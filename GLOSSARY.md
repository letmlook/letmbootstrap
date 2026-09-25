# Glossary

Terms used in this repo. Each entry has a short definition and a pointer to the relevant doc.

## A

### AGENTS.md

The 30-line project constitution that lives at the root of every project adopting letmbootstrap. Six required sections: Project is, Stack, Project is NOT, Required reading, Where new code goes, Definition of Done, Forbidden. See [`templates/AGENTS.md.template`](../templates/AGENTS.md.template) and [`methodology.md`](methodology.md) §"The 4 pieces".

### Anti-goal

A thing the project is **not**. Listed in AGENTS.md under "Project is NOT". Anti-goals are the single most powerful section of the constitution because they prevent the Agent from "helpfully" extending the project into territory you didn't want. See [`methodology.md`](methodology.md) §"Anti-patterns".

### Append-only

The property of the decision log: records are added, never modified in place. If a decision is reversed, a new record is appended that supersedes the old one. The old record is preserved (often moved to `rejected/`) so future readers can see the full history.

## B

### Bootstrap

In the context of this repo, two related but distinct operations:

1. **Bootstrapping a project** — running the `letmbootstrap` skill on a target project to install the 4-piece setup there.
2. **Bootstrapping the skill itself** — running `scripts/install.sh` to put the skill onto your Agent platform.

The first is described in [`skills/letmbootstrap/SKILL.md`](../skills/letmbootstrap/SKILL.md). The second is described in [`INSTALL.md`](../INSTALL.md) and [`docs/installation-guide.md`](installation-guide.md).

## C

### Constitution

Synonym for AGENTS.md. Used informally.

### Conventional Commits

A commit message format: `<type>(<scope>): <subject>`. Types: `feat`, `fix`, `docs`, `refactor`, `chore`, etc. Breaking changes append `!` and add a `BREAKING CHANGE:` footer. See [`CONTRIBUTING.md`](../CONTRIBUTING.md) for examples.

## D

### Decision record

A markdown file in `docs/decisions/` that records a settled choice. Format: Status / Context / Decision / Consequences / Alternatives considered. See [`templates/decision.md.template`](../templates/decision.md.template).

### Detect-before-write

A hard rule in every letmbootstrap skill: before any write, perform a read-only preflight check that detects the current state of the target. This is what makes re-running the skill safe.

### Dogfooding

Using your own product on yourself. The letmbootstrap repo uses its own methodology: AGENTS.md is the dogfooded constitution, [`examples/letmbootstrap-self/`](../examples/letmbootstrap-self/) is the dogfooded example output, [`docs/decisions/`](../docs/decisions/) is the dogfooded decision log.

## E

### Extension map

The "Where new code goes" table in AGENTS.md. Maps "I want to add X" to "it goes in Y". Prevents the Agent from inventing new directory structure on the fly.

## F

### Frontmatter

The YAML block at the top of a `SKILL.md` file:

```markdown
---
name: <skill-name>
description: Use when <trigger> — <summary>.
---
```

The `description:` is matched against user input to decide whether to invoke the skill. See [`docs/skills-catalog.md`](skills-catalog.md).

## I

### Idempotent

A property of operations: running them once produces the same result as running them many times. `scripts/install.sh` is idempotent — re-running it on a populated target is a no-op. The skill is idempotent — re-running it on an already-bootstrapped target is a no-op (after reporting state).

### Installer

In this repo, `scripts/install.sh`. Puts the `letmbootstrap` skill onto a supported Agent platform. Non-destructive. Default mode is dry-run.

## M

### Materialize decisions

Principle 1 of the 3 principles. Anything you decide that affects the project must exist as a file the Agent can read. Three rules: re-decide later → decision note; re-do procedure → skill; one-off → commit message.

### Mechanize rules

Principle 2 of the 3 principles. Every AGENTS.md rule gets an exit-1 script. If a rule isn't worth a check, it isn't worth a rule.

## N

### Non-destructive

The binding property of every letmbootstrap skill and installer. No `rm`, `unlink`, `mv`, `rmdir`, no `--force`, no `--reset`, no uninstall subcommand. See [`docs/decisions/0001-keep-skill-non-destructive.md`](decisions/0001-keep-skill-non-destructive.md).

## P

### Paste-on-invoke

The universal fallback when an Agent doesn't have a skills directory. Copy `SKILL.md` body into chat with "follow this procedure." Ugly but works everywhere.

## S

### Single-task contract

The 30-second pre-task template. Sections: Task / Required reading / Out of scope / Acceptance criteria / Autonomous decision space / Must ask me before. See [`templates/single-task-contract.md`](../templates/single-task-contract.md).

### Skill

A directory `skills/<skill-name>/SKILL.md` with frontmatter and a step-by-step procedure. The Agent invokes it when the `description:` matches user input.

### Skip-on-conflict

The behavior when an installer or skill encounters an existing file at the target path: print `SKIP` and continue. Never overwrite without explicit consent.

### Static guard

The pattern at the top of `scripts/install.sh`:

```bash
if grep -nE '^[^#]*\b(rm |unlink |mv |rmdir )\b' "$0" >/dev/null 2>&1; then
  exit 78
fi
```

Catches any future regression that introduces a destructive pattern. Cannot be bypassed by flags.

## T

### Trigger phrase

A phrase in a skill's `description:` frontmatter that the Agent matches against user input. The `description:` field is the trigger surface — make it specific or the skill will never invoke.

## V

### Verification-before-completion

The discipline of running the Acceptance criteria checklist before claiming "done". The skill body and every PR template include this discipline.

---

For terms not listed here, see [`methodology.md`](methodology.md) or open an issue.