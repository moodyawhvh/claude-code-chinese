---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: 创建一个 git 提交
---

> 🌐 本文档由 [anthropics/claude-code](https://github.com/anthropics/claude-code) 翻译,英文原版见原项目。

## 上下文

- 当前 git 状态:!`git status`
- 当前 git diff(暂存与未暂存的变更):!`git diff HEAD`
- 当前分支:!`git branch --show-current`
- 最近提交:!`git log --oneline -10`

## 你的任务

根据上述变更,创建一个 git 提交。

你有能力在单次响应中调用多个工具。在一条消息内完成暂存和提交。不要使用任何其他工具,也不要做任何其他事情。除了这些工具调用之外,不要发送任何其他文本或消息。
