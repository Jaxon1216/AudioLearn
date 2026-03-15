# 🚀 快速开始指南

## 前端已启动 ✅

前端正在运行：**http://localhost:3000**

---

## 📋 常用命令

### Git 操作

```bash
# 查看状态
git status

# 查看提交历史
git log --oneline

# 创建 GitHub 仓库（需要先在 GitHub 网站创建）
git remote add origin https://github.com/yourusername/Alan.git
git push -u origin main
```

### 前端开发

```bash
# 进入前端目录
cd alan

# 启动开发服务器（已启动）
npm start

# 构建生产版本
npm run build

# 运行测试
npm test
```

### 视频处理

```bash
# 验证环境
./scripts/verify-setup.sh

# 处理视频
mkdir -p raw_videos
mv your_video.mp4 raw_videos/
cd scripts
./process-videos.sh
```

### 打开项目

```bash
# 使用 Cursor 打开项目
cd /Users/eastonjiang/code/vibe/Alan
cursor .
```

---

## 🌐 访问应用

- **本地开发**: http://localhost:3000
- **网络访问**: http://172.25.117.99:3000

---

## 📚 文档链接

- [项目主文档](README.md)
- [应用使用说明](alan/README.md)
- [Supabase 配置](alan/SETUP_GUIDE.md)
- [工具安装指南](TOOLS_SETUP_COMPLETE.md)
- [项目清理总结](PROJECT_CLEANUP.md)

---

## 🎯 下一步

1. 在 GitHub 创建远程仓库
2. 推送代码到 GitHub
3. 配置 Vercel 部署（可选）
4. 配置 Supabase（可选）
