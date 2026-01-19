-- Auto Carry Module
-- Automatically carries player through obstacles

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local module = {}

-- Configuration
local CARRY_SPEED = 30
local isCarrying = false
local carryConnection

-- Simple pathfinding function
local function FindPath(startPos, endPos)
    local waypoints = {}
    local distance = (endPos - startPos).Magnitude
    
    -- Simple straight line path with intermediate points
    if distance > 100 then
        local direction = (endPos - startPos).Unit
        local steps = math.ceil(distance / 50)
        
        for i = 1, steps - 1 do
            local waypointPos = startPos + (direction * (distance / steps * i))
            table.insert(waypoints, waypointPos)
        end
    end
    
    table.insert(waypoints, endPos)
    return waypoints
end

-- Obstacle detection
local function DetectObstacles(position, radius)
    local obstacles = {}
    
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            if (part.Position - position).Magnitude < radius then
                table.insert(obstacles, part)
            end
        end
    end
    
    return obstacles
end

-- Safe movement function
local function MoveToPosition(position)
    local character = LocalPlayer.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return false end
    
    -- Check for obstacles
    local obstacles = DetectObstacles(rootPart.Position, 20)
    
    -- Temporarily disable collision for obstacles
    local originalCanCollide = {}
    for _, obstacle in ipairs(obstacles) do
        originalCanCollide[obstacle] = obstacle.CanCollide
        obstacle.CanCollide = false
    end
    
    -- Disable humanoid movement during teleport
    humanoid.AutoRotate = false
    
    -- Move in small steps for smooth movement
    local startPos = rootPart.Position
    local direction = (position - startPos).Unit
    local distance = (position - startPos).Magnitude
    local steps = math.ceil(distance / 10)
    
    for i = 1, steps do
        if not isCarrying then break end
        
        local stepPos = startPos + (direction * (distance / steps * i))
        rootPart.CFrame = CFrame.new(stepPos)
        
        RunService.RenderStepped:Wait()
    end
    
    -- Restore collision
    for obstacle, canCollide in pairs(originalCanCollide) do
        if obstacle and obstacle.Parent then
            obstacle.CanCollide = canCollide
        end
    end
    
    -- Re-enable humanoid
    humanoid.AutoRotate = true
    
    return true
end

-- Auto-follow checkpoints
local function AutoFollowCheckpoints()
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end
    
    task.wait(1)
    
    while isCarrying do
        -- Find nearest checkpoint
        local checkpoints = {}
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("checkpoint") then
                table.insert(checkpoints, obj)
            end
        end
        
        if #checkpoints > 0 then
            -- Sort by distance
            table.sort(checkpoints, function(a, b)
                local char = LocalPlayer.Character
                if not char then return false end
                
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then return false end
                
                return (root.Position - a.Position).Magnitude < (root.Position - b.Position).Magnitude
            end)
            
            -- Move to nearest checkpoint
            local nearest = checkpoints[1]
            local char = LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    MoveToPosition(nearest.Position)
                    
                    -- Touch checkpoint
                    firetouchinterest(root, nearest, 0)
                    task.wait(0.05)
                    firetouchinterest(root, nearest, 1)
                end
            end
        end
        
        task.wait(0.5)
    end
end

-- UI Creation
local function CreateCarryUI(parentFrame)
    local CarryFrame = Instance.new("Frame")
    CarryFrame.Name = "CarryControls"
    CarryFrame.Size = UDim2.new(1, -10, 0, 60)
    CarryFrame.Position = UDim2.new(0, 5, 0, 135)
    CarryFrame.BackgroundTransparency = 1
    
    -- Title
    local CarryTitle = Instance.new("TextLabel")
    CarryTitle.Name = "Title"
    CarryTitle.Size = UDim2.new(1, 0, 0, 20)
    CarryTitle.BackgroundTransparency = 1
    CarryTitle.Text = "AUTO CARRY"
    CarryTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
    CarryTitle.TextSize = 14
    CarryTitle.Font = Enum.Font.GothamBold
    CarryTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Status
    local CarryStatus = Instance.new("TextLabel")
    CarryStatus.Name = "Status"
    CarryStatus.Size = UDim2.new(1, 0, 0, 20)
    CarryStatus.Position = UDim2.new(0, 0, 0, 20)
    CarryStatus.BackgroundTransparency = 1
    CarryStatus.Text = "Status: OFF"
    CarryStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    CarryStatus.TextSize = 12
    CarryStatus.Font = Enum.Font.Gotham
    CarryStatus.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Control buttons
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = "Buttons"
    ButtonFrame.Size = UDim2.new(1, 0, 0, 25)
    ButtonFrame.Position = UDim2.new(0, 0, 0, 40)
    ButtonFrame.BackgroundTransparency = 1
    
    local StartButton = Instance.new("TextButton")
    StartButton.Name = "Start"
    StartButton.Size = UDim2.new(0.48, 0, 1, 0)
    StartButton.Position = UDim2.new(0, 0, 0, 0)
    StartButton.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
    StartButton.Text = "START"
    StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    StartButton.TextSize = 12
    StartButton.Font = Enum.Font.GothamBold
    
    local StopButton = Instance.new("TextButton")
    StopButton.Name = "Stop"
    StopButton.Size = UDim2.new(0.48, 0, 1, 0)
    StopButton.Position = UDim2.new(0.52, 0, 0, 0)
    StopButton.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
    StopButton.Text = "STOP"
    StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    StopButton.TextSize = 12
    StopButton.Font = Enum.Font.GothamBold
    
    local function ApplyCorner(button)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = button
    end
    
    ApplyCorner(StartButton)
    ApplyCorner(StopButton)
    
    StartButton.MouseButton1Click:Connect(function()
        module.Start()
        CarryStatus.Text = "Status: ON"
        CarryStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
    end)
    
    StopButton.MouseButton1Click:Connect(function()
        module.Stop()
        CarryStatus.Text = "Status: OFF"
        CarryStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    end)
    
    CarryTitle.Parent = CarryFrame
    CarryStatus.Parent = CarryFrame
    StartButton.Parent = ButtonFrame
    StopButton.Parent = ButtonFrame
    ButtonFrame.Parent = CarryFrame
    CarryFrame.Parent = parentFrame
    
    return {
        Status = CarryStatus,
        StartButton = StartButton,
        StopButton = StopButton
    }
end

-- Module functions
function module.Start()
    if isCarrying then
        return "ALREADY CARRYING"
    end
    
    isCarrying = true
    _G.AutoCarryRunning = true
    
    task.spawn(function()
        AutoFollowCheckpoints()
    end)
    
    print("[AutoCarry] Started")
    return "STARTED"
end

function module.Stop()
    if not isCarrying then
        return "NOT CARRYING"
    end
    
    isCarrying = false
    _G.AutoCarryRunning = false
    
    if carryConnection then
        carryConnection:Disconnect()
        carryConnection = nil
    end
    
    print("[AutoCarry] Stopped")
    return "STOPPED"
end

function module.GetStatus()
    return isCarrying and "CARRYING" or "IDLE"
end

-- Create UI when module loads
task.spawn(function()
    task.wait(1) -- Wait for main UI to load
    if _G.VanzyxUI then
        local uiElements = CreateCarryUI(_G.VanzyxUI.ModulesFrame)
        _G.CarryUI = uiElements
    end
end)

return module