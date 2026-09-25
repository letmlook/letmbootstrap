<!-- 语言：中文（默认） | English mirror: README.en.md -->

# letmbootstrap

> **letmbootstrap** — 单人 + Agent 迭代方法论。让一个人也能高质量地和 Agent 协作，不会跑偏、不会重复提醒。

一套可复用的协作方法论模板，专为单人 + Agent 迭代式开发设计。目标是防止 Agent 跑偏、减少重复提示、让项目的决策在会话之间持久保存。

## 目录结构

```
letmbootstrap/
├── README.md                          # 本文件（中文）
├── README.en.md                       # 英文镜像
├── INSTALL.md                         # 5 分钟把技能装到你的 Agent
├── FAQ.md                             # 常见问答（中文）
├── GLOSSARY.md                        # 术语表（中文）
├── AGENTS.md                          # dogfooded 项目宪法
├── ARCHITECTURE.md                    # 五层架构总览
├── CONTRIBUTING.md                    # 如何提 PR
├── CHANGELOG.md                       # 版本日志
├── LICENSE                            # MIT
├── CODE_OF_CONDUCT.md                 # 社区公约
├── SECURITY.md                        # 安全问题上报
│
├── docs/
│   ├── methodology.md                 # 4 件套方法论叙事
│   ├── installation-guide.md          # 各平台详细安装步骤
│   ├── agent-compatibility.md         # 兼容矩阵
│   ├── skills-catalog.md              # 已发布的技能 + 如何添加更多
│   └── decisions/                     # 决策日志（dogfooded）
│
├── templates/                         # 技能复制到目标项目的文件
│   ├── README.md
│   ├── AGENTS.md.template             # 项目宪法
│   ├── decision.md.template           # 决策记录
│   └── single-task-contract.md        # 任务契约
│
├── skills/                            # 可安装的 Agent 技能
│   └── letmbootstrap/
│       └── SKILL.md                   # 引导技能
│
├── scripts/                           # 宿主侧自动化
│   ├── README.md
│   └── install.sh                     # 非破坏性安装器
│
└── examples/                          # 技能输出实例
    ├── README.md
    └── letmbootstrap-self/            # dogfooded 示例
```

## 从哪里开始

| 你想… | 看这个 |
|---|---|
| 把技能装到你的 Agent | [`INSTALL.md`](INSTALL.md) |
| 理解方法论 | [`docs/methodology.md`](docs/methodology.md) |
| 看各平台的详细安装步骤 | [`docs/installation-guide.md`](docs/installation-guide.md) |
| 让 Agent 帮你装（不用自己敲 shell） | [`docs/agent-driven-install.md`](docs/agent-driven-install.md) |
| 查你的 Agent 是否支持 | [`docs/agent-compatibility.md`](docs/agent-compatibility.md) |
| 看仓库自身的架构 | [`ARCHITECTURE.md`](ARCHITECTURE.md) |
| 提 PR | [`CONTRIBUTING.md`](CONTRIBUTING.md) |
| 查术语 | [`GLOSSARY.md`](GLOSSARY.md) |
| 找快速答案 | [`FAQ.md`](FAQ.md) |
| 看版本历史 | [`CHANGELOG.md`](CHANGELOG.md) |

## 4 件套（防跑偏的最小集）

1. **`AGENTS.md`** — 30 行项目宪法：是什么 / 不是什么 / 必读 / 新代码放哪 / 完成标准 / 禁区。
2. **`docs/decisions/`** — 只能追加的决策日志（问题 / 决策 / 影响 / 拒绝的方案）。阻止 Agent 重新争论已敲定的选择。
3. **`skills/`** — Agent 不需要即兴发挥的逐步流程。
4. **单任务契约** — 每次给 Agent 派任务前花 30 秒填写（任务 / 必读 / 不做 / 完成标准 / 自主决策 / 必须先问）。防 scope 蔓延、防重复提示。

## 3 条原则

1. **决策物化。** 不要放在脑子里或聊天记录里，写到 Agent 能读的地方。
2. **规则机械化。** AGENTS.md 每条规则都要有 exit-1 脚本。"小心一点"没有检查 = 噪音。
3. **每个任务带完成标准。** 任务模糊时 Agent 一定跑偏，因为它不知道"做完"长什么样。

## 快速上手

你有两个不同的事要做：

### 工作 A — 把 letmbootstrap 技能装到你的 Agent

```bash
# 在本仓库目录下
./scripts/install.sh                # 干跑：看会装到哪里
./scripts/install.sh --apply        # 实际安装到每个检测到的 Agent
```

或只装一个平台：

```bash
./scripts/install.sh --apply --platform claude-code
./scripts/install.sh --apply --platform mavis --agent-name my-dev-agent
```

支持的平台：Mavis (MiniMax Code)、Claude Code、Codex CLI、Cursor、Gemini CLI、Aider、Devin、OpenCode。完整表格见 [`INSTALL.md`](INSTALL.md)，各平台能力见 [`docs/agent-compatibility.md`](docs/agent-compatibility.md)。

**安装器不会删除任何东西。** 重跑是安全的。技能本身也是非破坏性的 —— 未经逐文件明确同意，它不会 `rm` 或覆盖你项目里的文件。

### 工作 B — 用技能引导目标项目

技能装好后（Job A），在你想应用方法论的项目里开个新会话，对 Agent 说以下任一句：

- "letmbootstrap init"
- "搭三件套"
- "初始化方法论"

Agent 会按引导流程走：预检 → 问你 5 个元数据问题 → 预览要写的文件 → 确认后才创建 `AGENTS.md` + `docs/decisions/` + `skills/`。未经你逐个明确同意，它不会动你已有的任何文件。

或者手动复制模板：

```bash
# 在目标项目目录下
cp /Users/letmlook/code/letmbootstrap/templates/AGENTS.md.template ./AGENTS.md
cp /Users/letmlook/code/letmbootstrap/templates/decision.md.template ./docs/decisions/0001-bootstrap.md
mkdir -p .agent-skills && cp /Users/letmlook/code/letmbootstrap/templates/single-task-contract.md ./.agent-skills/
```

然后根据你的项目定制 `AGENTS.md`（项目名、技术栈、反目标、新代码放哪）。

## 来源

源自 deepseek-harness 项目的 `.agents/notes/` + `.agents/skills/` 体系，证明了多人 + 多 Agent 协作也能产出高质量迭代、几乎不需要重新定向。

## 语言说明

本仓库默认所有文档为中文。英文版本作为 `.en.md` 镜像存在（同一目录）。两者内容应保持一致；如有差异以中文版为准。脚本 `install.sh` 保持英文（shell 脚本惯例）。