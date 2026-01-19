-- Vanzyxxx Enhanced Record & Playback System
-- With Fly, Carry All Players, and Advanced Features

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

-- Player references
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = Workspace.CurrentCamera

-- Variables
local recording = false
local playing = false
local paused = false
local flying = false
local carrying = false
local recordedData = {}
local playbackIndex = 1
local recordConnection = nil
local flyConnection = nil
local carryConnection = nil
local checkpointHit = false
local originalWalkSpeed = humanoid.WalkSpeed
local originalJumpPower = humanoid.JumpPower
local originalGravity = Workspace.Gravity
local flySpeed = 50
local carryOffset = Vector3.new(0, 3, 0)
local smoothDelta = 0.1
local lastPosition = rootPart.Position
local velocity = Vector3.new(0, 0, 0)
local smoothingFactor = 0.9

-- Animation for carrying
local carryAnimation
if humanoid.RigType == Enum.RigType.R6 then
    carryAnimation = Instance.new("Animation")
    carryAnimation.AnimationId = "rbxassetid://3189777792"
else
    carryAnimation = Instance.new("Animation")
    carryAnimation.AnimationId = "rbxassetid://5918726674"
end

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VanzyxxxEnhanced"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create floating logo with your custom image
local logoButton = Instance.new("ImageButton")
logoButton.Name = "LogoButton"
logoButton.Image = "https://files.catbox.moe/2znol1.jpg"
logoButton.Size = UDim2.new(0, 70, 0, 70)
logoButton.Position = UDim2.new(1, -80, 0.5, -35)
logoButton.AnchorPoint = Vector2.new(0.5, 0.5)
logoButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
logoButton.BackgroundTransparency = 0.2
logoButton.AutoButtonColor = false

-- Logo styling
local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoCorner.Parent = logoButton

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(100, 150, 255)
logoStroke.Thickness = 3
logoStroke.Parent = logoButton

-- Hover effect for logo
logoButton.MouseEnter:Connect(function()
    TweenService:Create(logoButton, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 80, 0, 80),
        BackgroundTransparency = 0
    }):Play()
end)

logoButton.MouseLeave:Connect(function()
    TweenService:Create(logoButton, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 70, 0, 70),
        BackgroundTransparency = 0.2
    }):Play()
end)

logoButton.Parent = screenGui

-- Create main window
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true

-- Main frame styling
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 100, 255)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- Title bar with close button
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15, 0, 0)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(0.8, 0, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "⚡ Vanzyxxx Advanced"
titleText.TextColor3 = Color3.fromRGB(220, 220, 255)
titleText.TextSize = 18
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0.5, -15)
closeButton.AnchorPoint = Vector2.new(0.5, 0.5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeButton.BackgroundTransparency = 0.3
closeButton.Text = "×"
closeButton.TextColor3 = Color3.white
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.AutoButtonColor = true

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    wait(0.3)
    mainFrame.Visible = false
    mainFrame.Size = UDim2.new(0, 350, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
end)

closeButton.Parent = titleBar

titleBar.Parent = mainFrame

-- Minimize button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -70, 0.5, -15)
minimizeButton.AnchorPoint = Vector2.new(0.5, 0.5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
minimizeButton.BackgroundTransparency = 0.3
minimizeButton.Text = "―"
minimizeButton.TextColor3 = Color3.white
minimizeButton.TextSize = 20
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.AutoButtonColor = true

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(1, 0)
minimizeCorner.Parent = minimizeButton

local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 350, 0, 40)
        }):Play()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 350, 0, 450)
        }):Play()
    end
end)

minimizeButton.Parent = titleBar

-- Content frame (scrollable)
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 5
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
contentFrame.Parent = mainFrame

-- Create UIListLayout for content
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = contentFrame

-- Record Control Section
local recordSection = Instance.new("Frame")
recordSection.Name = "RecordSection"
recordSection.Size = UDim2.new(1, 0, 0, 150)
recordSection.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
recordSection.BackgroundTransparency = 0.5
recordSection.LayoutOrder = 1

local sectionCorner = Instance.new("UICorner")
sectionCorner.CornerRadius = UDim.new(0, 10)
sectionCorner.Parent = recordSection

local sectionStroke = Instance.new("UIStroke")
sectionStroke.Color = Color3.fromRGB(80, 100, 255)
sectionStroke.Thickness = 1
sectionStroke.Parent = recordSection

-- Section title
local recordTitle = Instance.new("TextLabel")
recordTitle.Name = "RecordTitle"
recordTitle.Size = UDim2.new(1, -20, 0, 30)
recordTitle.Position = UDim2.new(0, 10, 0, 5)
recordTitle.BackgroundTransparency = 1
recordTitle.Text = "🎮 RECORD CONTROLS"
recordTitle.TextColor3 = Color3.fromRGB(180, 200, 255)
recordTitle.TextSize = 16
recordTitle.Font = Enum.Font.GothamBold
recordTitle.TextXAlignment = Enum.TextXAlignment.Left
recordTitle.Parent = recordSection

-- Mini control buttons for record
local miniControls = Instance.new("Frame")
miniControls.Name = "MiniControls"
miniControls.Size = UDim2.new(1, -20, 0, 40)
miniControls.Position = UDim2.new(0, 10, 0, 40)
miniControls.BackgroundTransparency = 1
miniControls.Parent = recordSection

-- Create mini buttons container
local miniButtonsContainer = Instance.new("Frame")
miniButtonsContainer.Name = "MiniButtonsContainer"
miniButtonsContainer.Size = UDim2.new(1, 0, 1, 0)
miniButtonsContainer.BackgroundTransparency = 1
miniButtonsContainer.Parent = miniControls

-- Mini play button
local miniPlay = Instance.new("TextButton")
miniPlay.Name = "MiniPlay"
miniPlay.Size = UDim2.new(0.3, 0, 1, 0)
miniPlay.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
miniPlay.Text = "▶"
miniPlay.TextColor3 = Color3.white
miniPlay.TextSize = 18
miniPlay.Font = Enum.Font.GothamBold

local miniPlayCorner = Instance.new("UICorner")
miniPlayCorner.CornerRadius = UDim.new(0, 8)
miniPlayCorner.Parent = miniPlay

-- Mini pause button
local miniPause = Instance.new("TextButton")
miniPause.Name = "MiniPause"
miniPause.Size = UDim2.new(0.3, 0, 1, 0)
miniPause.Position = UDim2.new(0.35, 0, 0, 0)
miniPause.BackgroundColor3 = Color3.fromRGB(255, 180, 40)
miniPause.Text = "⏸"
miniPause.TextColor3 = Color3.white
miniPause.TextSize = 18
miniPause.Font = Enum.Font.GothamBold

local miniPauseCorner = Instance.new("UICorner")
miniPauseCorner.CornerRadius = UDim.new(0, 8)
miniPauseCorner.Parent = miniPause

-- Mini stop button
local miniStop = Instance.new("TextButton")
miniStop.Name = "MiniStop"
miniStop.Size = UDim2.new(0.3, 0, 1, 0)
miniStop.Position = UDim2.new(0.7, 0, 0, 0)
miniStop.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
miniStop.Text = "⏹"
miniStop.TextColor3 = Color3.white
miniStop.TextSize = 18
miniStop.Font = Enum.Font.GothamBold

local miniStopCorner = Instance.new("UICorner")
miniStopCorner.CornerRadius = UDim.new(0, 8)
miniStopCorner.Parent = miniStop

miniPlay.Parent = miniButtonsContainer
miniPause.Parent = miniButtonsContainer
miniStop.Parent = miniButtonsContainer

-- Main record buttons
local recordButtonsFrame = Instance.new("Frame")
recordButtonsFrame.Name = "RecordButtonsFrame"
recordButtonsFrame.Size = UDim2.new(1, -20, 0, 50)
recordButtonsFrame.Position = UDim2.new(0, 10, 0, 90)
recordButtonsFrame.BackgroundTransparency = 1
recordButtonsFrame.Parent = recordSection

local buttonNames = {"START RECORD", "CLEAR RECORD"}
local recordButtons = {}

for i, name in ipairs(buttonNames) do
    local button = Instance.new("TextButton")
    button.Name = name:gsub(" ", "")
    button.Size = UDim2.new(0.48, 0, 1, 0)
    button.Position = UDim2.new((i-1) * 0.5, 0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    button.BorderSizePixel = 0
    button.Text = name
    button.TextColor3 = Color3.fromRGB(220, 220, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.AutoButtonColor = true
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(100, 120, 255)
    buttonStroke.Thickness = 1
    buttonStroke.Parent = button
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(70, 70, 100),
            Size = UDim2.new(0.5, 0, 1.1, 0)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(50, 50, 70),
            Size = UDim2.new(0.48, 0, 1, 0)
        }):Play()
    end)
    
    button.Parent = recordButtonsFrame
    recordButtons[name] = button
end

recordSection.Parent = contentFrame

-- Advanced Features Section
local advancedSection = Instance.new("Frame")
advancedSection.Name = "AdvancedSection"
advancedSection.Size = UDim2.new(1, 0, 0, 180)
advancedSection.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
advancedSection.BackgroundTransparency = 0.5
advancedSection.LayoutOrder = 2

local advancedCorner = Instance.new("UICorner")
advancedCorner.CornerRadius = UDim.new(0, 10)
advancedCorner.Parent = advancedSection

local advancedStroke = Instance.new("UIStroke")
advancedStroke.Color = Color3.fromRGB(80, 100, 255)
advancedStroke.Thickness = 1
advancedStroke.Parent = advancedSection

-- Section title
local advancedTitle = Instance.new("TextLabel")
advancedTitle.Name = "AdvancedTitle"
advancedTitle.Size = UDim2.new(1, -20, 0, 30)
advancedTitle.Position = UDim2.new(0, 10, 0, 5)
advancedTitle.BackgroundTransparency = 1
advancedTitle.Text = "⚡ ADVANCED FEATURES"
advancedTitle.TextColor3 = Color3.fromRGB(180, 200, 255)
advancedTitle.TextSize = 16
advancedTitle.Font = Enum.Font.GothamBold
advancedTitle.TextXAlignment = Enum.TextXAlignment.Left
advancedTitle.Parent = advancedSection

-- Fly button
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Size = UDim2.new(1, -20, 0, 50)
flyButton.Position = UDim2.new(0, 10, 0, 40)
flyButton.BackgroundColor3 = Color3.fromRGB(60, 100, 255)
flyButton.Text = "🪽 TOGGLE FLY"
flyButton.TextColor3 = Color3.white
flyButton.TextSize = 16
flyButton.Font = Enum.Font.GothamBold
flyButton.AutoButtonColor = true

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 8)
flyCorner.Parent = flyButton

local flyStroke = Instance.new("UIStroke")
flyStroke.Color = Color3.fromRGB(140, 180, 255)
flyStroke.Thickness = 2
flyStroke.Parent = flyButton

-- Carry all players button
local carryButton = Instance.new("TextButton")
carryButton.Name = "CarryButton"
carryButton.Size = UDim2.new(1, -20, 0, 50)
carryButton.Position = UDim2.new(0, 10, 0, 100)
carryButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
carryButton.Text = "👥 CARRY ALL PLAYERS"
carryButton.TextColor3 = Color3.white
carryButton.TextSize = 16
carryButton.Font = Enum.Font.GothamBold
carryButton.AutoButtonColor = true

local carryCorner = Instance.new("UICorner")
carryCorner.CornerRadius = UDim.new(0, 8)
carryCorner.Parent = carryButton

local carryStroke = Instance.new("UIStroke")
carryStroke.Color = Color3.fromRGB(255, 150, 150)
carryStroke.Thickness = 2
carryStroke.Parent = carryButton

flyButton.Parent = advancedSection
carryButton.Parent = advancedSection
advancedSection.Parent = contentFrame

-- Playback Section
local playbackSection = Instance.new("Frame")
playbackSection.Name = "PlaybackSection"
playbackSection.Size = UDim2.new(1, 0, 0, 100)
playbackSection.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
playbackSection.BackgroundTransparency = 0.5
playbackSection.LayoutOrder = 3

local playbackCorner = Instance.new("UICorner")
playbackCorner.CornerRadius = UDim.new(0, 10)
playbackCorner.Parent = playbackSection

local playbackStroke = Instance.new("UIStroke")
playbackStroke.Color = Color3.fromRGB(80, 100, 255)
playbackStroke.Thickness = 1
playbackStroke.Parent = playbackSection

-- Section title
local playbackTitle = Instance.new("TextLabel")
playbackTitle.Name = "PlaybackTitle"
playbackTitle.Size = UDim2.new(1, -20, 0, 30)
playbackTitle.Position = UDim2.new(0, 10, 0, 5)
playbackTitle.BackgroundTransparency = 1
playbackTitle.Text = "📼 PLAYBACK"
playbackTitle.TextColor3 = Color3.fromRGB(180, 200, 255)
playbackTitle.TextSize = 16
playbackTitle.Font = Enum.Font.GothamBold
playbackTitle.TextXAlignment = Enum.TextXAlignment.Left
playbackTitle.Parent = playbackSection

-- Play button
local playButton = Instance.new("TextButton")
playButton.Name = "PlayButton"
playButton.Size = UDim2.new(1, -20, 0, 50)
playButton.Position = UDim2.new(0, 10, 0, 40)
playButton.BackgroundColor3 = Color3.fromRGB(40, 200, 100)
playButton.Text = "▶ PLAY RECORDING"
playButton.TextColor3 = Color3.white
playButton.TextSize = 16
playButton.Font = Enum.Font.GothamBold
playButton.AutoButtonColor = true

local playCorner = Instance.new("UICorner")
playCorner.CornerRadius = UDim.new(0, 8)
playCorner.Parent = playButton

local playStroke = Instance.new("UIStroke")
playStroke.Color = Color3.fromRGB(100, 255, 150)
playStroke.Thickness = 2
playStroke.Parent = playButton

playButton.Parent = playbackSection
playbackSection.Parent = contentFrame

-- Status bar
local statusBar = Instance.new("Frame")
statusBar.Name = "StatusBar"
statusBar.Size = UDim2.new(1, 0, 0, 40)
statusBar.Position = UDim2.new(0, 0, 1, -40)
statusBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
statusBar.LayoutOrder = 4

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 0, 0, 15)
statusCorner.Parent = statusBar

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0.7, 0, 1, 0)
statusLabel.Position = UDim2.new(0, 10, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🟢 System Ready"
statusLabel.TextColor3 = Color3.fromRGB(180, 255, 180)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusBar

-- Data counter
local dataLabel = Instance.new("TextLabel")
dataLabel.Name = "DataLabel"
dataLabel.Size = UDim2.new(0.3, 0, 1, 0)
dataLabel.Position = UDim2.new(0.7, 0, 0, 0)
dataLabel.BackgroundTransparency = 1
dataLabel.Text = "📊 Points: 0"
dataLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
dataLabel.TextSize = 14
dataLabel.Font = Enum.Font.Gotham
dataLabel.TextXAlignment = Enum.TextXAlignment.Right
dataLabel.Parent = statusBar

statusBar.Parent = contentFrame

mainFrame.Parent = screenGui
mainFrame.Visible = false

-- Make window draggable
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        return input
    end
    return nil
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                connection:Disconnect()
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and dragInput and input == dragInput then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Logo toggle functionality
logoButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 350, 0, 450),
            Position = UDim2.new(0.5, -175, 0.5, -225)
        }):Play()
    end
    TweenService:Create(logoButton, TweenInfo.new(0.2), {
        Rotation = mainFrame.Visible and 360 or 0,
        BackgroundTransparency = mainFrame.Visible and 0 : 0.2
    }):Play()
end)

-- Update status
local function updateStatus(text, color)
    if color == "red" then
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    elseif color == "yellow" then
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    elseif color == "blue" then
        statusLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
    else
        statusLabel.TextColor3 = Color3.fromRGB(180, 255, 180)
    end
    statusLabel.Text = text
end

local function updateDataCount()
    dataLabel.Text = "📊 Points: " .. #recordedData
end

-- Enhanced smooth recording with velocity calculation
local function startRecording()
    if recording then return end
    
    recording = true
    paused = false
    checkpointHit = false
    updateStatus("🔴 Recording...", "red")
    lastPosition = rootPart.Position
    velocity = Vector3.new(0, 0, 0)
    
    if recordConnection then
        recordConnection:Disconnect()
    end
    
    recordConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not recording or paused or checkpointHit then return end
        
        -- Calculate smooth velocity
        local currentPos = rootPart.Position
        local newVelocity = (currentPos - lastPosition) / deltaTime
        velocity = velocity * smoothingFactor + newVelocity * (1 - smoothingFactor)
        
        -- Store position, rotation, velocity and timestamp
        local cf = rootPart.CFrame
        table.insert(recordedData, {
            Position = cf.Position,
            Rotation = {cf:ToEulerAnglesXYZ()},
            Velocity = velocity,
            Timestamp = tick(),
            LookVector = cf.LookVector
        })
        
        lastPosition = currentPos
        updateDataCount()
        
        -- Auto-run when moving forward
        if velocity.Magnitude > 5 and humanoid.MoveDirection.Magnitude > 0 then
            humanoid:MoveTo(currentPos + humanoid.MoveDirection * 10)
        end
    end)
    
    miniPlay.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
    miniPause.BackgroundColor3 = Color3.fromRGB(255, 180, 40)
    miniStop.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
end

local function pauseRecording()
    if not recording then return end
    
    paused = not paused
    if paused then
        updateStatus("⏸ Recording Paused", "yellow")
        miniPause.Text = "▶"
    else
        updateStatus("🔴 Recording...", "red")
        miniPause.Text = "⏸"
    end
end

local function stopRecording()
    recording = false
    paused = false
    if recordConnection then
        recordConnection:Disconnect()
    end
    updateStatus("🟢 Ready", "green")
    miniPlay.BackgroundColor3 = Color3.fromRGB(40, 200, 40)
    miniPause.BackgroundColor3 = Color3.fromRGB(255, 180, 40)
    miniStop.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
end

-- Enhanced smooth playback with velocity interpolation
local function startPlayback()
    if playing or #recordedData == 0 then return end
    
    playing = true
    updateStatus("🔵 Playing Back...", "blue")
    
    -- Disable player movement
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    
    local startTime = tick()
    playbackIndex = 1
    
    -- Create a new thread for smooth playback
    spawn(function()
        while playing and playbackIndex <= #recordedData do
            local data = recordedData[playbackIndex]
            local nextData = recordedData[playbackIndex + 1]
            
            if data then
                -- Interpolate between current and next position for smoother movement
                if nextData then
                    local alpha = (tick() - startTime - (data.Timestamp - recordedData[1].Timestamp)) / 
                                 (nextData.Timestamp - data.Timestamp)
                    alpha = math.clamp(alpha, 0, 1)
                    
                    -- Linear interpolation
                    local interpPos = data.Position:Lerp(nextData.Position, alpha)
                    local cf = CFrame.new(interpPos) * CFrame.Angles(unpack(data.Rotation))
                    
                    -- Apply with BodyVelocity for smooth movement
                    rootPart.CFrame = cf
                    
                    -- Apply velocity for physics-based movement
                    local bv = rootPart:FindFirstChild("PlaybackVelocity") or Instance.new("BodyVelocity")
                    bv.Name = "PlaybackVelocity"
                    bv.Velocity = data.VectorVelocity or Vector3.new(0, 0, 0)
                    bv.MaxForce = Vector3.new(4000, 4000, 4000)
                    bv.P = 10000
                    bv.Parent = rootPart
                else
                    rootPart.CFrame = CFrame.new(data.Position) * CFrame.Angles(unpack(data.Rotation))
                end
                
                playbackIndex = playbackIndex + 1
            end
            
            -- Use Wait for consistent timing
            RunService.Heartbeat:Wait()
        end
        
        -- Cleanup
        playing = false
        playbackIndex = 1
        humanoid.WalkSpeed = originalWalkSpeed
        humanoid.JumpPower = originalJumpPower
        
        -- Remove BodyVelocity
        local bv = rootPart:FindFirstChild("PlaybackVelocity")
        if bv then
            bv:Destroy()
        end
        
        updateStatus("🟢 Playback Complete", "green")
    end)
end

local function clearRecording()
    recordedData = {}
    playbackIndex = 1
    updateDataCount()
    updateStatus("🟢 Ready", "green")
    stopRecording()
end

-- Fly System
local function toggleFly()
    flying = not flying
    
    if flying then
        updateStatus("🪽 Flying Enabled", "blue")
        
        -- Store original values
        originalWalkSpeed = humanoid.WalkSpeed
        originalJumpPower = humanoid.JumpPower
        
        -- Enable fly mode
        humanoid.PlatformStand = true
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Name = "FlyGyro"
        bodyGyro.P = 10000
        bodyGyro.D = 100
        bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
        bodyGyro.CFrame = rootPart.CFrame
        bodyGyro.Parent = rootPart
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "FlyVelocity"
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.P = 10000
        bodyVelocity.Parent = rootPart
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flying or not character or not rootPart then
                if flyConnection then
                    flyConnection:Disconnect()
                end
                return
            end
            
            local direction = Vector3.new(0, 0, 0)
            
            -- Keyboard controls
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                direction = direction - Vector3.new(0, 1, 0)
            end
            
            -- Normalize direction
            if direction.Magnitude > 0 then
                direction = direction.Unit * flySpeed
            end
            
            -- Update BodyVelocity
            local flyVelocity = rootPart:FindFirstChild("FlyVelocity")
            if flyVelocity then
                flyVelocity.Velocity = direction
            end
            
            -- Update BodyGyro to face camera direction
            local flyGyro = rootPart:FindFirstChild("FlyGyro")
            if flyGyro then
                flyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + camera.CFrame.LookVector)
            end
        end)
        
        flyButton.Text = "🛑 DISABLE FLY"
        flyButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    else
        -- Disable fly mode
        humanoid.PlatformStand = false
        humanoid.WalkSpeed = originalWalkSpeed
        humanoid.JumpPower = originalJumpPower
        
        -- Remove fly parts
        local flyGyro = rootPart:FindFirstChild("FlyGyro")
        if flyGyro then
            flyGyro:Destroy()
        end
        
        local flyVelocity = rootPart:FindFirstChild("FlyVelocity")
        if flyVelocity then
            flyVelocity:Destroy()
        end
        
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        updateStatus("🟢 Fly Disabled", "green")
        flyButton.Text = "🪽 TOGGLE FLY"
        flyButton.BackgroundColor3 = Color3.fromRGB(60, 100, 255)
    end
end

-- Carry All Players System
local function toggleCarryAll()
    carrying = not carrying
    
    if carrying then
        updateStatus("👥 Carrying All Players...", "blue")
        
        -- Play carry animation
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if animator then
            local animationTrack = animator:LoadAnimation(carryAnimation)
            animationTrack:Play()
        end
        
        -- Get all players except yourself
        local allPlayers = Players:GetPlayers()
        local carriedPlayers = {}
        
        for _, otherPlayer in ipairs(allPlayers) do
            if otherPlayer ~= player and otherPlayer.Character then
                local otherHumanoid = otherPlayer.Character:FindFirstChild("Humanoid")
                local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if otherHumanoid and otherRoot then
                    -- Make them sit on your back
                    otherHumanoid.Sit = true
                    otherHumanoid.PlatformStand = true
                    
                    -- Create weld to attach them
                    local weld = Instance.new("Weld")
                    weld.Name = "CarryWeld"
                    weld.Part0 = rootPart
                    weld.Part1 = otherRoot
                    weld.C0 = CFrame.new(0, 0, -2) * CFrame.Angles(0, math.rad(180), 0)
                    weld.Parent = rootPart
                    
                    table.insert(carriedPlayers, {
                        Player = otherPlayer,
                        Weld = weld,
                        Humanoid = otherHumanoid,
                        Root = otherRoot
                    })
                end
            end
        end
        
        carryButton.Text = "🛑 RELEASE PLAYERS"
        carryButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Store carried players for later release
        carryConnection = RunService.Heartbeat:Connect(function()
            if not carrying then
                if carryConnection then
                    carryConnection:Disconnect()
                end
                return
            end
            
            -- Update all welds to maintain position
            for _, carried in ipairs(carriedPlayers) do
                if carried.Weld and carried.Weld.Parent then
                    -- Keep them in position relative to you
                    carried.Root.CFrame = rootPart.CFrame * CFrame.new(0, 0, -2) * CFrame.Angles(0, math.rad(180), 0)
                end
            end
        end)
        
        -- Store for release
        _G.CarriedPlayers = carriedPlayers
    else
        -- Release all carried players
        updateStatus("🟢 Players Released", "green")
        
        if _G.CarriedPlayers then
            for _, carried in ipairs(_G.CarriedPlayers) do
                if carried.Weld then
                    carried.Weld:Destroy()
                end
                if carried.Humanoid then
                    carried.Humanoid.Sit = false
                    carried.Humanoid.PlatformStand = false
                end
            end
            _G.CarriedPlayers = nil
        end
        
        if carryConnection then
            carryConnection:Disconnect()
            carryConnection = nil
        end
        
        -- Stop animation
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                track:Stop()
            end
        end
        
        carryButton.Text = "👥 CARRY ALL PLAYERS"
        carryButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    end
end

-- Mini controls functionality
miniPlay.MouseButton1Click:Connect(startRecording)
miniPause.MouseButton1Click:Connect(pauseRecording)
miniStop.MouseButton1Click:Connect(stopRecording)

-- Main button functionality
recordButtons["START RECORD"].MouseButton1Click:Connect(startRecording)
recordButtons["CLEAR RECORD"].MouseButton1Click:Connect(clearRecording)
flyButton.MouseButton1Click:Connect(toggleFly)
carryButton.MouseButton1Click:Connect(toggleCarryAll)
playButton.MouseButton1Click:Connect(startPlayback)

-- Checkpoint system with enhanced detection
local function setupCheckpointListener()
    workspace.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") and (part.Name == "Checkpoint" or part.Name:lower():find("checkpoint")) then
            part.Touched:Connect(function(hit)
                local character = hit.Parent
                if character and character:FindFirstChild("Humanoid") and character == player.Character then
                    checkpointHit = true
                    updateStatus("🎯 Checkpoint Reached!", "blue")
                    
                    -- Show notification
                    local notif = Instance.new("TextLabel")
                    notif.Text = "🎯 CHECKPOINT REACHED!"
                    notif.Size = UDim2.new(0, 250, 0, 50)
                    notif.Position = UDim2.new(0.5, -125, 1, -60)
                    notif.BackgroundColor3 = Color3.fromRGB(40, 150, 255)
                    notif.TextColor3 = Color3.white
                    notif.TextSize = 16
                    notif.Font = Enum.Font.GothamBold
                    notif.Parent = screenGui
                    
                    local notifCorner = Instance.new("UICorner")
                    notifCorner.CornerRadius = UDim.new(0, 10)
                    notifCorner.Parent = notif
                    
                    -- Add animation
                    TweenService:Create(notif, TweenInfo.new(0.5), {
                        Position = UDim2.new(0.5, -125, 1, -120)
                    }):Play()
                    
                    wait(3)
                    TweenService:Create(notif, TweenInfo.new(0.5), {
                        Position = UDim2.new(0.5, -125, 1, -60)
                    }):Play()
                    wait(0.5)
                    notif:Destroy()
                end
            end)
        end
    end)
    
    -- Also check existing parts
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name == "Checkpoint" or part.Name:lower():find("checkpoint")) then
            part.Touched:Connect(function(hit)
                local character = hit.Parent
                if character and character:FindFirstChild("Humanoid") and character == player.Character then
                    checkpointHit = true
                    updateStatus("🎯 Checkpoint Reached!", "blue")
                end
            end)
        end
    end
end

-- Handle respawn with enhanced reconnection
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Reset all systems
    playing = false
    flying = false
    carrying = false
    recording = false
    paused = false
    
    -- Reset movement
    humanoid.WalkSpeed = originalWalkSpeed
    humanoid.JumpPower = originalJumpPower
    humanoid.PlatformStand = false
    
    -- Remove any remaining fly/carry parts
    if rootPart then
        local flyGyro = rootPart:FindFirstChild("FlyGyro")
        if flyGyro then flyGyro:Destroy() end
        
        local flyVelocity = rootPart:FindFirstChild("FlyVelocity")
        if flyVelocity then flyVelocity:Destroy() end
        
        local playbackVelocity = rootPart:FindFirstChild("PlaybackVelocity")
        if playbackVelocity then playbackVelocity:Destroy() end
        
        -- Remove carry welds
        for _, child in ipairs(rootPart:GetChildren()) do
            if child.Name == "CarryWeld" then
                child:Destroy()
            end
        end
    end
    
    -- Stop all connections
    if recordConnection then
        recordConnection:Disconnect()
        recordConnection = nil
    end
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    if carryConnection then
        carryConnection:Disconnect()
        carryConnection = nil
    end
    
    -- Release carried players
    if _G.CarriedPlayers then
        for _, carried in ipairs(_G.CarriedPlayers) do
            if carried.Weld then
                carried.Weld:Destroy()
            end
            if carried.Humanoid then
                carried.Humanoid.Sit = false
                carried.Humanoid.PlatformStand = false
            end
        end
        _G.CarriedPlayers = nil
    end
    
    -- Reset buttons
    flyButton.Text = "🪽 TOGGLE FLY"
    flyButton.BackgroundColor3 = Color3.fromRGB(60, 100, 255)
    
    carryButton.Text = "👥 CARRY ALL PLAYERS"
    carryButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    
    -- Re-run checkpoint setup
    setupCheckpointListener()
    
    updateStatus("🟢 System Ready (Respawned)", "green")
end)

-- Initial setup
setupCheckpointListener()
updateStatus("🟢 System Ready", "green")
updateDataCount()

-- Auto-cleanup on script stop
game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        if recordConnection then recordConnection:Disconnect() end
        if flyConnection then flyConnection:Disconnect() end
        if carryConnection then carryConnection:Disconnect() end
    end
end)

-- Keybind for quick menu toggle (optional)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightControl then
        mainFrame.Visible = not mainFrame.Visible
        if mainFrame.Visible then
            TweenService:Create(mainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 350, 0, 450),
                Position = UDim2.new(0.5, -175, 0.5, -225)
            }):Play()
        end
    end
end)

print("⚡ Vanzyxxx Enhanced System Loaded Successfully!")
print("Controls:")
print("- Right Click Logo: Toggle Menu")
print("- Right Control: Quick Toggle")
print("- Fly: W/A/S/D + Space/Ctrl")
print("- Checkpoint: Auto-stop at 'Checkpoint' parts")