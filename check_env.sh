#!/bin/bash

# 定义颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 初始化缺失列表
MISSING_TOOLS=()

echo "========================================"
echo "      Ghost 部署环境依赖检测"
echo "========================================"

# 函数：检测命令是否存在
check_cmd() {
    local cmd_name=$1
    local display_name=$2
    
    echo -n "正在检测 $display_name ... "
    if command -v "$cmd_name" &> /dev/null; then
        echo -e "${GREEN}已安装${NC}"
    else
        echo -e "${RED}未找到${NC}"
        MISSING_TOOLS+=("$display_name ($cmd_name)")
    fi
}

# 函数：专门检测 Docker Compose (插件版)
check_docker_compose() {
    echo -n "正在检测 Docker Compose ... "
    if docker compose version &> /dev/null; then
        echo -e "${GREEN}已安装${NC}"
    else
        echo -e "${RED}未找到${NC}"
        MISSING_TOOLS+=("Docker Compose (docker compose 插件)")
    fi
}

# --- 开始检测 ---

# 1. 基础工具
check_cmd "make" "Make 构建工具"
check_cmd "curl" "Curl 网络工具"
check_cmd "grep" "Grep 文本工具"

# 2. Docker 核心
check_cmd "docker" "Docker 引擎"

# 3. Docker Compose (依赖 Docker)
if command -v docker &> /dev/null; then
    check_docker_compose
else
    echo -e "${YELLOW}跳过 Docker Compose 检测 (因为 Docker 未安装)${NC}"
    MISSING_TOOLS+=("Docker Compose")
fi

echo "========================================"
echo "            检测结果汇总"
echo "========================================"

# --- 输出结果 ---

if [ ${#MISSING_TOOLS[@]} -eq 0 ]; then
    echo -e "${GREEN}✅ 环境均设置完毕！1${NC}"
    exit 0
else
    echo -e "${RED}❌ 检测到缺少以下环境，请先安装：${NC}"
    for tool in "${MISSING_TOOLS[@]}"; do
        echo "  - $tool"
    done
    
    echo ""
    echo -e "${YELLOW}建议安装命令 (Ubuntu/Debian):${NC}"
    echo "  sudo apt-get update"
    echo "  sudo apt-get install -y make curl docker.io docker-compose-plugin"
    exit 1
fi