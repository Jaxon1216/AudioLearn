export interface SubtitleLine {
  index: number;
  start: number;
  end: number;
  text: string;
}

export interface Audio {
  id: string;
  title: string;
  category: string;
  audio_url: string;
  subtitle_url: string;
  duration: number;
  status: 'raw' | 'familiar' | 'mastered' | null;
  user_id: string;
  created_at: string;
}

export interface PlaybackProgress {
  id: string;
  audio_id: string;
  user_id: string;
  position: number;
  updated_at: string;
}

export interface Vocabulary {
  id: string;
  word: string;
  audio_id: string | null;
  user_id: string;
  added_at: string;
}

export type Category = '每日跟读' | '造句公式' | '口语听力' | '美式口音' | '访谈节目' | '雅思';

export interface User {
  id: string;
  email: string;
}
