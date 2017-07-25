# if there was a previous instance, call its close method
global._xcode_connector?.close()

XcodeConnector = require './xcode_connector'

pack = Packages.register
  name: 'xcode'
  platforms: ['darwin']
  applications: ['com.apple.dt.Xcode']
  description: 'Xcode IDE integration'

# Settings.os = {terminalApplications: pack.applications()}
Settings.os = {editorApplications: pack.applications()}

pack.previous = {id: 'initial-state'}

pack.getCommand = ->
  return pack.previous

pack.connector = new XcodeConnector(pack.getCommand)
global._xcode_connector = pack.connector

pack.commands
  'jump-to-selection': ->
    enabled: true
    action: ->
      @key 'l', 'command shift'

pack.implement
  # 'os:get-selected-text': ->
  #   pack.previous =
  #     id: 'os:get-selected-text'
  #   fiber = Fiber.current
  #   global._xcode_callbacks.push(-> fiber.run())
  #   @key 'v', 'control option'
  #   Fiber.yield()
  #   return pack.connector.selectedText

  'object:next': ->
    @key 'right', 'command control'
  'object:previous': ->
    @key 'left', 'command control'
  'object:duplicate': ->
    pack.previous =
      id: 'object:duplicate'
    @key 'v', 'control option'

  # 'delete:lines': ({first, last} = {}) ->

  'editor:move-to-line-number': (input) ->
    if input?
      pack.previous =
        id: 'editor:move-to-line-number'
        line: input
      @key 'v', 'control option'
  'editor:select-line-number': (input) ->
    if input?
      pack.previous =
        id: 'editor:select-line-number'
        line: input
      @key 'v', 'control option'
  'editor:move-to-line-number-and-way-right':  (input) ->
    if input?
      pack.previous =
        id: 'editor:move-to-line-number-and-way-right'
        line: input
      @key 'v', 'control option'
  'editor:move-to-line-number-and-way-left':  (input) ->
    if input?
      pack.previous =
        id: 'editor:move-to-line-number-and-way-left'
        line: input
    @key 'v', 'control option'
  'editor:insert-under-line-number':  (input) ->
    if input?
      pack.previous =
        id: 'editor:insert-under-line-number'
        line: input
      @key 'v', 'control option'
  'editor:expand-selection-to-scope':  ->
    pack.previous =
      id: 'editor:expand-selection-to-scope'
    @key 'v', 'control option'
  'editor:click-expand-selection-to-scope':  ->
    pack.previous =
      id: 'editor:click-expand-selection-to-scope'
    @key 'v', 'control option'
  'editor:select-line-number-range': (input) ->
    if input?
      number = input.toString()
      length = Math.floor(number.length / 2)
      first = number.substr(0, length)
      last = number.substr(length, length + 1)
      first = parseInt(first)
      last = parseInt(last)
      if last < first
        temp = last
        last = first
        first = temp
      pack.previous =
        id: 'editor:select-line-number-range'
        line: first
        lastline: last
    @key 'v', 'control option'
  'editor:extend-selection-to-line-number': (input) ->
    if input?
      pack.previous =
        id: 'editor:extend-selection-to-line-number'
        line: input
      @key 'v', 'control option'
  'editor:insert-from-line-number': (input) ->
    if input?
      pack.previous =
        id: 'editor:insert-from-line-number'
        line: input
      @key 'v', 'control option'
  'editor:toggle-comments':  ->
    @key '/', 'command'
  'editor:insert-code-template':  ->
    @key '2', 'command control option'
  # 'editor:complete-code-template'
  #   pack.previous =
  #     id: 'editor:complete-code-template'
  #   @key 'v', 'control option'
  #
  'text-manipulation:move-line-up': ->
    @key '[', 'command option'
  'text-manipulation:move-line-down': ->
    @key '', 'command option'

# 'selection:previous-occurrence': (input) ->
  # if input?
  #   pack.previous =
  #     id: 'editor:insert-from-line-number'
  #     line: input
  #   @key 'v', 'control option'
# 'selection:next-occurrence': (input) ->
  # if input?
  #   pack.previous =
  #     id: 'editor:insert-from-line-number'
  #     line: input
  #   @key 'v', 'control option'
# 'selection:extend-to-next-occurrence'
# 'selection:extend-to-previous-occurrence'

  'selection:previous-selection-occurrence': ->
    @key 'e', 'command'
    @key 'g', 'command shift'
  'selection:next-selection-occurrence': ->
    @key 'e', 'command'
    @key 'g', 'command'
  'selection:range-upward': ->
    @key 'up', 'shift'
  'selection:range-downward': ->
    @key 'down', 'shift'
 # 'selection:range-on-current-line': (input) ->
 #  if input?
 #    pack.previous =
 #      id: 'selection:range-on-current-line'
 #      line: input
 #    @key 'v', 'control option'
# 'selection:previous-word-by-surrounding-characters'
# 'selection:next-word-by-surrounding-characters'
