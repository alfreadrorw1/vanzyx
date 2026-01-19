-- Vanzyxxx Record & Playback System
-- Main Script

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Player references
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variables
local recording = false
local playing = false
local paused = false
local recordedData = {}
local playbackIndex = 1
local connection = nil
local checkpointHit = false

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Vanzyxxx"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create floating logo
local logoButton = Instance.new("ImageButton")
logoButton.Name = "LogoButton"
logoButton.Image = "rbxassetid://9925120536" -- Default Roblox logo
logoButton.Size = UDim2.new(0, 60, 0, 60)
logoButton.Position = UDim2.new(1, -70, 0.5, -30)
logoButton.AnchorPoint = Vector2.new(0.5, 0.5)
logoButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
logoButton.BackgroundTransparency = 0.3
logoButton.AutoButtonColor = false

-- Logo styling
local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 30)
logoCorner.Parent = logoButton

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(100, 100, 100)
logoStroke.Thickness = 2
logoStroke.Parent = logoButton

logoButton.Parent = screenGui

-- Create main window
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0

-- Main frame styling
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 60, 70)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10, 0, 0)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Vanzyxxx Recorder"
titleText.TextColor3 = Color3.fromRGB(220, 220, 220)
titleText.TextSize = 18
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

titleBar.Parent = mainFrame

-- Content frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Buttons
local buttonNames = {"START RECORD", "PAUSE RECORD", "PLAY / TELEPORT", "CLEAR RECORD"}
local buttons = {}

for i, name in ipairs(buttonNames) do
    local button = Instance.new("TextButton")
    button.Name = name:gsub(" ", "")
    button.Size = UDim2.new(1, 0, 0, 50)
    button.Position = UDim2.new(0, 0, 0, (i-1) * 60)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    button.BorderSizePixel = 0
    button.Text = name
    button.TextColor3 = Color3.fromRGB(220, 220, 220)
    button.TextSize = 16
    button.Font = Enum.Font.Gotham
    button.AutoButtonColor = true
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(80, 80, 90)
    buttonStroke.Thickness = 1
    buttonStroke.Parent = button
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 65)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
    end)
    
    button.Parent = contentFrame
    buttons[name] = button
end

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, 0, 0, 40)
statusLabel.Position = UDim2.new(0, 0, 1, -40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Ready"
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = contentFrame

-- Data counter
local dataLabel = Instance.new("TextLabel")
dataLabel.Name = "DataLabel"
dataLabel.Size = UDim2.new(1, 0, 0, 20)
dataLabel.Position = UDim2.new(0, 0, 1, -60)
dataLabel.BackgroundTransparency = 1
dataLabel.Text = "Recorded Points: 0"
dataLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
dataLabel.TextSize = 12
dataLabel.Font = Enum.Font.Gotham
dataLabel.TextXAlignment = Enum.TextXAlignment.Left
dataLabel.Parent = contentFrame

mainFrame.Parent = screenGui
mainFrame.Visible = false

-- Make window draggable
local dragging = false
local dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Logo toggle functionality
logoButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    TweenService:Create(logoButton, TweenInfo.new(0.2), {
        Rotation = mainFrame.Visible and 360 or 0,
        BackgroundTransparency = mainFrame.Visible and 0.1 or 0.3
    }):Play()
end)

-- Update status
local function updateStatus(text)
    statusLabel.Text = "Status: " .. text
end

local function updateDataCount()
    dataLabel.Text = "Recorded Points: " .. #recordedData
end

-- Record system
local function startRecording()
    if recording then return end
    
    recording = true
    paused = false
    checkpointHit = false
    updateStatus("Recording...")
    
    if connection then
        connection:Disconnect()
    end
    
    connection = RunService.Heartbeat:Connect(function()
        if not recording or paused or checkpointHit then return end
        
        local cf = rootPart.CFrame
        table.insert(recordedData, {
            Position = cf.Position,
            Rotation = {cf:ToEulerAnglesXYZ()}
        })
        
        updateDataCount()
    end)
end

local function pauseRecording()
    if not recording then return end
    
    paused = not paused
    updateStatus(paused and "Recording Paused" or "Recording...")
end

-- Playback system
local function startPlayback()
    if playing or #recordedData == 0 then return end
    
    playing = true
    updateStatus("Playing Back...")
    
    -- Disable player movement
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    
    local startTime = tick()
    
    local function playbackStep()
        if not playing then return end
        
        playbackIndex = playbackIndex + 1
        
        if playbackIndex > #recordedData then
            playing = false
            playbackIndex = 1
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
            updateStatus("Playback Complete")
            return
        end
        
        local data = recordedData[playbackIndex]
        if data then
            rootPart.CFrame = CFrame.new(data.Position) * CFrame.Angles(unpack(data.Rotation))
        end
        
        wait(0.05)
        playbackStep()
    end
    
    spawn(playbackStep)
end

local function clearRecording()
    recordedData = {}
    playbackIndex = 1
    updateDataCount()
    updateStatus("Ready")
end

-- Button functionality
buttons["START RECORD"].MouseButton1Click:Connect(startRecording)
buttons["PAUSE RECORD"].MouseButton1Click:Connect(pauseRecording)
buttons["PLAY / TELEPORT"].MouseButton1Click:Connect(startPlayback)
buttons["CLEAR RECORD"].MouseButton1Click:Connect(clearRecording)

-- Checkpoint system
local function setupCheckpointListener()
    workspace.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") and part.Name == "Checkpoint" then
            part.Touched:Connect(function(hit)
                local character = hit.Parent
                if character and character:FindFirstChild("Humanoid") and character == player.Character then
                    checkpointHit = true
                    updateStatus("Checkpoint Reached!")
                    
                    -- Show notification
                    local notif = Instance.new("TextLabel")
                    notif.Text = "✓ Checkpoint Reached!"
                    notif.Size = UDim2.new(0, 200, 0, 40)
                    notif.Position = UDim2.new(0.5, -100, 1, -50)
                    notif.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
                    notif.TextColor3 = Color3.white
                    notif.TextSize = 14
                    notif.Font = Enum.Font.GothamBold
                    notif.Parent = screenGui
                    
                    local notifCorner = Instance.new("UICorner")
                    notifCorner.CornerRadius = UDim.new(0, 8)
                    notifCorner.Parent = notif
                    
                    wait(2)
                    notif:Destroy()
                end
            end)
        end
    end)
end

-- Handle respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Reset playback if active
    playing = false
    humanoid.WalkSpeed = 16
    humanoid.JumpPower = 50
    
    -- Re-run checkpoint setup
    setupCheckpointListener()
end)

-- Initial setup
setupCheckpointListener()
updateStatus("Ready")

-- Auto-cleanup on script stop
game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        if connection then
            connection:Disconnect()
        end
    end
end)

-- Initial update
updateDataCount()

print("Vanzyxxx Record & Playback System Loaded Successfully!")