# 📤 音频上传指南

## 🎯 目标

将 23 个"每日跟读"音频和字幕文件上传到 Supabase Storage，并在数据库中创建记录。

---

## 📋 准备工作

### ✅ 已完成
- [x] Supabase 项目已创建
- [x] 数据库表已创建（audios, playback_progress, vocabulary）
- [x] Storage buckets 已创建（audios, subtitles）
- [x] Email 认证已启用
- [x] .env 文件已配置

### ⏳ 待完成
- [ ] 注册测试账号
- [ ] 上传音频文件
- [ ] 测试应用

---

## 🚀 方案选择

### 方案 A：手动上传（推荐，简单直接）

**优点**：
- ✅ 不需要额外脚本
- ✅ 可以看到上传进度
- ✅ 适合少量文件（23个）

**步骤**：

#### 1. 注册账号

1. 访问 http://localhost:3000
2. 点击"注册"标签
3. 输入邮箱和密码（至少6位）
4. 点击"注册"
5. 登录成功后，记住你的邮箱

#### 2. 获取用户 ID

1. 打开浏览器开发者工具（F12）
2. 在 Console 中输入：
   ```javascript
   localStorage.getItem('sb-aouxwiisskawtylooxam-auth-token')
   ```
3. 复制返回的 JSON 中的 `user.id` 值

或者：

1. 访问 Supabase 控制台
2. 点击 **Authentication** → **Users**
3. 找到你注册的用户，复制 UUID

#### 3. 上传音频文件

1. 访问 Supabase 控制台：https://supabase.com/dashboard/project/aouxwiisskawtylooxam
2. 点击左侧 **Storage**
3. 点击 `audios` bucket
4. 点击 **Create folder**，输入：`每日跟读`
5. 进入 `每日跟读` 文件夹
6. 点击 **Upload files**
7. 选择所有 23 个 mp3 文件（在 `processed/每日跟读/` 目录）
8. 等待上传完成（约 2-3 分钟，230MB）

#### 4. 上传字幕文件

1. 返回 Storage
2. 点击 `subtitles` bucket
3. 点击 **Create folder**，输入：`每日跟读`
4. 进入 `每日跟读` 文件夹
5. 点击 **Upload files**
6. 选择所有 23 个 srt 文件
7. 等待上传完成（约 10 秒）

#### 5. 创建数据库记录

**方式 1：使用 SQL（推荐，快速）**

1. 点击左侧 **SQL Editor**
2. 点击 **New query**
3. 复制以下 SQL（替换 YOUR_USER_ID）：

```sql
-- 替换这里的 YOUR_USER_ID 为你的用户 ID
INSERT INTO public.audios (title, category, audio_url, subtitle_url, duration, user_id) VALUES
('例句1-10', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句1-10.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句1-10.srt', 0, 'YOUR_USER_ID'),
('例句11-20', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句11-20.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句11-20.srt', 0, 'YOUR_USER_ID'),
('例句21-30', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句21-30.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句21-30.srt', 0, 'YOUR_USER_ID'),
('例句31-40', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句31-40.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句31-40.srt', 0, 'YOUR_USER_ID'),
('例句41-50', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句41-50.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句41-50.srt', 0, 'YOUR_USER_ID'),
('例句51-60', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句51-60.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句51-60.srt', 0, 'YOUR_USER_ID'),
('例句61-70', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句61-70.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句61-70.srt', 0, 'YOUR_USER_ID'),
('例句71-80', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句71-80.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句71-80.srt', 0, 'YOUR_USER_ID'),
('例句81-90', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句81-90.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句81-90.srt', 0, 'YOUR_USER_ID'),
('例句91-100', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句91-100.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句91-100.srt', 0, 'YOUR_USER_ID'),
('例句111-120', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句111-120.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句111-120.srt', 0, 'YOUR_USER_ID'),
('例句121-130', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句121-130.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句121-130.srt', 0, 'YOUR_USER_ID'),
('例句131-140', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句131-140.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句131-140.srt', 0, 'YOUR_USER_ID'),
('例句141-150', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句141-150.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句141-150.srt', 0, 'YOUR_USER_ID'),
('例句151-160', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句151-160.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句151-160.srt', 0, 'YOUR_USER_ID'),
('例句161-170', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句161-170.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句161-170.srt', 0, 'YOUR_USER_ID'),
('例句171-178', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句171-178.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句171-178.srt', 0, 'YOUR_USER_ID'),
('例句179-186', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句179-186.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句179-186.srt', 0, 'YOUR_USER_ID'),
('例句187-194', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句187-194.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句187-194.srt', 0, 'YOUR_USER_ID'),
('例句195-198', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句195-198.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句195-198.srt', 0, 'YOUR_USER_ID'),
('例句199-204', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句199-204.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句199-204.srt', 0, 'YOUR_USER_ID'),
('例句205-212', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句205-212.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句205-212.srt', 0, 'YOUR_USER_ID'),
('例句213-220', '每日跟读', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/audios/每日跟读/例句213-220.mp3', 'https://aouxwiisskawtylooxam.supabase.co/storage/v1/object/public/subtitles/每日跟读/例句213-220.srt', 0, 'YOUR_USER_ID');
```

4. 替换所有 `YOUR_USER_ID` 为你的用户 ID
5. 点击 **Run**
6. 应该看到：`Success. No rows returned`

#### 6. 测试应用

1. 访问 http://localhost:3000
2. 登录（如果未登录）
3. 点击"每日跟读"标签
4. 应该能看到 23 个音频
5. 点击任意音频测试播放

---

### 方案 B：使用 Python 脚本（自动化）

**注意**：需要先完成方案 A 的步骤 1（注册账号）

**步骤**：

1. 在应用中注册并登录账号
2. 运行上传脚本：
   ```bash
   cd scripts
   python3 upload_to_supabase.py
   ```
3. 脚本会自动：
   - 上传所有音频文件
   - 上传所有字幕文件
   - 创建数据库记录

---

## ✅ 验证清单

上传完成后，检查：

- [ ] Supabase Storage 中有 23 个音频文件
- [ ] Supabase Storage 中有 23 个字幕文件
- [ ] 数据库 `audios` 表中有 23 条记录
- [ ] 前端应用能看到所有音频
- [ ] 点击音频能正常播放
- [ ] 字幕能正常显示和同步

---

## 🎯 当前进度

- [x] 1. 创建 Supabase 项目 ✅
- [x] 2. 执行建表 SQL ✅
- [x] 3. 创建 Storage Buckets ✅
- [x] 4. 启用 Email 认证 ✅
- [x] 5. 配置 .env 文件 ✅
- [ ] 6. **上传音频文件** ⏳ **← 现在做这个**
- [ ] 7. 测试应用 ⏳
- [ ] 8. 推送到 GitHub ⏳
- [ ] 9. 部署到 Vercel ⏳

---

## 💡 提示

- 上传 230MB 文件可能需要 2-3 分钟，请耐心等待
- 如果上传中断，可以重新上传（会覆盖）
- 确保 Storage buckets 设置为 public
- 数据库记录的 URL 必须与 Storage 中的文件路径完全匹配

---

## 🆘 遇到问题？

### 问题 1：上传失败
- 检查网络连接
- 确认 Storage buckets 已创建
- 确认文件大小不超过限制

### 问题 2：看不到音频
- 检查数据库记录的 user_id 是否正确
- 检查 URL 是否正确
- 刷新浏览器页面

### 问题 3：音频无法播放
- 检查 Storage buckets 是否设置为 public
- 检查音频文件是否上传成功
- 在浏览器中直接访问音频 URL 测试

---

**准备好了吗？开始上传吧！**
