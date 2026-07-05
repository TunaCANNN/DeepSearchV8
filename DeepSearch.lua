--// DeepSearch v8 - Orion Library Version
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

local Window = OrionLib:MakeWindow({
    Name = "DeepSearch v8",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "DeepSearch"
})

-- Tabs
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998"
})

local LogsTab = Window:MakeTab({
    Name = "Logs",
    Icon = "rbxassetid://4483345998"
})

local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998"
})

-- Variables
local perfMode = "normal"
local autoSave = true
local currentLogs = {}
local WORDBANK_URL = "https://raw.githubusercontent.com/TunaCANNN/DeepSearchV8/refs/heads/main/wordbank.txt"

-- Log Label
local LogLabel = LogsTab:AddLabel("No logs yet.")

local function addLog(text)
    local timestamp = os.date("%H:%M:%S")
    local line = "[" .. timestamp .. "] " .. text
    table.insert(currentLogs, line)

    if #currentLogs > 60 then
        table.remove(currentLogs, 1)
    end

    LogLabel:Set(table.concat(currentLogs, "\n"))
end

-- WordBank Loader
local function loadWordBank()
    local success, data = pcall(function()
        return game:HttpGet(WORDBANK_URL)
    end)

    if success and data then
        local keywords = {}
        for line in string.gmatch(data, "[^\r\n]+") do
            if line ~= "" then
                table.insert(keywords, line)
            end
        end
        addLog("Word bank loaded from GitHub (" .. #keywords .. " words)")
        return keywords
    else
        addLog("Failed to load word bank from GitHub!")
        return {}
    end
end

-- Scan Function (Only uses WordBank)
local function runScan(mode)
    addLog("Starting " .. mode .. " scan...")

    local keywords = loadWordBank()

    if #keywords == 0 then
        addLog("No keywords loaded. Scan cancelled.")
        return
    end

    addLog("Scanning for matches...")

    for _, v in ipairs(game:GetDescendants()) do
        if perfMode == "light" and math.random() > 0.5 then continue end

        for _, kw in ipairs(keywords) do
            if string.find(v.Name, kw) and not string.find(v:GetFullName(), "CoreGui") then
                addLog("→ " .. v:GetFullName() .. " [" .. v.ClassName .. "]")
                break
            end
        end
    end

    addLog("Scan complete.")

    if autoSave and writefile then
        local name = "DeepSearch_" .. os.date("%Y%m%d_%H%M%S") .. ".txt"
        writefile(name, table.concat(currentLogs, "\n"))
        addLog("Log saved: " .. name)
    end
end

-- ==================== MAIN TAB ====================
MainTab:AddSection({
    Name = "Quick Scans"
})

MainTab:AddButton({
    Name = "Quick Scan",
    Callback = function()
        runScan("quick")
    end
})

MainTab:AddButton({
    Name = "Deep Scan",
    Callback = function()
        runScan("deep")
    end
})

MainTab:AddButton({
    Name = "Full Scan",
    Callback = function()
        runScan("full")
    end
})

MainTab:AddSection({
    Name = "GitHub"
})

MainTab:AddButton({
    Name = "Reload Word Bank from GitHub",
    Callback = function()
        loadWordBank()
    end
})

-- ==================== LOGS TAB ====================
LogsTab:AddSection({
    Name = "Log Controls"
})

LogsTab:AddButton({
    Name = "Copy All Logs",
    Callback = function()
        if setclipboard then
            setclipboard(table.concat(currentLogs, "\n"))
            OrionLib:MakeNotification({
                Name = "Copied",
                Content = "Logs copied to clipboard",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "setclipboard not supported",
                Time = 3
            })
        end
    end
})

LogsTab:AddButton({
    Name = "Clear Logs",
    Callback = function()
        currentLogs = {}
        LogLabel:Set("Logs cleared.")
    end
})

-- ==================== SETTINGS TAB ====================
SettingsTab:AddSection({
    Name = "General Settings"
})

SettingsTab:AddToggle({
    Name = "Auto Save Logs",
    Default = true,
    Callback = function(Value)
        autoSave = Value
    end
})

SettingsTab:AddToggle({
    Name = "Performance Mode",
    Default = false,
    Callback = function(Value)
        perfMode = Value and "light" or "normal"
    end
})

SettingsTab:AddButton({
    Name = "Manual Save Current Log",
    Callback = function()
        if writefile then
            local name = "DeepSearch_Manual_" .. os.date("%Y%m%d_%H%M%S") .. ".txt"
            writefile(name, table.concat(currentLogs, "\n"))
            OrionLib:MakeNotification({
                Name = "Saved",
                Content = "Log saved as " .. name,
                Time = 3
            })
        end
    end
})

-- Final Notification
OrionLib:MakeNotification({
    Name = "DeepSearch v8",
    Content = "Loaded successfully with Orion Library",
    Time = 4
})

addLog("DeepSearch v8 loaded (Orion Library).")
addLog("Only using GitHub word bank for scanning.")
