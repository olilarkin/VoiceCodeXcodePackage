ws = require 'ws'

module.exports = class XcodeConnector
  # singleton
  instance = null
  constructor: (getCommand) ->
    return instance if instance?
    @getCommand = getCommand
    @webSocketServer = new ws.Server(port: 8081)
    @webSocketServer.on 'connection', (socket) =>
      console.log("XcodeConnector connected")
      socket.send(JSON.stringify(getCommand()))
      socket.on 'message', (message) =>
        if message == 'getCommand'
          socket.send(JSON.stringify(getCommand()))
    instance = @
    console.log("XcodeConnector listening on port " + @webSocketServer.options.port)
  close: ->
    @webSocketServer.close()
