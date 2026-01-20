import tasks

proc backlog(): int =
  echo tasks.index()
  result = 0

proc addTask(): int =
  stdout.write("タスク名: ")
  let name = stdin.readLine
  stdout.write("タスクの説明: ")
  let description = stdin.readLine
  let task = tasks.create(name, description)
  result = 0

when isMainModule:
  import cligen
  tasks.init()
  cligen.dispatchMulti([backlog], [addTask])