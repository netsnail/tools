#!/usr/bin/env node
# tiger 05/26/2019

var http = require('http'), 
  fs = require('fs'), 
  url = require('url');
const { exec } = require('child_process');
var tts = '~/bin/ekho.sh'

http.createServer(function(req, rsp) {
  var query = url.parse(req.url, true).query
  var txt = query.txt
  var p = query.p || 0
  var a = query.a || 0
  var s = query.s || 0
  var filename = Math.random().toString(36).substr(2)
  var file = '/tmp/'+filename

  if (! txt) {
    rsp.end('txt, Send request to TTS server \n'
	  + 'p, Set delta pitch. Value range from -100 to 100 (percent) \n'
	  + 'a, Set delta volume. Value range from -100 to 100 (percent) \n'
	  + 's, Set delta speed. Value range from -50 to 300 (percent)\n'
	)
	return
  }

  var cmd = tts+' -togg -p'+p+' -a'+a+' -s'+s+' -o'+file+' '+txt
  console.log(cmd)

  exec(cmd).on('exit', (code) => {
    rsp.writeHead(200, {
        'Content-Type': 'application/ogg',
        'Content-Length': fs.statSync(file).size
    })

    fs.createReadStream(file).pipe(rsp)
    fs.unlink(file, () => {})
  })

}).listen(2000);
