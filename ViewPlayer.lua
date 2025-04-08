-- Player View GUI Script
-- Place this in a LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local CurrentCamera = workspace.CurrentCamera

-- Configuration
local CONFIG = {
    COLORS = {
        BACKGROUND = Color3.fromRGB(45, 45, 45),
        TITLE_BAR = Color3.fromRGB(35, 35, 35),
        BUTTON = Color3.fromRGB(60, 60, 60),
        BUTTON_HOVER = Color3.fromRGB(75, 75, 75),
        CLOSE = Color3.fromRGB(200, 50, 50),
        CLOSE_HOVER = Color3.fromRGB(220, 70, 70),
        TEXT = Color3.fromRGB(255, 255, 255),
        PLAYER_FRAME = Color3.fromRGB(60, 60, 60),
        PLAYER_FRAME_SELECTED = Color3.fromRGB(80, 120, 220)
    },
    HOTKEY = Enum.KeyCode.P,
    TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

-- Variables
local currentlyViewing = nil
local uiElements = {}

-- Create the core GUI elements
local function createGui()
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PlayerViewGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    uiElements.ScreenGui = screenGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 220, 0, 300)
    mainFrame.Position = UDim2.new(0.85, 0, 0.5, -150)
    mainFrame.BackgroundColor3 = CONFIG.COLORS.BACKGROUND
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    uiElements.MainFrame = mainFrame
    
    -- Add corner radius
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = CONFIG.COLORS.TITLE_BAR
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    uiElements.TitleBar = titleBar
    
    -- Title Bar Corner
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    -- Fix corner overlapping
    local titleCornerFixFrame = Instance.new("Frame")
    titleCornerFixFrame.Name = "CornerFix"
    titleCornerFixFrame.Size = UDim2.new(1, 0, 0.5, 0)
    titleCornerFixFrame.Position = UDim2.new(0, 0, 0.5, 0)
    titleCornerFixFrame.BackgroundColor3 = CONFIG.COLORS.TITLE_BAR
    titleCornerFixFrame.BorderSizePixel = 0
    titleCornerFixFrame.Parent = titleBar
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Player Viewer"
    title.TextColor3 = CONFIG.COLORS.TEXT
    title.TextSize = 16
    title.Font = Enum.Font.SourceSansBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    uiElements.Title = title
    
    -- Hide Button
    local hideButton = Instance.new("TextButton")
    hideButton.Name = "HideButton"
    hideButton.Size = UDim2.new(0, 25, 0, 25)
    hideButton.Position = UDim2.new(1, -55, 0, 2.5)
    hideButton.BackgroundColor3 = CONFIG.COLORS.BUTTON
    hideButton.Text = "-"
    hideButton.TextColor3 = CONFIG.COLORS.TEXT
    hideButton.TextSize = 18
    hideButton.Font = Enum.Font.SourceSansBold
    hideButton.Parent = titleBar
    uiElements.HideButton = hideButton
    
    -- Hide Button Corner
    local hideButtonCorner = Instance.new("UICorner")
    hideButtonCorner.CornerRadius = UDim.new(0, 4)
    hideButtonCorner.Parent = hideButton
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 2.5)
    closeButton.BackgroundColor3 = CONFIG.COLORS.CLOSE
    closeButton.Text = "X"
    closeButton.TextColor3 = CONFIG.COLORS.TEXT
    closeButton.TextSize = 16
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = titleBar
    uiElements.CloseButton = closeButton
    
    -- Close Button Corner
    local closeButtonCorner = Instance.new("UICorner")
    closeButtonCorner.CornerRadius = UDim.new(0, 4)
    closeButtonCorner.Parent = closeButton
    
    -- Search Bar
    local searchBar = Instance.new("Frame")
    searchBar.Name = "SearchBar"
    searchBar.Size = UDim2.new(1, -20, 0, 30)
    searchBar.Position = UDim2.new(0, 10, 0, 35)
    searchBar.BackgroundColor3 = CONFIG.COLORS.BUTTON
    searchBar.BorderSizePixel = 0
    searchBar.Parent = mainFrame
    uiElements.SearchBar = searchBar
    
    -- Search Bar Corner
    local searchBarCorner = Instance.new("UICorner")
    searchBarCorner.CornerRadius = UDim.new(0, 6)
    searchBarCorner.Parent = searchBar
    
    -- Search Icon
    local searchIcon = Instance.new("ImageLabel")
    searchIcon.Name = "SearchIcon"
    searchIcon.Size = UDim2.new(0, 16, 0, 16)
    searchIcon.Position = UDim2.new(0, 7, 0.5, -8)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Image = "rbxassetid://3605022185"
    searchIcon.ImageColor3 = CONFIG.COLORS.TEXT
    searchIcon.Parent = searchBar
    
    -- Search Box
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(1, -30, 1, 0)
    searchBox.Position = UDim2.new(0, 30, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Text = ""
    searchBox.PlaceholderText = "Search players..."
    searchBox.TextColor3 = CONFIG.COLORS.TEXT
    searchBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
    searchBox.TextSize = 14
    searchBox.Font = Enum.Font.SourceSans
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = searchBar
    uiElements.SearchBox = searchBox
    
    -- ScrollingFrame for Players List
    local playersScrollFrame = Instance.new("ScrollingFrame")
    playersScrollFrame.Name = "PlayersScrollFrame"
    playersScrollFrame.Size = UDim2.new(1, -20, 1, -75)
    playersScrollFrame.Position = UDim2.new(0, 10, 0, 70)
    playersScrollFrame.BackgroundTransparency = 1
    playersScrollFrame.BorderSizePixel = 0
    playersScrollFrame.ScrollBarThickness = 4
    playersScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    playersScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    playersScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    playersScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    playersScrollFrame.Parent = mainFrame
    uiElements.PlayersScrollFrame = playersScrollFrame
    
    -- List Layout for player entries
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.Name
    listLayout.Parent = playersScrollFrame
    
    -- Stop Viewing Button
    local stopViewingButton = Instance.new("TextButton")
    stopViewingButton.Name = "StopViewingButton"
    stopViewingButton.Size = UDim2.new(0, 150, 0, 40)
    stopViewingButton.Position = UDim2.new(0.5, -75, 0.9, 0)
    stopViewingButton.BackgroundColor3 = CONFIG.COLORS.CLOSE
    stopViewingButton.Text = "Stop Viewing"
    stopViewingButton.TextColor3 = CONFIG.COLORS.TEXT
    stopViewingButton.TextSize = 16
    stopViewingButton.Font = Enum.Font.SourceSansBold
    stopViewingButton.Visible = false
    stopViewingButton.Parent = screenGui
    uiElements.StopViewingButton = stopViewingButton
    
    -- Stop Button Corner
    local stopButtonCorner = Instance.new("UICorner")
    stopButtonCorner.CornerRadius = UDim.new(0, 8)
    stopButtonCorner.Parent = stopViewingButton
    
    -- Currently Viewing Label
    local viewingLabel = Instance.new("TextLabel")
    viewingLabel.Name = "ViewingLabel"
    viewingLabel.Size = UDim2.new(0, 200, 0, 30)
    viewingLabel.Position = UDim2.new(0.5, -100, 0.9, -45)
    viewingLabel.BackgroundTransparency = 1
    viewingLabel.Text = "Viewing: Nobody"
    viewingLabel.TextColor3 = CONFIG.COLORS.TEXT
    viewingLabel.TextSize = 16
    viewingLabel.Font = Enum.Font.SourceSansBold
    viewingLabel.Visible = false
    viewingLabel.Parent = screenGui
    uiElements.ViewingLabel = viewingLabel
    
    return screenGui
end

-- Function to create player button with profile picture
local function createPlayerButton(player)
    if not uiElements.PlayersScrollFrame then return end
    
    local playerFrame = Instance.new("Frame")
    playerFrame.Name = player.Name .. "Frame"
    playerFrame.Size = UDim2.new(1, 0, 0, 50)
    playerFrame.BackgroundColor3 = CONFIG.COLORS.PLAYER_FRAME
    playerFrame.BorderSizePixel = 0
    playerFrame.Parent = uiElements.PlayersScrollFrame
    
    -- Add corner radius
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 6)
    frameCorner.Parent = playerFrame
    
    -- Player Thumbnail
    local playerThumbnail = Instance.new("ImageLabel")
    playerThumbnail.Name = "Thumbnail"
    playerThumbnail.Size = UDim2.new(0, 40, 0, 40)
    playerThumbnail.Position = UDim2.new(0, 5, 0.5, -20)
    playerThumbnail.BackgroundTransparency = 1
    playerThumbnail.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png" -- Placeholder until loaded
    playerThumbnail.Parent = playerFrame
    
    -- Add circular mask for thumbnail
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = playerThumbnail
    
    -- Player Button (with username)
    local playerButton = Instance.new("TextButton")
    playerButton.Name = player.Name .. "Button"
    playerButton.Size = UDim2.new(1, -50, 1, 0)
    playerButton.Position = UDim2.new(0, 50, 0, 0)
    playerButton.BackgroundTransparency = 1
    playerButton.Text = player.Name
    playerButton.TextColor3 = CONFIG.COLORS.TEXT
    playerButton.TextSize = 16
    playerButton.Font = Enum.Font.SourceSans
    playerButton.TextXAlignment = Enum.TextXAlignment.Left
    playerButton.Parent = playerFrame
    
    -- Team color indicator
    local teamIndicator = Instance.new("Frame")
    teamIndicator.Name = "TeamIndicator"
    teamIndicator.Size = UDim2.new(0, 4, 0.7, 0)
    teamIndicator.Position = UDim2.new(0, 0, 0.15, 0)
    teamIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
    teamIndicator.BackgroundTransparency = 1
    teamIndicator.BorderSizePixel = 0
    teamIndicator.Parent = playerFrame
    
    -- Update team color
    local function updateTeamColor()
        if player.Team then
            teamIndicator.BackgroundColor3 = player.TeamColor.Color
            teamIndicator.BackgroundTransparency = 0
        else
            teamIndicator.BackgroundTransparency = 1
        end
    end
    
    updateTeamColor()
    player:GetPropertyChangedSignal("Team"):Connect(updateTeamColor)
    
    -- Fetch and set the player's thumbnail (with error handling)
    local function loadThumbnail()
        local success, result = pcall(function()
            local userId = player.UserId
            local thumbType = Enum.ThumbnailType.HeadShot
            local thumbSize = Enum.ThumbnailSize.Size100x100
            return Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
        end)
        
        if success and result then
            playerThumbnail.Image = result
        end
    end
    
    task.spawn(loadThumbnail)
    
    -- Hover effect for player frame
    playerButton.MouseEnter:Connect(function()
        if currentlyViewing ~= player then
            TweenService:Create(playerFrame, CONFIG.TWEEN_INFO, {
                BackgroundColor3 = CONFIG.COLORS.BUTTON_HOVER
            }):Play()
        end
    end)
    
    playerButton.MouseLeave:Connect(function()
        if currentlyViewing ~= player then
            TweenService:Create(playerFrame, CONFIG.TWEEN_INFO, {
                BackgroundColor3 = CONFIG.COLORS.PLAYER_FRAME
            }):Play()
        end
    end)
    
    -- Click event for viewing player
    playerButton.MouseButton1Click:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            viewPlayer(player)
        else
            -- Flash red to indicate error
            local originalColor = playerFrame.BackgroundColor3
            playerFrame.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            task.wait(0.3)
            playerFrame.BackgroundColor3 = originalColor
        end
    end)
    
    return playerFrame
end

-- Function to handle viewing a player
function viewPlayer(player)
    -- Update currently viewing variable
    currentlyViewing = player
    
    -- Update camera subject
    CurrentCamera.CameraSubject = player.Character.Humanoid
    
    -- Show stop viewing button and update viewing label
    uiElements.StopViewingButton.Visible = true
    uiElements.ViewingLabel.Text = "Viewing: " .. player.Name
    uiElements.ViewingLabel.Visible = true
    
    -- Visual indication in the player list
    for _, frame in ipairs(uiElements.PlayersScrollFrame:GetChildren()) do
        if frame:IsA("Frame") then
            if frame.Name == player.Name .. "Frame" then
                TweenService:Create(frame, CONFIG.TWEEN_INFO, {
                    BackgroundColor3 = CONFIG.COLORS.PLAYER_FRAME_SELECTED
                }):Play()
            else
                TweenService:Create(frame, CONFIG.TWEEN_INFO, {
                    BackgroundColor3 = CONFIG.COLORS.PLAYER_FRAME
                }):Play()
            end
        end
    end
end

-- Function to stop viewing
local function stopViewing()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
        
        -- Reset UI
        uiElements.StopViewingButton.Visible = false
        uiElements.ViewingLabel.Visible = false
        
        -- Reset color for previously selected player
        if currentlyViewing then
            local frame = uiElements.PlayersScrollFrame:FindFirstChild(currentlyViewing.Name .. "Frame")
            if frame then
                TweenService:Create(frame, CONFIG.TWEEN_INFO, {
                    BackgroundColor3 = CONFIG.COLORS.PLAYER_FRAME
                }):Play()
            end
        end
        
        currentlyViewing = nil
    end
end

-- Function to update the player list
local function updatePlayerList()
    if not uiElements.PlayersScrollFrame then return end
    
    -- Clear existing player buttons
    for _, child in pairs(uiElements.PlayersScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Create buttons for all current players
    for _, player in pairs(Players:GetPlayers()) do
        createPlayerButton(player)
    end
    
    -- Apply search filter if there's text in the search box
    if uiElements.SearchBox and uiElements.SearchBox.Text ~= "" then
        filterPlayerList(uiElements.SearchBox.Text)
    end
end

-- Function to filter player list based on search
local function filterPlayerList(searchText)
    if not uiElements.PlayersScrollFrame then return end
    
    searchText = searchText:lower()
    
    for _, child in pairs(uiElements.PlayersScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            local playerName = child.Name:gsub("Frame", ""):lower()
            
            if searchText == "" or playerName:find(searchText) then
                child.Visible = true
            else
                child.Visible = false
            end
        end
    end
end

-- Set up UI behaviors
local function setupUiBehaviors()
    -- Make frame draggable (custom implementation to be smoother)
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        uiElements.MainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    uiElements.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = uiElements.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    uiElements.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)
    
    -- Hide button hover effect
    uiElements.HideButton.MouseEnter:Connect(function()
        TweenService:Create(uiElements.HideButton, CONFIG.TWEEN_INFO, {
            BackgroundColor3 = CONFIG.COLORS.BUTTON_HOVER
        }):Play()
    end)
    
    uiElements.HideButton.MouseLeave:Connect(function()
        TweenService:Create(uiElements.HideButton, CONFIG.TWEEN_INFO, {
            BackgroundColor3 = CONFIG.COLORS.BUTTON
        }):Play()
    end)
    
    -- Close button hover effect
    uiElements.CloseButton.MouseEnter:Connect(function()
        TweenService:Create(uiElements.CloseButton, CONFIG.TWEEN_INFO, {
            BackgroundColor3 = CONFIG.COLORS.CLOSE_HOVER
        }):Play()
    end)
    
    uiElements.CloseButton.MouseLeave:Connect(function()
        TweenService:Create(uiElements.CloseButton, CONFIG.TWEEN_INFO, {
            BackgroundColor3 = CONFIG.COLORS.CLOSE
        }):Play()
    end)
    
    -- Stop viewing button hover effect
    uiElements.StopViewingButton.MouseEnter:Connect(function()
        TweenService:Create(uiElements.StopViewingButton, CONFIG.TWEEN_INFO, {
            BackgroundColor3 = CONFIG.COLORS.CLOSE_HOVER
        }):Play()
    end)
    
    uiElements.StopViewingButton.MouseLeave:Connect(function()
        TweenService:Create(uiElements.StopViewingButton, CONFIG.TWEEN_INFO, {
            BackgroundColor3 = CONFIG.COLORS.CLOSE
        }):Play()
    end)
    
    -- Hide button click event
    uiElements.HideButton.MouseButton1Click:Connect(function()
        uiElements.MainFrame.Visible = false
    end)
    
    -- Close button click event
    uiElements.CloseButton.MouseButton1Click:Connect(function()
        uiElements.ScreenGui:Destroy()
        stopViewing()
    end)
    
    -- Stop viewing button click event
    uiElements.StopViewingButton.MouseButton1Click:Connect(stopViewing)
    
    -- Search box functionality
    uiElements.SearchBox.Changed:Connect(function(property)
        if property == "Text" then
            filterPlayerList(uiElements.SearchBox.Text)
        end
    end)
    
    -- Toggle GUI with hotkey
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == CONFIG.HOTKEY then
            uiElements.MainFrame.Visible = not uiElements.MainFrame.Visible
        end
    end)
end

-- Player added/removed event connections
local function setupPlayerEvents()
    Players.PlayerAdded:Connect(function(player)
        createPlayerButton(player)
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        local playerFrame = uiElements.PlayersScrollFrame:FindFirstChild(player.Name .. "Frame")
        if playerFrame then
            playerFrame:Destroy()
        end
        
        -- If we were viewing this player, stop viewing
        if currentlyViewing == player then
            stopViewing()
        end
    end)
end

-- Initialize the GUI
local function init()
    createGui()
    setupUiBehaviors()
    setupPlayerEvents()
    updatePlayerList()
    
    -- Add notification to inform about hotkey
    local notification = Instance.new("TextLabel")
    notification.Name = "HotkeyNotification"
    notification.Size = UDim2.new(0, 250, 0, 40)
    notification.Position = UDim2.new(0.5, -125, 0.15, 0)
    notification.BackgroundColor3 = CONFIG.COLORS.BACKGROUND
    notification.BorderSizePixel = 0
    notification.Text = "Press 'P' to toggle Player Viewer"
    notification.TextColor3 = CONFIG.COLORS.TEXT
    notification.TextSize = 16
    notification.Font = Enum.Font.SourceSansBold
    notification.Parent = uiElements.ScreenGui
    
    -- Add corner radius
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notification
    
    -- Animate notification
    notification.BackgroundTransparency = 0.2
    notification.TextTransparency = 0
    
    task.spawn(function()
        task.wait(3)
        local fadeTween = TweenService:Create(notification, TweenInfo.new(1), {
            BackgroundTransparency = 1,
            TextTransparency = 1
        })
        fadeTween:Play()
        fadeTween.Completed:Wait()
        notification:Destroy()
    end)
end

-- Start the script
init()