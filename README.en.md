# letmbootstrap

> **letmbootstrap** — solo + Agent iteration methodology. Lets one person iterate with high-quality agent collaboration, without agent drift or re-prompting.

A reusable collaboration methodology for solo + Agent iterative development. Designed to prevent Agent drift, reduce re-prompting, and keep project decisions persistent across sessions.

## What's in here

```
letmbootstrap/
├── README.md                          # this file
├── INSTALL.md                         # 5-minute install into your Agent platform
├── FAQ.md                             # common questions (English: FAQ.en.md)
├── GLOSSARY.md                        # terminology (English: GLOSSARY.en.md)
├── AGENTS.md                          # dogfooded project constitution
├── ARCHITECTURE.md                    # five-layer architecture overview
├── CONTRIBUTING.md                    # how to send a PR
├── CHANGELOG.md                       # release notes
├── LICENSE                            # MIT
├── CODE_OF_CONDUCT.md                 # community norms
├── SECURITY.md                        # how to report a security issue
│
├── docs/
│   ├── methodology.md                 # the 4-piece anti-drift narrative
│   ├── installation-guide.md          # per-platform install steps + troubleshooting
│   ├── agent-compatibility.md         # which Agents can run the skill
│   ├── skills-catalog.md              # what skills ship + how to write more
│   ├── faq.md                         # common questions
│   ├── glossary.md                    # terms used in this repo
│   └── decisions/                     # decision log (dogfooded)
│
├── templates/                         # files the skill copies into target projects
│   ├── README.md
│   ├── AGENTS.md.template             # project constitution
│   ├── decision.md.template           # decision record
│   └── single-task-contract.md        # task contract
│
├── skills/                            # the installable Agent skills
│   └── letmbootstrap/
│       └── SKILL.md                   # the bootstrap skill
│
├── scripts/                           # host-side automation
│   ├── README.md
│   └── install.sh                     # non-destructive installer
│
└── examples/                          # worked examples of skill output
    ├── README.md
    └── letmbootstrap-self/            # dogfooded example
```

## Where to start

| If you want to… | Read |
|---|---|
| Install the skill onto your Agent | [`INSTALL.md`](INSTALL.md) |
| Understand the methodology | [`docs/methodology.md`](docs/methodology.md) |
| See per-platform install details | [`docs/installation-guide.md`](docs/installation-guide.md) |
| Have your Agent install it (no shell typing) | [`docs/agent-driven-install.md`](docs/agent-driven-install.md) |
| Check if your Agent is supported | [`docs/agent-compatibility.md`](docs/agent-compatibility.md) |
| See the repo's own architecture | [`ARCHITECTURE.md`](ARCHITECTURE.md) |
| Send a PR | [`CONTRIBUTING.md`](CONTRIBUTING.md) |
| Look up a term | [`GLOSSARY.md`](GLOSSARY.md) |
| Find a quick answer | [`FAQ.md`](FAQ.md) |
| Browse the release notes | [`CHANGELOG.md`](CHANGELOG.md) |

## The 4-piece set (anti-drift minimum)

1. **`AGENTS.md`** — 30-line project constitution: what / isn't / read / where / done / forbidden.
2. **`docs/decisions/`** — append-only decision log (problem / decision / consequences / rejected alternatives). Stops Agent from re-litigating settled choices.
3. **`skills/`** — step-by-step procedures the Agent follows without improvising.
4. **Single-task contract** — fill in 30 seconds before each Agent task (task / read / not / done / autonomous / must-ask). Prevents scope creep and re-prompting.

## The 3 principles

1. **Materialize decisions.** Don't keep them in your head or in chat history. Write them down where the Agent can read them.
2. **Mechanize rules.** Every AGENTS.md rule gets an exit-1 script. No "be careful" without a check.
3. **Bound every task with acceptance criteria.** Tight cases drive agents off-track because they don't know what "done" means.

## Quick start

You have two distinct jobs:

### Job A — install the letmbootstrap skill onto your Agent

```bash
# from inside this repo
./scripts/install.sh                # dry-run: see what would happen
./scripts/install.sh --apply        # actually install into every detected Agent
```

Or pick one platform:

```bash
./scripts/install.sh --apply --platform claude-code
./scripts/install.sh --apply --platform mavis --agent-name my-dev-agent
```

Supported platforms: Mavis (MiniMax Code), Claude Code, Codex CLI, Cursor, Gemini CLI, Aider, Devin, OpenCode. See [`INSTALL.md`](INSTALL.md) for the full table and [`docs/agent-compatibility.md`](docs/agent-compatibility.md) for what each platform supports.

**The installer never deletes anything.** Re-running it is safe. The skill itself is non-destructive — it cannot `rm` or overwrite files in your projects without explicit per-file consent.

### Job B — use the skill to bootstrap a target project

Once the skill is on your Agent (Job A), open a session in any project you want to apply the methodology to and say one of:

- "letmbootstrap init"
- "搭三件套"
- "init methodology"

The Agent will run the guided setup: preflight check, ask 5 metadata questions, preview the writes, then on confirmation, create `AGENTS.md` + `docs/decisions/` + `skills/`. It will not touch your existing files unless you explicitly approve each one.

Or copy the templates manually:

```bash
# from inside the target project
cp /Users/letmlook/code/letmbootstrap/templates/AGENTS.md.template ./AGENTS.md
cp /Users/letmlook/code/letmbootstrap/templates/decision.md.template ./docs/decisions/0001-bootstrap.md
mkdir -p .agent-skills && cp /Users/letmlook/code/letmbootstrap/templates/single-task-contract.md ./.agent-skills/
```

Then customize the `AGENTS.md` for your project (project name, stack, anti-goals, where-new-code-goes).

## Origin

Synthesized from the deepseek-harness project's `.agents/notes/` + `.agents/skills/` system, which demonstrates how multi-human + multi-Agent collaboration can produce high-quality iteration with minimal re-orientation.