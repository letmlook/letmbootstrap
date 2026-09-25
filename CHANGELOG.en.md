# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

The skill's `SKILL.md` frontmatter is part of the API contract. Any change to it that affects external behavior is a minor version bump minimum.

## [Unreleased]

### Added

- **Full Chinese localization** — every top-level doc, docs/ subdoc, template, script doc, example, and skill body is now Chinese-default.
- English versions preserved as `.en.md` mirrors in the same directory.
- **Windows installer** — `scripts/install.ps1` (PowerShell implementation), fully equivalent to `scripts/install.sh`. Covers Mavis / Claude Code / Codex CLI / Cursor / Gemini CLI / Aider / Devin / OpenCode. Windows users run `.ps1`; everyone else runs `.sh`.
- **Two-script installer** — both versions share the same non-destructive guarantees; each script has its own static guard (`.sh` uses grep to check POSIX destructive commands; `.ps1` assembles cmdlet names at runtime to avoid self-detection).
- `ARCHITECTURE.md` — five-layer architecture overview
- `CONTRIBUTING.md` — PR workflow + decision record conventions
- `SECURITY.md` — security reporting policy
- `CODE_OF_CONDUCT.md` — community norms
- `LICENSE` — MIT
- `docs/skills-catalog.md` — catalog of shipped skills + how to write more
- `FAQ.md` / `GLOSSARY.md` — quick reference (top-level)
- `templates/README.md` — guide to the templates
- `scripts/README.md` — guide to the scripts
- `examples/README.md` — guide to the examples

### Changed

- `AGENTS.md` — "Where new things go" expanded; "Forbidden" lists destructive ops; both installers cited
- `README.md` — indexes all new docs
- `docs/decisions/0001-keep-skill-non-destructive.md` — referenced from more places

## [0.1.0] — 2026-09-26

### Added

- `README.md` — overview + Quick Start
- `INSTALL.md` — 1-page Agent-platform install guide
- `AGENTS.md` — dogfooded project constitution
- `docs/methodology.md` — 4-piece anti-drift narrative
- `docs/installation-guide.md` — per-platform install details + troubleshooting
- `docs/agent-compatibility.md` — compatibility matrix across 8 Agent platforms
- `docs/decisions/0001-keep-skill-non-destructive.md` — non-destructive guarantee
- `templates/AGENTS.md.template` — project constitution template
- `templates/decision.md.template` — decision record template
- `templates/single-task-contract.md` — task contract template
- `skills/letmbootstrap/SKILL.md` — the bootstrap skill (hard rules section at top)
- `scripts/install.sh` — non-destructive installer (static guard + dry-run default)
- `scripts/install.ps1` — PowerShell equivalent, native Windows
- `examples/letmbootstrap-self/` — dogfood example of skill output
- `.gitignore` — macOS + editor + temp exclusions

### Design commitments (binding across versions)

- **Non-destructive by default.** No `rm`, `unlink`, `mv`, `rmdir`, no `--force`, no `--reset`, no uninstall subcommand. See decision 0001.
- **Idempotent installer.** Re-running either installer is always safe.
- **Skip-on-conflict.** If the install target already exists, the installer prints SKIP and moves on.
- **Static guard.** Both `scripts/install.sh` and `scripts/install.ps1` abort with exit code 78 if a non-comment line grows a destructive pattern.

## Versioning policy

| Change | Version bump |
|---|---|
| Skill `SKILL.md` frontmatter or body changes external behavior | minor (0.x.0) |
| Add a new platform detector to either installer | minor |
| Add a new template | minor |
| Add a new decision record | patch |
| Clarify / correct existing docs | patch |
| Add a new example | patch |
| Bug fix that doesn't change behavior | patch |
| Anything that introduces destructive ops | **rejected** — see decision 0001 |

[Unreleased]: https://github.com/letmlook/letmbootstrap/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/letmlook/letmbootstrap/releases/tag/v0.1.0