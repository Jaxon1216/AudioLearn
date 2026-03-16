#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import json
from pathlib import Path
from datetime import datetime

# Supabase 配置
SUPABASE_URL = "https://aouxwiisskawtylooxam.supabase.co"
USER_ID = "bc47bf9a-33a3-45f6-afcc-de9afe441afa"

# 项目目录
PROJECT_ROOT = Path(__file__).parent.parent
PUBLIC_DIR = PROJECT_ROOT / "EastonJiang" / "public"

# 分类映射
CATEGORIES = {
    "sentence-formulas": "造句公式",
    "american-accent": "美式口音",
    "oral-listening": "口语听力"
}

def get_audio_duration(mp3_path):
    """获取音频时长（秒）"""
    try:
        import subprocess
        result = subprocess.run(
            ['ffprobe', '-v', 'error', '-show_entries', 'format=duration', 
             '-of', 'default=noprint_wrappers=1:nokey=1', str(mp3_path)],
            capture_output=True,
            text=True
        )
        return int(float(result.stdout.strip()))
    except:
        return 0

def generate_title(filename, category_key):
    """根据文件名生成标题"""
    # 移除扩展名
    name = filename.replace('.mp3', '')
    
    # 新的简单命名: 1.mp3, 2.mp3, 3.mp3...
    if category_key == "sentence-formulas":
        return f"造句公式 {name}"
    elif category_key == "american-accent":
        return f"美式口音 第{name}节"
    elif category_key == "oral-listening":
        return f"口语听力 第{name}节"
    
    return name

def generate_sql():
    """生成 SQL INSERT 语句"""
    
    sql_statements = []
    sql_statements.append("-- 新分类音频数据插入语句")
    sql_statements.append("-- 生成时间: " + datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
    sql_statements.append("")
    
    total_count = 0
    
    for category_key, chinese_name in CATEGORIES.items():
        audio_dir = PUBLIC_DIR / "audios" / category_key
        
        if not audio_dir.exists():
            print(f"⚠ 目录不存在: {audio_dir}")
            continue
        
        mp3_files = sorted(audio_dir.glob("*.mp3"), key=lambda x: int(x.stem))
        
        if not mp3_files:
            print(f"⚠ 没有找到 MP3 文件: {audio_dir}")
            continue
        
        sql_statements.append(f"-- {chinese_name} ({len(mp3_files)} 个)")
        sql_statements.append("")
        
        for idx, mp3_file in enumerate(mp3_files, 1):
            filename = mp3_file.name
            srt_filename = filename.replace('.mp3', '.srt')
            title = generate_title(filename, category_key)
            duration = get_audio_duration(mp3_file)
            
            audio_url = f"{SUPABASE_URL}/storage/v1/object/public/audios/{category_key}/{filename}"
            subtitle_url = f"{SUPABASE_URL}/storage/v1/object/public/subtitles/{category_key}/{srt_filename}"
            
            sql = f"""INSERT INTO audios (user_id, title, category, audio_url, subtitle_url, duration, status)
VALUES (
  '{USER_ID}',
  '{title}',
  '{chinese_name}',
  '{audio_url}',
  '{subtitle_url}',
  {duration},
  NULL
);"""
            
            sql_statements.append(sql)
            sql_statements.append("")
            total_count += 1
        
        print(f"✓ {chinese_name}: 生成 {len(mp3_files)} 条 SQL 语句")
    
    # 写入文件
    output_file = PROJECT_ROOT / "scripts" / "insert_new_categories.sql"
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(sql_statements))
    
    print(f"\n✅ 已生成 {total_count} 条 SQL INSERT 语句")
    print(f"📄 文件位置: {output_file}")
    
    return output_file

if __name__ == "__main__":
    generate_sql()
