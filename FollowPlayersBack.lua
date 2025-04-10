-- Player Teleport GUI
-- Creates a draggable list of players that allows you to teleport behind them and follow them

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Variables
local currentlyFollowing = nil
local followConnection = nil
local FOLLOW_OFFSET = Vector3.new(0, 0, 5) -- 5 studs behind the player

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlayerTeleportGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Create main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 300)
MainFrame.Position = UDim2.new(0.85, 0, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Create title
local TitleFrame = Instance.new("Frame")
TitleFrame.Name = "TitleFrame"
TitleFrame.Size = UDim2.new(1, 0, 0, 30)
TitleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleFrame.BorderSizePixel = 0
TitleFrame.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Players"
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextSize = 18
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Parent = TitleFrame

-- Create stop following button
local StopButton = Instance.new("TextButton")
StopButton.Name = "StopButton"
StopButton.Position = UDim2.new(0, 10, 1, -40)
StopButton.Size = UDim2.new(1, -20, 0, 30)
StopButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
StopButton.BorderSizePixel = 0
StopButton.Text = "Stop Following"
StopButton.Font = Enum.Font.SourceSansBold
StopButton.TextSize = 16
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.Parent = MainFrame

-- Create ScrollingFrame for player list
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "PlayerList"
ScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
ScrollingFrame.Size = UDim2.new(1, 0, 1, -80)
ScrollingFrame.BackgroundTransparency = 0.5
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.Parent = MainFrame

-- Create UIListLayout for organizing player buttons
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 2)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = ScrollingFrame

-- Function to create a player button
local function CreatePlayerButton(player)
    local PlayerButton = Instance.new("TextButton")
    PlayerButton.Name = player.Name
    PlayerButton.Size = UDim2.new(0.95, 0, 0, 30)
    PlayerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    PlayerButton.Text = player.Name
    PlayerButton.Font = Enum.Font.SourceSans
    PlayerButton.TextSize = 16
    PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerButton.BorderSizePixel = 0
    PlayerButton.Parent = ScrollingFrame
    
    -- Click event to teleport and follow
    PlayerButton.MouseButton1Click:Connect(function()
        -- Stop current following if any
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
        
        -- Set currently following player
        currentlyFollowing = player
        
        -- Create a connection to update position every frame
        followConnection = RunService.RenderStepped:Connect(function()
            -- Check if the player still exists in the game
            if not player or not player.Parent or player.Parent ~= Players then
                if followConnection then
                    followConnection:Disconnect()
                    followConnection = nil
                end
                currentlyFollowing = nil
                return
            end
            
            -- Get player character and humanoid root part
            local character = player.Character
            if not character then return end
            
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then return end
            
            -- Get local player character
            local localCharacter = LocalPlayer.Character
            if not localCharacter then return end
            
            local localHumanoidRootPart = localCharacter:FindFirstChild("HumanoidRootPart")
            if not localHumanoidRootPart then return end
            
            -- Calculate position behind the player (based on their orientation)
            local lookVector = humanoidRootPart.CFrame.LookVector
            local position = humanoidRootPart.Position - (lookVector * FOLLOW_OFFSET.Z) + Vector3.new(0, FOLLOW_OFFSET.Y, 0)
            
            -- Set position and face the same direction
            localHumanoidRootPart.CFrame = CFrame.new(position, humanoidRootPart.Position)
        end)
    end)
    
    return PlayerButton
end

-- Function to update player list
local function UpdatePlayerList()
    -- Clear existing buttons
    for _, item in pairs(ScrollingFrame:GetChildren()) do
        if item:IsA("TextButton") then
            item:Destroy()
        end
    end
    
    -- Create buttons for all players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreatePlayerButton(player)
        end
    end
    
    -- Update canvas size
    local playerCount = #Players:GetPlayers() - 1 -- Excluding LocalPlayer
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, playerCount * 32) -- 30 + 2 padding
end

-- Stop following button click event
StopButton.MouseButton1Click:Connect(function()
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    currentlyFollowing = nil
end)

-- Player added/removed events
Players.PlayerAdded:Connect(function(player)
    UpdatePlayerList()
end)

Players.PlayerRemoving:Connect(function(player)
    if currentlyFollowing == player and followConnection then
        followConnection:Disconnect()
        followConnection = nil
        currentlyFollowing = nil
    end
    UpdatePlayerList()
end)

-- Initial population
UpdatePlayerList()