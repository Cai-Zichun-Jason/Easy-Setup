#!/bin/bash
# ============================================
# Mihomo 代理环境配置安装脚本
# ============================================
# 使用方法：
#   执行此脚本将自动配置 ~/.bashrc
#   bash setProxy.sh
# ============================================

BASHRC="$HOME/.bashrc"

echo "正在配置 Mihomo 代理函数到 ~/.bashrc..."

# 检查是否已经配置过
if grep -q "# Mihomo Proxy Functions" "$BASHRC" 2>/dev/null; then
    echo "⚠️  检测到 ~/.bashrc 中已存在 Mihomo 代理配置"
    read -p "是否覆盖更新？(y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ 取消配置"
        exit 0
    fi
    # 删除旧配置
    sed -i '/# Mihomo Proxy Functions - Start/,/# Mihomo Proxy Functions - End/d' "$BASHRC"
    echo "✅ 已删除旧配置"
fi

# 将代理函数写入 ~/.bashrc
cat >> "$BASHRC" << 'EOF'

# Mihomo Proxy Functions - Start
# ============================================
# Mihomo 代理配置
# ============================================
PROXY_CONFIG_DIR="$HOME/mihomo"
PROXY_CONFIG_FILE="$PROXY_CONFIG_DIR/config.yaml"
PROXY_LOG_FILE="$PROXY_CONFIG_DIR/mihomo.log"
PROXY_HTTP="http://127.0.0.1:7890"      # HTTP 代理端口
PROXY_SOCKS="socks5://127.0.0.1:7890"   # SOCKS5 代理端口

# 启用终端代理
proxy_on() {
    export ALL_PROXY="$PROXY_SOCKS"
    export http_proxy="$PROXY_HTTP"
    export https_proxy="$PROXY_HTTP"
    export ftp_proxy="$PROXY_HTTP"
    echo "🌐 终端代理已启用:"
    echo "  - HTTP/HTTPS: $PROXY_HTTP"
    echo "  - SOCKS5: $ALL_PROXY"
}

# 禁用终端代理
proxy_off() {
    unset ALL_PROXY
    unset http_proxy
    unset https_proxy
    unset ftp_proxy
    echo "🚫 终端代理已禁用"
}

# 查看当前代理状态
proxy_status() {
    echo "代理状态检查:"
    if [ -n "$http_proxy" ]; then
        echo "  ✅ HTTP代理: $http_proxy"
    else
        echo "  ❌ HTTP代理: 未设置"
    fi
    if [ -n "$https_proxy" ]; then
        echo "  ✅ HTTPS代理: $https_proxy"
    else
        echo "  ❌ HTTPS代理: 未设置"
    fi
    if [ -n "$ALL_PROXY" ]; then
        echo "  ✅ SOCKS代理: $ALL_PROXY"
    else
        echo "  ❌ SOCKS代理: 未设置"
    fi
}

# 默认启用代理
proxy_on
# Mihomo Proxy Functions - End
EOF

echo ""
echo "✅ 配置完成！Mihomo 代理函数已写入 ~/.bashrc"
echo "✅ 代理已设置为默认启用"
echo ""
echo "📌 使用说明："
echo "   - proxy_on      启用代理"
echo "   - proxy_off     禁用代理"
echo "   - proxy_status  查看状态"
echo ""
echo "⚡ 请执行以下命令使配置生效："
echo "   source ~/.bashrc"
