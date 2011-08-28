class global.Map
  constructor: () ->
    @size = 20
    @players = []
    @flowers = []
    @timeleft = 0
  
  addPlayer: (player) ->
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
    {
      timeLeft: @timeleft, 
      flowersOnMap: @flowers, 
      players: player.info() for player in all_players
    }
    
  nextRound: ->
    
    socket_server.sockets.emit "setup", @getSetupData()
  # Singleton
  _instance = null  
  @instance: =>
    _instance ||= new @