-- Player Teleport GUI Script
-- Place this in a LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlayerTeleportGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 300)
MainFrame.Position = UDim2.new(0.85, 0, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Player Teleporter"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Hide Button
local HideButton = Instance.new("TextButton")
HideButton.Name = "HideButton"
HideButton.Size = UDim2.new(0, 25, 0, 25)
HideButton.Position = UDim2.new(1, -55, 0, 2.5)
HideButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
HideButton.Text = "-"
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.TextSize = 18
HideButton.Font = Enum.Font.SourceSansBold
HideButton.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 2.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = TitleBar

-- ScrollingFrame for Players List
local PlayersScrollFrame = Instance.new("ScrollingFrame")
PlayersScrollFrame.Name = "PlayersScrollFrame"
PlayersScrollFrame.Size = UDim2.new(1, -10, 1, -40)
PlayersScrollFrame.Position = UDim2.new(0, 5, 0, 35)
PlayersScrollFrame.BackgroundTransparency = 1
PlayersScrollFrame.BorderSizePixel = 0
PlayersScrollFrame.ScrollBarThickness = 6
PlayersScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
PlayersScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayersScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayersScrollFrame.Parent = MainFrame

-- List Layout for player entries
local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 5)
ListLayout.SortOrder = Enum.SortOrder.Name
ListLayout.Parent = PlayersScrollFrame

-- Minimized Button (shown when GUI is hidden)
local MinimizedButton = Instance.new("TextButton")
MinimizedButton.Name = "MinimizedButton"
MinimizedButton.Size = UDim2.new(0, 40, 0, 40)
MinimizedButton.Position = UDim2.new(0.95, 0, 0.5, 0)
MinimizedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MinimizedButton.Text = "P"
MinimizedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedButton.TextSize = 20
MinimizedButton.Font = Enum.Font.SourceSansBold
MinimizedButton.Visible = false
MinimizedButton.Parent = ScreenGui

-- Function to create player button
local function createPlayerButton(player)
    local PlayerFrame = Instance.new("Frame")
    PlayerFrame.Name = player.Name .. "Frame"
    PlayerFrame.Size = UDim2.new(1, -10, 0, 40)
    PlayerFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    PlayerFrame.BorderSizePixel = 0
    PlayerFrame.Parent = PlayersScrollFrame
    
    local PlayerButton = Instance.new("TextButton")
    PlayerButton.Name = player.Name .. "Button"
    PlayerButton.Size = UDim2.new(1, 0, 1, 0)
    PlayerButton.BackgroundTransparency = 1
    PlayerButton.Text = player.Name
    PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerButton.TextSize = 16
    PlayerButton.Font = Enum.Font.SourceSans
    PlayerButton.Parent = PlayerFrame
    
    -- Add player's thumbnail
    local PlayerThumbnail = Instance.new("ImageLabel")
    PlayerThumbnail.Name = "Thumbnail"
    PlayerThumbnail.Size = UDim2.new(0, 30, 0, 30)
    PlayerThumbnail.Position = UDim2.new(0, 5, 0, 5)
    PlayerThumbnail.BackgroundTransparency = 1
    
    -- Try to load player thumbnail
    local userId = player.UserId
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size48x48
    
    local content = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
    PlayerThumbnail.Image = content
    PlayerThumbnail.Parent = PlayerFrame
    
    -- Set player name to be next to thumbnail
    PlayerButton.TextXAlignment = Enum.TextXAlignment.Left
    PlayerButton.Position = UDim2.new(0, 40, 0, 0)
    PlayerButton.Size = UDim2.new(1, -40, 1, 0)
    
    -- Click event for teleportation
    PlayerButton.MouseButton1Click:Connect(function()
        local targetPlayer = Players:FindFirstChild(player.Name)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) -- Teleport behind the player
        end
    end)
    
    return PlayerFrame
end

-- Function to update the player list
local function updatePlayerList()
    -- Clear existing player buttons
    for _, child in pairs(PlayersScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Create buttons for all current players
    for _, player in pairs(Players:GetPlayers()) do
        createPlayerButton(player)
    end
end

-- Event handlers
HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedButton.Visible = true
end)

MinimizedButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinimizedButton.Visible = false
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Player join/leave events
Players.PlayerAdded:Connect(function(player)
    createPlayerButton(player)
end)

Players.PlayerRemoving:Connect(function(player)
    local playerFrame = PlayersScrollFrame:FindFirstChild(player.Name .. "Frame")
    if playerFrame then
        playerFrame:Destroy()
    end
end)

-- Initial population of player list
updatePlayerList()