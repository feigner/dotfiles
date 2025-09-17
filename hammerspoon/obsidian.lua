--[[
    Obsidian hotkeys:
        ⌥ + `     : toggle show/hide Obsidian app with focus positioning
        ⌥⇧ + `    : create new note in Obsidian
--]]

local obsidianApp = "Obsidian"

function toggleObsidian()
    local app = hs.application.find(obsidianApp)
    if not app then
        showObsidian()
        return
    end

    -- Check if any Obsidian window is visible and not minimized
    local visibleWindow = nil
    for _, win in ipairs(app:allWindows()) do
        if win:isVisible() and not win:isMinimized() then
            visibleWindow = win
            break
        end
    end

    if app:isFrontmost() and visibleWindow then
        -- App is frontmost with visible window, hide it
        app:hide()
    else
        -- App exists but either not frontmost, minimized, or hidden - show and focus
        showObsidian()
    end
end

function focusObsidianWindow(win)
    local screen = win:screen()
    local screenFrame = screen:frame()

    -- Calculate centered position with focus-style sizing
    local targetWidth = screenFrame.w * 0.5  -- 50% of screen width
    local targetHeight = screenFrame.h * 0.8  -- 80% of screen height


    local x = screenFrame.x + (screenFrame.w - targetWidth) / 2
    local y = screenFrame.y + (screenFrame.h - targetHeight) / 2

    win:setFrame(hs.geometry.rect(x, y, targetWidth, targetHeight))
end

function showObsidian(callback)
    local app = hs.application.find(obsidianApp)

    if not app then
        -- Launch Obsidian first
        hs.application.open(obsidianApp)
        if callback then
            hs.timer.doAfter(2.0, callback)
        end
        return
    end

    -- Show and focus Obsidian
    app:activate()

    -- Unminimize any minimized windows
    for _, win in ipairs(app:allWindows()) do
        if win:isMinimized() then
            win:unminimize()
        end
    end

    -- Apply focus positioning and callback
    hs.timer.doAfter(0.1, function()
        local win = app:focusedWindow()
        if win then
            focusObsidianWindow(win)
        end
        if callback then
            callback()
        end
    end)
end

function createNewNote()
    showObsidian(function()
        hs.urlevent.openURL("obsidian://new")
    end)
end

-- Bind ⌥ + ` to toggle Obsidian
hs.hotkey.bind({"⌥"}, "`", toggleObsidian)

-- Bind ⌥⇧ + ` to create new note
hs.hotkey.bind({"⌥", "⇧"}, "`", createNewNote)
