#!/bin/bash
filename="/etc/apt/sources.list.d/deepin-wine-install.list"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 425956BB3E31DF51
echo "deb http://mirrors.aliyun.com/deepin/ stable contrib main non-free"|sudo tee $filename
sudo apt-get update
sudo apt-get install -y deepin-wine aria2
url="https://mirrors.aliyun.com/deepin/pool/non-free/d/deepin.com.wechat/deepin.com.wechat_2.6.8.65deepin0_i386.deb"
aria2c -c --file-allocation=none -x 16 -k 1M -o wechat.deb $url
url="https://mirrors.aliyun.com/deepin/pool/non-free/d/deepin.com.qq.office/deepin.com.qq.office_2.0.0deepin4_i386.deb"
aria2c -c --file-allocation=none -x 16 -k 1M -o tim.deb $url
sudo dpkg -i wechat.deb
sudo dpkg -i tim.deb
sudo apt --fix-broken install -y
sudo rm $filename
sudo apt-get update
