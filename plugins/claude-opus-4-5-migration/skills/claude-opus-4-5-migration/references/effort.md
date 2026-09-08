# Effort 参数(Beta)

> 🌐 本文档由 [anthropics/claude-code](https://github.com/anthropics/claude-code) 翻译,英文原版见原项目。

**迁移时添加 effort 并设为 `"high"`。**这是在 Opus 4.5 上获得最佳性能的默认配置。

## 概述

Effort 控制 Claude 消耗 token 的积极程度。它影响所有 token:思考、文本回复和函数调用。

| Effort | 适用场景 |
|--------|----------|
| `high` | 最佳性能、深度推理(默认) |
| `medium` | 成本/延迟与性能之间取平衡 |
| `low` | 简单、高并发量的查询;显著节省 token |

## 实现方式

API 调用需要携带 beta 标志 `effort-2025-11-24`。

**Python SDK:**
```python
response = client.messages.create(
    model="claude-opus-4-5-20251101",
    max_tokens=1024,
    betas=["effort-2025-11-24"],
    output_config={
        "effort": "high"  # or "medium" or "low"
    },
    messages=[...]
)
```

**TypeScript SDK:**
```typescript
const response = await client.messages.create({
  model: "claude-opus-4-5-20251101",
  max_tokens: 1024,
  betas: ["effort-2025-11-24"],
  output_config: {
    effort: "high"  // or "medium" or "low"
  },
  messages: [...]
});
```

**原生 API:**
```json
{
  "model": "claude-opus-4-5-20251101",
  "max_tokens": 1024,
  "anthropic-beta": "effort-2025-11-24",
  "output_config": {
    "effort": "high"
  },
  "messages": [...]
}
```

## Effort 与思考预算的关系

Effort 与思考预算相互独立:

- 高 effort + 不思考 = 更多 token,但没有思考 token
- 高 effort + 32k 思考预算 = 更多 token,但思考上限仍为 32k

## 建议

1. 先确定 effort 等级,再设置思考预算
2. 追求最佳性能:高 effort + 高思考预算
3. 优化成本/延迟:中等 effort
4. 简单的高并发查询:低 effort
