#!/bin/bash
python gocn.py
scp dnsmasq.conf root@192.168.1.1:/etc/dnsmasq.conf
ssh root@192.168.1.1 '/etc/init.d/dnsmasq restart;'
