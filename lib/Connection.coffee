class global.Connection

  constructor: (@socket) ->
    
    @socket.on "disconnect", =>
      if @player then @socket.broadcast.emit("playerDisconnected", @player.disconnected())    
            
    @socket.on "setName", (data) =>
      @player = new Player(@socket)
      @player.setName data, @validateName

    @socket.on "setPosition", (data) =>
      @player.setPosition(data)
      @socket.broadcast.emit("playerMoved", @player.moved())
      
    
  
  validateName : (valid) =>
    if valid
      @socket.emit("setup", Map.instance().getSetupData())
      @socket.broadcast.emit("playerJoined", @player.joined())
    else
      @socket.emit("setName", "false")