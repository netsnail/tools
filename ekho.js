#!/usr/bin/env node

var http = require('http'),
  fs = require('fs'),
  url = require('url');
const { exec } = require('child_process');
var speak = '~/apps/ekho/bin/ekho.sh'

http.createServer(function(req, rsp) {
  var query = url.parse(req.url, true).query
  var txt = query.t
  var filename = Math.random().toString(36).substr(2)
  var file = '/tmp/'+filename

  rsp.end = (data) => {
    fs.unlink(file, () => {})
  }

  exec(speak+' -o '+file+' '+txt).on('exit', (code) => {
    var stat = fs.statSync(file)

    rsp.writeHead(200, {
        'Content-Type': 'audio/mpeg',
        'Content-Length': stat.size
    })

    fs.createReadStream(file).pipe(rsp)
  })

}).listen(2000);
