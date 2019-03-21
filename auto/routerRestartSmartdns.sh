#!/bin/sh
#*/5 * * * * /data/bin/auto/routerRestartSmartdns.sh

dnsOk=`dig blog.ghostry.cn @127.0.0.1 -p 6053|grep 47.52.253.230|wc -l`
if [ "$dnsOk" != "1" ] ; then
/etc/init.d/smartdns restart
else
echo 'is ok'
fi
