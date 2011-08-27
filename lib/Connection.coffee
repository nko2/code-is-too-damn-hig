class global.Connection
  constructor: (@socket) ->
    @socket.on "disconnect", =>
      this.logout()
    @socket.on "name", (data) =>
      this.setName data, (valid) =>
        if valid
          @socket.emit("name", "true")
        else
          @socket.emit("name", "false")
  logout: ->
    REDIS.srem "used_names", @name
  setName: (name, cb) ->
    @name = name
    REDIS.sadd "used_names", name, (error, resp) =>
      cb(parseInt(resp, 10) == 1)
      