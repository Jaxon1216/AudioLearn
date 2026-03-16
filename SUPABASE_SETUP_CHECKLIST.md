# ✅ Supabase 配置清单

**项目信息**：
- Project URL: `https://aouxwiisskawtylooxam.supabase.co`
- Region: 已配置
- Status: 🟢 Active

---

## 📋 配置步骤

### ✅ 1. 创建 Supabase 项目
- [x] 项目已创建
- [x] 获取 Project URL 和 anon key
- [x] 配置 `.env` 文件

### ⏳ 2. 执行建表 SQL

**操作步骤**：

1. 访问 Supabase 控制台：https://supabase.com/dashboard/project/aouxwiisskawtylooxam
2. 点击左侧 **SQL Editor**
3. 点击 **New query**
4. 打开文件：`scripts/supabase-migration-verified.sql`
5. 复制所有内容（202 行）
6. 粘贴到 SQL Editor
7. 点击右下角绿色的 **Run** 按钮
8. 等待执行完成（约 2-3 秒）
9. 查看成功提示：✅ 数据库迁移完成！

**验证**：
- 点击左侧 **Table Editor**
- 应该能看到 3 张表：
  - `audios`
  - `playback_progress`
  - `vocabulary`

### ⏳ 3. 创建 Storage Buckets

**操作步骤**：

1. 点击左侧 **Storage**
2. 点击右上角 **New bucket**

**创建第一个 bucket**：
- Name: `audios`
- Public bucket: **勾选** ✓
- File size limit: 50 MB (默认)
- Allowed MIME types: 留空（允许所有）
- 点击 **Create bucket**

**创建第二个 bucket**：
- 再次点击 **New bucket**
- Name: `subtitles`
- Public bucket: **勾选** ✓
- File size limit: 10 MB (默认)
- Allowed MIME types: 留空（允许所有）
- 点击 **Create bucket**

**验证**：
- 在 Storage 页面应该能看到 2 个 buckets：
  - `audios` (public)
  - `subtitles` (public)

### ⏳ 4. 启用 Email 认证

**操作步骤**：

1. 点击左侧 **Authentication**
2. 点击 **Providers**
3. 找到 **Email** provider
4. 确保状态是 **Enabled**（默认应该是开启的）

**可选配置**：
- Confirm email: 关闭（开发阶段）
- Secure email change: 开启（推荐）
- Email OTP: 关闭（使用密码登录）

### ⏳ 5. 上传音频文件

你有两个选择：

#### 选项 A：手动上传（简单，适合少量文件）

1. 进入 **Storage** → `audios` bucket
2. 创建文件夹：`每日跟读`
3. 点击 **Upload files**
4. 选择所有 23 个 mp3 文件
5. 上传完成后，进入 `subtitles` bucket
6. 创建文件夹：`每日跟读`
7. 上传所有 23 个 srt 文件

#### 选项 B：使用批量上传脚本（推荐，快速）

我可以帮你写一个 Python 脚本，自动：
- 上传所有音频和字幕文件
- 自动创建数据库记录
- 显示上传进度

### ⏳ 6. 测试应用

**操作步骤**：

1. 重启前端开发服务器：
   ```bash
   cd alan
   npm start
   ```

2. 访问 http://localhost:3000

3. 注册一个测试账号：
   - Email: 你的邮箱
   - Password: 至少 6 位

4. 登录后应该能看到：
   - 空的音频列表（因为还没上传音频）
   - 6 个分类标签

5. 上传音频后，刷新页面应该能看到所有音频

---

## 🎯 当前进度

- [x] 1. 创建 Supabase 项目 ✅
- [x] 2. 配置 .env 文件 ✅
- [ ] 3. 执行建表 SQL ⏳ **← 你现在在这里**
- [ ] 4. 创建 Storage Buckets ⏳
- [ ] 5. 启用 Email 认证 ⏳
- [ ] 6. 上传音频文件 ⏳
- [ ] 7. 测试应用 ⏳
- [ ] 8. 部署到 Vercel ⏳

---

## 📝 重要提示

### .env 文件安全

- ✅ `.env` 文件已添加到 `.gitignore`
- ✅ 不会被提交到 GitHub
- ⚠️ 部署到 Vercel 时需要手动配置环境变量

### 音频文件大小

你的音频文件总大小约 230 MB：
- Supabase 免费版存储限制：500 MB
- ✅ 足够使用
- 如果需要更多，可以升级到 Pro 版

### 数据库限制

Supabase 免费版：
- 数据库大小：500 MB
- 每月请求：50,000 次
- ✅ 对于个人项目完全够用

---

## 🚀 下一步

**现在请执行第 2 步：执行建表 SQL**

1. 访问：https://supabase.com/dashboard/project/aouxwiisskawtylooxam/sql/new
2. 复制 `scripts/supabase-migration-verified.sql` 的内容
3. 粘贴并点击 Run
4. 完成后告诉我，我会帮你继续下一步！

---

**需要帮助？**
- 如果遇到任何问题，随时告诉我
- 我可以帮你写批量上传脚本
- 我可以帮你调试任何错误
