<!-- English mirror | 中文默认版本: docs/agent-driven-install.md -->

# Ask your Agent to install

This page is not about **you** running shell commands — it's about **having your Agent do it for you**. Your Agent (Mavis, Claude Code, Codex CLI, OpenCode, etc.) usually has direct shell access, file read/write — it can run `install.sh` / `install.ps1` itself.

If you'd rather talk than type, these are the install patterns for Agent-driven use.

## 1. Just tell your Agent to install

Most Agents have a `Bash` tool or equivalent. Tell it:

> Install the letmbootstrap skill globally from `~/code/letmbootstrap`.

The Agent will:

1. Read [`INSTALL.md`](../INSTALL.md) or [`docs/installation-guide.md`](installation-guide.md) for context
2. Run `cd ~/code/letmbootstrap && ./scripts/install.sh --apply` (or `.\scripts\install.ps1 -Apply` on Windows)
3. Report what it did — it will naturally cite the installer's PLAN output

This is the simplest and most common pattern.

## 2. No-shell Agents — paste-on-invoke

Some Agents are pure chat (Aider in default mode, some web-based Agents). No shell, no skills directory. In that case:

1. Open [`skills/letmbootstrap/SKILL.md`](../skills/letmbootstrap/SKILL.md) from this repo
2. Copy the entire body (everything after the frontmatter)
3. Paste into the chat:

> Follow this procedure exactly. Start from Step 1.
>
> [paste SKILL.md body here]

The Agent treats the pasted content as instructions and executes them. Ugly but works everywhere — any chat-capable Agent can use this.

## 3. Common intents + what to say

Curated "say to Agent" templates below. Both Chinese and English trigger the skill — the frontmatter supports bilingual triggers.

| You want | Recommended phrasing |
|---|---|
| Global install (all detected Agents) | "全局安装 letmbootstrap" / "install letmbootstrap globally" |
| Dry-run first | "先干跑看看，不真装" / "dry-run first, don't actually install" |
| One platform only | "只装到 Claude Code" / "install on Claude Code only" |
| Multiple specific platforms | "装到 Claude Code 和 Mavis" / "install on Claude Code and Mavis" |
| Update existing | "从最新代码更新 letmbootstrap" / "update letmbootstrap from the latest" |
| Symlink for dev | "装成软链，方便我改仓库" / "make this install a symlink for dev" |
| Uninstall | "从 Claude Code 卸载 letmbootstrap" / "uninstall letmbootstrap from Claude Code" |
| Verify install | "letmbootstrap 装在哪？" / "where is letmbootstrap installed? Show me the SKILL.md paths." |
| Install under a specific Agent name | "装到 mavis 下的 my-dev-agent Agent" / "install under mavis/my-dev-agent Agent" |

Treat these as templates — once the Agent reads the install guide, it picks the right action.

## 4. Install on multiple platforms at once

The installer installs to **all** detected platforms by default. To install on a specific subset, have the Agent run multiple times:

```bash
./scripts/install.sh --apply --platform claude-code
./scripts/install.sh --apply --platform mavis
./scripts/install.sh --apply --platform cursor
```

Or just tell the Agent:

> Install letmbootstrap on Claude Code, Mavis, and Cursor only. Skip the others.

The Agent calls `--platform` once per target.

## 5. Update an existing install

The installer is **skip-on-conflict** — re-running doesn't update existing copies. To actually update:

> Help me update letmbootstrap to the latest version.

The Agent typically does:

```bash
cd ~/code/letmbootstrap
git pull

# Then replace the existing copy (after user authorization)
rm -rf ~/.claude/skills/letmbootstrap
cp -R skills/letmbootstrap ~/.claude/skills/letmbootstrap
```

> The `rm -rf` here is a one-off operation explicitly authorized by the user, not something the skill or installer does. The skill itself never deletes anything; the Agent uses generic shell commands for manual updates — user directs, Agent executes.

Windows equivalent:

```powershell
Remove-Item -Recurse -Force $HOME\.claude\skills\letmbootstrap
Copy-Item -Recurse -Force skills\letmbootstrap $HOME\.claude\skills\letmbootstrap
```

## 6. Symlink mode (for development)

If you're iterating on the skill and want changes live:

> Make this install a symlink from my dev checkout at `~/code/letmbootstrap`.

The Agent runs:

```bash
./scripts/install.sh --apply --symlink
```

or Windows:

```powershell
.\scripts\install.ps1 -Apply -Symlink
```

Now `~/.claude/skills/letmbootstrap/` is a symlink to your dev checkout. Edit `SKILL.md`, restart the Agent, changes are live.

**Note (Windows):** `New-Item -ItemType SymbolicLink` on Windows requires **Developer Mode** or admin privileges. If creation fails, the error message is explicit — no silent fallback to copy.

## 7. Verify the install

Ask the Agent:

> Where is letmbootstrap installed? Show me the SKILL.md paths.

The Agent runs:

```bash
ls -la ~/.claude/skills/letmbootstrap/SKILL.md
ls -la ~/.minimax/agents/mavis/skills/letmbootstrap/SKILL.md
# etc.
```

and lists what it finds.

## 8. Uninstall (user-authorized one-off)

The skill has no uninstall entry (see [`docs/decisions/0001-keep-skill-non-destructive.md`](decisions/0001-keep-skill-non-destructive.md)), but the user can authorize the Agent to manually remove:

> Help me uninstall letmbootstrap from Claude Code.

The Agent runs:

```bash
rm -rf ~/.claude/skills/letmbootstrap
```

or Windows:

```powershell
Remove-Item -Recurse -Force $HOME\.claude\skills\letmbootstrap
```

**This is a user-authorized one-off deletion.** The skill and installer themselves never proactively delete anything.

## Design intent

The idea behind this page: **let the Agent be the translation layer between you and the installer**, rather than forcing you to interact with the shell directly.

- You speak in natural language
- The Agent reads the install guide, runs the right command, reports results
- The skill itself stays strictly non-destructive ([decision 0001](decisions/0001-keep-skill-non-destructive.md))
- Destructive operations (`rm -rf`, overwriting existing installs) are performed by the Agent only after explicit user authorization — not as a skill feature

The user gets "conversational install" while the skill itself remains a safe package that will never run `rm -rf` on its own.

## What this isn't

- **Not "1-click install".** The Agent runs the same installer; you just don't have to type the commands yourself.
- **Not automatic.** The Agent won't install it without being asked. The skill never pushes itself.
- **Not a market.** Still direct from this repo, no marketplace identity.
- **Not something the skill does on its own.** All of the above is the Agent acting on **explicit user instruction**. The skill itself only activates in response to the `letmbootstrap init` trigger phrase when initializing a new project.