<!-- 语言：中文（默认） | English mirror: docs/agent-driven-install.en.md -->

# 让你的 Agent 装技能

本页讲的不是 **你自己** 跑 shell 命令，而是 **让 Agent 帮你装**。你的 Agent（无论 Mavis、Claude Code、Codex CLI、OpenCode）通常能直接执行 shell 命令、读文件、写文件 —— 它能自己跑 `install.sh` / `install.ps1`。

如果你想"动口不动手"，这是给 Agent 的几种安装姿势。

## 1. 直接跟 Agent 说"装一下"

大多数 Agent 都有 `Bash` 或类似工具。告诉它：

> 从 `~/code/letmbootstrap` 把 letmbootstrap 技能装到全局。
> 
> Install the letmbootstrap skill globally from `~/code/letmbootstrap`.

Agent 会：

1. 读 [`INSTALL.md`](../INSTALL.md) 或 [`docs/installation-guide.md`](installation-guide.md) 获取上下文
2. 跑 `cd ~/code/letmbootstrap && ./scripts/install.sh --apply`（Windows 是 `.\scripts\install.ps1 -Apply`）
3. 报告做了什么 —— 它会自然地引用安装器的 PLAN 输出

这是最简单也最常用的姿势。

## 2. 没有 shell 的 Agent —— 粘贴调用（paste-on-invoke）

有些 Agent 是纯对话的（Aider 默认模式、某些 Web 端 Agent）。没有 shell 也没"技能目录"。这种情况下：

1. 打开本仓库的 [`skills/letmbootstrap/SKILL.md`](../skills/letmbootstrap/SKILL.md)
2. 整段复制正文（frontmatter 后面的所有内容）
3. 粘到对话里说：

> 严格按这个流程执行。从第 1 步开始。
>
> Follow this procedure exactly. Start from Step 1.
>
> [粘贴 SKILL.md 正文]

Agent 会把粘贴的内容当作指令并执行。丑，但到处能用 —— 任何能聊天的 Agent 都能用。

## 3. 常见意图 + 跟 Agent 说的话

下表是经过整理的"对 Agent 说"模板。说中英文都能触发，技能 frontmatter 已经支持双语触发短语。

| 你想要 | 推荐说法 |
|---|---|
| 全局安装（装到所有检测到的 Agent） | "全局安装 letmbootstrap" / "install letmbootstrap globally" |
| 先看会装到哪（不真装） | "先干跑看看，不真装" / "dry-run first, don't actually install" |
| 只装一个 | "只装到 Claude Code" / "install on Claude Code only" |
| 装到指定多个平台 | "装到 Claude Code 和 Mavis" / "install on Claude Code and Mavis" |
| 更新已装的版本 | "从最新代码更新 letmbootstrap" / "update letmbootstrap from the latest" |
| 装成软链（开发模式） | "装成软链，方便我改仓库" / "make this install a symlink for dev" |
| 卸载 | "从 Claude Code 卸载 letmbootstrap" / "uninstall letmbootstrap from Claude Code" |
| 验证已装 | "letmbootstrap 装在哪？" / "where is letmbootstrap installed? Show me the SKILL.md paths." |
| 装到非默认 Agent 名 | "装到 mavis 下的 my-dev-agent Agent" / "install under mavis/my-dev-agent Agent" |

把这些说法当模板 —— Agent 拿到后，会读仓库里的安装指南并采取对应动作。

## 4. 装到多个平台（一次性）

安装器默认会装到 **所有** 检测到的平台。如果你想装到指定子集，让 Agent 跑多次：

```bash
./scripts/install.sh --apply --platform claude-code
./scripts/install.sh --apply --platform mavis
./scripts/install.sh --apply --platform cursor
```

或者直接告诉 Agent：

> 把 letmbootstrap 装到 Claude Code、Mavis 和 Cursor，跳过其他的。
>
> Install letmbootstrap on Claude Code, Mavis, and Cursor only.

Agent 会按需调多次 `--platform`。

## 5. 更新已装的版本

安装器是 **skip-on-conflict** —— 重跑不会更新已有副本。要真更新：

> 帮我更新一下 letmbootstrap 到最新版。

Agent 通常会做：

```bash
cd ~/code/letmbootstrap
git pull

# 然后替换已装的副本（用户授权后）
rm -rf ~/.claude/skills/letmbootstrap
cp -R skills/letmbootstrap ~/.claude/skills/letmbootstrap
```

> **这里 `rm -rf` 是用户明确授权的一次性操作**，不是技能或安装器做的事。技能本身严格不删任何东西；Agent 用通用的 shell 命令做手动更新 —— 由用户发号施令，Agent 执行。

Windows 上等价命令：

```powershell
Remove-Item -Recurse -Force $HOME\.claude\skills\letmbootstrap
Copy-Item -Recurse -Force skills\letmbootstrap $HOME\.claude\skills\letmbootstrap
```

## 6. 软链模式（开发用）

如果你在改技能并想实时看效果：

> 帮我把 letmbootstrap 装成软链，链到我 ~/code/letmbootstrap 这个开发目录。

Agent 跑：

```bash
./scripts/install.sh --apply --symlink
```

或 Windows：

```powershell
.\scripts\install.ps1 -Apply -Symlink
```

现在 `~/.claude/skills/letmbootstrap/` 是你开发仓库的软链。改完 SKILL.md 重启 Agent 就生效。

**注意（Windows）：** `New-Item -ItemType SymbolicLink` 在 Windows 上需要 **开发者模式** 或管理员权限。如果创建失败，错误信息会明确说 —— 不会静默回退到复制。

## 7. 验证已装

让 Agent 检查：

> 看看 letmbootstrap 装到哪里了，把 SKILL.md 路径列出来。

Agent 跑：

```bash
ls -la ~/.claude/skills/letmbootstrap/SKILL.md
ls -la ~/.minimax/agents/mavis/skills/letmbootstrap/SKILL.md
# 等
```

并把找到的路径列出来。

## 8. 卸载（用户授权的一次性操作）

技能没有卸载入口（见 [`docs/decisions/0001-keep-skill-non-destructive.md`](decisions/0001-keep-skill-non-destructive.md)），但用户可以授权 Agent 手动删：

> 帮我从 Claude Code 卸载 letmbootstrap。

Agent 会：

```bash
rm -rf ~/.claude/skills/letmbootstrap
```

或 Windows：

```powershell
Remove-Item -Recurse -Force $HOME\.claude\skills\letmbootstrap
```

**这是用户明确指令下的一次性删除。** 技能和安装器本身从不主动删除任何东西。

## 设计意图

这页背后的想法：**让 Agent 成为你和安装器之间的翻译层**，而不是强迫你直接和 shell 打交道。

- 你用自然语言
- Agent 读安装指南、跑正确命令、报告结果
- 技能本身保持严格非破坏性（[`docs/decisions/0001-keep-skill-non-destructive.md`](decisions/0001-keep-skill-non-destructive.md)）
- 破坏性操作（`rm -rf`、覆盖现有安装）由用户明确授权后 Agent 执行 —— 不是技能的功能

这样用户拿到的是"对话式安装"，同时技能本身仍然是 `rm -rf` 永远不会主动跑的安全包。

## 本页不是

- **不是 "1-click install"。** Agent 跑的还是同一个安装器，只是用户不必亲自敲键盘。
- **不是自动安装。** Agent 不会在你没说之前就装。技能从来不主动推销自己。
- **不是市场。** 还是直接来自本仓库，没有市场身份。
- **不是 skill 自己能做的。** 上面所有动作都是 **Agent 在用户的明确指令下做的**，技能本身只会在引导新项目时按 `letmbootstrap init` 触发短语被动调用。