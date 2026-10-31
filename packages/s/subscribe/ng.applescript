on run argv
  set cmd to "The task"
  if (count of argv) > 0 then
    set AppleScript's text item delimiters to " "
    set cmd to (argv as text)
    set AppleScript's text item delimiters to ""
  end if
  display dialog (cmd & " was failed.") buttons {"OK"} default button "OK" with icon stop with title "NG"
end run
