<!-- 语言：中文（默认） | English mirror: examples/letmbootstrap-self/docs/decisions/0001-bootstrap-with-letmbootstrap.en.md -->

# 0001 — 用 letmbootstrap 引导

## Status（状态）

YYYY-MM-DD — implemented — letmbootstrap 现在是本项目的协作方法论。

## Context（背景）

默认的 Agent 行为在迭代项目时有三种失效模式：

1. **跑偏** — Agent 不知道已经决定过什么，所以重新争论已敲定的选择。
2. **Scope 蔓延** — Agent"贴心地"超出任务范围，动了无关代码。
3. **规则遗忘** — 约定只在聊天记录里，会话之间蒸发。

项目需要一种方式让项目知识持久化、可机读，这样 Agent 不会每次会话都重新推导上下文。

## Decision（决策）

采用 letmbootstrap 4 件套：

- 项目根下的 `AGENTS.md` 作为项目宪法
- `docs/decisions/` 作为只能追加的决策日志
- `skills/` 存放 Agent 不即兴发挥的逐步流程
- 单任务契约，每次给 Agent 派任务前填写

方法论在 [`docs/methodology.md`](../../../../docs/methodology.md) 描述。

## Consequences（影响）

- ✅ **得到：** 消除 ~70% 的"你忘了规则 X"重复提示。决策跨会话持久。新 Agent 读 4 个文件上手，不问用户。
- ❌ **付出：** 首次写 `AGENTS.md` ~15 分钟；每次变更维护 5 分钟。
- ⚠️ **工作流变化：** 每个非平凡任务现在从单任务契约开始（30 秒）。每个非平凡决策现在生成决策文件。

## Alternatives considered（考虑过的方案）

- **聊天里临时决策：** 拒。聊天记录不持久；新 Agent 读不到。物化上下文是核心目标。
- **不要方法论，保持现状：** 拒。3 种失效模式（跑偏、scope 蔓延、规则遗忘）会随时间复合。靠希望不会消失。
- **自研方法论：** 拒。自研方法论要么膨胀成框架（本模板刻意禁止），要么停留在小规模然后拙劣地重发明 letmbootstrap。用模板。
- **更重的方法论（完整 docs/architecture、ADR 工具等）：** 现在拒。4 件套是杠杆点。在 4 件套跑顺之前不要加 —— 见 [`docs/methodology.md`](../../../../docs/methodology.md) "升级路径"。

## Lifecycle（生命周期）

本文件在 `docs/decisions/`（implemented）。如果 letmbootstrap 永远被替换，本文件移到 `docs/decisions/rejected/` 并带一行"由 00XX 取代"的说明。