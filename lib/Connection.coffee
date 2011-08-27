class global.Connection
  constructor: (@socket) ->
    @socket.on "hello", () =>
      this.sayHello()
  
  sayHello: ->
    @socket.emit("hello")