# Agent Compatibility Matrix

> Which Agents can run the letmbootstrap skill, and how.

## TL;DR

The skill is **a single `SKILL.md` file with YAML frontmatter**. Any Agent that:

1. Loads `SKILL.md` files from a known directory, and
2. Parses `name:` + `description:` from the frontmatter, and
3. Matches user input against the `description:` to decide when to invoke,

…can run letmbootstrap with zero modification. The skill body uses only standard markdown and explicit step-by-step procedure — no platform-specific syntax.

If your Agent doesn't have a skills concept, see [§ Agents without native skill support](#agents-without-native-skill-support).

## Matrix

| Agent | Skill support | Install path | Trigger syntax | Notes |
|---|---|---|---|---|
| **MiniMax Code / Mavis** | ✅ native | `~/.minimax/agents/<name>/skills/` | trigger phrase match | recommended host |
| **Claude Code** | ✅ native | `~/.claude/skills/` | trigger phrase match | most polished skill UX |
| **OpenAI Codex CLI** | ⚠️ partial | `.agent-skills/` per-project, or `~/.codex/skills/` (newer versions) | trigger phrase match | version-dependent; paste-on-invoke as fallback |
| **Cursor** | ✅ native | `.cursor/skills/` per-project | trigger phrase match | per-project only |
| **Gemini CLI** | ✅ native | `~/.gemini/skills/` | trigger phrase match | global only |
| **Aider** | ❌ no native skills | `.aider/conventions.md` reference | manual / paste-on-invoke | conventions-file workaround |
| **Devin** | ✅ native | `.devin/skills/` per-project | session-prompt reference | per-project only |
| **OpenCode** | ✅ native | `.opencode/skills/` or `~/.config/opencode/skills/` | trigger phrase match | both scopes work |
| **Windsurf** | ⚠️ via AGENTS.md | `.windsurf/` per-project | inline in AGENTS.md | partial — see notes |
| **Continue.dev** | ⚠️ via config | `~/.continue/config.json` | inline reference | partial |
| **Cline / Roo Code** | ⚠️ via custom instructions | `.clinerules` / `.roo/` | inline | partial |

> Coverage here is based on what each platform documented at the time of writing. If a row is wrong, open an issue — we treat this matrix as living documentation.

## Per-platform notes

### MiniMax Code / Mavis

- Native `skill` tool reads `~/.minimax/agents/<agent-name>/skills/<skill-name>/SKILL.md`.
- Frontmatter contract: `name:` + `description:`.
- Trigger phrase matching against `description:` is done by the runtime, not by the Agent itself.
- Skill content is read into context when triggered; the body is the procedure.
- **Recommended Agent name for hosting letmbootstrap:** the Agent you use for project bootstrap. Default: `mavis`.

### Claude Code

- Native skill support: reads `~/.claude/skills/` (global) and `./.claude/skills/` (per-project).
- Same frontmatter contract.
- Triggers: matches `description:` against user input.

### OpenAI Codex CLI

- Older Codex versions: no skills directory; use paste-on-invoke.
- Newer Codex versions: support `~/.codex/skills/`. Per-project `.agent-skills/` is the safe fallback that always works.
- When in doubt, reference the skill path in your project's `AGENTS.md`:

```markdown
## Skills
Skills in this project live in `.agent-skills/`. Read `<skill>/SKILL.md` when the trigger phrase matches.
```

### Cursor

- Per-project only. No global skills directory.
- Reads `./.cursor/skills/<name>/SKILL.md`.
- Skills picked up on session start.

### Gemini CLI

- Reads `~/.gemini/skills/`.
- Same frontmatter contract.
- Global scope.

### Aider

- No native skills concept. Aider reads `~/.aider/conventions.md` and per-project `.aider/conventions.md`.
- Workaround: copy the SKILL.md into your conventions file (or reference its path), and Aider will follow it when triggered.
- For one-off invocations, paste `SKILL.md` body into chat.

### Devin

- Reads `./.devin/` files per session.
- Per-project install.
- Reference the skill in your session prompt: "When I say 'letmbootstrap init', read `.devin/skills/letmbootstrap/SKILL.md`."

### OpenCode

- Supports both per-project (`.opencode/skills/`) and global (`~/.config/opencode/skills/`).
- Same frontmatter contract.

### Windsurf

- Doesn't have a skills directory per se, but reads `.windsurf/` config and project-level rules.
- Workaround: include a reference in your project's `AGENTS.md` or `.windsurfrules`.

### Continue.dev

- Configured via `~/.continue/config.json` with custom slash commands.
- Workaround: register letmbootstrap as a slash command pointing at `SKILL.md`.

### Cline / Roo Code

- Custom instructions via `.clinerules` or `.roo/` config.
- Workaround: reference the SKILL.md path in your custom instructions.

## Agents without native skill support

If your Agent isn't listed above (or has only partial support), the universal fallback is **paste-on-invoke**:

1. Copy `skills/letmbootstrap/SKILL.md` content.
2. Paste it into chat with: "Follow this procedure. Start from Step 1."
3. The Agent will execute the steps as if it had loaded it natively.

This is uglier than native install but works everywhere. The skill is designed to be self-contained for exactly this reason.

## What the skill assumes about its host

The skill body references a few things that may or may not exist on every Agent:

| Assumption | Fallback |
|---|---|
| Can read absolute paths | Skill body uses absolute path `/Users/letmlook/code/letmbootstrap/`. If your Agent can't, symlink it into a path it can read. |
| Has a `question UI` / `ask_user` tool | Falls back to plain questions in chat. |
| Can write files in the current project | Required for the bootstrap to work. If the Agent is read-only, the bootstrap fails by design. |
| Can run `ls -la` / `mkdir -p` | Standard shell. If the Agent can't run shell, the skill degrades to manual copy-paste. |

These are documented as explicit assumptions, not hidden dependencies. Every Agent that can read & write files in a project directory can run the skill.

## How to add support for a new Agent

Three steps:

1. **Identify the install path.** Check the Agent's docs for "skills", "extensions", "custom instructions", or similar.
2. **Add a row to the table above.** Include path, trigger syntax, and any quirks.
3. **Add a section to `INSTALL.md` and `docs/installation-guide.md`** with a copy-paste install snippet.

PRs welcome. The installer auto-detects based on directory markers; adding a new platform means adding a detection rule in `scripts/install.sh` and a documentation row.

## What this matrix does NOT cover

- **Authentication / billing** of any Agent — out of scope.
- **Skill marketplaces** — letmbootstrap is not on any marketplace by design. Install is always direct from this repo.
- **Cross-Agent skill translation** — if a target Agent uses different frontmatter keys, you write a thin wrapper. We don't ship wrappers; the skill is portable as-is.