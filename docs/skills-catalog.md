<!-- 语言：中文（默认） | English mirror: docs/skills-catalog.en.md -->

# 技能目录

仓库当前发一个技能。本页记录那个技能，并解释怎么写更多。

## 已发布的技能

### `letmbootstrap` — 在目标项目里引导方法论

**触发短语：** `letmbootstrap init`、`bootstrap letmbootstrap`、`init methodology`、`搭三件套`、`初始化方法论`、`letmbootstrap 初始化`。

**作用：** 在目标项目里安装 `AGENTS.md` + `docs/decisions/` + `skills/` 骨架，按 5 个问题定制，写之前都要明确同意。

**何时调用：** 启动新项目，或改造现有项目且还没有 4 件套防跑偏骨架时。

**何时不调用：** 目标已经有 AGENTS.md 和 docs/decisions/。或者用户想把 letmbootstrap 技能本身装到别的 Agent 平台 —— 那是 `INSTALL.md`，不是这个技能。

**文件：** [`skills/letmbootstrap/SKILL.md`](../skills/letmbootstrap/SKILL.md)

**保证：**

- 永不 `rm`、`unlink`、`mv`，未经逐文件明确同意也不覆盖
- 冲突跳过
- 幂等
- 只读的 Step 1（预检）

**要拒绝的反模式：**

- "重置这个项目" — 技能没有重置路径
- "强制覆盖" — 拒绝，必须逐文件
- "卸载" — 拒绝，见决策 0001

---

## 怎么写新技能

新技能是 `skills/<技能名>/SKILL.md` 目录，带 YAML frontmatter 和逐步流程。

### Frontmatter 契约

```markdown
---
name: <技能名>
description: 当 <具体触发> 时使用 — <一句话总结>.
---
```

`description:` 字段是 **最重要** 的部分。它决定 Agent 是否会调用这个技能。

| 好的 description | 反例 |
|---|---|
| `当 push 前跑 pre-push 检查时使用 — 跑覆盖当前 diff 的窄测试套件和 linter。` | `对代码审查有用。` |
| `当用户说 "letmbootstrap init" 或要求安装 4 件套防跑偏骨架时使用。` | `用于 bootstrap。` |
| `当排查本仓库的 flaky 测试时使用 — 隔离跑 10 次，静默，恢复状态。` | `用于 debug。` |

好例子有：

- 具体 **触发**（"push 前跑 pre-push 检查"）
- 具体 **动作**（"跑窄测试套件"）
- 具体 **结果**（"覆盖当前 diff"）

反例这些都没有。

### 正文结构

正文应按这个模板：

```markdown
# <技能标题>

<一段话总结这个技能做什么、为什么。>

## 何时用这个技能

**用它的场景：**
- <触发条件>

**不用的场景：**
- <范围外条件>

## 硬规则 — 默认非破坏性

1. 永不 rm / unlink / mv 已存在的文件。
2. 未经逐文件同意永不覆盖。
3. 默认只做加法。
4. 幂等。
5. 写前探测。

## 输入

- `<输入名>`（必需）：<说明>

## 流程

### 步骤 1：预检（只读）

<bash 命令>

### 步骤 2：<下一步>

<流程>

## 停止条件

- <中止触发器>

## 完成标准

- [ ] <可观察>
- [ ] <可观察>

## 失败处理

<步骤失败时怎么做>

## 技能后提醒（告诉用户）

<技能跑完后用户该记什么>
```

模板不强制，但 **"硬规则 — 默认非破坏性"** 是强制的。每个新技能都必须包含它，且必须含和 letmbootstrap 技能相同的 5 条规则。这由 [`docs/decisions/0001-keep-skill-non-destructive.md`](decisions/0001-keep-skill-non-destructive.md) 决策强制。

### 下一步可写的技能示例

这些是未来技能的候选 —— 但 **在真实项目需要之前不要写**：

- `pre-push-checks` — push 前的窄测试 + lint 选择
- `code-review` — 给定项目 PR 里检查什么
- `debug-flaky-test` — 隔离、静默、恢复
- `release-checklist` — 版本号、changelog、tag
- `incident-postmortem` — 事件后写什么
- `benchmark-regression` — 检测和二分性能回退

规则（按 AGENTS.md）：不为真实项目还没用到的东西加模板或技能。等真实用例。

## 给本仓库加新技能

1. 建 `skills/<技能名>/SKILL.md`。
2. 在上面的目录加一行。
3. 如果技能需要的安装路径还没有，在 `scripts/install.sh` 加新平台检测器（并更新 [`docs/agent-compatibility.md`](agent-compatibility.md)）。
4. 验证 frontmatter 渲染正确：`head -5 skills/<技能名>/SKILL.md` 应该显示 `name:` 和 `description:` 在相连行。

## 本目录不是

- **不是市场。** 本仓库里的技能不在别处发。
- **不是注册中心。** 目录只列本仓库发的技能。用户项目的技能住在用户项目自己的 `skills/` 目录，不在目录里登记。