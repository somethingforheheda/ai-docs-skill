# ai-docs-skill

> 让 Claude Code 跨会话持续工作的任务文档管理 Skill

## 是什么

`ai-docs` 是一个 [Claude Code](https://claude.ai/code) Skill，解决 AI 对话有上下文限制、每次新开会话都要重新解释背景的问题。

核心思路：**用 Markdown 文档代替对话记忆**。每个开发任务创建一个文档，AI 实时写入进度、下一步、变更文件，新会话读文档即可无缝接续。

## 解决什么问题

| 痛点 | ai-docs 的解法 |
|------|--------------|
| 会话上下文满了，AI 忘记之前做了什么 | 读 `{任务名}.md` 即可恢复完整上下文 |
| 复杂任务拆成多步，进度容易乱 | `todo.md` 追踪每一步，完成勾选 |
| 多个任务并行，不知道谁在哪 | `ai-docs/current/` 下每个子目录一个任务 |
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
├── current/              # 进行中的任务
│   └── {需求名}/
│       └── {需求名}.md   # 主文档（背景、方案、进度、变更清单）
├── archive/              # 已完成的任务
└── templates/
    └── task-template.md  # 由 init.sh 生成的模板
```

## 使用方式

在 Claude Code 对话中直接说：

```
开个任务：重构用户登录流程
```
```
更新进度
```
```
继续 current/重构用户登录流程 任务
```
```
任务完成，归档
```

Claude 会自动调用这个 skill，完成文档的创建、更新、归档。

## 文件说明

| 文件 | 说明 |
|------|------|
| `SKILL.md` | Skill 的行为规范，Claude Code 读取它理解如何执行 |
| `scripts/init.sh` | 初始化脚本，在项目根目录创建 `ai-docs/` 目录结构 |

## License

MIT
