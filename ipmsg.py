#!/usr/bin/env python
# -*- coding: utf-8 -*-

import socket, time, sys

botheader = '1_lbt6_0#128#305A3A52C610#0#0#0#4001#9:'
sendheader = ':告警机器人:robot:288:'

msg = sys.argv[2]
ip = sys.argv[1]
port = 2425

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.sendto((botheader + '%d'%int(time.time()) + sendheader + msg).decode('utf-8').encode('gbk'), (ip, port))
