# 🎉 工具配置完成！

**完成时间**: 2026年3月15日

---

## ✅ 已完成的配置

### 1. Cursor 命令行快捷方式 ✅

已添加到 `~/.zshrc`，现在可以在任何目录使用：

```bash
# 在任何目录打开 Cursor
cursor .

# 打开特定文件
cursor path/to/file.ts

# 打开特定目录
cursor /path/to/project
```

**验证命令**：
```bash
cursor --version
# 输出: 2.6.19
```

### 2. ffmpeg 8.0.1 ✅

通过 Homebrew 安装，用于视频音频处理。

**验证命令**：
```bash
ffmpeg -version
# 输出: ffmpeg version 8.0.1
```

**使用示例**：
```bash
# 从视频提取音频
ffmpeg -i video.mp4 -vn -ar 44100 -ac 2 -b:a 128k output.mp3
```

### 3. Python 3.11.15 (pyenv) ✅

已通过 pyenv 安装并设置为全局默认版本。

**验证命令**：
```bash
python --version
# 输出: Python 3.11.15
```

### 4. faster-whisper 1.2.1 ✅

已安装，用于生成音频字幕。

**验证命令**：
```bash
python -c "from faster_whisper import WhisperModel; print('✅ faster-whisper 已成功安装！')"
```

**使用示例**：
```bash
# 使用项目中的脚本生成字幕
cd /Users/eastonjiang/code/vibe/Alan
python scripts/whisper_transcribe.py audio.mp3 output_dir base
```

---

## 🔍 快速验证

运行验证脚本检查所有工具是否正确安装：

```bash
cd /Users/eastonjiang/code/vibe/Alan
./scripts/verify-setup.sh
```

如果所有检查都通过，你会看到：
```
🎉 所有工具已正确安装！
通过: 5
失败: 0
```

---

## 📋 快速使用指南

### 在项目目录中打开 Cursor

```bash
# 方法 1: 先进入目录
cd /Users/eastonjiang/code/vibe/Alan
cursor .

# 方法 2: 直接指定路径
cursor /Users/eastonjiang/code/vibe/Alan
```

### 处理视频文件

```bash
cd /Users/eastonjiang/code/vibe/Alan

# 1. 将视频放到 raw_videos 文件夹
mkdir -p raw_videos
mv your_video.mp4 raw_videos/

# 2. 运行批量处理脚本
cd scripts
./process-videos.sh

# 处理完成后，在 processed/ 文件夹中会有：
# - your_video.mp3 (音频文件)
# - your_video.srt (字幕文件)
```

### 单独提取音频

```bash
ffmpeg -i input.mp4 -vn -ar 44100 -ac 2 -b:a 128k output.mp3
```

### 单独生成字幕

```bash
python scripts/whisper_transcribe.py input.mp3 output_dir base
```

---

## 🔧 环境变量说明

已在 `~/.zshrc` 中添加以下配置：

```bash
# Cursor 命令行快捷方式
export PATH="$PATH:/Applications/Cursor.app/Contents/Resources/app/bin"

# pyenv (Python 版本管理)
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
```

**重要提示**：每次打开新的终端窗口，这些配置会自动加载。如果在当前终端中配置不生效，运行：

```bash
source ~/.zshrc
```

---

## 📊 工具版本总结

| 工具 | 版本 | 状态 | 用途 |
|------|------|------|------|
| Cursor | 2.6.19 | ✅ 已配置 | 代码编辑器 |
| ffmpeg | 8.0.1 | ✅ 已安装 | 视频/音频处理 |
| Python | 3.11.15 | ✅ 已安装 | 运行脚本 |
| faster-whisper | 1.2.1 | ✅ 已安装 | 生成字幕 |
| Node.js | 系统版本 | ✅ 可用 | 运行 React 应用 |

---

## 🎯 下一步操作

根据项目文档（`alan/README.md` 和 `alan/SETUP_GUIDE.md`），你可以：

### 1. 启动应用（本地模式 - 无需配置）

```bash
cd /Users/eastonjiang/code/vibe/Alan/alan
npm install  # 首次运行需要安装依赖
npm start    # 启动开发服务器
```

应用会在 http://localhost:3000 启动，使用本地 localStorage 存储数据。

### 2. 配置 Supabase（可选 - 用于云端同步）

如果需要跨设备数据同步，参考 `alan/SETUP_GUIDE.md` 配置 Supabase：

1. 创建 Supabase 项目
2. 执行数据库迁移
3. 创建 Storage buckets
4. 配置 `.env` 文件

### 3. 处理视频文件

```bash
# 将视频放到 raw_videos/
mkdir -p raw_videos
mv your_video.mp4 raw_videos/

# 运行处理脚本
cd scripts
./process-videos.sh
```

---

## ❓ 常见问题

### Q: cursor 命令找不到？

**A**: 运行 `source ~/.zshrc` 重新加载配置，或者关闭终端重新打开。

### Q: python 版本不对？

**A**: 确保 pyenv 已加载：
```bash
source ~/.zshrc
pyenv global 3.11.15
python --version
```

### Q: faster-whisper 导入失败？

**A**: 确认使用正确的 Python：
```bash
source ~/.zshrc
which python  # 应该显示 /Users/eastonjiang/.pyenv/shims/python
python -m pip list | grep faster-whisper
```

### Q: 处理视频时出错？

**A**: 检查：
1. 确保脚本有执行权限：`chmod +x scripts/process-videos.sh`
2. 确保 ffmpeg 可用：`ffmpeg -version`
3. 确保 Python 环境正确：`python --version`

---

## 💡 使用技巧

### Whisper 模型选择

根据需求选择不同的模型大小：

| 模型 | 大小 | 速度 | 准确度 | 推荐场景 |
|------|------|------|--------|---------|
| tiny | ~75MB | 最快 | 较低 | 快速测试 |
| **base** | ~140MB | 快 | **良好** | **日常使用（推荐）** |
| small | ~460MB | 中等 | 更好 | 高质量需求 |
| medium | ~1.5GB | 慢 | 很好 | 专业使用 |
| large | ~3GB | 很慢 | 最好 | 最高质量 |

**默认使用 base 模型**，在脚本中可以修改：

```bash
python scripts/whisper_transcribe.py audio.mp3 output_dir small  # 使用 small 模型
```

### 批量处理多个视频

```bash
# 将所有视频放到 raw_videos/
cp *.mp4 raw_videos/

# 运行脚本会自动处理所有视频
cd scripts
./process-videos.sh
```

---

## 🎊 总结

所有必需的工具已安装并配置完成！

✅ **Cursor 命令** - 可以在任何目录使用 `cursor .`
✅ **ffmpeg** - 可以提取音频
✅ **Python 3.11** - 可以运行脚本
✅ **faster-whisper** - 可以生成字幕

现在你可以：
1. 使用 `cursor .` 打开项目
2. 运行 `npm start` 启动应用
3. 使用脚本处理视频文件

**祝你使用愉快！🚀**

---

## 📞 需要帮助？

查看项目文档：
- 使用说明：`alan/README.md`
- 配置指南：`alan/SETUP_GUIDE.md`
- 安装说明：`INSTALLATION_COMPLETE.md`
- Whisper 安装：`WHISPER_INSTALL.md`
