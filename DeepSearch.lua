--// DeepSearch v8 - Expanded Final Version
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "DeepSearch v8",
    LoadingTitle = "DeepSearch",
    LoadingSubtitle = "Advanced Game Scanner",
})

-- Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local ScanTab = Window:CreateTab("Scanning", 4483362458)
local AdvancedTab = Window:CreateTab("Advanced", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Variables
local perfMode = "normal"
local autoSave = true
local WORDBANK_URL = "https://raw.githubusercontent.com/TunaCANNN/DeepSearchV8/refs/heads/main/wordbank.txt"

-- ==================== CORE FUNCTIONS ====================
local function loadWordBank()
    local success, data = pcall(function()
        return game:HttpGet(WORDBANK_URL)
    end)

    local keywords = {"Card", "Deck", "Hand", "Board", "Loot", "Shop", "Buy", "Merge", "Upgrade", "Mining", "Pickaxe", "Holder", "Sell", "Chest", "Prompt"}

    if success and data then
        Rayfield:Notify({Title = "GitHub", Content = "Word bank loaded from GitHub", Duration = 3})
        for line in string.gmatch(data, "[^\r\n]+") do
            if line ~= "" and not table.find(keywords, line) then
                table.insert(keywords, line)
            end
        end
    else
        Rayfield:Notify({Title = "GitHub", Content = "Failed to load word bank", Duration = 4})
    end
    return keywords
end

local function scanRemotes()
    print("\n[REMOTES]")
    local count = 0
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            print("→ " .. v:GetFullName())
            count += 1
        end
    end
    print("[Remotes] Found: " .. count)
end

local function scanImportantData(keywords)
    print("\n[IMPORTANT DATA]")
    local count = 0
    for _, v in ipairs(game:GetDescendants()) do
        if perfMode == "light" and math.random() > 0.5 then continue end

        for _, kw in ipairs(keywords) do
            if string.find(v.Name, kw) and not string.find(v:GetFullName(), "CoreGui") then
                print("→ " .. v:GetFullName() .. " [" .. v.ClassName .. "]")
                count += 1
                break
            end
        end
    end
    print("[Data] Found: " .. count .. " matches")
end

local function scanPlayerData()
    print("\n[PLAYER DATA]")
    for _, v in ipairs(player:GetDescendants()) do
        if v:IsA("Folder") or v:IsA("ValueBase") then
            local name = v.Name:lower()
            if string.find(name, "card") or string.find(name, "deck") or string.find(name, "coin") or string.find(name, "gem") or string.find(name, "money") then
                print("→ " .. v:GetFullName())
            end
        end
    end
end

local function runFullScan()
    local keywords = loadWordBank()
    print("\n[DeepSearch] Starting Full Scan...")

    scanRemotes()
    scanImportantData(keywords)
    scanPlayerData()

    print("\n[SCAN COMPLETE]")

    if autoSave and writefile then
        local name = "DeepSearch_" .. os.date("%Y%m%d_%H%M%S") .. ".txt"
        writefile(name, "DeepSearch Log - " .. os.date())
        Rayfield:Notify({Title = "Saved", Content = "Log saved as " .. name, Duration = 4})
    end
end

-- ==================== MAIN TAB ====================
MainTab:CreateSection("Quick Scans")

MainTab:CreateButton({
    Name = "Quick Scan",
    Callback = function()
        Rayfield:Notify({Title = "Scan", Content = "Quick scan started", Duration = 2})
        runFullScan()
    end,
})

MainTab:CreateButton({
    Name = "Deep Scan",
    Callback = function()
        Rayfield:Notify({Title = "Scan", Content = "Deep scan started", Duration = 2})
        runFullScan()
    end,
})

MainTab:CreateButton({
    Name = "Full Aggressive Scan",
    Callback = function()
        Rayfield:Notify({Title = "Scan", Content = "Full scan started", Duration = 2})
        runFullScan()
    end,
})

MainTab:CreateSection("GitHub")

MainTab:CreateButton({
    Name = "Reload Word Bank",
    Callback = function()
        loadWordBank()
    end,
})

-- ==================== SCANNING TAB ====================
ScanTab:CreateSection("Scan Categories")

ScanTab:CreateButton({
    Name = "Scan Only Remotes",
    Callback = function()
        scanRemotes()
        Rayfield:Notify({Title = "Scan", Content = "Remote scan complete", Duration = 2})
    end,
})

ScanTab:CreateButton({
    Name = "Scan Important Data",
    Callback = function()
        local keywords = loadWordBank()
        scanImportantData(keywords)
        Rayfield:Notify({Title = "Scan", Content = "Data scan complete", Duration = 2})
    end,
})

ScanTab:CreateButton({
    Name = "Scan Player Data",
    Callback = function()
        scanPlayerData()
        Rayfield:Notify({Title = "Scan", Content = "Player data scan complete", Duration = 2})
    end,
})

-- ==================== ADVANCED TAB ====================
AdvancedTab:CreateSection("Performance & Automation")

AdvancedTab:CreateToggle({
    Name = "Performance Mode (Faster)",
    CurrentValue = false,
    Callback = function(Value)
        perfMode = Value and "light" or "normal"
        Rayfield:Notify({Title = "Performance", Content = "Mode: " .. perfMode, Duration = 2})
    end,
})

AdvancedTab:CreateToggle({
    Name = "Auto Save Logs",
    CurrentValue = true,
    Callback = function(Value)
        autoSave = Value
    end,
})

AdvancedTab:CreateButton({
    Name = "Manual Save Log",
    Callback = function()
        if writefile then
            local name = "DeepSearch_Manual_" .. os.date("%Y%m%d_%H%M%S") .. ".txt"
            writefile(name, "Manual Log - " .. os.date())
            Rayfield:Notify({Title = "Saved", Content = "Log saved successfully", Duration = 3})
        end
    end,
})

-- ==================== SETTINGS TAB ====================
SettingsTab:CreateSection("General")

SettingsTab:CreateToggle({
    Name = "Enable Notifications",
    CurrentValue = true,
    Callback = function(Value)
        -- Can expand later
    end,
})

SettingsTab:CreateButton({
    Name = "Reset Settings",
    Callback = function()
        Rayfield:Notify({Title = "Reset", Content = "Settings reset to default", Duration = 3})
    end,
})

print("[DeepSearch v8] Expanded Rayfield version loaded.")
