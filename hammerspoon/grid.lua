sizeMash = {"⌘", "⌃", "shift"}

--- defaults
hs.grid.setGrid'3x3'
hs.grid.setMargins("10,10")
hs.window.animationDuration = 0.1

function getWin()
  return hs.window.focusedWindow()
end

--- arrows + mash: move window
hs.hotkey.bind(mash, "left", function() hs.grid.pushWindowLeft() end)
hs.hotkey.bind(mash, "right", function() hs.grid.pushWindowRight() end)
hs.hotkey.bind(mash, "up", function() hs.grid.pushWindowUp() end)
hs.hotkey.bind(mash, "down", function() hs.grid.pushWindowDown() end)

--- arrows + sizeMash: resize window
hs.hotkey.bind(sizeMash, "left", function() hs.grid.resizeWindowThinner() end)
hs.hotkey.bind(sizeMash, "right", function() hs.grid.resizeWindowWider() end)
hs.hotkey.bind(sizeMash, "up", function() hs.grid.resizeWindowShorter() end)
hs.hotkey.bind(sizeMash, "down", function() hs.grid.resizeWindowTaller() end)

--- mash + 234: resize grid
hs.hotkey.bind(mash, "2", function() hs.grid.setGrid('2x2'); hs.alert.show('2x2'); end)
hs.hotkey.bind(mash, "3", function() hs.grid.setGrid('3x3'); hs.alert.show('3x3'); end)
hs.hotkey.bind(mash, "4", function() hs.grid.setGrid('4x4'); hs.alert.show('4x4'); end)

--- /: move window to next screen
hs.hotkey.bind(mash, "`", function() local win = getWin(); win:moveToScreen(win:screen():next()) end)

--- ,: snap window to grid
hs.hotkey.bind(mash, ",", function() hs.grid.snap(getWin()) end)

--- space: maximize window
hs.hotkey.bind(mash, "return", function() hs.grid.maximizeWindow() end)

--- .: minimize window
hs.hotkey.bind(mash, ".", function() hs.grid.set(getWin(), '0,0 1x1'); end)

-- auto config reloading
reloader = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", function(files)
    doReload = false
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end)
reloader:start()
