<!-- English mirror | 中文默认版本: INSTALL.md -->

# INSTALL — put the letmbootstrap skill on your Agent

> **One-page guide.** Want details? See [`docs/installation-guide.md`](docs/installation-guide.md). Want to know which platforms are supported? See [`docs/agent-compatibility.md`](docs/agent-compatibility.md).

## What this installs

This repo ships **one Agent skill** named `letmbootstrap`. Once installed, your Agent can invoke it on any project to scaffold the 4-piece anti-drift setup (`AGENTS.md` + `docs/decisions/` + `skills/` + single-task contract).

The skill itself is **additive and non-destructive**. It never deletes or overwrites your files. Re-running the installer is always safe. There is no uninstall path on purpose.

## Pick your Agent

| Agent | Path | One-liner |
|---|---|---|
| **MiniMax Code / Mavis** | `~/.minimax/agents/<your-agent>/skills/` | see [§ Mavis](#minimax-code--mavis) |
| **Claude Code** | `~/.claude/skills/` | see [§ Claude Code](#claude-code) |
| **OpenAI Codex CLI** | `~/.codex/skills/` *(if available)* or symlink into a project | see [§ Codex](#openai-codex-cli) |
| **Cursor** | `.cursor/skills/` *(per-project)* | see [§ Cursor](#cursor) |
| **Gemini CLI** | `~/.gemini/skills/` | see [§ Gemini CLI](#gemini-cli) |
| **Aider** | `.aider/skills/` *(per-project)* | see [§ Aider](#aider) |
| **Devin** | `.devin/skills/` *(per-project)* | see [§ Devin](#devin) |
| **OpenCode** | `.opencode/skills/` or `~/.config/opencode/skills/` | see [§ OpenCode](#opencode) |

> Not listed? Open an issue with your platform's skill path and we'll add a row. The skill itself is portable — only the install path differs.

## Quick install (recommended)

The installer is **dry-run by default** — it prints what it would do and exits without writing anything. To actually install, pass the apply flag.

### Linux / macOS (bash)

```bash
# from inside the letmbootstrap repo
cd /Users/letmlook/code/letmbootstrap

# 1. See what would happen on your machine
./scripts/install.sh

# 2. Install globally for the detected platform(s)
./scripts/install.sh --apply

# 3. Install for a specific platform only
./scripts/install.sh --apply --platform claude-code
./scripts/install.sh --apply --platform mavis
./scripts/install.sh --apply --platform codex

# 4. Install into a specific Agent name (Mavis only)
./scripts/install.sh --apply --platform mavis --agent-name my-dev-agent

# 5. Symlink instead of copy (picks up repo edits automatically)
./scripts/install.sh --apply --symlink
```

### Windows (PowerShell)

```powershell
# from inside the letmbootstrap repo
cd C:\path\to\letmbootstrap

# 1. See what would happen on your machine
.\scripts\install.ps1

# 2. Install globally for the detected platform(s)
.\scripts\install.ps1 -Apply

# 3. Install for a specific platform only
.\scripts\install.ps1 -Apply -Platform claude-code
.\scripts\install.ps1 -Apply -Platform mavis
.\scripts\install.ps1 -Apply -Platform codex

# 4. Install into a specific Agent name (Mavis only)
.\scripts\install.ps1 -Apply -Platform mavis -AgentName my-dev-agent

# 5. Symlink instead of copy (picks up repo edits automatically)
.\scripts\install.ps1 -Apply -Symlink
```

> Either Windows PowerShell 5.1 or PowerShell Core 7+ works. Windows 10 1809+ ships with `pwsh`; older versions need to install PowerShell Core first.

## Shared guarantees (both scripts enforce)

The installer:

- ✅ Detects which platforms exist on your machine
- ✅ Copies `skills/letmbootstrap/` into the right location
- ✅ Skips any existing installation (no overwrites, no deletes)
- ✅ Reports skipped locations so you can investigate
- ❌ Never runs `rm`, `unlink`, `Remove-Item`, `Move-Item`, or anything destructive
- ❌ Never overwrites an existing skill

## Manual install (no script)

If you'd rather do it by hand:

### MiniMax Code / Mavis

```bash
# Pick which Agent should host the skill (e.g., your default dev agent)
AGENT_DIR="$HOME/.minimax/agents/<your-agent-name>/skills"

mkdir -p "$AGENT_DIR"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$AGENT_DIR/"

# Verify
ls "$AGENT_DIR/letmbootstrap/SKILL.md"
```

Reload the Agent session so it picks up the new skill. Trigger it with: "letmbootstrap init" or "搭三件套".

**Windows PowerShell version:**

```powershell
$agentDir = Join-Path $HOME ".minimax/agents/<your-agent-name>/skills"
New-Item -ItemType Directory -Path $agentDir -Force | Out-Null
Copy-Item -Recurse `
    C:\path\to\letmbootstrap\skills\letmbootstrap `
    $agentDir
Get-ChildItem "$agentDir\letmbootstrap\SKILL.md"
```

### Claude Code

```bash
# Global install — applies to every Claude Code session
mkdir -p "$HOME/.claude/skills"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$HOME/.claude/skills/"

# Verify
ls "$HOME/.claude/skills/letmbootstrap/SKILL.md"
```

Restart Claude Code. Trigger it with: "letmbootstrap init".

### OpenAI Codex CLI

Codex CLI's skill support depends on your version. Two options:

```bash
# Option A: per-project (most reliable)
cd <your-project>
mkdir -p .agent-skills
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .agent-skills/
# Then point Codex at it via AGENTS.md or config — see docs/installation-guide.md

# Option B: global, if your Codex version supports ~/.codex/skills/
mkdir -p "$HOME/.codex/skills"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$HOME/.codex/skills/"
```

If Codex doesn't yet load external skills on your version, fall back to inline-invocation: paste the skill body into chat and say "follow this procedure."

### Cursor

```bash
# Per-project only — Cursor doesn't have a global skills dir
cd <your-project>
mkdir -p .cursor/skills
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .cursor/skills/
```

Cursor picks up `.cursor/skills/` from the project root. Restart the session.

### Gemini CLI

```bash
mkdir -p "$HOME/.gemini/skills"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$HOME/.gemini/skills/"
```

### Aider

Aider has no native skills directory. Two options:

```bash
# Option A: per-project convention file
cd <your-project>
mkdir -p .aider/skills
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .aider/skills/
# Then add to .aider/conventions.md or .aider/README.md:
# "When asked to 'letmbootstrap init', read .aider/skills/letmbootstrap/SKILL.md"

# Option B: paste-on-invoke — copy the SKILL.md body into chat when needed.
```

### Devin

```bash
# Per-project
cd <your-project>
mkdir -p .devin/skills
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .devin/skills/
```

Devin reads `.devin/` files per session. Reference the skill path in the session prompt.

### OpenCode

```bash
# Per-project (preferred for OpenCode)
cd <your-project>
mkdir -p .opencode/skills
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .opencode/skills/

# OR global
mkdir -p "$HOME/.config/opencode/skills"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$HOME/.config/opencode/skills/"
```

## Verify it worked

After install, ask your Agent any of:

- "letmbootstrap init" (English)
- "搭三件套" (Chinese)
- "initialize methodology"
- "bootstrap letmbootstrap"

If the skill is installed correctly, the Agent will recognize the trigger phrase and begin the guided setup flow without you having to paste the SKILL.md body.

## What if I want to remove it later?

This installer does not provide an uninstall command. That's intentional — see [`docs/decisions/0001-keep-skill-non-destructive.md`](docs/decisions/0001-keep-skill-non-destructive.md) for the rationale.

To remove manually:

```bash
# Just delete the installed copy. The installer never touched anything else.
rm -rf "$HOME/.claude/skills/letmbootstrap"
# (or whatever path you installed to)
```

**Windows PowerShell:**

```powershell
Remove-Item -Recurse -Force "$HOME\.claude\skills\letmbootstrap"
```

This is something **you** do, not something the skill does.

## Updating the skill

The installer is safe to re-run. It skips existing installations, so to pull in upstream changes:

```bash
# 1. Pull the latest letmbootstrap repo
cd /Users/letmlook/code/letmbootstrap && git pull

# 2. Manually replace the installed copy with the new one
cp -R skills/letmbootstrap "$HOME/.claude/skills/letmbootstrap"
```

Or, for development, install once with `--symlink` (bash) or `-Symlink` (PowerShell) so every repo edit is picked up live (no re-install needed).

## Next step

After the skill is installed, you use it by saying one of the trigger phrases inside a project directory. The skill will guide the rest. See [`docs/methodology.md`](docs/methodology.md) for the full narrative.