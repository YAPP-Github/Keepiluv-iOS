const SLACK_USER_MAP = {
	clxxrlove: "U0AL614S4PL",
	jihun32: "U0ALJKWF5DX"
};

export default {
	async fetch(request, env) {
		const url = new URL(request.url);

		if (request.method === "GET" && url.pathname === "/") {
			return json({
				ok: true,
				message: "GitHub -> Slack notifier is running",
			});
		}

		if (request.method !== "POST" || url.pathname !== "/github") {
			return json({ ok: false, error: "Not found" }, 404);
		}

		try {
			const rawBody = await request.text();
			const signature = request.headers.get("x-hub-signature-256");

			if (env.GITHUB_WEBHOOK_SECRET) {
				const isValid = await verifyGitHubSignature(
					rawBody,
					signature,
					env.GITHUB_WEBHOOK_SECRET
				);

				if (!isValid) {
					return json({ ok: false, error: "Invalid GitHub webhook signature" }, 401);
				}
			}

			const event = request.headers.get("x-github-event");
			const deliveryId = request.headers.get("x-github-delivery");

			let body;
			try {
				body = rawBody ? JSON.parse(rawBody) : null;
			} catch (error) {
				return json({ ok: false, error: "Invalid JSON body" }, 400);
			}

			console.log("=== GitHub webhook received ===");
			console.log("event:", event);
			console.log("delivery:", deliveryId);
			console.log(JSON.stringify(body, null, 2));

			const message = buildSlackMessage(event, body, env);

			if (!message.shouldSend) {
				return json({
					ok: true,
					skipped: true,
					reason: message.reason,
				});
			}

			await postToSlack(env.SLACK_WEBHOOK_URL, message.payload);

			return json({
				ok: true,
				skipped: false,
				reason: message.reason,
			});
		} catch (error) {
			console.error("Unhandled error:", error);
			return json(
				{
					ok: false,
					error: error instanceof Error ? error.message : "Internal Server Error",
				},
				500
			);
		}
	},
};

function toSlackMention(value) {
	if (!value) return null;
	const slackUserId = SLACK_USER_MAP[value];
	return slackUserId ? `<@${slackUserId}>` : `@${value}`;
}

function buildSlackMessage(event, body, env) {
	if (event === "pull_request") {
		return buildPullRequestMessage(body, env);
	}

	if (event === "workflow_run") {
		return buildWorkflowRunMessage(body, env);
	}

	return {
		shouldSend: false,
		reason: `Unsupported event: ${event}`,
	};
}

function buildPullRequestMessage(body, env) {
	const action = body?.action;
	if (action !== "review_requested") {
		return {
			shouldSend: false,
			reason: `Ignored pull_request action: ${action}`,
		};
	}

	const pr = body?.pull_request;
	const repo = body?.repository;

	if (!pr || !repo) {
		return {
			shouldSend: false,
			reason: "Missing pull_request payload fields",
		};
	}

	const requestedReviewerLogin = body?.requested_reviewer?.login || null;
	const requestedReviewerName = body?.requested_reviewer?.name || null;
	const requestedTeam = body?.requested_team?.name || null;

	let reviewerText = null;

	if (requestedReviewerLogin || requestedReviewerName) {
		reviewerText =
			toSlackMention(requestedReviewerLogin) ||
			toSlackMention(requestedReviewerName) ||
			`@${requestedReviewerLogin || requestedReviewerName}`;
	} else if (requestedTeam) {
		reviewerText = `@${requestedTeam}`;
	} else {
		reviewerText = "@unknown";
	}

	return {
		shouldSend: true,
		reason: "PR reviewer requested",
		payload: {
			text: `${reviewerText} 리뷰 요청이 왔어요! :eyes: #${pr.number}`,
			blocks: [
				{
					type: "section",
					text: {
						type: "mrkdwn",
						text:
							`${reviewerText} 리뷰 요청이 왔어요! :eyes: *#${pr.number}*\n` +
							`> <${pr.html_url}|${escapeSlackText(pr.title)}>`,
					},
				},
			],
		},
	};
}

function buildWorkflowRunMessage(body, env) {
	const action = body?.action;
	const workflowRun = body?.workflow_run;
	const repo = body?.repository;

	if (action !== "completed") {
		return {
			shouldSend: false,
			reason: `Ignored workflow_run action: ${action}`,
		};
	}

	if (!workflowRun || !repo) {
		return {
			shouldSend: false,
			reason: "Missing workflow_run payload fields",
		};
	}

	if (workflowRun.conclusion !== "failure") {
		return {
			shouldSend: false,
			reason: `Workflow conclusion is not failure: ${workflowRun.conclusion}`,
		};
	}

	const actorLogin = workflowRun.actor?.login || null;
	const actorText = toSlackMention(actorLogin) || `@${actorLogin || "unknown"}`;

	return {
		shouldSend: true,
		reason: "Workflow run failed",
		payload: {
			text: "GitHub Actions 실패",
			blocks: [
				{
					type: "section",
					text: {
						type: "mrkdwn",
						text:
							`*GitHub Actions 실패*\n` +
							`${workflowRun.name} 워크플로우가 실패했습니다.\n` +
							`- 브랜치: \`${workflowRun.head_branch || "unknown"}\`\n` +
							`- 트리거 사용자: ${actorText}\n` +
							`- 상태: \`${workflowRun.conclusion}\`\n` +
							`- 자세히: <${workflowRun.html_url}|GitHub에서 보기>`,
					},
				},
			],
		},
	};
}

async function postToSlack(webhookUrl, payload) {
	if (!webhookUrl) {
		throw new Error("Missing SLACK_WEBHOOK_URL");
	}

	const response = await fetch(webhookUrl, {
		method: "POST",
		headers: {
			"Content-Type": "application/json",
		},
		body: JSON.stringify(payload),
	});

	const text = await response.text();

	if (!response.ok) {
		console.error("Slack webhook error", {
			status: response.status,
			body: text,
		});
		throw new Error(`Slack webhook failed with ${response.status}`);
	}

	return text;
}

async function verifyGitHubSignature(rawBody, signatureHeader, secret) {
	if (!signatureHeader || !secret) return false;
	if (!signatureHeader.startsWith("sha256=")) return false;

	const key = await crypto.subtle.importKey(
		"raw",
		new TextEncoder().encode(secret),
		{ name: "HMAC", hash: "SHA-256" },
		false,
		["sign"]
	);

	const mac = await crypto.subtle.sign(
		"HMAC",
		key,
		new TextEncoder().encode(rawBody)
	);

	const expected = "sha256=" + [...new Uint8Array(mac)]
		.map((b) => b.toString(16).padStart(2, "0"))
		.join("");

	return timingSafeEqual(expected, signatureHeader);
}

function escapeSlackText(text) {
	return String(text ?? "")
		.replace(/&/g, "&amp;")
		.replace(/</g, "&lt;")
		.replace(/>/g, "&gt;")
		.replace(/\|/g, "｜");
}

function timingSafeEqual(a, b) {
	if (a.length !== b.length) return false;
	let out = 0;
	for (let i = 0; i < a.length; i++) {
		out |= a.charCodeAt(i) ^ b.charCodeAt(i);
	}
	return out === 0;
}

function json(data, status = 200) {
	return new Response(JSON.stringify(data, null, 2), {
		status,
		headers: {
			"content-type": "application/json; charset=utf-8",
		},
	});
}