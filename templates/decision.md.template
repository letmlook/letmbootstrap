# NNNN — <Short title, kebab-case>

## Status
YYYY-MM-DD — proposed | implemented | rejected — <one-line reason>

## Context

What problem or opportunity drove this decision. Written so it stands without the proposed solution — a reader should understand the pressure even if they skip the decision.

Include:
- The observable symptom or constraint
- Why existing patterns don't address it
- The deadline or trigger if any

## Decision

What we decided. Present tense, factual. State the decision so a new Agent can verify the code matches it without ambiguity.

For example:
- "Store session logs as JSONL in `<configDir>/sessions/session-<id>.jsonl[.zstd]`."
- "Use SQLite for relational data, accessed via `better-sqlite3`."
- "Reject PRs that touch `vendor/`."

## Consequences

- ✅ **Gain:** <what this decision gives us>
- ❌ **Cost:** <what we give up or pay for it>
- ⚠️ **Workflow change:** <how our day-to-day work changes>

## Alternatives considered

Mandatory. Each genuine option gets one paragraph:

- **<Alternative A>:** <why rejected — one to three sentences>
- **<Alternative B>:** <why rejected>
- **<Alternative C>:** <why rejected>

**Rule: alternatives must be real.** Don't invent strawmen. If you can't reconstruct the alternative from the record, mark the section with:

```markdown
<!-- alternatives-not-recorded (pre-format or informal decision) -->
```

## Lifecycle

This file moves as the decision's status changes:

- `proposed/NNNN-*.md` → under review, code may or may not exist
- `implemented/NNNN-*.md` → shipped, code matches this file, facts stay in sync
- `rejected/NNNN-*.md` → considered and declined, kept only while it prevents a plausible mistake

When moving, update the `Status:` line and rewrite `## Decision` from future-tense (proposal) to present-tense (shipped) in the same change.