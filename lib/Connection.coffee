require './Player'

class global.Connection

  constructor: (@socket) ->
    
    @socket.on "disconnect", =>
      @player.logout()
            
    @socket.on "name", (data) =>
      @player = new Player(@socket)
      @player.setName data, @validateName
      
    
    
  
  validateName : (valid) =>
      if valid
        @socket.emit("name", "true")
      else
        @socket.emit("name", "false")
    


    

  
    