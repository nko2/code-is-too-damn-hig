class global.Map
  constructor: () ->
    @size = 20
    @players = []
    @flowers = []
    @timeleft = 0
  
  addPlayer: (player) ->
    player.setPosition(this.getRandomPosition())
    @players.push player
    
  removePlayer: (player) ->
    @players.remove player
  
  getRandomPosition: ()->
    x = Math.floor(Math.random() * (@size - 1))
    y = Math.floor(Math.random() * (@size - 1))
    [x,y]
      
  setRandomFlowers: ->
    @flowers = for i in [1..10]
      this.getRandomPosition()
      
  getSetupData: ->
    all_players = @players
    players = {}
    for player in all_players
      players[player.name] = player.position
    {
      timeLeft: @timeleft, 
      flowersOnMap: @flowers,
      "players" : players
    }
    
  # Singleton
  _instance = null  
  @instance: =>
    _instance ||= new @