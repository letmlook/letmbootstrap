# examples/

Worked examples of what the `letmbootstrap` skill produces. Each example shows the **target project's** output after running the skill — i.e., the files the skill would write into another project.

## What's here

| Example | What it demonstrates |
|---|---|
| [`letmbootstrap-self/`](letmbootstrap-self/) | The dogfood example: the letmbootstrap repo itself, with every section filled in |

## Why one example

The AGENTS.md says: *"Don't add templates for things not yet used by a real project."* The same rule applies to examples. One good example is enough to show the methodology; adding a second before a real user has reported using it would be premature.

When you adopt letmbootstrap in your own project, the output should look like the example — adjusted for your project's name, stack, and anti-goals. If it doesn't, the skill probably needs more metadata from you in Step 2 of the procedure.

## Reading order

1. [`letmbootstrap-self/README.md`](letmbootstrap-self/README.md) — what this example is and isn't
2. [`letmbootstrap-self/AGENTS.md`](letmbootstrap-self/AGENTS.md) — a populated project constitution (~50 lines)
3. [`letmbootstrap-self/docs/decisions/0001-bootstrap-with-letmbootstrap.md`](letmbootstrap-self/docs/decisions/0001-bootstrap-with-letmbootstrap.md) — the bootstrap decision record
4. [`letmbootstrap-self/skills/README.md`](letmbootstrap-self/skills/README.md) — a populated skills directory index

Each file has comments pointing at the canonical version in the repo root, so you can compare "what the example shows" with "what the real version looks like."

## How to add an example

When you adopt letmbootstrap in a real project and want to show others what your output looked like:

1. Copy the [`letmbootstrap-self/`](letmbootstrap-self/) directory to `examples/<your-project-name>/`.
2. Update the README to describe what your project is.
3. Update the AGENTS.md to your project's actual metadata.
4. Replace the bootstrap decision record with one specific to your project's adoption story.
5. **Sanitize before submitting.** Examples go into a public repo. Don't include secrets, internal URLs, or anything you wouldn't put on a public README.

Submit a PR linking your example. The maintainers will check:

- Does it follow the template structure (no missing sections, no added sections that the skill doesn't produce)?
- Are the anti-goals real anti-goals (not aspirational)?
- Is the decision record's "Alternatives considered" populated with real alternatives?

## What this README is not

- **Not a tutorial.** The skill body is the tutorial; this directory shows output.
- **Not exhaustive.** Each example shows one adoption. Different projects adopt differently.