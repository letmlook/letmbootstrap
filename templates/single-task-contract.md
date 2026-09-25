# Single-Task Contract — <Short title>

> **Fill this in 30 seconds before each Agent task.** Cost: 30 seconds. Saves: ~30 minutes of re-orientation.

## Task

<One sentence: verb + noun. Concrete, observable.>

> Example: "Add `--format json` option to the `list` CLI command."

## Required reading

- `<doc or file path>` — <why>
- `<existing similar implementation>` — <mimic this style>

> 2-5 references is the sweet spot. Too few = Agent guesses. Too many = Agent drowns.

## Out of scope (do NOT do)

- <Boundary 1: e.g., "Don't change the YAML parser">
- <Boundary 2: e.g., "Don't add a new dependency">
- <Boundary 3: e.g., "Don't touch docs/decisions/ files">

> Explicit boundaries prevent the most common drift: "while I was at it..."

## Acceptance criteria

- [ ] <Observable criterion 1: e.g., "`--format json` appears in `--help` output">
- [ ] <Observable criterion 2: e.g., "Output is valid JSON parseable by `JSON.parse`">
- [ ] Tests cover: <cases — empty input, single item, many items>
- [ ] `pnpm typecheck && pnpm lint` passes
- [ ] <Any project-specific gate>

> Criteria must be **observable and verifiable**. Not "code looks clean" — that's subjective.

## Autonomous decision space

The Agent decides alone:

- <Implementation detail>
- <Test fixture content>
- <Error message wording (English)>
- <Internal helper names>

## Must ask me before

- <Anything that changes the public API>
- <Anything that affects the scope boundaries above>
- <Adding a new dependency>
- <Touching files outside the stated scope>
- <Deleting or rewriting existing tests>

## Notes (optional)

<Anything that doesn't fit the above: links to related issues, prior attempts, special considerations>