# Security Policy

## Scope

This repo contains documentation, templates, one shell script (`scripts/install.sh`), and one Agent skill (`skills/letmbootstrap/SKILL.md`). There is no runtime, no server, no network code.

The security model is therefore narrow:

| Asset | Risk |
|---|---|
| `scripts/install.sh` | Shell injection if a user passes untrusted arguments. Mitigated by `set -euo pipefail` and minimal flag parsing. |
| `skills/letmbootstrap/SKILL.md` | Indirect — if a user installs a forked version that contains a malicious payload, the skill runs in their Agent's context. Mitigated by always installing from this repo, not forks. |
| Templates | Pure markdown — no execution risk. |

There are no credentials, no tokens, no build artifacts.

## Supported versions

Only the latest release on `main` is supported with security fixes. Older tags receive no patches.

## Reporting a vulnerability

Please **do not** open a public GitHub issue for security reports.

Email the maintainer at the address in their GitHub profile, with subject prefix `[letmbootstrap security]`. Include:

- A description of the issue
- Reproduction steps
- Impact assessment

You should receive an acknowledgement within 7 days. The maintainer will assess and either:

- Patch and release (typical timeline: 14 days from acknowledgement), or
- Decline with rationale if the report is out of scope.

## Out of scope

The following are intentionally not part of this repo's security model and will not be patched here:

- **Agent platforms themselves** (Claude Code, Mavis, Codex CLI, etc.). Report those to the platform maintainer.
- **Skill marketplaces** that might re-host this skill. We don't publish to marketplaces by design — see [`docs/decisions/0001-keep-skill-non-destructive.md`](docs/decisions/0001-keep-skill-non-destructive.md).
- **User projects** that adopted the methodology. Their security is their own.
- **Forks.** If you fork this repo, you maintain your fork.

## The non-destructive guarantee, restated for security

The non-destructive guarantee from [decision 0001](docs/decisions/0001-keep-skill-non-destructive.md) is also a security property:

- The skill cannot `rm` user files without consent.
- The installer cannot `rm` user files under any flag.
- The static guard in `scripts/install.sh` aborts if a destructive pattern ever appears in the script source.

This is by design. If a future PR weakens this, treat it as a security regression.

## What this policy is not

- **Not a CVE-bidding process.** This is a small docs repo; we don't run a coordinated disclosure program.
- **Not a bug bounty.** No compensation is offered.
- **Not a promise of zero issues.** The repo is small enough to read in one sitting — please do, and report what you find.