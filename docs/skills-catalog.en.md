# Skills catalog

The repo currently ships one skill. This page documents that skill and explains how to write more.

## Shipped skills

### `letmbootstrap` — bootstrap the methodology into a target project

**Trigger phrases:** `letmbootstrap init`, `bootstrap letmbootstrap`, `init methodology`, `搭三件套`, `初始化方法论`, `letmbootstrap 初始化`.

**What it does:** installs `AGENTS.md` + `docs/decisions/` + `skills/` scaffolding into a target project, customized via 5 questions, with explicit consent before any write.

**When to invoke:** when starting a new project or retrofitting an existing one that doesn't yet have the 4-piece anti-drift setup.

**When NOT to invoke:** the target already has AGENTS.md and docs/decisions/. Or the user wants to install the letmbootstrap skill itself onto a different Agent platform — that's `INSTALL.md`, not this skill.

**File:** [`skills/letmbootstrap/SKILL.md`](../skills/letmbootstrap/SKILL.md)

**Guarantees:**

- Never `rm`, `unlink`, `mv`, or overwrite without per-file explicit consent
- Skip-on-conflict
- Idempotent
- Read-only Step 1 (preflight)

**Anti-patterns to refuse:**

- "Reset this project" — the skill has no reset path
- "Force overwrite" — refused, must be per-file
- "Uninstall" — refused, see decision 0001

---

## How to write a new skill

A new skill is a new directory under `skills/<skill-name>/SKILL.md` with YAML frontmatter and a step-by-step procedure.

### Frontmatter contract

```markdown
---
name: <skill-name>
description: Use when <specific trigger phrase> — <one-line summary>.
---
```

The `description:` field is the **most important** part. It determines whether the Agent ever invokes the skill.

| Good description | Bad example |
|---|---|
| `Use when running pre-push checks before submitting a PR — runs the narrow test suite and linters that cover the diff.` | `Useful for code review.` |
| `Use when the user says "letmbootstrap init" or asks to install the 4-piece anti-drift setup.` | `For bootstrap.` |
| `Use when debugging a flaky test in this repo — runs 10x in isolation, quiesces, restores state.` | `For debugging.` |

The good examples have:

- A specific **trigger** ("running pre-push checks before submitting a PR")
- A specific **action** ("runs the narrow test suite")
- A specific **outcome** ("covers the diff")

The bad examples have none of these.

### Body structure

The body should follow this template:

```markdown
# <Skill Title>

<One-paragraph summary of what this skill does and why.>

## When to use this skill

**Use it when:**
- <trigger condition>

**Don't use it when:**
- <out-of-scope condition>

## Hard rules — non-destructive by default

1. Never rm / unlink / mv existing files.
2. Never overwrite without per-file consent.
3. Default to additive operations.
4. Idempotent.
5. Detect-before-write.

## Inputs

- `<input_name>` (required): <description>

## Process

### Step 1: Pre-flight check (read-only)

<bash commands>

### Step 2: <next step>

<procedure>

## Stop conditions

- <abort triggers>

## Acceptance criteria

- [ ] <observable>
- [ ] <observable>

## Failure handling

<what to do when a step fails>

## Post-skill reminder (give to user)

<what the user should remember after the skill runs>
```

The template is not mandatory, but **Hard rules — non-destructive by default** is. Every new skill must include it as the second section, and it must contain the same five rules as the letmbootstrap skill. This is enforced by the [`docs/decisions/0001-keep-skill-non-destructive.md`](decisions/0001-keep-skill-non-destructive.md) decision.

### Examples of skills to write next

These are candidates for future skills — but **don't write them until they're needed by a real project**:

- `pre-push-checks` — narrow test + lint selection before push
- `code-review` — what to check in a PR for a given project
- `debug-flaky-test` — isolation, quiescence, restoration
- `release-checklist` — version bump, changelog, tags
- `incident-postmortem` — what to write after an incident
- `benchmark-regression` — detect and bisect perf regressions

The rule (per the AGENTS.md): don't add templates or skills for things not yet used by a real project. Wait for a real use case.

## Adding a skill to this repo

1. Create `skills/<skill-name>/SKILL.md`.
2. Add a row to the catalog above.
3. If the skill needs an install path that doesn't exist yet, extend `scripts/install.sh` with a new platform detector (and update [`docs/agent-compatibility.md`](agent-compatibility.md)).
4. Verify the frontmatter renders correctly: `head -5 skills/<skill-name>/SKILL.md` should show `name:` and `description:` on consecutive lines.

## What this catalog is not

- **Not a marketplace.** Skills in this repo are not published anywhere else.
- **Not a registry.** The catalog only lists skills that ship from this repo. User-project skills live in the user project's own `skills/` directory and are not cataloged here.