-- ============================================
-- Alan 音频学习应用 - Supabase 数据库迁移脚本
-- ============================================
-- 版本: 2.0 (已验证字段与前端类型定义完全匹配)
-- 在 Supabase SQL Editor 中执行此脚本
-- ============================================

-- 启用 UUID 扩展
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- 1. 创建 audios 表
-- ============================================
-- 对应前端类型: Audio
-- 字段说明:
--   - id: 音频唯一标识 (UUID)
--   - title: 音频标题
--   - category: 分类 (每日跟读/造句公式/口语听力/美式口音/访谈节目/雅思)
--   - audio_url: 音频文件 URL (Supabase Storage)
--   - subtitle_url: 字幕文件 URL (Supabase Storage)
--   - duration: 音频时长(秒)
--   - status: 学习状态 (raw/familiar/mastered/null)
--   - user_id: 用户 ID (关联 auth.users)
--   - created_at: 创建时间
-- ============================================
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

-- ============================================
-- 2. 创建 playback_progress 表
-- ============================================
-- 对应前端类型: PlaybackProgress
-- 字段说明:
--   - id: 进度记录唯一标识
--   - audio_id: 关联的音频 ID
--   - user_id: 用户 ID
--   - position: 播放位置(秒)
--   - updated_at: 更新时间
-- 约束: 每个用户每个音频只有一条进度记录
-- ============================================
CREATE TABLE IF NOT EXISTS public.playback_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    audio_id UUID NOT NULL REFERENCES public.audios(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    position FLOAT NOT NULL DEFAULT 0,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(audio_id, user_id)
);

-- ============================================
-- 3. 创建 vocabulary 表
-- ============================================
-- 对应前端类型: Vocabulary
-- 字段说明:
--   - id: 生词唯一标识
--   - word: 单词内容
--   - audio_id: 关联的音频 ID (可选)
--   - user_id: 用户 ID
--   - added_at: 添加时间
-- ============================================
CREATE TABLE IF NOT EXISTS public.vocabulary (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    word TEXT NOT NULL,
    audio_id UUID REFERENCES public.audios(id) ON DELETE SET NULL,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    added_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- 4. 创建索引 (优化查询性能)
-- ============================================
CREATE INDEX IF NOT EXISTS idx_audios_user_id ON public.audios(user_id);
CREATE INDEX IF NOT EXISTS idx_audios_category ON public.audios(category);
CREATE INDEX IF NOT EXISTS idx_playback_progress_user_id ON public.playback_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_vocabulary_user_id ON public.vocabulary(user_id);
CREATE INDEX IF NOT EXISTS idx_vocabulary_word ON public.vocabulary(word);

-- ============================================
-- 5. 启用 Row Level Security (RLS)
-- ============================================
ALTER TABLE public.audios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.playback_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vocabulary ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 6. RLS 策略 - audios 表
-- ============================================
-- 用户只能访问自己的音频数据
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

-- ============================================
-- 7. RLS 策略 - playback_progress 表
-- ============================================
-- 用户只能访问自己的播放进度
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

-- ============================================
-- 8. RLS 策略 - vocabulary 表
-- ============================================
-- 用户只能访问自己的生词列表
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

-- ============================================
-- 9. 创建触发器函数
-- ============================================
-- 自动更新 playback_progress 的 updated_at 字段
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- 10. 创建触发器
-- ============================================
CREATE TRIGGER update_playback_progress_updated_at
    BEFORE UPDATE ON public.playback_progress
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 完成提示
-- ============================================
DO $$
BEGIN
    RAISE NOTICE '✅ 数据库迁移完成！';
    RAISE NOTICE '';
    RAISE NOTICE '📊 已创建的表:';
    RAISE NOTICE '  1. audios (音频数据)';
    RAISE NOTICE '  2. playback_progress (播放进度)';
    RAISE NOTICE '  3. vocabulary (生词列表)';
    RAISE NOTICE '';
    RAISE NOTICE '🔐 已启用 Row Level Security (RLS)';
    RAISE NOTICE '  - 用户只能访问自己的数据';
    RAISE NOTICE '';
    RAISE NOTICE '📝 下一步操作:';
    RAISE NOTICE '  1. 在 Supabase Storage 中创建 2 个 bucket:';
    RAISE NOTICE '     - audios (设置为 public)';
    RAISE NOTICE '     - subtitles (设置为 public)';
    RAISE NOTICE '  2. 在 Authentication > Providers 中启用 Email provider';
    RAISE NOTICE '  3. 复制 Project URL 和 anon key 到 .env 文件';
    RAISE NOTICE '  4. 上传音频和字幕文件到 Storage';
    RAISE NOTICE '';
    RAISE NOTICE '🎉 准备就绪！';
END $$;
