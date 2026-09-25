# Architecture

What this repo is, how its parts fit together, and the design rules that bind them.

## One-sentence description

A reusable collaboration methodology template for solo + Agent iterative development, packaged as one installable Agent skill plus the docs and templates that explain and sustain it.

## Repository shape

```
letmbootstrap/
├── README.md                          # marketing + top-level index
├── INSTALL.md                         # 1-pager: how to put the skill on your Agent
├── AGENTS.md                          # dogfooded project constitution (30-line rule)
├── ARCHITECTURE.md                    # this file
├── CONTRIBUTING.md                    # how to send a PR
├── CHANGELOG.md                       # release notes
├── LICENSE                            # MIT
├── CODE_OF_CONDUCT.md                 # community norms
├── SECURITY.md                        # how to report a security issue
│
├── docs/
│   ├── methodology.md                 # the 4-piece narrative (≤ 1500 words)
│   ├── installation-guide.md          # per-platform install details
│   ├── agent-compatibility.md         # matrix across Agent platforms
│   ├── skills-catalog.md              # which skills ship + how to add more
│   ├── faq.md                         # common questions (mirrored at /FAQ.md)
│   ├── glossary.md                    # terms used in this repo
│   └── decisions/                     # append-only decision log
│
├── templates/                         # files the skill copies into target projects
│   ├── README.md                      # index of the templates
│   ├── AGENTS.md.template             # project constitution
│   ├── decision.md.template           # decision record
│   └── single-task-contract.md        # task contract
│
├── skills/                            # the installable Agent skills
│   └── letmbootstrap/
│       └── SKILL.md                   # the bootstrap skill
│
├── scripts/                           # host-side automation
│   ├── README.md                      # index of the scripts
│   └── install.sh                     # non-destructive installer
│
├── examples/                          # worked examples of skill output
│   └── letmbootstrap-self/            # the dogfood example
│
└── .github/
    └── workflows/                     # CI for the repo itself
```

## Five-layer architecture

The repo is split into five layers with explicit dependencies:

| Layer | Purpose | Examples | Depends on |
|---|---|---|---|
| **1. Constitution** | Define the project's own rules | `AGENTS.md` | nothing |
| **2. Narrative** | Explain why the rules exist | `docs/methodology.md`, `ARCHITECTURE.md` | Layer 1 |
| **3. Templates** | Files that get copied into other projects | `templates/*.template` | Layer 2 |
| **4. Skill** | An Agent-executable procedure | `skills/letmbootstrap/SKILL.md` | Layers 1, 2, 3 |
| **5. Installer** | Host-side automation that distributes Layer 4 | `scripts/install.sh` | Layers 1, 4 |

Dependency direction is strictly downward: a Layer 5 file may reference a Layer 1 file, but never the other way around. This keeps the constitution stable — every other layer can change without changing it.

## What "non-destructive" means across layers

The non-destructive guarantee from [`docs/decisions/0001-keep-skill-non-destructive.md`](docs/decisions/0001-keep-skill-non-destructive.md) is binding on every layer:

| Layer | Non-destructive rule |
|---|---|
| 1. Constitution | "Forbidden" section lists destructive operations as no-fly |
| 2. Narrative | Decisions explicitly record and defend the rule |
| 3. Templates | Templates are pure markdown — no shell, no rm |
| 4. Skill | "Hard rules — non-destructive by default" section at the top |
| 5. Installer | Static guard at the top of `scripts/install.sh` aborts on any `rm`/`unlink`/`mv`/`rmdir` pattern |

Any new layer that doesn't preserve the guarantee is a regression. The CI workflow in `.github/workflows/` runs the installer in dry-run mode on every push to catch regressions.

## Why this shape and not another

The repo deliberately avoids:

- **A runtime.** No code, no build, no tests. It's docs + templates + one shell script. Adding a runtime would push a maintenance burden onto the user for no methodology benefit.
- **A CLI.** Same reason. The install path is one shell script and one `cp -R`. A CLI would be more code to install than the thing it installs.
- **A skill marketplace presence.** Skill marketplaces ship pre-installed skills. letmbootstrap is installed by `cp -R`. This is intentional — see [`docs/decisions/0001-keep-skill-non-destructive.md`](docs/decisions/0001-keep-skill-non-destructive.md) for the "no uninstall path" rationale, which extends to "no remote-managed install path."
- **Multiple skills in v1.** One skill is enough to demonstrate the methodology. Additional skills live in user projects under their own `skills/` directory once they adopt the methodology.

## Adding a new layer

If you need to add Layer 6, write a decision record first. The decision should explain:

- Why the existing five layers can't do the job
- What the new layer would own
- How it preserves the non-destructive guarantee

Until the decision is recorded, the new layer is rejected at PR review.

## Versioning

This repo follows [Semantic Versioning 2.0](https://semver.org/) with one extension: **the skill's `SKILL.md` frontmatter is part of the API contract**. Bumping the major version requires either a breaking change to the template format or a change to the non-destructive guarantee.

See [`CHANGELOG.md`](CHANGELOG.md) for the version history.

## What this file is not

- **Not a roadmap.** This is the architecture as it exists today, not the plan for what comes next.
- **Not a tutorial.** For "how do I use this", start at [`INSTALL.md`](INSTALL.md).
- **Not the AGENTS.md.** The constitution lives at [`AGENTS.md`](AGENTS.md) and is shorter and more opinionated. This file explains the shape; that file makes the rules.