# 📊 数据库表结构说明

## ✅ 字段验证报告

已验证前端 TypeScript 类型定义与数据库表结构**完全匹配**，无多余字段。

---

## 📋 表 1: audios (音频数据表)

### 前端类型定义 (TypeScript)

```typescript
export interface Audio {
  id: string;                                    // UUID
  title: string;                                 // 音频标题
  category: string;                              // 分类
  audio_url: string;                             // 音频 URL
  subtitle_url: string;                          // 字幕 URL
  duration: number;                              // 时长(秒)
  status: 'raw' | 'familiar' | 'mastered' | null; // 学习状态
  user_id: string;                               // 用户 ID
  created_at: string;                            // 创建时间
}
```

### 数据库表结构 (PostgreSQL)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| `id` | UUID | PRIMARY KEY | 音频唯一标识 |
| `title` | TEXT | NOT NULL | 音频标题 |
| `category` | TEXT | NOT NULL | 分类(每日跟读/造句公式/口语听力/美式口音/访谈节目/雅思) |
| `audio_url` | TEXT | NOT NULL | 音频文件 URL (Supabase Storage) |
| `subtitle_url` | TEXT | NOT NULL | 字幕文件 URL (Supabase Storage) |
| `duration` | INTEGER | NOT NULL, DEFAULT 0 | 音频时长(秒) |
| `status` | TEXT | CHECK (raw/familiar/mastered), NULL | 学习状态 |
| `user_id` | UUID | NOT NULL, FK → auth.users | 用户 ID |
| `created_at` | TIMESTAMP | DEFAULT NOW() | 创建时间 |

**✅ 验证结果**: 9 个字段，完全匹配，无多余字段

---

## 📋 表 2: playback_progress (播放进度表)

### 前端类型定义 (TypeScript)

```typescript
export interface PlaybackProgress {
  id: string;          // UUID
  audio_id: string;    // 音频 ID
  user_id: string;     // 用户 ID
  position: number;    // 播放位置(秒)
  updated_at: string;  // 更新时间
}
```

### 数据库表结构 (PostgreSQL)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| `id` | UUID | PRIMARY KEY | 进度记录唯一标识 |
| `audio_id` | UUID | NOT NULL, FK → audios | 关联的音频 ID |
| `user_id` | UUID | NOT NULL, FK → auth.users | 用户 ID |
| `position` | FLOAT | NOT NULL, DEFAULT 0 | 播放位置(秒) |
| `updated_at` | TIMESTAMP | DEFAULT NOW() | 更新时间 |

**约束**: `UNIQUE(audio_id, user_id)` - 每个用户每个音频只有一条进度记录

**✅ 验证结果**: 5 个字段，完全匹配，无多余字段

---

## 📋 表 3: vocabulary (生词表)

### 前端类型定义 (TypeScript)

```typescript
export interface Vocabulary {
  id: string;              // UUID
  word: string;            // 单词
  audio_id: string | null; // 音频 ID (可选)
  user_id: string;         // 用户 ID
  added_at: string;        // 添加时间
}
```

### 数据库表结构 (PostgreSQL)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| `id` | UUID | PRIMARY KEY | 生词唯一标识 |
| `word` | TEXT | NOT NULL | 单词内容 |
| `audio_id` | UUID | NULL, FK → audios | 关联的音频 ID (可选) |
| `user_id` | UUID | NOT NULL, FK → auth.users | 用户 ID |
| `added_at` | TIMESTAMP | DEFAULT NOW() | 添加时间 |

**✅ 验证结果**: 5 个字段，完全匹配，无多余字段

---

## 🔐 安全特性

### Row Level Security (RLS)

所有表都启用了 RLS，确保：
- ✅ 用户只能访问自己的数据
- ✅ 无法查看或修改其他用户的数据
- ✅ 自动通过 `auth.uid()` 验证用户身份

### 数据级联删除

- 删除用户 → 自动删除该用户的所有音频、进度、生词
- 删除音频 → 自动删除该音频的播放进度
- 删除音频 → 生词的 `audio_id` 设置为 NULL (保留生词)

---

## 📈 索引优化

为以下字段创建了索引，提升查询性能：

| 表名 | 索引字段 | 用途 |
|------|----------|------|
| `audios` | `user_id` | 快速查询用户的所有音频 |
| `audios` | `category` | 快速按分类筛选音频 |
| `playback_progress` | `user_id` | 快速查询用户的播放进度 |
| `vocabulary` | `user_id` | 快速查询用户的生词列表 |
| `vocabulary` | `word` | 快速搜索特定单词 |

---

## 🎯 总结

### ✅ 验证通过

- **3 张表**，共 **19 个字段**
- 所有字段与前端 TypeScript 类型定义**完全匹配**
- **无多余字段**，**无缺失字段**
- 数据类型映射正确（TypeScript ↔ PostgreSQL）

### 📝 类型映射

| TypeScript | PostgreSQL | 说明 |
|------------|------------|------|
| `string` | `TEXT` / `UUID` | 文本或 UUID |
| `number` | `INTEGER` / `FLOAT` | 整数或浮点数 |
| `'raw' \| 'familiar' \| 'mastered' \| null` | `TEXT CHECK (...)` | 枚举类型 |
| `string` (timestamp) | `TIMESTAMP WITH TIME ZONE` | 时间戳 |

---

## 🚀 使用方法

1. 访问 Supabase 控制台
2. 进入 **SQL Editor**
3. 复制 `scripts/supabase-migration-verified.sql` 的内容
4. 点击 **Run** 执行
5. 查看成功提示

---

## 📦 下一步

1. ✅ 执行 SQL 创建表
2. ⏳ 创建 Storage buckets (`audios`, `subtitles`)
3. ⏳ 启用 Email Authentication
4. ⏳ 上传音频文件
5. ⏳ 配置 `.env` 文件
6. ⏳ 部署到 Vercel

---

**版本**: 2.0  
**验证日期**: 2026-03-15  
**状态**: ✅ 已验证，可以安全使用
