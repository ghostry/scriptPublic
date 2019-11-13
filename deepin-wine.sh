#!/bin/bash
filename="/etc/apt/sources.list.d/deepin-wine-install.list"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 425956BB3E31DF51
echo "deb http://mirrors.aliyun.com/deepin/ stable contrib main non-free"|sudo tee $filename
sudo apt-get update
sudo apt-get install deepin-wine
sudo rm $filename
sudo apt-get update
