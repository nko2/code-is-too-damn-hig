class global.Map
  constructor: () ->
    @size = 20
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
      [10,10]
      
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
    @setRandomPlayerPositions()
    @setRandomFlowerPositions()
    socket_server.sockets.emit "setup", @getSetupData()

  #Private
  getRandomPosition: ()->
    x = Math.floor(Math.random() * (@size - 1))
    y = Math.floor(Math.random() * (@size - 1))
    [x,y]

  # Singleton
  _instance = null  
  @instance: =>
    _instance ||= new @