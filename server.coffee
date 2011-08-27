require('nko')('YOe/SzwxAmx8J0UC')
#export NODE_ENV=production
# 
# static = require 'node-static'
# http = require 'http'
# io = require 'socket.io'
# 
# port = process.env.PORT || 7777
# 
# # HTTP Server
# file = new static.Server('./public')
# server = http.createServer (request, response) ->
#   request.addListener 'end', ->
#     file.serve(request, response);
# 
# server.listen(port);
# console.log "Running http server at port #{port}"
# 
# # Websockets Server
# websocket = io.listen(server)
# 
# 
# websocket.sockets.on "connection", (socket)->
#   console.log("Hello #{socket}")
#   socket.emit "message", "FUCKING PIECE OF SHIT"

app = require('http').createServer(handler)
io = require('socket.io').listen(app)
fs = require('fs')
app.listen(80)

handler =  handler (req, res) ->
  fs.readFile __dirname + '/public/index.html', (err, data) ->
    if (err)
      res.writeHead(500);
      return res.end('Error loading index.html')

    res.writeHead(200)
    res.end(data)



io.sockets.on 'connection', (socket) ->
  socket.emit('news', { hello: 'world' })
  socket.on 'my other event', (data) ->
    console.log(data)
