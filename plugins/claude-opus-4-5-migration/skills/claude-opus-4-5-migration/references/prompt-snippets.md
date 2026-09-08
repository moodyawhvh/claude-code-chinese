# Opus 4.5 提示词片段

> 🌐 本文档由 [anthropics/claude-code](https://github.com/anthropics/claude-code) 翻译,英文原版见原项目。

仅当用户明确要求或报告了具体问题时才应用这些片段。默认情况下,迁移只应更新模型字符串。

## 1. 工具误触发

**问题**:为减少旧模型漏触发而设计的提示词,可能导致 Opus 4.5 误触发。

**添加时机**:用户报告工具被过于频繁或不必要地调用。

**解决方案**:把强硬措辞换成正常表述。

| 修改前 | 修改后 |
|--------|-------|
| `CRITICAL: You MUST use this tool when...` | `Use this tool when...` |
| `ALWAYS call the search function before...` | `Call the search function before...` |
| `You are REQUIRED to...` | `You should...` |
| `NEVER skip this step` | `Don't skip this step` |

## 2. 防止过度工程

**问题**:Opus 4.5 可能创建多余的文件、添加不必要的抽象,或构建没人要求的灵活性。

**添加时机**:用户报告出现了多余文件、过度抽象或未被要求的功能。

**添加到系统提示词的片段**:

```
- Avoid over-engineering. Only make changes that are directly requested or clearly necessary. Keep solutions simple and focused.
- Don't add features, refactor code, or make "improvements" beyond what was asked. A bug fix doesn't need surrounding code cleaned up. A simple feature doesn't need extra configurability.
- Don't add error handling, fallbacks, or validation for scenarios that can't happen. Trust internal code and framework guarantees. Only validate at system boundaries (user input, external APIs). Don't use backwards-compatibility shims when you can just change the code.
- Don't create helpers, utilities, or abstractions for one-time operations. Don't design for hypothetical future requirements. The right amount of complexity is the minimum needed for the current task. Reuse existing abstractions where possible and follow the DRY principle.
```

## 3. 代码探索

**问题**:Opus 4.5 可能不读代码就提出方案,或对未读文件做出假设。

**添加时机**:用户报告模型在没有查看相关代码的情况下就提出修复方案。

**添加到系统提示词的片段**:

```
ALWAYS read and understand relevant files before proposing code edits. Do not speculate about code you have not inspected. If the user references a specific file/path, you MUST open and inspect it before explaining or proposing fixes. Be rigorous and persistent in searching code for key facts. Thoroughly review the style, conventions, and abstractions of the codebase before implementing new features or abstractions.
```

## 4. 前端设计质量

**问题**:默认的前端产出可能显得千篇一律("AI slop" 审美)。

**添加时机**:用户要求提升前端设计质量,或报告产出看起来千篇一律。

**添加到系统提示词的片段**:

```xml
<frontend_aesthetics>
You tend to converge toward generic, "on distribution" outputs. In frontend design, this creates what users call the "AI slop" aesthetic. Avoid this: make creative, distinctive frontends that surprise and delight.

Focus on:
- Typography: Choose fonts that are beautiful, unique, and interesting. Avoid generic fonts like Arial and Inter; opt instead for distinctive choices that elevate the frontend's aesthetics.
- Color & Theme: Commit to a cohesive aesthetic. Use CSS variables for consistency. Dominant colors with sharp accents outperform timid, evenly-distributed palettes. Draw from IDE themes and cultural aesthetics for inspiration.
- Motion: Use animations for effects and micro-interactions. Prioritize CSS-only solutions for HTML. Use Motion library for React when available. Focus on high-impact moments: one well-orchestrated page load with staggered reveals (animation-delay) creates more delight than scattered micro-interactions.
- Backgrounds: Create atmosphere and depth rather than defaulting to solid colors. Layer CSS gradients, use geometric patterns, or add contextual effects that match the overall aesthetic.

Avoid generic AI-generated aesthetics:
- Overused font families (Inter, Roboto, Arial, system fonts)
- Clichéd color schemes (particularly purple gradients on white backgrounds)
- Predictable layouts and component patterns
- Cookie-cutter design that lacks context-specific character

Interpret creatively and make unexpected choices that feel genuinely designed for the context. Vary between light and dark themes, different fonts, different aesthetics. You still tend to converge on common choices (Space Grotesk, for example) across generations. Avoid this: it is critical that you think outside the box!
</frontend_aesthetics>
```

## 5. "Think" 一词敏感性

**问题**:在未启用扩展思考(默认状态)时,Opus 4.5 对 "think" 一词及其变体格外敏感。

扩展思考默认不启用。只有 API 请求包含 `thinking` 参数时才启用:
```json
"thinking": {
    "type": "enabled",
    "budget_tokens": 10000
}
```

**应用时机**:用户在未启用扩展思考的情况下(请求中没有 `thinking` 参数)报告与 "thinking" 相关的问题。

**解决方案**:把 "think" 替换为其他词。

| 修改前 | 修改后 |
|--------|-------|
| `think about` | `consider` |
| `think through` | `evaluate` |
| `I think` | `I believe` |
| `think carefully` | `consider carefully` |
| `thinking` | `reasoning` / `considering` |

## 使用准则

1. **有意识地整合** - 不要简单追加片段,要把它们织入现有提示词结构
2. **使用 XML 标签** - 用描述性标签(如 `<coding_guidelines>`、`<tool_behavior>`)包裹新增内容,与现有提示词结构匹配或互补
3. **匹配提示词风格** - 提示词简洁就精简片段;提示词详细就保留完整细节
4. **位置合理** - 编码片段放在其他编码指令附近,工具指引放在工具定义附近,以此类推
5. **保留现有内容** - 插入片段时不移除任何功能性内容
6. **总结变更** - 迁移完成后,列出所有模型字符串更新和提示词修改
