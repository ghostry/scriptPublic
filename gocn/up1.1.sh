#!/bin/bash
#天朝网站走回国VPN
#生成DNSmasq的ipset设置，并上传到路由器
#然后在mwan3配置规则
#路由器添加启动项
#ipset create govpn hash:ip
python3 gocn.py
scp dnsmasq.conf root@192.168.1.1:/etc/dnsmasq.conf
ssh root@192.168.1.1 '/etc/init.d/dnsmasq restart;'
