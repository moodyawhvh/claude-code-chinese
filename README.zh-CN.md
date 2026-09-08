<div align="center">

# Claude Code 中文文档

[![原项目](https://img.shields.io/badge/原项目-anthropics--claude--code-blue?style=flat-square&logo=github)](https://github.com/anthropics/claude-code)
[![GitHub Stars](https://img.shields.io/github/stars/anthropics/claude-code?style=flat-square&label=原项目Stars)](https://github.com/anthropics/claude-code/stargazers)
[![微信联系](https://img.shields.io/badge/微信-uaycar-brightgreen?style=flat-square&logo=wechat)](#)

</div>

> 本文档是 [anthropics/claude-code](https://github.com/anthropics/claude-code) 官方 README 的中文翻译,仅供学习参考;如有出入请以英文原文与官方文档为准。

**代部署 / 定制服务 / 技术咨询 请添加微信:uaycar**

---

## 📖 项目简介

Claude Code 是一个常驻终端的智能编程(agentic coding)工具:它理解你的整个代码库,通过自然语言指令帮你更快地写代码——执行例行任务、解释复杂代码、处理 git 工作流,都可以交给它。你可以在终端和 IDE 中使用它,也可以在 GitHub 上 @claude 让它直接参与协作。

环境要求:Node.js 18+(npm 安装方式已弃用,推荐官方安装脚本)。

## ✨ 主要特性

- 🧠 **代码库全理解**:自动检索并理解项目结构与依赖,无需手工挑选上下文。
- 💬 **自然语言编程**:一句话描述需求,由它完成例行修改、重构与脚手架搭建。
- 🔍 **复杂代码讲解**:快速解释陌生模块、算法与调用链,显著降低阅读成本。
- 🔀 **git 工作流原生支持**:提交、分支、历史查询与冲突处理一气呵成。
- 🖥️ **多环境可用**:终端、IDE 皆可运行,并支持在 GitHub 上 @claude 协作。
- 🧩 **插件系统**:仓库内置多个官方插件,通过自定义命令与 agents 扩展功能。
- 🐞 **内置反馈通道**:使用 `/bug` 命令在工具内直接报告问题。
- 🔐 **明确的隐私保障**:限制敏感信息保留期限与访问范围,反馈数据不用于模型训练。

## 🚀 开始使用

> [!NOTE]
> 通过 npm 安装的方式已被弃用,请使用下述推荐安装方式。

更多安装选项、卸载步骤与故障排查,请见官方 setup 文档(https://code.claude.com/docs/en/setup)。

**1. 安装 Claude Code:**

macOS / Linux(推荐):

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

Homebrew(macOS / Linux):

```bash
brew install --cask claude-code
```

Windows(推荐):

```powershell
irm https://claude.ai/install.ps1 | iex
```

WinGet(Windows):

```powershell
winget install Anthropic.ClaudeCode
```

NPM(已弃用,仅作参考):

```bash
npm install -g @anthropic-ai/claude-code
```

**2. 进入项目目录并运行 `claude`:**

```bash
cd 你的项目路径
claude
```

启动后即可用自然语言与它协作,例如:让它梳理项目结构、修复一个报错、补写单元测试、解释一段看不懂的代码,或整理并生成本次改动的 git 提交。

## 🧩 插件

本仓库内置多个 Claude Code 插件,通过自定义命令与 agents 扩展功能。可用插件的详细说明见原仓库 `plugins/` 目录下的文档。

## 🐞 反馈 Bug

欢迎反馈问题:在 Claude Code 内直接使用 `/bug` 命令,或到原仓库提交 GitHub issue(https://github.com/anthropics/claude-code/issues)。

## 💬 加入 Discord

加入 Claude Developers Discord(https://anthropic.com/discord),与其他使用 Claude Code 的开发者交流经验、分享反馈、讨论项目。

## 🗄️ 数据收集、使用与保留

使用 Claude Code 时,官方会收集反馈数据,包括:使用数据(如代码建议被采纳或拒绝)、关联的会话数据,以及通过 `/bug` 命令提交的用户反馈。

### 数据如何使用

详见官方数据使用政策:https://code.claude.com/docs/en/data-usage

### 隐私保障

官方实施了多项保障措施,包括:限制敏感信息的保留期限、限制用户会话数据的访问范围,并明确禁止将用户反馈用于模型训练。完整细节请查阅商业服务条款(https://www.anthropic.com/legal/commercial-terms)与隐私政策(https://www.anthropic.com/legal/privacy)。

## 🔗 相关链接

- 官方文档:https://code.claude.com/docs/en/overview
- 安装与配置:https://code.claude.com/docs/en/setup
- 数据使用政策:https://code.claude.com/docs/en/data-usage
- 问题反馈:https://github.com/anthropics/claude-code/issues

---

> 本文档为 [anthropics/claude-code](https://github.com/anthropics/claude-code) 官方 README 的中文翻译版本,所有代码版权归原项目作者所有,遵循其原始许可证。

**代部署 / 定制服务 / 技术咨询 请添加微信:uaycar**

**如果觉得有用,请给原项目点个 Star!** ⭐
