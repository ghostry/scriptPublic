#!/bin/bash
#监控服务器延迟在线情况
IP=(
baidu.com
google.com
);
	length=${#IP[*]};
num=();
numch=();
haomiao=();
time=();
zonghaoshi=();
function pingIp(){
	i=0;
	while [ $i -lt $length ]
	do
	{
		jieguo=`ping -c 1 -w 3 ${IP[$i]} `;
		numtmp1=`echo "$jieguo"|grep 'packet'|awk '{print $4}'`;
		numtmp2=${numch[$i]};
		let numtmp1+=numtmp2;
		numch[$i]=$numtmp1;
		haomiao[$i]=`echo "$jieguo"|grep 'min/avg/max/mdev'|awk -F '=' '{print $2}'|awk -F '/' '{print $2}'`;
		if [ "${haomiao[$i]}" == '' ];then
			haomiao[$i]=0;
		fi
		zonghaoshi[$i]=`echo "${haomiao[$i]}+${zonghaoshi[$i]}"|bc`;
		time[$i]=`date +%H:%M:%S`;
		let num[$i]++;
		let i++;
	}
	done;
}
function display(){
	echo -e "IP\t\t丢包率\t平均延时\t成功次数\t次数\t上次延时\t更新时间";
	i=0;
	while [ $i -lt $length ]
	do
		diubao=`echo "scale=0;(${num[$i]}-${numch[$i]})*100/${num[$i]}"|bc`;
		if [ "$diubao" == '' ];then
			diubao=0;
		fi
		avgyan=`awk 'BEGIN{printf "%.3f\n",'${zonghaoshi[$i]}'/'${numch[$i]}'}' 2>/dev/null`;
		if [ "$avgyan" == '' ];then
			avgyan=0;
		fi
		if [ ${avgyan%.*} -gt 100 ] || [ ${avgyan%.*} -lt 1 ];then
			echo -ne "\033[43;31m";
		fi
		if [ ${diubao%.*} -gt 10 ];then
			echo -ne "\033[41;37m";
		fi
		echo -n ${IP[$i]};
		echo -ne "\t";
		echo -n "${diubao}%";
		echo -ne "\t";
		echo -n "${avgyan}ms";
		if [ ${avgyan%.*} -lt 10 ];then
			echo -ne "\t";
		fi
		echo -ne "\t";
		echo -n ${numch[$i]};
		echo -ne "\t";
		echo -ne "\t";
		echo -n ${num[$i]};
		echo -ne "\t";
		echo -n ${haomiao[$i]}ms;
		if [ ${haomiao[$i]%.*} -lt 10 ];then
			echo -ne "\t";
		fi
		echo -ne "\t";
		echo -n ${time[$i]};
		if [ ${diubao%.*} -gt 10 ] || [ ${avgyan%.*} -gt 100 ] || [ ${avgyan%.*} -lt 1 ];then
			echo -ne "\033[0m";
		fi
		echo '';
		let i++;
	done;
}
	i=0;
	while [ $i -lt $length ]
	do
	{
		numch[$i]=0;
		haomiao[$i]='0';
		zonghaoshi[$i]='0';
		time[$i]=`date +%H:%M:%S`;
		num[$i]=0;
		let i++;
	}
	done;
clear;
	while [ true ]
	do
	{
pingIp ;
clear;
display;
		if [ ${length%.*} -lt 10 ];then
sleep 1;
		fi
	}
	done;
