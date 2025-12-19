-- Hotkey Cheatsheet
-- Press Cmd+Ctrl+H to toggle display

local cheatsheet = hs.hotkey.modal.new({"cmd", "ctrl"}, "H")
-- esc to exit
cheatsheet:bind('', 'escape', function() cheatsheet:exit() end)
-- cmd-ctrl-h to toggle
cheatsheet:bind('cmd,ctrl', 'H', function() cheatsheet:exit() end)

-- Hotkey reference (manually maintained)
local hotkeys = [[
Grid - Layout:
  ⌘⌃ 1    4x3 grid layout
  ⌘⌃ 2    6x6 grid layout
  ⌘⌃ 3    12x6 grid layout
  ⌘⌃ 4    15x6 grid layout

Grid - Movement:
  ⌘⌃ `    Move window to next screen
  ⌘⌃ ,    Snap window to grid
  ⌘⌃ ↵    Maximize window
  ⌘⌃ .    Minimize window
  ⌘⌃ ←→↑↓  Move window

Grid - Resize:
  ⌘⌥ ←→↑↓  Increase window size
  ⌃⌥ ←→↑↓  Decrease window size

Grid - Throw:
  ⌘⌃⇧ ←   Throw to left column
  ⌘⌃⇧ ↓   Throw to center column
  ⌘⌃⇧ →   Throw to right column
  ⌘⌃⇧ ↑   Focus mod
  ⌘⌃⇧ S   Screen sharing mode

Obsidian:
  ⌥ `     Toggle Obsidian
  ⌥⇧ `    Create new note

Desktop Assignment:
  ⌘⌃ D    Toggle desktop assignment

Cheatsheet:
  ⌘⌃ H    Toggle this cheatsheet
  ESC     Close cheatsheet
]]

local alertID = nil
function cheatsheet:entered()
    alertID = hs.alert.show(hotkeys, {
        textSize = 15,
        textFont = "Menlo",
        textColor = { white = 0.95, alpha = 1 },
        fillColor = { red = 0.12, green = 0.12, blue = 0.13, alpha = 0.97 },
        strokeColor = { red = 0.3, green = 0.3, blue = 0.32, alpha = 0.95 },
        strokeWidth = 1.5,
        radius = 12,
        padding = 40,
        atScreenEdge = 0,
        fadeInDuration = 0.2,
        fadeOutDuration = 0.15,
    }, "infinite")
end

function cheatsheet:exited()
    if alertID then
        hs.alert.closeSpecific(alertID)
        alertID = nil
    end
end
