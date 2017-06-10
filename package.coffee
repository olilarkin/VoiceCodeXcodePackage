# if there was a previous instance, call its close method
global._xcode_connector?.close()

XcodeConnector = require './xcode_connector'

pack = Packages.register
  name: 'xcode'
  platforms: ['darwin']
  applications: ['com.apple.dt.Xcode']
  description: 'Xcode IDE integration'

Settings.os = {terminalApplications: pack.applications()}
Settings.os = {editorApplications: pack.applications()}

pack.previous = {id: 'initial-state'}

pack.getCommand = ->
  return pack.previous

pack.connector = new XcodeConnector(pack.getCommand)
global._xcode_connector = pack.connector

pack.implement
  'editor:move-to-line-number': (input) ->
    pack.previous =
      id: 'editor:move-to-line-number'
      line: input
    @key 'v', 'control  option'
  'editor:select-line-number': (input) ->
    pack.previous =
      id: 'editor:select-line-number'
      line: input
    @key 'v', 'control  option'
  # 'editor:move-to-line-number-and-way-right':  ->
  #   pack.previous =
  #     id: 'editor:select-line-number'
  #   @key 'v', 'control  option'
  # 'editor:move-to-line-number-and-way-left':  ->
  #   pack.previous =
  #     id: 'editor:select-line-number'
  #   @key 'v', 'control  option'
  # 'editor:insert-under-line-number':  ->
  #   pack.previous =
  #     id: 'editor:select-line-number'
  #   @key 'v', 'control  option'
  # 'editor:expand-selection-to-scope':  ->
  #   pack.previous =
  #     id: 'editor:select-line-number'
  #   @key 'v', 'control  option'
  # 'editor:click-expand-selection-to-scope':  ->
  #   pack.previous =
  #     id: 'editor:select-line-number'
  #   @key 'v', 'control  option'
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
      first: first
      last: last
    @key 'v', 'control  option'
  # 'editor:extend-selection-to-line-number':  ->
  #   pack.previous =
  #     id: 'editor:select-line-number'
  #   @key 'v', 'control  option'
  # 'editor:insert-from-line-number':  ->
  #   pack.previous =
  #     id: 'editor:select-line-number'
  #   @key 'v', 'control  option'
  # 'editor:toggle-comments':  ->
  #   pack.previous =
  #     id: 'editor:select-line-number'
  #   @key 'v', 'control  option'
  # 'editor:insert-code-template':  ->
  #   pack.previous =
  #     id: 'editor:select-line-number'
  #   @key 'v', 'control  option'
  # 'editor:complete-code-template'
  #   pack.previous =
  #     id: 'editor:select-line-number'
  #   @key 'v', 'control  option'

  # 'text-manipulation:move-line-up': ->
  #   @key '[', 'command option'

  # 'selection:previous-occurrence'
  # 'selection:next-occurrence'
  # 'selection:extend-to-next-occurrence'
  # 'selection:extend-to-previous-occurrence'
  # 'selection:previous-selection-occurrence'
  # 'selection:next-selection-occurrence'
  # 'selection:range-upward'
  # 'selection:range-downward'
  # 'selection:range-on-current-line'
  # 'selection:previous-word-by-surrounding-characters'
  # 'selection:next-word-by-surrounding-characters'
