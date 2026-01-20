import os, osproc, terminal, colors, strformat, json

proc echoGenerating(fileName: string)
proc genDirAndFileAndEcho(projectPath, dirPath, fileName: string)
proc mkdirCmd(path: string)
proc touchCmd(path: string)
proc getNimbleFileContent(version, author, description: string): string

proc create*(appName: string): int =
  enableTrueColors()
  setForegroundColor(stdout, parseColor("#ffa500"))
  echo "\e[1m" & "Blackvas CLI v0.1.0" & "\e[0m"
  resetAttributes(stdout)
  let projectPath: string = os.getCurrentDir() & "/" & appName
  echo "✨ Creating project in " & projectPath & "."

  stdout.write "✏️  Please enter author name.  "
  var enteredAuthor: string = stdin.readLine
  while (enteredAuthor == ""):
    stdout.write "Please enter author name.  "
    enteredAuthor = stdin.readLine
  
  stdout.write "✏️  Please enter description. [default: A new awesome Blackvas project]  "
  var enteredDescription: string = "A new awesome Blackvas project"
  enteredDescription = stdin.readLine
  if (enteredDescription == ""):
    enteredDescription = "A new awesome Blackvas project"
  
  stdout.write "✏️  Please enter version. [default: 0.1.0]  "
  var enteredVersion: string = "0.1.0"
  enteredVersion = stdin.readLine
  if (enteredVersion == ""):
    enteredVersion = "0.1.0"

  stdout.write "❓ Would you adopt Atomic Design? [y/n]  "
  var yn: string = stdin.readLine
  while (yn != "y" and yn != "n"):
    stdout.write "Please enter y or n.  "
    yn = stdin.readLine
  var atomicDesign = $(yn == "y")

  echo ""
  mkdirCmd(projectPath)
  let nimbleFilePath = "/" & appName & ".nimble"
  touchCmd(projectPath & nimbleFilePath)
  echoGenerating(nimbleFilePath)
  var rootNimFile: File = open(projectPath & nimbleFilePath, FileMode.fmWrite)
  rootNimFile.writeLine getNimbleFileContent(enteredVersion, enteredAuthor, enteredDescription)

  mkdirCmd(projectPath & "/src")
  let rootNimProgramFilePath = "/src/" & appName & ".nim"
  touchCmd(appName & rootNimProgramFilePath)
  echoGenerating(rootNimProgramFilePath)

  const blackvasJsonPath = "/blackvas.json"
  touchCmd(appName & blackvasJsonPath)
  echoGenerating(blackvasJsonPath)
  var blackvasJsonFile: File = open(projectPath & blackvasJsonPath, FileMode.fmWrite)
  let blackvasJson = %* {
    "name": appName,
    "design": {
      "AtomicDesign": atomicDesign
    }
  }
  blackvasJsonFile.writeLine json.pretty(blackvasJson)

  if (yn == "y"):
    mkdirCmd(projectPath & "/src/components")
    genDirAndFileAndEcho(projectPath, "/src/components/atoms", "/atom.nim")
    genDirAndFileAndEcho(projectPath, "/src/components/molecules", "/molecule.nim")
    genDirAndFileAndEcho(projectPath, "/src/components/organisms", "/organism.nim")
    genDirAndFileAndEcho(projectPath, "/src/components/templates", "/template.nim")
    genDirAndFileAndEcho(projectPath, "/src/views", "/hello_blackvas.nim")

  echo ""
  stdout.write fmt"🎉 Successfully created project "
  setForegroundColor(stdout, fgRed)
  stdout.write appName
  resetAttributes(stdout)
  echo "."
  echo "👉  Get started with the following commands:"
  echo "    $ cd ", appName
  echo "    $ blackvas_cli serve"

  return 0

proc echoGenerating(fileName: string) =
  echo fmt"📄  Generating {fileName}..."

proc genDirAndFileAndEcho(projectPath, dirPath, fileName: string) =
  mkdirCmd(projectPath & dirPath)
  touchCmd(projectPath & dirPath & fileName)
  echoGenerating(dirPath & fileName)

proc mkdirCmd(path: string) =
  discard execCmd "mkdir " & path

proc touchCmd(path: string) =
  discard execCmd "touch " & path

proc getNimbleFileContent(version, author, description: string): string =
  result = fmt"""
# Package

version       = "{version}"
author        = "{author}"
description   = "{description}"
license       = "MIT"
srcDir        = "src"
backend       = "js"

# Dependencies

requires "nim >= 1.0.6"
requires "blackvas >= 1.0.0"
"""