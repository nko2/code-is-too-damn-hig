class global.Map
  constructor: () ->
    @used_positions = []
    @size = 2
    @players = []
    @flowers = []
    @timeleft = 0
  
  addPlayer: (player) ->
    player.setPosition(@getRandomPosition())
    @players.push player
    
  removePlayer: (player) ->
    @players.remove player
  
  
  setRandomPlayerPositions: () ->
    player.setPosition(@getRandomPosition()) for player in @players
      
  setRandomFlowerPositions: ->
    @flowers = for i in [1..10]
      @getRandomPosition()
      
  getSetupData: ->
    all_players = @players
    players = {}
    for player in all_players
      players[player.name] = {position : player.position, score: player.score}
    {
      timeLeft: @timeleft, 
      flowersOnMap: @flowers,
      "players" : players
    }
    
  awardScores: ->
    for player in @players
      for flower in @flowers
        if _.isEqual(player.position, flower) then player.score += 1
  
  nextRound: ->
    @used_positions = []
    @setRandomPlayerPositions()
    @setRandomFlowerPositions()
    socket_server.sockets.emit "setup", @getSetupData()

  #Private
  getRandomPosition: ()->
    return if @used_positions.length == @size*@size
    pos = =>
      x = Math.round(Math.random() * (@size - 1))
      y = Math.round(Math.random() * (@size - 1))
      [x,y]
    
    random_position = pos()
    while _.detect(@used_positions, ((i) => _.isEqual(i, random_position))) != undefined
      random_position = pos()
    @used_positions.push random_position
    random_position

  # Singleton
  _instance = null  
  @instance: =>
    _instance ||= new @