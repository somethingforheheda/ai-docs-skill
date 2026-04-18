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

# 2. 写入任务模板（仅在不存在时）
TEMPLATE_PATH="ai-docs/templates/task-template.md"
if [ ! -f "$TEMPLATE_PATH" ]; then
  cat > "$TEMPLATE_PATH" << 'TEMPLATE'
# [任务名称]

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

## 进度追踪

### 已完成
- [x] [步骤1]

### 进行中
- [ ] [步骤2]（当前进度说明）

### 待完成
- [ ] [步骤3]
- [ ] [步骤4]

### 下一步
> 接下来需要：[具体描述下一个动作]

---

## 技术方案

### 关键类

| 类名 | 路径 | 作用 |
|------|------|------|
| `ClassName` | `path/to/Class.kt:line` | [作用说明] |

### 架构设计

```
[简要的流程图或架构示意]
```

---

## 关键决策

### 决策1：[标题]

**问题**：[描述问题]

**决策**：[描述决策]

**理由**：[解释原因]

---

## 变更文件清单

### 新增文件

| 文件 | 说明 |
|------|------|
| `path/to/NewFile.kt` | [说明] |

### 修改文件

| 文件 | 修改内容 |
|------|----------|
| `path/to/ExistingFile.kt:line` | [修改说明] |

---

## 完成总结（任务完成后填写）

### 实现概述

[简述最终实现的内容]

### 经验教训

[记录值得注意的经验，供未来参考]
TEMPLATE
  echo "✓ 写入模板：$TEMPLATE_PATH"
else
  echo "- 模板已存在，跳过：$TEMPLATE_PATH"
fi

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
