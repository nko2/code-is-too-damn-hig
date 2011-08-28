class global.Player
   
  constructor: (@socket) ->
    @position = [13,51]
    @score = 0
  
  setName: (name, cb) ->
    REDIS.sadd "player:names", name, (error, resp) =>
      isValid = (parseInt(resp) == 1)
      if isValid 
        @name = name
      cb(isValid)
  
  setPosition: (data) =>
    @position = (parseInt(i) for i in data)
    
  
  disconnected: () =>
    if @name 
      REDIS.srem "player:names", @name
      Map.instance().removePlayer(this)
    return @name
  
  
    
  info: () =>
    { name:@name, position: @position }
        
  setup: => @info()

  joined: => @info()
  
  moved: => @info()
    
      

