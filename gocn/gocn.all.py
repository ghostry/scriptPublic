#!/usr/bin/env python3
# coding=utf-8
import re
import os
import urllib.request

ipset_forward = 'govpn'
rulesfile = './dnsmasq.conf'
domainListfile = './domain.all.list'
domain_url = 'https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf'
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
# 读取远程域名列表
domain_pattern = 'server=/([\w\-\_\.]*[\w\.\-\_]+)/114.114.114.114'
html = str(urllib.request.urlopen(domain_url).read(), encoding="utf-8")
for line in html.splitlines():
    domain = re.findall(domain_pattern, line)
    if domain:
        print('add ' + domain[0])
        domainList.append(domain[0])
    else:
        print('no valid domain in this line: ' + line)
# 去重并写入
domainList = list(set(domainList))
print('总共读取到%s条不重复记录,开始写入文件%s' % (len(domainList), rulesfile))
try:
    os.remove(rulesfile)
    os.remove(domainListfile)
except:
    pass
fs = open(rulesfile, 'w')
fsd = open(domainListfile, 'w')
for domain in domainList:
    fs.write('ipset=/.%s/%s\n' % (domain, ipset_forward))
    num = domain.count('.')
    if num <= 1:
        fsd.write('.%s\n' % (domain,))
    elif num > 1:
        fsd.write('%s\n' % (domain,))
fs.close()
fsd.close()
