#!/usr/bin/env bash
# ai-docs 初始化脚本
# 用法：bash <skill-path>/scripts/init.sh [--with-git-exclude]
# 在项目根目录下执行，创建 ai-docs 目录结构并写入任务模板

set -e

WITH_GIT_EXCLUDE=false
for arg in "$@"; do
  [ "$arg" = "--with-git-exclude" ] && WITH_GIT_EXCLUDE=true
done

# 1. 创建目录结构
mkdir -p ai-docs/current ai-docs/archive ai-docs/templates
echo "✓ 创建目录：ai-docs/current  ai-docs/archive  ai-docs/templates"

# 2. 写入模板（仅在不存在时）
write_template() {
  local path="$1"
  local heredoc_body="$2"
  if [ ! -f "$path" ]; then
    printf '%s' "$heredoc_body" > "$path"
    echo "✓ 写入模板：$path"
  else
    echo "- 模板已存在，跳过：$path"
  fi
}

write_template "ai-docs/templates/task-template.md" '# [任务名称]

## 基本信息

| 项目 | 内容 |
|------|------|
| 负责人 | [姓名] |
| 创建时间 | [YYYY-MM-DD HH:MM] |
| 状态 | 进行中 / 已完成 |

---

## 任务目标

[描述任务的目标和预期结果]

---

## 分文件索引

| 文件 | 内容 |
|------|------|
| [requirement.md](./requirement.md) | 需求详情 |
| [todo.md](./todo.md) | 进度追踪 |
| [decisions.md](./decisions.md) | 关键决策 |
| [changes.md](./changes.md) | 变更文件清单 |
| [resources/](./resources/) | 图片、Excel、drawio 等配套资源 |

---

## 当前状态摘要

[一句话概括当前进展，详情见 todo.md]
'

write_template "ai-docs/templates/requirement-template.md" '# 需求详情

## 背景

[需求背景、产品思路]

## 需求描述

[功能描述、字段定义、接口结构等]

## 待确认事项

- [ ] [问题1]
'

write_template "ai-docs/templates/todo-template.md" '# 进度追踪

## 已完成
- [x] [步骤1]

## 进行中
- [ ] [步骤2]（当前进度说明）

## 待完成
- [ ] [步骤3]
- [ ] [步骤4]

## 下一步
> 接下来需要：[具体描述下一个动作]
'

write_template "ai-docs/templates/decisions-template.md" '# 关键决策

## 决策1：[标题]

**问题**：[描述问题]

**决策**：[描述决策]

**理由**：[解释原因]
'

write_template "ai-docs/templates/changes-template.md" '# 变更文件清单

## 新增文件

| 文件 | 说明 |
|------|------|
| `path/to/NewFile.kt` | [说明] |

## 修改文件

| 文件 | 修改内容 |
|------|----------|
| `path/to/ExistingFile.kt:line` | [修改说明] |
'

# 3. 可选：添加 git 本地忽略
if [ "$WITH_GIT_EXCLUDE" = true ]; then
  if [ -d ".git" ]; then
    mkdir -p .git/info
    # 避免重复写入
    if ! grep -qF "ai-docs/" .git/info/exclude 2>/dev/null; then
      echo "ai-docs/" >> .git/info/exclude
      echo "✓ 已添加 ai-docs/ 到 .git/info/exclude"
    else
      echo "- .git/info/exclude 中已有 ai-docs/，跳过"
    fi
  else
    echo "⚠ 当前目录没有 .git，跳过 git exclude"
  fi
fi

echo ""
echo "初始化完成：$(pwd)/ai-docs/"
