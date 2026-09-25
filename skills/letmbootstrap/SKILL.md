---
name: letmbootstrap
description: Use when initializing a new project (or retrofitting an existing project) with the letmbootstrap collaboration methodology — installs the AGENTS.md constitution, docs/decisions/ decision log, and skills/ scaffolding so the project follows the 4-piece anti-drift setup. Trigger phrases include "letmbootstrap init", "init methodology", "bootstrap letmbootstrap", "搭三件套", "初始化方法论", "letmbootstrap 初始化", and any request to apply the methodology template to a project. Do NOT use this skill for projects that are already initialized — check first.
---

# Bootstrapping the letmbootstrap Methodology

Install the letmbootstrap 4-piece set (`AGENTS.md` + `docs/decisions/` + `skills/`) into a target project so that an Agent working in that project follows the anti-drift discipline from day one.

The source of truth for the methodology lives at `/Users/letmlook/code/letmbootstrap/`. Read `templates/`, `docs/methodology.md`, and the example `AGENTS.md` from there before doing anything.

If you arrived here because you want to **install the letmbootstrap skill itself into your Agent platform** (Claude Code, MiniMax Code, Codex CLI, etc.) instead of installing the methodology into a project, read [`INSTALL.md`](../../INSTALL.md) instead — that path is non-destructive and platform-specific. This SKILL.md assumes the skill is already installed.

## Hard rules — non-destructive by default

These rules apply to **every step below**. They cannot be overridden by user request without an explicit, confirmed, separate consent for each file affected.

1. **Never `rm`, `unlink`, `mv`, or otherwise delete an existing file.** The skill has no uninstall path. If a user asks to remove a previously installed file, refuse and point them at manual cleanup.
2. **Never overwrite an existing file without per-file explicit consent.** "Initialize my project" does not grant consent to overwrite `AGENTS.md` if one already exists. Each overwrite requires its own confirmation.
3. **Default to additive operations only.** New files are fine; replacements require consent; deletions are forbidden.
4. **Idempotent: re-running the skill is safe.** Running the bootstrap twice on a clean target produces the same result. Running it twice on an initialized target is a no-op (after reporting current state).
5. **Detect-before-write.** Step 1 is mandatory and read-only. If the target already has the 4-piece set in working order, the skill reports "already initialized" and exits without writing anything.

## When to use this skill

**Use it when:**

- User explicitly asks to "letmbootstrap init", "bootstrap letmbootstrap", "init methodology", "搭三件套", "初始化方法论"
- User asks to apply the letmbootstrap template to a project
- User asks "set up this project for Agent collaboration"

**Don't use it when:**

- Target project already has AGENTS.md and docs/decisions/ — instead, point the user to the existing files
- User wants only one piece (e.g., just AGENTS.md) — ask whether to install the full set
- User is asking about the methodology itself — point them to `docs/methodology.md`
- User wants to **install the letmbootstrap skill itself** into a different Agent platform — point them at `INSTALL.md`

## Inputs

- `target_dir` (required): absolute path to the project root. Default: current working directory if it looks like a project root.
- `project_meta` (gathered from user): see Step 2 below.

If the user did not specify a target directory, default to the current working directory **only if** it contains a project marker (`package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `README.md`, `.git/`, etc.). Otherwise ask.

## Process

### Step 1: Pre-flight check (read-only)

Before any write:

1. **Verify target_dir exists and is writable.**
2. **Detect current state:**
   ```bash
   ls -la <target_dir>/AGENTS.md              # already has constitution?
   ls <target_dir>/docs/decisions/ 2>/dev/null # already has decision log?
   ls <target_dir>/skills/ <target_dir>/.agent-skills/ <target_dir>/.claude/skills/ 2>/dev/null
   ```
3. **If all three pieces exist and look intentional** → tell the user "this project is already initialized" and stop. Don't overwrite.
4. **If some pieces exist** → ask the user before overwriting each one. Default behavior is to leave existing files alone (additive only).
5. **If nothing exists** → proceed to Step 2.

This step is read-only. No `rm`, no `mv`, no writes.

### Step 2: Gather project metadata

Ask the user 5 short questions. Keep them concise; use the question UI, not a long paragraph.

1. **What's the project's one-line purpose?** (verb + noun + audience)
   - Example: "A CLI that converts markdown to Notion pages."
2. **What's the stack?** (language, runtime, framework, package manager, test runner)
   - Example: "TypeScript 5 / Node 22 / Hono / pnpm / vitest"
3. **What must this project NOT do?** (2-4 anti-goals)
   - Example: "No web UI. No multi-user auth. No cloud sync."
4. **Where does new code go?** (extension map; if user is unsure, propose a default based on the stack and ask for confirmation)
5. **Are there existing docs to link from AGENTS.md?** (README, architecture doc, contributing guide)

If the user says "I don't know" or "you decide" on any question, propose sensible defaults and ask for confirmation.

### Step 3: Preview what will be written

Before writing anything, show the user a preview that makes the non-destructive guarantee explicit:

```
Will CREATE (additive, safe to re-run):
  <target_dir>/AGENTS.md                            (~30 lines, customized)
  <target_dir>/docs/decisions/                      (directory)
  <target_dir>/docs/decisions/0001-bootstrap.md     (initial decision)
  <target_dir>/docs/decisions/README.md             (decision format guide)
  <target_dir>/.agent-skills/                       (or skills/ — ask user)
  <target_dir>/.agent-skills/README.md              (links back to letmbootstrap)
  <target_dir>/.agent-skills/single-task-contract.md (task contract template)

Will NOT touch:
  <list of existing files that won't be modified>

Will NOT do (no matter what):
  - rm / unlink / mv of any existing file
  - overwrite without per-file consent
  - touch anything outside <target_dir>
```

Ask the user: "Proceed with this bootstrap?" Use the question UI with explicit confirmation. **Do not proceed without explicit confirmation.**

If the user requests a different skills directory name (`skills/` instead of `.agent-skills/`, or `.claude/skills/`), respect that choice.

### Step 4: Write the files (additive only)

Order matters — each subsequent file may reference earlier ones.

1. **`AGENTS.md`** at `<target_dir>/AGENTS.md`:
   - Read template: `templates/AGENTS.md.template` from the letmbootstrap repo
   - Substitute: project name, stack, anti-goals, extension map, doc links
   - Keep it ≤ 200 lines — if it grows, push detail into `docs/`
   - **If `<target_dir>/AGENTS.md` already exists, stop and ask for consent.** Do not overwrite silently.

2. **`docs/decisions/README.md`** at `<target_dir>/docs/decisions/README.md`:
   - Brief explanation of the decision log format
   - Copy content from `docs/methodology.md` "## Decision lifecycle" section
   - Link back to the letmbootstrap repo
   - **If `<target_dir>/docs/decisions/README.md` already exists, skip and report.** Do not overwrite.

3. **`docs/decisions/0001-bootstrap-with-letmbootstrap.md`**:
   - Read template: `templates/decision.md.template`
   - Fill in:
     - **Context:** the project is adopting letmbootstrap methodology
     - **Decision:** install the 4-piece set
     - **Consequences:** project follows letmbootstrap anti-drift discipline
     - **Alternatives considered:** ad-hoc decisions, no methodology, status quo
   - **If a file with this name already exists, append a numeric suffix (0002, 0003, …) instead of overwriting.**

4. **Skills directory** at `<target_dir>/.agent-skills/` (or user's preferred name):
   - **`README.md`** — explains the directory, links back to letmbootstrap, mentions the single-task contract
   - **`single-task-contract.md`** — copy of `templates/single-task-contract.md`
   - Optionally add a `pre-commit-checks.md` if the user has a stack with known gates (TypeScript → typecheck + lint; Python → ruff + pytest; etc.)
   - **If the skills directory already exists, copy files in but skip any that already exist.** Do not overwrite.

### Step 5: Verify and report

After all files are written:

1. Run `ls -laR <target_dir>/AGENTS.md <target_dir>/docs/ <target_dir>/.agent-skills/` (or chosen skills dir) and confirm the structure.
2. Show the user a tree of what was created.
3. Show the customized `AGENTS.md` content so they can review.
4. Remind them: "Next time you give the Agent a non-trivial task, fill the single-task contract first."

## Stop conditions

Abort cleanly if any of the following:

- User declines the preview
- Target directory is not writable
- Existing files would be overwritten without explicit consent
- User says "stop" or "not now" at any step
- User asks to delete or remove any existing file — refuse and explain why

## Acceptance criteria

The bootstrap is complete when:

- `AGENTS.md` exists at the target root, customized to the project, ≤ 200 lines
- `docs/decisions/` contains `README.md` + `0001-bootstrap-with-letmbootstrap.md` (or next available number)
- Skills directory exists with `README.md` + `single-task-contract.md`
- User has reviewed each created file and confirmed
- No existing files were modified or deleted, period

## Failure handling

If a file write fails:

1. Report the exact error and the file path.
2. Suggest the fix (permissions, parent dir, etc.).
3. Don't silently retry — the user may need to intervene.

If the customization produces an awkward `AGENTS.md` (e.g., user gave very vague answers), surface that and offer to refine. Don't ship a generic-looking constitution.

If a user asks for an operation that would delete or overwrite an existing file:

1. Refuse clearly. Quote the non-destructive guarantee.
2. Offer the closest safe alternative (e.g., "I can create a sibling file with a new name, or write the new content to a temporary file you can review").
3. Do not attempt the operation, even if the user insists, until they re-confirm with full understanding that the skill explicitly does not support deletion.

## Post-bootstrap reminder (give to user)

After success, tell the user:

> **Daily reminder:** every time you give the Agent a non-trivial task, fill a single-task contract first (`.agent-skills/single-task-contract.md`). It's 30 seconds of typing and saves ~30 minutes of re-orientation per task.
>
> **Weekly reminder:** when you make a non-trivial decision (anything you'll need to re-decide later), write a decision note (`docs/decisions/NNNN-<title>.md`). It's the only way the Agent will know not to re-litigate it.
>
> **Re-running is safe.** You can run the skill again later to add pieces you skipped. It will not delete or overwrite anything without explicit consent.