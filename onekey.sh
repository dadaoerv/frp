#!/bin/bash

# 检查是否以 root 权限运行
if [ "$(id -u)" -ne 0 ]; then
    echo "请使用 root 权限运行该脚本。"
    exit 1
fi

# 提示用户选择安装 frps 还是 frpc
echo "请选择要安装的 frp 服务类型："
echo "1. frps 服务器"
echo "2. frpc 客户端"
read -p "请输入选项 (1 或 2): " choice

case $choice in
    1)
        SERVICE_TYPE="frps"
        ;;
    2)
        SERVICE_TYPE="frpc"
        ;;
    *)
        echo "无效的选项。"
        exit 1
        ;;
esac

# 提示用户输入配置文件内容
echo "请按照以下提示输入 $SERVICE_TYPE.toml 文件的配置内容："
read -p "请输入 server_addr (服务器地址): " SERVER_ADDR
read -p "请输入 bind_addr (绑定地址，一般使用 0.0.0.0): " BIND_ADDR
read -p "请输入 bind_port (绑定端口): " BIND_PORT
read -p "请输入 dashboard_port (仪表盘端口): " DASHBOARD_PORT
read -p "请输入 token (访问密码): " TOKEN
read -p "请输入 Dashboard 用户名: " DASHBOARD_USER
read -p "请输入 Dashboard 密码: " DASHBOARD_PASSWORD

# 根据服务类型设置不同的配置文件格式
if [ "$SERVICE_TYPE" == "frps" ]; then
    read -p "请输入 privilege_mode (特权模式，通常为 true): " PRIVILEGE_MODE
    read -p "请输入 privilege_token (特权令牌): " PRIVILEGE_TOKEN
    read -p "请输入 log_file (日志文件路径): " LOG_FILE
    read -p "请输入 log_level (日志级别): " LOG_LEVEL

    # 创建 frps 配置文件
    cat > "/etc/frp/$SERVICE_TYPE.toml" <<EOF
[common]
server_addr = $SERVER_ADDR
bind_addr = $BIND_ADDR
bind_port = $BIND_PORT
dashboard_port = $DASHBOARD_PORT
token = $TOKEN
dashboard_user = $DASHBOARD_USER
dashboard_pwd = $DASHBOARD_PASSWORD
privilege_mode = $PRIVILEGE_MODE
privilege_token = $PRIVILEGE_TOKEN
log_file = $LOG_FILE
else
    read -p "请输入 remote_port (远程端口): " REMOTE_PORT
    read -p "请输入 remote_addr (远程地址): " REMOTE_ADDR

    # 创建 frpc 配置文件
    cat > "/etc/frp/$SERVICE_TYPE.toml" <<EOF
[common]
server_addr = $SERVER_ADDR
bind_addr = $BIND_ADDR
bind_port = $BIND_PORT
token = $TOKEN

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = $REMOTE_PORT
remote_addr = $REMOTE_ADDR
EOF
fi

# 安装 frp
apt-get update
apt-get install -y unzip
wget https://github.com/fatedier/frp/releases/latest/download/$SERVICE_TYPE\_linux_amd64 -O /usr/local/bin/$SERVICE_TYPE
chmod +x /usr/local/bin/$SERVICE_TYPE

# 创建 systemd 服务
cat > /etc/systemd/system/$SERVICE_TYPE.service <<EOF
[Unit]
Description=$SERVICE_TYPE service for frp
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/$SERVICE_TYPE -c /etc/frp/$SERVICE_TYPE.toml

[Install]
WantedBy=multi-user.target
EOF

# 启动 frp 服务并设置开机自启动
systemctl daemon-reload
systemctl start $SERVICE_TYPE
systemctl enable $SERVICE_TYPE

echo "安装完成并启动了 $SERVICE_TYPE 服务。"
