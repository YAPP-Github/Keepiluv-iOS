const { Client } = require("@notionhq/client");

const notion = new Client({ auth: process.env.NOTION_TOKEN });

function rt(text) {
    return [{ type: "text", text: { content: text } }];
}

function mdToNotionBlocks(md) {
    const lines = (md ?? "").replace(/\r\n/g, "\n").split("\n");

    const blocks = [];
    for (const raw of lines) {
        const line = raw.trim();
        if (!line) continue;

        // ### Heading 3 to 2
        const h3 = line.match(/^###\s+(.*)$/);
        if (h3) {
            blocks.push({
                object: "block",
                type: "heading_3",
                heading_2: { rich_text: rt(h3[1]) },
            });
            continue;
        }

        // - [ ] todo (unchecked)
        const todoUnchecked = line.match(/^- \[\s\]\s+(.*)$/);
        if (todoUnchecked) {
            blocks.push({
                object: "block",
                type: "to_do",
                to_do: { rich_text: rt(todoUnchecked[1]), checked: false },
            });
            continue;
        }

        // - [x] todo (checked)
        const todoChecked = line.match(/^- \[[xX]\]\s+(.*)$/);
        if (todoChecked) {
            blocks.push({
                object: "block",
                type: "to_do",
                to_do: { rich_text: rt(todoChecked[1]), checked: true },
            });
            continue;
        }

        // fallback paragraph
        blocks.push({
            object: "block",
            type: "paragraph",
            paragraph: { rich_text: rt(line) },
        });
    }
    return blocks;
}

async function main() {
    const dbId = process.env.NOTION_DATABASE_ID;
    const bodyMd = process.env.ISSUE_BODY_MD;
    const titleText = process.env.ISSUE_TITLE ?? "Untitled";
    const issueNumber = process.env.ISSUE_NUMBER ?? 0;
    const githubAssignee = process.env.GITHUB_ASSIGNEE || process.env.GITHUB_ISSUE_AUTHOR;

    const db = await notion.databases.retrieve({ database_id: dbId });
    const dataSourceId = db.data_sources?.[0]?.id;
    if (!dataSourceId) throw new Error("No data_sources in this database");

    const notionAssigneeIdMap = {
        "clxxrlove": process.env.NOTION_USER_ID_CLXXRLOVE,
        "jihun32": process.env.NOTION_USER_ID_JIHUN32,
    };

    const properties = {
        "작업 이름": { title: rt(`#${issueNumber} ${titleText}`) },
        "상태": { status: { name: "작업 중" } },
        "작업 유형": { multi_select: [{ name: "팀 작업" }] },
        "마감일": { date: { start: "2026-03-01" } },
    };

    const notionUserId = notionAssigneeIdMap[githubAssignee];
    if (notionUserId) {
        properties["담당자"] = { people: [{ id: notionUserId }] };
    }

    const children = mdToNotionBlocks(bodyMd);

    await notion.pages.create({
        parent: { data_source_id: dataSourceId },
        properties,
        children,
    });
}

main().catch((e) => {
    console.error(e);
    process.exit(1);
});