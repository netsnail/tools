#!/bin/bash

cd `dirname $0`

pgrep redsocks || sudo ./redsocks
sudo iptables -t nat -F

[[ -n "$1" ]] && { sudo killall redsocks; exit 0; }

sudo iptables -t nat -A OUTPUT -d ip/32 -j RETURN
sudo iptables -t nat -A OUTPUT -d 127.0.0.0/8 -j RETURN
sudo iptables -t nat -A OUTPUT -d 10.0.0.0/8 -j RETURN
sudo iptables -t nat -A OUTPUT -d 172.16.0.0/16 -j RETURN
sudo iptables -t nat -A OUTPUT -d 192.168.0.0/16 -j RETURN
sudo iptables -t nat -A OUTPUT -p tcp -j REDIRECT --to-ports 12345
