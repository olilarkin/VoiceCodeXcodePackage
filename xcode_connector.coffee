ws = require 'ws'

global._xcode_callbacks = []

module.exports = class XcodeConnector
  # singleton
  instance = null
  constructor: (getCommand) ->
    return instance if instance?
    @getCommand = getCommand
    @selectedText = ""
    @webSocketServer = new ws.Server(port: 8081)
    @webSocketServer.on 'connection', (socket) =>
      console.log("XcodeConnector connected")
      socket.send(JSON.stringify(getCommand()))
      socket.on 'message', (message) =>
        parsedMessage = JSON.parse(message)
        if parsedMessage.id == 'getCommand'
          socket.send(JSON.stringify(getCommand()))
        if parsedMessage.id == 'jumpToSelection'
          emit 'commandsShouldExecute', [{command: 'xcode:jump-to-selection', arguments: null}]
        if parsedMessage.id == 'setSelectedText'
          @selectedText = parsedMessage.text
          global._xcode_callbacks.pop().call()

    instance = @
    console.log("XcodeConnector listening on port " + @webSocketServer.options.port)
  close: ->
    @webSocketServer.close()
