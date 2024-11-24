-- [ Bloxfruit Script By N4tzzSquadCommunity ]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local function antiDie()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.HealthChanged:Connect(function(health)
        if health <= 0 then
            humanoid.Health = 100
        end
    end)
end

local function teleportToPosition(position)
    local character = player.Character or player.CharacterAdded:Wait()
    if character.PrimaryPart then
        character:SetPrimaryPartCFrame(CFrame.new(position))
    else
        warn("PrimaryPart not set for the character!")
    end
end

local function createButton(parent, text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.Text = text
    button.Parent = parent
    button.MouseButton1Click:Connect(callback)
    return button
end

local function createTeleportButtons()
    local positions = {
        StarterIsland = Vector3.new(100, 100, 100),
        PirateIsland = Vector3.new(300, 100, 200),
        JungleIsland = Vector3.new(500, 100, 500)
    }

    local yOffset = 70
    for name, position in pairs(positions) do
        createButton(
            gui,
            "Teleport to " .. name,
            UDim2.new(0, 10, 0, yOffset),
            UDim2.new(0, 200, 0, 50),
            function() teleportToPosition(position) end
        )
        yOffset = yOffset + 60
    end
end

local function handleCommands(commandText)
    local args = commandText:split(" ")
    if args[1] == "/f" then
        local fruitType = args[2] or "None"
        local useMaxMastery = args[3] == "max"
        print("Activating fruit: " .. fruitType)
        if useMaxMastery then
            print("Maximizing mastery for " .. fruitType)
        end
    elseif args[1] == "/tp" then
        local targetPlayerName = args[2]
        local targetPlayer = Players:FindFirstChild(targetPlayerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            teleportToPosition(targetPlayer.Character.HumanoidRootPart.Position)
        else
            warn("Player not found or invalid character!")
        end
    else
        warn("Unknown command: " .. args[1])
    end
end

local function createAdminInterface()
    local commandBox = Instance.new("TextBox")
    commandBox.Size = UDim2.new(0, 200, 0, 50)
    commandBox.Position = UDim2.new(0, 10, 0, 250)
    commandBox.PlaceholderText = "Enter Command"
    commandBox.Text = ""
    commandBox.Parent = gui

    commandBox.FocusLost:Connect(function(enterPressed)
        if enterPressed and commandBox.Text ~= "" then
            handleCommands(commandBox.Text)
        end
    end)
end

local function displayStatsVisual()
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.Adornee = player.Character:WaitForChild("Head")
    billboard.Parent = gui

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0, 25)
    healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "Health: " .. player.Character.Humanoid.Health
    healthLabel.Parent = billboard

    local levelLabel = Instance.new("TextLabel")
    levelLabel.Size = UDim2.new(1, 0, 0, 25)
    levelLabel.Position = UDim2.new(0, 0, 0.5, 0)
    levelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    levelLabel.BackgroundTransparency = 1
    levelLabel.Text = "Level: " .. (player:FindFirstChild("Data") and player.Data.Level or "Unknown")
    levelLabel.Parent = billboard
end

antiDie()
createTeleportButtons()
createAdminInterface()
displayStatsVisual()
