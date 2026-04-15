const ASSIGNEE_MAP = {
	정지용: "clxxrlove",
	정지훈: "jihun32",
};

const TITLE_PREFIX_ORDER = [
	"feat",
	"fix",
	"docs",
	"chore",
	"style",
	"test",
	"refactor",
];

const ALLOWED_GITHUB_LABELS = new Set(TITLE_PREFIX_ORDER);

export default {
	async fetch(request, env) {
		const url = new URL(request.url);

		try {
			if (request.method === "GET" && url.pathname === "/") {
				return json({
					ok: true,
					message: "Linear webhook worker is running",
				});
			}

			if (request.method === "POST" && url.pathname === "/linear") {
				const rawBody = await request.text();

				if (env.LINEAR_WEBHOOK_SECRET) {
					const signature = request.headers.get("linear-signature");
					const isValid = await verifyLinearSignature(
						rawBody,
						signature,
						env.LINEAR_WEBHOOK_SECRET
					);

					if (!isValid) {
						return json({ ok: false, error: "Invalid webhook signature" }, 401);
					}
				}

				let body;
				try {
					body = rawBody ? JSON.parse(rawBody) : null;
				} catch (error) {
					console.error("Failed to parse JSON body:", error);
					return json({ ok: false, error: "Invalid JSON body" }, 400);
				}

				console.log("=== Linear webhook received ===");
				console.log(JSON.stringify(body, null, 2));

				const parsed = buildGithubSyncPayload(body);

				console.log("=== Parsed result ===");
				console.log(JSON.stringify(parsed, null, 2));

				if (!parsed.shouldProcess) {
					return json({ ok: true, skipped: true, result: parsed });
				}

				const githubResult = await syncToGitHub(parsed, env);

				return json({
					ok: true,
					skipped: false,
					parsed,
					githubResult,
				});
			}

			return json({ ok: false, error: "Not found" }, 404);
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

function buildGithubSyncPayload(body) {
	const action = body?.action ?? null;
	const type = body?.type ?? null;
	const data = body?.data ?? {};

	if (type !== "Issue") {
		return skip("Not an Issue webhook");
	}

	if (action !== "create" && action !== "update") {
		return skip("Only create/update actions are processed", {
			action,
			type,
		});
	}

	const rawLabels = Array.isArray(data.labels) ? data.labels : [];
	const labelNames = rawLabels
		.map((label) => label?.name)
		.filter(Boolean)
		.map((name) => String(name).trim().toLowerCase());

	if (!labelNames.includes("ios")) {
		return skip("No ios label", {
			action,
			type,
			labelNames,
			identifier: data?.identifier ?? null,
		});
	}

	const allowedGithubLabels = extractAllowedGithubLabels(labelNames);
	const githubAssignee = mapAssignee(data?.assignee?.name ?? null);

	if (action === "create") {
		return {
			shouldProcess: true,
			reason: "Matched ios issue create event",
			mode: "create_issue",
			linear: {
				action,
				id: data?.id ?? null,
				identifier: data?.identifier ?? null,
				url: data?.url ?? body?.url ?? null,
				title: data?.title ?? "",
				description: data?.description ?? "",
				assigneeName: data?.assignee?.name ?? null,
				rawLabels: labelNames,
			},
			github: {
				title: buildGithubTitle(
					data?.title ?? "",
					allowedGithubLabels,
					data?.identifier ?? null
				),
				body: buildGithubBody({
					linearIdentifier: data?.identifier ?? null,
					linearUrl: data?.url ?? body?.url ?? null,
					description: data?.description ?? "",
				}),
				labels: allowedGithubLabels,
				assignee: githubAssignee,
			},
		};
	}

	const updatedFrom = body?.updatedFrom ?? {};

	if (action === "update") {
		const assigneeChanged =
			Object.prototype.hasOwnProperty.call(updatedFrom, "assigneeId") ||
			Object.prototype.hasOwnProperty.call(updatedFrom, "assignee");

		if (!assigneeChanged) {
			return skip("Update ignored because assignee did not change", {
				identifier: data?.identifier ?? null,
				updatedFields: Object.keys(updatedFrom),
			});
		}
	}

	return {
		shouldProcess: true,
		reason: "Matched ios issue update event",
		mode: "update_issue_metadata",
		policy: {
			updateLabels: false,
			updateTitle: false,
			updateBody: false,
			updateAssignee: true,
		},
		linear: {
			action,
			id: data?.id ?? null,
			identifier: data?.identifier ?? null,
			url: data?.url ?? body?.url ?? null,
			title: data?.title ?? "",
			description: data?.description ?? "",
			assigneeName: data?.assignee?.name ?? null,
			rawLabels: labelNames,
		},
		github: {
			assignee: githubAssignee,
		},
	};
}

async function syncToGitHub(parsed, env) {
	const owner = env.GITHUB_OWNER || "Keepiluv";
	const repo = env.GITHUB_REPO || "Keepiluv-iOS";

	if (!env.GITHUB_TOKEN) {
		throw new Error("Missing GITHUB_TOKEN");
	}

	if (parsed.mode === "create_issue") {
		const existing = await findExistingIssueByLinearIdentifier(
			env,
			owner,
			repo,
			parsed.linear.identifier
		);

		if (existing) {
			return {
				action: "noop_existing_issue",
				issue_number: existing.number,
				html_url: existing.html_url,
			};
		}

		const created = await githubRequest(env, "POST", `/repos/${owner}/${repo}/issues`, {
			title: parsed.github.title,
			body: parsed.github.body,
		});

		if (parsed.github.labels.length > 0) {
			await githubRequest(
				env,
				"POST",
				`/repos/${owner}/${repo}/issues/${created.number}/labels`,
				{
					labels: parsed.github.labels,
				}
			);
		}

		if (parsed.github.assignee) {
			const canAssign = await canAssignUser(env, owner, repo, parsed.github.assignee);

			if (canAssign) {
				await githubRequest(
					env,
					"POST",
					`/repos/${owner}/${repo}/issues/${created.number}/assignees`,
					{
						assignees: [parsed.github.assignee],
					}
				);
			}
		}

		return {
			action: "created_issue",
			issue_number: created.number,
			html_url: created.html_url,
		};
	}

	if (parsed.mode === "update_issue_metadata") {
		const existing = await findExistingIssueByLinearIdentifier(
			env,
			owner,
			repo,
			parsed.linear.identifier
		);

		if (!existing) {
			return {
				action: "skip_missing_issue",
				reason: "No matching GitHub issue found for update",
				linearIdentifier: parsed.linear.identifier,
			};
		}

		await syncAssignee(env, owner, repo, existing.number, parsed.github.assignee);

		return {
			action: "updated_issue_assignee",
			issue_number: existing.number,
			html_url: existing.html_url,
			assignee: parsed.github.assignee,
		};
	}

	throw new Error(`Unsupported mode: ${parsed.mode}`);
}

async function findExistingIssueByLinearIdentifier(env, owner, repo, identifier) {
	if (!identifier) return null;

	const issues = await githubRequest(
		env,
		"GET",
		`/repos/${owner}/${repo}/issues?state=all&per_page=100`
	);

	const marker = buildLinearMarker(identifier);

	return (
		issues.find((issue) => {
			if (issue.pull_request) return false;
			return (
				issue.body?.includes(marker) ||
				issue.title?.includes(` - [${identifier}]`)
			);
		}) || null
	);
}

async function syncAssignee(env, owner, repo, issueNumber, desiredAssignee) {
	const currentIssue = await githubRequest(
		env,
		"GET",
		`/repos/${owner}/${repo}/issues/${issueNumber}`
	);

	const currentAssignees = Array.isArray(currentIssue.assignees)
		? currentIssue.assignees.map((user) => user.login)
		: [];

	if (currentAssignees.length > 0) {
		await githubRequest(
			env,
			"DELETE",
			`/repos/${owner}/${repo}/issues/${issueNumber}/assignees`,
			{ assignees: currentAssignees }
		);
	}

	if (!desiredAssignee) {
		return;
	}

	const canAssign = await canAssignUser(env, owner, repo, desiredAssignee);
	if (!canAssign) {
		console.warn(`User cannot be assigned: ${desiredAssignee}`);
		return;
	}

	await githubRequest(
		env,
		"POST",
		`/repos/${owner}/${repo}/issues/${issueNumber}/assignees`,
		{ assignees: [desiredAssignee] }
	);
}

async function canAssignUser(env, owner, repo, assignee) {
	const response = await fetch(
		`https://api.github.com/repos/${owner}/${repo}/assignees/${encodeURIComponent(
			assignee
		)}`,
		{
			method: "GET",
			headers: githubHeaders(env),
		}
	);

	return response.status === 204;
}

function extractAllowedGithubLabels(labelNames) {
	return labelNames.filter((label) => ALLOWED_GITHUB_LABELS.has(label));
}

function mapAssignee(name) {
	if (!name) return null;
	return ASSIGNEE_MAP[name] ?? null;
}

function buildGithubTitle(linearTitle, labelNames, identifier) {
	const baseTitle = stripExistingPrefix(String(linearTitle ?? "").trim());
	const prefix = pickTitlePrefix(labelNames);

	let finalTitle = baseTitle || "Untitled";

	if (identifier) {
		finalTitle = `${finalTitle} - [${identifier}]`;
	}

	return prefix ? `${prefix}: ${finalTitle}` : finalTitle;
}

function buildGithubBody({ linearIdentifier, linearUrl, description }) {
	const parts = [];

	if (description?.trim()) {
		parts.push(description.trim());
	}

	parts.push("---");
	parts.push(`Linear: ${linearUrl || "N/A"}`);
	if (linearIdentifier) {
		parts.push(buildLinearMarker(linearIdentifier));
	}

	return parts.join("\n\n");
}

function buildLinearMarker(identifier) {
	return `<!-- linear-id:${identifier} -->`;
}

function pickTitlePrefix(labelNames) {
	return TITLE_PREFIX_ORDER.find((label) => labelNames.includes(label)) ?? null;
}

function stripExistingPrefix(title) {
	return title
		.replace(/^(feat|fix|docs|chore|style|test|refactor):\s*/i, "")
		.replace(/^\[ios\]\s*/i, "")
		.replace(/^\[qa\]\s*/i, "")
		.trim();
}

function skip(reason, debug = {}) {
	return {
		shouldProcess: false,
		reason,
		debug,
	};
}

async function githubRequest(env, method, pathWithQuery, body) {
	const response = await fetch(`https://api.github.com${pathWithQuery}`, {
		method,
		headers: githubHeaders(env, body ? { "Content-Type": "application/json" } : {}),
		body: body ? JSON.stringify(body) : undefined,
	});

	if (response.status === 204) return null;

	const text = await response.text();
	const data = text ? safeJsonParse(text) : null;

	if (!response.ok) {
		console.error("GitHub API error", {
			method,
			pathWithQuery,
			status: response.status,
			data,
		});
		throw new Error(
			`GitHub API ${method} ${pathWithQuery} failed with ${response.status}`
		);
	}

	return data;
}

function githubHeaders(env, extra = {}) {
	return {
		Accept: "application/vnd.github+json",
		Authorization: `Bearer ${env.GITHUB_TOKEN}`,
		"X-GitHub-Api-Version": "2022-11-28",
		"User-Agent": "linear-webhook-relay",
		...extra,
	};
}

function safeJsonParse(text) {
	try {
		return JSON.parse(text);
	} catch {
		return { raw: text };
	}
}

async function verifyLinearSignature(rawBody, signature, secret) {
	if (!signature || !secret) return false;

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

	const expected = [...new Uint8Array(mac)]
		.map((b) => b.toString(16).padStart(2, "0"))
		.join("");

	return timingSafeEqual(expected, signature);
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