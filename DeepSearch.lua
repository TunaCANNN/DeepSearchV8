--// DeepSearch v8 - Final Terminal UI + Keybind
local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui")
gui.Name = "DeepSearch"
gui.ResetOnSpawn = false
gui.Parent = (gethui and gethui()) or player:WaitForChild("PlayerGui")

-- Main Window
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 860, 0, 540)
main.Position = UDim2.new(0.5, -430, 0.5, -270)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
main.BorderSizePixel = 0
main.Visible = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 18)
corner.Parent = main

-- Title Bar (Centered + Lowered)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
titleBar.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 18)
titleCorner.Parent = titleBar

-- Diamond Icon
local diamond = Instance.new("Frame")
diamond.Size = UDim2.new(0, 10, 0, 10)
diamond.Position = UDim2.new(0.5, -120, 0.5, -5)
diamond.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
diamond.Rotation = 45
diamond.Parent = titleBar

-- Title (Centered + Lowered)
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "DeepSearch v8"
titleText.TextColor3 = Color3.fromRGB(200, 200, 220)
titleText.TextScaled = true
titleText.Font = Enum.Font.Code
titleText.TextXAlignment = Enum.TextXAlignment.Center
titleText.Parent = titleBar

-- Content Area
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -16, 1, -40)
content.Position = UDim2.new(0, 8, 0, 34)
content.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
content.Parent = main

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 12)
contentCorner.Parent = content

-- Console
local console = Instance.new("ScrollingFrame")
console.Size = UDim2.new(1, -160, 1, -50)
console.Position = UDim2.new(0, 8, 0, 8)
console.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
console.ScrollBarThickness = 5
console.Parent = content

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
        log("Word bank loaded ("..#decoded.." categories)")
        return decoded
    else
        log("Failed to load word bank!")
        return {}
    end
end

-- Category Scan
local function scanCategory(category)
    local wordbank = loadWordBank()
    if not wordbank[category] then
        log("Category not found: "..category)
        return
    end

    log("Scanning: "..category)
    local keywords = wordbank[category]
    local found = 0

    for _, v in ipairs(game:GetDescendants()) do
        if perfMode == "light" and math.random() > 0.5 then continue end

        for _, kw in ipairs(keywords) do
            if string.find(v.Name, kw) and not string.find(v:GetFullName(), "CoreGui") then
                log("→ "..v:GetFullName())
                found += 1
                break
            end
        end
    end

    log("Found "..found.." matches in "..category)
end

-- Full Scan
local function runFullScan()
    local wordbank = loadWordBank()
    log("Starting full scan...")

    local total = 0
    for category, keywords in pairs(wordbank) do
        for _, v in ipairs(game:GetDescendants()) do
            if perfMode == "light" and math.random() > 0.5 then continue end

            for _, kw in ipairs(keywords) do
                if string.find(v.Name, kw) and not string.find(v:GetFullName(), "CoreGui") then
                    log("→ "..v:GetFullName())
                    total += 1
                    break
                end
            end
        end
    end

    log("Full scan complete. Total: "..total)
end

-- Keybind (RightShift to toggle UI)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

-- Sidebar Buttons
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 140, 1, -40)
sidebar.Position = UDim2.new(0, 8, 0, 36)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 8, 25)
sidebar.Parent = content

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

-- Buttons
local y = 8
createButton("Quick Scan", y, function() runFullScan() end); y += 34
createButton("Deep Scan", y, function() runFullScan() end); y += 34
createButton("Full Scan", y, function() runFullScan() end); y += 34
createButton("Weapons", y, function() scanCategory("Weapons") end); y += 34
createButton("Loot", y, function() scanCategory("Loot_Economy") end); y += 34
createButton("Economy", y, function() scanCategory("Loot_Economy") end); y += 34
createButton("Survival", y, function() scanCategory("Survival") end); y += 34
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
end)

log("DeepSearch v8 loaded.")
log("Press RightShift to hide/show UI.")
