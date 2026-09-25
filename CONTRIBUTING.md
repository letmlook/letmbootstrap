<!-- 语言：中文（默认） | English mirror: CONTRIBUTING.en.md -->

# 贡献指南

感谢考虑为 letmbootstrap 贡献。本文档讲怎么提一份干净落地的 PR。简短版：**先给自己写一份单任务契约**，再提 PR。详细版在下面。

## TL;DR

1. 读 [`AGENTS.md`](AGENTS.md)（宪法）和 [`ARCHITECTURE.md`](ARCHITECTURE.md)（形状）。
2. 通读 [`docs/methodology.md`](docs/methodology.md)（≤ 1500 字，5 分钟）。
3. 查 [`docs/decisions/`](docs/decisions/) —— 你关心的事可能已有定论。
4. 如果是非平凡变更，先填一份 [单任务契约](templates/single-task-contract.md) 并放进 PR 描述。
5. 如果你的改动和现有决策冲突，写一条新决策记录。不要在 PR 评论里争论。

## 行为准则

参与即视为同意 [行为准则](CODE_OF_CONDUCT.md)。由维护者执行。

## 我们接受什么

| 类型 | 门槛 |
|---|---|
| **Bug 修复**（错别字、断链、表格格式问题） | 平凡 PR —— 不需要契约。干跑必须通过。 |
| **文档澄清** | 提 PR 时描述里附前后对比。 |
| **`scripts/install.sh` 加新平台支持** | PR 必须加检测函数、更新 [`docs/agent-compatibility.md`](docs/agent-compatibility.md)，并在你能量到的平台上跑通干跑。 |
| **新模板** | 必须配套 `examples/` 下的可用示例。见 AGENTS.md 的"完成标准"。 |
| **`skills/` 新技能** | 必须有清晰的 `description:` frontmatter 触发。中英文触发短语都鼓励。 |
| **新方法论规则** | 必须更新 [`docs/methodology.md`](docs/methodology.md) 叙事（≤ 1500 字）并配一条决策记录说明改了什么。 |
| **引入破坏性操作的任何东西** | **PR 评审时拒。** 见 [决策 0001](docs/decisions/0001-keep-skill-non-destructive.md)。 |
| **卸载 / reset / force 标志** | **PR 评审时拒。** 同一条决策。 |

## 怎么写 PR

PR 描述就是单任务契约。用这个模板：

```markdown
## 任务
<一句话：动词 + 名词>

## 必读
- <评审者先读的链接>

## 不做（do NOT do）
- <边界 —— 本 PR 不做什么>

## 完成标准
- [ ] <可观察的>
- [ ] <可观察的>
- [ ] 干跑通过

## 决策记录
<链接到 docs/decisions/NNNN-*.md，如果本 PR 跟现有决策冲突>
<如果不冲突，写"无">
```

填不出来，PR 就还没准备好。继续打磨直到能填 —— 这就是方法论在起作用。

## 测你的改动

没有测试套件。验证步骤是：

```bash
# 1. 技能语法 / frontmatter 健康
head -5 skills/letmbootstrap/SKILL.md  # 应该看到 name: + description:

# 2. 安装器干跑
./scripts/install.sh                  # 干跑所有检测到的平台

# 3. 安装器静态守卫（抓 rm/unlink/mv/rmdir 回归）
bash -n scripts/install.sh && echo OK

# 4. 如果加了新平台，用临时 HOME 测 --apply
TMP=$(mktemp -d)
mkdir -p "$TMP/.claude/skills"
HOME="$TMP" ./scripts/install.sh --apply --platform claude-code
ls "$TMP/.claude/skills/letmbootstrap/SKILL.md"  # 应该存在
# 清理
mavis-trash "$TMP"
```

## Commit 信息

我们用 [Conventional Commits](https://www.conventionalcommits.org/)。示例：

- `docs: 在 SKILL.md 澄清非破坏性保证`
- `feat: 加 Gemini CLI 平台支持`
- `fix: 静态守卫在注释里 ^rm -rf 的误报`
- `refactor: 把 install.sh 拆成平台检测器`
- `chore: 版本 bump 到 0.2.0`

对技能 API（`SKILL.md` frontmatter 或模板格式）的破坏性变更必须在类型后加 `!` 并加 `BREAKING CHANGE:` 页脚。

## 加决策记录

如果你的改动动了已敲定的约定，先写决策记录：

```bash
# 复制模板
cp templates/decision.md.template docs/decisions/NNNN-<短横线小标题>.md

# 填写：
#   Status:        YYYY-MM-DD — proposed | implemented | rejected — <理由>
#   Context:       问题，写得让方案不出现也能读懂
#   Decision:      现在时、事实性、可验证
#   Alternatives:  必填；必须是真实方案
```

数字是 `docs/decisions/` 里下一个可用的 `NNNN`。按创建顺序排，不按主题 —— 这避免给分类做无意义的争论。

决策记录落地后，从 PR 描述链接过去。

## 评审流程

1. **维护者 7 天内评审。** 没回音就催。
2. **手动干跑通过。** `./scripts/install.sh`（干跑）在每个检测到的平台必须成功，才合并。
3. **非平凡变更要两个 approve。** 纯文档变更一个 approve 即可。
4. **squash-merge 到 `main`。** 合并后 commit 的历史应与 PR 标题一致。

## 发版流程

维护者在有实质变化时发版：

1. 在 [`CHANGELOG.md`](CHANGELOG.md) bump 版本号并打 tag。
2. 技能的 `SKILL.md` 不嵌版本号 —— 版本跟踪在 `CHANGELOG.md` 和 `git tags`。这保持安装包最小。
3. 如果改动影响技能的外部行为（frontmatter、正文），至少 minor bump。如果加新平台，minor bump。修不改变行为的 bug 是 patch。

## 提问

- 开 issue。题目写清楚。
- 安全问题见 `SECURITY.md`。不要在公开 issue 上报安全问题。

## 本指南不是

- **不是许可证。** 见 [`LICENSE`](LICENSE)。
- **不是合同。** 维护者保留因任何理由拒任何 PR 的权利。
- **不是降标准借口。** 方法论小是因为每块都是承重的。新增需要证明自己值得加。