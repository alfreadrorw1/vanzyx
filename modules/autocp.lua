-- Auto Complete CP Module

local module = {}

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Player
local player = Players.LocalPlayer
local character = player.Character
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChild("Humanoid")

-- Module state
local active = false
local checkpoints = {}
local currentCheckpointIndex = 1
local teleporting = false

-- Find all checkpoints in the game
local function findCheckpoints()
    local foundCheckpoints = {}
    
    -- Search for parts named "Checkpoint"
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("checkpoint") or name:find("cp") then
                table.insert(foundCheckpoints, {
                    part = obj,
                    position = obj.Position,
                    name = obj.Name
                })
            end
        end
    end
    
    -- Search in "Checkpoints" folder
    local checkpointsFolder = Workspace:FindFirstChild("Checkpoints")
    if checkpointsFolder then
        for _, obj in ipairs(checkpointsFolder:GetDescendants()) do
            if obj:IsA("BasePart") then
                table.insert(foundCheckpoints, {
                    part = obj,
                    position = obj.Position,
                    name = obj.Name
                })
            end
        end
    end
    
    -- Sort checkpoints
    table.sort(foundCheckpoints, function(a, b)
        -- Try to extract numbers from names
        local numA = tonumber(a.name:match("%d+"))
        local numB = tonumber(b.name:match("%d+"))
        
        if numA and numB then
            return numA < numB
        elseif numA then
            return true
        elseif numB then
            return false
        else
            -- Sort by Z position if no numbers
            return a.position.Z < b.position.Z
        end
    end)
    
    return foundCheckpoints
end

-- Safe teleport function
local function safeTeleportTo(position)
    if not character or not humanoidRootPart then
        return false
    end
    
    teleporting = true
    
    -- Disable humanoid movement during teleport
    if humanoid then
        humanoid.PlatformStand = true
    end
    
    -- Store original properties
    local originalTransparency = humanoidRootPart.Transparency
    local originalCanCollide = humanoidRootPart.CanCollide
    
    -- Make character non-collidable
    humanoidRootPart.Transparency = 1
    humanoidRootPart.CanCollide = false
    
    -- Teleport
    humanoidRootPart.CFrame = CFrame.new(position)
    
    -- Wait for teleport to complete
    RunService.Heartbeat:Wait()
    task.wait(0.1)
    
    -- Restore properties
    humanoidRootPart.Transparency = originalTransparency
    humanoidRootPart.CanCollide = originalCanCollide
    
    if humanoid then
        humanoid.PlatformStand = false
    end
    
    teleporting = false
    return true
end

-- Check if at summit
local function isAtSummit(checkpoint)
    local name = checkpoint.name:lower()
    return name:find("summit") or name:find("finish") or name:find("end")
end

-- Main CP completion loop
local function completeCheckpoints()
    if not active or not character or not humanoidRootPart then
        return
    end
    
    -- Find checkpoints
    checkpoints = findCheckpoints()
    
    if #checkpoints == 0 then
        warn("No checkpoints found!")
        return
    end
    
    for i, checkpoint in ipairs(checkpoints) do
        if not active then break end
        
        currentCheckpointIndex = i
        
        -- Check if we're already at this checkpoint
        local distance = (humanoidRootPart.Position - checkpoint.position).Magnitude
        if distance > 10 then
            -- Teleport to checkpoint
            local success = safeTeleportTo(checkpoint.position + Vector3.new(0, 5, 0))
            
            if not success then
                warn("Failed to teleport to checkpoint", checkpoint.name)
                break
            end
            
            -- Wait before next checkpoint
            task.wait(0.25 + math.random() * 0.05)
        end
        
        -- Check if we reached the summit
        if isAtSummit(checkpoint) then
            print("Reached summit! Stopping Auto CP.")
            break
        end
    end
    
    -- Deactivate after completion
    if active then
        module.deactivate()
    end
end

-- Character added handler
local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    humanoid = character:FindFirstChild("Humanoid")
    
    if active then
        -- Restart CP completion with new character
        task.wait(1)
        if active then
            completeCheckpoints()
        end
    end
end

-- Module functions
function module.activate()
    if active then return end
    
    active = true
    print("Auto Complete CP activated")
    
    -- Set up character monitoring
    player.CharacterAdded:Connect(onCharacterAdded)
    
    -- Start CP completion
    spawn(completeCheckpoints)
end

function module.deactivate()
    if not active then return end
    
    active = false
    teleporting = false
    print("Auto Complete CP deactivated")
    
    -- Restore character if teleporting
    if character and humanoid then
        humanoid.PlatformStand = false
    end
end

-- Return module
return module