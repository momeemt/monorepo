import asyncdispatch, jester, strutils, os, terminal, colors
include "index.tmpl"

proc serve*(): int =
  # blackvasプロジェクトをコンパイルして、生成したjavascriptを探索、indexTmplにpathを渡す
  
  let currentPath = os.getCurrentDir()
  var existBlackvasJson = false
  for f in walkDirRec(currentPath, {pcFile}):
    if f == currentPath & "/blackvas.json":
      existBlackvasJson = true
  
  if not existBlackvasJson:
    echo "This is not Blackvas Project!"
    quit(1)
  else:
    enableTrueColors()
    setForegroundColor(stdout, parseColor("#ffa500"))
    echo "\e[1m" & "✨  Blackvas server is up and running successfully" & "\e[0m"
    resetAttributes(stdout)

  let genJsFile = "/js/sample.js"

  routes:
    get "/":
      resp(indexTmpl(genJsFile))
  result = 0