require.paths.unshift(__dirname+"/lib")
require 'Connection'
require "Redis"


require('nko')('YOe/SzwxAmx8J0UC')
express = require('express')
#export NODE_ENV=production


io = require 'socket.io'
redis = require 'redis'

global.REDIS = redis.createClient()

port = process.env.PORT || 7777

app = express.createServer()

app.use(express.static("#{__dirname}/public"))

app.listen(port)

websocket = require('socket.io').listen(app)

websocket.sockets.on "connection", (socket)->
  console.log "CONNECTION"
  socket.emit "message", "FUCKING PIECE OF SHIT"
  socket.emit "news", "NEWS PIECE OF SHIT"

