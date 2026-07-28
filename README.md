# ai-docs-skill

> 让 Claude Code 跨会话持续工作的任务文档管理 Skill

## 是什么

`ai-docs` 是一个 [Claude Code](https://claude.ai/code) Skill，解决 AI 对话有上下文限制、每次新开会话都要重新解释背景的问题。

核心思路：**用 Markdown 文档代替对话记忆**。每个开发任务是一个目录，正文按用途拆成多个文件（需求 / 进度 / 决策 / 变更），AI 实时写入，新会话读文档即可无缝接续。

## 解决什么问题

| 痛点 | ai-docs 的解法 |
|------|--------------|
| 会话上下文满了，AI 忘记之前做了什么 | 读 `{任务名}.md` 索引摘要定位现状，按需再读分文件 |
| 单个大文档越写越长，读一次占满上下文 | 正文拆成 `requirement.md` / `todo.md` / `decisions.md` / `changes.md`，按需读取 |
| 复杂任务拆成多步，进度容易乱 | `todo.md` 追踪每一步，完成勾选 |
| 多个任务并行，不知道谁在哪 | `ai-docs/current/` 下每个子目录一个任务 |
| 截图、Excel、drawio 无处安放 | 每个任务自带 `resources/` 目录 |
| 任务结束没有记录 | 归档时写完成总结，移入 `archive/` |

## 安装

```bash
# 克隆到 Claude Code skills 目录
git clone https://github.com/somethingforheheda/ai-docs-skill ~/.claude/skills/ai-docs
```

安装后在 `~/.claude/CLAUDE.md` 里注册触发词（可选，Claude Code 会自动识别 skills 目录）。

## 目录结构

```
ai-docs/
├── current/                  # 进行中的任务
│   └── {任务名}/
│       ├── {任务名}.md       # 索引摘要：基本信息 + 任务目标 + 分文件链接 + 一句话现状
│       ├── requirement.md    # 需求详情：背景、描述、字段/接口定义、待确认事项
│       ├── todo.md           # 进度追踪：已完成 / 进行中 / 待完成 / 下一步
│       ├── decisions.md      # 关键决策：问题 / 决策 / 理由
│       ├── changes.md        # 变更文件清单：新增 / 修改文件
│       └── resources/        # 配套资源：图片、Excel、drawio、导出文件
├── archive/                  # 已完成的任务（结构与 current/ 相同）
└── templates/                # 由 init.sh 生成的模板
    ├── task-template.md
    ├── requirement-template.md
    ├── todo-template.md
    ├── decisions-template.md
    └── changes-template.md
```

`{任务名}.md` 只做索引和摘要，不写细节——恢复任务时先读它定位现状，需要细节再读对应分文件。

> **兼容旧格式**：早期版本每个任务是单个 `{任务名}.md` 塞所有内容。遇到这种任务（目录下没有 `todo.md` 等分文件）时只兼容读取，直接在该文件内按章节读写，不会自动迁移；只有你明确要求“拆分”时才会拆成分文件结构。

## 使用方式

在 Claude Code 对话中直接说：

| 你说的 | Claude 做的 |
|--------|------------|
| `开个任务：重构用户登录流程` | 创建任务目录，写入索引 + 各分文件 |
| `更新进度` | 把新进展写进 `todo.md`，变更文件写进 `changes.md`，同步索引摘要 |
| `继续 current/重构用户登录流程 任务` | 读索引 + `todo.md` 恢复上下文，从“下一步”接着做 |
| `任务完成，归档` | 补完成总结，目录移入 `archive/` |
| `列出当前任务` | 列出 `ai-docs/current/` 下各任务及状态 |

首次在一个项目里触发时，Claude 会先征求同意再创建 `ai-docs/`，并单独询问是否把它加进 `.git/info/exclude`（仅本机生效，不写 `.gitignore`）。

## 文件说明

| 文件 | 说明 |
|------|------|
| `SKILL.md` | Skill 的行为规范，Claude Code 读取它理解如何执行 |
| `scripts/init.sh` | 初始化脚本，在项目根目录创建 `ai-docs/` 目录结构与 5 个模板；加 `--with-git-exclude` 参数则同时写入 `.git/info/exclude` |

## License

MIT
