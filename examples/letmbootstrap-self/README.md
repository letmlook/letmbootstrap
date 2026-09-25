# Example: letmbootstrap dogfooding itself

This example shows what the letmbootstrap skill produces when invoked on a project — using **the letmbootstrap repo itself** as the target.

The actual artifacts of the real bootstrap are committed to the parent repo (`AGENTS.md`, `docs/`, etc.). This `examples/letmbootstrap-self/` directory contains a **minimal, annotated copy** that shows what the skill would generate, with commentary on each section.

## What's in this example

```
examples/letmbootstrap-self/
├── README.md                      # this file
├── AGENTS.md                      # what a populated project constitution looks like
├── docs/
│   └── decisions/
│       └── 0001-bootstrap-with-letmbootstrap.md
└── skills/
    └── README.md                  # what the project's own skills directory contains
```

## How to read this example

1. Start with [`AGENTS.md`](AGENTS.md). Notice it is ~50 lines, not 500. That's the goal — short, opinionated, machine-readable.
2. Then read [`docs/decisions/0001-bootstrap-with-letmbootstrap.md`](docs/decisions/0001-bootstrap-with-letmbootstrap.md). The "Alternatives considered" section is mandatory; that's the part that prevents the Agent from re-litigating the decision later.
3. Finally read [`skills/README.md`](skills/README.md) — the skills directory is for *project-specific* procedures, not the letmbootstrap skill itself.

## What this example deliberately omits

- A real source tree (`src/`, tests, build config). The point is the methodology scaffold, not a runnable project.
- Multiple decision files. A real project accumulates decisions over time; one example decision is enough to show the format.
- A populated `single-task-contract.md`. The template lives in [`templates/`](../../templates/single-task-contract.md); the example would just repeat it.

## What the actual repo looks like

This is the canonical, real version that the letmbootstrap team uses day-to-day:

- [`AGENTS.md`](../../AGENTS.md) — the constitution the team operates under
- [`docs/methodology.md`](../../docs/methodology.md) — the methodology narrative
- [`docs/decisions/`](../../docs/decisions/) — the decision log
- [`skills/letmbootstrap/`](../../skills/letmbootstrap/) — the skill itself

The repo uses the methodology on itself. That is what "dogfooding" means in this context.

## Using this example

When you run the letmbootstrap skill on your own project, the output should look like this example — adjusted for your project's name, stack, and anti-goals. If it doesn't, the skill probably needs more metadata from you in Step 2.