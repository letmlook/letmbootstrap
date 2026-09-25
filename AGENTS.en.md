# AGENTS.md — letmbootstrap template

> This file dogfoods the methodology: it IS the 30-line constitution for this template repo.

## Project is

A reusable collaboration methodology template for solo + Agent iterative development. It packages the 4-piece anti-drift setup + bootstrap skill so a new project can adopt the discipline in ~10 minutes.

## Stack

Markdown / shell / Agent SKILL.md. No runtime. No build.

## Project is NOT

- Not a runtime framework, not a CLI, not a library — just docs + templates + a skill.
- Not coupled to any specific language or framework.
- Not a "methodology encyclopedia" — keep each artifact short and opinionated.
- Not a skill marketplace — we don't publish to one by design.

## Required reading (in order)

1. `README.md` — what's in here and why
2. `INSTALL.md` — how to put the letmbootstrap skill on your Agent
3. `ARCHITECTURE.md` — five-layer architecture overview
4. `docs/methodology.md` — the full narrative
5. `docs/installation-guide.md` — per-platform install steps + troubleshooting
6. `docs/agent-compatibility.md` — which Agents can run the skill
7. `docs/skills-catalog.md` — catalog of shipped skills + how to write more
8. `docs/agent-driven-install.md` — ask your Agent to install the skill (not type shell yourself)
9. `FAQ.md` / `GLOSSARY.md` — quick reference
10. `templates/` — the three templates to copy (see `templates/README.md`)
11. `skills/letmbootstrap/SKILL.md` — the bootstrap skill
12. `scripts/install.sh` — non-destructive installer for Linux/macOS (read the static guard)
13. `scripts/install.ps1` — PowerShell equivalent for Windows / cross-platform (same static guard)

## Where new things go

| Goal | Location |
|---|---|
| Add a new template | `templates/<name>.template` |
| Add a new skill | `skills/<skill-name>/SKILL.md` |
| Add a methodology rule | `docs/methodology.md` (update narrative, keep ≤ 1500 words) |
| Add an example | `examples/<project-name>/` (small, complete) |
| Add a decision record | `docs/decisions/NNNN-<short>.md` |
| Add an install script | `scripts/<name>.sh` (non-destructive by default) |
| Add a per-platform install path | edit **both** `scripts/install.sh` and `scripts/install.ps1` detectors + add row to `docs/agent-compatibility.md` |
| Add an FAQ entry | `FAQ.md` + mirror to `FAQ.en.md` |
| Add a glossary entry | `GLOSSARY.md` + mirror to `GLOSSARY.en.md` |
| Tweak the constitution | this file (≤ 80 lines) |

## Definition of Done (per change)

- [ ] Each new template has ≥ 1 example in `examples/`
- [ ] Each new skill has a clear `description:` frontmatter trigger
- [ ] `docs/methodology.md` narrative still readable end-to-end (≤ 1500 words)
- [ ] README's "Quick start" still accurate
- [ ] INSTALL.md still accurate if install flow changed
- [ ] `./scripts/install.sh --help` and `.\scripts\install.ps1 -Help` both still work
- [ ] Both installers (dry-run, no flags) report no errors
- [ ] No new destructive ops in `scripts/` (no `rm`, `unlink`, `mv`, `rmdir` in non-comment lines)
- [ ] If `FAQ.md` or `GLOSSARY.md` changed, mirror to `FAQ.en.md` / `GLOSSARY.en.md`

## Forbidden

- Don't grow this into a meta-methodology framework.
- Don't add templates for things not yet used by a real project.
- Don't write "philosophy" without concrete steps.
- Don't add destructive operations to `scripts/install.sh` or `scripts/install.ps1` — the static guards at the top of each file are binding (see `docs/decisions/0001-keep-skill-non-destructive.md`).
- Don't ship an `uninstall` subcommand or `--force`/`--reset` flag in any install script. Users do destructive ops themselves.
- Don't publish to skill marketplaces. Install is always direct from this repo.

## Decisions

Before adding any new convention, check `docs/decisions/`. If addressed, follow it. If you want to change it, write a new decision file — don't argue in PR comments.

## Tasks

Before any non-trivial change, fill a single-task contract (see `templates/single-task-contract.md`).