# Installation Guide — detailed per-platform

This is the long-form companion to [`INSTALL.md`](../INSTALL.md). Read `INSTALL.md` first; come here only when you need depth, troubleshooting, or platform quirks.

## Design principles (binding)

These apply to **every** install path described below:

1. **Additive only.** Every operation is `mkdir -p` + `cp -R` (or `ln -s`). Nothing is removed, renamed, or overwritten.
2. **Skip on conflict.** If the destination already exists, the installer prints `SKIP` and moves on. It does **not** overwrite, does **not** prompt for overwrite, does **not** delete the old copy.
3. **Idempotent.** Running the installer twice produces the same final state as running it once.
4. **Dry-run by default.** The script prints what it would do and exits 0 without writing. `--apply` flips it to write mode.
5. **No `rm` anywhere in the script.** `grep -rn rm scripts/install.sh` returns no matches for destructive patterns. The script contains a static guard that aborts if asked to delete anything.
6. **No mutation of the source repo.** The installer never edits files inside `/Users/letmlook/code/letmbootstrap/` — it only reads from it.

## The skill payload

What you actually install is a single directory:

```
skills/letmbootstrap/
└── SKILL.md        # the skill definition (frontmatter + procedure)
```

Everything else in the repo (templates, docs, examples, scripts) supports the skill but is not part of the installed payload. The Agent only needs `SKILL.md` to invoke the skill; the templates and docs are referenced from inside the skill body via absolute path.

If you want a richer install (e.g., the templates alongside the skill), pass `--with-templates`. The default keeps the payload minimal.

## Platform reference

### MiniMax Code / Mavis

- **Source:** `/Users/letmlook/code/letmbootstrap/skills/letmbootstrap/`
- **Target:** `~/.minimax/agents/<agent-name>/skills/letmbootstrap/`
- **Scope:** per-Agent. Each Mavis Agent has its own skills directory.
- **Pick the Agent name:** run `mavis agent list` to see your Agents. Default is the `mavis` Agent.
- **Verification:** start a new session for that Agent; trigger with "letmbootstrap init" or "搭三件套".
- **Reload required:** yes — new sessions pick up new skills automatically; existing sessions do not.

```bash
AGENT_DIR="$HOME/.minimax/agents/mavis/skills"
mkdir -p "$AGENT_DIR"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$AGENT_DIR/"
```

### Claude Code

- **Source:** `/Users/letmlook/code/letmbootstrap/skills/letmbootstrap/`
- **Target:** `~/.claude/skills/letmbootstrap/` *(global)* or `./.claude/skills/letmbootstrap/` *(per-project)*
- **Scope:** global install is recommended — applies to every Claude Code session.
- **Verification:** restart Claude Code; trigger with "letmbootstrap init".
- **Reload required:** yes — restart the CLI.

```bash
mkdir -p "$HOME/.claude/skills"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$HOME/.claude/skills/"
```

### OpenAI Codex CLI

Codex's skill discovery has evolved across versions. Two reliable paths:

**Path A — per-project (always works):**

```bash
cd <your-project>
mkdir -p .agent-skills
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .agent-skills/
```

Then reference from `AGENTS.md` or your Codex config:

```markdown
<!-- in AGENTS.md -->
Skills available in this repo: `./.agent-skills/`. Read `<skill-name>/SKILL.md` when the trigger phrase matches.
```

**Path B — global (newer Codex versions):**

```bash
mkdir -p "$HOME/.codex/skills"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$HOME/.codex/skills/"
```

**Path C — paste-on-invoke (universal fallback):**

If neither path works, copy `SKILL.md` into the chat when you want to invoke it. No install needed.

### Cursor

- **Source:** `/Users/letmlook/code/letmbootstrap/skills/letmbootstrap/`
- **Target:** `./.cursor/skills/letmbootstrap/` *(per-project only)*
- **Scope:** Cursor doesn't have a global skills directory — install in each project.
- **Verification:** restart the Cursor session in that project.

```bash
cd <your-project>
mkdir -p .cursor/skills
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .cursor/skills/
```

### Gemini CLI

- **Source:** `/Users/letmlook/code/letmbootstrap/skills/letmbootstrap/`
- **Target:** `~/.gemini/skills/letmbootstrap/`
- **Scope:** global.
- **Reload required:** restart Gemini CLI.

```bash
mkdir -p "$HOME/.gemini/skills"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$HOME/.gemini/skills/"
```

### Aider

Aider has no formal skills directory. Two workable patterns:

**Pattern A — convention file:**

```bash
cd <your-project>
mkdir -p .aider
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .aider/skills/

# Add to .aider/conventions.md (Aider reads this automatically):
cat >> .aider/conventions.md <<'EOF'

## Available skills
When asked to "letmbootstrap init" / "搭三件套" / "init methodology":
read `.aider/skills/letmbootstrap/SKILL.md` and follow its procedure exactly.
EOF
```

**Pattern B — paste-on-invoke:** copy `SKILL.md` body into chat when needed.

### Devin

- **Source:** `/Users/letmlook/code/letmbootstrap/skills/letmbootstrap/`
- **Target:** `./.devin/skills/letmbootstrap/` *(per-project)*
- **Scope:** Devin reads project-local `.devin/` files. Per-project install.
- **Verification:** reference the path in your Devin session prompt.

```bash
cd <your-project>
mkdir -p .devin/skills
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .devin/skills/
```

### OpenCode

- **Source:** `/Users/letmlook/code/letmbootstrap/skills/letmbootstrap/`
- **Target (per-project):** `./.opencode/skills/letmbootstrap/`
- **Target (global):** `~/.config/opencode/skills/letmbootstrap/`

```bash
# Per-project
cd <your-project>
mkdir -p .opencode/skills
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap .opencode/skills/

# Global
mkdir -p "$HOME/.config/opencode/skills"
cp -R /Users/letmlook/code/letmbootstrap/skills/letmbootstrap "$HOME/.config/opencode/skills/"
```

## What the installer does, in detail

```
./scripts/install.sh [--apply] [--platform <name>] [--agent-name <name>] [--symlink] [--with-templates]
```

| Flag | Meaning |
|---|---|
| *(none)* | Dry-run for every detected platform. Prints planned ops and exits. |
| `--apply` | Actually write. Without this, the script is read-only. |
| `--platform <name>` | Restrict to one platform. Valid: `mavis`, `claude-code`, `codex`, `cursor`, `gemini-cli`, `aider`, `devin`, `opencode`. Repeatable. |
| `--agent-name <name>` | For Mavis only — which Agent to install under. Defaults to `mavis`. |
| `--symlink` | Symlink instead of copy. Lets you edit the repo and have changes reflected live. |
| `--with-templates` | Also install `templates/` and a copy of `docs/methodology.md` next to the skill. Off by default — keeps the payload minimal. |
| `--help` | Print usage. |

The script detects installed platforms by looking for these markers:

| Platform | Detection marker |
|---|---|
| `mavis` | `$HOME/.minimax/` directory exists |
| `claude-code` | `$HOME/.claude/` directory exists (global) **or** `./.claude/` (per-project) |
| `codex` | `$HOME/.codex/` directory exists |
| `cursor` | `./.cursor/` directory exists (per-project only — there's no global) |
| `gemini-cli` | `$HOME/.gemini/` directory exists |
| `aider` | `./.aider/` or `$HOME/.aider/` directory exists |
| `devin` | `./.devin/` directory exists (per-project only) |
| `opencode` | `$HOME/.config/opencode/` or `./.opencode/` directory exists |

## Conflict policy

If the target path already exists:

```
SKIP: ~/.claude/skills/letmbootstrap already exists. To update, remove manually then re-run with --apply.
```

The script does not delete the existing copy for you. If you want to update, you do the replacement yourself (which is exactly the "you own destructive ops" principle).

## Symlink mode

```bash
./scripts/install.sh --apply --symlink
```

Creates `~/.claude/skills/letmbootstrap → /Users/letmlook/code/letmbootstrap/skills/letmbootstrap`. Now every edit in the repo is picked up live by your Agent without re-installing.

**Trade-off:** if you move or rename the repo, every symlink breaks. Use a stable absolute path.

## Troubleshooting

### "The skill isn't being invoked."

Check, in order:

1. **Path matches your Agent's convention.** Different Agents use different paths. Cross-check the table above.
2. **Reload.** Most Agents need a session restart to pick up new skills.
3. **Trigger phrase.** Use one of the documented trigger phrases ("letmbootstrap init", "搭三件套"). The skill's `description:` frontmatter is what matches.
4. **Frontmatter parsing.** Open the installed `SKILL.md` and confirm the YAML frontmatter at the top is intact (`name:`, `description:`). If your Agent mangled the file, re-copy it.

### "It overwrote my existing files."

It shouldn't have — the installer skips on conflict and the skill itself asks before overwriting. If this happened:

1. Check `git status` (or your VCS) for what actually changed.
2. Report a bug with the exact install command and target path. The installer has a static guard against `rm` and against writes-without-flag; if a delete happened, that's a script bug.

### "I want to uninstall."

The skill has no uninstall path on purpose. To remove manually:

```bash
rm -rf <install-path>/letmbootstrap
```

This is something **you** do. The skill and installer never do it for you.

### "My Agent isn't listed."

Open an issue with:

- Agent name + homepage
- Where it looks for skills (path)
- Whether it supports SKILL.md frontmatter (name/description)

… and we'll add a row to the compatibility matrix. The skill itself is portable — only the install target differs.

## Re-running the installer

Re-running is safe. The installer is idempotent: on a clean target, it installs once; on a populated target, it skips and reports. It never overwrites, never deletes, never renames.

## Updating to a newer version

Two patterns:

**Pattern A — manual replace** (recommended for production):

```bash
cd /Users/letmlook/code/letmbootstrap && git pull

# For each install target you have, replace the directory:
cp -R skills/letmbootstrap "$HOME/.claude/skills/letmbootstrap"
```

You do the `rm -rf` yourself, then `cp -R`. The installer doesn't do either.

**Pattern B — symlink during development** (recommended for skill authors):

```bash
./scripts/install.sh --apply --symlink
```

Edits in the repo are picked up live. Use only when you're actively iterating.

## What this guide does NOT cover

- Uninstall — intentionally absent. See the decision note [`0001-keep-skill-non-destructive.md`](decisions/0001-keep-skill-non-destructive.md).
- Migration between Agents — out of scope for v1. Reinstall on the new platform.
- Auto-update — out of scope. Pull + manual replace (or symlink during dev).