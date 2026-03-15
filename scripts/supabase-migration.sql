-- Alan 音频学习应用 - Supabase 数据库迁移脚本
-- 在 Supabase SQL Editor 中执行此脚本

-- 启用 UUID 扩展
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 创建 audios 表
CREATE TABLE IF NOT EXISTS public.audios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    category TEXT NOT NULL,
    audio_url TEXT NOT NULL,
    subtitle_url TEXT NOT NULL,
    duration INTEGER NOT NULL DEFAULT 0,
    status TEXT CHECK (status IN ('raw', 'familiar', 'mastered')) DEFAULT NULL,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建 playback_progress 表
CREATE TABLE IF NOT EXISTS public.playback_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    audio_id UUID NOT NULL REFERENCES public.audios(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    position FLOAT NOT NULL DEFAULT 0,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(audio_id, user_id)
);

-- 创建 vocabulary 表
CREATE TABLE IF NOT EXISTS public.vocabulary (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    word TEXT NOT NULL,
    audio_id UUID REFERENCES public.audios(id) ON DELETE SET NULL,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    added_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_audios_user_id ON public.audios(user_id);
CREATE INDEX IF NOT EXISTS idx_audios_category ON public.audios(category);
CREATE INDEX IF NOT EXISTS idx_playback_progress_user_id ON public.playback_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_vocabulary_user_id ON public.vocabulary(user_id);
CREATE INDEX IF NOT EXISTS idx_vocabulary_word ON public.vocabulary(word);

-- 启用 Row Level Security (RLS)
ALTER TABLE public.audios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.playback_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vocabulary ENABLE ROW LEVEL SECURITY;

-- RLS 策略 - audios 表
CREATE POLICY "Users can view their own audios"
    ON public.audios FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own audios"
    ON public.audios FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own audios"
    ON public.audios FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own audios"
    ON public.audios FOR DELETE
    USING (auth.uid() = user_id);

-- RLS 策略 - playback_progress 表
CREATE POLICY "Users can view their own progress"
    ON public.playback_progress FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own progress"
    ON public.playback_progress FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own progress"
    ON public.playback_progress FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own progress"
    ON public.playback_progress FOR DELETE
    USING (auth.uid() = user_id);

-- RLS 策略 - vocabulary 表
CREATE POLICY "Users can view their own vocabulary"
    ON public.vocabulary FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own vocabulary"
    ON public.vocabulary FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own vocabulary"
    ON public.vocabulary FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own vocabulary"
    ON public.vocabulary FOR DELETE
    USING (auth.uid() = user_id);

-- 创建函数：自动更新 playback_progress 的 updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 创建触发器
CREATE TRIGGER update_playback_progress_updated_at
    BEFORE UPDATE ON public.playback_progress
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 完成提示
DO $$
BEGIN
    RAISE NOTICE '✓ 数据库迁移完成！';
    RAISE NOTICE '  ';
    RAISE NOTICE '下一步：';
    RAISE NOTICE '1. 在 Supabase Storage 中创建 bucket：';
    RAISE NOTICE '   - audios (public)';
    RAISE NOTICE '   - subtitles (public)';
    RAISE NOTICE '2. 在 Authentication > Settings 中启用 Email provider';
    RAISE NOTICE '3. 复制 Project URL 和 anon key 到 .env 文件';
END $$;
