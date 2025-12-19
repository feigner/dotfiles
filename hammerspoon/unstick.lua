-- Space Unstick
-- Fixes apps that *should* be assigned to all desktops but are stuck on one
-- by toggling their "All Desktops" setting. Usually happens after waking from sleep.
-- Annoying.

local DEBUG_MODE = false

local function toggleAllDesktopsForApp(appName)
    local script = string.format([[
        property debugMsgs : {}

        on logMsg(msg)
            if %s then
                copy (msg as text) to the end of debugMsgs
            end if
        end logMsg

        on run
            set debugMsgs to {}
            set targetName to "%s"
            set status to "not_found"

            try
                tell application "System Events"
                    tell application process "Dock"
                        repeat with listIndex from 1 to (count of lists)
                            set dockItems to UI elements of list listIndex
                            repeat with dockItem in dockItems
                                set itemName to ""
                                try
                                    set itemName to name of dockItem
                                end try

                                if itemName is targetName then
                                    -- Open Dock menu
                                    perform action "AXShowMenu" of dockItem
                                    delay 0.3

                                    -- Find menu using recursive search
                                    set dockMenu to missing value
                                    try
                                        set allElements to entire contents
                                        repeat with elem in allElements
                                            try
                                                if role of elem is "AXMenu" then
                                                    set dockMenu to elem
                                                    exit repeat
                                                end if
                                            end try
                                        end repeat
                                    end try

                                    if dockMenu is missing value then
                                        set status to "error:no_menu"
                                        key code 53  -- Close menu
                                        exit repeat
                                    end if

                                    -- Open Options submenu
                                    set optionsMenu to menu 1 of menu item "Options" of dockMenu

                                    -- Get All Desktops item (direct child of Options, not in "Assign To" submenu)
                                    set allDesktopsItem to menu item "All Desktops" of optionsMenu

                                    -- Check if currently set
                                    set isAllDesktops to false
                                    try
                                        set markChar to value of attribute "AXMenuItemMarkChar" of allDesktopsItem
                                        set isAllDesktops to markChar is not missing value
                                    end try

                                    if not isAllDesktops then
                                        my logMsg("Skipping - not currently set to All Desktops")
                                        set status to "skipped:not_set"
                                        key code 53  -- Close menu
                                        exit repeat
                                    end if

                                    -- Toggle to None
                                    click menu item "None" of optionsMenu
                                    delay 0.3

                                    -- Re-open menu
                                    perform action "AXShowMenu" of dockItem
                                    delay 0.3

                                    -- Find menu again
                                    set dockMenu to missing value
                                    try
                                        set allElements to entire contents
                                        repeat with elem in allElements
                                            try
                                                if role of elem is "AXMenu" then
                                                    set dockMenu to elem
                                                    exit repeat
                                                end if
                                            end try
                                        end repeat
                                    end try

                                    if dockMenu is missing value then
                                        set status to "error:no_menu_second"
                                        key code 53  -- Close menu
                                        exit repeat
                                    end if

                                    -- Click All Desktops again
                                    set optionsMenu to menu 1 of menu item "Options" of dockMenu
                                    click menu item "All Desktops" of optionsMenu
                                    set status to "success"
                                    exit repeat
                                end if
                            end repeat
                            if status is not "not_found" then exit repeat
                        end repeat
                    end tell
                end tell
            on error errMsg number errNum
                my logMsg("ERROR: " & errMsg)
                -- Try to close any open menus
                try
                    tell application "System Events"
                        key code 53
                    end tell
                end try
                return {status:"error:exception", logs:debugMsgs, err:errMsg}
            end try

            return {status:status, logs:debugMsgs}
        end run
    ]], tostring(DEBUG_MODE), appName)

    local ok, result = hs.osascript.applescript(script)

    local status = ok and result and result.status or nil
    local logs = ok and result and result.logs or {}

    -- Only print logs in debug mode or on error
    if DEBUG_MODE or not ok or (status and status:match("^error:")) then
        print(string.format("  %s: status=%s", appName, tostring(status)))
        if logs and type(logs) == "table" and #logs > 0 then
            for _, msg in ipairs(logs) do
                print("    " .. tostring(msg))
            end
        end
    end

    return ok and status == "success"
end

local function getAllDockApps()
    local script = [[
        tell application "System Events"
            tell application process "Dock"
                set dockApps to {}
                repeat with listIndex from 1 to (count of lists)
                    set dockItems to UI elements of list listIndex
                    repeat with dockItem in dockItems
                        try
                            set appName to name of dockItem
                            if appName is not in {"Downloads", "Trash", "Applications"} then
                                set end of dockApps to appName
                            end if
                        end try
                    end repeat
                end repeat
                return dockApps
            end tell
        end tell
    ]]

    local ok, result = hs.osascript.applescript(script)
    if ok and type(result) == "table" then
        return result
    end
    return {}
end

local function toggleAllDesktops()
    local dockApps = getAllDockApps()
    local affectedApps = {}

    -- Find running apps
    for _, appName in ipairs(dockApps) do
        local app = hs.application.find(appName)
        if app then
            table.insert(affectedApps, appName)
        end
    end

    if #affectedApps == 0 then
        print("No running apps found in Dock")
        return
    end

    print(string.format("\n🔄 Processing %d app(s)...", #affectedApps))
    if not DEBUG_MODE then
        print("⚠️  Don't interact with the Dock during this process!")
    end

    local successCount = 0
    for i, appName in ipairs(affectedApps) do
        if DEBUG_MODE then
            print(string.format("\n━━━ %d/%d: %s ━━━", i, #affectedApps, appName))
        end

        local success = toggleAllDesktopsForApp(appName)
        if success then
            successCount = successCount + 1
            if not DEBUG_MODE then
                print(string.format("  ✓ %s", appName))
            end
        elseif DEBUG_MODE then
            print(string.format("  ✗ %s", appName))
        end

        -- calm down
        hs.timer.usleep(300000)
    end

    hs.alert.show(string.format("Fixed %d/%d app(s)", successCount, #affectedApps))
    print(string.format("\n✓ Done! Fixed %d/%d app(s)\n", successCount, #affectedApps))
end

-- Bind to Cmd+Ctrl+D
hs.hotkey.bind({"cmd", "ctrl"}, "D", toggleAllDesktops)
