import os, osproc, strformat, terminal

proc touchCmd(path: string)
proc generateNewFile(fileType, name: string)

proc generate*(fileType: string, name: string): int =
  result = 0
  if (
    fileType == "atoms" or
    fileType == "molecules" or
    fileType == "organisms" or
    fileType == "templates"):
    generateNewFile(fileType, name)
  else:
    setForegroundColor(stdout, fgRed)
    echo "🚨  Error! Illegal file type specified!"
    resetAttributes(stdout)
    echo fmt"💀  Failed to create {fileType} file "
    result = 1

proc touchCmd(path: string) =
  discard execCmd "touch " & path

proc generateNewFile(fileType, name: string) =
  let incompleteNewPath = fmt"/{fileType}/{name}.nim"
  let projectPath: string = os.getCurrentDir()
  let componentsDirPath: string = projectPath & "/src/components"
  let newPath = componentsDirPath & incompleteNewPath
  echo fmt"📄  Generating {incompleteNewPath}..."
  touchCmd(newPath)
  var newFile: File = open(newPath, FileMode.fmWrite)
  newFile.writeLine fmt"""
import Blackvas

settings:
  name = {name}

shapes:
  discard

exportShape:
  discard
"""
  echo fmt"🎉  Successfully created {fileType} file "