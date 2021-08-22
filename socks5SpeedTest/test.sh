#!/bin/bash
cd $(dirname $(readlink -f "$0"))
timeOut=5
socks5List=(
"192.168.1.7:9012"
"192.168.1.7:9013"
"192.168.1.7:9014"
"192.168.1.7:9015"
"192.168.1.7:9016"
)
testUrl='https://www.google.com/search?q=google&oq=goo&aqs=chrome.1.69i57j0i433i512j0i131i433i512j69i60l3j69i65l2.2729j0j7&sourceid=chrome&ie=UTF-8'
tmpFile=/tmp/socks5SpeedTest.log
rm -f $tmpFile
testRun(){
    printf "%s\t%s\t" "$1" "$2"
    printf "%.f" `curl -m $timeOut -x "socks5://$2/" \
        -s -w '%{speed_download}' \
        $testUrl -o /dev/null `
    printf "\tByte/s\n"
}
for i in "${!socks5List[@]}";
do
    testRun "$i" "${socks5List[$i]}"|tee -a $tmpFile
done
echo ""
echo "排序后"
echo ""
sort -n -r -k 3 -t $'\t' $tmpFile
