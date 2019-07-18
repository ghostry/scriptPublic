#!/bin/sh
#该脚本会测试所有ubuntu软件源的下载速度，找出最快的源，生成列表
cd $(dirname $(readlink -f "$0"))
pipenv install
pipenv run python fastMirrors.py
echo "现在可以把上面deb开头的行，\n粘贴到 /etc/apt/sources.list 文件中，替换原有内容"