#!/bin/bash

# 安装frp服务
echo "正在安装frp服务..."
wget https://github.com/fatedier/frp/releases/latest/download/frp_0.52.3_linux_amd64.tar.gz
tar -xzf frp_0.52.3_linux_amd64.tar.gz
cd frp_0.52.3_linux_amd64

# 创建frp服务配置文件
echo "正在创建frp服务配置文件..."
cat <<EOF > frps.ini
[common]
# 监听端口
bind_port = 7000
# 面板端口
dashboard_port = 7810
# 登录面板账号设置
dashboard_user = dadaoerv
dashboard_pwd = aaa999999
# 设置http及https协议下代理端口（非重要）
vhost_http_port = 7080
vhost_https_port = 7081
# 身份验证
token = aaa999999
EOF

# 移动frp文件到目标位置
echo "正在安装frp服务..."
sudo mv frps /usr/local/bin
sudo mv frps.ini /etc/frp

# 创建frp服务文件
echo "正在创建frp服务文件..."
cat <<EOF | sudo tee /etc/systemd/system/frp.service
[Unit]
Description=frp Service
After=network.target

[Service]
ExecStart=/usr/local/bin/frps -c /etc/frp/frps.ini
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
