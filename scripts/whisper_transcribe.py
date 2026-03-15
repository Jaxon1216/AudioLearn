#!/usr/bin/env python3
"""
Whisper 字幕生成脚本（使用 faster-whisper）
"""

import sys
import os
from faster_whisper import WhisperModel

def transcribe_audio(audio_path, output_dir, model_size="base"):
    """
    使用 faster-whisper 转录音频并生成 SRT 字幕
    
    Args:
        audio_path: 音频文件路径
        output_dir: 输出目录
        model_size: 模型大小 (tiny, base, small, medium, large)
    """
    print(f"加载 Whisper {model_size} 模型...")
    model = WhisperModel(model_size, device="cpu", compute_type="int8")
    
    print(f"转录音频: {audio_path}")
    segments, info = model.transcribe(
        audio_path,
        language=None,  # 自动检测
        beam_size=5,
        vad_filter=True  # 使用语音活动检测
    )
    
    print(f"检测到的语言: {info.language} (概率: {info.language_probability:.2f})")
    
    # 生成 SRT 文件
    base_name = os.path.splitext(os.path.basename(audio_path))[0]
    srt_path = os.path.join(output_dir, f"{base_name}.srt")
    
    with open(srt_path, "w", encoding="utf-8") as f:
        for i, segment in enumerate(segments, start=1):
            # SRT 格式
            f.write(f"{i}\n")
            f.write(f"{format_timestamp(segment.start)} --> {format_timestamp(segment.end)}\n")
            f.write(f"{segment.text.strip()}\n\n")
    
    print(f"✓ 字幕已保存: {srt_path}")
    return srt_path

def format_timestamp(seconds):
    """将秒转换为 SRT 时间格式"""
    hours = int(seconds // 3600)
    minutes = int((seconds % 3600) // 60)
    secs = int(seconds % 60)
    millis = int((seconds % 1) * 1000)
    return f"{hours:02d}:{minutes:02d}:{secs:02d},{millis:03d}"

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("用法: python whisper_transcribe.py <音频文件> <输出目录> [模型大小]")
        print("示例: python whisper_transcribe.py audio.mp3 ./output base")
        sys.exit(1)
    
    audio_file = sys.argv[1]
    output_dir = sys.argv[2]
    model_size = sys.argv[3] if len(sys.argv) > 3 else "base"
    
    if not os.path.exists(audio_file):
        print(f"错误: 音频文件不存在: {audio_file}")
        sys.exit(1)
    
    os.makedirs(output_dir, exist_ok=True)
    
    try:
        transcribe_audio(audio_file, output_dir, model_size)
    except Exception as e:
        print(f"错误: {e}")
        sys.exit(1)
