#!/bin/bash

# Alan 音频学习应用 - 视频预处理脚本（支持分类）
# 功能：批量处理视频，提取音频并生成字幕，按分类存储

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

echo -e "${GREEN}=== Alan 视频预处理脚本（分类版）===${NC}"
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

# 创建分类目录
mkdir -p "$OUTPUT_DIR"/{每日跟读,造句公式,口语听力,美式口音,访谈节目,雅思}

# 函数：根据文件名确定分类
get_category() {
    local filename="$1"
    
    if [[ "$filename" == *"每日跟读"* ]]; then
        echo "每日跟读"
    elif [[ "$filename" == *"造句公式"* ]]; then
        echo "造句公式"
    elif [[ "$filename" == *"口语听力"* ]]; then
        echo "口语听力"
    elif [[ "$filename" == *"美式口音"* ]]; then
        echo "美式口音"
    elif [[ "$filename" == *"访谈节目"* ]]; then
        echo "访谈节目"
    elif [[ "$filename" == *"雅思"* ]]; then
        echo "雅思"
    else
        echo "其他"
    fi
}

# 函数：提取简化的文件名（只保留数字部分）
get_simple_name() {
    local filename="$1"
    
    # 对于每日跟读：提取 "例句1-10" 这样的格式
    if [[ "$filename" =~ 例句([0-9]+-[0-9]+) ]]; then
        echo "例句${BASH_REMATCH[1]}"
    # 对于其他格式：提取数字
    elif [[ "$filename" =~ \[([0-9]+)\] ]]; then
        echo "${BASH_REMATCH[1]}"
    else
        # 如果无法提取，使用原文件名
        echo "$filename"
    fi
}

# 统计文件数（排除 .downloading 文件）
VIDEO_COUNT=$(find "$INPUT_DIR" -maxdepth 1 -name "*.mp4" ! -name "*.downloading" | wc -l | tr -d ' ')
if [ "$VIDEO_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}警告: 在 $INPUT_DIR 中没有找到 .mp4 文件${NC}"
    exit 0
fi

echo -e "${GREEN}找到 $VIDEO_COUNT 个视频文件${NC}"
echo ""

# 处理每个视频
CURRENT=0
for video in "$INPUT_DIR"/*.mp4; do
    # 跳过正在下载的文件
    if [[ "$video" == *.downloading ]]; then
        continue
    fi
    
    CURRENT=$((CURRENT + 1))
    original_filename=$(basename "$video" .mp4)
    
    # 确定分类
    category=$(get_category "$original_filename")
    
    # 获取简化的文件名
    simple_name=$(get_simple_name "$original_filename")
    
    # 设置输出路径
    category_dir="$OUTPUT_DIR/$category"
    
    echo -e "${GREEN}[$CURRENT/$VIDEO_COUNT] 处理: $original_filename${NC}"
    echo -e "${YELLOW}  分类: $category | 新文件名: $simple_name${NC}"
    
    # 1. 提取音频
    echo -e "${YELLOW}  → 提取音频...${NC}"
    ffmpeg -i "$video" -vn -ar 44100 -ac 2 -b:a 128k \
        "$category_dir/${simple_name}.mp3" \
        -y -loglevel error
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✓ 音频提取成功: $category_dir/${simple_name}.mp3${NC}"
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
        "$category_dir/${simple_name}.mp3" \
        "$category_dir" \
        "$WHISPER_MODEL"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✓ 字幕生成成功: $category_dir/${simple_name}.srt${NC}"
    else
        echo -e "${RED}  ✗ 字幕生成失败${NC}"
    fi
    
    echo ""
done

echo -e "${GREEN}=== 处理完成 ===${NC}"
echo -e "${GREEN}文件已按分类保存在: $OUTPUT_DIR/<分类名>/${NC}"
echo ""
echo "生成的分类文件夹："
for category in 每日跟读 造句公式 口语听力 美式口音 访谈节目 雅思; do
    count=$(find "$OUTPUT_DIR/$category" -name "*.mp3" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$count" -gt 0 ]; then
        echo -e "  ${GREEN}$category: $count 个音频${NC}"
    fi
done
echo ""
echo -e "${YELLOW}下一步（本地模式）:${NC}"
echo "1. 将文件复制到 alan/public/audios/<分类>/ 和 alan/public/subtitles/<分类>/"
echo "2. 更新 alan/public/audios/mock-data.json"
echo ""
echo -e "${YELLOW}或者（Supabase 模式）:${NC}"
echo "1. 上传到 Supabase Storage 对应的文件夹"
echo "2. 在 audios 表中添加记录"
