#!/bin/sh
cd $(dirname $(readlink -f "$0"))
image="kylemanna/openvpn"
DNSNAME=`curl ipinfo.io/ip`
docker run -v $PWD:/etc/openvpn --rm --user $(id -u):$(id -g) $image ovpn_genconfig -u udp://$DNSNAME -b
docker run -v $PWD:/etc/openvpn --rm --user $(id -u):$(id -g) -it $image ovpn_initpki
docker run -v $PWD:/etc/openvpn --rm --user $(id -u):$(id -g) -it $image easyrsa build-client-full CLIENTNAME nopass
docker run -v $PWD:/etc/openvpn --rm --user $(id -u):$(id -g) $image ovpn_getclient CLIENTNAME >$DNSNAME.ovpn