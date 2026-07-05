--// DeepSearch v8 - Fusion + Copy Logs
local Fusion = loadstring(game:HttpGet("https://raw.githubusercontent.com/dphfox/Fusion/main/src/init.lua"))()

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

-- State
local logs = Value({})
local perfMode = Value("normal")
local autoSave = Value(true)
local currentLogs = {}

local function addLog(text)
    local ts = os.date("%H:%M:%S")
    local line = "[" .. ts .. "] " .. text
    table.insert(currentLogs, line)
    if #currentLogs > 70 then table.remove(currentLogs, 1) end
    logs:set(currentLogs)
end

-- GitHub WordBank
local WORDBANK_URL = "https://raw.githubusercontent.com/TunaCANNN/DeepSearchV8/refs/heads/main/wordbank.txt"

local function loadWordBank()
    local success, data = pcall(function()
        return game:HttpGet(WORDBANK_URL)
    end)

    if success and data then
        local keywords = {}
        for line in string.gmatch(data, "[^\r\n]+") do
            if line ~= "" then table.insert(keywords, line) end
        end
        addLog("Word bank loaded from GitHub (" .. #keywords .. " words)")
        return keywords
    else
        addLog("Failed to load word bank from GitHub!")
        return {}
    end
end

-- Scan Function
local function runScan(mode)
    addLog("Starting " .. mode .. " scan...")
    local keywords = loadWordBank()

    if #keywords == 0 then
        addLog("No keywords loaded.")
        return
    end

    for _, v in ipairs(game:GetDescendants()) do
        if perfMode:get() == "light" and math.random() > 0.5 then continue end

        for _, kw in ipairs(keywords) do
            if string.find(v.Name, kw) and not string.find(v:GetFullName(), "CoreGui") then
                addLog("→ " .. v:GetFullName())
                break
            end
        end
    end

    addLog("Scan complete.")

    if autoSave:get() and writefile then
        local name = "DeepSearch_" .. os.date("%Y%m%d_%H%M%S") .. ".txt"
        writefile(name, table.concat(currentLogs, "\n"))
        addLog("Log saved: " .. name)
    end
end

-- Main GUI
local screenGui = New "ScreenGui" {
    Name = "DeepSearch",
    ResetOnSpawn = false,
    Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),

    [Children] = {
        New "Frame" {
            Name = "MainWindow",
            Size = UDim2.new(0, 980, 0, 640),
            Position = UDim2.new(0.5, -490, 0.5, -320),
            BackgroundColor3 = Color3.fromRGB(12, 12, 18),
            BorderSizePixel = 0,

            [Children] = {
                -- Title Bar
                New "Frame" {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Color3.fromRGB(18, 8, 32),

                    [Children] = {
                        New "TextLabel" {
                            Size = UDim2.new(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                            Text = "DeepSearch v8 - Fusion",
                            TextColor3 = Color3.fromRGB(180, 100, 255),
                            TextScaled = true,
                            Font = Enum.Font.Code,
                        }
                    }
                },

                -- Sidebar
                New "Frame" {
                    Name = "Sidebar",
                    Size = UDim2.new(0, 150, 1, -34),
                    Position = UDim2.new(0, 0, 0, 34),
                    BackgroundColor3 = Color3.fromRGB(15, 8, 25),

                    [Children] = {
                        -- Quick Scan
                        New "TextButton" {
                            Size = UDim2.new(1, -10, 0, 34),
                            Position = UDim2.new(0, 5, 0, 10),
                            BackgroundColor3 = Color3.fromRGB(30, 12, 50),
                            Text = "Quick Scan",
                            TextColor3 = Color3.fromRGB(200, 150, 255),
                            Font = Enum.Font.Code,
                            TextSize = 14,
                            [OnEvent "MouseButton1Click"] = function() runScan("quick") end
                        },
                        -- Deep Scan
                        New "TextButton" {
                            Size = UDim2.new(1, -10, 0, 34),
                            Position = UDim2.new(0, 5, 0, 50),
                            BackgroundColor3 = Color3.fromRGB(30, 12, 50),
                            Text = "Deep Scan",
                            TextColor3 = Color3.fromRGB(200, 150, 255),
                            Font = Enum.Font.Code,
                            TextSize = 14,
                            [OnEvent "MouseButton1Click"] = function() runScan("deep") end
                        },
                        -- Full Scan
                        New "TextButton" {
                            Size = UDim2.new(1, -10, 0, 34),
                            Position = UDim2.new(0, 5, 0, 90),
                            BackgroundColor3 = Color3.fromRGB(30, 12, 50),
                            Text = "Full Scan",
                            TextColor3 = Color3.fromRGB(200, 150, 255),
                            Font = Enum.Font.Code,
                            TextSize = 14,
                            [OnEvent "MouseButton1Click"] = function() runScan("full") end
                        },
                        -- Reload WordBank
                        New "TextButton" {
                            Size = UDim2.new(1, -10, 0, 34),
                            Position = UDim2.new(0, 5, 0, 140),
                            BackgroundColor3 = Color3.fromRGB(30, 12, 50),
                            Text = "Reload WordBank",
                            TextColor3 = Color3.fromRGB(200, 150, 255),
                            Font = Enum.Font.Code,
                            TextSize = 14,
                            [OnEvent "MouseButton1Click"] = function() loadWordBank() end
                        },
                        -- Copy Logs
                        New "TextButton" {
                            Size = UDim2.new(1, -10, 0, 34),
                            Position = UDim2.new(0, 5, 0, 180),
                            BackgroundColor3 = Color3.fromRGB(30, 12, 50),
                            Text = "Copy Logs",
                            TextColor3 = Color3.fromRGB(200, 150, 255),
                            Font = Enum.Font.Code,
                            TextSize = 14,
                            [OnEvent "MouseButton1Click"] = function()
                                if setclipboard then
                                    setclipboard(table.concat(currentLogs, "\n"))
                                    addLog("Logs copied to clipboard")
                                else
                                    addLog("setclipboard not supported on this executor")
                                end
                            end
                        },
                        -- Clear Logs
                        New "TextButton" {
                            Size = UDim2.new(1, -10, 0, 34),
                            Position = UDim2.new(0, 5, 0, 220),
                            BackgroundColor3 = Color3.fromRGB(30, 12, 50),
                            Text = "Clear Logs",
                            TextColor3 = Color3.fromRGB(200, 150, 255),
                            Font = Enum.Font.Code,
                            TextSize = 14,
                            [OnEvent "MouseButton1Click"] = function()
                                currentLogs = {}
                                logs:set({})
                                addLog("Logs cleared")
                            end
                        },
                        -- Exit
                        New "TextButton" {
                            Size = UDim2.new(1, -10, 0, 34),
                            Position = UDim2.new(0, 5, 0, 260),
                            BackgroundColor3 = Color3.fromRGB(60, 20, 30),
                            Text = "Exit",
                            TextColor3 = Color3.fromRGB(255, 150, 150),
                            Font = Enum.Font.Code,
                            TextSize = 14,
                            [OnEvent "MouseButton1Click"] = function()
                                script.Parent.Parent:Destroy()
                            end
                        }
                    }
                },

                -- Main Console
                New "ScrollingFrame" {
                    Name = "Console",
                    Size = UDim2.new(1, -170, 1, -90),
                    Position = UDim2.new(0, 160, 0, 42),
                    BackgroundColor3 = Color3.fromRGB(8, 8, 12),
                    ScrollBarThickness = 6,

                    [Children] = {
                        New "TextLabel" {
                            Name = "Output",
                            Size = UDim2.new(1, -10, 1, 0),
                            BackgroundTransparency = 1,
                            TextColor3 = Color3.fromRGB(180, 100, 255),
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextYAlignment = Enum.TextYAlignment.Top,
                            Font = Enum.Font.Code,
                            TextSize = 13,
                            TextWrapped = true,
                            Text = Computed(function()
                                return table.concat(logs:get(), "\n")
                            end),
                        }
                    }
                },

                -- Command Bar
                New "TextBox" {
                    Name = "CommandBar",
                    Size = UDim2.new(1, -170, 0, 28),
                    Position = UDim2.new(0, 160, 1, -32),
                    BackgroundColor3 = Color3.fromRGB(12, 8, 20),
                    TextColor3 = Color3.fromRGB(200, 150, 255),
                    PlaceholderText = "Type commands...",
                    Font = Enum.Font.Code,
                    TextSize = 14,
                    ClearTextOnFocus = false,

                    [OnEvent "FocusLost"] = function(enterPressed)
                        if not enterPressed then return end
                        local input = string.lower(script.Parent.CommandBar.Text)
                        script.Parent.CommandBar.Text = ""

                        if input == "scan" or input == "quick" then runScan("quick")
                        elseif input == "deep" then runScan("deep")
                        elseif input == "full" then runScan("full")
                        elseif input == "perf" then
                            perfMode:set(perfMode:get() == "normal" and "light" or "normal")
                            addLog("Performance mode: " .. perfMode:get())
                        elseif input == "clear" then
                            currentLogs = {}
                            logs:set({})
                        elseif input == "exit" then
                            script.Parent.Parent:Destroy()
                        else
                            addLog("Unknown command")
                        end
                    end
                }
            }
        }
    }
}

addLog("DeepSearch v8 (Fusion) loaded with Copy Logs button.")
addLog("Using only GitHub word bank for scanning.")
