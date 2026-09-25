<!-- 语言：中文（默认） | English mirror: examples/letmbootstrap-self/README.en.md -->

# 示例：letmbootstrap 吃自己的狗粮

本示例展示把 letmbootstrap 技能跑在项目上时输出长什么样 —— **用 letmbootstrap 仓库本身** 当目标。

真实的引导产物已经提交到父仓库（`AGENTS.md`、`docs/` 等）。本 `examples/letmbootstrap-self/` 目录包含一份 **最小、带注释的副本**，展示技能会生成什么，每个章节有解说。

## 本示例里有什么

```
examples/letmbootstrap-self/
├── README.md                                   # 本文件
├── AGENTS.md                                   # 项目宪法填好的样子
├── docs/
│   └── decisions/
│       └── 0001-bootstrap-with-letmbootstrap.md
└── skills/
    └── README.md                               # 项目自己的 skills 目录里有什么
```

## 怎么读这个示例

1. 从 [`AGENTS.md`](AGENTS.md) 开始。注意它 ~50 行，不是 500 行。这是目标 —— 短、有立场、机读。
2. 然后读 [`docs/decisions/0001-bootstrap-with-letmbootstrap.md`](docs/decisions/0001-bootstrap-with-letmbootstrap.md)。"考虑过的方案"一节是必填的；这部分防止 Agent 以后重新争论这个决策。
3. 最后读 [`skills/README.md`](skills/README.md) —— skills 目录是给 *项目特定* 流程用的，不是 letmbootstrap 技能本身。

## 本示例刻意省略什么

- 真实的源码树（`src/`、测试、构建配置）。重点是方法论脚手架，不是可跑项目。
- 多条决策文件。真实项目会随时间累积决策；一个示例决策足够展示格式。
- 填好的 `single-task-contract.md`。模板在 [`../../templates/`](../../templates/single-task-contract.md)；示例只会重复一遍。

## 真实仓库长什么样

这是 letmbootstrap 团队日常用的规范、真实版本：

- [`AGENTS.md`](../../AGENTS.md) — 团队遵守的宪法
- [`docs/methodology.md`](../../docs/methodology.md) — 方法论叙事
- [`docs/decisions/`](../../docs/decisions/) — 决策日志
- [`skills/letmbootstrap/`](../../skills/letmbootstrap/) — 技能本身

本仓库在自己身上用方法论。这就是在本语境下"吃自己狗粮"的意思。

## 用这个示例

当你在自己的项目里跑 letmbootstrap 技能时，输出应该像本示例 —— 按你项目的名、技术栈、反目标调整。如果不像，技能大概率在第 2 步需要你提供更多元数据。