#!/bin/bash

# 安装frp服务
echo "正在安装frp服务..."
wget https://github.com/fatedier/frp/releases/latest/download/frp_0.52.3_linux_amd64.tar.gz
tar -xzf frp_0.52.3_linux_amd64.tar.gz
cd frp_0.52.3_linux_amd64

# 创建frp服务配置文件
echo "正在创建frp服务配置文件..."
cat <<EOF > frpc.ini
[common]
server_addr = 101.42.151.229
server_port = 7000
token = aaa999999

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 2288
EOF

# 移动frp文件到目标位置
echo "正在安装frp服务..."
sudo mv frpc /usr/local/bin
sudo mv frpc.ini /etc/frp

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
