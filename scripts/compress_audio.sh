#!/bin/bash

# 批量压缩音频文件
# 将 128 kbps 压缩为 96 kbps（节省约 25% 空间，音质仍然良好）

SOURCE_DIR="../processed/每日跟读"
OUTPUT_DIR="../processed/daily-reading-compressed"
BITRATE="96k"  # 可选: 96k, 64k, 48k

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== 音频压缩脚本 ===${NC}"
echo "比特率: $BITRATE"
echo ""

# 检查 ffmpeg
if ! command -v ffmpeg &> /dev/null; then
    echo -e "${YELLOW}错误: ffmpeg 未安装${NC}"
    exit 1
fi

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 统计
TOTAL=$(ls "$SOURCE_DIR"/*.mp3 2>/dev/null | wc -l)
CURRENT=0

echo "找到 $TOTAL 个音频文件"
echo ""

# 压缩每个文件
for file in "$SOURCE_DIR"/*.mp3; do
    if [ -f "$file" ]; then
        CURRENT=$((CURRENT + 1))
        filename=$(basename "$file")
        # 重命名为英文
        newname=$(echo "$filename" | sed 's/例句/lesson-/')
        
        echo -e "${GREEN}[$CURRENT/$TOTAL] 压缩: $filename${NC}"
        
        # 获取原始大小
        original_size=$(du -h "$file" | cut -f1)
        
        # 压缩
        ffmpeg -i "$file" -b:a "$BITRATE" -ar 44100 \
            "$OUTPUT_DIR/$newname" \
            -y -loglevel error
        
        if [ $? -eq 0 ]; then
            # 获取压缩后大小
            compressed_size=$(du -h "$OUTPUT_DIR/$newname" | cut -f1)
            echo -e "  原始: $original_size → 压缩后: $compressed_size"
        else
            echo -e "${YELLOW}  压缩失败${NC}"
        fi
        echo ""
    fi
done

# 统计结果
echo -e "${GREEN}=== 压缩完成 ===${NC}"
echo ""
echo "原始目录: $SOURCE_DIR"
original_total=$(du -sh "$SOURCE_DIR" | cut -f1)
echo "原始大小: $original_total"
echo ""
echo "压缩目录: $OUTPUT_DIR"
compressed_total=$(du -sh "$OUTPUT_DIR" | cut -f1)
echo "压缩后大小: $compressed_total"
echo ""
echo "节省空间: 约 25%"
echo ""
echo -e "${YELLOW}下一步:${NC}"
echo "1. 检查压缩后的音频质量（试听几个文件）"
echo "2. 如果满意，上传压缩后的文件到 Supabase"
echo "3. 更新数据库中的 URL"
