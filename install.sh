#!/bin/bash

# 定义 FRP 版本
FRP_VERSION="0.53.2"

# 下载 FRP
download_frp() {
    local frp_type=$1
    local os_type=$(uname | tr '[:upper:]' '[:lower:]')
    local arch_type="amd64" # 根据需要调整架构类型

    local file_name="frp_${FRP_VERSION}_${os_type}_${arch_type}.tar.gz"
    local download_url="https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/${file_name}"

    wget $download_url
    tar -zxvf $file_name
    cd "frp_${FRP_VERSION}_${os_type}_${arch_type}"
}

# 创建配置文件
create_config() {
    local frp_type=$1
    echo "正在创建 $frp_type 配置文件..."

    if [ "$frp_type" == "frpc" ]; then
        read -p "请输入服务器地址: " server_addr
        read -p "请输入服务器端口: " server_port
        read -p "请输入连接密码: " token

        # 创建 frpc.toml
        cat >frpc.toml <<EOF
[common]
server_addr = "$server_addr"
server_port = $server_port
token = "$token"
EOF
        echo "frpc.toml 配置文件已创建。"
    else
        read -p "请输入监听端口: " bind_port
        read -p "请输入连接密码: " token

        # 创建 frps.toml
        cat >frps.toml <<EOF
[common]
bind_port = $bind_port
token = "$token"
EOF
        echo "frps.toml 配置文件已创建。"
    fi
}

# 设置自动启动
setup_autostart() {
    local frp_type=$1
    local service_file="/etc/systemd/system/${frp_type}.service"

    echo "正在设置 $frp_type 自动启动..."
    cat >$service_file <<EOF
[Unit]
Description=FRP ${frp_type^} Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=$(pwd)/${frp_type} -c $(pwd)/${frp_type}.toml

[Install]
WantedBy=multi-user.target
EOF

    systemctl enable ${frp_type}
    systemctl start ${frp_type}
    echo "$frp_type 自动启动设置完成。"
}

# 主流程
echo "请选择要安装的 FRP 类型："
echo "1) frps (服务端)"
echo "2) frpc (客户端)"
read -p "选择 [1-2]: " choice

if [ "$choice" == "1" ]; then
    frp_type="frps"
elif [ "$choice" == "2" ]; then
    frp_type="frpc"
else
    echo "选择错误！"
    exit 1
fi

download_frp $frp_type
create_config $frp_type
setup_autostart $frp_type

echo "FRP 安装和配置完成。"
