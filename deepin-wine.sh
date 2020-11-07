#!/bin/bash
filename="/etc/apt/sources.list.d/deepin.list"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 425956BB3E31DF51
echo "deb [by-hash=force] https://community-packages.deepin.com/deepin/ apricot main contrib non-free"|sudo tee $filename
echo "Package: *\nPin: origin community-packages.deepin.com\nPin-Priority: 200"|sudo tee /etc/apt/preferences.d/deepin
sudo apt-get update
# 更多软件名查看 https://community-packages.deepin.com/deepin/pool/non-free/d/
sudo apt-get install -y deepin.com.wechat
sudo apt-get install -y deepin.com.qq.office
