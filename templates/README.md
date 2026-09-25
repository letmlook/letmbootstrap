<!-- 语言：中文（默认） | English mirror: templates/README.en.md -->

# templates/

本目录包含 `letmbootstrap` 技能复制到目标项目的三个 markdown 文件。它们是 **模板**，不是成品文档 —— 每个都需要用户在使用前填好。

## 这里有什么

| 文件 | 作用 | 技能何时复制 |
|---|---|---|
| `AGENTS.md.template` | 项目宪法 | 总是 |
| `decision.md.template` | 单条决策记录 | 总是（作为 `0001-bootstrap-with-letmbootstrap.md`）|
| `single-task-contract.md` | 空白的任务契约 | 总是（复制到用户选的 skills 目录） |

## 技能怎么用它们

1. 安装时 **读** 每个模板。
2. **替换** 用户的项目元数据（名、技术栈、反目标、扩展图）。
3. **写入** 目标项目下不冲突的路径。
4. **跳过** 如果目标已存在 —— 技能永不覆盖。

完整流程见 [`skills/letmbootstrap/SKILL.md`](../skills/letmbootstrap/SKILL.md)。

## 何时加新模板

只在以下情况加模板：

1. 真实项目需要同一种文件超过两次。
2. 模式足够通用，能套用到不同技术栈的项目。
3. 模板用户能在 30 秒内填好。

如果一个项目只需要一次性的东西，放聊天里或 commit 信息里。模板是杠杆；一次性的文件回不了本。

## 怎么写好模板

好模板是：

- **有立场。** 包含反目标和禁区，不只是结构。
- **短。** 大多数模板一屏能看完。细节推到单独的文档。
- **填空式。** 每个 `<占位符>` 是用户不用思考就能答的具体东西。
- **自解释。** 填模板的人不应该需要读方法论叙事才知道写什么。

坏模板是：

- **长。** 超过 ~80 行是气味 —— 把细节推走。
- **模糊。** `AGENTS.md.template` 里写 `<加你的项目描述>` 等于没说。
- **决策形。** 如果模板强迫用户做决策（不只是描述项目），决策就该在决策记录里，不在模板里。

## 各模板说明

### `AGENTS.md.template`

30 行宪法。章节：

1. **Project is** — 一句话，动词 + 名词 + 受众。
2. **Stack** — 语言、运行时、框架、包管理器、测试运行器。
3. **Project is NOT** — 反目标。最强大的章节。
4. **Required reading (in order)** — 明确的阅读顺序。
5. **Where new code goes** — 扩展图。
6. **Definition of Done** — 清单。
7. **Forbidden** — 不可谈判的禁飞区。
8. **Decisions** — 指向 docs/decisions/。
9. **Tasks** — 指向单任务契约。
10. **Stop and ask if** — 升级触发器。

### `decision.md.template`

只能追加的决策记录。章节：

1. **Status** — 日期、状态、一句话理由。
2. **Context** — 问题，写得脱离方案也能读懂。
3. **Decision** — 现在时、事实性、可验证。
4. **Consequences** — 得到 / 付出 / 工作流变化。
5. **Alternatives considered** — 必填。必须是真实方案。
6. **Lifecycle** — proposed / implemented / rejected。

最重要的规则：**方案必须是真的**。一条"我们选了 SQLite"但没写"拒绝了 Postgres 因为 X"的决策记录，每半年就会被重新争论一次。

### `single-task-contract.md`

30 秒派任务前模板。章节：

1. **Task** — 一句话，动词 + 名词。
2. **Required reading** — 2-5 个引用。
3. **Out of scope (do NOT do)** — 边界。
4. **Acceptance criteria** — 可观察清单。
5. **Autonomous decision space** — Agent 单独决定什么。
6. **Must ask me before** — 升级触发器。

契约同时做三件事：

- 开始任务前澄清你自己的思路。
- 通过明确的"不要做"清单防止 scope 蔓延。
- 给 Agent 一个停止信号。

## 版本

模板是公开 API 的一部分。任何影响技能如何安装的模板结构变更都需要 minor 版本 bump。

版本历史见 [`../CHANGELOG.md`](../CHANGELOG.md)。

## 本 README 不是

- **不是 AGENTS.md。** 这是模板目录的索引；项目宪法在 [`../AGENTS.md`](../AGENTS.md)。
- **不是方法论。** 完整叙事见 [`../docs/methodology.md`](../docs/methodology.md)。