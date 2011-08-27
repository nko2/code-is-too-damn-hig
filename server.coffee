`require('nko')('YOe/SzwxAmx8J0UC'); // team code
//export NODE_ENV=production`

static = require 'node-static'
http = require 'http'

file = new static.Server('./public')
server = http.createServer (request, response) ->
  request.addListener 'end', ->
    file.serve(request, response);

port = process.env.PORT || 7777
server.listen(port);
console.log "Running server at port #{port}"