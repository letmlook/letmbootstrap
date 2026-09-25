<!-- 语言：中文（默认） | English mirror: SECURITY.en.md -->

# 安全策略

## 范围

本仓库包含文档、模板、一个 shell 脚本（`scripts/install.sh`）、一个 Agent 技能（`skills/letmbootstrap/SKILL.md`）。无运行时、无服务端、无网络代码。

因此安全模型很窄：

| 资产 | 风险 |
|---|---|
| `scripts/install.sh` | 如果用户传入不受信的参数，可能 shell 注入。用 `set -euo pipefail` 和最小化标志解析缓解。 |
| `skills/letmbootstrap/SKILL.md` | 间接风险 —— 如果用户装了某个含恶意 payload 的 fork 版，技能会在他们 Agent 的上下文中执行。缓解方式：始终从本仓库安装，不用 fork。 |
| 模板 | 纯 markdown —— 无执行风险。 |

无凭证、无 token、无构建产物。

## 支持的版本

只有 `main` 上最新的 release 接受安全补丁。旧 tag 不再维护。

## 上报漏洞

**请勿**为安全报告开公开 GitHub issue。

给维护者发邮件，邮箱在他们的 GitHub profile 上，主题前缀 `[letmbootstrap security]`。包括：

- 问题描述
- 复现步骤
- 影响评估

7 天内应收到确认。维护者评估后会：

- 修复并发布（典型时间线：从确认起 14 天），或
- 以理由拒绝（如果超出范围）。

## 超出范围

以下刻意不在本仓库安全模型之内，不会在这里修：

- **Agent 平台自身**（Claude Code、Mavis、Codex CLI 等）。向平台维护者上报。
- **可能转载本技能的市场**。我们刻意不在市场发 —— 见 [`docs/decisions/0001-keep-skill-non-destructive.md`](docs/decisions/0001-keep-skill-non-destructive.md)。
- **已采用方法论的用户项目**。它们的安全是它们自己的事。
- **Fork**。如果你 fork 本仓库，你维护你的 fork。

## 非破坏性保证，重述为安全属性

[决策 0001](docs/decisions/0001-keep-skill-non-destructive.md) 的非破坏性保证同时也是安全属性：

- 技能未经同意不能 `rm` 用户文件。
- 安装器在任何标志下都不能 `rm` 用户文件。
- `scripts/install.sh` 中的静态守卫在脚本源码出现破坏性模式时立即中止。

这是设计如此。如果未来的 PR 弱化了这个，把它当安全回归。

## 本策略不是

- **不是 CVE 投标流程。** 这是个小文档仓库；不跑协调披露。
- **不是漏洞赏金。** 没有报酬。
- **不是零问题的承诺。** 仓库足够小可以一次读完 —— 请读，并报告你发现的。