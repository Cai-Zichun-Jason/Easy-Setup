# 快速入门指南

## 一键部署（3步）

```bash
# 1. 检查环境
bash check_env.sh

# 2. 导入镜像（离线部署）
bash loadVPNImages.sh

# 3. 启动服务
docker compose up -d
```

## 访问面板

浏览器访问：`http://服务器IP:8080`

**首次配置填写：**
- Endpoint URL: `http://服务器IP:9090`
- Secret: **留空**

## 使用代理

### 终端代理（推荐）

```bash
# 加载代理脚本
bash setProxy.sh

# 启用代理
proxy_on

# 禁用代理
proxy_off
```

### 系统代理

HTTP 代理：`127.0.0.1:7890`
SOCKS5 代理：`127.0.0.1:7890`

## 常用命令

```bash
# 查看状态
docker ps

# 查看日志
docker logs mihomo

# 重启服务
docker restart mihomo

# 停止所有
docker compose down
```

---

**详细文档**: 查看 [README.md](./README.md)
