# 快速入门使用指南

## 一键部署（3步）

```bash
# 1. 检查环境
bash check_env.sh

# 2. 导入镜像（离线部署）
bash loadVPNImages.sh

# 3. 把你的代理文件改名为config.yaml文件,放入config目录下(传文件可以用SCP/VSCODE/TERMINUS)
mv xxxxxxx.yaml config/config.yaml

# 4. 启动服务
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
