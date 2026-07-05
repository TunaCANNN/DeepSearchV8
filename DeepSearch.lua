--// DeepSearch v8 - Modern Code Editor UI
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui")
gui.Name = "DeepSearch"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Window
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 1000, 0, 620)
main.Position = UDim2.new(0.5, -500, 0.5, -310)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 36)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
topBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "DeepSearch v8"
title.TextColor3 = Color3.fromRGB(180, 100, 255)
title.TextScaled = true
title.Font = Enum.Font.Code
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- Status on top bar
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.5, 0, 1, 0)
statusLabel.Position = UDim2.new(0.5, 0, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Mode: Normal  |  GitHub: Connected  |  AutoSave: ON"
statusLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Code
statusLabel.TextXAlignment = Enum.TextXAlignment.Right
statusLabel.Parent = topBar

-- Main Console
local console = Instance.new("ScrollingFrame")
console.Size = UDim2.new(1, -20, 1, -95)
console.Position = UDim2.new(0, 10, 0, 44)
console.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
console.ScrollBarThickness = 6
console.Parent = main

local output = Instance.new("TextLabel")
output.Size = UDim2.new(1, -12, 1, 0)
output.BackgroundTransparency = 1
output.TextColor3 = Color3.fromRGB(180, 100, 255)
output.TextXAlignment = Enum.TextXAlignment.Left
output.TextYAlignment = Enum.TextYAlignment.Top
output.Font = Enum.Font.Code
output.TextSize = 14
output.TextWrapped = true
output.Parent = console

local logs = {}

local function log(text, color)
    color = color or Color3.fromRGB(180, 100, 255)
    local ts = os.date("%H:%M:%S")
    table.insert(logs, "["..ts.."] " .. text)
    if #logs > 65 then table.remove(logs, 1) end
    output.Text = table.concat(logs, "\n")
    console.CanvasPosition = Vector2.new(0, console.AbsoluteCanvasSize.Y)
end

-- Command Bar
local cmdBar = Instance.new("TextBox")
cmdBar.Size = UDim2.new(1, -20, 0, 28)
cmdBar.Position = UDim2.new(0, 10, 1, -32)
cmdBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
cmdBar.TextColor3 = Color3.fromRGB(200, 150, 255)
cmdBar.PlaceholderText = "Type command (scan, deep, full, perf, help, clear, exit)..."
cmdBar.Font = Enum.Font.Code
cmdBar.TextSize = 14
cmdBar.ClearTextOnFocus = false
cmdBar.Parent = main

-- Floating Action Buttons (Top Right)
local function createActionButton(text, xOffset, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 85, 0, 26)
    btn.Position = UDim2.new(1, xOffset, 0, 5)
    btn.BackgroundColor3 = Color3.fromRGB(30, 12, 50)
    btn.TextColor3 = Color3.fromRGB(200, 150, 255)
    btn.Text = text
    btn.Font = Enum.Font.Code
    btn.TextSize = 13
    btn.Parent = topBar

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    -- Hover
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(50, 18, 80)
        }):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(30, 12, 50)
        }):Play()
    end)

    -- Click
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.08), {
            BackgroundColor3 = Color3.fromRGB(90, 30, 130)
        }):Play()
        task.delay(0.1, function()
            TweenService:Create(btn, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(50, 18, 80)
            }):Play()
        end)
        callback()
    end)

    return btn
end

-- Action Buttons
createActionButton("Quick", -280, function() 
    log("Quick scan started")
end)

createActionButton("Deep", -185, function() 
    log("Deep scan started")
end)

createActionButton("Full", -90, function() 
    log("Full scan started")
end)

-- Command System
cmdBar.FocusLost:Connect(function(enter)
    if not enter then return end
    local input = string.lower(cmdBar.Text)
    cmdBar.Text = ""

    if input == "scan" or input == "quick" then
        log("Quick scan executed")
    elseif input == "deep" then
        log("Deep scan executed")
    elseif input == "full" then
        log("Full scan executed")
    elseif input == "perf" then
        log("Performance mode toggled")
    elseif input == "help" then
        log("Available: scan, deep, full, perf, clear, exit")
    elseif input == "clear" then
        logs = {}
        output.Text = ""
    elseif input == "exit" then
        gui:Destroy()
    else
        log("Unknown command")
    end
end)

log("[DeepSearch v8] Modern UI loaded successfully.")
log("Type commands in the bottom bar or use the top buttons.")
