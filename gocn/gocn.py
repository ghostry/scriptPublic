#!/usr/bin/env python  
#coding=utf-8
import re
import os

ipset_forward = 'govpn'
rulesfile = './dnsmasq.conf'
domain_pattern = '([\w\-\_]+\.[\w\.\-\_]+)[\/\*]*'
domainlist = open('domain.list', 'r')
try:
	os.remove(rulesfile)
except:
	pass
fs = open(rulesfile, 'w')
for line in domainlist.readlines():
	domain = re.findall(domain_pattern, line)
	if domain:
		print('saving ' + domain[0])
		fs.write('ipset=/.%s/%s\n'%(domain[0],ipset_forward))
	else:
		print 'no valid domain in this line: ' + line
domainlist.close()
fs.close()


