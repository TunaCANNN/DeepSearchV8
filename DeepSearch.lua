--// DeepSearch v8 - Clean Terminal UI + Category Scanning
local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui")
gui.Name = "DeepSearch"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Window (Clean rounded style)
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 860, 0, 540)
main.Position = UDim2.new(0.5, -430, 0.5, -270)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 18)
corner.Parent = main

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
titleBar.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 18)
titleCorner.Parent = titleBar

-- Diamond Icon
local diamond = Instance.new("Frame")
diamond.Size = UDim2.new(0, 11, 0, 11)
diamond.Position = UDim2.new(0, 12, 0.5, -5.5)
diamond.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
diamond.Rotation = 45
diamond.Parent = titleBar

-- Title
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -30, 1, 0)
titleText.Position = UDim2.new(0, 30, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "DeepSearch v8"
titleText.TextColor3 = Color3.fromRGB(200, 200, 220)
titleText.TextScaled = true
titleText.Font = Enum.Font.Code
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Content Area
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -16, 1, -42)
content.Position = UDim2.new(0, 8, 0, 36)
content.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
content.Parent = main

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 12)
contentCorner.Parent = content

-- Console
local console = Instance.new("ScrollingFrame")
console.Size = UDim2.new(1, -16, 1, -55)
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

-- Load WordBank JSON
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

log("DeepSearch v8 loaded with category scanning.")
