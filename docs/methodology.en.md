# The letmbootstrap Methodology

A short, opinionated guide for solo developers iterating with an Agent. The goal: **make project knowledge persistent and machine-readable so the Agent doesn't re-derive context every session, and so it can't quietly violate the rules.**

## Why this exists

Default Agent behavior has three failure modes when iterating on a project:

1. **Drift** — Agent doesn't know what's been decided, so it re-litigates settled choices.
2. **Scope creep** — Agent "helpfully" extends beyond the task, touching unrelated code.
3. **Forgotten rules** — Conventions live in chat history and evaporate between sessions.

Every piece of letmbootstrap targets one of these failures. The methodology is small on purpose — it's a set of leverage points, not a framework.

## The 4 pieces

### 1. `AGENTS.md` — the project constitution

A 30-line file at the project root. Six sections, each one decision that prevents drift:

- **Project is** — one sentence. Forces clarity on what this project does.
- **Stack** — what runtime/language. Makes the Agent respect the language.
- **Project is NOT** — anti-goals. The single most powerful section: lists what the Agent must NOT add.
- **Required reading (in order)** — explicit doc order so the Agent doesn't read stale docs first.
- **Where new code goes** — extension map. New CLI command goes here, new HTTP handler goes there. Prevents Agent from inventing new structure.
- **Definition of Done** — checklist the Agent runs against its own work before claiming done.
- **Forbidden** — non-negotiable no-fly zones (vendor/, --no-verify, drive-by refactors).

**Cost to write:** 15 minutes the first time, 5 minutes to maintain.
**ROI:** Eliminates ~70% of "you forgot rule X" re-prompting.

### 2. `docs/decisions/` — the decision log

Append-only. One file per decision: `NNNN-short-title.md`. Four segments:

- **Context** — the problem or opportunity. Written to stand without the solution.
- **Decision** — what was decided, present tense, factual.
- **Consequences** — what's gained, what's lost, what's changed about how we work.
- **Alternatives considered** — what was rejected and why. Mandatory.

The single most important rule: **alternatives must be real**. A decision record that says "we picked SQLite" without "we rejected Postgres because X" invites re-litigation every six months.

**The lifecycle:**
- `proposed/` — proposal under review, not yet built.
- `implemented/` — shipped. Code follows note; note follows code; they stay in sync.
- `rejected/` — considered and declined, kept only while its rationale prevents a plausible mistake.

**Why this works for Agent collaboration:** Before starting any significant change, the Agent reads recent decisions. If the change contradicts one, the Agent either follows the decision or writes a new decision explicitly. Re-litigation becomes visible — it's a file write, not a paragraph in a PR comment.

### 3. `skills/` — procedure over improvisation

A `skills/` (or `.agent-skills/`) directory of `SKILL.md` files. Each one:

- Has frontmatter: `name:` + `description:` that says **when to invoke**.
- Body is step-by-step procedure with verifiable success criteria.
- Refuses to give subjective advice — only commands, checks, and decision rules.

The trigger description is the hardest part to write. A skill whose description says "useful for code review" will never be invoked. A skill whose description says "Use when reviewing a PR or before marking one ready" gets invoked at the right moment.

Common skills to ship:

- `pre-push-checks` — narrow test selection before push
- `code-review` — what to check in a PR
- `debug-flaky-test` — isolation, quiescence, restoration
- `release-checklist` — version bump, changelog, tags

### 4. Single-task contract — 30 seconds before each task

Every time you hand the Agent a task, fill this in first (it goes in the chat or as a file):

```
## Task
[verb + noun, one sentence]

## Required reading
- doc / file references

## Out of scope (do NOT do)
- boundaries

## Acceptance criteria
- [ ] observable criterion
- [ ] observable criterion
- [ ] tests cover: cases
- [ ] gates pass: typecheck / lint / test

## Autonomous decision space
- what the Agent decides alone

## Must ask me before
- what the Agent must escalate
```

**This is the anti-drift nuclear weapon.** The contract does three things at once:
- **Clarifies your own thinking** — by the time you've filled it in, you know exactly what you want.
- **Prevents scope creep** — explicit "do NOT" list.
- **Gives the Agent a stop signal** — acceptance criteria let it know when it's done, so it doesn't keep going or stop too early.

**Cost:** 30 seconds. **ROI:** Saves 30 minutes of re-orientation per task on average.

## The 3 principles

### Principle 1: Materialize decisions

Anything you decide that affects the project must exist as a file the Agent can read. Three rules:

- If you'll need to re-decide it later → write a decision note.
- If you'll need to remember how to do it → write a skill.
- If it's a one-off that won't recur → still write it in the commit message.

**Don't keep conventions in chat history. Don't keep conventions in your head. Write them where the Agent can read them.**

### Principle 2: Mechanize rules

Any rule you want the Agent to follow must have a check. Three forms:

- **Pre-commit hook** — fast (seconds), runs on every commit.
- **Pre-push hook** — medium (tens of seconds), runs on every push.
- **CI gate** — slow (minutes), exhaustive matrix on every PR.

If a rule isn't worth a script, it's not worth putting in AGENTS.md. Suggestions without enforcement are noise.

Examples:
- "Use 2-space indent" → `prettier --check`
- "TypeScript strict" → `tsc --noEmit --strict`
- "No unused exports" → `ts-prune` or `knip`
- "Bilingual docs in sync" → custom pairing script
- "Per-file 100% coverage" → coverage gate in CI

### Principle 3: Bound every task with acceptance criteria

Every task handed to the Agent must have:
- **What done looks like** (observable, not subjective).
- **What NOT to do** (explicit boundaries).
- **What to escalate** (autonomous vs. must-ask split).

If you can't write the acceptance criteria, the task isn't ready for the Agent. Refine the task until you can.

## Anti-patterns (what to avoid)

- **Don't write a "philosophy" without steps.** "Communication is important" is not a rule. "Always fill a single-task contract before asking the Agent" is a rule.
- **Don't merge AGENTS.md and README.md.** AGENTS.md is for the Agent; README.md is for humans (and other tools). Different readers, different files.
- **Don't write decisions about things that won't recur.** Every decision should pay back its writing cost in less than a year. If it's a one-off hack, put it in the commit message.
- **Don't make skills write-only documents.** A skill that's never invoked is dead. Trigger descriptions must be specific.
- **Don't run the full test suite before every commit.** Use `change-scope` or equivalent to find the narrow tests that cover your diff. CI owns the full matrix.

## Scaling up

This 4-piece set works for a single-developer project. As you scale:

| Need | Add |
|---|---|
| Multi-developer coordination | Stacked PRs + GitHub native stack |
| Cross-package refactors | Architecture map (`docs/architecture.md`) with seam definitions |
| Heavy Agent use | Snapshot tests (recorded sessions) as the canonical behavior oracle |
| Multi-language i18n | Bilingual doc pair + pairing gate |
| Long-running projects | Archived decisions tree for historical-only notes |

Don't add any of these until the 4-piece set is running smoothly. Each one builds on the foundation.

## Where this came from

Synthesized from the deepseek-harness project's `.agents/notes/` + `.agents/skills/` system. The harness is a large multi-package codebase developed by multiple humans and multiple Agents over 18+ months. The methodology scaled from "single dev + Agent" to "team + many Agents" by the same principles — materialize, mechanize, bound.