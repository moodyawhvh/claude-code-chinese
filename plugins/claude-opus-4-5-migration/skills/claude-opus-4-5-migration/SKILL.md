---
name: claude-opus-4-5-migration
description: 将提示词和代码从 Claude Sonnet 4.0、Sonnet 4.5 或 Opus 4.1 迁移到 Opus 4.5。当用户想把代码库、提示词或 API 调用更新为 Opus 4.5 时使用。处理模型字符串更新,并针对 Opus 4.5 的已知行为差异调整提示词。不迁移 Haiku 4.5。
---

> 🌐 本文档由 [anthropics/claude-code](https://github.com/anthropics/claude-code) 翻译,英文原版见原项目。

# Opus 4.5 迁移指南

一次性完成从 Sonnet 4.0、Sonnet 4.5 或 Opus 4.1 到 Opus 4.5 的迁移。

## 迁移流程

1. 在代码库中搜索模型字符串和 API 调用
2. 将模型字符串更新为 Opus 4.5(见下文各平台的模型字符串)
3. 移除不受支持的 beta 头
4. 添加 effort 参数并设为 `"high"`(见 `references/effort.md`)
5. 总结所有已做的修改
6. 告诉用户:"如果你在使用 Opus 4.5 时遇到任何问题,告诉我,我可以帮你调整提示词。"

## 模型字符串更新

先判断代码库使用的平台,然后相应替换模型字符串。

### 不受支持的 Beta 头

如存在 `context-1m-2025-08-07` beta 头,移除它——Opus 4.5 尚不支持。并留下注释说明:

```python
# Note: 1M context beta (context-1m-2025-08-07) not yet supported with Opus 4.5
```

### 目标模型字符串(Opus 4.5)

| 平台 | Opus 4.5 模型字符串 |
|----------|----------------------|
| Anthropic API (1P) | `claude-opus-4-5-20251101` |
| AWS Bedrock | `anthropic.claude-opus-4-5-20251101-v1:0` |
| Google Vertex AI | `claude-opus-4-5@20251101` |
| Azure AI Foundry | `claude-opus-4-5-20251101` |

### 需要替换的源模型字符串

| 源模型 | Anthropic API (1P) | AWS Bedrock | Google Vertex AI |
|--------------|-------------------|-------------|------------------|
| Sonnet 4.0 | `claude-sonnet-4-20250514` | `anthropic.claude-sonnet-4-20250514-v1:0` | `claude-sonnet-4@20250514` |
| Sonnet 4.5 | `claude-sonnet-4-5-20250929` | `anthropic.claude-sonnet-4-5-20250929-v1:0` | `claude-sonnet-4-5@20250929` |
| Opus 4.1 | `claude-opus-4-1-20250422` | `anthropic.claude-opus-4-1-20250422-v1:0` | `claude-opus-4-1@20250422` |

**不要迁移**:任何 Haiku 模型(例如 `claude-haiku-4-5-20251001`)。

## 提示词调整

Opus 4.5 与之前的模型存在已知的行为差异。**仅当用户明确要求或报告了具体问题时才应用这些修复。**默认只更新模型字符串。

**整合原则**:添加片段时,不要直接追加到提示词末尾,要有意识地融入:
- 使用 XML 标签(如 `<code_guidelines>`、`<tool_usage>`)来组织新增内容
- 匹配现有提示词的风格和结构
- 把片段放在逻辑合理的位置(例如编码准则放在其他编码指令附近)
- 如果提示词已经使用了 XML 标签,把新内容放进合适的既有标签内,或创建风格一致的新标签

### 1. 工具误触发

Opus 4.5 对系统提示词的响应更敏感。以前用来防止漏触发的强硬措辞,现在可能引发误触发。

**应用条件**:用户报告工具被过于频繁或不必要地调用。

**查找并软化**:
- `CRITICAL:` → 移除或软化
- `You MUST...` → `You should...`
- `ALWAYS do X` → `Do X`
- `NEVER skip...` → `Don't skip...`
- `REQUIRED` → 移除或软化

只处理与工具触发相关的指令,其他地方使用的强调语气保持原样。

### 2. 防止过度工程

Opus 4.5 倾向于创建多余的文件、添加不必要的抽象,或构建没人要求的灵活性。

**应用条件**:用户报告出现了多余文件、过度抽象或未被要求的功能。添加 `references/prompt-snippets.md` 中的片段。

### 3. 代码探索

Opus 4.5 在探索代码方面可能过于保守,不读文件就提出方案。

**应用条件**:用户报告模型在没有查看相关代码的情况下就提出修复方案。添加 `references/prompt-snippets.md` 中的片段。

### 4. 前端设计

**应用条件**:用户要求提升前端设计质量,或报告产出看起来千篇一律。

添加 `references/prompt-snippets.md` 中的前端美学片段。

### 5. "Think" 一词敏感性

在未启用扩展思考(默认状态)时,Opus 4.5 对 "think" 一词及其变体格外敏感。只有 API 请求包含 `thinking` 参数时才会启用扩展思考。

**应用条件**:用户在未启用扩展思考的情况下(请求中没有 `thinking` 参数)报告与 "thinking" 相关的问题。

把 "think" 替换为 "consider"、"believe"、"evaluate" 等替代词。

## 参考

各片段的完整文本见 `references/prompt-snippets.md`。

effort 参数的配置见 `references/effort.md`(仅在用户提出要求时使用)。
