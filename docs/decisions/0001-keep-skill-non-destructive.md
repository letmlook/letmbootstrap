# 0001 — Keep the letmbootstrap skill non-destructive (no rm, no uninstall)

## Status

2026-09-26 — implemented — skill body and installer enforce non-destructive operation as a hard rule.

## Context

The letmbootstrap skill is an installer: it copies `AGENTS.md` + `docs/decisions/` + `skills/` into a target project. The repo also ships an installer (`scripts/install.sh`) that copies the skill itself into an Agent's skills directory.

Both are designed to be safe to run repeatedly, in any order, on partially-initialized or fully-initialized targets. The principle: **the skill never deletes or overwrites anything the user didn't explicitly approve**.

The initial v1 of the skill and installer could have included an "uninstall" or "reset" path that wipes the previously installed files. We considered this for symmetry with most installers. We decided not to ship it in v1 for three reasons:

1. **The most expensive failure mode is accidental deletion.** A misfired uninstall script can wipe a project's `AGENTS.md`, decision log, and skills directory in one command. The blast radius is unbounded.
2. **Recovery is easy without an uninstall command.** The user can `rm -rf` the installed directory themselves if they really want to. That single-line operation is no harder than calling an uninstall command — but it forces the user to be explicit about what they're removing.
3. **The skill's value proposition is "don't drift, don't re-prompt, don't lose context."** Shipping a destructive command in the same tool that promises durability is a contradiction. The user should never have to wonder whether a re-run might delete state.

## Decision

The letmbootstrap skill and `scripts/install.sh` are **non-destructive by default**:

1. The skill body refuses to `rm`, `unlink`, `mv`, or overwrite any existing file without per-file explicit consent from the user.
2. `scripts/install.sh` defaults to dry-run. It never deletes. On conflict (target path already exists), it prints `SKIP` and continues.
3. `scripts/install.sh` contains a static guard at the top of the file: if a non-comment line ever grows a destructive pattern (`rm`, `unlink`, `mv`, `rmdir`), the script aborts with exit code 78 before doing anything.
4. There is no `uninstall` subcommand. There is no `--force` flag. There is no `--reset` flag. There is no way to override the skip-on-conflict behavior from inside the script.
5. The skill body's "Hard rules — non-destructive by default" section is binding; the skill may not skip them even when the user explicitly asks for an operation that would delete state.

## Consequences

- ✅ **Gain:** users can run the skill or installer any number of times without risk to their existing files. Re-runs are safe. The trust contract is clear: this tool never destroys what you've built.
- ❌ **Cost:** if a user wants to start fresh, they must do the manual `rm -rf` themselves. This is a one-line, copy-pasteable operation that they can find in [`INSTALL.md`](../../INSTALL.md) and [`docs/installation-guide.md`](../installation-guide.md). The cost is "5 seconds of reading the docs."
- ⚠️ **Workflow change:** updates to the skill require the user to manually replace the installed copy (`cp -R skills/letmbootstrap $INSTALL_PATH`). For active development, `--symlink` mode is supported so repo edits are picked up live.
- ⚠️ **Workflow change:** if a future feature requires destructive ops (e.g., a project migration that genuinely needs to move files), it must be implemented as a **separate skill** with its own consent flow, not as a flag inside the installer.

## Alternatives considered

- **Ship an `uninstall` subcommand with confirmations:** rejected. Confirmations are an unreliable defense. Users click through them. The probability of accidental deletion is non-zero and the cost is high. Better to make the operation explicit by requiring the user to type the destructive command themselves.
- **Ship `--force` and `--reset` flags:** rejected for the same reason. Flags add power; power without explicit per-file consent is exactly what we want to avoid.
- **Allow the skill to delete files when the user says "yes, delete X":** rejected for v1. The decision boundary we picked is "no destructive operations at all, period." If a future use case really requires it, we'll write a new decision record (probably `0002`) laying out the consent flow and ship it as a separate skill. Until then, this decision stands.
- **Ship a separate `letmbootstrap-uninstall` skill:** rejected. Having two skills where one is "do" and the other is "undo" invites confusion. The single-skill model is simpler. If you want uninstall, do it manually — the docs explain how.
- **Make the static guard a runtime check only:** rejected. A runtime check can be bypassed (e.g., `--no-verify`-style flag). A static guard at the top of the script is checked every time, regardless of how the script is invoked.

## Lifecycle

This file is in `docs/decisions/` (implemented). If the policy ever changes — for example, if we add a destructive operation behind explicit per-file consent — this file moves to `docs/decisions/rejected/` and a new decision record (e.g., `0002-allow-targeted-deletion-with-consent.md`) takes its place. Until then, no PR that introduces destructive operations to the skill or installer should be merged.

## Audit checklist for contributors

Before adding any operation to the skill body or `scripts/install.sh`, verify:

- [ ] Does not contain `rm`, `unlink`, `mv`, `rmdir` in non-comment lines.
- [ ] Does not overwrite an existing file without per-file explicit consent.
- [ ] Is idempotent — re-running on a populated target is a no-op.
- [ ] The static guard in `scripts/install.sh` still passes (`bash -n scripts/install.sh` and a manual review).
- [ ] The "Hard rules" section in `skills/letmbootstrap/SKILL.md` is still consistent with the actual behavior.