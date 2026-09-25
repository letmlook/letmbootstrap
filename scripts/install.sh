#!/usr/bin/env bash
# install.sh — install the letmbootstrap skill into a supported Agent platform.
#
# Design principles (binding):
#   1. Dry-run by default. Pass --apply to actually write anything.
#   2. Additive only. Never rm, unlink, mv, or overwrite.
#   3. Idempotent. Re-running is a no-op on populated targets.
#   4. Skip on conflict. If target already exists, print SKIP and move on.
#   5. Never mutate the source repo at $SOURCE_DIR.
#
# Static guard: this script intentionally contains no destructive commands.
# If you ever grow such a pattern, the guard at the top of the script aborts.
#
# Usage:
#   ./scripts/install.sh                                # dry-run for all detected platforms
#   ./scripts/install.sh --apply                        # install for all detected platforms
#   ./scripts/install.sh --apply --platform claude-code # one platform only
#   ./scripts/install.sh --apply --symlink              # symlink instead of copy
#   ./scripts/install.sh --help

set -euo pipefail

# ---------- Static guard (belt + suspenders) ----------
# If this script ever grows a destructive pattern in a non-comment line, the guard catches it.
if grep -nE '^[^#]*\b(rm |unlink |mv |rmdir )\b' "$0" >/dev/null 2>&1; then
  echo "REFUSE: scripts/install.sh contains a destructive command pattern." >&2
  echo "        This script is non-destructive by design. Refusing to run." >&2
  exit 78  # EX_CONFIG
fi

# ---------- Resolve source / skill payload ----------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILL_SRC="$SOURCE_DIR/skills/letmbootstrap"
SKILL_NAME="letmbootstrap"

if [ ! -d "$SKILL_SRC" ]; then
  echo "ERROR: skill payload not found at $SKILL_SRC" >&2
  echo "       Are you running this from inside the letmbootstrap repo?" >&2
  exit 1
fi

# ---------- Defaults ----------
MODE="dry-run"
PLATFORMS=()
AGENT_NAME="mavis"
USE_SYMLINK="false"
HELP="false"

# ---------- Parse args ----------
while [ $# -gt 0 ]; do
  case "$1" in
    --apply) MODE="apply"; shift ;;
    --dry-run) MODE="dry-run"; shift ;;
    --platform)
      [ $# -ge 2 ] || { echo "--platform requires a value" >&2; exit 64; }
      PLATFORMS+=("$2"); shift 2 ;;
    --agent-name)
      [ $# -ge 2 ] || { echo "--agent-name requires a value" >&2; exit 64; }
      AGENT_NAME="$2"; shift 2 ;;
    --symlink) USE_SYMLINK="true"; shift ;;
    --help|-h) HELP="true"; shift ;;
    *)
      echo "Unknown flag: $1" >&2
      echo "Run with --help for usage." >&2
      exit 64 ;;
  esac
done

usage() {
  cat <<EOF
install.sh — install the letmbootstrap skill into a supported Agent platform.

USAGE
  ./scripts/install.sh [flags]

FLAGS
  (no flag)              Dry-run for every detected platform (default).
  --apply                Actually write. Without this, the script is read-only.
  --platform <name>      Restrict to one platform. Repeatable.
                         Valid: mavis, claude-code, codex, cursor, gemini-cli,
                                aider, devin, opencode.
  --agent-name <name>    For Mavis only — which Agent to install under (default: mavis).
  --symlink              Symlink instead of copy. Useful during development.
  --help, -h             Print this help.

NON-DESTRUCTIVE GUARANTEES
  - Never rm, unlink, mv, or overwrite.
  - Skip-and-report on conflict (existing target = no-op).
  - Source repo at \$SOURCE_DIR is never modified.
  - Idempotent. Re-running is safe.

EXAMPLES
  ./scripts/install.sh                                  # dry-run, all platforms
  ./scripts/install.sh --apply                          # install all detected platforms
  ./scripts/install.sh --apply --platform claude-code   # one platform only
  ./scripts/install.sh --apply --symlink                # live-link during development
EOF
}

if [ "$HELP" = "true" ]; then
  usage
  exit 0
fi

# ---------- Platform detection ----------
# Each detector prints "<id>|<target-dir>" for each scope that exists on this machine.

detect_mavis() {
  local target="$HOME/.minimax/agents/$AGENT_NAME/skills/$SKILL_NAME"
  [ -d "$HOME/.minimax" ] && echo "mavis|$target"
}

detect_claude_code() {
  local global="$HOME/.claude/skills/$SKILL_NAME"
  local local_target="./.claude/skills/$SKILL_NAME"
  [ -d "$HOME/.claude" ] && echo "claude-code|$global"
  [ -d "./.claude" ] && echo "claude-code|$local_target"
}

detect_codex() {
  local target="$HOME/.codex/skills/$SKILL_NAME"
  [ -d "$HOME/.codex" ] && echo "codex|$target"
}

detect_cursor() {
  local target="./.cursor/skills/$SKILL_NAME"
  [ -d "./.cursor" ] && echo "cursor|$target"
}

detect_gemini_cli() {
  local target="$HOME/.gemini/skills/$SKILL_NAME"
  [ -d "$HOME/.gemini" ] && echo "gemini-cli|$target"
}

detect_aider() {
  local project="./.aider/skills/$SKILL_NAME"
  local home="$HOME/.aider/skills/$SKILL_NAME"
  [ -d "./.aider" ] && echo "aider|$project"
  [ -d "$HOME/.aider" ] && echo "aider|$home"
}

detect_devin() {
  local target="./.devin/skills/$SKILL_NAME"
  [ -d "./.devin" ] && echo "devin|$target"
}

detect_opencode() {
  local home="$HOME/.config/opencode/skills/$SKILL_NAME"
  local proj="./.opencode/skills/$SKILL_NAME"
  [ -d "$HOME/.config/opencode" ] && echo "opencode|$home"
  [ -d "./.opencode" ] && echo "opencode|$proj"
}

ALL_DETECTORS=(detect_mavis detect_claude_code detect_codex detect_cursor detect_gemini_cli detect_aider detect_devin detect_opencode)
VALID_IDS=(mavis claude-code codex cursor gemini-cli aider devin opencode)

# ---------- Filter platforms by --platform flag ----------
is_valid_platform() {
  local p="$1"
  for v in "${VALID_IDS[@]}"; do
    [ "$v" = "$p" ] && return 0
  done
  return 1
}

if [ "${#PLATFORMS[@]}" -gt 0 ]; then
  for p in "${PLATFORMS[@]}"; do
    if ! is_valid_platform "$p"; then
      echo "ERROR: unknown platform '$p'" >&2
      echo "       Valid: ${VALID_IDS[*]}" >&2
      exit 64
    fi
  done
fi

# ---------- Output state ----------
MODE_LABEL="DRY-RUN"
[ "$MODE" = "apply" ] && MODE_LABEL="APPLY"

echo "================================================================"
echo " letmbootstrap skill installer"
echo " mode:     $MODE_LABEL"
echo " symlink:  $USE_SYMLINK"
echo " source:   $SKILL_SRC"
echo "================================================================"
echo

# ---------- Walk detectors and install ----------
INSTALLED=0
SKIPPED=0
DETECTED=0

for detector in "${ALL_DETECTORS[@]}"; do
  while IFS='|' read -r pid target; do
    [ -z "$pid" ] && continue

    # Apply --platform filter
    if [ "${#PLATFORMS[@]}" -gt 0 ]; then
      keep=0
      for p in "${PLATFORMS[@]}"; do
        [ "$p" = "$pid" ] && keep=1
      done
      [ "$keep" -eq 0 ] && continue
    fi

    DETECTED=$((DETECTED+1))

    target_parent="$(dirname "$target")"

    # ----- conflict check (non-destructive core) -----
    if [ -e "$target" ] || [ -L "$target" ]; then
      echo "SKIP: [$pid] $target"
      echo "      Already exists. Refusing to overwrite."
      SKIPPED=$((SKIPPED+1))
      continue
    fi

    # ----- plan -----
    verb="cp -R"
    [ "$USE_SYMLINK" = "true" ] && verb="ln -s"

    echo "PLAN: [$pid] $verb $SKILL_SRC -> $target"

    # ----- execute -----
    if [ "$MODE" = "apply" ]; then
      mkdir -p "$target_parent"
      if [ "$USE_SYMLINK" = "true" ]; then
        ln -s "$SKILL_SRC" "$target"
      else
        cp -R "$SKILL_SRC" "$target"
      fi
      echo "  ✓ installed"

      INSTALLED=$((INSTALLED+1))
    fi
  done < <("$detector")
done

# ---------- Summary ----------
echo
echo "================================================================"
echo " Summary"
echo "   detected: $DETECTED location(s)"
echo "   installed: $INSTALLED"
echo "   skipped:   $SKIPPED (existing installations — preserved as-is)"
echo "================================================================"

if [ "$MODE" = "dry-run" ]; then
  echo
  echo "This was a DRY-RUN. No files were written."
  echo "Re-run with --apply to perform the planned operations."
fi

if [ "$DETECTED" -eq 0 ]; then
  echo
  echo "No supported Agent platforms detected on this machine."
  echo "If you have one installed elsewhere, set its expected config dir first."
  echo "See docs/installation-guide.md for the per-platform detection markers."
fi

exit 0