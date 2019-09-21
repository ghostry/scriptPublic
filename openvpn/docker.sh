#!/bin/sh
cd $(dirname $(readlink -f "$0"))
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
echo '{"log-opts": {"max-size":"5m", "max-file":"1"}}' > /etc/docker/daemon.json
systemctl enable docker
systemctl start docker
docker ps
