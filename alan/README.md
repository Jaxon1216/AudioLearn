# Alan - 音频学习应用

一个基于 React + Supabase 的音频学习应用，支持音频播放、字幕同步高亮、音频标签管理和生词列表功能。

**🎯 支持本地模式**：无需配置 Supabase，开箱即用！

## 功能特性

- ✅ **音频播放器**（播放/暂停/调速 0.5x-2.0x）
- ✅ **字幕同步高亮**（自动滚动、实时同步）
- ✅ **音频标签管理**（生/熟/秒三态标记）
- ✅ **生词列表**（点击单词添加、按月份分类、折叠展开、一键删除整月）
- ✅ **单词复制**（一键复制到剪贴板）
- ✅ **播放进度自动保存**（记住上次播放位置）
- ✅ **本地模式**（使用 localStorage，无需后端）
- ✅ **用户认证**（邮箱+密码登录，可选）
- ✅ **跨设备数据同步**（使用 Supabase 时）

## 技术栈

- **前端**: React 18 + TypeScript + Create React App
- **UI 库**: Ant Design 5
- **后端**: Supabase (PostgreSQL + Auth + Storage) - 可选
- **本地存储**: localStorage (无需配置即可使用)
- **部署**: Vercel
- **音频预处理**: ffmpeg + faster-whisper

## 快速开始（本地模式 - 推荐）

### 1. 克隆项目

```bash
git clone <your-repo-url>
cd Alan/alan
```

### 2. 安装依赖

```bash
npm install
```

### 3. 启动开发服务器

```bash
npm start
```

应用将在 [http://localhost:3000](http://localhost:3000) 启动。

**就这么简单！** 无需配置后端，所有数据存储在浏览器 localStorage 中。

### 本地测试音频

项目已包含一个测试音频和字幕文件：
- 音频：`public/audios/test.mp3`
- 字幕：`public/subtitles/test.srt`
- 配置：`public/audios/mock-data.json`

启动后切换到"教学"分类即可看到测试音频。

---

## 进阶：使用 Supabase（可选）

如果需要跨设备数据同步，可以配置 Supabase：

### 1. 创建 Supabase 项目

1. 访问 [Supabase](https://supabase.com/) 创建新项目
2. 在 SQL Editor 中执行 `../scripts/supabase-migration.sql`
3. 在 Storage 中创建两个 bucket：
   - `audios` (public)
   - `subtitles` (public)
4. 在 Authentication > Providers 中启用 Email provider

### 2. 配置环境变量

创建 `.env` 文件：

```bash
cp .env.example .env
```

编辑 `.env` 文件，填入 Supabase 凭证：

```env
REACT_APP_SUPABASE_URL=your_supabase_url
REACT_APP_SUPABASE_ANON_KEY=your_anon_key
```

### 3. 重启应用

```bash
npm start
```

配置后将自动切换到 Supabase 模式。

## 视频预处理

### 准备工具

1. **安装 ffmpeg**：
```bash
brew install ffmpeg
```

2. **安装 Python 3.11** (推荐使用 pyenv)：
```bash
# 安装 pyenv
brew install pyenv

# 安装 Python 3.11
pyenv install 3.11

# 设置为当前项目的 Python 版本
pyenv local 3.11
```

3. **安装 faster-whisper**：
```bash
pip install faster-whisper
pip install 'httpx[socks]'  # 如果下载模型需要代理
```

### 批量处理视频

1. 将 MP4 视频文件放入 `raw_videos/` 文件夹
2. 运行处理脚本：

```bash
cd scripts
./process-videos.sh
```

脚本会自动：
- 提取音频（MP4 → MP3 128kbps）
- 生成字幕（使用 faster-whisper 的 base 模型）
- 输出到 `processed/` 文件夹

3. **本地模式**：将处理好的文件复制到 `alan/public/` 对应文件夹
4. **Supabase 模式**：上传到 Supabase Storage，并在数据库中添加记录

## 项目结构

```
alan/
├── public/                 # 静态资源
├── src/
│   ├── components/        # React 组件
│   │   ├── AudioPlayer/   # 音频播放器
│   │   ├── Subtitle/      # 字幕显示
│   │   ├── AudioList/     # 音频列表
│   │   └── Auth/          # 认证相关
│   ├── contexts/          # React Context
│   ├── hooks/             # 自定义 Hooks
│   ├── lib/               # 工具库
│   ├── pages/             # 页面组件
│   ├── types/             # TypeScript 类型
│   └── App.tsx            # 应用入口
├── scripts/               # 预处理脚本
│   ├── process-videos.sh  # 视频处理脚本
│   └── supabase-migration.sql  # 数据库迁移
├── raw_videos/            # 原始视频文件
└── processed/             # 处理后的文件

```

## 部署到 Vercel

1. 推送代码到 GitHub
2. 访问 [Vercel](https://vercel.com/)
3. 导入 GitHub 仓库
4. 配置环境变量：
   - `REACT_APP_SUPABASE_URL`
   - `REACT_APP_SUPABASE_ANON_KEY`
5. 点击 Deploy

## 使用说明

### 📝 登录（本地模式自动登录）

- **本地模式**：自动以测试用户身份登录
- **Supabase 模式**：首次使用需要注册账号（邮箱+密码）

### 🎵 播放音频

1. 从左侧列表选择分类（切换 Tab）
2. 点击音频条目开始播放
3. 使用播放器控制：
   - 播放/暂停按钮
   - 播放速度选择（0.5x ~ 2.0x）
   - 进度条拖动

### 🏷️ 标记音频

点击音频条目右侧的标签按钮：
- **生**：陌生内容（蓝色）
- **熟**：熟悉内容（绿色）
- **秒**：完全掌握（黄色）

状态会自动保存（本地模式存 localStorage，Supabase 模式存数据库）。

### 📚 管理生词列表

**添加单词：**
- 在字幕区域点击**英文单词**（会高亮显示）
- 自动添加到生词列表
- 重复单词会被自动去重

**查看生词列表：**
1. 点击右上角 "生词列表" 按钮
2. 单词按月份自动分组显示
3. 显示添加日期

**管理功能：**
- 📋 **复制单词**：点击复制按钮复制到剪贴板
- 🗑️ **删除单词**：删除单个单词（需要确认）
- 🗑️ **删除整月**：点击月份旁的删除按钮，一键清空该月所有单词
- 📁 **折叠/展开**：点击月份标题折叠或展开该月的单词列表

**VocabMap 推荐：**
生词列表顶部会推荐访问 [VocabMap](https://www.vocabmap.com/) 进行更专业的单词查询和学习。

## 开发

### 可用脚本

- `npm start` - 启动开发服务器
- `npm test` - 运行测试
- `npm run build` - 构建生产版本
- `npm run eject` - 弹出 CRA 配置（不可逆）

### 调试

使用 Chrome DevTools 进行调试。React Developer Tools 扩展推荐安装。

## 常见问题

### Q: 本地模式和 Supabase 模式有什么区别？

A: 
- **本地模式**：数据存在浏览器 localStorage，清除浏览器数据会丢失，无法跨设备同步
- **Supabase 模式**：数据存在云端数据库，可以跨设备访问，需要登录

### Q: 如何切换到 Supabase 模式？

A: 创建 `.env` 文件并填入 Supabase 凭证，重启应用即可自动切换。

### Q: 字幕不显示？

A: 
- **本地模式**：检查 `mock-data.json` 中的文件路径是否正确
- **Supabase 模式**：检查字幕文件格式是否为 `.srt`，并且 URL 可访问

### Q: 音频无法播放？

A:
- **本地模式**：确保音频文件在 `public/audios/` 文件夹中
- **Supabase 模式**：确保音频文件已正确上传到 Storage，且 bucket 设置为 public

### Q: 生词列表为空？

A: 只有**纯英文单词**会被识别（不含数字和特殊字符），点击时确保单词有高亮效果。

### Q: faster-whisper 安装失败？

A: 
1. 确保使用 Python 3.11（不要使用 3.14）
2. 如果下载模型失败，需要安装：`pip install 'httpx[socks]'`
3. 详见 `WHISPER_INSTALL.md` 文档

### Q: 如何添加更多音频？

A:
- **本地模式**：
  1. 将音频放到 `public/audios/`
  2. 将字幕放到 `public/subtitles/`
  3. 编辑 `public/audios/mock-data.json` 添加记录
  
- **Supabase 模式**：
  1. 上传文件到 Supabase Storage
  2. 在 `audios` 表中添加记录

## 许可证

MIT License

## 作者

Created with ❤️ by Alan Team
