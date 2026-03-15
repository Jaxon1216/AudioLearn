#!/bin/bash

# 检查处理进度的脚本

OUTPUT_DIR="../processed"

echo "=== 音频处理进度 ==="
echo ""

for category in 每日跟读 造句公式 口语听力 美式口音 访谈节目 雅思; do
    mp3_count=$(find "$OUTPUT_DIR/$category" -name "*.mp3" 2>/dev/null | wc -l | tr -d ' ')
    srt_count=$(find "$OUTPUT_DIR/$category" -name "*.srt" -size +0 2>/dev/null | wc -l | tr -d ' ')
    
    if [ "$mp3_count" -gt 0 ]; then
        echo "$category:"
        echo "  音频文件: $mp3_count 个"
        echo "  字幕文件: $srt_count 个（完成）"
        echo ""
    fi
done

echo "总计:"
total_mp3=$(find "$OUTPUT_DIR" -name "*.mp3" 2>/dev/null | wc -l | tr -d ' ')
total_srt=$(find "$OUTPUT_DIR" -name "*.srt" -size +0 2>/dev/null | wc -l | tr -d ' ')
echo "  音频: $total_mp3 个"
echo "  字幕: $total_srt 个（完成）"
