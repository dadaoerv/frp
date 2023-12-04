# 安装frp服务

```
git clone https://github.com/dadaoerv/frp.git
cd /root/frp
```

# 服务端:   
默认：7000端口
管理员：admin
密码：123456
token：123456
如果你需要修改端口，密码（token）等，不需要就不需要进行下面这步。
```
 vim frps.ini
```
然后运行：
```
 ./frps -c ./frps.ini
##如果报错，运行下面的
 ./root/frp/frps -c /root/frp/frps.ini
```
如果运行成功了，就可以用终端ssh连接后，开启下面的开机自运行：
```
cp /root/frp/frps.service /etc/systemd/system/frps.service
sudo systemctl daemon-reload
sudo systemctl start frps.service
sudo systemctl enable frps.service
```
# 客户端：   
frpc常用端口都写了，修改你的ip和token即可
```
 vim frpc.ini
```
然后运行：
```
 ./frpc -c ./frpc.ini
##如果报错，运行下面的
 ./root/frp/frpc -c /root/frp/frpc.ini
```
如果运行成功了，就可以用终端ssh连接后，开启下面的开机自运行：
```
cp /root/frp/frpc.service /etc/systemd/system/frpc.service
sudo systemctl daemon-reload
sudo systemctl start frpc.service
sudo systemctl enable frpc.service
```
