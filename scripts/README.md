# scripts/

Host-side shell scripts that automate letmbootstrap on the user's machine. Every script in this directory is **non-destructive by default** — see [`../docs/decisions/0001-keep-skill-non-destructive.md`](../docs/decisions/0001-keep-skill-non-destructive.md).

## What's here

| File | Purpose | Default mode |
|---|---|---|
| `install.sh` | Install the `letmbootstrap` skill into a supported Agent platform | dry-run (prints plan, no writes) |

## `install.sh` — at a glance

```bash
./scripts/install.sh                                # dry-run for every detected platform
./scripts/install.sh --apply                        # actually install
./scripts/install.sh --apply --platform claude-code # one platform only
./scripts/install.sh --apply --symlink              # symlink instead of copy
./scripts/install.sh --help                         # usage
```

**What it does:** copies `skills/letmbootstrap/` into the right location for each detected Agent platform. Detects Mavis, Claude Code, Cursor, Gemini CLI, Codex CLI, Aider, Devin, OpenCode.

**What it never does:**

- `rm`, `unlink`, `mv`, `rmdir` — the static guard at the top of the script aborts the script if any of these ever appear in non-comment lines
- Overwrite an existing skill installation
- Modify the source repo

**What it does on conflict:** prints `SKIP` and continues. Re-run with `--apply` after manually removing the existing installation if you really want to replace it.

See [`../INSTALL.md`](../INSTALL.md) for the quick-start guide and [`../docs/installation-guide.md`](../docs/installation-guide.md) for the per-platform details.

## When to add a new script

Add a script when:

1. The same shell operation is needed by more than one user / more than one project.
2. The operation can't be expressed as a one-liner in the skill body.
3. The operation is non-destructive (no `rm`/`mv`/overwrite without per-file consent).

If the operation is one-off or destructive, don't put it in this directory — the script will be rejected at PR review per the AGENTS.md "Forbidden" section.

## The static guard

`install.sh` opens with:

```bash
# Static guard: this script intentionally contains no destructive commands.
if grep -nE '^[^#]*\b(rm |unlink |mv |rmdir )\b' "$0" >/dev/null 2>&1; then
  echo "REFUSE: scripts/install.sh contains a destructive command pattern." >&2
  exit 78
fi
```

This guard runs **before** any other code. If any non-comment line ever grows a destructive pattern, the script aborts with exit code 78 (EX_CONFIG). The guard cannot be bypassed by flags or environment variables.

When adding a new script:

- **Either** copy the static guard into the new script, **or**
- **Explain in the PR description** why the new script doesn't need one (e.g., it's read-only by construction).

## Testing a script

There is no test suite. The verification steps are:

```bash
# 1. Syntax
bash -n scripts/install.sh && echo OK

# 2. Help text
./scripts/install.sh --help

# 3. Dry-run
./scripts/install.sh

# 4. Apply against a temp HOME (for safety)
TMP=$(mktemp -d)
mkdir -p "$TMP/.claude/skills"
HOME="$TMP" ./scripts/install.sh --apply --platform claude-code
ls "$TMP/.claude/skills/letmbootstrap/SKILL.md"
# cleanup
mavis-trash "$TMP"

# 5. Idempotency: run again, expect SKIP
HOME="$TMP" ./scripts/install.sh --apply --platform claude-code
```

CI also runs the dry-run on every push. See `.github/workflows/install-dryrun.yml`.

## What this README is not

- **Not the AGENTS.md.** Project constitution is [`../AGENTS.md`](../AGENTS.md).
- **Not the install instructions.** Quick start is [`../INSTALL.md`](../INSTALL.md); details are [`../docs/installation-guide.md`](../docs/installation-guide.md).