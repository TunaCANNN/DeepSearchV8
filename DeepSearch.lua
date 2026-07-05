--// DeepSearch v8 - LinoriaLib Version
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))()

local Window = Library:CreateWindow({
    Title = 'DeepSearch v8',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuAccentColor = Color3.fromRGB(180, 100, 255)
})

-- Tabs
local Tabs = {
    Main = Window:AddTab('Main'),
    Logs = Window:AddTab('Logs'),
    Settings = Window:AddTab('Settings'),
}

-- Variables
local perfMode = "normal"
local autoSave = true
local currentLogs = {}
local WORDBANK_URL = "https://raw.githubusercontent.com/TunaCANNN/DeepSearchV8/refs/heads/main/wordbank.txt"

-- Log Label (for Logs tab)
local LogLabel = Tabs.Logs:AddLabel("No logs yet.")

local function addLog(text)
    local timestamp = os.date("%H:%M:%S")
    local line = "[" .. timestamp .. "] " .. text
    
    table.insert(currentLogs, line)
    
    if #currentLogs > 60 then
        table.remove(currentLogs, 1)
    end
    
    LogLabel:SetValue(table.concat(currentLogs, "\n"))
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

-- Scan Function (Uses only WordBank)
local function runScan(mode)
    addLog("Starting " .. mode .. " scan...")

    local keywords = loadWordBank()

    if #keywords == 0 then
        addLog("No keywords found. Scan cancelled.")
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
Tabs.Main:AddLeftGroupbox('Quick Scans')

Tabs.Main:AddButton({
    Text = 'Quick Scan',
    Func = function()
        runScan("quick")
    end,
})

Tabs.Main:AddButton({
    Text = 'Deep Scan',
    Func = function()
        runScan("deep")
    end,
})

Tabs.Main:AddButton({
    Text = 'Full Scan',
    Func = function()
        runScan("full")
    end,
})

Tabs.Main:AddLeftGroupbox('GitHub')

Tabs.Main:AddButton({
    Text = 'Reload Word Bank',
    Func = function()
        loadWordBank()
    end,
})

-- ==================== LOGS TAB ====================
Tabs.Logs:AddLeftGroupbox('Log Controls')

Tabs.Logs:AddButton({
    Text = 'Copy All Logs',
    Func = function()
        if setclipboard then
            setclipboard(table.concat(currentLogs, "\n"))
            Library:Notify('Logs copied to clipboard', 3)
        else
            Library:Notify('setclipboard not supported', 3)
        end
    end,
})

Tabs.Logs:AddButton({
    Text = 'Clear Logs',
    Func = function()
        currentLogs = {}
        LogLabel:SetValue("Logs cleared.")
    end,
})

-- ==================== SETTINGS TAB ====================
Tabs.Settings:AddLeftGroupbox('General')

Tabs.Settings:AddToggle('AutoSave', {
    Text = 'Auto Save Logs',
    Default = true,
    Callback = function(Value)
        autoSave = Value
    end,
})

Tabs.Settings:AddToggle('PerfMode', {
    Text = 'Performance Mode',
    Default = false,
    Callback = function(Value)
        perfMode = Value and "light" or "normal"
    end,
})

Tabs.Settings:AddButton({
    Text = 'Manual Save Log',
    Func = function()
        if writefile then
            local name = "DeepSearch_Manual_" .. os.date("%Y%m%d_%H%M%S") .. ".txt"
            writefile(name, table.concat(currentLogs, "\n"))
            Library:Notify('Log saved as ' .. name, 3)
        end
    end,
})

-- Theme Manager (Optional but nice)
ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)

addLog("DeepSearch v8 (LinoriaLib) loaded successfully.")
addLog("All scans now use only the GitHub word bank.")
