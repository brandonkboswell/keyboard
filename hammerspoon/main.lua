local log = hs.logger.new('delete-words.lua', 'debug')

local isInTerminal = function()
  app = hs.application.frontmostApplication():name()
  return app == 'iTerm2' or app == 'Terminal'
end

isAppFocused = function(name)
  app = hs.application.frontmostApplication()
  appName = app:name()

  print('focused_app', appName)

  return appName:lower() == name:lower()
end

toggleFocus = function(name, altName)
  print('toggleFocus', name)
  if(isAppFocused(name)) then
    print('focused')
    app:hide();
  else
    print('not focused')
    if altName then
      hs.application.launchOrFocus(altName)
    else
      hs.application.launchOrFocus(name)
    end
  end
end

--
-- /opt/homebrew/bin/YABAI SHORTCUTS
--

-- Layout
hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'f4', function()
  os.execute("/opt/homebrew/bin/yabai -m space --layout stack")
end)

hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, '0', function()
  os.execute("/opt/homebrew/bin/yabai -m space --layout stack")
end)

hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, '9', function()
  os.execute("/opt/homebrew/bin/yabai -m space --layout bsp")
end)

-- focus window
hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 's', function()
  -- os.execute("/opt/homebrew/bin/yabai -m window --focus next || /opt/homebrew/bin/yabai -m window --focus first")
  output = hs.execute("/opt/homebrew/bin/yabai -m query --spaces --space | /opt/homebrew/bin/jq -r '.type'")

  print(output)

  if output == "stack\n" then
    os.execute("/opt/homebrew/bin/yabai -m window --focus stack.next || /opt/homebrew/bin/yabai -m window --focus stack.first")
  else
    os.execute("/opt/homebrew/bin/yabai -m window --focus next || /opt/homebrew/bin/yabai -m window --focus first")
  end
end)

hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'd', function()
  -- os.execute("/opt/homebrew/bin/yabai -m window --focus prev || /opt/homebrew/bin/yabai -m window --focus last")
  output = hs.execute("/opt/homebrew/bin/yabai -m query --spaces --space | /opt/homebrew/bin/jq -r '.type'")

  if output == "stack\n" then
    os.execute("/opt/homebrew/bin/yabai -m window --focus stack.prev || /opt/homebrew/bin/yabai -m window --focus stack.last")
  else
    os.execute("/opt/homebrew/bin/yabai -m window --focus prev || /opt/homebrew/bin/yabai -m window --focus last")
  end
end)

-- hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'f', function()
--   os.execute("/opt/homebrew/bin/yabai -m window --focus east")
-- end)
-- hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'a', function()
--   os.execute("/opt/homebrew/bin/yabai -m window --focus west")
-- end)

hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'x', function()
  os.execute("/opt/homebrew/bin/yabai -m window --swap south || /opt/homebrew/bin/yabai -m window --swap east || /opt/homebrew/bin/yabai -m window --swap north || /opt/homebrew/bin/yabai -m window --swap west")
end)

hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'c', function()
  os.execute("/opt/homebrew/bin/yabai -m window --swap north || /opt/homebrew/bin/yabai -m window --swap west || /opt/homebrew/bin/yabai -m window --swap south || /opt/homebrew/bin/yabai -m window --swap east")
end)

-- Manipulate Window Size
hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, '-', function()
  os.execute("/opt/homebrew/bin/yabai -m window --ratio rel:-0.05")
end)

hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, '=', function()
  os.execute("/opt/homebrew/bin/yabai -m window --ratio rel:0.05")
end)

-- Monitor
hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'a', function()
  os.execute("/opt/homebrew/bin/yabai -m display --focus prev || /opt/homebrew/bin/yabai -m display --focus last")
end)

hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'f', function()
  os.execute("/opt/homebrew/bin/yabai -m display --focus next || /opt/homebrew/bin/yabai -m display --focus first")
end)

-- send window to monitor and follow focus
hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'z', function()
  os.execute("/opt/homebrew/bin/yabai -m window --display 2; /opt/homebrew/bin/yabai -m display --focus 2")
  -- os.execute("/opt/homebrew/bin/yabai -m display --focus prev || /opt/homebrew/bin/yabai -m display --focus last; /opt/homebrew/bin/yabai -m window --display prev || /opt/homebrew/bin/yabai -m display --focus last")
end)

hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'v', function()
  -- os.execute("/opt/homebrew/bin/yabai -m window --display 1; /opt/homebrew/bin/yabai -m display --focus 1")
  os.execute("/opt/homebrew/bin/yabai -m window --display next || /opt/homebrew/bin/yabai -m window --display first; /opt/homebrew/bin/yabai -m display --focus next || /opt/homebrew/bin/yabai -m display --focus first")
end)

-- rotate tree
hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'e', function()
  os.execute("/opt/homebrew/bin/yabai -m space --rotate 90")
end)

-- toggle window fullscreen zoom
hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'return', function()
  -- os.execute("/opt/homebrew/bin/yabai -m window --toggle zoom-fullscreen")
  output = hs.execute("/opt/homebrew/bin/yabai -m query --spaces --space | /opt/homebrew/bin/jq -r '.type'")

  if output == "stack\n" then
    os.execute("/opt/homebrew/bin/yabai -m space --layout bsp;")
    -- os.execute("/opt/homebrew/bin/yabai -m space --layout bsp; /opt/homebrew/bin/yabai -m space --padding abs:15:15:15:15; /opt/homebrew/bin/yabai -m space --gap abs:15")
  else
    os.execute("/opt/homebrew/bin/yabai -m space --layout stack;")
    -- os.execute("/opt/homebrew/bin/yabai -m space --layout stack; /opt/homebrew/bin/yabai -m space --padding abs:0:0:0:0; /opt/homebrew/bin/yabai -m space --gap abs:0")
  end
end)

-- toggle padding and gap
hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'g', function()
  os.execute("/opt/homebrew/bin/yabai -m space --toggle padding; /opt/homebrew/bin/yabai -m space --toggle gap")
end)

-- float / unfloat window and center on screen
hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, '\\', function()
  os.execute("/opt/homebrew/bin/yabai -m window --toggle float; /opt/homebrew/bin/yabai -m window --grid 12:12:2:2:8:8")
end)

-- balance size of windows
hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'r', function()
  os.execute("/opt/homebrew/bin/yabai -m space --balance")
end)

--
-- Shortcuts
--

-- hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, '1', function()
--   os.execute("open https://mail.google.com/mail/u/0/#inbox")
-- end)

-- hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, '2', function()
--   os.execute("open https://mail.google.com/mail/u/1/#inbox")
-- end)

-- hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, '3', function()
--   os.execute("open https://www.notion.so/dorsata/ac4230c7df3848118c54269308493230?v=5713ab04faa440d5b1314dd8bf4fc39f")
-- end)

-- hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, '4', function()
--   os.execute("open https://dorsata.atlassian.net/jira/software/c/projects/DOR/boards/2?quickFilter=3")
-- end)

-- hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, '5', function()
--   os.execute("open https://calendar.google.com/calendar/u/0/r")
-- end)

-- hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, '6', function()
--   os.execute("open https://www.figma.com/files/recent")
-- end)

hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 't', function()
  toggleFocus('iTerm2')
end)

-- Use option + h to delete previous word
hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'h', function()
  if isInTerminal() then
    keyUpDown({'ctrl'}, 'w')
  else
    keyUpDown({'alt'}, 'delete')
  end
end)

-- Use option + l to delete next word
hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'l', function()
  if isInTerminal() then
    keyUpDown({}, 'escape')
    keyUpDown({}, 'd')
  else
    keyUpDown({'alt'}, 'forwarddelete')
  end
end)

-- Use control + u to delete to beginning of line
--
-- In bash, control + u automatically deletes to the beginning of the line, so
-- we don't need (or want) this hotkey in the terminal. If this hotkey was
-- enabled in the terminal, it would break the standard control + u behavior.
-- Therefore, we only enable this hotkey for non-terminal apps.
local wf = hs.window.filter.new():setFilters({iTerm2 = false, Terminal = false})
enableHotkeyForWindowsMatchingFilter(wf, hs.hotkey.new({'alt', 'ctrl', 'cmd', 'shift'}, 'u', function()
  keyUpDown({'cmd'}, 'delete')
end))

-- Use control + ; to delete to end of line
--
-- I prefer to use control+h/j/k/l to move left/down/up/right by one pane in all
-- multi-pane apps (e.g., iTerm, various editors). That's convenient and
-- consistent, but it conflicts with the default macOS binding for deleting to
-- the end of the line (i.e., control+k). To maintain that very useful
-- functionality, and to keep it on the home row, this hotkey binds control+; to
-- delete to the end of the line.
hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, ';', function()
  -- If we're in the terminal, then temporarily disable our custom control+k
  -- hotkey used for pane navigation, then fire control+k to delete to the end
  -- of the line, and then renable the control+k hotkey.
  --
  -- If we're not in the terminal, then just select to the end of the line and
  -- then delete the selected text.
  if isInTerminal() then
    hotkeyForControlK = hs.fnutils.find(hs.hotkey.getHotkeys(), function(hotkey)
      return hotkey.idx == '⌃K'
    end)
    if hotkeyForControlK then hotkeyForControlK:disable() end

    keyUpDown({'ctrl'}, 'k')

    -- Allow some time for the control+k keystroke to fire asynchronously before
    -- we re-enable our custom control+k hotkey.
    hs.timer.doAfter(0.2, function()
      if hotkeyForControlK then hotkeyForControlK:enable() end
    end)
  else
    keyUpDown({'cmd', 'shift'}, 'right')
    keyUpDown({}, 'forwarddelete')
  end
end)
