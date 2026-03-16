#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import os
from pathlib import Path

# 定义目录
PUBLIC_DIR = Path(__file__).parent.parent / "EastonJiang" / "public"
AUDIOS_DIR = PUBLIC_DIR / "audios"
SUBTITLES_DIR = PUBLIC_DIR / "subtitles"

# 分类配置
CATEGORIES = {
    "sentence-formulas": {
        "chinese_name": "造句公式",
        "id_prefix": "formula"
    },
    "american-accent": {
        "chinese_name": "美式口音",
        "id_prefix": "accent"
    },
    "oral-listening": {
        "chinese_name": "口语听力",
        "id_prefix": "listening"
    }
}

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

def generate_mock_data():
    """生成 mock-data.json"""
    audios = []
    
    # 保留原有的"每日跟读"数据
    daily_reading_data = [
        {
            "id": f"daily-{i}",
            "title": title,
            "category": "每日跟读",
            "audio_url": f"/audios/每日跟读/{title}.mp3",
            "subtitle_url": f"/subtitles/每日跟读/{title}.srt",
            "duration": 0,
            "status": None,
            "user_id": "local-user",
            "created_at": "2026-03-14T00:00:00Z"
        }
        for i, title in enumerate([
            "例句1-10", "例句11-20", "例句21-30", "例句31-40", "例句41-50",
            "例句51-60", "例句61-70", "例句71-80", "例句81-90", "例句91-100",
            "例句111-120", "例句121-130", "例句131-140", "例句141-150", "例句151-160",
            "例句161-170", "例句171-178", "例句179-186", "例句187-194", "例句195-198",
            "例句199-204", "例句205-212", "例句213-220"
        ], 1)
    ]
    
    audios.extend(daily_reading_data)
    
    # 处理新分类
    for category_key, config in CATEGORIES.items():
        audio_dir = AUDIOS_DIR / category_key
        
        if not audio_dir.exists():
            print(f"⚠ 目录不存在: {audio_dir}")
            continue
        
        mp3_files = sorted(audio_dir.glob("*.mp3"), key=lambda x: int(x.stem))
        print(f"✓ {config['chinese_name']}: 找到 {len(mp3_files)} 个文件")
        
        for idx, mp3_file in enumerate(mp3_files, 1):
            filename = mp3_file.name
            srt_filename = filename.replace('.mp3', '.srt')
            
            audio_entry = {
                "id": f"{config['id_prefix']}-{idx}",
                "title": generate_title(filename, category_key),
                "category": config['chinese_name'],
                "audio_url": f"/audios/{category_key}/{filename}",
                "subtitle_url": f"/subtitles/{category_key}/{srt_filename}",
                "duration": 0,
                "status": None,
                "user_id": "local-user",
                "created_at": "2026-03-16T00:00:00Z"
            }
            audios.append(audio_entry)
    
    # 写入文件
    output_file = AUDIOS_DIR / "mock-data.json"
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(audios, f, ensure_ascii=False, indent=2)
    
    print(f"\n✅ 已生成 {len(audios)} 条记录到: {output_file}")
    print(f"   - 每日跟读: 23 条")
    print(f"   - 造句公式: {len([a for a in audios if a['category'] == '造句公式'])} 条")
    print(f"   - 美式口音: {len([a for a in audios if a['category'] == '美式口音'])} 条")
    print(f"   - 口语听力: {len([a for a in audios if a['category'] == '口语听力'])} 条")

if __name__ == "__main__":
    generate_mock_data()
