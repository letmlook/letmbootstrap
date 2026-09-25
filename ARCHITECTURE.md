<!-- 语言：中文（默认） | English mirror: ARCHITECTURE.en.md -->

# 架构

本仓库是什么、各部分如何组合、约束它们的设计规则。

## 一句话描述

一套可复用的协作方法论模板，专为单人 + Agent 迭代式开发设计，打包成一个可安装的 Agent 技能 + 解释并支撑它的文档和模板。

## 仓库形态

```
letmbootstrap/
├── README.md                          # 营销 + 顶层索引
├── INSTALL.md                         # 一页指南：怎么把技能装到你的 Agent
├── AGENTS.md                          # dogfooded 项目宪法（30 行规则）
├── ARCHITECTURE.md                    # 本文件
├── CONTRIBUTING.md                    # 怎么提 PR
├── CHANGELOG.md                       # 版本日志
├── LICENSE                            # MIT
├── CODE_OF_CONDUCT.md                 # 社区公约
├── SECURITY.md                        # 怎么上报安全问题
│
├── docs/
│   ├── methodology.md                 # 4 件套叙事（≤ 1500 字）
│   ├── installation-guide.md          # 各平台安装细节
│   ├── agent-compatibility.md         # 各 Agent 平台兼容矩阵
│   ├── skills-catalog.md              # 已发布的技能 + 如何添加
│   └── decisions/                     # 只能追加的决策日志
│
├── templates/                         # 复制到目标项目的文件
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
    └── letmbootstrap-self/            # dogfooded 示例
```

## 五层架构

仓库拆成五层，依赖关系显式：

| 层 | 作用 | 示例 | 依赖 |
|---|---|---|---|
| **1. 宪法** | 定义项目自身规则 | `AGENTS.md` | 无 |
| **2. 叙事** | 解释规则为什么存在 | `docs/methodology.md`、`ARCHITECTURE.md` | 第 1 层 |
| **3. 模板** | 复制到其他项目的文件 | `templates/*.template` | 第 2 层 |
| **4. 技能** | Agent 可执行的流程 | `skills/letmbootstrap/SKILL.md` | 第 1、2、3 层 |
| **5. 安装器** | 分发第 4 层的宿主侧自动化 | `scripts/install.sh` | 第 1、4 层 |

依赖方向严格向下：第 5 层文件可以引用第 1 层文件，反过来不行。这让宪法稳定 —— 其他层可以变化，宪法不动。

## "非破坏性"在各层的含义

[`docs/decisions/0001-keep-skill-non-destructive.md`](docs/decisions/0001-keep-skill-non-destructive.md) 中的非破坏性保证对每层都有约束力：

| 层 | 非破坏性规则 |
|---|---|
| 1. 宪法 | "禁区"一节列出破坏性操作为禁飞区 |
| 2. 叙事 | 决策明确记录并捍卫该规则 |
| 3. 模板 | 模板就是纯 markdown —— 无 shell、无 rm |
| 4. 技能 | 顶部"硬规则 —— 默认非破坏性"一节 |
| 5. 安装器 | `scripts/install.sh` 顶部静态守卫，遇到任何 `rm`/`unlink`/`mv`/`rmdir` 模式就终止 |

任何不保留该保证的新层都是回归。

## 为什么是这个形状

仓库刻意避免：

- **运行时。** 没有代码、没有构建、没有测试。是文档 + 模板 + 一个 shell 脚本。加运行时会增加维护负担但对方法论没好处。
- **CLI。** 同样道理。安装路径就是一个 shell 脚本加一个 `cp -R`。CLI 比它要装的东西还多。
- **技能市场身份。** 技能市场发的是预装技能。letmbootstrap 是 `cp -R` 装的。刻意为之 —— 见 [`docs/decisions/0001-keep-skill-non-destructive.md`](docs/decisions/0001-keep-skill-non-destructive.md) 的"无卸载路径"理由，扩展到"无远程管理的安装路径"。
- **v1 多技能。** 一个技能足够示范方法论。其他技能住在用户项目自己的 `skills/` 目录里，等他们采纳方法论后。

## 添加新层

如果你需要加第 6 层，先写决策记录。决策应说明：

- 为什么现有 5 层做不了
- 新层将拥有什么
- 如何保留非破坏性保证

在决策记录落地之前，新层在 PR 评审时被拒。

## 版本

本仓库遵循 [Semantic Versioning 2.0](https://semver.org/)，加一条扩展：**技能的 `SKILL.md` frontmatter 是 API 契约的一部分**。大版本号 bump 要求要么模板格式有破坏性变更，要么非破坏性保证有变化。

版本历史见 [`CHANGELOG.md`](CHANGELOG.md)。

## 本文件不是

- **不是路线图。** 这是架构现状，不是未来计划。
- **不是教程。** "我怎么用"从 [`INSTALL.md`](INSTALL.md) 开始。
- **不是 AGENTS.md。** 宪法在 [`AGENTS.md`](AGENTS.md)，更短更有立场。本文件解释形状；那个文件定规则。