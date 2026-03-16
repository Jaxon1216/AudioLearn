# EastonJiang - 音频学习应用

一个基于 React + Supabase 的音频学习应用，支持音频播放、字幕同步高亮、音频标签管理和生词列表功能。

**🎯 支持本地模式**：无需配置 Supabase，开箱即用！

![](https://img.shields.io/badge/React-18-blue)
![](https://img.shields.io/badge/TypeScript-5-blue)
![](https://img.shields.io/badge/Ant%20Design-5-blue)
![](https://img.shields.io/badge/Supabase-Optional-green)

## ✨ 功能特性

- ✅ **音频播放器** - 播放/暂停/调速 0.5x-2.0x
- ✅ **字幕同步高亮** - 自动滚动、实时同步
- ✅ **音频标签管理** - 生/熟/秒三态标记
- ✅ **生词列表** - 点击单词添加、按月份分类、折叠展开
- ✅ **播放进度自动保存** - 记住上次播放位置
- ✅ **本地模式** - 使用 localStorage，无需后端
- ✅ **用户认证** - 邮箱+密码登录（可选）
- ✅ **跨设备数据同步** - 使用 Supabase 时

## 🚀 快速开始

### 本地模式（推荐）

```bash
# 1. 克隆项目
git clone https://github.com/yourusername/EastonJiang.git
cd EastonJiang/EastonJiang

# 2. 安装依赖
npm install

# 3. 启动开发服务器
npm start
```

应用将在 http://localhost:3000 启动，无需任何配置！

### 使用 Supabase（可选）

如果需要跨设备数据同步：

1. 创建 Supabase 项目
2. 执行 `scripts/supabase-migration.sql` 创建数据库
3. 创建 Storage buckets：`audios` 和 `subtitles`
4. 配置 `.env` 文件：

```bash
cd EastonJiang
cp .env.example .env
# 编辑 .env 填入 Supabase 凭证
```

详细配置步骤请查看 [`EastonJiang/SETUP_GUIDE.md`](EastonJiang/SETUP_GUIDE.md)

## 📁 项目结构

```
EastonJiang/
├── EastonJiang/                   # React 前端应用
│   ├── src/
│   │   ├── components/    # React 组件
│   │   ├── contexts/      # Context API
│   │   ├── hooks/         # 自定义 Hooks
│   │   ├── lib/           # 工具库
│   │   └── types/         # TypeScript 类型
│   ├── public/            # 静态资源
│   └── package.json
├── scripts/               # 视频处理脚本
│   ├── process-videos.sh  # 批量处理视频
│   └── whisper_transcribe.py  # 生成字幕
└── processed/             # 处理后的音频和字幕
```

## 🎬 视频预处理

### 安装工具

```bash
# macOS
brew install ffmpeg
brew install pyenv

# 安装 Python 3.11
pyenv install 3.11
pyenv global 3.11

# 安装 faster-whisper
pip install faster-whisper
```

### 批量处理视频

```bash
# 1. 将视频放到 raw_videos 文件夹
mkdir -p raw_videos
mv your_video.mp4 raw_videos/

# 2. 运行处理脚本
cd scripts
./process-videos.sh

# 处理完成后，在 processed/ 文件夹中会有：
# - your_video.mp3 (音频文件)
# - your_video.srt (字幕文件)
```

详细说明请查看 [`WHISPER_INSTALL.md`](WHISPER_INSTALL.md) 和 [`TOOLS_SETUP_COMPLETE.md`](TOOLS_SETUP_COMPLETE.md)

## 🛠️ 技术栈

- **前端**: React 18 + TypeScript + Create React App
- **UI 库**: Ant Design 5
- **后端**: Supabase (PostgreSQL + Auth + Storage) - 可选
- **本地存储**: localStorage
- **部署**: Vercel
- **音频预处理**: ffmpeg + faster-whisper

## 📖 文档

- [应用使用说明](EastonJiang/README.md) - 详细的功能说明和使用指南
- [Supabase 配置指南](EastonJiang/SETUP_GUIDE.md) - 配置云端数据同步
- [工具安装指南](TOOLS_SETUP_COMPLETE.md) - ffmpeg 和 Whisper 安装
- [Whisper 安装说明](WHISPER_INSTALL.md) - 字幕生成工具配置

## 🚢 部署

### Vercel 部署

1. 推送代码到 GitHub
2. 访问 [Vercel](https://vercel.com/) 导入项目
3. 配置：
   - Root Directory: `EastonJiang`
   - Framework Preset: Create React App
4. 添加环境变量（如果使用 Supabase）：
   - `REACT_APP_SUPABASE_URL`
   - `REACT_APP_SUPABASE_ANON_KEY`
5. 点击 Deploy

## 📝 使用说明

### 播放音频

1. 从左侧列表选择分类
2. 点击音频条目开始播放
3. 使用播放器控制播放/暂停/调速

### 标记音频

点击音频右侧的标签按钮：
- **生** - 陌生内容（蓝色）
- **熟** - 熟悉内容（绿色）
- **秒** - 完全掌握（黄色）

### 管理生词

- 点击字幕中的英文单词添加到生词列表
- 单词按月份自动分组
- 支持复制、删除单个单词或整月单词

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

## 👨‍💻 作者

Created with ❤️ by EastonJiang Team
