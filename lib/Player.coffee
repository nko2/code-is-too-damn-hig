class global.Player
   
  constructor: (@socket) ->
    
  
  setName: (name, cb) ->
    REDIS.sadd "player:names", name, (error, resp) =>
      isValid = (parseInt(resp) == 1)
      if isValid 
        @name = name
        @valid = true
      cb(isValid)
      

  logout: () =>
    if @name then REDIS.srem "player:names", @name
    
  join: () =>
    { name:@name, position:[11,11] }
    
    
      

