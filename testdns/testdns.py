#!/usr/bin/python3
import subprocess
import re
import os
import urllib.request
# 依赖
# apt-get install knot-dnsutils

# 多少毫秒以内算优质
maxms = 500
# kdig测试几秒超时
timeout = '1'
# 有发布dns地址的网页
urlList = [
    'https://www.suozy.cn/post-21.html',
    'https://www.iplaysoft.com/public-dns.html',
    'http://www.dn258.com/1024.html',
    'http://www.dnsdizhi.com/post-338.html',
    'https://www.boyhost.cn/otherfree/china-public-dns-ip-lists.html',
    'https://segmentfault.com/a/1190000004607227',
    'https://www.liwei8090.com/4580.html',
    'https://www.cnblogs.com/gjw-hsf/p/7204830.html',
    'https://blog.csdn.net/pengyuan_D/article/details/76598748',
    'https://www.ip.cn/dns.html',
    'https://www.0xss.cn/441.html',
    'https://wangdalao.com/44.html',
    'https://dns.icoa.cn/',
    'https://laod.cn/dns/public-dns.html',
    'http://dns.lisect.com/',
]
# 待测试的dns
ipListFile = 'dnslist'
# 测试结果,建议每次完成后修改名称
fineIpList = 'fineiplist'
# 是否生成日志
isdebug = True
logfile = 'testdns.log'
# 以上是配置

# 以下内容不要修改
ipv4 = r'((?:(?:25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(?:25[0-5]|2[0-4]\d|[01]?\d\d?))'
# ipv6 = r'((?:[\da-fA-F]{1,4}:){7}[\da-fA-F]{1,4})'
cmdbase = 'kdig%s +time=' + timeout + \
    ' +retry=1 +short +stats blog.ghostry.cn @%s 2>>/dev/null|sed "2,3d"'
logstrbase = "%s 执行结果:\n%s\n-------------------------\n"
if os.path.exists(ipListFile):
    fo = open(ipListFile, "r")
    try:
        os.remove(logfile)
    except Exception as e:
        pass
    log = open(logfile, 'w')
    jieguo = {}
    for dns in fo:
        # ss = str(subprocess.check_output(
        #     'ping -c 1 %s' % dns, shell=True), encoding='utf-8')
        # miao = re.findall(r'time=([0-9\.]*) ms', ss)
        dns = dns.strip()
        try:
            print('%s kdig 进行测试,' % dns, end='')
            cmd = cmdbase % ('', dns)
            udpstr = str(subprocess.check_output(
                cmd, shell=True), encoding='utf-8')
            if isdebug:
                log.write(logstrbase % (cmd, udpstr))
            if '47.52.253.230' in udpstr:
                miao = re.findall(r' in ([0-9\.]*) ms', udpstr)
                if int(float(miao[0])) < maxms:
                    print(' 优质dns,%s毫秒,测试是否支持tls/tcp,' % (miao[0]), end='')
                    suffix = ''
                    try:
                        # 测试tcp支持
                        cmd = cmdbase % (' +tcp', dns)
                        tcpstr = str(subprocess.check_output(
                            cmd, shell=True), encoding='utf-8')
                        if '47.52.253.230' in tcpstr:
                            suffix = '-tcp'
                        if isdebug:
                            log.write(logstrbase %
                                      (cmd, udpstr))
                    except Exception as e:
                        pass
                    try:
                        # 测试tls支持
                        cmd = cmdbase % (' +tls', dns)
                        tlsstr = str(subprocess.check_output(
                            cmd, shell=True), encoding='utf-8')
                        if '47.52.253.230' in tlsstr:
                            suffix = '-tls'
                        if isdebug:
                            log.write(logstrbase %
                                      (cmd, udpstr))
                    except Exception as e:
                        pass
                    print('支持%s,缓存结果' % (suffix))
                    jieguo[float(miao[0])] = {'ms': miao[0],
                                              'suffix': suffix, 'dns': dns}
                else:
                    print(' 慢速dns,%s毫秒' % (miao[0]))
            else:
                print(' kdig 解析失败')
        except Exception as e:
            print(' kdig 失败')
    keys = sorted(jieguo.keys())
    print('写入结果开始')
    try:
        os.remove(fineIpList)
    except Exception as e:
        pass
    fine = open(fineIpList, 'w')
    for key in keys:
        fine.write("# UDP Test resolution time %s ms\nserver%s %s\n" %
                   (jieguo[key]['ms'], jieguo[key]['suffix'], jieguo[key]['dns']))
    fo.close()
    fine.close()
    print('写入结果完成')
else:
    result = []
    for url in urlList:
        print('读取%s中,' % url, end='')
        try:
            html = str(urllib.request.urlopen(url).read(), encoding="utf-8")
            resultsub = re.findall(re.compile(ipv4), html)
        except:
            resultsub=[]
        print('读取到%s条记录' % len(resultsub))
        result.extend(resultsub)
    result = list(set(result))
    print('总共读取到%s条不重复记录,开始写入文件%s' % (len(result), ipListFile))
    fo = open(ipListFile, "w")
    for url in result:
        fo.write("%s\n" % url)
    fo.close()
