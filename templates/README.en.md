# templates/

This directory contains the three markdown files that the `letmbootstrap` skill copies into a target project. They are **templates**, not finished documents — every one needs to be filled in by the user before it's useful.

## What's here

| File | Purpose | When the skill copies it |
|---|---|---|
| `AGENTS.md.template` | The project constitution | Always |
| `decision.md.template` | A single decision record | Always (as `0001-bootstrap-with-letmbootstrap.md`) |
| `single-task-contract.md` | A blank task contract | Always (into the user's chosen skills dir) |

## How the skill uses them

1. **Read** each template at install time.
2. **Substitute** the user's project metadata (name, stack, anti-goals, extension map).
3. **Write** to the target project under a non-conflicting path.
4. **Skip** if the destination already exists — the skill never overwrites.

See [`skills/letmbootstrap/SKILL.md`](../skills/letmbootstrap/SKILL.md) for the full procedure.

## When to add a new template

Add a template only when:

1. A real project has needed the same kind of file more than twice.
2. The pattern is general enough to apply to projects with different stacks.
3. The template can be filled in by a user in 30 seconds or less.

If a project needs something one-off, put it in chat or a commit message. Templates are leverage; one-off files don't pay back their writing cost.

## How to write a good template

A good template is:

- **Opinionated.** Includes anti-goals and forbidden lists, not just structure.
- **Short.** Most templates should fit on one screen. Push detail into separate docs.
- **Fill-in-the-blanks.** Each `<placeholder>` is one concrete thing the user can answer without thinking.
- **Self-explanatory.** A user filling it in should not need to read the methodology narrative to know what to write.

A bad template is:

- **Long.** More than ~80 lines is a smell — push detail elsewhere.
- **Vague.** `AGENTS.md.template` with `<add your project description>` is meaningless.
- **Decision-shaped.** If the template forces the user to make a decision (not just describe their project), the decision belongs in a decision record, not the template.

## Per-template notes

### `AGENTS.md.template`

The 30-line constitution. Sections:

1. **Project is** — one sentence, verb + noun + audience.
2. **Stack** — language, runtime, framework, package manager, test runner.
3. **Project is NOT** — anti-goals. The most powerful section.
4. **Required reading (in order)** — explicit doc order.
5. **Where new code goes** — extension map.
6. **Definition of Done** — checklist.
7. **Forbidden** — non-negotiable no-fly zones.
8. **Decisions** — pointer to docs/decisions/.
9. **Tasks** — pointer to single-task-contract.
10. **Stop and ask if** — escalation triggers.

### `decision.md.template`

The append-only decision record. Sections:

1. **Status** — date, state, one-line reason.
2. **Context** — the problem, written so it stands without the solution.
3. **Decision** — present tense, factual, verifiable.
4. **Consequences** — gain / cost / workflow change.
5. **Alternatives considered** — mandatory. Real alternatives only.
6. **Lifecycle** — proposed / implemented / rejected.

The single most important rule: **alternatives must be real**. A decision record that says "we picked SQLite" without "we rejected Postgres because X" invites re-litigation every six months.

### `single-task-contract.md`

The 30-second pre-task template. Sections:

1. **Task** — one sentence, verb + noun.
2. **Required reading** — 2-5 references.
3. **Out of scope (do NOT do)** — boundaries.
4. **Acceptance criteria** — observable checklist.
5. **Autonomous decision space** — what the Agent decides alone.
6. **Must ask me before** — escalation triggers.

The contract does three things at once:

- Clarifies your own thinking before the task starts.
- Prevents scope creep via explicit "do NOT" list.
- Gives the Agent a stop signal.

## Versioning

Templates are part of the public API. Any change to a template's structure that affects how the skill installs it requires a minor version bump.

See [`../CHANGELOG.md`](../CHANGELOG.md) for the version history.

## What this README is not

- **Not the AGENTS.md.** This is the templates directory's index; the project constitution is [`../AGENTS.md`](../AGENTS.md).
- **Not the methodology.** For the full narrative, see [`../docs/methodology.md`](../docs/methodology.md).