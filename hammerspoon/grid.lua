sizeUpMash = {"⌘", "⌥"}
sizeDownMash = {"⌃", "⌥"}
throwMash = {"⌘", "⌃", "shift"}

-- defaults
hs.grid.setGrid'6x6'
hs.grid.setMargins("15,15")
hs.window.animationDuration = 0.0

-- mash + #: resize grid
hs.hotkey.bind(mash, "2", function() setGrid('2x3'); end)
hs.hotkey.bind(mash, "3", function() setGrid('3x6'); end)
hs.hotkey.bind(mash, "4", function() setGrid('6x6'); end)
hs.hotkey.bind(mash, "5", function() setGrid('9x6'); end)
hs.hotkey.bind(mash, "6", function() setGrid('12x6'); end)
hs.hotkey.bind(mash, "7", function() setGrid('15x6'); end)

--  mash + `: move window to next screen
hs.hotkey.bind(mash, "`", function() local win = getWinGridCell(); win:moveToScreen(win:screen():next()) end)

-- mash + ,: snap window to grid
hs.hotkey.bind(mash, ",", function() hs.grid.snap(getWin()) end)

-- mash + enter: maximize window
hs.hotkey.bind(mash, "return", function() hs.grid.maximizeWindow() end)

-- mash + .: minimize window
hs.hotkey.bind(mash, ".", function() hs.grid.set(getWin(), '0,0 1x1'); end)

--
-- left / down / right + throwMash -- throw to left, center, right
-- up + throwMash -- focus
--

hs.hotkey.bind(throwMash, "left", function()
    local win, grid, cell = getWinGridCell()
    setWin(win, 0, 0, grid.w/3, grid.h)
end)


hs.hotkey.bind(throwMash, "right", function()
    local win, grid, cell = getWinGridCell()
    print(grid.w, grid.w/3)
    setWin(win, grid.w * 2/3, 0, grid.w/3, grid.h)
end)

hs.hotkey.bind(throwMash, "down", function()
    local win, grid, cell = getWinGridCell()
    if grid.w > 2 then
        setWin(win, grid.w/3, 0, grid.w/3, grid.h)
    end
end)

hs.hotkey.bind(throwMash, "up", function()
    local win, grid, cell = getWinGridCell()
    setWin(win, grid.w/3, 0, grid.w/3, grid.h)
    local winSize = win:size()
    win:setSize(winSize.w+500, winSize.h * .8)
    win:centerOnScreen()
end)

--
-- arrows + mash: move window w/ wrap
--

hs.hotkey.bind(mash, "left", function()
    local win, grid, cell = getWinGridCell()
    if cell.x == 0 then setWin(win, grid.w-cell.w, cell.y, cell.w, cell.h)
    else hs.grid.pushWindowLeft() end
end)

hs.hotkey.bind(mash, "right", function()
    local win, grid, cell = getWinGridCell()
    if cell.x + cell.w >= grid.w then setWin(win, 0, cell.y, cell.w, cell.h)
    else hs.grid.pushWindowRight() end
end)

hs.hotkey.bind(mash, "up", function()
    local win, grid, cell = getWinGridCell()
    if cell.y == 0 then setWin(win, cell.x, grid.h-cell.h, cell.w, cell.h)
    else hs.grid.pushWindowUp() end
end)

hs.hotkey.bind(mash, "down", function()
    local win, grid, cell = getWinGridCell()
    if cell.y + cell.h >= grid.h then setWin(win, cell.x, 0, cell.w, cell.h)
    else hs.grid.pushWindowDown() end
end)

--
-- arrows + sizeUpMash -- increase window sizing
--

hs.hotkey.bind(sizeUpMash, "left", function()
    hs.grid.pushWindowLeft()
    hs.grid.resizeWindowWider()
end)

hs.hotkey.bind(sizeUpMash, "right", function()
    hs.grid.resizeWindowWider()
end)

hs.hotkey.bind(sizeUpMash, "up", function()
    local win, grid, cell = getWinGridCell()
    if cell.y > 0 then
        hs.grid.pushWindowUp()
        hs.grid.resizeWindowTaller()
    end
end)

hs.hotkey.bind(sizeUpMash, "down", function()
    local win, grid, cell = getWinGridCell()
    if cell.y + cell.h < grid.h then hs.grid.resizeWindowTaller() end
end)

--
-- arrows + sizeDownMash -- decrease window sizing
--

hs.hotkey.bind(sizeDownMash, "left", function()
    hs.grid.resizeWindowThinner()
end)

hs.hotkey.bind(sizeDownMash, "right", function()
    local win, grid, cell = getWinGridCell()
    if cell.w > 1 then
        hs.grid.pushWindowRight()
        hs.grid.resizeWindowThinner()
    end
end)

hs.hotkey.bind(sizeDownMash, "up", function()
    hs.grid.resizeWindowShorter()
end)

hs.hotkey.bind(sizeDownMash, "down", function()
    local win, grid, cell = getWinGridCell()
    if cell.h > 1 then
        hs.grid.resizeWindowShorter()
        hs.grid.pushWindowDown()
    end

end)

--
-- helpers
--
function getWinGridCell()
    local win = hs.window.focusedWindow()
    return win, hs.grid.getGrid(win:screen()), hs.grid.get(win)
end

function setWin(win, x, y, w, h) hs.grid.set(win, hs.geometry(x, y, w, h), win:screen()) end
function setGrid(wh) hs.grid.setGrid(wh); hs.alert.show(wh) end
