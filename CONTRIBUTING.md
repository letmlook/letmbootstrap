# Contributing

Thanks for considering a contribution to letmbootstrap. This document covers how to send a PR that lands cleanly. The short version: **write a single-task contract for yourself first**, then send the PR. The longer version is below.

## TL;DR

1. Read [`AGENTS.md`](AGENTS.md) (the constitution) and [`ARCHITECTURE.md`](ARCHITECTURE.md) (the shape).
2. Read [`docs/methodology.md`](docs/methodology.md) end-to-end (≤ 1500 words, takes 5 minutes).
3. Check [`docs/decisions/`](docs/decisions/) — your concern may already be addressed.
4. If you're changing anything non-trivial, fill a [single-task contract](templates/single-task-contract.md) and include it in the PR description.
5. If your change conflicts with a decision, write a new decision record. Don't argue in PR comments.

## Code of conduct

By participating, you agree to the [Code of Conduct](CODE_OF_CONDUCT.md). Enforcement is by the maintainers.

## What we accept

| Type | Bar |
|---|---|
| **Bug fix** (typo, broken link, misformatted table) | Trivial PR — no contract needed. CI must pass. |
| **Documentation clarification** | Send a PR with a before/after explanation in the description. |
| **New platform support in `scripts/install.sh`** | PR must add a detection function, update [`docs/agent-compatibility.md`](docs/agent-compatibility.md), and pass the dry-run test on the platform you can verify. |
| **New template** | Must come with a worked example in `examples/`. See the AGENTS.md "Definition of Done". |
| **New skill in `skills/`** | Must have a clear `description:` frontmatter trigger. Trigger phrases in Chinese and English are encouraged. |
| **New methodology rule** | Must update the narrative in `docs/methodology.md` (≤ 1500 words) and ship as a decision record explaining what changed. |
| **Anything that introduces destructive operations** | **Rejected at PR review.** See [decision 0001](docs/decisions/0001-keep-skill-non-destructive.md). |
| **Uninstall / reset / force flags** | **Rejected at PR review.** Same decision. |

## How to write the PR

The PR description is the single-task contract. Use the template:

```markdown
## Task
<one-sentence verb + noun>

## Required reading
- <links the reviewer should read first>

## Out of scope (do NOT do)
- <boundaries — what this PR is NOT>

## Acceptance criteria
- [ ] <observable>
- [ ] <observable>
- [ ] CI is green

## Decision record
<linked docs/decisions/NNNN-*.md, if this PR contradicts an existing decision>
<"none", if it doesn't>
```

If you can't fill this in, the PR isn't ready. Refine until you can — that's the methodology working.

## Testing your change

There is no test suite. The verification steps are:

```bash
# 1. Skill syntax / frontmatter sanity
head -5 skills/letmbootstrap/SKILL.md  # should have name: + description:

# 2. Installer dry-run
./scripts/install.sh                  # dry-run for every detected platform

# 3. Installer static guard (catches rm/unlink/mv/rmdir regressions)
bash -n scripts/install.sh && echo OK

# 4. CI on GitHub will also run the dry-run on push
```

If you added a new platform, also test `--apply --platform <your-platform>` against a temp HOME directory:

```bash
TMP=$(mktemp -d)
mkdir -p "$TMP/.claude/skills"
HOME="$TMP" ./scripts/install.sh --apply --platform claude-code
ls "$TMP/.claude/skills/letmbootstrap/SKILL.md"  # should exist
# cleanup
mavis-trash "$TMP"
```

## Commit messages

We use [Conventional Commits](https://www.conventionalcommits.org/). Examples:

- `docs: clarify non-destructive guarantee in SKILL.md`
- `feat: add Gemini CLI platform support`
- `fix: static guard false-positive on `^rm -rf` in comment`
- `refactor: split install.sh into platform detectors`
- `chore: bump version to 0.2.0`

Breaking changes to the skill API (`SKILL.md` frontmatter or template format) must include `!` after the type and a `BREAKING CHANGE:` footer.

## Adding a decision record

If your change touches a settled convention, write a decision record first:

```bash
# Copy the template
cp templates/decision.md.template docs/decisions/NNNN-<short-kebab-title>.md

# Fill in:
#   Status:        YYYY-MM-DD — proposed | implemented | rejected — <reason>
#   Context:       the problem, written so it stands without the solution
#   Decision:      present tense, factual, verifiable
#   Alternatives:   mandatory; real alternatives only
```

The number is the next available `NNNN` in `docs/decisions/`. Sort order is creation order, not topic order — this prevents bikeshedding about categorization.

Once the decision record exists, link it from your PR description.

## Review process

1. **Maintainer reviews within 7 days.** If you don't hear back, ping.
2. **CI must pass.** The dry-run on every detected platform must succeed.
3. **Two approvals for non-trivial changes.** Documentation-only changes need one approval.
4. **Squash-merge to `main`.** Commit history of the merged commit should match the PR title.

## Release process

Maintainers cut a release when something material changes:

1. Bump version in [`CHANGELOG.md`](CHANGELOG.md) and tag.
2. The skill's `SKILL.md` does not embed a version — version is tracked in `CHANGELOG.md` and `git tags`. This keeps the installable payload minimal.
3. If the change affects the skill's external behavior (frontmatter, body), it's a minor version bump. If it adds a new platform, it's a minor version bump. Bug fixes that don't change behavior are patch.

## Asking a question

- Open an issue. Use the question template if one exists; otherwise a clear subject line.
- For security issues, see `SECURITY.md`. Do not file public issues for security reports.

## What this guide is not

- **Not a license.** See [`LICENSE`](LICENSE).
- **Not a contract.** The maintainers reserve the right to reject any PR for any reason.
- **Not an excuse for low bar.** The methodology is small because every piece is load-bearing. New additions need to justify themselves.