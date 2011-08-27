require.paths.unshift(__dirname+"/lib")
require 'extensions'
require 'Connection'
require 'Map'
require 'Player'

require('nko')('YOe/SzwxAmx8J0UC')
#export NODE_ENV=production

static = require 'node-static'
http = require 'http'
io = require 'socket.io'
redis = require 'redis'
global.REDIS = redis.createClient()
REDIS.flushall()

port = 3000
port = 80 if (process.env.NODE_ENV == 'production')

file = new static.Server("#{__dirname}/public")

server = http.createServer (request, response) ->
  request.addListener 'end', ->
    file.serve(request, response);

server.listen port, () ->
  if process.getuid() == 0
    require('fs').stat __filename, (err, stats) ->
      return console.log(err) if (err)
      process.setuid(stats.uid)
console.log "Running http server at port #{port}"



# Websockets Server
websocket_server = io.listen(server)



setup =  { timeLeft : 7, flowersOnMap : [[1,1], [3,3], [0,1], [1, 0]], players: [{ name: "Seivan", position: [10,10]}] }

websocket_server.sockets.on "connection", (socket)->
  connection = new Connection socket, setup
  

  

