sizeMash = {"⌘", "⌃", "shift"}

--- defaults
hs.grid.setGrid'3x3'
hs.grid.setMargins("15,15")
hs.window.animationDuration = 0.0

--- mash + 234: resize grid
hs.hotkey.bind(mash, "2", function() hs.grid.setGrid('2x2'); hs.alert.show('2x2'); end)
hs.hotkey.bind(mash, "3", function() hs.grid.setGrid('3x3'); hs.alert.show('3x3'); end)
hs.hotkey.bind(mash, "4", function() hs.grid.setGrid('4x4'); hs.alert.show('4x4'); end)
hs.hotkey.bind(mash, "5", function() hs.grid.setGrid('5x5'); hs.alert.show('5x5'); end)

--- /: move window to next screen
hs.hotkey.bind(mash, "`", function() local win = getWin(); win:moveToScreen(win:screen():next()) end)

--- ,: snap window to grid
hs.hotkey.bind(mash, ",", function() hs.grid.snap(getWin()) end)

--- space: maximize window
hs.hotkey.bind(mash, "return", function() hs.grid.maximizeWindow() end)

--- .: minimize window
hs.hotkey.bind(mash, ".", function() hs.grid.set(getWin(), '0,0 1x1'); end)

---
--- arrows + mash: move window w/ wrap
---

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

---
--- arrows + sizeMash: resizers
---
--
hs.hotkey.bind(sizeMash, "left", function()
    local win, grid, cell = getWinGridCell()
    if cell.x > 0 then setWin(win, cell.x-1, cell.y, cell.w+1, cell.h)
    else hs.grid.resizeWindowThinner() end
end)

hs.hotkey.bind(sizeMash, "right", function()
    local win, grid, cell = getWinGridCell()
    if cell.x + cell.w >= grid.w then setWin(win, cell.x+1, cell.y, cell.w-1, cell.h)
    else hs.grid.resizeWindowWider() end
end)

hs.hotkey.bind(sizeMash, "up", function()
    local win, grid, cell = getWinGridCell()
    if cell.y > 0 then setWin(win, cell.x, cell.y-1, cell.w, cell.h+1)
    else hs.grid.resizeWindowShorter() end
end)
hs.hotkey.bind(sizeMash, "down", function()
    local win, grid, cell = getWinGridCell()
    if cell.h + cell.y >= grid.h then setWin(win, cell.x, cell.y+1, cell.w, cell.h-1)
    else hs.grid.resizeWindowTaller() end
end)

---
--- helpers
---
function getWinGridCell()
    local win = hs.window.focusedWindow()
    return win, hs.grid.getGrid(win:screen()), hs.grid.get(win)
end

function setWin(win, x, y, w, h) hs.grid.set(win, hs.geometry(x, y, w, h), win:screen()) end
