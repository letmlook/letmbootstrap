# AGENTS.md — letmbootstrap (example output)

> This is an **example** of what the letmbootstrap skill produces. The canonical, real version lives at [`AGENTS.md`](../../AGENTS.md) in the repo root.

## Project is

A reusable collaboration methodology template for solo + Agent iterative development. Packages the 4-piece anti-drift setup + bootstrap skill so a new project can adopt the discipline in ~10 minutes.

## Stack

- Language: Markdown
- Runtime: None (documentation + shell + skill definition only)
- Framework: None
- Package manager: None
- Test: None (manually verified via `./scripts/install.sh --dry-run`)

## Project is NOT

- Not a runtime framework, CLI, or library — just docs + templates + a skill.
- Not coupled to any specific Agent platform.
- Not a "methodology encyclopedia" — keep each artifact short and opinionated.

## Required reading (in order)

1. [`README.md`](../../README.md) — what's in here and why
2. [`docs/methodology.md`](../../docs/methodology.md) — the full narrative
3. [`templates/`](../../templates/) — the three templates to copy
4. [`skills/letmbootstrap/SKILL.md`](../../skills/letmbootstrap/SKILL.md) — the install procedure

## Where new code goes

| Goal | Location |
|---|---|
| Add a new template | `templates/<name>.template` |
| Add a new skill | `skills/<skill-name>/SKILL.md` |
| Add a methodology rule | `docs/methodology.md` (update narrative, keep ≤ 1500 words) |
| Add an example | `examples/<project-name>/` (small, complete) |
| Add a decision record | `docs/decisions/NNNN-<short>.md` |
| Add an install script | `scripts/<name>.sh` (non-destructive by default) |

## Definition of Done (per change)

- [ ] Each new template has ≥ 1 example in `examples/`
- [ ] Each new skill has a clear `description:` frontmatter trigger
- [ ] `docs/methodology.md` narrative still readable end-to-end (≤ 1500 words)
- [ ] README's "Quick start" still accurate
- [ ] `./scripts/install.sh --help` still works
- [ ] `./scripts/install.sh` (dry-run) reports no errors

## Forbidden

- Don't grow this into a meta-methodology framework.
- Don't add templates for things not yet used by a real project.
- Don't write "philosophy" without concrete steps.
- Don't add destructive operations to `scripts/install.sh` (no `rm`, `unlink`, `mv`, `rmdir` in non-comment lines).
- Don't bypass the static guard in `scripts/install.sh` — it's there on purpose.

## Decisions

Before adding any new convention, check [`docs/decisions/`](../../docs/decisions/). If addressed, follow it. If you want to change it, write a new decision file — don't argue in PR comments.

## Tasks

Before any non-trivial change, fill a single-task contract (see [`templates/single-task-contract.md`](../../templates/single-task-contract.md)). Keep it with the task in chat or as a scratch file.

## Stop and ask if

- You find yourself wanting to relax a `Forbidden` rule
- You find yourself wanting to introduce destructive operations in `scripts/`
- You find a decision note that contradicts what the user asked — surface it and ask which wins