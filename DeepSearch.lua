--// DeepSearch v8 - Final Complete Version
local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Services & Variables
local gui = Instance.new("ScreenGui")
gui.Name = "DeepSearch"
gui.ResetOnSpawn = false
gui.Parent = (gethui and gethui()) or player:WaitForChild("PlayerGui")

local currentLogs = {}
local perfMode = "normal"
local autoSave = true

-- Main Window
local main = Instance.new("Frame")
main.Name = "MainWindow"
main.Size = UDim2.new(0, 880, 0, 560)
main.Position = UDim2.new(0.5, -440, 0.5, -280)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.BorderSizePixel = 0
main.Visible = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
titleBar.Parent = main

Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 16)

-- Diamond Icon
local diamond = Instance.new("Frame")
diamond.Size = UDim2.new(0, 10, 0, 10)
diamond.Position = UDim2.new(0.5, -130, 0.5, -5)
diamond.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
diamond.Rotation = 45
diamond.Parent = titleBar

-- Title (Centered + Lowered)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "DeepSearch v8"
title.TextColor3 = Color3.fromRGB(200, 200, 220)
title.TextScaled = true
title.Font = Enum.Font.Code
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = titleBar

-- Console
local console = Instance.new("ScrollingFrame")
console.Size = UDim2.new(1, -160, 1, -55)
console.Position = UDim2.new(0, 150, 0, 38)
console.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
console.ScrollBarThickness = 5
console.Parent = main

local output = Instance.new("TextLabel")
output.Size = UDim2.new(1, -8, 1, 0)
output.BackgroundTransparency = 1
output.TextColor3 = Color3.fromRGB(180, 100, 255)
output.TextXAlignment = Enum.TextXAlignment.Left
output.TextYAlignment = Enum.TextYAlignment.Top
output.Font = Enum.Font.Code
output.TextSize = 13
output.TextWrapped = true
output.Parent = console

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 140, 1, -38)
sidebar.Position = UDim2.new(0, 6, 0, 36)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 8, 25)
sidebar.Parent = main

-- Command Bar
local cmdBar = Instance.new("TextBox")
cmdBar.Size = UDim2.new(1, -160, 0, 26)
cmdBar.Position = UDim2.new(0, 150, 1, -30)
cmdBar.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
cmdBar.TextColor3 = Color3.fromRGB(200, 150, 255)
cmdBar.PlaceholderText = "Type commands..."
cmdBar.Font = Enum.Font.Code
cmdBar.TextSize = 13
cmdBar.ClearTextOnFocus = false
cmdBar.Parent = main

-- Variables
local currentLogs = {}
local perfMode = "normal"
local autoSave = true

local function log(text)
    local ts = os.date("%H:%M:%S")
    local line = "["..ts.."] "..text
    table.insert(currentLogs, line)
    if #currentLogs > 60 then table.remove(currentLogs, 1) end
    output.Text = table.concat(currentLogs, "\n")
    console.CanvasPosition = Vector2.new(0, console.AbsoluteCanvasSize.Y)
end

-- WordBank JSON
local WORDBANK_URL = "https://raw.githubusercontent.com/TunaCANNN/DeepSearchV8/refs/heads/main/wordbank.json"

local function loadWordBank()
    local success, data = pcall(function()
        return game:HttpGet(WORDBANK_URL)
    end)

    if success and data then
        local decoded = HttpService:JSONDecode(data)
        local keywords = {}
        for _, list in pairs(decoded) do
            for _, word in ipairs(list) do
                table.insert(keywords, word)
            end
        end
        log("Word bank loaded (" .. #keywords .. " words)")
        return keywords
    else
        log("Failed to load word bank!")
        return {}
    end
end

-- Scanning
local function runScan(mode)
    log("Starting " .. mode .. " scan...")
    local keywords = loadWordBank()

    if #keywords == 0 then
        log("No keywords loaded.")
        return
    end

    local found = 0
    for _, v in ipairs(game:GetDescendants()) do
        if perfMode == "light" and math.random() > 0.5 then continue end

        for _, kw in ipairs(keywords) do
            if string.find(v.Name, kw) and not string.find(v:GetFullName(), "CoreGui") then
                log("→ " .. v:GetFullName())
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

-- Keybind (RightShift)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

-- Button Creator
local function createButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 10, 42)
    btn.TextColor3 = Color3.fromRGB(200, 150, 255)
    btn.Text = text
    btn.Font = Enum.Font.Code
    btn.TextSize = 13
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
end

-- Sidebar Buttons
local y = 8
createButton("Quick Scan", y, function() runScan("quick") end); y += 34
createButton("Deep Scan", y, function() runScan("deep") end); y += 34
createButton("Full Scan", y, function() runScan("full") end); y += 34
createButton("Copy Logs", y, function()
    if setclipboard then
        setclipboard(table.concat(currentLogs, "\n"))
        log("Logs copied to clipboard")
    else
        log("setclipboard not supported")
    end
end); y += 34
createButton("Clear Logs", y, function()
    currentLogs = {}
    output.Text = ""
    log("Logs cleared")
end); y += 34
createButton("Exit", y, function() gui:Destroy() end)

-- Command Bar
cmdBar.FocusLost:Connect(function(enter)
    if not enter then return end
    local input = string.lower(cmdBar.Text)
    cmdBar.Text = ""

    if input == "scan" or input == "quick" then runScan("quick")
    elseif input == "deep" then runScan("deep")
    elseif input == "full" then runScan("full")
    elseif input == "perf" then
        perfMode = (perfMode == "normal") and "light" or "normal"
        log("Performance mode: " .. perfMode)
    elseif input == "clear" then
        currentLogs = {}
        output.Text = ""
    elseif input == "exit" then
        gui:Destroy()
    else
        log("Unknown command")
    end
end)

log("DeepSearch v8 loaded successfully.")
log("Press RightShift to hide/show UI.")
