pack = Packages.register
  name: 'xcode'
  platforms: ['darwin']
  applications: ['com.apple.dt.Xcode']
  description: 'Xcode IDE integration'

Settings.os = {terminalApplications: pack.applications()}
Settings.os = {editorApplications: pack.applications()}

pack.implement
  'editor:move-to-line-number': (input) ->
    @key 'l', 'command'
    if input?
      @delay 200
      @string input
      @delay 100
      @enter()
  'text-manipulation:move-line-up': ->
    @key '[', 'command option'
