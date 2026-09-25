<!-- 语言：中文（默认） | English mirror: examples/letmbootstrap-self/skills/README.en.md -->

# skills/ — 项目特定的 Agent 流程

本目录放 **项目特定** 的 Agent 技能 —— Agent 不即兴发挥的逐步流程。

letmbootstrap 技能本身（引导了这个项目的那个）住在仓库根 [`../../skills/letmbootstrap/SKILL.md`](../../skills/letmbootstrap/SKILL.md)。那是"把方法论装进目标项目"的技能。本目录是给 *这个项目* 装好后用的特定技能。

## 何时在这里加技能

发现你给 Agent 同样的多步指令超过两次时，加技能。如果指令又短又一次性，放对话里。如果又长、又重复、又可验证，写技能。

常见候选：

- `pre-push-checks` — push 前的窄测试选择
- `code-review` — 给定项目 PR 里检查什么
- `debug-flaky-test` — 隔离、静默、恢复
- `release-checklist` — 版本号、changelog、tag

## 技能格式

每个技能是一个目录里有 `SKILL.md`：

```
skills/<技能名>/
└── SKILL.md
```

`SKILL.md` 必须有 YAML frontmatter：

```markdown
---
name: <技能名>
description: 当 <具体触发> 时使用 — <一句话总结它做什么>.
---
```

`description:` 字段是最难写的部分。必须足够具体能匹配触发，但不能太窄以至于 Agent 从不调用。

正文是带可验证成功标准的逐步流程。无主观建议。

## 禁区

- 不要为一次性操作加技能 —— 用对话或 commit 信息。
- 不要加 `description:` 写"对代码审查有用"的技能 —— 太模糊永远不会触发。
- 不要写和父项目宪法（`AGENTS.md`）矛盾的技能。
- 不要给技能加破坏性操作（无 `rm`、`unlink`、`mv`、`rmdir`）。技能只做加法。

## 另见

- [`../single-task-contract.md`](../single-task-contract.md) — 每次给 Agent 派任务前填这个
- [`../AGENTS.md`](../AGENTS.md) — 项目宪法
- [`../../docs/methodology.md`](../../docs/methodology.md) — 方法论叙事
- [`../../skills/letmbootstrap/SKILL.md`](../../skills/letmbootstrap/SKILL.md) — 引导技能