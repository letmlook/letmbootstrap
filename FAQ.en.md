# FAQ

Common questions, organized by topic. If your question isn't here, open an issue.

## General

### What does letmbootstrap actually do?

It installs a 4-piece anti-drift setup (`AGENTS.md` + `docs/decisions/` + `skills/` + single-task contract) into a project, customized to that project. The setup keeps Agent collaboration consistent across sessions — no more re-litigating settled decisions or re-prompting forgotten rules.

### Is this just for solo developers?

It started there. It also works for small teams and for projects where multiple Agents (or multiple Agent sessions) collaborate on the same code. The methodology scales by the same principles (materialize, mechanize, bound), but the AGENTS.md and decision log become more important as more readers (human and Agent) consume them.

### Is this tied to a specific Agent?

No. The skill works on any Agent that loads `SKILL.md` files and matches trigger phrases against the `description:` frontmatter. Compatibility matrix at [`agent-compatibility.md`](agent-compatibility.md).

### What language is the skill body in?

English. The trigger phrases include both English ("letmbootstrap init") and Chinese ("搭三件套", "初始化方法论") for convenience.

## Install / uninstall

### How do I install the letmbootstrap skill on my Agent?

```bash
git clone https://github.com/letmlook/letmbootstrap.git
cd letmbootstrap
./scripts/install.sh                # dry-run, see what would happen
./scripts/install.sh --apply        # actually install
```

Or follow [`INSTALL.md`](../INSTALL.md) for the one-pager. Details at [`installation-guide.md`](installation-guide.md).

### How do I uninstall it?

Manually. The installer never deletes anything, by design. To uninstall:

```bash
rm -rf "$HOME/.claude/skills/letmbootstrap"   # or wherever you installed it
```

This is something you do yourself — see [`docs/decisions/0001-keep-skill-non-destructive.md`](decisions/0001-keep-skill-non-destructive.md) for why there's no uninstall command.

### Can I install just for one project?

Yes. For per-project installs (Cursor, Devin, Codex per-project):

```bash
cd <your-project>
mkdir -p .cursor/skills
cp -R /path/to/letmbootstrap/skills/letmbootstrap .cursor/skills/
```

The skill is identical across global and per-project installs.

### I already have a `~/.claude/skills/letmbootstrap` from an older version. How do I update?

Re-run the installer — it skips existing installations. To actually update, manually replace:

```bash
rm -rf ~/.claude/skills/letmbootstrap   # you do this manually
cp -R /path/to/letmbootstrap/skills/letmbootstrap ~/.claude/skills/
```

Or use `--symlink` mode during development for live updates:

```bash
./scripts/install.sh --apply --symlink
```

## Methodology

### Why "letmbootstrap"?

"let me bootstrap" + "the methodology". Pronounced "let-me-bootstrap". Short enough to type in chat.

### Why not just AGENTS.md? Isn't that enough?

AGENTS.md is the constitution, but it's not enough on its own. Without `docs/decisions/`, the Agent re-litigates settled choices. Without `skills/`, the Agent improvises procedures that drift. Without the single-task contract, scope creep is uncontrolled. Each piece targets a specific failure mode — see [`methodology.md`](methodology.md) for the failure mode mapping.

### What if I only want AGENTS.md?

The skill asks. If you say "just AGENTS.md", it skips `docs/decisions/` and `skills/`. But the methodology is more effective with all four pieces — the cost is small and the ROI compounds.

### Do I need to fill the single-task contract for trivial tasks?

No. The contract is for non-trivial tasks. A trivial task (rename a variable, fix a typo) doesn't need one. The judgment: if you can answer "what does done look like?" in one sentence, skip the contract.

### My AGENTS.md is getting long. Should I split it?

Yes, if it grows past ~80 lines. Push detail into `docs/architecture.md`, `docs/ci.md`, etc. The AGENTS.md should be a one-screen index, not the full reference.

## Decisions

### What goes in a decision record vs. AGENTS.md?

**AGENTS.md** is for rules that apply to *every* change (anti-goals, forbidden ops, definition of done). **Decision records** are for one-off choices (we picked library X, we rejected library Y). If the rule recurs across many decisions, it belongs in AGENTS.md. If it's a single choice with a rationale, it belongs in a decision.

### Can I edit a decision after it's implemented?

Yes, if the situation changed. Move the old version to `implemented/` (with a note), write a new decision in `proposed/`. Don't rewrite history — append a new record.

### What if I have nothing to put in "Alternatives considered"?

Use the marker:

```markdown
<!-- alternatives-not-recorded (pre-format or informal decision) -->
```

This is honest: "we didn't record the alternatives at the time." Future readers will know not to trust the alternatives section as exhaustive.

## Non-destructive guarantee

### Why no `--force` or `--reset` flag?

See [`docs/decisions/0001-keep-skill-non-destructive.md`](decisions/0001-keep-skill-non-destructive.md). The short answer: any flag that overrides skip-on-conflict is one keystroke away from accidental deletion. The skill values durability; users do destructive ops themselves.

### What if I really want to delete the installed skill?

You do it manually:

```bash
rm -rf <install-path>/letmbootstrap
```

This is intentional. The skill doesn't know what else might be at `<install-path>/` (other skills, your own files), so it refuses to do this for you.

### What if my Agent gets into a loop trying to delete files?

That's a different problem — likely the agent's behavior, not the skill's. Check the skill's output: did it actually try to delete, or did it refuse? If it refused correctly, the loop is the Agent re-asking. Force the Agent to "stop" and use manual cleanup.

## Compatibility

### Will this work on my Agent?

Check [`agent-compatibility.md`](agent-compatibility.md). If your Agent isn't listed, the universal fallback is paste-on-invoke: copy `SKILL.md` into chat with "follow this procedure."

### Why don't you publish to skill marketplaces?

Same reason as no uninstall: external install paths introduce failure modes we don't control. A marketplace update could break your install; we don't ship from one. Install directly from the repo.

## Contributing

### How do I send a PR?

See [`CONTRIBUTING.md`](../CONTRIBUTING.md). Short version: write a single-task contract for yourself, then send the PR.

### Can I add a destructive operation to the skill?

No. Per [decision 0001](decisions/0001-keep-skill-non-destructive.md), destructive operations are not part of v1 and any PR introducing them is rejected. If you have a use case, write a new decision record (`0002`) laying out the consent flow.

### Why MIT license?

Standard, permissive, compatible with most other licenses. The repo is small enough that the license choice doesn't matter much — what matters is that the work is reusable.

---

This FAQ mirrors itself between [`/FAQ.md`](../FAQ.md) (Chinese default) and this file (English mirror). Keep them in sync if you edit one.