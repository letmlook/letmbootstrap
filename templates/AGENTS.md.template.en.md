# AGENTS.md — <PROJECT_NAME>

## Project is
<ONE SENTENCE: what this project does and for whom. Example: "A CLI that converts markdown files to Notion pages via the Notion API.">

## Stack
- Language: <e.g., TypeScript 5.x>
- Runtime: <e.g., Node 22+>
- Framework: <e.g., none / Express / Hono>
- Package manager: <e.g., pnpm>
- Test: <e.g., vitest>

## Project is NOT
- <Anti-goal 1: e.g., "A web service. CLI only.">
- <Anti-goal 2: e.g., "Persistent storage. Stateless transformations only.">
- <Anti-goal 3: e.g., "Multi-user auth. Single-user local tool.">

## Required reading (in order)
1. `README.md` — overview
2. `docs/decisions/` — settled decisions (don't re-litigate; if you must change one, write a new decision file)
3. <link to architecture doc, if any>
4. <link to contributing guide, if any>

## Where new code goes
| Goal | Location |
|---|---|
| New CLI command | `src/commands/` |
| New HTTP handler | `src/api/handlers/` |
| New data source adapter | `src/sources/` |
| New CLI flag on existing command | edit `src/commands/<name>.ts` |
| New test fixture | `tests/fixtures/` |
| New documentation page | `docs/` |
| New decision | `docs/decisions/NNNN-<short>.md` |

## Definition of Done (per PR)
- [ ] Change has corresponding test(s) that fail without the change
- [ ] All tests in the affected package pass (`pnpm --filter <pkg> test`)
- [ ] `pnpm typecheck` passes (or `tsc --noEmit`)
- [ ] Lint passes (`pnpm lint`)
- [ ] Docs / JSDoc / examples updated in the same diff if behavior changed
- [ ] `pnpm run change-scope` shows the diff stays within the stated scope
- [ ] No drive-by refactors in unrelated files

## Forbidden
- Adding a new top-level dependency without writing/updating a decision note
- "Helpfully" extending scope beyond what the task asked
- Skipping pre-commit/pre-push hooks with `--no-verify`
- Touching `vendor/`, `.git/`, `dist/`, `node_modules/`, `*.lock` (unless that's the task)
- Tests that pass when the code is broken (assertion-free tests)
- Merging to main without all gates green

## Decisions
Before doing anything significant, run `ls docs/decisions/`. If your concern is addressed, follow the decision. If you want to change it, **write a new decision file** — don't argue in PR comments or chat.

## Tasks
Before starting any non-trivial task, fill a single-task contract (see `templates/single-task-contract.md`). Keep it with the task in chat or as a scratch file.

## Stop and ask if
- You find yourself wanting to introduce a new pattern that isn't in `Where new code goes`
- You find yourself wanting to relax a rule in `Forbidden`
- You find a decision note that contradicts what the user asked — surface it and ask which wins