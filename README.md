# 安装frp服务
必须在root目录下，如果没有，自己修改
```
git clone https://github.com/dadaoerv/frp.git
cd /root/frp
```

# 服务端:   
默认：7000端口  
管理端口：7810   
管理员：admin   
密码：123456   
token：123456   
如果你需要修改端口，密码（token）等，运行下一步修改，不需要跳过。
```
 vim frps.toml
```
然后运行：
```
 chmod +x frps
 ./frps -c ./frps.toml
```
开启frps服务端开机自运行：
```
cp /root/frp/frps.service /etc/systemd/system/frps.service
sudo systemctl daemon-reload
sudo systemctl start frps.service
sudo systemctl enable frps.service
```
# 客户端：   
frpc常用端口都写了，修改你的ip和token即可
```
 vim frpc.toml
```
然后运行：
```
 chmod +x frpc
 ./frpc -c ./frpc.toml
```
如果运行成功了，就可以用终端ssh连接后，开启下面的开机自运行：
```
cp /root/frp/frpc.service /etc/systemd/system/frpc.service
sudo systemctl daemon-reload
sudo systemctl start frpc.service
sudo systemctl enable frpc.service
```
# 如果你安装多个终端（机器），那么记得frpc.toml文件里的名字和端口都需要改
