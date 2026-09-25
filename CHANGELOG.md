<!-- 语言：中文（默认） | English mirror: CHANGELOG.en.md -->

# 更新日志

本项目的所有显著变更都会记录在此文件。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)，
本项目遵循 [Semantic Versioning](https://semver.org/lang/zh-CN/spec/v2.0.0.html)。

技能的 `SKILL.md` frontmatter 是 API 契约的一部分。任何影响外部行为的变更至少 minor bump。

## [未发布]

### 新增

- **全面中文化** — 所有顶层文档、`docs/` 下文档、模板、脚本说明、示例、技能的 default 版本改为中文。
- 英文版本以 `.en.md` 镜像形式保留在同目录，与中文版同步。

### 变更

- README/AGENTS/CHANGELOG 等顶层文档的 default 语言切换为中文。
- AGENTS.md 的"新东西放哪"增补双语镜像规则。

## [0.1.0] — 2026-09-26

### 新增

- `README.md` — 总览 + 快速上手
- `INSTALL.md` — 一页 Agent 平台安装指南
- `AGENTS.md` — dogfooded 项目宪法
- `docs/methodology.md` — 4 件套防跑偏叙事
- `docs/installation-guide.md` — 各平台安装细节 + 故障排查
- `docs/agent-compatibility.md` — 8 个 Agent 平台的兼容矩阵
- `docs/decisions/0001-keep-skill-non-destructive.md` — 非破坏性保证
- `templates/AGENTS.md.template` — 项目宪法模板
- `templates/decision.md.template` — 决策记录模板
- `templates/single-task-contract.md` — 单任务契约模板
- `skills/letmbootstrap/SKILL.md` — 引导技能（顶部硬规则一节）
- `scripts/install.sh` — 非破坏性安装器（静态守卫 + 默认干跑）
- `examples/letmbootstrap-self/` — 技能输出的 dogfood 示例
- `.gitignore` — macOS + 编辑器 + 临时文件排除
- `ARCHITECTURE.md` — 五层架构总览
- `CONTRIBUTING.md` — PR 流程 + 决策记录约定
- `SECURITY.md` — 安全上报策略
- `CODE_OF_CONDUCT.md` — 社区公约
- `LICENSE` — MIT
- `docs/skills-catalog.md` — 已发布技能 + 如何编写
- `FAQ.md` / `GLOSSARY.md` — 速查参考（顶层）
- `templates/README.md` — 模板指引
- `scripts/README.md` — 脚本指引
- `examples/README.md` — 示例指引

> 注：`docs/faq.md` 和 `docs/glossary.md` 在 0.1.0 中是 `FAQ.md` 和 `GLOSSARY.md` 的镜像副本。在 [未发布] 段删除以减少维护负担 —— 顶层版本为唯一规范位置。

### 设计承诺（跨版本绑定）

- **默认非破坏性。** 无 `rm`、`unlink`、`mv`、`rmdir`，无 `--force`、无 `--reset`、无卸载子命令。见决策 0001。
- **幂等安装器。** 重跑 `scripts/install.sh` 永远安全。
- **冲突跳过。** 安装目标已存在时，打印 `SKIP` 继续。
- **静态守卫。** `scripts/install.sh` 一旦非注释行出现破坏性模式，以退出码 78 中止。

## 版本策略

| 变更 | 版本 bump |
|---|---|
| 技能 `SKILL.md` frontmatter 或正文改变外部行为 | minor (0.x.0) |
| 给 `scripts/install.sh` 加新平台检测器 | minor |
| 加新模板 | minor |
| 加新决策记录 | patch |
| 澄清 / 修正现有文档 | patch |
| 加新示例 | patch |
| 不改变行为的 bug 修复 | patch |
| 任何引入破坏性操作的东西 | **拒** —— 见决策 0001 |

[未发布]: https://github.com/letmlook/letmbootstrap/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/letmlook/letmbootstrap/releases/tag/v0.1.0