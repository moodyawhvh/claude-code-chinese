---
allowed-tools: Bash(git checkout --branch:*), Bash(git add:*), Bash(git status:*), Bash(git push:*), Bash(git commit:*), Bash(gh pr create:*)
description: 提交、推送并创建 PR
---

> 🌐 本文档由 [anthropics/claude-code](https://github.com/anthropics/claude-code) 翻译,英文原版见原项目。

## 上下文

- 当前 git 状态:!`git status`
- 当前 git diff(暂存与未暂存的变更):!`git diff HEAD`
- 当前分支:!`git branch --show-current`

## 你的任务

根据上述变更:

1. 如果当前在 main 分支上,先创建一个新分支
2. 用合适的提交信息创建一个提交
3. 把分支推送到 origin
4. 使用 `gh pr create` 创建拉取请求
5. 你有能力在单次响应中调用多个工具。你必须把上述所有步骤放在一条消息里完成。不要使用任何其他工具,也不要做任何其他事情。除了这些工具调用之外,不要发送任何其他文本或消息。
