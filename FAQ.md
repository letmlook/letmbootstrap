<!-- 语言：中文（默认） | English mirror: FAQ.en.md -->

# FAQ

常见问题，按主题分组。这里没收录的请开 issue。

## 总览

### letmbootstrap 到底是干什么的？

它在目标项目里安装 4 件套防跑偏骨架（`AGENTS.md` + `docs/decisions/` + `skills/` + 单任务契约），按项目定制。让 Agent 协作跨会话保持一致 —— 不再反复争论已敲定的决策、不再反复提醒忘记的规则。

### 这个项目只给单人开发者用吗？

起步是。但它对小型团队、以及多个 Agent（或多个 Agent 会话）在同一份代码上协作的项目也适用。同样的原则（物化、机械化、设边界）能放大规模，只是 AGENTS.md 和决策日志在更多读者（人和 Agent）共用时会更重要。

### 必须绑定某个特定 Agent 吗？

不。技能能在任何加载 `SKILL.md` 并用 `description:` frontmatter 匹配触发短语的 Agent 上跑。兼容矩阵见 [`docs/agent-compatibility.md`](docs/agent-compatibility.md)。

### 技能正文是什么语言？

中文。触发短语中英文都有（"letmbootstrap init"、"搭三件套"、"初始化方法论"、"letmbootstrap 初始化"），方便中英用户。

## 安装 / 卸载

### 怎么把 letmbootstrap 技能装到我的 Agent？

```bash
git clone https://github.com/letmlook/letmbootstrap.git
cd letmbootstrap
./scripts/install.sh                # 干跑，看会装到哪
./scripts/install.sh --apply        # 实际安装
```

或看 [`INSTALL.md`](INSTALL.md) 的快速版。详细各平台步骤见 [`docs/installation-guide.md`](docs/installation-guide.md)。

### 怎么卸载？

手动。安装器从不删除任何东西，这是设计。要卸载：

```bash
rm -rf "$HOME/.claude/skills/letmbootstrap"   # 或你装到的任何路径
```

这是你自己做的事 —— 见 [`docs/decisions/0001-keep-skill-non-destructive.md`](docs/decisions/0001-keep-skill-non-destructive.md) 为什么没有卸载命令。

### 能只装到一个项目里吗？

可以。按项目安装（Cursor、Devin、Codex 按项目）：

```bash
cd <你的项目>
mkdir -p .cursor/skills
cp -R /path/to/letmbootstrap/skills/letmbootstrap .cursor/skills/
```

技能本体在全局和按项目安装下完全相同。

### 我已经有老版本的 `~/.claude/skills/letmbootstrap`，怎么更新？

重跑安装器 —— 它跳过已存在的安装。要真更新就手动替换：

```bash
rm -rf ~/.claude/skills/letmbootstrap   # 你手动执行
cp -R /path/to/letmbootstrap/skills/letmbootstrap ~/.claude/skills/
```

或者开发期用 `--symlink` 实现热更新：

```bash
./scripts/install.sh --apply --symlink
```

## 方法论

### 为什么叫 letmbootstrap？

"let me bootstrap" + "方法论"。读作 "let-me-bootstrap"。短到能在对话里打出来。

### 为什么不能只要 AGENTS.md？那样不够吗？

AGENTS.md 是宪法，但光靠它不够。没有 `docs/decisions/`，Agent 会反复争论已敲定的选择。没有 `skills/`，Agent 会即兴发挥导致漂移。没有单任务契约，scope 蔓延就管不住。每个组件针对一种特定的失效模式 —— 见 [`docs/methodology.md`](docs/methodology.md) 的失效模式映射。

### 如果我只想要 AGENTS.md 呢？

技能会问。你说"只要 AGENTS.md"，它就跳过 `docs/decisions/` 和 `skills/`。但 4 件套全套效果更好 —— 成本小、复利高。

### 微小任务也要填单任务契约吗？

不用。契约是给非平凡任务用的。小任务（改个变量名、修个错别字）不用。能用一句话说清"做完长啥样"的，跳过契约。

### 我的 AGENTS.md 越来越长，要拆分吗？

要，超过 ~80 行就要拆。把细节推到 `docs/architecture.md`、`docs/ci.md` 等。AGENTS.md 应该是"一屏能看完的索引"，不是完整参考。

## 决策

### AGENTS.md 和决策记录该写什么？

**AGENTS.md** 写适用于 *每次* 变更的规则（反目标、禁区、完成标准）。**决策记录** 写一次性的选择（我们选了库 X、拒绝了库 Y）。如果一条规则在很多决策里都出现，就归 AGENTS.md。如果是一个选择 + 理由，归决策记录。

### 决策实施后能改吗？

可以，但只能通过追加新决策反转。旧版本移到 `implemented/`（带说明），写一条新的在 `proposed/`。不要改写历史 —— 追加新记录。

### "考虑过的方案" 那一节实在写不出来怎么办？

用占位标记：

```markdown
<!-- alternatives-not-recorded (pre-format or informal decision) -->
```

这很诚实："当时我们没记下方案"。以后的读者会知道不要把这一节当成完整的对比。

## 非破坏性保证

### 为什么没有 `--force` 或 `--reset` 标志？

见 [`docs/decisions/0001-keep-skill-non-destructive.md`](docs/decisions/0001-keep-skill-non-destructive.md)。简短回答：任何覆盖"冲突跳过"行为的标志都离误删只有一个按键距离。技能的价值是持久性，破坏性操作由用户自己执行。

### 如果我真的想删除已安装的技能？

你自己执行：

```bash
rm -rf <install-path>/letmbootstrap
```

这是刻意的。技能不知道 `<install-path>/` 下还有什么（其他技能、你自己的文件），所以拒绝替你做。

### 我的 Agent 进入"试图删除文件"的死循环怎么办？

那是另一个问题 —— 大概率是 Agent 行为问题，不是技能问题。检查技能输出：它到底是试着删了，还是拒绝了？如果正确拒绝了，死循环是 Agent 在重复发问。强制 Agent "stop" 然后手动清理。

## 兼容性

### 我的 Agent 能用吗？

查 [`docs/agent-compatibility.md`](docs/agent-compatibility.md)。如果你的 Agent 没列出来，万能回退是"调用时粘贴"：把 `SKILL.md` 正文粘到对话里说"按这个流程执行"。

### 为什么不发布到技能市场？

和"没有卸载"是同一个原因：外部安装路径会引入我们控制不了的失效模式。市场更新可能破坏你的安装；我们不从那里发。直接从仓库装。

## 贡献

### 怎么提 PR？

见 [`CONTRIBUTING.md`](CONTRIBUTING.md)。简短版：先给自己写一份单任务契约，再提 PR。

### 能给技能加破坏性操作吗？

不能。按 [决策 0001](docs/decisions/0001-keep-skill-non-destructive.md)，破坏性操作不在 v1，任何引入它们的 PR 都会被拒。如果你有真实需求，先写一条新的决策记录（`0002`）说明同意流程。

### 为什么要 MIT 协议？

标准、宽松、跟大多数其他协议兼容。本仓库足够小，协议选择没那么重要 —— 关键是作品可复用。

---

本 FAQ 在 [`FAQ.en.md`](FAQ.en.md) （英文镜像）和本文件之间镜像。编辑其中一处时记得同步。