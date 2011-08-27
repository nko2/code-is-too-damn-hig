require.paths.unshift(__dirname+"/lib")
require 'Connection'
require "Redis"

require('nko')('YOe/SzwxAmx8J0UC')
#export NODE_ENV=production

static = require 'node-static'
http = require 'http'
io = require 'socket.io'
redis = require 'redis'
global.REDIS = redis.createClient()
REDIS.flushall()

port = process.env.PORT || 3000

# HTTP Server
file = new static.Server('./public/')
server = http.createServer (request, response) ->
  request.addListener 'end', ->
    file.serve(request, response);

server.listen(port);
console.log "Running http server at port #{port}"



# Websockets Server
websocket_server = io.listen(server)



setup =  { timeLeft : 7, flowersOnMap : [[1,1], [3,3], [0,1], [1, 0]], players: [{ name: "Seivan", position: [10,10]}] }

websocket_server.sockets.on "connection", (socket)->
  connection = new Connection socket, setup
  

  

