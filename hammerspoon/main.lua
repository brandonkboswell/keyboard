local log = hs.logger.new('delete-words.lua', 'debug')

local isInTerminal = function()
  app = hs.application.frontmostApplication():name()
  return app == 'WezTerm' or app == 'iTerm2' or app == 'Terminal'
end

isAppFocused = function(name)
  app = hs.application.frontmostApplication()
  appName = app:name()

  print('focused_app', appName)

  return appName:lower() == name:lower()
end

-- create a array of app names that are troublesome to hide
local troublesomeAppsToHide = {
  "Arc"
}

isInTable = function(tbl, item)
    for key, value in pairs(tbl) do
        if value == item then return key end
    end
    return false
end

toggleFocus = function(name, altName)
  print('toggleFocus', name)
  if(isAppFocused(name)) then
    print(name, 'is focused. Hiding')

    -- I'm investigating whether the app:hide call is the issue as this is a method to potentially mitigate that
    hs.eventtap.keyStroke({"cmd"}, "H")

    -- This is the technically correct way to do this, but it appear that something is making hammerspoon hang
    -- if not app:hide() then
    --   -- is this app a known troublesome app?
    --   -- if so, issue CMD+H to hide it
    --   if isInTable(troublesomeAppsToHide, name) then
    --     -- Add this condition to check if the name is in the troublesomeApps array
    --     hs.eventtap.keyStroke({"cmd"}, "H")
    --     print('hiding', name, ' via Commmand+H')
    --   end
    -- end
  else
    print('not focused')
    if altName then
      print('Trying to focus', altName)
      local execute = "/usr/bin/open -a '"..altName.."'"
      hs.execute(execute)

      -- This has a tendency to hang from time to time
      -- The shell is slower, but more reliable
      -- hs.application.launchOrFocus(altName)
    else
      local execute = "/usr/bin/open -a '"..name.."'"
      hs.execute(execute)

      -- This has a tendency to hang from time to time
      -- The shell is slower, but more reliable
      -- hs.application.launchOrFocus(name)
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

-- float / unfloat window and center on screen
hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, '\\', function()
  os.execute("/opt/homebrew/bin/yabai -m window --toggle float; /opt/homebrew/bin/yabai -m window --grid 12:12:2:2:8:8")
end)

-- balance size of windows
hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'r', function()
  os.execute("/opt/homebrew/bin/yabai --restart-service")
end)

--
-- Shortcuts
--

local apps = {
  {shortcut = '1', name = '1Password'},
  {shortcut = 'a', name = 'Akiflow'},
  {shortcut = 'v', name = 'DaVinci Resolve'},
  {shortcut = 'd', name = 'Discord'},
  {shortcut = 'f', name = 'Finder'},
  -- {shortcut = 'l', name = 'Loom'},
  {shortcut = 'k', name = 'Keymapp'},
  {shortcut = 'i', name = 'Messages'},
  {shortcut = 'm', name = 'Music'},
  {shortcut = 'o', name = 'Obsidian'},
  -- {shortcut = 'p', name = 'Adobe Photoshop 2023'},
  {shortcut = 'p', name = 'Postico'},
  {shortcut = 'q', name = 'QuickTime Player'},
  {shortcut = 'r', name = 'reMarkable'},
  {shortcut = 'e', name = 'Code', altName = 'Visual Studio Code'},
  {shortcut = 'z', name = 'zoom.us'},
  {shortcut = 's', name = 'Slack'},
  {shortcut = 't', name = 'Wezterm'},
  {shortcut = 'g', name = 'Arc'},
}

-- loop through apps and bind shortcuts
for i, app in ipairs(apps) do

  hs.hotkey.bind({'alt', 'ctrl', 'shift'}, app.shortcut, function()
    toggleFocus(app.name, app.altName)
  end)

  print('bound toggle shortcuts for:', app.name)
end

hs.hotkey.bind({'shift'}, 'delete', function()
  print('forwarddelete')
  keyUpDown({}, 'forwarddelete')
end)

-- Forward Delete on Hyper + Backspace
-- Doesn't work for whatever reason
hs.hotkey.bind({'alt', 'ctrl', 'cmd', 'shift'}, 'delete', function()
  print('forwarddelete')
  keyUpDown({}, 'forwarddelete')
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
  -- if isInTerminal() then
  --   keyUpDown({}, 'escape')
  --   keyUpDown({}, 'd')
  -- else
  -- The above doesn't play well with VIM, so forward delete is likely better
    keyUpDown({'alt'}, 'forwarddelete')
  -- end
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
