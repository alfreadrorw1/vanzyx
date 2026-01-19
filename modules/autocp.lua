-- Auto Complete Checkpoint Module
-- Automatically finds and completes all checkpoints

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local module = {}

-- Configuration
local TELEPORT_DELAY = 0.25
local MAX_TELEPORT_DISTANCE = 500
local ANTI_KICK_STEPS = 5

-- Cache
local checkpoints = {}
local currentCheckpoint = 1
local isRunning = false

-- Find all checkpoints
local function FindCheckpoints()
    checkpoints = {}
    
    -- Method 1: Check for parts named "Checkpoint"
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("checkpoint") 
            or obj.Name:lower():find("cp")
            or obj.Name:lower():find("point")) then
            table.insert(checkpoints, {
                Part = obj,
                Position = obj.Position
            })
        end
    end
    
    -- Method 2: Check for folders containing checkpoints
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Folder") and (obj.Name:lower():find("checkpoint") 
            or obj.Name:lower():find("cp")) then
            for _, part in ipairs(obj:GetDescendants()) do
                if part:IsA("BasePart") then
                    table.insert(checkpoints, {
                        Part = part,
                        Position = part.Position
                    })
                end
            end
        end
    end
    
    -- Method 3: Check for models
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("checkpoint") 
            or obj.Name:lower():find("cp")) then
            local primaryPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if primaryPart then
                table.insert(checkpoints, {
                    Part = primaryPart,
                    Position = primaryPart.Position
                })
            end
        end
    end
    
    -- Sort checkpoints
    if #checkpoints > 0 then
        table.sort(checkpoints, function(a, b)
            -- Try to sort by number in name
            local numA = tonumber(a.Part.Name:match("%d+")) or 0
            local numB = tonumber(b.Part.Name:match("%d+")) or 0
            
            if numA ~= numB then
                return numA < numB
            end
            
            -- Sort by position (usually Z-axis for obbies)
            return a.Position.Z < b.Position.Z
        end)
        
        print("[AutoCP] Found", #checkpoints, "checkpoints")
    end
    
    return checkpoints
end

-- Safe teleport function
local function SafeTeleport(position)
    local character = LocalPlayer.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return false end
    
    -- Disable humanoid temporarily
    humanoid.AutoRotate = false
    
    -- Calculate distance
    local distance = (rootPart.Position - position).Magnitude
    
    if distance > MAX_TELEPORT_DISTANCE then
        -- Teleport in steps to avoid anti-cheat
        local direction = (position - rootPart.Position).Unit
        local steps = math.ceil(distance / MAX_TELEPORT_DISTANCE)
        local stepDistance = distance / steps
        
        for i = 1, steps do
            if not isRunning then break end
            
            local stepPos = rootPart.Position + (direction * stepDistance)
            rootPart.CFrame = CFrame.new(stepPos)
            
            task.wait(TELEPORT_DELAY / 2)
        end
    else
        -- Direct teleport
        rootPart.CFrame = CFrame.new(position)
    end
    
    -- Re-enable humanoid
    task.wait(0.1)
    humanoid.AutoRotate = true
    
    return true
end

-- Find the summit/finish
local function FindSummit()
    local summit = nil
    
    -- Look for finish/summit objects
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("finish") 
            or obj.Name:lower():find("summit")
            or obj.Name:lower():find("end")
            or obj.Name:lower():find("win")) then
            summit = obj
            break
        end
    end
    
    -- If no summit found, use the last checkpoint position + offset
    if not summit and #checkpoints > 0 then
        local lastCP = checkpoints[#checkpoints]
        summit = lastCP.Part
    end
    
    return summit
end

-- Main auto complete function
local function AutoComplete()
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end
    
    task.wait(1) -- Wait for character to load
    
    local character = LocalPlayer.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then
        warn("[AutoCP] No humanoid or root part found")
        return "ERROR: No character"
    end
    
    -- Find checkpoints
    FindCheckpoints()
    
    if #checkpoints == 0 then
        warn("[AutoCP] No checkpoints found")
        return "NO CHECKPOINTS"
    end
    
    print("[AutoCP] Starting auto-complete with", #checkpoints, "checkpoints")
    
    -- Complete each checkpoint
    for i, checkpoint in ipairs(checkpoints) do
        if not isRunning then break end
        
        currentCheckpoint = i
        print("[AutoCP] Teleporting to checkpoint", i)
        
        local success = SafeTeleport(checkpoint.Position)
        
        if success then
            -- Trigger checkpoint (touch part)
            if checkpoint.Part and checkpoint.Part:IsA("BasePart") then
                firetouchinterest(rootPart, checkpoint.Part, 0)
                task.wait(0.05)
                firetouchinterest(rootPart, checkpoint.Part, 1)
            end
            
            -- Update status
            _G.CurrentStatus = "CP " .. i .. "/" .. #checkpoints
        end
        
        task.wait(TELEPORT_DELAY)
    end
    
    -- Go to summit/finish
    if isRunning then
        local summit = FindSummit()
        if summit then
            print("[AutoCP] Teleporting to summit")
            SafeTeleport(summit.Position)
            
            -- Touch the finish
            if summit:IsA("BasePart") then
                firetouchinterest(rootPart, summit, 0)
                task.wait(0.05)
                firetouchinterest(rootPart, summit, 1)
            end
            
            task.wait(0.5)
        end
    end
    
    return "FINISHED"
end

-- Module functions
function module.Start()
    if isRunning then
        return "ALREADY RUNNING"
    end
    
    isRunning = true
    _G.AutoCPRunning = true
    _G.CurrentStatus = "STARTING"
    
    task.spawn(function()
        local result = AutoComplete()
        
        isRunning = false
        _G.AutoCPRunning = false
        
        -- Disable fly if it was enabled
        if _G.FlyEnabled then
            _G.DisableFly()
        end
        
        return result
    end)
    
    return "RUNNING"
end

function module.Stop()
    isRunning = false
    _G.AutoCPRunning = false
    return "STOPPED"
end

function module.GetStatus()
    if not isRunning then return "IDLE" end
    return _G.CurrentStatus or "RUNNING"
end

function module.GetCheckpointCount()
    return #checkpoints
end

return module