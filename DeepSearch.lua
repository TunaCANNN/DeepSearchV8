--// DeepSearch v8
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "DeepSearch"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 920, 0, 640)
main.Position = UDim2.new(0.5, -460, 0.5, -320)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(18, 8, 32)
title.Text = "DeepSearch v8  •  Terminal + GitHub WordBank"
title.TextColor3 = Color3.fromRGB(180, 100, 255)
title.TextScaled = true
title.Font = Enum.Font.Code
title.Parent = main

local console = Instance.new("ScrollingFrame")
console.Size = UDim2.new(1, -20, 1, -115)
console.Position = UDim2.new(0, 10, 0, 38)
console.BackgroundColor3 = Color3.fromRGB(6, 6, 10)
console.ScrollBarThickness = 6
console.Parent = main

local output = Instance.new("TextLabel")
output.Size = UDim2.new(1, -10, 1, 0)
output.BackgroundTransparency = 1
output.TextColor3 = Color3.fromRGB(180, 100, 255)
output.TextXAlignment = Enum.TextXAlignment.Left
output.TextYAlignment = Enum.TextYAlignment.Top
output.Font = Enum.Font.Code
output.TextSize = 13
output.TextWrapped = true
output.Parent = console

local logs = {}
local perfMode = "normal"

local function log(text, color)
    color = color or Color3.fromRGB(180, 100, 255)
    local ts = os.date("%H:%M:%S")
    table.insert(logs, "["..ts.."] " .. text)
    if #logs > 70 then table.remove(logs, 1) end
    output.Text = table.concat(logs, "\n")
    console.CanvasPosition = Vector2.new(0, console.AbsoluteCanvasSize.Y)
end

local cmdBar = Instance.new("TextBox")
cmdBar.Size = UDim2.new(1, -20, 0, 26)
cmdBar.Position = UDim2.new(0, 10, 1, -30)
cmdBar.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
cmdBar.TextColor3 = Color3.fromRGB(200, 150, 255)
cmdBar.PlaceholderText = "Commands: scan | deep | full | github | perf | help | clear | exit"
cmdBar.Font = Enum.Font.Code
cmdBar.TextSize = 13
cmdBar.ClearTextOnFocus = false
cmdBar.Parent = main

-- WordBank
local GITHUB_WORD_BANK = "https://github.com/TunaCANNN/DeepSearchV8/blob/main/wordbank.txt"

local function loadWordBank()
    local success, data = pcall(function()
        return game:HttpGet(GITHUB_WORD_BANK)
    end)

    local defaultKeywords = {
        "Card", "Deck", "Hand", "Board", "Loot", "Shop", "Buy", "Merge", 
        "Upgrade", "Mining", "Pickaxe", "Holder", "Sell", "Chest", "Prompt",
        "Tool", "Backpack", "Plot", "Base", "Owner", "Coin", "Gem"
    }

    if success and data then
        log("[GitHub] Word bank loaded successfully", Color3.fromRGB(100, 255, 150))
        for line in string.gmatch(data, "[^\r\n]+") do
            if line ~= "" and not table.find(defaultKeywords, line) then
                table.insert(defaultKeywords, line)
            end
        end
    else
        log("[GitHub] Failed to load word bank. Using defaults.", Color3.fromRGB(255, 150, 100))
    end

    return defaultKeywords
end

local function runScan(mode)
    log("\n[SCAN STARTED] Mode: " .. mode:upper(), Color3.fromRGB(255, 200, 100))

    local keywords = loadWordBank()

    -- Remotes
    log("\n[REMOTES]", Color3.fromRGB(120, 180, 255))
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            log("  RemoteEvent → " .. v:GetFullName())
        elseif v:IsA("RemoteFunction") then
            log("  RemoteFunction → " .. v:GetFullName())
        end
    end

    -- Important Data
    log("\n[IMPORTANT DATA]", Color3.fromRGB(120, 180, 255))
    for _, v in ipairs(game:GetDescendants()) do
        if perfMode == "light" and math.random() > 0.4 then continue end

        for _, kw in ipairs(keywords) do
            if string.find(v.Name, kw) and not string.find(v:GetFullName(), "CoreGui") then
                log("  " .. v:GetFullName() .. " [" .. v.ClassName .. "]")
                break
            end
        end

        for attr, val in pairs(v:GetAttributes()) do
            if string.find(attr, "Card") or string.find(attr, "Loot") or string.find(attr, "Tier") or string.find(attr, "Cost") then
                log("  ATTR → " .. v:GetFullName() .. " | " .. attr .. " = " .. tostring(val))
            end
        end
    end

    log("\n[SCAN COMPLETE]", Color3.fromRGB(100, 255, 150))

    if writefile then
        local name = "DeepSearch_" .. os.date("%Y%m%d_%H%M%S") .. ".txt"
        writefile(name, table.concat(logs, "\n"))
        log("File saved: " .. name, Color3.fromRGB(100, 255, 150))
    end
end

-- Commands
cmdBar.FocusLost:Connect(function(enter)
    if not enter then return end
    local input = string.lower(cmdBar.Text)
    cmdBar.Text = ""

    if input == "scan" or input == "quick" then
        runScan("quick")
    elseif input == "deep" then
        perfMode = "normal"
        runScan("deep")
    elseif input == "full" then
        perfMode = "aggressive"
        runScan("full")
    elseif input == "github" then
        loadWordBank()
    elseif input == "perf" then
        perfMode = (perfMode == "normal") and "light" or "normal"
        log("Performance Mode: " .. perfMode)
    elseif input == "help" then
        log("\n[COMMANDS]")
        log("scan / quick   → Quick scan")
        log("deep           → Deep scan")
        log("full           → Full aggressive scan")
        log("github         → Reload GitHub word bank")
        log("perf           → Toggle performance mode")
        log("clear          → Clear console")
        log("exit           → Close DeepSearch")
    elseif input == "clear" then
        logs = {}
        output.Text = ""
    elseif input == "exit" then
        gui:Destroy()
    else
        log("Unknown command. Type 'help'")
    end
end)

-- Buttons
local function makeBtn(text, x, func)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 78, 0, 24)
    b.Position = UDim2.new(0, x, 1, -28)
    b.BackgroundColor3 = Color3.fromRGB(22, 10, 38)
    b.TextColor3 = Color3.fromRGB(200, 150, 255)
    b.Text = text
    b.Font = Enum.Font.Code
    b.TextSize = 12
    b.Parent = main
    b.MouseButton1Click:Connect(func)
end

makeBtn("Quick", 10, function() runScan("quick") end)
makeBtn("Deep", 98, function() runScan("deep") end)
makeBtn("Full", 186, function() runScan("full") end)
makeBtn("GitHub", 274, function() loadWordBank() end)
makeBtn("Perf", 362, function()
    perfMode = (perfMode == "normal") and "light" or "normal"
    log("Performance Mode: " .. perfMode)
end)
makeBtn("Clear", 450, function() logs = {} output.Text = "" end)
makeBtn("Exit", 538, function() gui:Destroy() end)

log("[DeepSearch v8] Loaded.")
log("Make sure to change GITHUB_WORD_BANK to your own raw GitHub URL.")
log("The bigger your wordbank.txt is, the more it will find.")
