#!/bin/bash
filename="/etc/apt/sources.list.d/deepin-wine-install.list"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 425956BB3E31DF51
echo "deb https://mirrors.huaweicloud.com/deepin stable main contrib non-free"|sudo tee $filename
sudo apt-get update
sudo apt-get install -y deepin-wine
sudo apt-get install -y deepin.com.wechat
sudo apt-get install -y deepin.com.qq.office
sudo rm $filename
sudo apt-get update
