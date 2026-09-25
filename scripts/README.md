<!-- 语言：中文（默认） | English mirror: scripts/README.en.md -->

# scripts/

宿主侧的 shell 脚本，自动化 letmbootstrap 在你机器上的操作。本目录的每个脚本都 **默认非破坏性** —— 见 [`../docs/decisions/0001-keep-skill-non-destructive.md`](../docs/decisions/0001-keep-skill-non-destructive.md)。

## 这里有什么

| 文件 | 作用 | 默认模式 |
|---|---|---|
| `install.sh` | 把 `letmbootstrap` 技能装到支持的 Agent 平台 | 干跑（打印计划，不写） |

## `install.sh` — 速览

```bash
./scripts/install.sh                                # 干跑所有检测到的平台
./scripts/install.sh --apply                        # 实际安装
./scripts/install.sh --apply --platform claude-code # 只装一个平台
./scripts/install.sh --apply --symlink              # 用软链而不是复制
./scripts/install.sh --help                         # 用法
```

**作用：** 把 `skills/letmbootstrap/` 复制到每个检测到的 Agent 平台的正确位置。检测 Mavis、Claude Code、Cursor、Gemini CLI、Codex CLI、Aider、Devin、OpenCode。

**永远不做：**

- `rm`、`unlink`、`mv`、`rmdir` —— 脚本顶部的静态守卫一旦发现非注释行出现这些模式就中止脚本
- 覆盖已存在的技能安装
- 改源仓库

**冲突时：** 打印 `SKIP` 继续。重跑 `--apply` 前先手动移除已存在的安装，如果你真的想替换。

快速版见 [`../INSTALL.md`](../INSTALL.md)；细节见 [`../docs/installation-guide.md`](../docs/installation-guide.md)。

## 何时加新脚本

加脚本的场景：

1. 同样的 shell 操作被多于一个用户 / 多于一个项目需要。
2. 操作不能表达成技能正文里的一行命令。
3. 操作是非破坏性的（没有未经逐文件同意的 `rm`/`mv`/覆盖）。

如果操作是一次性或破坏性的，别放本目录 —— 按 AGENTS.md "禁区"，脚本会在 PR 评审时被拒。

## 静态守卫

`install.sh` 顶部是：

```bash
# 静态守卫：本脚本刻意不含破坏性命令。
if grep -nE '^[^#]*\b(rm |unlink |mv |rmdir )\b' "$0" >/dev/null 2>&1; then
  echo "REFUSE: scripts/install.sh 含有破坏性命令模式。" >&2
  exit 78
fi
```

这个守卫在 **任何其他代码之前** 跑。如果非注释行出现破坏性模式，脚本以退出码 78（EX_CONFIG）中止。守卫不能被标志或环境变量绕过。

加新脚本时：

- **要么** 把静态守卫复制到新脚本，**要么**
- **在 PR 描述里解释** 为什么新脚本不需要（例如，它本来就是只读的）。

## 测脚本

没有测试套件。验证步骤是：

```bash
# 1. 语法
bash -n scripts/install.sh && echo OK

# 2. help 文本
./scripts/install.sh --help

# 3. 干跑
./scripts/install.sh

# 4. 用临时 HOME 实测 --apply（安全）
TMP=$(mktemp -d)
mkdir -p "$TMP/.claude/skills"
HOME="$TMP" ./scripts/install.sh --apply --platform claude-code
ls "$TMP/.claude/skills/letmbootstrap/SKILL.md"
# 清理
mavis-trash "$TMP"

# 5. 幂等：再跑一次，期望 SKIP
HOME="$TMP" ./scripts/install.sh --apply --platform claude-code
```

## 本 README 不是

- **不是 AGENTS.md。** 项目宪法在 [`../AGENTS.md`](../AGENTS.md)。
- **不是安装说明。** 快速上手 [`../INSTALL.md`](../INSTALL.md)；细节 [`../docs/installation-guide.md`](../docs/installation-guide.md)。