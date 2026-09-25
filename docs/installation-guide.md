<!-- 语言：中文（默认） | English mirror: docs/installation-guide.en.md -->

# 安装指南 — 各平台详细步骤

本文是 [`INSTALL.md`](../INSTALL.md) 的长篇版。先读 `INSTALL.md`；需要细节、故障排查或平台特殊性时来这里。

## 设计原则（绑定）

适用于下面描述的 **所有** 安装路径：

1. **只做加法。** 每次操作都是 `mkdir -p` + `cp -R`（或 `ln -s`）。不删、不改名、不覆盖。
2. **冲突跳过。** 如果目标已存在，安装器打印 `SKIP` 继续。不覆盖、不询问覆盖、不删旧副本。
3. **幂等。** 跑两次和跑一次最终状态相同。
4. **默认干跑。** 脚本打印它会做什么然后退出 0，不写。`--apply` / `-Apply` 切换到写入模式。
5. **脚本里无破坏性命令。** `install.sh` 顶部静态守卫拦 `rm`、`unlink`、`mv`、`rmdir`；`install.ps1` 拦 `Remove-Item`、`Move-Item`、`Rename-Item`、`Clear-Item`、`Clear-Content` 以及对应别名（`del`、`rm`、`mv` 等）。任何匹配就退出 78。
6. **不改源仓库。** 安装器从不编辑 `/Users/letmlook/code/letmbootstrap/` 里的文件 —— 只读。

## 两个安装器

仓库同时提供两个功能等价的安装器：

| 脚本 | 平台 | 标志风格 |
|---|---|---|
| `scripts/install.sh` | Linux / macOS | `--apply`、`--platform <名>`、`--symlink`、`--help` |
| `scripts/install.ps1` | Windows（PowerShell 5.1 / Core 7+） | `-Apply`、`-Platform <名>`、`-Symlink`、`-Help` |

检测器、跳过策略、保证完全一致 —— 只是语法不同。Windows 用户跑 `.ps1`；其他平台跑 `.sh`。两个都支持 `-Apply` / `--apply` 之外的相同功能集。

## 技能载荷

你实际装的是单个目录：

```
skills/letmbootstrap/
└── SKILL.md        # 技能定义（frontmatter + 流程）
```

仓库里的其他东西（模板、文档、示例、脚本）支撑技能但不是安装载荷的一部分。Agent 只需要 `SKILL.md` 就能调用技能；模板和文档通过技能正文里的绝对路径引用。

如果你想要更丰富的安装（例如模板和技能一起），传 `--with-templates` / `-WithTemplates`。默认载荷最小。

## 各平台参考

### MiniMax Code / Mavis

- **源：** `/Users/letmlook/code/letmbootstrap/skills/letmbootstrap/`
- **目标：** `~/.minimax/agents/<agent-名>/skills/letmbootstrap/`
- **范围：** 按 Agent。每个 Mavis Agent 有自己的技能目录。
- **选 Agent 名：** 跑 `mavis agent list` 看你的 Agent。默认 `mavis`。
- **验证：** 给该 Agent 开个新会话；用"letmbootstrap init"或"搭三件套"触发。
- **需要重载：** 是 —— 新会话自动加载新技能；现有会话不会。

```bash
AGENT_DIR="$HOME/.minimax/agents/mavis/skills"
mkdir -p "$AGENT_DIR"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$AGENT_DIR/"
```

### Claude Code

- **源：** `/Users/letmlook/code/letmbootstrap/skills/letmbootstrap/`
- **目标：** `~/.claude/skills/letmbootstrap/` *（全局）* 或 `./.claude/skills/letmbootstrap/` *（按项目）*
- **范围：** 推荐全局 —— 作用于每个 Claude Code 会话。
- **验证：** 重启 Claude Code；用"letmbootstrap init"触发。
- **需要重载：** 是 —— 重启 CLI。

```bash
mkdir -p "$HOME/.claude/skills"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$HOME/.claude/skills/"
```

### OpenAI Codex CLI

Codex 的技能发现跨版本有差异。三条可靠路径：

**路径 A — 按项目（永远可用）：**

```bash
cd <你的项目>
mkdir -p .agent-skills
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .agent-skills/
```

然后在 `AGENTS.md` 或 Codex 配置里引用：

```markdown
<!-- in AGENTS.md -->
本仓库可用技能：./.agent-skills/。触发短语匹配时读 <技能名>/SKILL.md。
```

**路径 B — 全局（新 Codex 版本）：**

```bash
mkdir -p "$HOME/.codex/skills"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$HOME/.codex/skills/"
```

**路径 C — 调用时粘贴（万能回退）：**

如果两条路径都不行，调用时把 `SKILL.md` 粘到对话里。无需安装。

### Cursor

- **源：** `/Users/letmlook/code/letmbootstrap/skills/letmbootstrap/`
- **目标：** `./.cursor/skills/letmbootstrap/` *（只能按项目）*
- **范围：** Cursor 没有全局技能目录 —— 每个项目装。
- **验证：** 在该项目里重启 Cursor 会话。

```bash
cd <你的项目>
mkdir -p .cursor/skills
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .cursor/skills/
```

### Gemini CLI

- **源：** `/Users/letmlook/code/letmbootstrap/skills/letmbootstrap/`
- **目标：** `~/.gemini/skills/letmbootstrap/`
- **范围：** 全局。
- **需要重载：** 重启 Gemini CLI。

```bash
mkdir -p "$HOME/.gemini/skills"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$HOME/.gemini/skills/"
```

### Aider

Aider 没有正式技能目录。两种可行模式：

**模式 A — 约定文件：**

```bash
cd <你的项目>
mkdir -p .aider
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .aider/skills/

# 加到 .aider/conventions.md（Aider 自动读）：
cat >> .aider/conventions.md <<'EOF'

## 可用技能
当被要求 "letmbootstrap init" / "搭三件套" / "init methodology" 时：
读 .aider/skills/letmbootstrap/SKILL.md 并严格按其流程执行。
EOF
```

**模式 B — 调用时粘贴：** 需要时把 `SKILL.md` 正文粘到对话里。

### Devin

- **源：** `/Users/letmlook/code/letmbootstrap/skills/letmbootstrap/`
- **目标：** `./.devin/skills/letmbootstrap/` *（按项目）*
- **范围：** Devin 按会话读项目本地的 `.devin/` 文件。按项目装。
- **验证：** 在会话提示里引用该路径。

```bash
cd <你的项目>
mkdir -p .devin/skills
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .devin/skills/
```

### OpenCode

- **源：** `/Users/letmlook/code/letmbootstrap/skills/letmbootstrap/`
- **目标（按项目）：** `./.opencode/skills/letmbootstrap/`
- **目标（全局）：** `~/.config/opencode/skills/letmbootstrap/`

```bash
# 按项目
cd <你的项目>
mkdir -p .opencode/skills
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .opencode/skills/

# 全局
mkdir -p "$HOME/.config/opencode/skills"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$HOME/.config/opencode/skills/"
```

## 安装器做了什么，细节

```
# bash
./scripts/install.sh [--apply] [--platform <名>] [--agent-name <名>] [--symlink] [--with-templates]

# PowerShell
.\scripts\install.ps1 [-Apply] [-Platform <名>] [-AgentName <名>] [-Symlink] [-Help]
```

| bash 标志 | PowerShell 参数 | 含义 |
|---|---|---|
| *（无）* | *（无）* | 对所有检测到的平台干跑。打印计划的操作并退出。 |
| `--apply` | `-Apply` | 实际写。不加这个脚本是只读的。 |
| `--platform <名>` | `-Platform <名>` | 限制单一平台。可重复。合法：mavis、claude-code、codex、cursor、gemini-cli、aider、devin、opencode。 |
| `--agent-name <名>` | `-AgentName <名>` | 仅 Mavis —— 装到哪个 Agent 下。默认 `mavis`。 |
| `--symlink` | `-Symlink` | 用软链而不是复制。改仓库时自动生效。 |
| `--help` | `-Help` | 打印用法。 |

脚本通过看这些标记来检测安装的平台：

| 平台 | 检测标记 |
|---|---|
| `mavis` | `$HOME/.minimax/` 目录存在 |
| `claude-code` | `$HOME/.claude/` 目录存在（全局）**或** `./.claude/`（按项目） |
| `codex` | `$HOME/.codex/` 目录存在 |
| `cursor` | `./.cursor/` 目录存在（只能按项目 —— 没有全局） |
| `gemini-cli` | `$HOME/.gemini/` 目录存在 |
| `aider` | `./.aider/` 或 `$HOME/.aider/` 目录存在 |
| `devin` | `./.devin/` 目录存在（只能按项目） |
| `opencode` | `$HOME/.config/opencode/` 或 `./.opencode/` 目录存在 |

## 让你的 Agent 来装

如果你不想自己敲命令，直接告诉你的 Agent（它会读 [`INSTALL.md`](../INSTALL.md) 跑安装器）：

> 全局安装 letmbootstrap
> install letmbootstrap globally

Agent 通常有 `Bash` 工具，会自己跑 `./scripts/install.sh --apply`。完整对话模板、paste-on-invoke（无 shell Agent）、更新、软链开发模式、卸载见 [`docs/agent-driven-install.md`](agent-driven-install.md)。

## 冲突策略

如果目标路径已存在：

```
SKIP: ~/.claude/skills/letmbootstrap 已存在。要更新，手动删除后再跑 --apply。
```

脚本不替你删旧副本。如果想更新，你自己做替换（这正是"你拥有破坏性操作"的原则）。

## 软链模式

```bash
./scripts/install.sh --apply --symlink
```

或 PowerShell：

```powershell
.\scripts\install.ps1 -Apply -Symlink
```

创建 `~/.claude/skills/letmbootstrap → /Users/letmlook/code/letmbootstrap/skills/letmbootstrap`。现在仓库里每次编辑都会被你的 Agent 实时看到，不用重装。

**权衡：** 如果你移动或改名仓库，所有软链都断。用稳定的绝对路径。

**Windows 上的软链：** PowerShell 的 `New-Item -ItemType SymbolicLink` 在 Windows 上需要 **开发人员模式** 或管理员权限。如果创建失败，错误会明确指出 —— 不静默回退到复制。

## 故障排查

### "技能没被调用。"

按顺序检查：

1. **路径匹配你的 Agent 约定。** 不同 Agent 路径不同。交叉检查上表。
2. **重载。** 大多数 Agent 需要重启会话来加载新技能。
3. **触发短语。** 用文档化的触发短语之一（"letmbootstrap init"、"搭三件套"）。技能匹配靠 `description:` frontmatter。
4. **Frontmatter 解析。** 打开已装的 `SKILL.md` 确认顶部的 YAML frontmatter 完整（`name:`、`description:`）。如果你的 Agent 把文件弄坏了，重新复制。

### "它覆盖了我已有的文件。"

不应该 —— 安装器跳过冲突，技能本身在覆盖前会问。如果真发生了：

1. 查 `git status`（或你的 VCS）看实际改了什么。
2. 用精确的安装命令和目标路径报 bug。安装器对 `rm` 有静态守卫、对"无标志不写"有保护；如果发生删除，那是脚本 bug。

### "我想卸载。"

技能刻意没有卸载路径。要手动移除：

```bash
# Linux / macOS
rm -rf <安装路径>/letmbootstrap
```

```powershell
# Windows (PowerShell)
Remove-Item -Recurse -Force <安装路径>\letmbootstrap
```

这是 **你自己** 做的。技能和安装器都从不替你做。

### "我的 Agent 没列出来。"

开个 issue 并附：

- Agent 名 + 主页
- 它在哪里找技能（路径）
- 是否支持 SKILL.md frontmatter（name/description）

…我们会在兼容矩阵加一行。技能本身是可移植的 —— 只有安装目标不同。

## 重跑安装器

重跑是安全的。安装器是幂等的：在干净目标上装一次；在已有目标上跳过并报告。永不覆盖、永不删除、永不改名。

## 升级到更新版本

两种模式：

**模式 A — 手动替换**（生产推荐）：

```bash
# Linux / macOS
cd /Users/letmlook/code/letmbootstrap && git pull

# 对每个安装目标，替换目录：
cp -R skills/letmbootstrap "$HOME/.claude/skills/letmbootstrap"
```

```powershell
# Windows (PowerShell)
cd C:\path\to\letmbootstrap
git pull

# 对每个安装目标，替换目录：
Copy-Item -Recurse -Force skills\letmbootstrap $HOME\.claude\skills\letmbootstrap
```

你自己执行删除，然后复制。安装器两个都不做。

**模式 B — 开发期软链**（技能作者推荐）：

```bash
# Linux / macOS
./scripts/install.sh --apply --symlink
```

```powershell
# Windows
.\scripts\install.ps1 -Apply -Symlink
```

仓库里的编辑实时生效。仅在你积极迭代时用。

## 本指南不覆盖什么

- **卸载** — 故意不写。见决策 [`0001-keep-skill-non-destructive.md`](decisions/0001-keep-skill-non-destructive.md)。
- **跨 Agent 迁移** — v1 范围外。在新平台重装。
- **自动更新** — 范围外。手动拉 + 手动替换（或开发期软链）。