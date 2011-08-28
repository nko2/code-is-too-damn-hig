require('nko')('YOe/SzwxAmx8J0UC')
require.paths.unshift(__dirname+"/lib")
require 'extensions'
require 'Connection'
require 'Map'
require 'Player'
io = require 'socket.io'
redis = require 'redis'
express = require('express')
#export NODE_ENV=production

global.REDIS = redis.createClient()
REDIS.flushall()


port = 3000
port = 80 if (process.env.NODE_ENV == 'production')

app = express.createServer()

app.use(express.static("#{__dirname}/public"))

app.listen(port)
global.socket_server = io.listen(app)
global.socket_server.sockets.on "connection", (socket)->
  connection = new Connection socket
  

gameTick = ()->
  Map.instance().nextRound()
  setTimeout (()-> gameTick()), 20000
gameTick()