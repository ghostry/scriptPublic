#!/usr/bin/env python
# -*- coding: utf-8 -*-
from bs4 import BeautifulSoup
import http.client as httplib
import urllib.parse as urlparse
import timeit
try:
    import queue
except ImportError:
    import Queue as queue
import threading
import sys


class fastMirrors(object):
    """
    找到最快的软件源，生成sources.list内容

    # ubuntu的版本，默认disco
    version = 'disco',
    # 线程数，默认10
    threadNum = 10,
    # 请求超时秒数，默认5秒
    timeout = 5,
    # 是否打开提前释放出的更新，默认不打开
    dev = False
    """

    def __init__(self, version='focal', threadNum=10, timeout=5, dev=False):
        self.version = version
        self.threadNum = threadNum + 1
        self.timeout = timeout
        self.rets = []
        self.list = []
        # 定义队列
        self.q = queue.Queue()
        self.ups = [
            "", "-updates", "-security", "-backports",
        ]
        if dev:
            self.ups.append("-proposed")
        self.ves = [
            "main",
            "restricted",
            "universe",
            "multiverse",
        ]

    def sendhttp(self, url):
        url = urlparse.urlsplit(url)
        headers = {"Content-type": "application/x-www-form-urlencoded",
                   "Accept": "text/plain"}
        if url.scheme == 'http':
            conn = httplib.HTTPConnection(url.netloc, timeout=self.timeout)
        elif url.scheme == 'https':
            conn = httplib.HTTPSConnection(url.netloc, timeout=self.timeout)
        else:
            return 0
        try:
            conn.request('GET', url.path, url.query, headers)
            httpres = conn.getresponse()
        except Exception as e:
            return 0
        if int(httpres.status) == 200:
            try:
                html = httpres.read()
                size = sys.getsizeof(html)
                # print(size)
                if size < 10000:
                    return 0
                return html
            except Exception as e:
                return 0
        else:
            return 0

    def createQueue(self):
        # 获取软件源列表，写入队列
        url = 'https://launchpad.net/ubuntu/+archivemirrors'
        print("从%s读取软件源列表" % url)
        html = self.sendhttp(url)
        bsObj = BeautifulSoup(html, 'html.parser')
        t1 = bsObj.find_all('a')
        for t2 in t1:
            t3 = t2.get('href')
            if t2.string == 'http':
                self.q.put(t3)

    def consumer(self, name):
        while True:
            if not self.q.empty():
                # http://mirror.ncunwlab.tk/ubuntu/dists/bionic/InRelease
                url = self.q.get()
                sendurl = "%s/dists/%s/InRelease" % (
                    url.rstrip('/'), self.version)
                start = timeit.default_timer()
                # 打开页面1次
                returnNum = self.sendhttp(sendurl)
                end = timeit.default_timer()
                time = end - start
                if returnNum:
                    print('\033[32;1m线程 %s 请求 %s 耗时 %s 秒\033[0m' %
                          (name, sendurl, time))
                    self.list.append((url, time))
                else:
                    print('线程 %s 请求 %s 耗时 %s 秒' % (name, sendurl, time))
            else:
                print("-----线程 %s 结束----" % name)
                break

    def takeSecond(self, elem):
        # 获取列表的第二个元素
        return elem[1]

    def createSourcesList(self):
        # 创建队列
        self.createQueue()
        # 开始线程
        threads = {}
        for x in range(1, self.threadNum):
            name = 'th%s' % x
            threads[name] = threading.Thread(
                target=self.consumer, args=(name,))
            threads[name].start()
        # 等待结束
        for x in range(1, self.threadNum):
            name = 'th%s' % x
            threads[name].join()
        # 指定第二个元素排序
        self.list.sort(key=self.takeSecond)
        # 输出结果
        num = 0
        for up in self.ups:
            for ve in self.ves:
                ret = "deb %s %s%s %s" % (
                    self.list[num][0], self.version, up, ve)
                print(ret)
                self.rets.append(ret)
                num += 1
if __name__ == '__main__':
    fast = fastMirrors()
    fast.createSourcesList()
