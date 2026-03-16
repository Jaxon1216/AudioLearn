#!/bin/bash

# 批量处理新视频：提取音频 + 生成字幕
# 使用方法: ./process_new_videos.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
RESOURCE_DIR="$PROJECT_ROOT/resource"

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   批量视频处理脚本${NC}"
echo -e "${BLUE}========================================${NC}\n"

# 激活 Python 环境
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
pyenv global 3.11.15

# 检查必要工具
command -v ffmpeg >/dev/null 2>&1 || { echo "错误: 需要安装 ffmpeg"; exit 1; }
python -c "import faster_whisper" 2>/dev/null || { echo "错误: 需要安装 faster-whisper"; exit 1; }

# 处理函数
process_category() {
    local chinese_name=$1
    local english_name=$2
    local bitrate=$3
    
    local source_dir="$RESOURCE_DIR/$chinese_name"
    local output_dir="$RESOURCE_DIR/$english_name"
    
    echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}处理分类: $chinese_name → $english_name${NC}"
    echo -e "${GREEN}音频质量: ${bitrate}kbps${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    
    # 创建输出目录
    mkdir -p "$output_dir"
    
    # 统计视频文件数量
    video_count=$(find "$source_dir" -name "*.mp4" | wc -l | tr -d ' ')
    echo -e "${BLUE}找到 $video_count 个视频文件${NC}\n"
    
    if [ "$video_count" -eq 0 ]; then
        echo -e "${YELLOW}⚠ 没有找到视频文件，跳过${NC}"
        return
    fi
    
    local processed=0
    local failed=0
    
    # 遍历所有 MP4 文件
    for video_file in "$source_dir"/*.mp4; do
        [ -e "$video_file" ] || continue
        
        filename=$(basename "$video_file")
        base_name="${filename%.*}"
        
        # 生成英文文件名（移除方括号和特殊字符）
        english_filename=$(echo "$base_name" | sed 's/\[//g; s/\]//g; s/-【.*】/-/g; s/：/-/g; s/，/-/g; s/\"//g; s/"//g; s/"//g')
        english_filename=$(echo "$english_filename" | sed 's/--*/-/g; s/-$//g; s/^-//g')
        
        output_audio="$output_dir/${english_filename}.mp3"
        output_subtitle="$output_dir/${english_filename}.srt"
        
        echo -e "${YELLOW}[$((processed + failed + 1))/$video_count]${NC} 处理: $filename"
        
        # 跳过已存在的文件
        if [ -f "$output_audio" ] && [ -f "$output_subtitle" ]; then
            echo "  ⏭  已存在，跳过"
            ((processed++))
            continue
        fi
        
        # 提取音频
        if [ ! -f "$output_audio" ]; then
            echo "  🎵 提取音频 (${bitrate}kbps)..."
            if ffmpeg -i "$video_file" -vn -ar 44100 -ac 2 -b:a ${bitrate}k "$output_audio" -y -loglevel error; then
                echo "  ✓ 音频提取完成"
            else
                echo "  ✗ 音频提取失败"
                ((failed++))
                continue
            fi
        fi
        
        # 生成字幕
        if [ ! -f "$output_subtitle" ]; then
            echo "  📝 生成字幕..."
            if python3 << EOF
import sys
import os
from faster_whisper import WhisperModel

# 禁用代理（仅在 Python 进程内）
os.environ['HTTP_PROXY'] = ''
os.environ['HTTPS_PROXY'] = ''
os.environ['http_proxy'] = ''
os.environ['https_proxy'] = ''

try:
    model = WhisperModel("tiny", device="cpu", compute_type="int8")
    segments, info = model.transcribe("$output_audio", language="en")
    
    with open("$output_subtitle", "w", encoding="utf-8") as f:
        for i, segment in enumerate(segments, 1):
            start_time = segment.start
            end_time = segment.end
            text = segment.text.strip()
            
            start_h = int(start_time // 3600)
            start_m = int((start_time % 3600) // 60)
            start_s = int(start_time % 60)
            start_ms = int((start_time % 1) * 1000)
            
            end_h = int(end_time // 3600)
            end_m = int((end_time % 3600) // 60)
            end_s = int(end_time % 60)
            end_ms = int((end_time % 1) * 1000)
            
            f.write(f"{i}\n")
            f.write(f"{start_h:02d}:{start_m:02d}:{start_s:02d},{start_ms:03d} --> {end_h:02d}:{end_m:02d}:{end_s:02d},{end_ms:03d}\n")
            f.write(f"{text}\n\n")
    
    print("  ✓ 字幕生成完成", file=sys.stderr)
except Exception as e:
    print(f"  ✗ 字幕生成失败: {e}", file=sys.stderr)
    sys.exit(1)
EOF
            then
                ((processed++))
            else
                ((failed++))
                continue
            fi
        else
            ((processed++))
        fi
        
        echo ""
    done
    
    echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}完成: $processed 个 | 失败: $failed 个${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# 处理三个分类
process_category "造句公式" "sentence-formulas" "128"
process_category "美式口音" "american-accent" "96"
process_category "口语听力" "oral-listening" "128"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   所有处理完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\n输出目录:"
echo -e "  • resource/sentence-formulas/"
echo -e "  • resource/american-accent/"
echo -e "  • resource/oral-listening/"
