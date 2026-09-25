<!-- 语言：中文（默认） | English mirror: docs/agent-compatibility.en.md -->

# Agent 兼容性矩阵

> 哪些 Agent 能跑 letmbootstrap 技能，以及怎么跑。

## TL;DR

技能就是 **一个带 YAML frontmatter 的 `SKILL.md` 文件**。任何：

1. 从已知目录加载 `SKILL.md`，并
2. 解析 frontmatter 里的 `name:` + `description:`，并
3. 把用户输入和 `description:` 匹配以决定何时调用，

…的 Agent 都能零修改地跑 letmbootstrap。技能正文只用标准 markdown 和逐步流程 —— 无平台特有语法。

如果你的 Agent 没有"技能"概念，见 [§ 没有原生技能支持的 Agent](#没有原生技能支持的-agent)。

## 矩阵

| Agent | 技能支持 | 安装路径 | 触发语法 | 备注 |
|---|---|---|---|---|
| **MiniMax Code / Mavis** | ✅ 原生 | `~/.minimax/agents/<名>/skills/` | 触发短语匹配 | 推荐宿主 |
| **Claude Code** | ✅ 原生 | `~/.claude/skills/` | 触发短语匹配 | 技能 UX 最打磨 |
| **OpenAI Codex CLI** | ⚠️ 部分 | 按项目 `.agent-skills/`，或 `~/.codex/skills/`（新版本） | 触发短语匹配 | 看版本；回退是调用时粘贴 |
| **Cursor** | ✅ 原生 | 按项目 `.cursor/skills/` | 触发短语匹配 | 只能按项目 |
| **Gemini CLI** | ✅ 原生 | `~/.gemini/skills/` | 触发短语匹配 | 只能全局 |
| **Aider** | ❌ 没有原生技能 | `.aider/conventions.md` 引用 | 手动 / 调用时粘贴 | 约定文件 workaround |
| **Devin** | ✅ 原生 | 按项目 `.devin/skills/` | 会话提示引用 | 只能按项目 |
| **OpenCode** | ✅ 原生 | `.opencode/skills/` 或 `~/.config/opencode/skills/` | 触发短语匹配 | 两种范围都行 |
| **Windsurf** | ⚠️ 通过 AGENTS.md | 按项目 `.windsurf/` | 在 AGENTS.md 内联 | 部分支持 —— 见备注 |
| **Continue.dev** | ⚠️ 通过配置 | `~/.continue/config.json` | 内联引用 | 部分支持 |
| **Cline / Roo Code** | ⚠️ 通过自定义指令 | `.clinerules` / `.roo/` | 内联 | 部分支持 |

> 覆盖范围基于撰写时各平台的文档。如果某行错，开个 issue —— 我们把这份矩阵当活的文档维护。

## 各平台备注

### MiniMax Code / Mavis

- 原生 `skill` 工具读 `~/.minimax/agents/<agent-名>/skills/<技能名>/SKILL.md`。
- Frontmatter 契约：`name:` + `description:`。
- 触发短语匹配 `description:` 由运行时做，不是 Agent 自己做。
- 触发时技能正文读入上下文；正文就是流程。
- **推荐承载 letmbootstrap 的 Agent 名：** 用于项目引导的 Agent。默认 `mavis`。

### Claude Code

- 原生技能支持：读 `~/.claude/skills/`（全局）和 `./.claude/skills/`（按项目）。
- 同样的 frontmatter 契约。
- 触发：`description:` 匹配用户输入。

### OpenAI Codex CLI

- 老 Codex 版本：无技能目录；用调用时粘贴。
- 新 Codex 版本：支持 `~/.codex/skills/`。按项目 `.agent-skills/` 是永远可用的安全回退。
- 不确定时，在项目的 `AGENTS.md` 里引用技能路径：

```markdown
## 技能
本项目里的技能在 .agent-skills/。触发短语匹配时读 <技能>/SKILL.md。
```

### Cursor

- 只能按项目。没有全局技能目录。
- 读 `./.cursor/skills/<名>/SKILL.md`。
- 技能在会话启动时加载。

### Gemini CLI

- 读 `~/.gemini/skills/`。
- 同样的 frontmatter 契约。
- 全局范围。

### Aider

- 没有原生"技能"概念。Aider 读 `~/.aider/conventions.md` 和按项目 `.aider/conventions.md`。
- Workaround：把 SKILL.md 拷到你的约定文件（或引用它的路径），Aider 触发时会跟它。
- 一次性调用，把 `SKILL.md` 正文粘到对话里。

### Devin

- 按会话读 `./.devin/` 文件。
- 按项目装。
- 在会话提示里引用技能："当我说 'letmbootstrap init'，读 `.devin/skills/letmbootstrap/SKILL.md`。"

### OpenCode

- 同时支持按项目（`.opencode/skills/`）和全局（`~/.config/opencode/skills/`）。
- 同样的 frontmatter 契约。

### Windsurf

- 严格来说没有技能目录，但读 `.windsurf/` 配置和项目级规则。
- Workaround：在项目的 `AGENTS.md` 或 `.windsurfrules` 里加引用。

### Continue.dev

- 通过 `~/.continue/config.json` 的自定义 slash 命令配置。
- Workaround：把 letmbootstrap 注册为指向 `SKILL.md` 的 slash 命令。

### Cline / Roo Code

- 通过 `.clinerules` 或 `.roo/` 配置的自定义指令。
- Workaround：在自定义指令里引用 SKILL.md 路径。

## 没有原生技能支持的 Agent

如果你的 Agent 没列在上面（或只部分支持），万能回退是 **调用时粘贴**：

1. 复制 `skills/letmbootstrap/SKILL.md` 内容。
2. 粘到对话里说："按这个流程执行。从第 1 步开始。"
3. Agent 会像原生加载那样跑流程。

比原生安装丑但到处能用。技能正是为此设计成自包含的。

## 技能对宿主的假设

技能正文引用了几样东西，不同 Agent 不一定有：

| 假设 | 回退 |
|---|---|
| 能读绝对路径 | 技能正文用绝对路径 `/Users/letmlook/code/letmbootstrap/`。如果你的 Agent 不能，软链到它能读的路径。 |
| 有 `question UI` / `ask_user` 工具 | 回退到对话里直接问。 |
| 能在当前项目写文件 | 引导必需。如果 Agent 只读，引导按设计失败。 |
| 能跑 `ls -la` / `mkdir -p` | 标准 shell。如果 Agent 不能跑 shell，技能降级到手动复制粘贴。 |

这些是显式假设，不是隐藏依赖。每个能读写项目文件目录的 Agent 都能跑这个技能。

## 怎么加新 Agent 的支持

三步：

1. **确定安装路径。** 看 Agent 文档里的"技能"、"扩展"、"自定义指令"等。
2. **在上表加一行。** 包括路径、触发语法、任何特殊性。
3. **在 `INSTALL.md` 和 `docs/installation-guide.md` 加一节** 附复制粘贴安装片段。

欢迎提 PR。安装器按目录标记自动检测；加新平台意味着在 `scripts/install.sh` 加一条检测规则 + 文档加一行。

## 本矩阵不覆盖什么

- **任何 Agent 的认证 / 计费** — 范围外。
- **技能市场** — letmbootstrap 刻意不在任何市场。安装一律直接来自本仓库。
- **跨 Agent 技能翻译** — 如果目标 Agent 用不同的 frontmatter 键，你自己写个薄 wrapper。我们不发 wrapper；技能本身即可移植。