#!/bin/bash
#超时改为1,
#增加UbuntuISO
isture=$(grep 'GRUB_TIMEOUT=1'  /etc/default/grub);
if [ ! -n "$isture" ];then
        sed -i 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=1/' /etc/default/grub
fi
istrue=$(grep 'menuentry "ubuntu iso install" {' /etc/grub.d/40_custom)
if [ ! -n "$istrue" ];then
        echo 'menuentry "ubuntu iso install" {' >> /etc/grub.d/40_custom
        echo '  insmod ntfs' >> /etc/grub.d/40_custom
        echo '  loopback loop (hd1,1)/ubuntu-16.04-desktop-amd64.iso' >> /etc/grub.d/40_custom
        echo '  set root=(loop)' >> /etc/grub.d/40_custom
        echo '  linux /casper/vmlinuz.efi boot=casper iso-scan/filename=/ubuntu-16.04-desktop-amd64.iso  ro quiet splash locale=zh_CN.UTF-8' >> /etc/grub.d/40_custom
        echo '  initrd /casper/initrd.lz' >> /etc/grub.d/40_custom
        echo '}' >> /etc/grub.d/40_custom
fi
update-grub
