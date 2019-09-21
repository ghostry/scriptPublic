#!/bin/sh
cd $(dirname $(readlink -f "$0"))
name="openvpn-server"
image="kylemanna/openvpn"
docker pull $image
docker stop $name
docker rm $name
docker run --name $name -v $PWD:/etc/openvpn -d -p 8027:1194/udp --cap-add=NET_ADMIN $image
docker ps
