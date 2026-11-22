
-- AUT-Style GUI
-- For your own Roblox game
-- Place in StarterPlayerScripts as a LocalScript

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local itemsFolder = workspace:FindFirstChild("Items")

local gui = Instance.new("ScreenGui")
gui.Name = "UniversalHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(520, 350)
main.Position = UDim2.new(0.5, -260, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
title.Text = "UNIVERSAL HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = main

local function createButton(name, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.fromOffset(115, 32)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = name
    button.Font = Enum.Font.Gotham
    button.TextSize = 13
    button.Parent = main

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = button

    button.MouseButton1Click:Connect(callback)
    return button
end

local search = Instance.new("TextBox")
search.Size = UDim2.fromOffset(350, 32)
search.Position = UDim2.fromOffset(145, 65)
search.PlaceholderText = "Search for items..."
search.Text = ""
search.Parent = main

local results = Instance.new("ScrollingFrame")
results.Size = UDim2.fromOffset(350, 220)
results.Position = UDim2.fromOffset(145, 105)
results.BackgroundColor3 = Color3.fromRGB(27, 27, 34)
results.BorderSizePixel = 0
results.CanvasSize = UDim2.new()
results.ScrollBarThickness = 5
results.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = results

local function refreshItems()
    results:ClearAllChildren()
    layout.Parent = results

    if not itemsFolder then
        return
    end

    local query = string.lower(search.Text)

    for _, item in ipairs(itemsFolder:GetChildren()) do
        if string.find(string.lower(item.Name), query, 1, true) then
            local row = Instance.new("TextLabel")
            row.Size = UDim2.new(1, -10, 0, 35)
            row.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
            row.TextColor3 = Color3.new(1, 1, 1)
            row.Font = Enum.Font.Gotham
            row.TextSize = 12
            row.Text = item.Name
            row.Parent = results

            if item:IsA("BasePart") then
                local character = player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")

                if root then
                    row.Text = item.Name .. " | " ..
                        math.floor((root.Position - item.Position).Magnitude) .. " studs"
                end
            end
        end
    end

    task.wait()
    results.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 10)
end

search:GetPropertyChangedSignal("Text"):Connect(refreshItems)

createButton("Refresh Items", UDim2.fromOffset(15, 65), refreshItems)

createButton("Highlight Items", UDim2.fromOffset(15, 110), function()
    if not itemsFolder then return end

    for _, item in ipairs(itemsFolder:GetChildren()) do
        if item:IsA("BasePart") then
            local highlight = item:FindFirstChild("HubHighlight")
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "HubHighlight"
                highlight.Adornee = item
                highlight.FillColor = Color3.fromRGB(170, 80, 255)
                highlight.Parent = item
            end
        end
    end
end)

createButton("Clear Highlights", UDim2.fromOffset(15, 155), function()
    if not itemsFolder then return end

    for _, item in ipairs(itemsFolder:GetChildren()) do
        local highlight = item:FindFirstChild("HubHighlight")
        if highlight then
            highlight:Destroy()
        end
    end
end)

createButton("Close GUI", UDim2.fromOffset(15, 200), function()
    gui:Destroy()
end)

refreshItems()
