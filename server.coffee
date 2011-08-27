require('nko')('YOe/SzwxAmx8J0UC')
#export NODE_ENV=production

static = require 'node-static'
http = require 'http'
io = require 'socket.io'

port = 80 #process.env.PORT || 7777

# HTTP Server
file = new static.Server('./public')
server = http.createServer (request, response) ->
  request.addListener 'end', ->
    file.serve(request, response);

server.listen(port);
console.log "Running http server at port #{port}"

# Websockets Server
websocket_server = io.listen(server)


websocket_server.sockets.on "connection", (socket)->
  console.log("Hello #{socket}")
