#!/usr/bin/env pwsh
# install.ps1 — install the letmbootstrap skill into a supported Agent platform.
# Windows / PowerShell Core port of install.sh.
#
# Design principles (binding):
#   1. Dry-run by default. Pass -Apply to actually write anything.
#   2. Additive only. Never Remove-Item, Move-Item, Rename-Item, or overwrite.
#   3. Idempotent. Re-running is a no-op on populated targets.
#   4. Skip on conflict. If target already exists, print SKIP and move on.
#   5. Never mutate the source repo at $SourceDir.
#
# Static guard: this script intentionally contains no destructive commands.
# Patterns are assembled at runtime so the guard does not flag itself.
#
# Usage:
#   .\scripts\install.ps1                                 # dry-run for all detected platforms
#   .\scripts\install.ps1 -Apply                          # install for all detected platforms
#   .\scripts\install.ps1 -Apply -Platform claude-code    # one platform only
#   .\scripts\install.ps1 -Apply -Symlink                 # symlink instead of copy
#   .\scripts\install.ps1 -Help                           # usage

[CmdletBinding()]
param(
    [switch]$Apply,
    [string[]]$Platform = @(),
    [string]$AgentName = "mavis",
    [switch]$Symlink,
    [switch]$Help
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------- Static guard (belt + suspenders) ----------
# Assemble destructive pattern strings at runtime so this script's own source
# doesn't contain them as literals.
$scriptPath = $MyInvocation.MyCommand.Path
$content = Get-Content -Raw -Path $scriptPath

$forbiddenCmdlets = @(
    ('Remove' + '-Item'),
    ('Move' + '-Item'),
    ('Rename' + '-Item'),
    ('Clear' + '-Item'),
    ('Clear' + '-Content')
)
$forbiddenAliases = @(
    ('d' + 'el'),
    ('er' + 'ase'),
    ('r' + 'd'),
    ('r' + 'i'),
    ('r' + 'm'),
    ('m' + 'v'),
    ('mo' + 've'),
    ('re' + 'n'),
    ('r' + 'ni')
)

$violations = @()
foreach ($cmdlet in $forbiddenCmdlets) {
    $regex = '(?m)^[^#]*\b' + [regex]::Escape($cmdlet) + '\b'
    if ($content -match $regex) {
        $violations += $cmdlet
    }
}
foreach ($alias in $forbiddenAliases) {
    # Aliases are ambiguous when short (e.g. 'rm' could appear in $rm_count).
    # Require start-of-line or statement separator before; word boundary after.
    $regex = '(?m)(^|[;&\s])' + [regex]::Escape($alias) + '\b'
    if ($content -match $regex) {
        $violations += $alias
    }
}
if ($violations.Count -gt 0) {
    Write-Error "REFUSE: scripts/install.ps1 contains destructive command patterns: $($violations -join ', ')"
    Write-Error "        This script is non-destructive by design. Refusing to run."
    exit 78  # EX_CONFIG
}

# ---------- Resolve source ----------
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceDir = Resolve-Path (Join-Path $ScriptDir "..")
$SkillSrc = Join-Path $SourceDir "skills/letmbootstrap"
$SkillName = "letmbootstrap"

if (-not (Test-Path $SkillSrc)) {
    Write-Error "ERROR: skill payload not found at $SkillSrc"
    Write-Error "       Are you running this from inside the letmbootstrap repo?"
    exit 1
}

# ---------- Help ----------
if ($Help) {
    Write-Host @"
install.ps1 — install the letmbootstrap skill into a supported Agent platform.

USAGE
    .\scripts\install.ps1 [flags]

FLAGS
    (no flag)              Dry-run for every detected platform (default).
    -Apply                 Actually write. Without this, the script is read-only.
    -Platform <name>       Restrict to one platform. Comma-separated or repeated.
                           Valid: mavis, claude-code, codex, cursor, gemini-cli,
                                  aider, devin, opencode.
    -AgentName <name>      For Mavis only — which Agent to install under (default: mavis).
    -Symlink               Symlink instead of copy. Useful during development.
    -Help                  Print this help.

NON-DESTRUCTIVE GUARANTEES
    - Never destructive commands (anything that erases, relocates, or renames files).
    - Skip-and-report on conflict (existing target = no-op).
    - Source repo at $SourceDir is never modified.
    - Idempotent. Re-running is safe.

EXAMPLES
    .\scripts\install.ps1                                   # dry-run, all platforms
    .\scripts\install.ps1 -Apply                           # install all detected platforms
    .\scripts\install.ps1 -Apply -Platform claude-code     # one platform only
    .\scripts\install.ps1 -Apply -Symlink                  # live-link during development
"@
    exit 0
}

# ---------- Validate platforms ----------
$validIds = @('mavis', 'claude-code', 'codex', 'cursor', 'gemini-cli', 'aider', 'devin', 'opencode')
foreach ($p in $Platform) {
    if ($validIds -notcontains $p) {
        Write-Error "ERROR: unknown platform '$p'"
        Write-Error "       Valid: $($validIds -join ', ')"
        exit 64
    }
}

# ---------- Output state ----------
$modeLabel = if ($Apply) { "APPLY" } else { "DRY-RUN" }
Write-Host "================================================================"
Write-Host " letmbootstrap skill installer (PowerShell)"
Write-Host " mode:     $modeLabel"
Write-Host " symlink:  $Symlink"
Write-Host " source:   $SkillSrc"
Write-Host "================================================================"
Write-Host ""

# ---------- Platform detection ----------
# Each detector returns either $null, a single hashtable, or an array of hashtables.

function Get-MavisTarget {
    $markerPath = Join-Path $HOME ".minimax"
    if (Test-Path $markerPath) {
        return @{ id = "mavis"; target = (Join-Path $HOME ".minimax/agents/$AgentName/skills/$SkillName") }
    }
    return $null
}

function Get-ClaudeCodeTarget {
    $results = @()
    $globalMarker = Join-Path $HOME ".claude"
    if (Test-Path $globalMarker) {
        $results += @{ id = "claude-code"; target = (Join-Path $HOME ".claude/skills/$SkillName") }
    }
    $localMarker = Join-Path (Get-Location) ".claude"
    if (Test-Path $localMarker) {
        $results += @{ id = "claude-code"; target = (Join-Path (Get-Location) ".claude/skills/$SkillName") }
    }
    return , $results
}

function Get-CodexTarget {
    $markerPath = Join-Path $HOME ".codex"
    if (Test-Path $markerPath) {
        return @{ id = "codex"; target = (Join-Path $HOME ".codex/skills/$SkillName") }
    }
    return $null
}

function Get-CursorTarget {
    $localMarker = Join-Path (Get-Location) ".cursor"
    if (Test-Path $localMarker) {
        return @{ id = "cursor"; target = (Join-Path (Get-Location) ".cursor/skills/$SkillName") }
    }
    return $null
}

function Get-GeminiCLITarget {
    $markerPath = Join-Path $HOME ".gemini"
    if (Test-Path $markerPath) {
        return @{ id = "gemini-cli"; target = (Join-Path $HOME ".gemini/skills/$SkillName") }
    }
    return $null
}

function Get-AiderTarget {
    $results = @()
    $projectMarker = Join-Path (Get-Location) ".aider"
    if (Test-Path $projectMarker) {
        $results += @{ id = "aider"; target = (Join-Path (Get-Location) ".aider/skills/$SkillName") }
    }
    $homeMarker = Join-Path $HOME ".aider"
    if (Test-Path $homeMarker) {
        $results += @{ id = "aider"; target = (Join-Path $HOME ".aider/skills/$SkillName") }
    }
    return , $results
}

function Get-DevinTarget {
    $localMarker = Join-Path (Get-Location) ".devin"
    if (Test-Path $localMarker) {
        return @{ id = "devin"; target = (Join-Path (Get-Location) ".devin/skills/$SkillName") }
    }
    return $null
}

function Get-OpenCodeTarget {
    $results = @()
    $homeMarker = Join-Path $HOME ".config/opencode"
    if (Test-Path $homeMarker) {
        $results += @{ id = "opencode"; target = (Join-Path $HOME ".config/opencode/skills/$SkillName") }
    }
    $projMarker = Join-Path (Get-Location) ".opencode"
    if (Test-Path $projMarker) {
        $results += @{ id = "opencode"; target = (Join-Path (Get-Location) ".opencode/skills/$SkillName") }
    }
    return , $results
}

$detectors = @(
    ${function:Get-MavisTarget},
    ${function:Get-ClaudeCodeTarget},
    ${function:Get-CodexTarget},
    ${function:Get-CursorTarget},
    ${function:Get-GeminiCLITarget},
    ${function:Get-AiderTarget},
    ${function:Get-DevinTarget},
    ${function:Get-OpenCodeTarget}
)

# ---------- Walk detectors and install ----------
$installed = 0
$skipped = 0
$detected = 0

foreach ($detector in $detectors) {
    $found = & $detector
    if ($null -eq $found) {
        continue
    }
    $items = @($found)
    foreach ($entry in $items) {
        if ($null -eq $entry) { continue }
        $pid = $entry.id
        $target = $entry.target

        if ([string]::IsNullOrEmpty($pid)) {
            continue
        }

        # Apply --Platform filter
        if ($Platform.Count -gt 0 -and $Platform -notcontains $pid) {
            continue
        }

        $detected++

        # Conflict check
        if (Test-Path $target) {
            Write-Host "SKIP: [$pid] $target"
            Write-Host "      Already exists. Refusing to overwrite."
            $skipped++
            continue
        }

        # Plan
        $verb = if ($Symlink) { "ln -s (New-Item -ItemType SymbolicLink)" } else { "cp -R (Copy-Item -Recurse)" }
        Write-Host "PLAN: [$pid] $verb $SkillSrc -> $target"

        # Execute
        if ($Apply) {
            $parentDir = Split-Path -Parent $target
            New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
            if ($Symlink) {
                New-Item -ItemType SymbolicLink -Path $target -Target $SkillSrc | Out-Null
            } else {
                Copy-Item -Path $SkillSrc -Destination $target -Recurse -Force
            }
            Write-Host "  ✓ installed"
            $installed++
        }
    }
}

# ---------- Summary ----------
Write-Host ""
Write-Host "================================================================"
Write-Host " Summary"
Write-Host "   detected: $detected location(s)"
Write-Host "   installed: $installed"
Write-Host "   skipped:   $skipped (existing installations — preserved as-is)"
Write-Host "================================================================"

if (-not $Apply) {
    Write-Host ""
    Write-Host "This was a DRY-RUN. No files were written."
    Write-Host "Re-run with -Apply to perform the planned operations."
}

if ($detected -eq 0) {
    Write-Host ""
    Write-Host "No supported Agent platforms detected on this machine."
    Write-Host "If you have one installed elsewhere, set its expected config dir first."
    Write-Host "See docs/installation-guide.md for the per-platform detection markers."
}

exit 0