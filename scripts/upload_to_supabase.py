#!/usr/bin/env python3
"""
批量上传音频和字幕文件到 Supabase Storage
并在数据库中创建记录
"""

import os
import sys
from pathlib import Path
from supabase import create_client, Client
import mimetypes

# Supabase 配置
SUPABASE_URL = "https://aouxwiisskawtylooxam.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFvdXh3aWlzc2thd3R5bG9veGFtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM2MDc3MTQsImV4cCI6MjA4OTE4MzcxNH0.OiYzJwlVMiinxoPJfLrG_Bm0UAVJ9WZOW7TykRbb9oY"

# 目录配置
PROCESSED_DIR = Path("../processed/每日跟读")
AUDIO_BUCKET = "audios"
SUBTITLE_BUCKET = "subtitles"
CATEGORY = "每日跟读"

# 初始化 Supabase 客户端
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

def get_user_id():
    """获取当前登录用户的 ID"""
    try:
        user = supabase.auth.get_user()
        if user and user.user:
            return user.user.id
        else:
            print("❌ 错误：未登录，请先注册/登录账号")
            print("\n请访问 http://localhost:3000 注册一个账号，然后重新运行此脚本")
            sys.exit(1)
    except Exception as e:
        print(f"❌ 获取用户信息失败: {e}")
        print("\n请确保：")
        print("1. Supabase 项目已正确配置")
        print("2. 已在应用中注册/登录账号")
        sys.exit(1)

def upload_file(file_path: Path, bucket: str, storage_path: str) -> str:
    """上传文件到 Supabase Storage"""
    try:
        with open(file_path, 'rb') as f:
            file_data = f.read()
        
        # 获取文件类型
        mime_type, _ = mimetypes.guess_type(str(file_path))
        
        # 上传文件
        response = supabase.storage.from_(bucket).upload(
            path=storage_path,
            file=file_data,
            file_options={"content-type": mime_type or "application/octet-stream"}
        )
        
        # 获取公开 URL
        public_url = supabase.storage.from_(bucket).get_public_url(storage_path)
        return public_url
    
    except Exception as e:
        raise Exception(f"上传失败: {e}")

def create_audio_record(title: str, audio_url: str, subtitle_url: str, user_id: str):
    """在数据库中创建音频记录"""
    try:
        data = {
            "title": title,
            "category": CATEGORY,
            "audio_url": audio_url,
            "subtitle_url": subtitle_url,
            "duration": 0,
            "status": None,
            "user_id": user_id
        }
        
        response = supabase.table("audios").insert(data).execute()
        return response.data[0] if response.data else None
    
    except Exception as e:
        raise Exception(f"创建数据库记录失败: {e}")

def main():
    print("=" * 60)
    print("🚀 批量上传音频到 Supabase")
    print("=" * 60)
    print()
    
    # 检查目录
    if not PROCESSED_DIR.exists():
        print(f"❌ 错误：目录不存在: {PROCESSED_DIR}")
        sys.exit(1)
    
    # 获取所有音频文件
    audio_files = sorted(PROCESSED_DIR.glob("*.mp3"))
    
    if not audio_files:
        print(f"❌ 错误：在 {PROCESSED_DIR} 中没有找到 mp3 文件")
        sys.exit(1)
    
    print(f"📁 找到 {len(audio_files)} 个音频文件")
    print()
    
    # 获取用户 ID
    print("🔐 获取用户信息...")
    user_id = get_user_id()
    print(f"✅ 用户 ID: {user_id[:8]}...")
    print()
    
    # 上传文件
    success_count = 0
    fail_count = 0
    
    for i, audio_file in enumerate(audio_files, 1):
        title = audio_file.stem  # 文件名（不含扩展名）
        subtitle_file = audio_file.with_suffix('.srt')
        
        print(f"[{i}/{len(audio_files)}] 处理: {title}")
        
        # 检查字幕文件是否存在
        if not subtitle_file.exists():
            print(f"  ⚠️  跳过：找不到对应的字幕文件")
            fail_count += 1
            continue
        
        try:
            # 上传音频
            print(f"  → 上传音频...")
            audio_storage_path = f"{CATEGORY}/{audio_file.name}"
            audio_url = upload_file(audio_file, AUDIO_BUCKET, audio_storage_path)
            
            # 上传字幕
            print(f"  → 上传字幕...")
            subtitle_storage_path = f"{CATEGORY}/{subtitle_file.name}"
            subtitle_url = upload_file(subtitle_file, SUBTITLE_BUCKET, subtitle_storage_path)
            
            # 创建数据库记录
            print(f"  → 创建数据库记录...")
            record = create_audio_record(title, audio_url, subtitle_url, user_id)
            
            print(f"  ✅ 成功！")
            success_count += 1
            
        except Exception as e:
            print(f"  ❌ 失败: {e}")
            fail_count += 1
        
        print()
    
    # 总结
    print("=" * 60)
    print("📊 上传完成！")
    print("=" * 60)
    print(f"✅ 成功: {success_count} 个")
    print(f"❌ 失败: {fail_count} 个")
    print()
    
    if success_count > 0:
        print("🎉 现在可以访问 http://localhost:3000 查看音频列表了！")
        print()
        print("💡 提示：")
        print("  1. 刷新浏览器页面")
        print("  2. 点击「每日跟读」标签")
        print("  3. 应该能看到所有上传的音频")

if __name__ == "__main__":
    main()
