#!/bin/bash
stop() {
	# must interrupt it to save session
	killall -2 aria2c
	echo 'stop'
}
start(){
	usr_path=$HOME						#基础目录
	aria2_conf_path="$usr_path/.aria2"			#配置文件目录
	aria2_downloadfolder="$usr_path/下载"			#下载文件目录

	aria2_configfile="$aria2_conf_path/aria2.conf"		#配置
	aria2_downloadlist="$aria2_conf_path/aria2file.txt"	#下载任务列表
	aria2_DHT="$aria2_conf_path/dht.dat"			#dht数据文件

	[ ! -d "$aria2_conf_path" ] && mkdir -p "$aria2_conf_path"
	[ ! -f "$aria2_downloadlist" ] && touch "$aria2_downloadlist"
	[ ! -f "$aria2_DHT" ] && touch "$aria2_DHT"
	[ ! -f "$aria2_configfile" ] && {
		cat > "$aria2_configfile" << EOF
# General Setting
#
continue
peer-id-prefix=-TR2610-
user-agent=Transmission/2.61 (13407)
event-poll=epoll
on-download-complete=/etc/aria2/post

# Connection Setting
#
disable-ipv6
check-certificate=false
min-split-size=20M
max-resume-failure-tries=50

# BitTorrent Setting
#
enable-dht
enable-dht6=true
enable-peer-exchange
bt-enable-lpd
bt-seed-unverified
bt-save-metadata
bt-hash-check-seed
bt-remove-unselected-file
bt-stop-timeout=60
seed-ratio=0.5
save-session-interval=60
bt-tracker=udp://tracker.openbittorrent.com:80/announce,udp://coppersurfer.tk:6969/announce,udp://mgtracker.org:2710/announce,http://mgtracker.org:2710/announce,udp://9.rarbg.com:2710/announce,udp://11.rarbg.me:80/announce,udp://tracker.openbittorrent.com:80,http://pubt.net:2710/announce,http://open.acgtracker.com:1096/announce,http://tracker.tfile.me/announce,udp://9.rarbg.me:2710/announce,udp://tracker.leechers-paradise.org:6969/announce,udp://shadowshq.yi.org:6969/announce,http://bt.careland.com.cn:6969/announce,udp://11.rarbg.com/announce,udp://11.rarbg.com:80/announce,udp://tracker.coppersurfer.tk:6969/announce,udp://tracker.openbittorrent.com/announce,http://open.acgtracker.com:1096/announce,http://tracker1.wasabii.com.tw:6969/announce,udp://tracker.coppersurfer.tk:6969/announce,http://tracker.pow7.com/announce,udp://tracker.ex.ua:80/announce,udp://tracker.leechers-paradise.org:6969/announce,http://t.nyaatracker.com/announce,http://pow7.com/announce,http://share.camoe.cn:8080/announce,udp://208.67.16.113:8000/announce,udp://9.rarbg.me:2710/announce,udp://9.rarbg.com:2710/announce,http://tracker.opentrackr.org:1337/announce,http://bt2.careland.com.cn:6969/announce,udp://tracker.eddie4.nl:6969/announce,http://tracker.tiny-vps.com:6969/announce,udp://tracker.leechers-paradise.org:6969/announce,udp://9.rarbg.me:2710/announce,udp://tracker.grepler.com:6969/announce,http://tracker.skyts.net:6969/announce,udp://tracker.tiny-vps.com:6969/announce,udp://tracker.coppersurfer.tk:1337/announce,udp://168.235.67.63:6969/announce,http://t.bitlove.org/announce,udp://tracker.kicks-ass.net:80/announce,http://tracker.tfile.me/announce,udp://tracker.opentrackr.org:1337/announce,http://bt2.rutracker.cc/ann,http://mgtracker.org:2710/announce,http://tracker.yoshi210.com:6969/announce,udp://tracker.filetracker.pl:8089/announce,udp://tracker.ex.ua:80/announce,http://tracker.grepler.com:6969/announce,http://share.camoe.cn:8080/announce,http://tracker.filetracker.pl:8089/announce,http://tracker.kicks-ass.net:80/announce,udp://208.67.16.113:8000/announce,http://open.acgtracker.com:1096/announce,udp://9.rarbg.com:2710/announce,http://pow7.com/announce,udp://tracker.skyts.net:6969/announce,http://208.67.16.113:8000/announce,udp://208.67.16.113:8000/announce,http://tracker.openbittorrent.com:80/announce,http://tracker.publicbt.com:80/announce,http://tracker.prq.to/announce,http://open.acgtracker.com:1096/announce,http://tr.bangumi.moe:6969/announce,https://t-115.rhcloud.com/only_for_ylbud,http://btfile.sdo.com:6961/announce,http://exodus.desync.com:6969/announce,https://tr.bangumi.moe:9696/announce,http://open.nyaatorrents.info:6544/announce,http://share.camoe.cn:8080/announce,http://t.acg.rip:6699/announce,http://121.14.98.151:9090/announce,http://94.228.192.98/announce,http://bt.mp4ba.com:2710/announce
EOF
		}
	seedtime=30			#做种时间
	diskcache="30M"			#磁盘缓存
	fileallocation="none"		#磁盘预分配
	download_limit="1M"		#总体下载速度限制
	upload_limit="50K"		#总体上传速度限制
	rpc_user=""			#管理帐号,1.19后放弃
	rpc_passwd=""			#管理密码,1.19后放弃
	rpc_secret=""			#管理密码，1.19后使用
	btmaxpeers="0"			#每个种子最大peer数量,0为不限制
	maxthread="6"			#下载使用连接数
	maxjobs="3"			#同时开启任务数量
	rpclistenport='6800'

	cmd="aria2c -c -D --enable-rpc --rpc-listen-all=true --rpc-allow-origin-all --rpc-listen-port=$rpclistenport \
	--seed-time=$seedtime --conf-path=$aria2_configfile --dir=$aria2_downloadfolder \
	--input-file=$aria2_downloadlist --save-session=$aria2_downloadlist --disk-cache=$diskcache \
	--dht-file-path=$aria2_DHT --file-allocation=$fileallocation --http-accept-gzip=true\
	--max-overall-download-limit=$download_limit --max-overall-upload-limit=$upload_limit \
	--bt-max-peers=$btmaxpeers --split=$maxthread --max-connection-per-server=$maxthread \
	--max-concurrent-downloads=$maxjobs --listen-port=$tcp_port --dht-listen-port=$udp_port ";
	[ "$rpc_user" != "" ] && cmd=$cmd" --rpc-user=$rpc_user --rpc-passwd=$rpc_passwd ";
	[ "$rpc_secret" != "" ] && cmd=$cmd" --rpc-secret=$rpc_secret ";
	[ "`pgrep aria2c`" != "" ] && {
	stop
	sleep 3
	}
	echo 'starting...'
	eval "$cmd"
}
restart(){
	stop
	sleep 3	
	start
}

case "$1" in  
start)  
        start  
        ;;  
stop)  
        stop  
        ;;  
reload|force-reload|restart)  
        restart  
        ;;
status|pid)  
        pgrep aria2c  
        ;;
*)  
        echo $"Usage: $0 {start|stop|restart|pid}"  
        exit 1  
esac 
