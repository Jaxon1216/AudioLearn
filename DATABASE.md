# 数据库设计文档

## Supabase 配置

- **Project URL**: `https://aouxwiisskawtylooxam.supabase.co`
- **配置文件**: `EastonJiang/.env`

## 数据库表结构

### 1. audios 表
存储音频学习资源的元数据

| 字段 | 类型 | 说明 | 约束 |
|------|------|------|------|
| id | UUID | 主键 | PRIMARY KEY |
| user_id | UUID | 用户ID | REFERENCES auth.users |
| title | TEXT | 音频标题 | NOT NULL |
| category | TEXT | 分类 | NOT NULL |
| audio_url | TEXT | 音频URL | NOT NULL |
| subtitle_url | TEXT | 字幕URL | NOT NULL |
| duration | INTEGER | 时长(秒) | DEFAULT 0 |
| status | TEXT | 学习状态 | CHECK IN ('raw', 'familiar', 'mastered') |
| created_at | TIMESTAMPTZ | 创建时间 | DEFAULT NOW() |

**分类**: 每日跟读、造句公式、口语听力、美式口音、访谈节目、雅思

**学习状态**:
- `raw`: 生疏
- `familiar`: 熟悉
- `mastered`: 掌握
- `NULL`: 未标记

### 2. playback_progress 表
存储用户的播放进度

| 字段 | 类型 | 说明 | 约束 |
|------|------|------|------|
| id | UUID | 主键 | PRIMARY KEY |
| audio_id | UUID | 音频ID | REFERENCES audios |
| user_id | UUID | 用户ID | REFERENCES auth.users |
| position | FLOAT | 播放位置(秒) | DEFAULT 0 |
| updated_at | TIMESTAMPTZ | 更新时间 | DEFAULT NOW() |

**唯一约束**: (audio_id, user_id) - 每个用户每个音频只有一条进度记录

### 3. vocabulary 表
存储用户的生词本

| 字段 | 类型 | 说明 | 约束 |
|------|------|------|------|
| id | UUID | 主键 | PRIMARY KEY |
| user_id | UUID | 用户ID | REFERENCES auth.users |
| word | TEXT | 单词 | NOT NULL |
| translation | TEXT | 翻译 | |
| audio_id | UUID | 关联音频 | REFERENCES audios |
| created_at | TIMESTAMPTZ | 创建时间 | DEFAULT NOW() |

## Storage 结构

### audios bucket (Public)
```
audios/
├── daily-reading/        # 每日跟读 (23 个)
├── sentence-formulas/    # 造句公式 (25 个)
├── american-accent/      # 美式口音 (11 个)
└── oral-listening/       # 口语听力 (4 个)
```

### subtitles bucket (Public)
```
subtitles/
├── daily-reading/        # 每日跟读字幕
├── sentence-formulas/    # 造句公式字幕
├── american-accent/      # 美式口音字幕
└── oral-listening/       # 口语听力字幕
```

## RLS (Row Level Security)

所有表都启用了 RLS，用户只能访问自己的数据：

```sql
-- audios 表
CREATE POLICY "Users can view own audios" ON audios FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own audios" ON audios FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own audios" ON audios FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own audios" ON audios FOR DELETE USING (auth.uid() = user_id);

-- playback_progress 表
CREATE POLICY "Users can view own progress" ON playback_progress FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own progress" ON playback_progress FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own progress" ON playback_progress FOR UPDATE USING (auth.uid() = user_id);

-- vocabulary 表
CREATE POLICY "Users can view own vocabulary" ON vocabulary FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own vocabulary" ON vocabulary FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own vocabulary" ON vocabulary FOR DELETE USING (auth.uid() = user_id);
```

## 初始化脚本

完整的数据库迁移脚本：`scripts/supabase-migration-verified.sql`

## 本地开发模式

本地模式使用 `EastonJiang/public/audios/mock-data.json` 作为数据源，通过 localStorage 缓存。

**数据版本控制**:
- `CURRENT_DATA_VERSION` 在 `AudioList.tsx` 中定义
- 版本变更时自动清除缓存并重新加载

## 存储空间

- **免费额度**: 1GB
- **当前使用**: 约 645MB
  - 每日跟读: 200MB
  - 造句公式: 279MB
  - 美式口音: 68MB
  - 口语听力: 98MB
- **剩余**: 约 355MB

## 音频质量

- **每日跟读**: 128kbps
- **造句公式**: 128kbps
- **美式口音**: 96kbps
- **口语听力**: 128kbps
