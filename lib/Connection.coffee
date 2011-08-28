class global.Connection

  constructor: (@socket) ->
    
    @socket.on "disconnect", =>
      if @player then @socket.broadcast.emit("playerDisconnected", @player.disconnected())    
            
    @socket.on "login", (name) =>
      @player = new Player(@socket)
      @player.login name, (valid) =>
        if valid
          Map.instance().addPlayer(@player)
          @socket.emit("setup", Map.instance().getSetupData())
          @socket.broadcast.emit("playerJoined", @player.joined())
        else
          @socket.emit("invalidName")

    @socket.on "moveTo", (data) =>
      position = (parseInt(i) for i in data)
      if Map.instance().canMoveTo(position)
        @player.moveTo(position)
        @socket.broadcast.emit("playerMoved", @player.moved())
      else
        @socket.emit("playerMoved", @player.moved())
      
  @broadcastSetup: ->
    socket_server.sockets.emit "setup", Map.instance().getSetupData()