#!/bin/bash
kernel=`uname -s`;
kernel_release=`uname -r`;
echo "内核为： $kernel $kernel_release";
echo "有以下PCI设备：";
lspci|awk '{$1="";print}'|while read line;do
    echo $line;
done
echo "有以下USB设备：";
lsusb|awk '{$1=$2=$3=$4=$5=$6="";print}'|while read line; do
    echo $line;
done
