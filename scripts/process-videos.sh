#!/bin/bash

# Alan 音频学习应用 - 视频预处理脚本
# 功能：批量处理视频，提取音频并生成字幕

set -e

# 配置
INPUT_DIR="../raw_videos"
OUTPUT_DIR="../processed"
WHISPER_MODEL="base"

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== Alan 视频预处理脚本 ===${NC}"
echo ""

# 检查依赖
if ! command -v ffmpeg &> /dev/null; then
    echo -e "${RED}错误: ffmpeg 未安装。请运行: brew install ffmpeg${NC}"
    exit 1
fi

# 设置 Python 环境
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)" 2>/dev/null || true

# 检查 faster-whisper
if ! python3 -c "import faster_whisper" 2>/dev/null; then
    echo -e "${RED}错误: faster-whisper 未安装。${NC}"
    echo -e "${YELLOW}请运行: pip install faster-whisper${NC}"
    exit 1
fi

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 统计文件数
VIDEO_COUNT=$(find "$INPUT_DIR" -maxdepth 1 -name "*.mp4" | wc -l)
if [ "$VIDEO_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}警告: 在 $INPUT_DIR 中没有找到 .mp4 文件${NC}"
    exit 0
fi

echo -e "${GREEN}找到 $VIDEO_COUNT 个视频文件${NC}"
echo ""

# 处理每个视频
CURRENT=0
for video in "$INPUT_DIR"/*.mp4; do
    CURRENT=$((CURRENT + 1))
    filename=$(basename "$video" .mp4)
    
    echo -e "${GREEN}[$CURRENT/$VIDEO_COUNT] 处理: $filename${NC}"
    
    # 1. 提取音频
    echo -e "${YELLOW}  → 提取音频...${NC}"
    ffmpeg -i "$video" -vn -ar 44100 -ac 2 -b:a 128k \
        "$OUTPUT_DIR/${filename}.mp3" \
        -y -loglevel error
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✓ 音频提取成功${NC}"
    else
        echo -e "${RED}  ✗ 音频提取失败${NC}"
        continue
    fi
    
    # 2. 生成字幕（使用 faster-whisper）
    echo -e "${YELLOW}  → 生成字幕...${NC}"
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    
    python3 "$(dirname "$0")/whisper_transcribe.py" \
        "$OUTPUT_DIR/${filename}.mp3" \
        "$OUTPUT_DIR" \
        "$WHISPER_MODEL"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✓ 字幕生成成功${NC}"
    else
        echo -e "${RED}  ✗ 字幕生成失败${NC}"
    fi
    
    echo ""
done

echo -e "${GREEN}=== 处理完成 ===${NC}"
echo -e "${GREEN}音频和字幕文件保存在: $OUTPUT_DIR${NC}"
echo ""
echo -e "${YELLOW}下一步:${NC}"
echo "1. 检查生成的音频和字幕文件"
echo "2. 登录 Supabase 控制台"
echo "3. 上传音频文件到 'audios' bucket"
echo "4. 上传字幕文件到 'subtitles' bucket"
echo "5. 在 'audios' 表中添加记录"
