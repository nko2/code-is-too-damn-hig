require './Player'

class global.Connection

  constructor: (@socket, @setup) ->
    
    @socket.on "disconnect", =>
      @player.logout()
            
    @socket.on "name", (data) =>
      @player = new Player(@socket)
      @player.setName data, @validateName
      
    
  
  validateName : (valid) =>
      if valid
        @socket.emit("setup", JSON.stringify([@setup, @player.join()]))
        @socket.broadcast.emit("newPlayerJoined", JSON.stringify(@player.join()))
      else
        @socket.emit("name", "false")
    


    


  
      
    

  
    