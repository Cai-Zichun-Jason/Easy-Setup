#!/bin/bash

# 获取当前分支名称
BRANCH=$(git symbolic-ref --short HEAD)

echo ">>> 正在执行 Git 同步流程 (分支: $BRANCH)..."

# 1. 添加所有变更
git add .

# 2. 提交变更
if [ -n "$1" ]; then
    # 如果有参数，直接使用参数作为 Commit Message
    git commit -m "$1"
else
    # 如果没有参数，进入交互式提交 (打开编辑器)
    echo ">>> 未提供 Commit Message，进入交互模式..."
    git commit
fi

# 3. 推送
# 检查 commit 是否成功 (防止空提交导致 push 报错)
if [ $? -eq 0 ]; then
    echo ">>> 正在推送到远程仓库..."
    git push origin "$BRANCH"
    echo "✅ 推送完成！"
else
    echo "❌ 提交失败或被取消，跳过推送。"
fi