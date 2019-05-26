#!/usr/bin/env python
#coding=utf-8

import SimpleHTTPServer, SocketServer
import re, commands, urllib2, urllib

class MyHandler(SimpleHTTPServer.SimpleHTTPRequestHandler):

    def param_handle(self, value):
        w = re.match(r'.*w=([^&]*)', value).group(1)
        print w
        (status, output) = commands.getstatusoutput('ls')
        print status, output
        post_data = urllib.urlencode({})
        resp = urllib2.urlopen('http://www.baidu.com', post_data)
        print resp.read()

    def do_GET(self):
        self.param_handle(self.path)
        return SimpleHTTPServer.SimpleHTTPRequestHandler.do_GET(self)

    def do_POST(self):
        data = self.rfile.read(int(self.headers['Content-Length']))
        self.param_handle(data)
        return SimpleHTTPServer.SimpleHTTPRequestHandler.do_GET(self)

httpd = SocketServer.TCPServer(('0.0.0.0', 8080), MyHandler)
httpd.serve_forever()
