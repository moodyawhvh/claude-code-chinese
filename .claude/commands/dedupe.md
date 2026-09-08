---
allowed-tools: Bash(./scripts/gh.sh:*), Bash(./scripts/comment-on-duplicates.sh:*)
description: 查找重复的 GitHub issue
---

> 🌐 本文档由 [anthropics/claude-code](https://github.com/anthropics/claude-code) 翻译,英文原版见原项目。

为一个给定的 GitHub issue 找出最多 3 个可能的重复 issue。

为此,请严格按以下步骤执行:

1. 使用一个 agent 检查该 GitHub issue:(a) 是否已关闭,(b) 是否无需去重(例如它是没有具体方案的宽泛产品反馈,或者是正面反馈),或者 (c) 是否已经有你之前发布的重复标记评论。如果是,则不继续。
2. 使用一个 agent 查看该 GitHub issue,并让 agent 返回该 issue 的摘要。
3. 然后,启动 5 个并行 agent,使用第 1 步得到的摘要,以多样的关键词和搜索方式在 GitHub 上搜索该 issue 的重复项。
4. 接下来,把第 1 步和第 2 步的结果交给另一个 agent,让它过滤掉误报——那些很可能并不是原始 issue 真正重复项的结果。如果没有剩余的重复项,则不继续。
5. 最后,使用评论脚本发布重复项:
   ```
   ./scripts/comment-on-duplicates.sh --potential-duplicates <dup1> <dup2> <dup3>
   ```

注意事项(务必同样告知你的 agent):

- 与 GitHub 交互一律使用 `./scripts/gh.sh`,不要用网页抓取或原生 `gh`。示例:
  - `./scripts/gh.sh issue view 123` — 查看 issue
  - `./scripts/gh.sh issue view 123 --comments` — 查看带评论的 issue
  - `./scripts/gh.sh issue list --state open --limit 20` — 列出 issue
  - `./scripts/gh.sh search issues "query" --limit 10` — 搜索 issue
- 除 `./scripts/gh.sh` 和评论脚本外,不要使用其他工具(例如不要用其他 MCP 服务器、文件编辑等)。
- 先建一个待办清单。
