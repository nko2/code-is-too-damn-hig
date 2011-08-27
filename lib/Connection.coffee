class global.Connection

  constructor: (@socket, @setup) ->
    
    @socket.on "disconnect", =>
      if @player then @socket.broadcast.emit("playerDisconnected", @player.disconnected())    
            
    @socket.on "setName", (data) =>
      @player = new Player(@socket)
      @player.setName data, @validateName

    @socket.on "setPosition", (data) =>
      @player.setPosition(data)
      @socket.broadcast.emit("playerMoved", @player.moved())
      
    
  
  validateName : (valid) =>
<<<<<<< Updated upstream
      if valid
        @socket.emit("setup", [@setup, @player.setup()])
        @socket.broadcast.emit("playerJoined", @player.joined())
      else
        @socket.emit("setName", "false")
    
=======
    if valid
      @socket.emit("setup", JSON.stringify([@setup, @player.join()]))
      @socket.broadcast.emit("newPlayerJoined", JSON.stringify(@player.join()))
    else
      @socket.emit("name", "false")

>>>>>>> Stashed changes


    


  
      
    

  
    