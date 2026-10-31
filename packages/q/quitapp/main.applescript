on run argv
  tell application "System Events"
    set appList to (name of every process whose background only is false)
  end tell
  repeat with appName in appList
    set n to appName as text
    if n is not "Finder" and n is not "Alacritty" then
      try
        tell application n to quit
      end try
    end if
  end repeat
end run
