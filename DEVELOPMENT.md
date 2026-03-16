# 开发指南

## 项目结构

```
EastonJiang/
├── EastonJiang/                    # React 前端应用
│   ├── src/
│   │   ├── components/      # React 组件
│   │   ├── contexts/        # Context (Auth)
│   │   ├── lib/             # Supabase 客户端
│   │   └── types/           # TypeScript 类型定义
│   ├── public/
│   │   ├── audios/          # 本地音频文件 (gitignore)
│   │   └── subtitles/       # 本地字幕文件 (gitignore)
│   └── .env                 # Supabase 配置 (gitignore)
├── resource/                # 原始资源文件 (gitignore)
│   ├── 造句公式/            # 原始视频
│   ├── 美式口音/
│   ├── 口语听力/
│   ├── sentence-formulas/   # 处理后的 MP3 + SRT
│   ├── american-accent/
│   └── oral-listening/
└── scripts/                 # 工具脚本
    ├── process_new_videos.sh          # 批量处理视频
    ├── generate_mock_data.py          # 生成 mock-data.json
    ├── generate_sql_inserts_new.py    # 生成 SQL INSERT
    └── supabase-migration-verified.sql # 数据库迁移

```

## 开发环境

### 必需工具
- **Node.js**: 用于运行 React 前端
- **Python 3.11**: 用于视频处理脚本
- **ffmpeg**: 音频提取
- **faster-whisper**: 字幕生成

### 安装依赖
```bash
# 前端依赖
cd EastonJiang
npm install

# Python 依赖
pip install faster-whisper
```

## 本地开发

### 启动前端
```bash
cd EastonJiang
npm start
# 访问 http://localhost:3000
```

### 本地模式 vs Supabase 模式
- **本地模式**: 使用 `public/audios/mock-data.json`，无需登录
- **Supabase 模式**: 连接真实数据库，需要登录

切换方式：修改 `EastonJiang/src/lib/supabase.ts` 中的 `isLocalMode`

## 视频处理流程

### 1. 添加新视频
将视频文件放到 `resource/{分类名}/` 目录

### 2. 批量处理
```bash
cd scripts
./process_new_videos.sh
```

这会：
- 提取音频（MP3 格式，128kbps 或 96kbps）
- 生成字幕（SRT 格式，使用 Whisper tiny 模型）
- 输出到 `resource/{英文分类名}/`

### 3. 重命名为英文序号
```bash
cd scripts
./rename_to_english.sh
```

将文件名改为 `1.mp3`, `2.mp3`, `3.mp3`...

### 4. 生成前端数据
```bash
cd scripts
python3 generate_mock_data.py
```

更新 `EastonJiang/public/audios/mock-data.json`

### 5. 生成 SQL 语句
```bash
cd scripts
python3 generate_sql_inserts_new.py
```

生成 `insert_new_categories.sql` 用于 Supabase

### 6. 更新数据版本
修改 `EastonJiang/src/components/AudioList/AudioList.tsx`:
```typescript
const CURRENT_DATA_VERSION = 'X'; // 增加版本号
```

## Supabase 部署

### 1. 创建 Storage 文件夹
在 `audios` 和 `subtitles` buckets 中创建分类文件夹

### 2. 上传文件
从 `EastonJiang/public/audios/{category}/` 和 `EastonJiang/public/subtitles/{category}/` 上传

### 3. 执行 SQL
在 Supabase SQL Editor 中执行生成的 SQL 文件

### 4. 测试
刷新前端，切换到 Supabase 模式测试

## 常见任务

### 添加新分类
1. 更新 `EastonJiang/src/types/index.ts` 中的 `Category` 类型
2. 更新 `AudioList.tsx` 中的 `categories` 数组
3. 按照视频处理流程添加内容

### 压缩音频（节省空间）
```bash
cd scripts
./compress_audio.sh
```

### 清理重复数据
```bash
# 在 Supabase SQL Editor 执行
DELETE FROM audios WHERE category = '分类名' AND user_id = 'your-user-id';
```

## 技术栈

- **前端**: React + TypeScript + Ant Design
- **后端**: Supabase (PostgreSQL + Storage + Auth)
- **音频处理**: ffmpeg
- **字幕生成**: faster-whisper (OpenAI Whisper)

## 注意事项

1. **文件命名**: 使用英文文件夹名和数字文件名（兼容 Supabase）
2. **存储空间**: 免费 1GB，注意监控使用量
3. **音频质量**: 教学内容 128kbps，发音练习 96kbps
4. **数据版本**: 每次更新 mock-data.json 需增加版本号
5. **Git 忽略**: 音频/视频文件不提交到 Git（使用 Supabase Storage）

## 故障排除

### 前端不显示新数据
- 清除 localStorage: 访问 `/clear-cache.html`
- 增加 `CURRENT_DATA_VERSION`

### Supabase 上传失败
- 检查文件名是否为英文
- 检查 bucket 是否设置为 Public

### 字幕不显示
- 确认 subtitles bucket 为 Public
- 检查文件路径是否匹配数据库记录

### SQL 执行失败
- 检查 `status` 字段值（只能是 'raw'/'familiar'/'mastered'/NULL）
- 检查 `user_id` 是否正确
