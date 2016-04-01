StepJumper = require './step-jumper'
{CompositeDisposable} = require 'atom'

module.exports =
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'behave-step:jump-to-step': => @jump()

  jump: ->
    currentLine = atom.workspace.getActiveTextEditor().getLastCursor().getCurrentBufferLine()
    stepJumper = new StepJumper(currentLine)
    return unless stepJumper.firstWord
    options =
      paths: ["**/steps/**/*.py"]
    atom.workspace.scan stepJumper.stepTypeRegex(), options, (match) ->
      if foundMatch = stepJumper.checkMatch(match)
        [file, line] = foundMatch
        console.log("Found match at #{file}:#{line}")
        atom.workspace.open(file).then (editor) -> editor.setCursorBufferPosition([line, 0])

  deactivate: ->
    @subscriptions.dispose()
