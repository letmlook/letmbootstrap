<!-- English mirror | 中文默认版本: scripts/README.md -->

# scripts/

Host-side shell scripts that automate letmbootstrap on the user's machine. Every script in this directory is **non-destructive by default** — see [`../docs/decisions/0001-keep-skill-non-destructive.md`](../docs/decisions/0001-keep-skill-non-destructive.md).

## What's in here

| File | Purpose | Default mode | Platform |
|---|---|---|---|
| `install.sh` | Install the `letmbootstrap` skill into a supported Agent platform | dry-run (prints plan, no writes) | Linux / macOS |
| `install.ps1` | Same, PowerShell implementation | dry-run | Windows / cross-platform |

The two scripts have identical behavior (same detectors, same skip policy, same non-destructive guarantee). Use whichever runs on your platform.

## `install.sh` — at a glance (Linux / macOS)

```bash
./scripts/install.sh                                # dry-run for every detected platform
./scripts/install.sh --apply                        # actually install
./scripts/install.sh --apply --platform claude-code # one platform only
./scripts/install.sh --apply --symlink              # symlink instead of copy
./scripts/install.sh --help                         # usage
```

## `install.ps1` — at a glance (Windows / PowerShell)

```powershell
.\scripts\install.ps1                                 # dry-run for every detected platform
.\scripts\install.ps1 -Apply                          # actually install
.\scripts\install.ps1 -Apply -Platform claude-code    # one platform only
.\scripts\install.ps1 -Apply -Symlink                 # symlink instead of copy
.\scripts\install.ps1 -Help                           # usage
```

> The PowerShell version requires PowerShell Core 7+ (`pwsh`) or Windows PowerShell 5.1+. Windows 10 1809+ ships with `pwsh`; older versions need to install it first.

## Shared guarantees (both scripts enforce)

**What it does:** copies `skills/letmbootstrap/` into the right location for each detected Agent platform. Detects Mavis, Claude Code, Cursor, Gemini CLI, Codex CLI, Aider, Devin, OpenCode.

**What it never does:**

- `rm`, `unlink`, `mv`, `rmdir` / `Remove-Item`, `Move-Item`, `Rename-Item` — the static guard at the top of each script aborts if any of these ever appear in non-comment lines
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

`install.ps1` opens with the PowerShell equivalent. Both guards run **before** any other code. If any non-comment line ever grows a destructive pattern, the script aborts with exit code 78 (EX_CONFIG). The guard cannot be bypassed by flags or environment variables.

When adding a new script:

- **Either** copy the static guard pattern into the new script, **or**
- **Explain in the PR description** why the new script doesn't need one (e.g., it's read-only by construction).

## Testing a script

There is no test suite. The verification steps are:

**Bash (`install.sh`):**

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

**PowerShell (`install.ps1`):**

```powershell
# 1. Static guard test (the script should refuse if a destructive pattern is planted)
$tmp = Join-Path $env:TEMP "lb-test-$pid"
New-Item -ItemType Directory -Path $tmp | Out-Null
Copy-Item scripts/install.ps1 "$tmp\install.ps1"
Add-Content "$tmp\install.ps1" "`nRemove-Item -Path foo"
& "$tmp\install.ps1" -Help
# Expected: exit code 78, "REFUSE" in stderr
Remove-Item -Recurse -Force $tmp
# ^ the test cleanup itself uses Remove-Item, that's fine — it's the user's choice

# 2. Help text
.\scripts\install.ps1 -Help

# 3. Dry-run
.\scripts\install.ps1

# 4. Apply against a fake HOME
$fakeHome = Join-Path $env:TEMP "lb-fake-$pid"
New-Item -ItemType Directory -Path (Join-Path $fakeHome ".claude/skills") -Force | Out-Null
$env:HOME = $fakeHome
.\scripts\install.ps1 -Apply -Platform claude-code
Get-ChildItem "$fakeHome\.claude\skills\letmbootstrap\SKILL.md"
```

## What this README is not

- **Not the AGENTS.md.** Project constitution is [`../AGENTS.md`](../AGENTS.md).
- **Not the install instructions.** Quick start is [`../INSTALL.md`](../INSTALL.md); details are [`../docs/installation-guide.md`](../docs/installation-guide.md).