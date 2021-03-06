#!/usr/bin/env python3
# coding=utf-8
import re
import os
import urllib.request

ipset_forward = 'govpn'
rulesfile = './dnsmasq.conf'
domainList = []
# 读取本地域名列表
domain_pattern = '^([\w\-\_\.]*[\w\.\-\_]+)'
domainlist = open('domain.list', 'r')
for line in domainlist.readlines():
    domain = re.findall(domain_pattern, line)
    if domain:
        print('add ' + domain[0])
        domainList.append(domain[0])
    else:
        print('no valid domain in this line: ' + line)
domainlist.close()
# 去重并写入
domainList = list(set(domainList))
print('总共读取到%s条不重复记录,开始写入文件%s' % (len(domainList), rulesfile))
try:
    os.remove(rulesfile)
except:
    pass
fs = open(rulesfile, 'w')
for domain in domainList:
    fs.write('ipset=/.%s/%s\n' % (domain, ipset_forward))
fs.close()
