import db_sqlite, strformat, strutils

type
  Task* = object
    id*: int
    name*: string
    description*: string
    done*: bool

proc init* () =
  let db = open("tasks.db", "", "", "")
  defer:
    db.close()
  let cmd = sql"create table if not exists task(id integer primary key, name text not null, description text not null, done boolean not null)"
  discard db.tryExec(cmd)

proc create* (name: string, description: string, done: bool = false): Task =
  let db = open("tasks.db", "", "", "")
  let id = db.tryInsertID(sql"insert into task (name, description, done) values(?, ?, ?)", name, description, done)
  db.close()
  echo fmt"タスク「{name}」を登録しました！"
  result = Task(
    id: id.int,
    name: name,
    description: description,
    done: done
  )

proc index* (): seq[Task] =
  let db = open("tasks.db", "", "", "")
  let tasks = db.getAllRows(sql"select id, name, description, done from task")
  result = @[]
  for task in tasks:
    result.add(
      Task(
        id: task[0].parseInt,
        name: task[1],
        description: task[2],
        done: task[3].parseBool
      )
    )

proc show* (id: int): Task =
  let db = open("tasks.db", "", "", "")
  let task = db.getRow(sql"SELECT id, name, description, done FROM task WHERE id=?", id)
  result = Task(
    id: task[0].parseInt,
    name: task[1],
    description: task[2],
    done: task[3].parseBool
  )

proc update* (task: Task): Task =
  let db = open("tasks.db", "", "", "")
  db.exec(
    sql"update task set name = ?, description = ?, done = ?) where id = ?",
    task.name,
    task.description,
    task.done,
    task.id
  )
  echo fmt"タスク「{task.name}」を更新しました！"
  result = task

proc destroy* (id: int): Task =
  let db = open("tasks.db", "", "", "")
  let task = db.getRow(sql"SELECT id, name, description, done FROM task WHERE id=?", id)
  db.exec(sql"delete from task where id = ?", id)
  let name = task[1]
  echo fmt"タスク「{name}」を削除しました！"
  result = Task(
    id: task[0].parseInt,
    name: name,
    description: task[2],
    done: task[3].parseBool
  )