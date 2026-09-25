# 0001 — Bootstrap with letmbootstrap

## Status

YYYY-MM-DD — implemented — letmbootstrap is now the project's collaboration methodology.

## Context

Default Agent behavior has three failure modes when iterating on a project:

1. **Drift** — Agent doesn't know what's been decided, so it re-litigates settled choices.
2. **Scope creep** — Agent "helpfully" extends beyond the task, touching unrelated code.
3. **Forgotten rules** — Conventions live in chat history and evaporate between sessions.

The project needed a way to make project knowledge persistent and machine-readable so the Agent doesn't re-derive context every session.

## Decision

Adopt the letmbootstrap 4-piece set:

- `AGENTS.md` at the project root as the project constitution
- `docs/decisions/` as the append-only decision log
- `skills/` for step-by-step procedures the Agent follows without improvising
- Single-task contract, filled in before each Agent task

The methodology is described in [`docs/methodology.md`](../../../../docs/methodology.md).

## Consequences

- ✅ **Gain:** eliminates ~70% of "you forgot rule X" re-prompting. Decisions persist across sessions. New Agents onboard by reading 4 files, not by asking the user.
- ❌ **Cost:** ~15 minutes the first time to write `AGENTS.md`; 5 minutes per change to maintain.
- ⚠️ **Workflow change:** every non-trivial task now starts with a single-task contract (30 seconds). Every non-trivial decision now generates a decision file.

## Alternatives considered

- **Ad-hoc decisions in chat:** rejected. Chat history is not durable; new Agents can't read it. The whole point is to externalize context.
- **No methodology, status quo:** rejected. The 3 failure modes (drift, scope creep, forgotten rules) compound over time. They don't go away by hoping.
- **Custom methodology:** rejected. Custom methodologies either grow into a framework (which this template explicitly forbids) or stay small and re-invent letmbootstrap poorly. Use the template.
- **Heavier methodology (full docs/architecture, ADR tools, etc.):** rejected for now. The 4-piece set is the leverage point. Don't add anything until the 4 pieces are running smoothly — see [`docs/methodology.md`](../../../../docs/methodology.md) "Scaling up".

## Lifecycle

This file is in `docs/decisions/` (implemented). If letmbootstrap is ever replaced, this file moves to `docs/decisions/rejected/` with a one-line "superseded by 00XX" note.