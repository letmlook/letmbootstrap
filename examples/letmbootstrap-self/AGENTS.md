<!-- 语言：中文（默认） | English mirror: examples/letmbootstrap-self/AGENTS.en.md -->

# AGENTS.md — letmbootstrap（示例输出）

> 这是 **示例**，展示 letmbootstrap 技能产出什么。规范、真实版本在仓库根 [`AGENTS.md`](../../AGENTS.md)。

## Project is（项目是什么）

一套可复用的协作方法论模板，专为单人 + Agent 迭代式开发设计。把 4 件套防跑偏骨架 + 引导技能打包在一起，让新项目 ~10 分钟就能采纳这套纪律。

## Stack（技术栈）

- 语言：Markdown
- 运行时：无（仅文档 + shell + 技能定义）
- 框架：无
- 包管理器：无
- 测试：无（手动通过 `./scripts/install.sh --dry-run` 验证）

## Project is NOT（项目不是什么）

- 不是运行时框架、CLI 或库 —— 只是文档 + 模板 + 技能。
- 不绑定任何特定 Agent 平台。
- 不是"方法论百科全书" —— 每个制品都要短且有立场。

## Required reading (in order)（必读，按顺序）

1. [`README.md`](../../README.md) — 仓库里有什么、为什么
2. [`docs/methodology.md`](../../docs/methodology.md) — 完整叙事
3. [`templates/`](../../templates/) — 三个可复制模板
4. [`skills/letmbootstrap/SKILL.md`](../../skills/letmbootstrap/SKILL.md) — 安装流程

## Where new code goes（新东西放哪）

| 目标 | 位置 |
|---|---|
| 加新模板 | `templates/<名>.template` |
| 加新技能 | `skills/<技能名>/SKILL.md` |
| 加方法论规则 | `docs/methodology.md`（更新叙事，≤ 1500 字） |
| 加示例 | `examples/<项目名>/`（小巧、完整） |
| 加决策记录 | `docs/decisions/NNNN-<短>.md` |
| 加安装脚本 | `scripts/<名>.sh`（默认非破坏性） |

## Definition of Done（每次变更的完成标准）

- [ ] 每个新模板在 `examples/` 下有 ≥ 1 个示例
- [ ] 每个新技能有清晰的 `description:` frontmatter 触发
- [ ] `docs/methodology.md` 叙事从头到尾可读（≤ 1500 字）
- [ ] README 的"快速上手"仍然准确
- [ ] `./scripts/install.sh --help` 仍然可用
- [ ] `./scripts/install.sh`（干跑）无报错

## Forbidden（禁区）

- 不要膨胀成"元方法论框架"。
- 不要为真实项目还没用到的东西加模板。
- 不要写没有具体步骤的"哲学"。
- 不要给 `scripts/install.sh` 加破坏性操作（非注释行无 `rm`、`unlink`、`mv`、`rmdir`）。
- 不要绕过 `scripts/install.sh` 的静态守卫 —— 它在那里是有原因的。

## Decisions（决策）

添加任何新约定前，先查 [`docs/decisions/`](../../docs/decisions/)。如果已有，跟着走；如果要改，写一条新决策文件 —— 不要在 PR 评论里争论。

## Tasks（任务）

任何非平凡变更前，先填一份单任务契约（见 [`templates/single-task-contract.md`](../../templates/single-task-contract.md)）。和任务一起放在对话里或作为草稿文件。

## Stop and ask if（在以下情况停下问）

- 你想放松 `Forbidden` 里的某条规则
- 你想在 `scripts/` 里引入破坏性操作
- 你发现决策记录和用户要求矛盾 —— 摆出来问哪个赢