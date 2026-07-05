--// DeepSearch v8 - Terminal UI + JSON WordBank
local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui")
gui.Name = "DeepSearch"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Window
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 920, 0, 600)
main.Position = UDim2.new(0.5, -460, 0.5, -300)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 8, 32)
titleBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "DeepSearch v8  •  Terminal + JSON WordBank"
title.TextColor3 = Color3.fromRGB(180, 100, 255)
title.TextScaled = true
title.Font = Enum.Font.Code
title.Parent = titleBar

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 140, 1, -32)
sidebar.Position = UDim2.new(0, 0, 0, 32)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 8, 25)
sidebar.Parent = main

-- Main Console
local console = Instance.new("ScrollingFrame")
console.Size = UDim2.new(1, -160, 1, -75)
console.Position = UDim2.new(0, 150, 0, 40)
console.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
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

local currentLogs = {}
local perfMode = "normal"
local autoSave = true

local function log(text)
    local ts = os.date("%H:%M:%S")
    local line = "[" .. ts .. "] " .. text
    table.insert(currentLogs, line)
    if #currentLogs > 65 then table.remove(currentLogs, 1) end
    output.Text = table.concat(currentLogs, "\n")
    console.CanvasPosition = Vector2.new(0, console.AbsoluteCanvasSize.Y)
end

-- Load WordBank from JSON (Dictionary)
local WORDBANK_URL = "https://raw.githubusercontent.com/TunaCANNN/DeepSearchV8/refs/heads/main/wordbank.json"

local function loadWordBank()
    local success, data = pcall(function()
        return game:HttpGet(WORDBANK_URL)
    end)

    if success and data then
        local decoded = HttpService:JSONDecode(data)
        local keywords = {}

        for category, list in pairs(decoded) do
            for _, word in ipairs(list) do
                table.insert(keywords, word)
            end
        end

        log("Word bank loaded from GitHub (" .. #keywords .. " words)")
        return keywords
    else
        log("Failed to load word bank from GitHub!")
        return {}
    end
end

-- Scanning Logic (Uses only JSON WordBank)
local function runScan(mode)
    log("Starting " .. mode .. " scan...")

    local keywords = loadWordBank()
    if #keywords == 0 then
        log("No keywords loaded. Scan cancelled.")
        return
    end

    local found = 0

    for _, v in ipairs(game:GetDescendants()) do
        if perfMode == "light" and math.random() > 0.5 then continue end

        for _, kw in ipairs(keywords) do
            if string.find(v.Name, kw) and not string.find(v:GetFullName(), "CoreGui") then
                log("→ " .. v:GetFullName() .. " [" .. v.ClassName .. "]")
                found += 1
                break
            end
        end
    end

    log("Scan complete. Found " .. found .. " matches.")

    if autoSave and writefile then
        local name = "DeepSearch_" .. os.date("%Y%m%d_%H%M%S") .. ".txt"
        writefile(name, table.concat(currentLogs, "\n"))
        log("Log saved: " .. name)
    end
end

-- Button Creator with Effects
local function createButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 32)
    btn.Position = UDim2.new(0, 6, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 10, 42)
    btn.TextColor3 = Color3.fromRGB(200, 150, 255)
    btn.Text = text
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    btn.Parent = sidebar

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(45, 15, 70)
        }):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(25, 10, 42)
        }):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.06), {
            BackgroundColor3 = Color3.fromRGB(90, 30, 130)
        }):Play()
        task.delay(0.08, function()
            TweenService:Create(btn, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(45, 15, 70)
            }):Play()
        end)
        callback()
    end)

    return btn
end

-- Sidebar Buttons
local y = 10
createButton("Quick Scan", y, function() runScan("quick") end); y += 38
createButton("Deep Scan", y, function() runScan("deep") end); y += 38
createButton("Full Scan", y, function() runScan("full") end); y += 38
createButton("Reload WordBank", y, function() loadWordBank() end); y += 38
createButton("Copy Logs", y, function()
    if setclipboard then
        setclipboard(table.concat(currentLogs, "\n"))
        log("Logs copied to clipboard")
    else
        log("setclipboard not supported")
    end
end); y += 38
createButton("Clear Logs", y, function()
    currentLogs = {}
    output.Text = ""
    log("Logs cleared")
end); y += 38
createButton("Exit", y, function() gui:Destroy() end)

log("DeepSearch v8 loaded with JSON WordBank support.")
log("Scanning now uses your full dictionary word bank.")
