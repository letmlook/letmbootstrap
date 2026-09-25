<!-- 语言：中文（默认） | English mirror: AGENTS.en.md -->

# AGENTS.md — letmbootstrap 模板

> 本文件 dogfood 方法论本身：它就是本模板仓库的 30 行宪法。

## Project is（项目是什么）

一套可复用的协作方法论模板，专为单人 + Agent 迭代式开发设计。把 4 件套防跑偏骨架 + 引导技能打包在一起，让新项目 ~10 分钟就能采纳这套纪律。

## Stack（技术栈）

Markdown / shell / Agent SKILL.md。无运行时。无构建。

## Project is NOT（项目不是什么）

- 不是运行时框架，不是 CLI，不是库 —— 只是文档 + 模板 + 技能。
- 不绑定任何特定语言或框架。
- 不是"方法论百科全书" —— 每个制品都要短且有立场。
- 不上技能市场 —— 刻意不发。

## Required reading (in order)（必读，按顺序）

1. `README.md` — 仓库里有什么、为什么
2. `INSTALL.md` — 怎么把 letmbootstrap 技能装到你的 Agent
3. `ARCHITECTURE.md` — 五层架构总览
4. `docs/methodology.md` — 完整叙事
5. `docs/installation-guide.md` — 各平台详细安装步骤 + 故障排查
6. `docs/agent-compatibility.md` — 哪些 Agent 能跑这个技能
7. `docs/skills-catalog.md` — 已发布的技能 + 如何添加更多
8. `FAQ.md` / `GLOSSARY.md` — 速查
9. `templates/` — 三个可复制模板（见 `templates/README.md`）
10. `skills/letmbootstrap/SKILL.md` — 引导技能
11. `scripts/install.sh` — 非破坏性安装器，Linux/macOS（读静态守卫）
12. `scripts/install.ps1` — PowerShell 等价版本，Windows/跨平台（同样有静态守卫）

## Where new things go（新东西放哪）

| 目标 | 位置 |
|---|---|
| 加新模板 | `templates/<名>.template` |
| 加新技能 | `skills/<技能名>/SKILL.md` |
| 加方法论规则 | `docs/methodology.md`（更新叙事，≤ 1500 字） |
| 加示例 | `examples/<项目名>/`（小巧、完整） |
| 加决策记录 | `docs/decisions/NNNN-<短>.md` |
| 加安装脚本 | `scripts/<名>.sh`（默认非破坏性） |
| 加新平台安装路径 | 编辑 `scripts/install.sh` **和** `scripts/install.ps1` 检测器 + 在 `docs/agent-compatibility.md` 加一行 |
| 加 FAQ 条目 | `FAQ.md` + 镜像到 `FAQ.en.md` |
| 加术语条目 | `GLOSSARY.md` + 镜像到 `GLOSSARY.en.md` |
| 调整宪法 | 本文件（≤ 80 行） |

## Definition of Done（每次变更的完成标准）

- [ ] 每个新模板在 `examples/` 下有 ≥ 1 个示例
- [ ] 每个新技能有清晰的 `description:` frontmatter 触发
- [ ] `docs/methodology.md` 叙事从头到尾可读（≤ 1500 字）
- [ ] README 的"快速上手"仍然准确
- [ ] INSTALL.md 在安装流程变更后仍然准确
- [ ] `./scripts/install.sh --help` 和 `.\scripts\install.ps1 -Help` 仍然可用
- [ ] 两个安装器（干跑，无标志）均无报错
- [ ] `scripts/` 下无新破坏性操作（非注释行无 `rm`、`unlink`、`mv`、`rmdir`）
- [ ] 如改 `FAQ.md` 或 `GLOSSARY.md`，镜像到 `FAQ.en.md` / `GLOSSARY.en.md`

## Forbidden（禁区）

- 不要膨胀成"元方法论框架"。
- 不要为真实项目还没用到的东西加模板。
- 不要写没有具体步骤的"哲学"。
- 不要给 `scripts/install.sh` 或 `scripts/install.ps1` 加破坏性操作 —— 两个脚本顶部的静态守卫是绑定的（见 `docs/decisions/0001-keep-skill-non-destructive.md`）。
- 不要在任何安装脚本里发 `uninstall` 子命令或 `--force` / `--reset` 标志。破坏性操作由用户自己执行。
- 不要发到技能市场。安装一律直接来自本仓库。

## Decisions（决策）

添加任何新约定前，先查 `docs/decisions/`。如果已有，跟着走；如果要改，**写一条新决策文件** —— 不要在 PR 评论里争论。

## Tasks（任务）

任何非平凡变更前，先填一份单任务契约（见 `templates/single-task-contract.md`）。