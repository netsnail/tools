#!/usr/bin/env python2.7
#encode=utf-8

import random, os, re
import commands, urllib
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer

tts = '/bin/ekho.sh'
tts_help = '''Syntax: http://ip/?txt=
  txt, Send request to TTS server
  p, Set delta pitch. Value range from -100 to 100 (percent)
  a, Set delta volume. Value range from -100 to 100 (percent)
  s, Set delta speed. Value range from -50 to 300 (percent)
'''

class MyHandler(BaseHTTPRequestHandler):
 
  def getparam(self, name):
    m = re.match(r'.*'+name+'=([^&]*)', self.path)
    return m and m.group(1) or '0'

  def do_GET(self):
    txt = self.getparam('txt')
    if txt == '0':
      self.send_response(200)
      self.send_header('Content-Type', 'text/plain')
      self.end_headers()
      self.wfile.write(tts_help)
      return

    p = self.getparam('p')
    a = self.getparam('a')
    s = self.getparam('s')

    mfile='/tmp/tts-'+str(random.randint(10000,99999))
    cmd = tts+' -togg -p'+p+' -a'+a+' -s'+s+' -o'+mfile+' '+urllib.unquote(txt)
    print cmd
    (status, output) = commands.getstatusoutput(cmd)

    f = open(mfile, 'rb')
    self.send_response(200)
    self.send_header('Content-Type', 'application/ogg')
    self.end_headers()
    self.wfile.write(f.read())
    f.close()

    os.unlink(mfile)

def main():
  try:
    server = HTTPServer(('0.0.0.0', 8000), MyHandler)
    server.serve_forever()
  except KeyboardInterrupt:
    server.socket.close()

if __name__ == '__main__':
  main()
