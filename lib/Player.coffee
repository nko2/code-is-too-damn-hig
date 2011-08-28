class global.Player
   
  constructor: (@socket) ->
    @position = [0,0]
    @score = 0

  
  login: (name, cb) ->
    REDIS.sadd "player:names", name, (error, resp) =>
      isValid = (parseInt(resp) == 1)
      if isValid 
        @name = name
      cb(isValid)
  
  moveTo: (position) =>
    @position = position
    
  
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
    
      

