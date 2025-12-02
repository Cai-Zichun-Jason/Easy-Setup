# Mihomo VPN 部署指南
这是一个为没有GUI界面的LINUX服务器提供翻墙的自动化部署方案。  
基于 Mihomo (Clash Meta 内核) 的代理解决方案，提供 Metacubexd 可视化管理界面。  
可以直接用能够用于 Clash Verge Rev 客户端的代理文件。  
[**Clash Verge Rev**](https://github.com/clash-verge-rev/clash-verge-rev/releases)   

**为什么可以用?**   
因为 Clash Verge Rev 是基于VPN内核 Clash Meta (其实就是Mihomo) 进一步开发得来的。当然有时候他们会说，Clash Verge是基于Sing内核或者Sing-Box开发而来的，不尽然，只是用了人家的库。  

**发展轨迹**  : Clash Verge Rev ⬅️ Clash Verge ⬅️ Mihomo(Clash Meta内核) ⬅️ Sing-Box

---

## 📦 项目使用的 Docker 容器

本项目使用以下两个 Docker 容器：

| 容器名称 | 镜像 | 作用 | 网络模式 |
|---------|------|------|---------|
| **mihomo** | `metacubex/mihomo:latest` | 代理核心服务，负责流量转发和规则匹配 | `host` 模式（高性能） |
| **metacubexd** | `ghcr.io/metacubex/metacubexd:latest` | Web 管理面板，提供可视化配置界面 | 桥接模式 |

---

## 🔌 需要暴露的端口

| 端口号 | 服务 | 用途 | 访问方式 |
|-------|------|------|---------|
| **7890** | Mihomo 代理端口 | HTTP + SOCKS5 混合代理 | 系统代理/应用代理 |
| **9090** | Mihomo API | RESTful API 管理接口 | Web 面板连接 |
| **8080** | Metacubexd Web UI | 可视化管理面板 | 浏览器访问 |

**防火墙设置（如需远程访问）：**
```bash
sudo ufw allow 8080/tcp  # Web 管理面板
sudo ufw allow 9090/tcp  # Mihomo API
# 注意：7890 端口通常只用于本地，不建议对外开放
```

---

## ⚙️ 前置环境要求

运行本项目需要以下环境：

- **操作系统**: Linux (Ubuntu/Debian/CentOS 等)
- **Docker**: 版本 20.10 或更高
- **Docker Compose**: 版本 2.0 或更高（docker compose 插件）
- **必需工具**: curl, grep, make (可选)

### 快速检查环境

运行环境检查脚本：
```bash
bash check_env.sh
```

如果提示缺少依赖，请参考本文档底部的 [附录：Docker 安装](#附录docker-安装与配置)。

---

## 📁 项目结构

```
Topic1-VPN/
├── docker-compose.yaml    # Docker Compose 配置文件
├── config/                # 配置文件目录
│   └── config.yaml       # ⭐ Mihomo 核心配置（包含节点信息）
├── images/                # 离线 Docker 镜像存放目录
├── loadVPNImages.sh       # 镜像导入脚本
├── setProxy.sh            # 代理环境配置脚本
├── check_env.sh           # 环境依赖检查脚本
└── README.md              # 本文档
```

---

## 📝 配置文件说明

### config.yaml 文件位置

直接把你的代理yaml文件放到config文件夹下，改名为config.yaml。  

本人代理采用 https://赔钱机场.com/ 的节点代理目前使用一切正常。

**修改配置后需要重启容器**：
```bash
docker restart mihomo
```

---

## 🚀 初始化与启动步骤

### 步骤 1: 导入 Docker 镜像（离线部署）

如果服务器无法访问 Docker Hub，使用提供的离线镜像：

```bash
# 进入项目目录
cd Topic1-VPN

# 运行镜像导入脚本
bash loadVPNImages.sh
```

该脚本会自动导入 `images/` 目录中的镜像文件。

### 步骤 2: 启动服务

```bash
# 使用 Docker Compose 启动所有服务
docker compose up -d
```

**预期输出**：
```
[+] Running 2/2
 ✔ Container mihomo       Started
 ✔ Container metacubexd   Started
```

### 步骤 3: 验证服务状态（不必要）

```bash
# 查看容器运行状态
docker ps

# 查看 Mihomo 日志
docker logs mihomo

# 查看 Metacubexd 日志
docker logs metacubexd
```
### 步骤 4: 通过Web访问Clash管理页面
在浏览器中打开：
- **远程访问**：`http://服务器IP:8080`
打开面板后，需要填写连接信息：

| 字段 | 填写内容 |
|-----|---------|
| **Endpoint URL** | `http://服务器IP:9090` 或 `http://localhost:9090` |
| **Secret** | **留空不填**（默认无密码，如果你没有设置的话） |
---

## 🌐 访问与配置

### 1. 访问 Web 管理面板

在浏览器中打开：
- **本机访问**：`http://localhost:8080`
- **远程访问**：`http://服务器IP:8080`

### 2. 首次配置面板

打开面板后，需要填写连接信息：

| 字段 | 填写内容 |
|-----|---------|
| **Endpoint URL** | `http://服务器IP:9090` 或 `http://localhost:9090` |
| **Secret** | **留空不填**（默认无密码） |

点击 "Connect" 连接成功后，即可管理代理节点。

### 3. 配置系统代理

在需要使用代理的应用中设置：

- **HTTP 代理**：`127.0.0.1:7890`
- **SOCKS5 代理**：`127.0.0.1:7890`

### 4. 使用代理脚本（终端）

为了方便在终端中启用/禁用代理，项目提供了 `setProxy.sh` 脚本：

```bash
# 加载代理函数到当前终端
bash setProxy.sh

# 激活新加入到 ~/.bashrc 的内容
source ~/.bashrc

# 启用代理
proxy_on

# 禁用代理
proxy_off

# 查看代理状态
proxy_status
```1
---

## 🔧 常用管理命令

```bash
# 启动所有服务
docker compose up -d

# 停止所有服务
docker compose down

# 重启特定服务
docker restart mihomo
docker restart metacubexd

# 查看服务日志
docker logs mihomo
docker logs metacubexd

# 实时查看日志
docker logs -f mihomo

# 更新配置后重载
docker restart mihomo

# 查看容器资源占用
docker stats mihomo metacubexd
```

---

## 🔍 故障排查

### 问题 1: 无法访问 Web 面板（8080端口）

**检查步骤**：
```bash
# 1. 检查容器是否运行
docker ps | grep metacubexd

# 2. 检查端口监听
ss -tulpn | grep :8080

# 3. 查看容器日志
docker logs metacubexd
```

### 问题 2: Web 面板无法连接 Mihomo API

**检查步骤**：
```bash
# 1. 检查 Mihomo 是否运行
docker ps | grep mihomo

# 2. 查看 API 配置
docker logs mihomo | grep "RESTful API"
# 应该看到: RESTful API listening at: [::]:9090

# 3. 测试 API 连接
curl http://localhost:9090/version
# 应该返回: {"meta":true,"version":"v1.19.16"}
```

**解决方案**：
- 确保 `config/config.yaml` 中 `external-controller: '0.0.0.0:9090'`
- 检查防火墙是否开放 9090 端口

### 问题 3: 代理不工作

**检查步骤**：
```bash
# 1. 测试代理端口
curl -x http://127.0.0.1:7890 https://www.google.com

# 2. 查看 Mihomo 日志
docker logs mihomo --tail 50

# 3. 检查节点连接状态（Web 面板）
# 访问面板 -> Proxies -> 查看节点延迟
```

### 问题 4: Docker 容器无法启动

**检查步骤**：
```bash
# 查看完整错误信息
docker compose logs

# 检查端口占用
ss -tulpn | grep -E '7890|9090|8080'

# 重新启动
docker compose down
docker compose up -d
```

---

## 📝 配置修改示例

### 1. 修改代理端口

编辑 `config/config.yaml`：
```yaml
mixed-port: 7891  # 改为其他端口
```

重启服务：
```bash
docker restart mihomo
```

### 2. 设置 API 密码

编辑 `config/config.yaml`：
```yaml
secret: 'your_password_here'  # 设置密码
```

重启并更新面板配置：
```bash
docker restart mihomo
# 然后在 Web 面板中的 Secret 字段填入密码
```

### 3. 允许局域网连接

编辑 `config/config.yaml`：
```yaml
allow-lan: true  # 允许局域网设备使用代理
```

重启服务：
```bash
docker restart mihomo
```

---

## 🔄 更新与维护

### 更新镜像

```bash
# 拉取最新镜像
docker compose pull

# 重新创建容器
docker compose up -d --force-recreate
```

### 备份配置

```bash
# 备份配置文件
cp config/config.yaml config/config.yaml.backup.$(date +%Y%m%d)

# 或整体备份
tar -czf vpn-backup-$(date +%Y%m%d).tar.gz config/
```

### 查看版本信息

```bash
# Mihomo 版本
curl -s http://localhost:9090/version

# Docker 镜像版本
docker images | grep -E 'mihomo|metacubexd'
```

---

## 附录：Docker 安装与配置

### 安装 Docker（Ubuntu/Debian）

```bash
# 1. 更新软件包索引
sudo apt-get update

# 2. 安装依赖
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# 3. 添加 Docker 官方 GPG 密钥
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 4. 添加 Docker 软件源
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. 安装 Docker Engine 和 Docker Compose 插件
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 6. 验证安装
docker --version
docker compose version
```

### 安装 Docker（CentOS/RHEL）

```bash
# 1. 卸载旧版本
sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine

# 2. 安装依赖
sudo yum install -y yum-utils

# 3. 添加 Docker 软件源
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# 4. 安装 Docker
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 5. 启动 Docker
sudo systemctl start docker
sudo systemctl enable docker

# 6. 验证安装
docker --version
docker compose version
```

### 配置 Docker 服务

```bash
# 1. 启动 Docker 服务
sudo systemctl start docker

# 2. 设置开机自启
sudo systemctl enable docker

# 3. 查看服务状态
sudo systemctl status docker
```

### 将当前用户添加到 docker 组（免 sudo）

```bash
# 1. 创建 docker 组（如果不存在）
sudo groupadd docker

# 2. 将当前用户添加到 docker 组
sudo usermod -aG docker $USER

# 3. 刷新用户组（需要重新登录或执行）
newgrp docker

# 4. 验证（无需 sudo）
docker ps
```

**注意**：添加到 docker 组后，需要**注销并重新登录**或者**重启系统**才能完全生效。
---

## 📞 技术支持

如遇问题，请按以下顺序排查：

1. 运行 `bash check_env.sh` 检查环境
2. 查看容器日志：`docker logs mihomo` 和 `docker logs metacubexd`
3. 检查配置文件语法（YAML 格式严格要求缩进）
4. 确认防火墙规则和端口占用
5. 查看本文档的 [故障排查](#故障排查) 章节

---

## 📄 许可证

本项目基于开源软件构建：
- [Mihomo](https://github.com/MetaCubeX/mihomo) - GPLv3
- [Metacubexd](https://github.com/MetaCubeX/metacubexd) - MIT
