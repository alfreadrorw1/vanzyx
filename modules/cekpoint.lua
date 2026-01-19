-- ====================================================
-- CHECKPOINT MODULE - Auto Obby Runner
-- Compatible with Delta Executor
-- ====================================================

local CheckpointModule = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- Variables
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local Checkpoints = {}
local AutoObbyRunning = false
local AutoObbyPaused = false
local CurrentCheckpoint = 1
local ObbyConnection = nil

-- Function to scan for checkpoints
function CheckpointModule.ScanCheckpoints()
    Checkpoints = {}
    
    -- Search for common checkpoint names
    local checkpointNames = {
        "Checkpoint", "checkpoint", "CP", "cp", "Stage", "stage",
        "Part", "part", "Spawn", "spawn", "Flag", "flag",
        "Point", "point", "Goal", "goal"
    }
    
    -- Search through workspace
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            
            -- Check if name contains checkpoint indicators
            for _, checkpointName in ipairs(checkpointNames) do
                if name:find(checkpointName:lower()) then
                    -- Check for numbered checkpoints
                    local number = name:match("%d+")
                    if number then
                        local index = tonumber(number)
                        if index then
                            Checkpoints[index] = obj
                        end
                    else
                        -- Add unnumbered checkpoints
                        table.insert(Checkpoints, obj)
                    end
                    break
                end
            end
            
            -- Also check for parts with checkpoint in display name
            if obj:FindFirstChild("DisplayName") then
                local displayName = obj.DisplayName.Value:lower()
                for _, checkpointName in ipairs(checkpointNames) do
                    if displayName:find(checkpointName:lower()) then
                        table.insert(Checkpoints, obj)
                        break
                    end
                end
            end
        end
    end
    
    -- Sort by number if possible
    local sorted = {}
    for i = 1, #Checkpoints do
        if Checkpoints[i] then
            table.insert(sorted, Checkpoints[i])
        end
    end
    
    Checkpoints = sorted
    
    return #Checkpoints
end

-- Function to teleport to checkpoint
function CheckpointModule.TeleportToCheckpoint(index)
    if index < 1 or index > #Checkpoints then
        return false, "Checkpoint index out of range"
    end
    
    local checkpoint = Checkpoints[index]
    if not checkpoint then
        return false, "Checkpoint not found"
    end
    
    -- Calculate teleport position
    local teleportPosition = checkpoint.Position + Vector3.new(0, 5, 0)
    
    -- Teleport character
    if Character and HumanoidRootPart then
        HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        return true, "Teleported to checkpoint " .. index
    end
    
    return false, "Character not found"
end

-- Function to start auto obby
function CheckpointModule.StartAutoObby(startIndex)
    if AutoObbyRunning then
        return "Auto Obby is already running"
    end
    
    -- Scan checkpoints if not already scanned
    if #Checkpoints == 0 then
        CheckpointModule.ScanCheckpoints()
    end
    
    if #Checkpoints == 0 then
        return "No checkpoints found"
    end
    
    AutoObbyRunning = true
    AutoObbyPaused = false
    
    if startIndex then
        CurrentCheckpoint = math.clamp(startIndex, 1, #Checkpoints)
    else
        CurrentCheckpoint = 1
    end
    
    -- Start auto obby loop
    ObbyConnection = RunService.Heartbeat:Connect(function()
        if not AutoObbyRunning or AutoObbyPaused or not Character or not HumanoidRootPart or not Humanoid then
            return
        end
        
        -- Check if we reached current checkpoint
        local checkpoint = Checkpoints[CurrentCheckpoint]
        if checkpoint then
            local distance = (HumanoidRootPart.Position - checkpoint.Position).Magnitude
            
            if distance < 10 then
                -- Move to next checkpoint
                CurrentCheckpoint = CurrentCheckpoint + 1
                
                if CurrentCheckpoint > #Checkpoints then
                    CheckpointModule.StopAutoObby()
                    return
                end
            else
                -- Move towards checkpoint
                local direction = (checkpoint.Position - HumanoidRootPart.Position).Unit
                
                -- Simple obstacle avoidance
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParams.FilterDescendantsInstances = {Character}
                
                local raycastResult = Workspace:Raycast(
                    HumanoidRootPart.Position,
                    direction * 10,
                    raycastParams
                )
                
                if raycastResult then
                    -- Obstacle detected, try to jump
                    Humanoid.Jump = true
                    
                    -- Try different direction
                    local newDirection = direction:Cross(Vector3.new(0, 1, 0))
                    Humanoid:Move(newDirection)
                else
                    -- Move normally
                    Humanoid:Move(direction)
                end
                
                -- Auto jump for obstacles
                local floorRay = Workspace:Raycast(
                    HumanoidRootPart.Position,
                    Vector3.new(0, -5, 0),
                    raycastParams
                )
                
                if not floorRay then
                    Humanoid.Jump = true
                end
            end
        else
            -- Checkpoint not found, scan again
            CheckpointModule.ScanCheckpoints()
        end
    end)
    
    return "Auto Obby started at checkpoint " .. CurrentCheckpoint
end

-- Function to pause auto obby
function CheckpointModule.PauseAutoObby()
    if not AutoObbyRunning then
        return "Auto Obby is not running"
    end
    
    AutoObbyPaused = not AutoObbyPaused
    return AutoObbyPaused and "Auto Obby paused" or "Auto Obby resumed"
end

-- Function to stop auto obby
function CheckpointModule.StopAutoObby()
    if not AutoObbyRunning then
        return "Auto Obby is not running"
    end
    
    AutoObbyRunning = false
    AutoObbyPaused = false
    
    if ObbyConnection then
        ObbyConnection:Disconnect()
        ObbyConnection = nil
    end
    
    return "Auto Obby stopped"
end

-- Function to get current status
function CheckpointModule.GetStatus()
    return {
        Running = AutoObbyRunning,
        Paused = AutoObbyPaused,
        CurrentCheckpoint = CurrentCheckpoint,
        TotalCheckpoints = #Checkpoints,
        Checkpoints = Checkpoints
    }
end

-- Function to create UI elements
function CheckpointModule.CreateUI(container)
    -- Clear existing UI
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    
    -- Scan checkpoints
    local totalCheckpoints = CheckpointModule.ScanCheckpoints()
    
    -- Status display
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "Status"
    StatusLabel.Size = UDim2.new(1, 0, 0, 40)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "📊 Found " .. totalCheckpoints .. " checkpoints"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
    StatusLabel.TextSize = 14
    StatusLabel.Font = Enum.Font.GothamBold
    
    -- Checkpoint list frame
    local ListFrame = Instance.new("ScrollingFrame")
    ListFrame.Name = "CheckpointList"
    ListFrame.Size = UDim2.new(1, 0, 0, 150)
    ListFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    ListFrame.BackgroundTransparency = 0.1
    ListFrame.ScrollBarThickness = 4
    ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 8)
    ListCorner.Parent = ListFrame
    
    -- Populate checkpoint list
    local function UpdateCheckpointList()
        for _, child in ipairs(ListFrame:GetChildren()) do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end
        
        for i, checkpoint in ipairs(Checkpoints) do
            local Button = Instance.new("TextButton")
            Button.Name = "CP" .. i
            Button.Size = UDim2.new(1, -10, 0, 30)
            Button.Position = UDim2.new(0, 5, 0, (i-1) * 35)
            Button.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            Button.Text = "📍 Checkpoint " .. i .. " - " .. checkpoint.Name
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 12
            Button.Font = Enum.Font.Gotham
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                CheckpointModule.TeleportToCheckpoint(i)
            end)
            
            Button.Parent = ListFrame
        end
    end
    
    UpdateCheckpointList()
    
    -- Control buttons for Auto Obby
    local StartButton = Instance.new("TextButton")
    StartButton.Name = "StartAutoObby"
    StartButton.Size = UDim2.new(1, 0, 0, 45)
    StartButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
    StartButton.Text = "▶️ Start Auto Obby"
    StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    StartButton.TextSize = 16
    StartButton.Font = Enum.Font.GothamBold
    
    local StartCorner = Instance.new("UICorner")
    StartCorner.CornerRadius = UDim.new(0, 8)
    StartCorner.Parent = StartButton
    
    local PauseButton = Instance.new("TextButton")
    PauseButton.Name = "PauseAutoObby"
    PauseButton.Size = UDim2.new(1, 0, 0, 45)
    PauseButton.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    PauseButton.Text = "⏸️ Pause/Resume"
    PauseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    PauseButton.TextSize = 16
    PauseButton.Font = Enum.Font.GothamBold
    
    local PauseCorner = Instance.new("UICorner")
    PauseCorner.CornerRadius = UDim.new(0, 8)
    PauseCorner.Parent = PauseButton
    
    local StopButton = Instance.new("TextButton")
    StopButton.Name = "StopAutoObby"
    StopButton.Size = UDim2.new(1, 0, 0, 45)
    StopButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    StopButton.Text = "⏹️ Stop Auto Obby"
    StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    StopButton.TextSize = 16
    StopButton.Font = Enum.Font.GothamBold
    
    local StopCorner = Instance.new("UICorner")
    StopCorner.CornerRadius = UDim.new(0, 8)
    StopCorner.Parent = StopButton
    
    -- Refresh button
    local RefreshButton = Instance.new("TextButton")
    RefreshButton.Name = "RefreshCheckpoints"
    RefreshButton.Size = UDim2.new(1, 0, 0, 45)
    RefreshButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    RefreshButton.Text = "🔄 Refresh Checkpoints"
    RefreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    RefreshButton.TextSize = 16
    RefreshButton.Font = Enum.Font.GothamBold
    
    local RefreshCorner = Instance.new("UICorner")
    RefreshCorner.CornerRadius = UDim.new(0, 8)
    RefreshCorner.Parent = RefreshButton
    
    -- Start from specific checkpoint
    local StartFromFrame = Instance.new("Frame")
    StartFromFrame.Name = "StartFromFrame"
    StartFromFrame.Size = UDim2.new(1, 0, 0, 60)
    StartFromFrame.BackgroundTransparency = 1
    
    local StartFromLabel = Instance.new("TextLabel")
    StartFromLabel.Name = "StartFromLabel"
    StartFromLabel.Size = UDim2.new(0.5, -5, 0, 30)
    StartFromLabel.BackgroundTransparency = 1
    StartFromLabel.Text = "Start from CP:"
    StartFromLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StartFromLabel.TextSize = 14
    StartFromLabel.Font = Enum.Font.Gotham
    
    local StartFromInput = Instance.new("TextBox")
    StartFromInput.Name = "StartFromInput"
    StartFromInput.Size = UDim2.new(0.5, -5, 0, 30)
    StartFromInput.Position = UDim2.new(0.5, 5, 0, 0)
    StartFromInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    StartFromInput.Text = "1"
    StartFromInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    StartFromInput.TextSize = 14
    StartFromInput.Font = Enum.Font.Gotham
    StartFromInput.PlaceholderText = "Checkpoint number"
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = StartFromInput
    
    -- Button functionality
    StartButton.MouseButton1Click:Connect(function()
        local startIndex = tonumber(StartFromInput.Text) or 1
        local result = CheckpointModule.StartAutoObby(startIndex)
        StatusLabel.Text = "📊 " .. result
    end)
    
    PauseButton.MouseButton1Click:Connect(function()
        local result = CheckpointModule.PauseAutoObby()
        StatusLabel.Text = "📊 " .. result
    end)
    
    StopButton.MouseButton1Click:Connect(function()
        local result = CheckpointModule.StopAutoObby()
        StatusLabel.Text = "📊 " .. result
    end)
    
    RefreshButton.MouseButton1Click:Connect(function()
        local total = CheckpointModule.ScanCheckpoints()
        UpdateCheckpointList()
        StatusLabel.Text = "📊 Found " .. total .. " checkpoints"
    end)
    
    -- Add to container
    StatusLabel.Parent = container
    ListFrame.Parent = container
    StartFromFrame.Parent = container
    StartFromLabel.Parent = StartFromFrame
    StartFromInput.Parent = StartFromFrame
    RefreshButton.Parent = container
    StartButton.Parent = container
    PauseButton.Parent = container
    StopButton.Parent = container
end

-- Cleanup function
function CheckpointModule.Cleanup()
    CheckpointModule.StopAutoObby()
end

return CheckpointModule