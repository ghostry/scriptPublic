#!/bin/sh
#dns守护，解析不了了重启
dnsOk=`dig blog.ghostry.cn @127.0.0.1|grep 47.52.253.230|wc -l`
if [ "$dnsOk" != "1" ] ; then
docker restart gsmartdns
else
echo 'is ok'
fi
