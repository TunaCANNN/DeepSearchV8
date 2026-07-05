--// DeepSearch v8 - Expanded UI v2
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui")
gui.Name = "DeepSearch"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 980, 0, 660)
main.Position = UDim2.new(0.5, -490, 0.5, -330)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 34)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 8, 32)
titleBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "DeepSearch v8  •  Terminal  •  Overhauled UI"
title.TextColor3 = Color3.fromRGB(180, 100, 255)
title.TextScaled = true
title.Font = Enum.Font.Code
title.Parent = titleBar

-- === SIDEBAR ===
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 140, 1, -34)
sidebar.Position = UDim2.new(0, 0, 0, 34)
sidebar.BackgroundColor3 = Color3.fromRGB(14, 8, 24)
sidebar.Parent = main

-- Main Console
local mainConsole = Instance.new("ScrollingFrame")
mainConsole.Size = UDim2.new(1, -160, 0.72, -10)
mainConsole.Position = UDim2.new(0, 150, 0, 42)
mainConsole.BackgroundColor3 = Color3.fromRGB(6, 6, 10)
mainConsole.ScrollBarThickness = 6
mainConsole.Parent = main

local mainOutput = Instance.new("TextLabel")
mainOutput.Size = UDim2.new(1, -12, 1, 0)
mainOutput.BackgroundTransparency = 1
mainOutput.TextColor3 = Color3.fromRGB(180, 100, 255)
mainOutput.TextXAlignment = Enum.TextXAlignment.Left
mainOutput.TextYAlignment = Enum.TextYAlignment.Top
mainOutput.Font = Enum.Font.Code
mainOutput.TextSize = 13
mainOutput.TextWrapped = true
mainOutput.Parent = mainConsole

-- Button Console
local btnConsole = Instance.new("ScrollingFrame")
btnConsole.Size = UDim2.new(1, -160, 0.23, -10)
btnConsole.Position = UDim2.new(0, 150, 0.75, 0)
btnConsole.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
btnConsole.ScrollBarThickness = 5
btnConsole.Parent = main

local btnOutput = Instance.new("TextLabel")
btnOutput.Size = UDim2.new(1, -12, 1, 0)
btnOutput.BackgroundTransparency = 1
btnOutput.TextColor3 = Color3.fromRGB(140, 200, 255)
btnOutput.TextXAlignment = Enum.TextXAlignment.Left
btnOutput.TextYAlignment = Enum.TextYAlignment.Top
btnOutput.Font = Enum.Font.Code
btnOutput.TextSize = 12
btnOutput.TextWrapped = true
btnOutput.Parent = btnConsole

-- Search Bar
local searchBar = Instance.new("TextBox")
searchBar.Size = UDim2.new(1, -160, 0, 26)
searchBar.Position = UDim2.new(0, 150, 1, -58)
searchBar.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
searchBar.TextColor3 = Color3.fromRGB(200, 150, 255)
searchBar.PlaceholderText = "Filter console..."
searchBar.Font = Enum.Font.Code
searchBar.TextSize = 13
searchBar.Parent = main

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

-- Status Bar
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 22)
status.Position = UDim2.new(0, 0, 1, -52)
status.BackgroundColor3 = Color3.fromRGB(15, 8, 28)
status.TextColor3 = Color3.fromRGB(150, 150, 200)
status.Text = "Mode: Normal  |  AutoSave: ON  |  GitHub: Connected"
status.TextScaled = true
status.Font = Enum.Font.Code
status.Parent = main

local logs = {}
local btnLogs = {}

local function logMain(text)
    local ts = os.date("%H:%M:%S")
    table.insert(logs, "["..ts.."] " .. text)
    if #logs > 70 then table.remove(logs, 1) end
    mainOutput.Text = table.concat(logs, "\n")
    mainConsole.CanvasPosition = Vector2.new(0, mainConsole.AbsoluteCanvasSize.Y)
end

local function logBtn(text)
    local ts = os.date("%H:%M:%S")
    table.insert(btnLogs, "["..ts.."] " .. text)
    if #btnLogs > 20 then table.remove(btnLogs, 1) end
    btnOutput.Text = table.concat(btnLogs, "\n")
    btnConsole.CanvasPosition = Vector2.new(0, btnConsole.AbsoluteCanvasSize.Y)
end

-- Enhanced Button with Effects
local function createButton(text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 34)
    btn.Position = UDim2.new(0, 6, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(25, 10, 42)
    btn.TextColor3 = Color3.fromRGB(200, 150, 255)
    btn.Text = text
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    btn.Parent = sidebar

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    -- Hover Effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(45, 15, 75),
            Size = UDim2.new(1, -6, 0, 36)
        }):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(25, 10, 42),
            Size = UDim2.new(1, -12, 0, 34)
        }):Play()
    end)

    -- Click Effect
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.06), {
            BackgroundColor3 = Color3.fromRGB(90, 30, 130),
            Size = UDim2.new(1, -18, 0, 32)
        }):Play()
    end)

    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(45, 15, 75),
            Size = UDim2.new(1, -6, 0, 36)
        }):Play()
        callback()
    end)

    return btn
end

-- Buttons
local yPos = 12
createButton("Quick Scan", yPos, function() 
    logBtn("Quick Scan started")
    -- Add scan logic here
end); yPos += 40

createButton("Deep Scan", yPos, function() 
    logBtn("Deep Scan started")
end); yPos += 40

createButton("Full Scan", yPos, function() 
    logBtn("Full Scan started")
end); yPos += 40

createButton("Performance", yPos, function() 
    perfMode = (perfMode == "normal") and "light" or "normal"
    logBtn("Performance mode: " .. perfMode)
end); yPos += 40

createButton("GitHub", yPos, function() 
    logBtn("Reloading word bank from GitHub...")
end); yPos += 40

createButton("Clear", yPos, function() 
    logs = {}
    mainOutput.Text = ""
    logBtn("Console cleared")
end); yPos += 40

createButton("Exit", yPos, function() 
    gui:Destroy()
end)

logMain("[DeepSearch v8] UI Overhauled v2 loaded.")
logBtn("Ready. Hover and click buttons to see effects.")

-- Search Filter
searchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local filter = string.lower(searchBar.Text)
    if filter == "" then
        mainOutput.Text = table.concat(logs, "\n")
        return
    end
    
    local filtered = {}
    for _, line in ipairs(logs) do
        if string.find(string.lower(line), filter) then
            table.insert(filtered, line)
        end
    end
    mainOutput.Text = table.concat(filtered, "\n")
end)
