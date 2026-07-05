--// DeepSearch v8 - UI Overhauled
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui")
gui.Name = "DeepSearch"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Window
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 950, 0, 620)
main.Position = UDim2.new(0.5, -475, 0.5, -310)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 8, 32)
titleBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "DeepSearch v8  •  Terminal"
title.TextColor3 = Color3.fromRGB(180, 100, 255)
title.TextScaled = true
title.Font = Enum.Font.Code
title.Parent = titleBar

-- === SIDEBAR ===
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 130, 1, -32)
sidebar.Position = UDim2.new(0, 0, 0, 32)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 8, 25)
sidebar.Parent = main

-- Main Console
local mainConsole = Instance.new("ScrollingFrame")
mainConsole.Size = UDim2.new(1, -150, 0.65, -10)
mainConsole.Position = UDim2.new(0, 140, 0, 40)
mainConsole.BackgroundColor3 = Color3.fromRGB(6, 6, 10)
mainConsole.ScrollBarThickness = 6
mainConsole.Parent = main

local mainOutput = Instance.new("TextLabel")
mainOutput.Size = UDim2.new(1, -10, 1, 0)
mainOutput.BackgroundTransparency = 1
mainOutput.TextColor3 = Color3.fromRGB(180, 100, 255)
mainOutput.TextXAlignment = Enum.TextXAlignment.Left
mainOutput.TextYAlignment = Enum.TextYAlignment.Top
mainOutput.Font = Enum.Font.Code
mainOutput.TextSize = 13
mainOutput.TextWrapped = true
mainOutput.Parent = mainConsole

-- Button Console (Separate output for button actions)
local buttonConsole = Instance.new("ScrollingFrame")
buttonConsole.Size = UDim2.new(1, -150, 0.3, -10)
buttonConsole.Position = UDim2.new**DeepSearch v8 - Complete UI Overhaul**

Here's a full redesign with:

- **Sidebar buttons** (left side)
- **Hover effects** (color + slight scale)
- **Click effects** (flash + scale)
- **Separate console area** for button outputs
- Much cleaner and more modern terminal look
- Better spacing and organization

```lua
--// DeepSearch v8 - UI Overhauled
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui")
gui.Name = "DeepSearch"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Window
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 950, 0, 620)
main.Position = UDim2.new(0.5, -475, 0.5, -310)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 8, 32)
titleBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "DeepSearch v8  •  Terminal"
title.TextColor3 = Color3.fromRGB(180, 100, 255)
title.TextScaled = true
title.Font = Enum.Font.Code
title.Parent = titleBar

-- === SIDEBAR ===
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 130, 1, -32)
sidebar.Position = UDim2.new(0, 0, 0, 32)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 8, 25)
sidebar.Parent = main

-- Main Console
local mainConsole = Instance.new("ScrollingFrame")
mainConsole.Size = UDim2.new(1, -150, 0.65, -10)
mainConsole.Position = UDim2.new(0, 140, 0, 40)
mainConsole.BackgroundColor3 = Color3.fromRGB(6, 6, 10)
mainConsole.ScrollBarThickness = 6
mainConsole.Parent = main

local mainOutput = Instance.new("TextLabel")
mainOutput.Size = UDim2.new(1, -10, 1, 0)
mainOutput.BackgroundTransparency = 1
mainOutput.TextColor3 = Color3.fromRGB(180, 100, 255)
mainOutput.TextXAlignment = Enum.TextXAlignment.Left
mainOutput.TextYAlignment = Enum.TextYAlignment.Top
mainOutput.Font = Enum.Font.Code
mainOutput.TextSize = 13
mainOutput.TextWrapped = true
mainOutput.Parent = mainConsole

-- Button Console (Separate output for button actions)
local buttonConsole = Instance.new("ScrollingFrame")
buttonConsole.Size = UDim2.new(1, -150, 0.3, -10)
buttonConsole.Position = UDim2.new(0, 140, 0.68, 0)
buttonConsole.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
buttonConsole.ScrollBarThickness = 5
buttonConsole.Parent = main

local buttonOutput = Instance.new("TextLabel")
buttonOutput.Size = UDim2.new(1, -10, 1, 0)
buttonOutput.BackgroundTransparency = 1
buttonOutput.TextColor3 = Color3.fromRGB(150, 200, 255)
buttonOutput.TextXAlignment = Enum.TextXAlignment.Left
buttonOutput.TextYAlignment = Enum.TextYAlignment.Top
buttonOutput.Font = Enum.Font.Code
buttonOutput.TextSize = 12
buttonOutput.TextWrapped = true
buttonOutput.Parent = buttonConsole

-- Command Bar
local cmdBar = Instance.new("TextBox")
cmdBar.Size = UDim2.new(1, -150, 0, 26)
cmdBar.Position = UDim2.new(0, 140, 1, -30)
cmdBar.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
cmdBar.TextColor3 = Color3.fromRGB(200, 150, 255)
cmdBar.PlaceholderText = "Type commands here..."
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
status.Text = "Mode: Normal  |  AutoSave: ON"
status.TextScaled = true
status.Font = Enum.Font.Code
status.Parent = main

local logs = {}
local buttonLogs = {}

local function logMain(text)
    local ts = os.date("%H:%M:%S")
    table.insert(logs, "["..ts.."] " .. text)
    if #logs > 65 then table.remove(logs, 1) end
    mainOutput.Text = table.concat(logs, "\n")
    mainConsole.CanvasPosition = Vector2.new(0, mainConsole.AbsoluteCanvasSize.Y)
end

local function logButton(text)
    local ts = os.date("%H:%M:%S")
    table.insert(buttonLogs, "["..ts.."] " .. text)
    if #buttonLogs > 25 then table.remove(buttonLogs, 1) end
    buttonOutput.Text = table.concat(buttonLogs, "\n")
    buttonConsole.CanvasPosition = Vector2.new(0, buttonConsole.AbsoluteCanvasSize.Y)
end

-- Button Creation with Hover/Click Effects
local function createSidebarButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 10, 40)
    btn.TextColor3 = Color3.fromRGB(200, 150, 255)
    btn.Text = text
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    btn.Parent = sidebar

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    -- Hover Effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(40, 15, 65),
            Size = UDim2.new(1, -5, 0, 34)
        }):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(25, 10, 40),
            Size = UDim2.new(1, -10, 0, 32)
        }):Play()
    end)

    -- Click Effect
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.08), {
            BackgroundColor3 = Color3.fromRGB(80, 30, 120),
            Size = UDim2.new(1, -15, 0, 30)
        }):Play()
    end)

    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(40, 15, 65),
            Size = UDim2.new(1, -5, 0, 34)
        }):Play()
        callback()
    end)

    return btn
end

-- Scan Function
local function runScan(mode)
    logMain("\n[SCAN STARTED] Mode: " .. mode:upper(), Color3.fromRGB(255, 200, 100))
    logButton("Running " .. mode .. " scan...")

    -- Add your actual scanning logic here
    logMain("[REMOTES] Scanning...")
    logMain("[IMPORTANT DATA] Scanning...")

    logMain("\n[SCAN COMPLETE]", Color3.fromRGB(100, 255, 150))
    logButton("Scan finished successfully.")
end

-- Sidebar Buttons
local y = 10
createSidebarButton("Quick Scan", y, function() runScan("quick") end); y += 38
createSidebarButton("Deep Scan", y, function() runScan("deep") end); y += 38
createSidebarButton("Full Scan", y, function() runScan("full") end); y += 38
createSidebarButton("Performance", y, function()
    perfMode = (perfMode == "normal") and "light" or "normal"
    logButton("Performance mode set to: " .. perfMode)
end); y += 38
createSidebarButton("GitHub", y, function()
    logButton("Reloading word bank from GitHub...")
end); y += 38
createSidebarButton("Clear", y, function()
    logs = {}
    mainOutput.Text = ""
    logButton("Console cleared.")
end); y += 38
createSidebarButton("Exit", y, function()
    gui:Destroy()
end)

logMain("[DeepSearch v8] Overhauled UI loaded.")
logButton("Ready. Use sidebar buttons or type commands.")
