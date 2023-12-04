#!/bin/bash

# 定义变量
FRP_VERSION="0.52.3"
FRP_DOWNLOAD_URL="https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz"
FRP_INSTALL_DIR="/usr/local/frp"

# 下载frp压缩包
echo "Downloading frp..."
wget -q $FRP_DOWNLOAD_URL

# 解压并安装frp
echo "Installing frp..."
tar -xzf frp_${FRP_VERSION}_linux_amd64.tar.gz
sudo mkdir -p $FRP_INSTALL_DIR
sudo mv frp_${FRP_VERSION}_linux_amd64/* $FRP_INSTALL_DIR
rm -rf frp_${FRP_VERSION}_linux_amd64.tar.gz frp_${FRP_VERSION}_linux_amd64

# 创建frp配置文件
echo "Configuring frp..."
sudo tee $FRP_INSTALL_DIR/frpc.ini > /dev/null << EOL
[common]
server_addr = 101.42.151.229
server_port = 7000
token = aaa999999

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 2212
EOL

# 启动frp服务
echo "Starting frp..."
sudo $FRP_INSTALL_DIR/frpc -c $FRP_INSTALL_DIR/frpc.ini &

echo "frp installation completed!"

# 创建frp服务文件
echo "正在创建frp服务文件..."
cat <<EOF | sudo tee /etc/systemd/system/frp.service
[Unit]
Description=frp Service
After=network.target

[Service]
ExecStart=/usr/local/bin/frpc -c /etc/frp/frpc.ini
Restart=on-failure
User=root

[Install]
WantedBy=multi-user.target
EOF

# 启动并设置自动启动
echo "正在启动frp服务..."
sudo systemctl daemon-reload
sudo systemctl start frp.service
sudo systemctl enable frp.service

echo "frp服务已成功安装并已设置为自动启动。"
