on run argv
  set cmd to "The task"
  if (count of argv) > 0 then
    set AppleScript's text item delimiters to " "
    set cmd to (argv as text)
    set AppleScript's text item delimiters to ""
  end if
  display notification (cmd & " was successfully done.") with title "OK"
end run
