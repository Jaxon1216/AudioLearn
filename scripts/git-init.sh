#!/bin/bash

# Git 初始化脚本 - 只提交代码，不含大文件

set -e

echo "=== Alan 项目 Git 初始化 ==="
echo ""

# 检查是否已经初始化
if [ -d ".git" ]; then
    echo "⚠️ Git 仓库已存在"
    read -p "是否要重新初始化？(y/N): " answer
    if [ "$answer" != "y" ]; then
        echo "取消操作"
        exit 0
    fi
    rm -rf .git
fi

# 初始化 Git
echo "📦 初始化 Git 仓库..."
git init
echo ""

# 检查 .gitignore
if [ ! -f ".gitignore" ]; then
    echo "❌ .gitignore 文件不存在！"
    exit 1
fi

echo "✅ .gitignore 已配置"
echo ""

# 显示将要提交的文件
echo "📝 将提交的文件："
echo "  - alan/ (前端代码)"
echo "  - scripts/*.sh scripts/*.py scripts/*.sql"
echo "  - *.md (文档)"
echo ""
echo "❌ 不会提交的文件："
echo "  - raw_videos/ (1.5GB 原始视频)"
echo "  - processed/ (235MB 音频和字幕)"
echo "  - node_modules/"
echo ""

read -p "继续？(Y/n): " confirm
if [ "$confirm" = "n" ]; then
    echo "取消操作"
    exit 0
fi

# 添加文件
echo ""
echo "📋 添加文件到 Git..."

git add .gitignore
git add alan/
git add scripts/*.sh scripts/*.py scripts/*.sql
git add *.md
git add CHANGELOG.md PROJECT_SUMMARY.md CURRENT_STATUS.md PROCESSING_STATUS.md PROJECT_OPTIMIZATION.md 2>/dev/null || true

echo ""
echo "✅ 文件已添加"
echo ""

# 显示状态
echo "📊 Git 状态："
git status --short | head -20
echo ""

# 提示提交
echo "接下来的步骤："
echo ""
echo "1. 查看完整状态："
echo "   git status"
echo ""
echo "2. 创建首次提交："
echo "   git commit -m \"feat: initial commit - Alan audio learning app v1.0.0\""
echo ""
echo "3. 关联远程仓库："
echo "   git remote add origin <your-github-repo-url>"
echo ""
echo "4. 推送到远程："
echo "   git push -u origin main"
echo ""
echo "5. 音频文件请上传到 Supabase Storage"
echo "   （参考 PROJECT_OPTIMIZATION.md）"
echo ""
