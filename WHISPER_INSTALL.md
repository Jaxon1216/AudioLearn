# Whisper 安装指南

由于你的系统使用 Python 3.14（最新版），openai-whisper 可能存在兼容性问题。以下是几种解决方案：

## 🎯 推荐方案：使用 Python 3.11

### 方法 1：使用 pyenv（推荐）

```bash
# 安装 pyenv
brew install pyenv

# 安装 Python 3.11
pyenv install 3.11

# 设置全局版本
pyenv global 3.11

# 重新加载 shell
source ~/.zshrc

# 安装 Whisper
pip install openai-whisper
```

### 方法 2：使用 Homebrew Python

```bash
# 安装 Python 3.11
brew install python@3.11

# 使用 Python 3.11 安装 Whisper
/usr/local/opt/python@3.11/bin/pip3 install openai-whisper

# 创建别名（可选）
echo 'alias whisper="/usr/local/opt/python@3.11/bin/whisper"' >> ~/.zshrc
source ~/.zshrc
```

### 方法 3：尝试安装最新的 faster-whisper（替代方案）

faster-whisper 是 Whisper 的优化版本，可能兼容性更好：

```bash
pip3 install --break-system-packages faster-whisper
```

使用方式类似，但命令是 `faster-whisper` 而不是 `whisper`。

## 🔧 临时解决方案：手动转录

如果安装困难，你可以先跳过 Whisper，使用以下方案：

### 选项 A：在线服务

1. 使用 [Happy Scribe](https://www.happyscribe.com/) 或 [Otter.ai](https://otter.ai/)
2. 上传音频文件
3. 下载生成的 .srt 字幕文件

### 选项 B：使用现有字幕

如果你的视频已有字幕（内嵌或外挂），可以：
1. 使用 ffmpeg 提取：`ffmpeg -i video.mp4 -map 0:s:0 subtitle.srt`
2. 或使用在线工具提取字幕

## ✅ 验证安装

安装成功后，运行以下命令测试：

```bash
# 检查 Whisper 版本
whisper --version

# 或 faster-whisper
faster-whisper --version
```

## 📝 修改处理脚本

如果你使用了 `faster-whisper`，需要修改 `scripts/process-videos.sh`：

将：
```bash
whisper "$OUTPUT_DIR/${filename}.mp3" \
  --model base \
  --language auto \
  --output_format srt \
  --output_dir "$OUTPUT_DIR"
```

改为：
```bash
faster-whisper "$OUTPUT_DIR/${filename}.mp3" \
  --model base \
  --language auto \
  --output_format srt \
  --output_dir "$OUTPUT_DIR"
```

## 🚀 项目仍可继续

即使暂时没有 Whisper，你仍然可以：

1. ✅ **配置 Supabase** - 创建数据库和存储
2. ✅ **启动 React 应用** - 测试前端功能
3. ✅ **使用 ffmpeg 提取音频** - `ffmpeg -i video.mp4 -vn audio.mp3`
4. ✅ **手动上传已有字幕** - 如果你有 .srt 文件

Whisper 只用于**生成字幕**，不影响应用的其他功能！

## 🎯 下一步

建议先完成以下步骤，Whisper 可以稍后再处理：

1. **配置 Supabase**（详见 `alan/SETUP_GUIDE.md`）
2. **启动应用测试**（`cd alan && npm start`）
3. **准备测试数据**（如果有现成字幕更好）
4. **稍后再安装 Whisper**（或使用替代方案）

---

**重要提示**：Python 3.14 刚发布不久，很多库还需要时间适配。建议等待 openai-whisper 更新，或使用 Python 3.11。
