<!-- 语言：中文（默认） | English mirror: GLOSSARY.en.md -->

# 术语表

本仓库使用的术语。每个词条有简短定义和相关文档的指引。

## A

### AGENTS.md

每个采用 letmbootstrap 的项目根目录下 30 行的项目宪法。6 个必需章节：是什么、技术栈、不是什么、必读、新代码放哪、完成标准、禁区。见 [`templates/AGENTS.md.template`](templates/AGENTS.md.template) 和 [`docs/methodology.md`](docs/methodology.md) §"4 件套"。

### Anti-goal（反目标）

项目 **不做的事**。列在 AGENTS.md 的"不是什么"下。反目标是宪法里最强大的章节，因为它能阻止 Agent"贴心地"把项目扩展到你不想去的方向。见 [`docs/methodology.md`](docs/methodology.md) §"反模式"。

### Append-only（只能追加）

决策日志的属性：只加记录、不就地修改。如果一个决策被反转，追加一条新记录覆盖旧记录。旧记录保留（通常移到 `rejected/`），方便以后的读者看到完整历史。

## B

### Bootstrap（引导）

在本仓库语境下指两个相关但不同的操作：

1. **引导一个项目** — 在目标项目上运行 `letmbootstrap` 技能，安装 4 件套。
2. **引导技能本身** — 运行 `scripts/install.sh`，把技能装到你的 Agent 平台。

前者见 [`skills/letmbootstrap/SKILL.md`](skills/letmbootstrap/SKILL.md)。后者见 [`INSTALL.md`](INSTALL.md) 和 [`docs/installation-guide.md`](docs/installation-guide.md)。

## C

### Constitution（宪法）

AGENTS.md 的同义词。口语使用。

### Conventional Commits（约定式提交）

commit 信息格式：`<type>(<scope>): <subject>`。类型：`feat`、`fix`、`docs`、`refactor`、`chore` 等。破坏性变更追加 `!` 并加 `BREAKING CHANGE:` 页脚。见 [`CONTRIBUTING.md`](CONTRIBUTING.md) 示例。

## D

### Decision record（决策记录）

`docs/decisions/` 下的 markdown 文件，记录一项已敲定的选择。格式：状态 / 背景 / 决策 / 影响 / 考虑过的方案。见 [`templates/decision.md.template`](templates/decision.md.template)。

### Detect-before-write（写前探测）

每个 letmbootstrap 技能的硬规则：写任何东西之前，先做只读的预检来探测目标当前状态。这就是重跑技能安全的原因。

### Dogfooding（吃自己的狗粮）

用自己的产品。本 letmbootstrap 仓库用自己的方法论：AGENTS.md 就是 dogfooded 的宪法，[`examples/letmbootstrap-self/`](examples/letmbootstrap-self/) 是 dogfooded 的示例输出，[`docs/decisions/`](docs/decisions/) 是 dogfooded 的决策日志。

## E

### Extension map（扩展图）

AGENTS.md 里的"新代码放哪"表。把"我想加 X"映射到"它放 Y"。防止 Agent 临时发明新目录结构。

## F

### Frontmatter

`SKILL.md` 文件顶部的 YAML 块：

```markdown
---
name: <技能名>
description: Use when <触发> — <一句话总结>.
---
```

`description:` 用来匹配用户输入以决定是否调用技能。见 [`docs/skills-catalog.md`](docs/skills-catalog.md)。

## I

### Idempotent（幂等）

操作的性质：跑一次和跑多次结果相同。`scripts/install.sh` 是幂等的 —— 在已填充的目标上重跑是无操作。技能也是幂等的 —— 在已引导好的目标上重跑是无操作（先报告状态）。

### Installer（安装器）

本仓库里指 `scripts/install.sh`。把 `letmbootstrap` 技能装到支持的 Agent 平台。非破坏性。默认模式是 dry-run。

## M

### Materialize decisions（物化决策）

3 原则的第 1 条。任何影响项目的决策必须以 Agent 能读的文件存在。3 条规则：以后还要重决策 → 决策记录；以后还要重做流程 → 技能；一次性 → commit 信息。

### Mechanize rules（机械化规则）

3 原则的第 2 条。AGENTS.md 每条规则都要有 exit-1 脚本。如果不值得写检查，就不值得写规则。

## N

### Non-destructive（非破坏性）

每个 letmbootstrap 技能和安装器的绑定属性。禁止 `rm`、`unlink`、`mv`、`rmdir`、禁止 `--force`、禁止 `--reset`、禁止卸载子命令。见 [`docs/decisions/0001-keep-skill-non-destructive.md`](docs/decisions/0001-keep-skill-non-destructive.md)。

## P

### Paste-on-invoke（调用时粘贴）

当 Agent 没有技能目录时的万能回退。把 `SKILL.md` 正文粘到对话里说"按这个流程执行"。丑但到处能用。

## S

### Single-task contract（单任务契约）

30 秒填写的派任务前模板。章节：任务 / 必读 / 不做 / 完成标准 / 自主决策空间 / 必须先问。见 [`templates/single-task-contract.md`](templates/single-task-contract.md)。

### Skill（技能）

`skills/<技能名>/SKILL.md` 目录，含 frontmatter 和逐步流程。Agent 在 `description:` 匹配用户输入时调用。

### Skip-on-conflict（冲突跳过）

当安装器或技能遇到目标路径已有文件时的行为：打印 `SKIP` 继续。绝不未经明确同意就覆盖。

### Static guard（静态守卫）

`scripts/install.sh` 顶部的模式：

```bash
if grep -nE '^[^#]*\b(rm |unlink |mv |rmdir )\b' "$0" >/dev/null 2>&1; then
  exit 78
fi
```

抓任何未来的回归引入的破坏性模式。无法用标志绕过。

## T

### Trigger phrase（触发短语）

技能 `description:` frontmatter 中 Agent 拿来匹配用户输入的短语。`description:` 是触发面 —— 写得不具体，技能永远不会被调用。

## V

### Verification-before-completion（完成前验证）

跑"完成标准"清单再声称"做完"的纪律。技能正文和每个 PR 模板都包含这条纪律。

---

未列出的术语见 [`docs/methodology.md`](docs/methodology.md) 或开 issue。