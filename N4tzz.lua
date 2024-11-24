local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
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

local function handleCommands(commandText)
    local args = commandText:split(" ")
    if args[1] == "/f" then
        local fruitType = args[2] or "None"
        local useMaxMastery = args[3] == "max"
        activateFruit(fruitType, useMaxMastery)
    elseif args[1] == "/tp" then
        local targetPlayerName = args[2]
        teleportToPlayer(targetPlayerName)
    end
end

local function activateFruit(fruitType, maxMastery)
    print("Activating fruit: " .. fruitType)
    if maxMastery then
        print("Maximizing mastery for " .. fruitType)
    end
end

local function teleportToPlayer(playerName)
    local targetPlayer = game.Players:FindFirstChild(playerName)
    if targetPlayer then
        local targetCharacter = targetPlayer.Character
        if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
            teleportToPosition(targetCharacter.HumanoidRootPart.Position)
        else
            print("Target player has no valid character.")
        end
    else
        print("Player not found.")
    end
end

local function teleportToPosition(position)
    local character = player.Character or player.CharacterAdded:Wait()
    character:SetPrimaryPartCFrame(CFrame.new(position))
end

local function setBoatSpeed(speed)
    local boat = workspace:FindFirstChild("Boat")
    if boat then
        boat.Velocity = Vector3.new(speed, 0, speed)
    else
        print("Boat not found.")
    end
end

local function displayStatsVisual()
    local stats = Instance.new("BillboardGui")
    stats.Size = UDim2.new(0, 200, 0, 50)
    stats.Adornee = player.Character:WaitForChild("Head")
    stats.Parent = player.PlayerGui

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Text = "Health: " .. player.Character.Humanoid.Health
    healthLabel.Size = UDim2.new(1, 0, 0, 25)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthLabel.Parent = stats

    local levelLabel = Instance.new("TextLabel")
    levelLabel.Text = "Level: " .. player.Data.Level
    levelLabel.Size = UDim2.new(1, 0, 0, 25)
    levelLabel.Position = UDim2.new(0, 0, 0.5, 0)
    levelLabel.BackgroundTransparency = 1
    levelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    levelLabel.Parent = stats
end

local function createTeleportButtons()
    local starterIslandButton = Instance.new("TextButton")
    starterIslandButton.Size = UDim2.new(0, 200, 0, 50)
    starterIslandButton.Position = UDim2.new(0, 10, 0, 70)
    starterIslandButton.Text = "Teleport to Starter Island"
    starterIslandButton.Parent = gui
    starterIslandButton.MouseButton1Click:Connect(function()
        teleportToPosition(Vector3.new(100, 100, 100))
    end)
end

local function adminCommands()
    local commandBox = Instance.new("TextBox")
    commandBox.Size = UDim2.new(0, 200, 0, 50)
    commandBox.Position = UDim2.new(0, 10, 0, 190)
    commandBox.Text = "Enter Command"
    commandBox.Parent = gui
    commandBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local command = commandBox.Text
            handleCommands(command)
        end
    end)
end

local function createAdminInterface()
    local adminButton = Instance.new("TextButton")
    adminButton.Size = UDim2.new(0, 200, 0, 50)
    adminButton.Position = UDim2.new(0, 10, 0, 310)
    adminButton.Text = "Admin Command Box"
    adminButton.Parent = gui
    adminButton.MouseButton1Click:Connect(function()
        adminCommands()
    end)
end

createTeleportButtons()
createAdminInterface()


antiDie()
displayStatsVisual()
