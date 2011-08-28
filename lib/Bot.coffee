class global.Bot extends Player
  constructor: ->
    @flower = null
    setTimeout =>
      @aiMove()
    , (Math.random()*500) + 200
    
  aiMove: ()->
    @flower = _.detect Map.instance().flowers, (f) =>
      _.isEqual(f, @flower)
    @flower ||= @randomFlowerPosition()
    
    if !_.isEqual(@position, @flower)
      to = [@position[0],@position[1]] 
      if to[0] != @flower[0]
        if to[0] < @flower[0]
          to[0]++
        else
          to[0]--
      else if to[1] != @flower[1]
        if to[1] < @flower[1]
          to[1]++
        else
          to[1]--
      if !_.isEqual(to, @position) && Map.instance().canMoveTo(to)
        this.moveTo(to)
        socket_server.sockets.emit "playerMoved", @moved()
    setTimeout =>
      @aiMove()
    , (Math.random()*500) + 200


  # Private
  
  randomFlowerPosition: ->
    flowers = Map.instance().flowers
    rand = Math.round(Math.random() * (flowers.length - 1))
    flowers[rand]