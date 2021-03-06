require('nko')('YOe/SzwxAmx8J0UC')
require.paths.unshift(__dirname+"/lib")

require 'extensions'

require 'Connection'
require 'Map'
require 'Player'
require 'Bot'

io = require 'socket.io'
redis = require 'redis'
express = require('express')
#export NODE_ENV=production

global._ = require('underscore')
global.REDIS = redis.createClient()

REDIS.flushall()

port = 3000
port = 80 if (process.env.NODE_ENV == 'production')

app = express.createServer()

publicDir = "#{__dirname}/public/"
# // coffeeDir = "#{__dirname}/game/"
# // app.use express.compiler(src: coffeeDir, dest: publicDir, enable: ['coffeescript'])
app.use express.static(publicDir)

app.listen(port)
global.socket_server = io.listen(app)
global.socket_server.sockets.on "connection", (socket)->
  connection = new Connection socket
  


gameTick = ()->
  if Map.instance().humanPlayers().length == 1
    if Map.instance().botPlayers().length == 0 
      Map.instance().addBots()
  else
    Map.instance().removeBots()
    
  Map.instance().awardScores()
  Map.instance().nextRound()
  Connection.broadcastSetup()
  setTimeout (()-> gameTick()), 5000
gameTick()
