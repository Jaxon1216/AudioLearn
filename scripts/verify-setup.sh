#!/bin/bash

# Alan 项目 - 环境验证脚本
# 检查所有必需的工具是否正确安装

set -e

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Alan 项目环境验证 ===${NC}"
echo ""

# 检查计数器
PASS=0
FAIL=0

# 1. 检查 Cursor
echo -e "${YELLOW}[1/5] 检查 Cursor 命令...${NC}"
if command -v cursor &> /dev/null; then
    VERSION=$(cursor --version 2>&1 | head -n 1)
    echo -e "${GREEN}  ✓ Cursor 已安装: $VERSION${NC}"
    PASS=$((PASS + 1))
else
    echo -e "${RED}  ✗ Cursor 命令未找到${NC}"
    echo -e "${YELLOW}    解决方案: 运行 'source ~/.zshrc'${NC}"
    FAIL=$((FAIL + 1))
fi
echo ""

# 2. 检查 ffmpeg
echo -e "${YELLOW}[2/5] 检查 ffmpeg...${NC}"
if command -v ffmpeg &> /dev/null; then
    VERSION=$(ffmpeg -version 2>&1 | head -n 1 | awk '{print $3}')
    echo -e "${GREEN}  ✓ ffmpeg 已安装: $VERSION${NC}"
    PASS=$((PASS + 1))
else
    echo -e "${RED}  ✗ ffmpeg 未安装${NC}"
    echo -e "${YELLOW}    解决方案: 运行 'brew install ffmpeg'${NC}"
    FAIL=$((FAIL + 1))
fi
echo ""

# 3. 检查 Python
echo -e "${YELLOW}[3/5] 检查 Python 3.11...${NC}"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)" 2>/dev/null || true

if command -v python &> /dev/null; then
    VERSION=$(python --version 2>&1)
    if [[ $VERSION == *"3.11"* ]]; then
        echo -e "${GREEN}  ✓ Python 已安装: $VERSION${NC}"
        PASS=$((PASS + 1))
    else
        echo -e "${YELLOW}  ⚠ Python 版本不是 3.11: $VERSION${NC}"
        echo -e "${YELLOW}    建议: 运行 'pyenv global 3.11.15'${NC}"
        FAIL=$((FAIL + 1))
    fi
else
    echo -e "${RED}  ✗ Python 未找到${NC}"
    echo -e "${YELLOW}    解决方案: 安装 pyenv 和 Python 3.11${NC}"
    FAIL=$((FAIL + 1))
fi
echo ""

# 4. 检查 faster-whisper
echo -e "${YELLOW}[4/5] 检查 faster-whisper...${NC}"
if python -c "from faster_whisper import WhisperModel" 2>/dev/null; then
    VERSION=$(python -c "import faster_whisper; print(faster_whisper.__version__)" 2>/dev/null || echo "已安装")
    echo -e "${GREEN}  ✓ faster-whisper 已安装: $VERSION${NC}"
    PASS=$((PASS + 1))
else
    echo -e "${RED}  ✗ faster-whisper 未安装${NC}"
    echo -e "${YELLOW}    解决方案: 运行 'pip install faster-whisper'${NC}"
    FAIL=$((FAIL + 1))
fi
echo ""

# 5. 检查 Node.js 和 npm
echo -e "${YELLOW}[5/5] 检查 Node.js 和 npm...${NC}"
if command -v node &> /dev/null && command -v npm &> /dev/null; then
    NODE_VERSION=$(node --version)
    NPM_VERSION=$(npm --version)
    echo -e "${GREEN}  ✓ Node.js 已安装: $NODE_VERSION${NC}"
    echo -e "${GREEN}  ✓ npm 已安装: $NPM_VERSION${NC}"
    PASS=$((PASS + 1))
else
    echo -e "${RED}  ✗ Node.js 或 npm 未安装${NC}"
    echo -e "${YELLOW}    解决方案: 安装 Node.js${NC}"
    FAIL=$((FAIL + 1))
fi
echo ""

# 总结
echo -e "${BLUE}=== 验证结果 ===${NC}"
echo -e "${GREEN}通过: $PASS${NC}"
echo -e "${RED}失败: $FAIL${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}🎉 所有工具已正确安装！${NC}"
    echo ""
    echo -e "${BLUE}下一步操作：${NC}"
    echo "1. 使用 'cursor .' 打开项目"
    echo "2. 运行 'cd alan && npm install && npm start' 启动应用"
    echo "3. 将视频放到 raw_videos/ 并运行 'cd scripts && ./process-videos.sh'"
    exit 0
else
    echo -e "${YELLOW}⚠ 有 $FAIL 个工具需要安装或配置${NC}"
    echo ""
    echo -e "${BLUE}建议操作：${NC}"
    echo "1. 运行 'source ~/.zshrc' 重新加载配置"
    echo "2. 按照上面的提示安装缺失的工具"
    echo "3. 再次运行此脚本验证"
    exit 1
fi
