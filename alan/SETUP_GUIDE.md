# Alan 音频学习应用 - 配置指南

本指南将帮助你完成 Supabase 配置和应用部署。

## 第一步：配置 Supabase

### 1.1 创建 Supabase 项目

1. 访问 [https://supabase.com/](https://supabase.com/)
2. 点击 "Start your project"
3. 登录或注册账号
4. 点击 "New Project"
5. 填写项目信息：
   - Name: `alan-audio-learning`
   - Database Password: 设置一个强密码（记住它！）
   - Region: 选择离你最近的区域（如 Singapore）
6. 点击 "Create new project"（等待1-2分钟项目创建）

### 1.2 执行数据库迁移

1. 在项目仪表板左侧，点击 **SQL Editor**
2. 点击 **New query**
3. 打开 `../scripts/supabase-migration.sql` 文件
4. 复制所有内容，粘贴到 SQL Editor
5. 点击右下角的 **Run** 按钮
6. 看到成功提示即表示数据库创建完成

### 1.3 创建 Storage Buckets

1. 在左侧菜单点击 **Storage**
2. 点击 **New bucket**
3. 创建第一个 bucket：
   - Name: `audios`
   - Public bucket: **勾选** ✓
   - 点击 **Create bucket**
4. 再次点击 **New bucket**
5. 创建第二个 bucket：
   - Name: `subtitles`
   - Public bucket: **勾选** ✓
   - 点击 **Create bucket**

### 1.4 配置 Authentication

1. 在左侧菜单点击 **Authentication**
2. 点击 **Providers**
3. 找到 **Email** provider
4. 确保 **Enable Email provider** 是开启状态（默认应该是开启的）
5. 如果需要邮箱验证：
   - 勾选 **Enable email confirmations**
   - 配置 SMTP 设置（可选，用于自定义邮件）

### 1.5 获取 API 凭证

1. 在左侧菜单点击 **Settings** (齿轮图标)
2. 点击 **API**
3. 找到以下信息：
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon public** key: 一长串字符串
4. **保存这两个值**，下一步需要用到

## 第二步：配置本地环境变量

1. 在 `alan` 项目目录下，复制 `.env.example` 为 `.env`：
   ```bash
   cp .env.example .env
   ```

2. 编辑 `.env` 文件，填入刚才获取的凭证：
   ```env
   REACT_APP_SUPABASE_URL=https://你的项目ID.supabase.co
   REACT_APP_SUPABASE_ANON_KEY=你的anon_key
   ```

3. 保存文件

## 第三步：启动应用

```bash
npm start
```

应用将在 [http://localhost:3000](http://localhost:3000) 启动。

### 测试应用

1. 打开浏览器访问 http://localhost:3000
2. 应该会看到登录页面
3. 点击 "注册" 标签
4. 输入邮箱和密码（至少6位）
5. 点击 "注册"
6. 如果成功，会跳转到主页面

## 第四步：准备测试数据

### 4.1 检查 ffmpeg 和 Whisper

```bash
# 检查 ffmpeg
ffmpeg -version

# 检查 Whisper
whisper --help
```

如果未安装，参考 README.md 中的安装说明。

### 4.2 处理测试视频

1. 确保根目录有测试视频文件
2. 运行处理脚本：
   ```bash
   cd scripts
   ./process-videos.sh
   ```

3. 查看 `processed` 文件夹，应该有：
   - `[视频名].mp3` - 音频文件
   - `[视频名].srt` - 字幕文件

### 4.3 上传到 Supabase

1. 回到 Supabase 控制台
2. 点击 **Storage**
3. 上传音频：
   - 点击 `audios` bucket
   - 点击 **Upload file**
   - 选择 `processed/[视频名].mp3`
   - 上传完成后，点击文件，复制 URL
4. 上传字幕：
   - 返回 Storage
   - 点击 `subtitles` bucket
   - 上传 `processed/[视频名].srt`
   - 复制 URL

### 4.4 添加音频记录

1. 点击左侧 **Table Editor**
2. 选择 `audios` 表
3. 点击 **Insert** → **Insert row**
4. 填写信息：
   - `title`: 给音频起个名字（如 "美式口音速成"）
   - `category`: 选择分类（如 "教学"）
   - `audio_url`: 粘贴音频文件 URL
   - `subtitle_url`: 粘贴字幕文件 URL
   - `duration`: 音频时长（秒，可以先填0）
   - `user_id`: 在下拉菜单选择你的用户 ID
5. 点击 **Save**

## 第五步：测试完整流程

1. 刷新应用页面
2. 在左侧列表应该能看到刚添加的音频
3. 点击音频条目
4. 应该能：
   - 播放音频
   - 看到字幕同步高亮
   - 点击英文单词添加到生词本
   - 标记音频状态（生/熟/秒）

## 第六步：部署到 Vercel（可选）

### 6.1 准备 Git 仓库

```bash
# 如果还没有 git 仓库
git init
git add .
git commit -m "Initial commit: Alan audio learning app"

# 推送到 GitHub
# 在 GitHub 创建新仓库，然后：
git remote add origin https://github.com/你的用户名/alan.git
git push -u origin main
```

### 6.2 部署到 Vercel

1. 访问 [https://vercel.com/](https://vercel.com/)
2. 使用 GitHub 账号登录
3. 点击 **Add New** → **Project**
4. 导入你的 GitHub 仓库
5. 配置项目：
   - Framework Preset: Create React App
   - Root Directory: `./alan` (如果项目在子目录)
   - Build Command: `npm run build`
   - Output Directory: `build`
6. 添加环境变量：
   - 点击 **Environment Variables**
   - 添加 `REACT_APP_SUPABASE_URL`
   - 添加 `REACT_APP_SUPABASE_ANON_KEY`
7. 点击 **Deploy**
8. 等待部署完成（2-3分钟）
9. 访问分配的 URL 测试应用

## 常见问题

### Q: 登录后显示 "暂无音频"

**A**: 需要在 Supabase 的 `audios` 表中添加记录，确保 `user_id` 字段正确。

### Q: 音频无法播放

**A**: 检查：
1. Storage buckets 是否设置为 public
2. 音频文件 URL 是否正确
3. 浏览器控制台是否有 CORS 错误

### Q: 字幕不显示

**A**: 检查：
1. 字幕文件是否上传成功
2. `subtitle_url` 是否正确
3. 字幕格式是否为 `.srt`

### Q: Whisper 生成字幕失败

**A**: 确保：
1. 已安装 openai-whisper: `pip3 install openai-whisper`
2. 音频文件格式正确
3. 硬盘空间充足（Whisper 模型文件约 140MB）

### Q: 部署后环境变量不生效

**A**: 
1. 确认 Vercel 环境变量已正确设置
2. 重新部署项目
3. 清除浏览器缓存

## 下一步

- 批量上传更多音频文件
- 调整 UI 样式
- 添加更多分类
- 优化移动端体验
- 实现音频标签筛选功能

## 需要帮助？

如果遇到问题，检查：
1. 浏览器控制台错误
2. Supabase 日志（Settings → Logs）
3. Vercel 部署日志

祝你使用愉快！🎉
