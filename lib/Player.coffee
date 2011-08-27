class global.Player
   
  constructor: (@socket) ->
    @position = [13,51]
  
  setName: (name, cb) ->
    REDIS.sadd "player:names", name, (error, resp) =>
      isValid = (parseInt(resp) == 1)
      if isValid 
        @name = name
        @valid = true
      cb(isValid)
  
  setPosition: (data) =>
    @position = data
  
  disconnected: () =>
    if @name then REDIS.srem "player:names", @name
    return @name
  
  
    
  info: () =>
    
    { name:@name, position: @position }
    
  setup:  => @info()

  joined: => @info()
  
  moved: => @info()
    
      

