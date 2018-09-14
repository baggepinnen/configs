# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"



atom.commands.add 'atom-text-editor', 'custom:hide-docs', ->
  atom.workspace.getLeftDock().hide()
  atom.workspace.getRightDock().hide()
  atom.workspace.getBottomDock().hide()

atom.commands.add 'atom-text-editor', 'custom:docstring', ->
  editor = atom.workspace.getActiveTextEditor()
  editor.selectLinesContainingCursors()
  text = editor.getSelectedText()
  editor.moveUp()
  text = text.replace /function /, ""
  kwarg_split = text.split ";" # kwargs come after a ;
  if kwarg_split.length == 1 # Didn't find kwargs
    # editor.insertText("if -- no kwargs")
    kwargs = ""
    args = text.match( / *([\w\s\:=]+?)[;,\)]/g  ) # Match the first paren (, then match everything that ends with either of , ; )
    if args == null # Found no args either
      arg_text = ""
    else
      arg_text = "\# Arguments\n"
      for arg in args
        arg_text = "#{arg_text}- `#{arg}` \n"
    kwarg_text = ""
  else
    # editor.insertText("else -- found kwargs")
    arg_text = kwarg_split[0]
    args = arg_text.match( / *([\w\s\:=]+?)[;,\)]/g  )
    if args == null # Found no args
      arg_text = ""
    else
      arg_text = "\# Arguments\n"
      for arg in args
        arg_text = "#{arg_text}- `#{arg}` \n"
    kwarg_text = kwarg_split[1]
    kwargs = kwarg_text.match( / *([\w\s\:=]+)[;,\)]/g  )
    kwarg_text = "\n\# Keyword Arguments\n"
    for arg in kwargs
      kwarg_text = "#{kwarg_text}- `#{arg}` \n"

  # editor.insertText(name)
  docstring = "\"\"\"\n    #{text}\n#{arg_text}#{kwarg_text}\n\"\"\""
  editor.insertText(docstring)
  editor.moveUp(2)
  editor.moveToBeginningOfLine()
