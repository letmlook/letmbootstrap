# skills/ — project-specific Agent procedures

This directory holds **project-specific** Agent skills — step-by-step procedures the Agent follows without improvising.

The letmbootstrap skill itself (the one that bootstrapped this very project) lives at [`../../skills/letmbootstrap/SKILL.md`](../../skills/letmbootstrap/SKILL.md) in the repo root. That's the "install the methodology into a target project" skill. This directory is for skills that apply to *this* project once it's set up.

## When to add a skill here

Add a skill when you find yourself giving the Agent the same multi-step instructions more than twice. If the instructions are short and one-off, just put them in chat. If they're long, recurring, and verifiable, write a skill.

Common candidates:

- `pre-push-checks` — narrow test selection before push
- `code-review` — what to check in a PR for this project
- `debug-flaky-test` — isolation, quiescence, restoration
- `release-checklist` — version bump, changelog, tags

## Skill format

Each skill is a directory with a `SKILL.md` file:

```
skills/<skill-name>/
└── SKILL.md
```

The `SKILL.md` must have YAML frontmatter:

```markdown
---
name: <skill-name>
description: Use when <specific trigger> — <one-line summary of what it does>.
---
```

The `description:` field is the hardest part to write. It must be specific enough to match the trigger but not so narrow that the Agent never invokes it.

The body is step-by-step procedure with verifiable success criteria. No subjective advice.

## Forbidden

- Don't add a skill for one-off operations — use chat or commit messages.
- Don't add a skill whose description says "useful for code review" — that's too vague to ever trigger.
- Don't write a skill that contradicts the parent project constitution (`AGENTS.md`).
- Don't add destructive operations to skills (no `rm`, `unlink`, `mv`, `rmdir`). Skills are additive.

## See also

- [`../single-task-contract.md`](../single-task-contract.md) — fill this in before each Agent task
- [`../AGENTS.md`](../AGENTS.md) — the project constitution
- [`../../docs/methodology.md`](../../docs/methodology.md) — the methodology narrative
- [`../../skills/letmbootstrap/SKILL.md`](../../skills/letmbootstrap/SKILL.md) — the bootstrap skill