---
name: letmbootstrap
description: 当初始化新项目（或改造现有项目）时使用 — 安装 AGENTS.md 宪法、docs/decisions/ 决策日志和 skills/ 脚手架，让项目遵循 4 件套防跑偏骨架。触发短语包括 "letmbootstrap init"、"bootstrap letmbootstrap"、"init methodology"、"搭三件套"、"初始化方法论"、"letmbootstrap 初始化"，以及任何将方法论模板应用到项目的请求。不要用于已经初始化的项目 — 请先检查。Use when initializing a new project (or retrofitting an existing one) — installs the AGENTS.md constitution, docs/decisions/ decision log, and skills/ scaffolding so the project follows the 4-piece anti-drift setup.
---

# 引导 letmbootstrap 方法论

把 letmbootstrap 4 件套（`AGENTS.md` + `docs/decisions/` + `skills/`）装到目标项目，让 Agent 在那个项目里从第一天起就遵守防跑偏纪律。

方法论的源头在 `/Users/letmlook/code/letmbootstrap/`。动手前先读那里的 `templates/`、`docs/methodology.md` 和示例 `AGENTS.md`。

如果你是想 **把 letmbootstrap 技能本身装到你的 Agent 平台**（Claude Code、MiniMax Code、Codex CLI 等），而不是把方法论装进项目，读 [`INSTALL.md`](../../INSTALL.md) —— 那条路径非破坏性、平台特定。本 SKILL.md 假设技能已装好。

## 硬规则 — 默认非破坏性

以下规则对 **下面每个步骤** 生效。它们无法被用户请求覆盖，除非对每个受影响文件有单独明确确认的同意。

1. **永不 `rm`、`unlink`、`mv` 或以其他方式删除已存在的文件。** 技能没有卸载路径。如果用户要求删除已装文件，拒绝并指向手动清理。
2. **未经逐文件明确同意，永不覆盖已存在的文件。** "初始化我的项目"不构成覆盖现有 `AGENTS.md` 的同意。每次覆盖需要单独的确认。
3. **默认只做加法。** 新文件可以；替换需要同意；删除禁止。
4. **幂等：重跑技能是安全的。** 在干净目标上跑两次产生相同结果。在已初始化目标上跑两次是无操作（先报告当前状态）。
5. **写前探测。** 第 1 步是强制的且只读。如果目标已经有 4 件套在工作状态，技能报告"已初始化"并退出，不写任何东西。

## 何时使用本技能

**用它的场景：**

- 用户明确要求 "letmbootstrap init"、"bootstrap letmbootstrap"、"init methodology"、"搭三件套"、"初始化方法论"
- 用户要求把 letmbootstrap 模板套到项目上
- 用户说"为 Agent 协作设置这个项目"

**不用的场景：**

- 目标项目已经有 AGENTS.md 和 docs/decisions/ —— 改为指向用户的现有文件
- 用户只要其中一件（例如只要 AGENTS.md）—— 问是否装全套
- 用户在问方法论本身 —— 指向 `docs/methodology.md`
- 用户想把 **letmbootstrap 技能本身** 装到别的 Agent 平台 —— 指向 `INSTALL.md`

## 输入

- `target_dir`（必需）：项目根的绝对路径。默认：当前工作目录，如果它看起来像项目根。
- `project_meta`（从用户收集）：见下面第 2 步。

如果用户没指定目标目录，**仅当** 它包含项目标记（`package.json`、`pyproject.toml`、`Cargo.toml`、`go.mod`、`README.md`、`.git/` 等）时，默认当前工作目录。否则问。

## 流程

### 第 1 步：预检（只读）

写任何东西之前：

1. **验证 target_dir 存在且可写。**
2. **检测当前状态：**
   ```bash
   ls -la <target_dir>/AGENTS.md              # 已经有宪法？
   ls <target_dir>/docs/decisions/ 2>/dev/null # 已经有决策日志？
   ls <target_dir>/skills/ <target_dir>/.agent-skills/ <target_dir>/.claude/skills/ 2>/dev/null
   ```
3. **如果三件都存在且看着是刻意的** → 告诉用户"这个项目已经初始化"并停止。不覆盖。
4. **如果部分存在** → 覆盖每个之前问用户。默认行为是保留已有文件不动（只做加法）。
5. **如果什么都不存在** → 进入第 2 步。

本步只读。无 `rm`、无 `mv`、无写。

### 第 2 步：收集项目元数据

问用户 5 个简短问题。保持简洁；用问题 UI，不要长段。

1. **项目的一句话目的是什么？**（动词 + 名词 + 受众）
   - 示例："一个把 markdown 转 Notion 页面的 CLI。"
2. **技术栈是什么？**（语言、运行时、框架、包管理器、测试运行器）
   - 示例："TypeScript 5 / Node 22 / Hono / pnpm / vitest"
3. **本项目 **不能** 做什么？**（2-4 个反目标）
   - 示例："不要 web UI。不要多用户鉴权。不要云同步。"
4. **新代码放哪？**（扩展图；如果用户不确定，按技术栈给默认并请确认）
5. **有现成的文档要从 AGENTS.md 链吗？**（README、架构文档、贡献指南）

如果用户说"我不知道"或"你定"，给合理默认并请确认。

### 第 3 步：预览要写什么

写之前，给用户看预览，把非破坏性保证说清楚：

```
将创建（加法式，可重跑）：
  <target_dir>/AGENTS.md                            (~30 行，已定制)
  <target_dir>/docs/decisions/                      (目录)
  <target_dir>/docs/decisions/0001-bootstrap.md     (初始决策)
  <target_dir>/docs/decisions/README.md             (决策格式指南)
  <target_dir>/.agent-skills/                       (或 skills/ — 问用户)
  <target_dir>/.agent-skills/README.md              (链回 letmbootstrap)
  <target_dir>/.agent-skills/single-task-contract.md (任务契约模板)

不会动：
  <不会被改的现有文件清单>

不会做（无论如何都不做）：
  - rm / unlink / mv 任何现有文件
  - 未经逐文件同意覆盖
  - 动 <target_dir> 外面的任何东西
```

问用户："继续这次引导吗？" 用问题 UI + 明确确认。**没有明确确认不继续。**

如果用户要求不同的 skills 目录名（`skills/` 而不是 `.agent-skills/`，或 `.claude/skills/`），尊重选择。

### 第 4 步：写文件（只加法）

顺序重要 —— 后续文件可能引用前面的。

1. **`AGENTS.md`** 在 `<target_dir>/AGENTS.md`：
   - 读模板：`templates/AGENTS.md.template` 从 letmbootstrap 仓库
   - 替换：项目名、技术栈、反目标、扩展图、文档链接
   - 保持 ≤ 200 行 —— 超过就把细节推 `docs/`
   - **如果 `<target_dir>/AGENTS.md` 已存在，停下问同意。** 不默默覆盖。

2. **`docs/decisions/README.md`** 在 `<target_dir>/docs/decisions/README.md`：
   - 简短解释决策日志格式
   - 复制 `docs/methodology.md` "决策生命周期"那节内容
   - 链回 letmbootstrap 仓库
   - **如果 `<target_dir>/docs/decisions/README.md` 已存在，跳过并报告。** 不覆盖。

3. **`docs/decisions/0001-bootstrap-with-letmbootstrap.md`**：
   - 读模板：`templates/decision.md.template`
   - 填写：
     - **背景：** 项目正在采用 letmbootstrap 方法论
     - **决策：** 安装 4 件套
     - **影响：** 项目遵循 letmbootstrap 防跑偏纪律
     - **考虑过的方案：** 临时决策、不要方法论、保持现状
   - **如果同名文件已存在，加数字后缀（0002、0003、…）而不是覆盖。**

4. **Skills 目录** 在 `<target_dir>/.agent-skills/`（或用户选的名字）：
   - **`README.md`** — 解释目录、链回 letmbootstrap、提单任务契约
   - **`single-task-contract.md`** — 复制 `templates/single-task-contract.md`
   - 可选地加 `pre-commit-checks.md` 如果用户的技术栈有已知闸门（TypeScript → typecheck + lint；Python → ruff + pytest；等）
   - **如果 skills 目录已存在，拷文件进来但跳过任何已存在的。** 不覆盖。

### 第 5 步：验证和报告

所有文件写完后：

1. 跑 `ls -laR <target_dir>/AGENTS.md <target_dir>/docs/ <target_dir>/.agent-skills/`（或选的 skills 目录）确认结构。
2. 给用户看创建出来的树。
3. 给用户看已定制的 `AGENTS.md` 内容方便 review。
4. 提醒他们："下次给 Agent 非平凡任务前，先填单任务契约。"

## 停止条件

以下情况干净中止：

- 用户拒绝预览
- 目标目录不可写
- 现有文件未经明确同意会被覆盖
- 用户在任何步骤说"停"或"先不要"
- 用户要求删除或移除任何现有文件 —— 拒绝并解释为什么

## 完成标准

引导完成当：

- `AGENTS.md` 存在于目标根，已为项目定制，≤ 200 行
- `docs/decisions/` 含 `README.md` + `0001-bootstrap-with-letmbootstrap.md`（或下一个可用编号）
- skills 目录存在含 `README.md` + `single-task-contract.md`
- 用户 review 过每个创建的文件并确认
- 没有任何现有文件被修改或删除

## 失败处理

写文件失败时：

1. 报告准确错误和文件路径。
2. 建议修复方法（权限、父目录等）。
3. 不默默重试 —— 用户可能要介入。

定制产出尴尬的 `AGENTS.md`（例如用户给了很模糊的答案），摆出来并提议精炼。不要交付看起来千篇一律的宪法。

用户要求会删除或覆盖现有文件的操作时：

1. 明确拒绝。引用非破坏性保证。
2. 提供最接近的安全替代（"我可以新建一个同目录不同名的文件，或把新内容写到临时文件给你 review"）。
3. 不尝试该操作，即使用户坚持，直到他们重新确认且完全理解技能明确不支持删除。

## 引导后提醒（告诉用户）

成功后告诉用户：

> **每日提醒：** 每次给 Agent 非平凡任务前，先填单任务契约（`.agent-skills/single-task-contract.md`）。30 秒打字，平均每次任务节省 ~30 分钟重新定向。
>
> **每周提醒：** 做非平凡决策时（任何你以后还要重决策的事），写一条决策记录（`docs/decisions/NNNN-<标题>.md`）。这是 Agent 知道不重新争论的唯一方式。
>
> **重跑是安全的。** 你可以以后再跑技能补上跳过的部分。它不会删除或覆盖任何东西，除非明确同意。