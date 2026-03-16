#!/bin/bash

# 将所有音频和字幕文件重命名为简单的英文序号
# 使用方法: ./rename_to_english.sh

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   文件重命名为英文序号${NC}"
echo -e "${BLUE}========================================${NC}\n"

# 重命名函数
rename_category() {
    local category_dir=$1
    local category_name=$2
    
    echo -e "${GREEN}━━━ 处理: $category_name ━━━${NC}\n"
    
    if [ ! -d "$category_dir" ]; then
        echo -e "${YELLOW}⚠ 目录不存在: $category_dir${NC}\n"
        return
    fi
    
    cd "$category_dir"
    
    # 统计文件数量
    local count=$(find . -maxdepth 1 -name "*.mp3" | wc -l | tr -d ' ')
    
    if [ $count -eq 0 ]; then
        echo -e "${YELLOW}⚠ 没有找到 MP3 文件${NC}\n"
        return
    fi
    
    echo -e "${BLUE}找到 $count 个文件${NC}\n"
    
    # 创建临时目录
    mkdir -p temp_rename
    
    # 重命名并复制
    local index=1
    find . -maxdepth 1 -name "*.mp3" -print0 | sort -z | while IFS= read -r -d '' mp3_file; do
        local old_basename=$(basename "$mp3_file")
        local old_srt="${mp3_file%.mp3}.srt"
        
        echo -e "${YELLOW}[$index/$count]${NC} $old_basename → ${index}.mp3"
        
        # 复制到临时目录
        cp "$mp3_file" "temp_rename/${index}.mp3"
        
        if [ -f "$old_srt" ]; then
            cp "$old_srt" "temp_rename/${index}.srt"
            echo "         $(basename "$old_srt") → ${index}.srt"
        fi
        
        ((index++))
    done
    
    # 删除原文件
    echo -e "\n${BLUE}删除原文件...${NC}"
    find . -maxdepth 1 -name "*.mp3" -delete
    find . -maxdepth 1 -name "*.srt" -delete
    
    # 移动新文件
    echo -e "${BLUE}移动新文件...${NC}"
    mv temp_rename/* .
    rmdir temp_rename
    
    echo -e "${GREEN}✓ 完成: $count 个文件已重命名${NC}\n"
}

# 处理 resource 目录
echo -e "${BLUE}=== 处理 resource 目录 ===${NC}\n"
rename_category "$PROJECT_ROOT/resource/sentence-formulas" "造句公式"
rename_category "$PROJECT_ROOT/resource/american-accent" "美式口音"
rename_category "$PROJECT_ROOT/resource/oral-listening" "口语听力"

# 处理 public/audios 目录
echo -e "\n${BLUE}=== 处理 public/audios 目录 ===${NC}\n"
rename_category "$PROJECT_ROOT/EastonJiang/public/audios/sentence-formulas" "造句公式"
rename_category "$PROJECT_ROOT/EastonJiang/public/audios/american-accent" "美式口音"
rename_category "$PROJECT_ROOT/EastonJiang/public/audios/oral-listening" "口语听力"

# 处理 public/subtitles 目录
echo -e "\n${BLUE}=== 处理 public/subtitles 目录 ===${NC}\n"
rename_category "$PROJECT_ROOT/EastonJiang/public/subtitles/sentence-formulas" "造句公式"
rename_category "$PROJECT_ROOT/EastonJiang/public/subtitles/american-accent" "美式口音"
rename_category "$PROJECT_ROOT/EastonJiang/public/subtitles/oral-listening" "口语听力"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   所有文件重命名完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\n新文件命名格式: 1.mp3, 2.mp3, 3.mp3, ..."
echo -e "对应字幕文件: 1.srt, 2.srt, 3.srt, ...\n"
