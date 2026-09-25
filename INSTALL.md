<!-- 语言：中文（默认） | English mirror: INSTALL.en.md -->

# INSTALL — 把 letmbootstrap 技能装到你的 Agent

> **一页指南。** 要细节？看 [`docs/installation-guide.md`](docs/installation-guide.md)。想知道哪些平台支持？看 [`docs/agent-compatibility.md`](docs/agent-compatibility.md)。

## 这是什么

本仓库发布 **一个** 名为 `letmbootstrap` 的 Agent 技能。装好后，你的 Agent 可以在任何项目里调用它来搭建 4 件套防跑偏骨架（`AGENTS.md` + `docs/decisions/` + `skills/` + 单任务契约）。

技能本身是 **附加式、非破坏性的**。它从不删除或覆盖你的文件。重跑安装器永远安全。刻意没有卸载入口。

## 选你的 Agent

| Agent | 路径 | 一行命令 |
|---|---|---|
| **MiniMax Code / Mavis** | `~/.minimax/agents/<你的-agent>/skills/` | 看 [§ Mavis](#minimax-code--mavis) |
| **Claude Code** | `~/.claude/skills/` | 看 [§ Claude Code](#claude-code) |
| **OpenAI Codex CLI** | `~/.codex/skills/` *（如支持）* 或在项目里做软链 | 看 [§ Codex](#openai-codex-cli) |
| **Cursor** | `.cursor/skills/` *（按项目）* | 看 [§ Cursor](#cursor) |
| **Gemini CLI** | `~/.gemini/skills/` | 看 [§ Gemini CLI](#gemini-cli) |
| **Aider** | `.aider/skills/` *（按项目）* | 看 [§ Aider](#aider) |
| **Devin** | `.devin/skills/` *（按项目）* | 看 [§ Devin](#devin) |
| **OpenCode** | `.opencode/skills/` 或 `~/.config/opencode/skills/` | 看 [§ OpenCode](#opencode) |

> 没列出来？开个 issue 告诉我们你的平台的技能路径，我们补一行。技能本身是可移植的 —— 只有安装路径不同。

## 快速安装（推荐）

安装器 **默认是 dry-run** —— 它会打印要做什么然后退出，不写任何东西。要实际安装，加 `--apply`。

### Linux / macOS（bash）

```bash
# 在 letmbootstrap 仓库目录下
cd /Users/letmlook/code/letmbootstrap

# 1. 看会装到哪里
./scripts/install.sh

# 2. 装到所有检测到的平台
./scripts/install.sh --apply

# 3. 只装一个平台
./scripts/install.sh --apply --platform claude-code
./scripts/install.sh --apply --platform mavis
./scripts/install.sh --apply --platform codex

# 4. 装到指定 Agent（仅 Mavis）
./scripts/install.sh --apply --platform mavis --agent-name my-dev-agent

# 5. 用软链而不是复制（仓库改动自动生效）
./scripts/install.sh --apply --symlink
```

### Windows（PowerShell）

```powershell
# 在 letmbootstrap 仓库目录下
cd C:\path\to\letmbootstrap

# 1. 看会装到哪里
.\scripts\install.ps1

# 2. 装到所有检测到的平台
.\scripts\install.ps1 -Apply

# 3. 只装一个平台
.\scripts\install.ps1 -Apply -Platform claude-code
.\scripts\install.ps1 -Apply -Platform mavis
.\scripts\install.ps1 -Apply -Platform codex

# 4. 装到指定 Agent（仅 Mavis）
.\scripts\install.ps1 -Apply -Platform mavis -AgentName my-dev-agent

# 5. 用软链而不是复制（仓库改动自动生效）
.\scripts\install.ps1 -Apply -Symlink
```

> Windows PowerShell 5.1 或 PowerShell Core 7+ 都可以跑。Windows 10 1809+ 自带 `pwsh`；更老版本要先装 PowerShell Core。

## 共同保证（两个脚本都遵守）

安装器：

- ✅ 自动检测你机器上有哪些平台
- ✅ 把 `skills/letmbootstrap/` 复制到正确位置
- ✅ 跳过已存在的安装（不覆盖、不删除）
- ✅ 报告被跳过的位置以便排查
- ❌ 永远不跑 `rm`、`unlink`、`Remove-Item`、`Move-Item` 或任何破坏性命令
- ❌ 永远不覆盖已存在的技能

## 手动安装（不跑脚本）

如果你想手动操作：

### MiniMax Code / Mavis

```bash
# 挑一个 Agent 来承载技能（比如你的默认开发 Agent）
AGENT_DIR="$HOME/.minimax/agents/<你的-agent-名>/skills"

mkdir -p "$AGENT_DIR"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$AGENT_DIR/"

# 验证
ls "$AGENT_DIR/letmbootstrap/SKILL.md"
```

重载 Agent 会话以加载新技能。触发短语："letmbootstrap init" 或 "搭三件套"。

### Claude Code

```bash
# 全局安装 — 作用于所有 Claude Code 会话
mkdir -p "$HOME/.claude/skills"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$HOME/.claude/skills/"

# 验证
ls "$HOME/.claude/skills/letmbootstrap/SKILL.md"
```

重启 Claude Code。触发短语："letmbootstrap init"。

### OpenAI Codex CLI

Codex CLI 的技能支持取决于你的版本。两种方式：

```bash
# 方式 A：按项目（最稳）
cd <你的项目>
mkdir -p .agent-skills
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .agent-skills/
# 然后在 AGENTS.md 或配置里指向它 — 见 docs/installation-guide.md

# 方式 B：全局，如果你的 Codex 版本支持 ~/.codex/skills/
mkdir -p "$HOME/.codex/skills"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$HOME/.codex/skills/"
```

如果你的 Codex 版本还不支持外部技能，回退到"调用时粘贴"：把技能正文粘到对话里并说"按这个流程执行"。

### Cursor

```bash
# 只能按项目 — Cursor 没有全局技能目录
cd <你的项目>
mkdir -p .cursor/skills
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .cursor/skills/
```

Cursor 从项目根目录的 `.cursor/skills/` 读技能。重启会话。

### Gemini CLI

```bash
mkdir -p "$HOME/.gemini/skills"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$HOME/.gemini/skills/"
```

### Aider

Aider 没有原生技能目录。两种方式：

```bash
# 方式 A：按项目约定文件
cd <你的项目>
mkdir -p .aider/skills
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .aider/skills/
# 然后加到 .aider/conventions.md：
# "当被要求 'letmbootstrap init' / '搭三件套' / 'init methodology' 时，
#  读 .aider/skills/letmbootstrap/SKILL.md 并严格按其流程执行。"

# 方式 B：调用时粘贴 — 需要时把 SKILL.md 粘到对话里
```

### Devin

```bash
# 按项目
cd <你的项目>
mkdir -p .devin/skills
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .devin/skills/
```

Devin 按会话读 `.devin/` 下的文件。在会话提示里引用技能路径。

### OpenCode

```bash
# 按项目（推荐用于 OpenCode）
cd <你的项目>
mkdir -p .opencode/skills
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .opencode/skills/

# 或全局
mkdir -p "$HOME/.config/opencode/skills"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$HOME/.config/opencode/skills/"
```

## 验证是否成功

装好后，对 Agent 说以下任一句：

- "letmbootstrap init"
- "搭三件套"
- "初始化方法论"
- "bootstrap letmbootstrap"

如果技能装对了，Agent 会识别触发短语并按引导流程走，不需要你再贴 SKILL.md 正文。

## 如果以后想移除？

本安装器不提供卸载命令。这是刻意的设计 —— 见 [`docs/decisions/0001-keep-skill-non-destructive.md`](docs/decisions/0001-keep-skill-non-destructive.md) 的理由。

要手动移除：

```bash
# 直接删除安装的副本。安装器没动过其他任何东西。
rm -rf "$HOME/.claude/skills/letmbootstrap"
# （或你装到的任何路径）
```

这是 **你自己** 做的事，不是技能做的事。

## 更新技能

安装器可以安全重跑。它跳过已存在的安装，所以要更新就：

```bash
# 1. 拉最新的 letmbootstrap 仓库
cd /Users/letmlook/code/letmbootstrap && git pull

# 2. 手动把安装的副本替换成新版本
cp -R skills/letmbootstrap "$HOME/.claude/skills/letmbootstrap"
```

或者开发期用 `--symlink`，仓库改动自动生效，不用重装。

## 下一步

技能装好后，在项目目录里说一句触发短语即可。技能会引导剩下的步骤。完整叙事见 [`docs/methodology.md`](docs/methodology.md)。