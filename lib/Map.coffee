class global.Map
  constructor: () ->
    @used_positions = []
    @size = 8
    @players = []
    @flowers = []
    @timeleft = 0
  
  addPlayer: (player) ->
    player.moveTo(@getRandomPosition())
    @players.push player
    
  removePlayer: (player) ->
    @players.remove player
  
  canMoveTo: (position) ->
    return false if !(@size > position[0] >= 0 && @size > position[1] >= 0)
    found = _.detect @players, (player) ->
      _.isEqual(player.position, position)
    found == undefined # true if not found
    
  setRandomPlayerPositions: () ->
    player.moveTo(@getRandomPosition()) for player in @players
      
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