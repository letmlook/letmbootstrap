<!-- 语言：中文（默认） | English mirror: examples/README.en.md -->

# examples/

`letmbootstrap` 技能输出的真实示例。每个示例展示 **目标项目** 跑完技能后的样子 —— 即技能会写到另一个项目的那些文件。

## 这里有什么

| 示例 | 展示什么 |
|---|---|
| [`letmbootstrap-self/`](letmbootstrap-self/) | dogfood 示例：letmbootstrap 仓库自身，每个章节都填好 |

## 为什么只有一个

AGENTS.md 说："不为真实项目还没用到的东西加模板。" 同样的规则适用于示例。一个好示例足够展示方法论；在真实用户报告使用前加第二个是过早。

当你在自己的项目里采用 letmbootstrap 时，输出应该看起来像示例 —— 按你项目的名、技术栈、反目标调整。如果不像，技能大概率在第 2 步需要你提供更多元数据。

## 阅读顺序

1. [`letmbootstrap-self/README.md`](letmbootstrap-self/README.md) — 这个示例是什么、不是什么
2. [`letmbootstrap-self/AGENTS.md`](letmbootstrap-self/AGENTS.md) — 填好的项目宪法（~50 行）
3. [`letmbootstrap-self/docs/decisions/0001-bootstrap-with-letmbootstrap.md`](letmbootstrap-self/docs/decisions/0001-bootstrap-with-letmbootstrap.md) — 引导决策记录
4. [`letmbootstrap-self/skills/README.md`](letmbootstrap-self/skills/README.md) — 填好的 skills 目录索引

每个文件都有注释指向仓库根下的规范版本，方便对比"示例展示"和"真实版本长什么样"。

## 怎么加示例

当你在真实项目里采用 letmbootstrap 想展示输出时：

1. 把 [`letmbootstrap-self/`](letmbootstrap-self/) 目录拷到 `examples/<你的项目名>/`。
2. 更新 README 描述你的项目是什么。
3. 更新 AGENTS.md 为你项目的真实元数据。
4. 把引导决策记录替换成针对你项目采纳故事的那一条。
5. **提交前脱敏。** 示例进公开仓库。不要包含密钥、内部 URL、或任何你不会放公开 README 的东西。

提个 PR 链上你的示例。维护者会检查：

- 是否遵循模板结构（不缺章节、不加技能不产生的章节）？
- 反目标是真反目标（不是愿望清单）？
- 决策记录的"考虑过的方案"用真实方案填好了？

## 本 README 不是

- **不是教程。** 技能正文是教程；本目录展示输出。
- **不是穷尽。** 每个示例展示一种采纳。不同项目采纳方式不同。