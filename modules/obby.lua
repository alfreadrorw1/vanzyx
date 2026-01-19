-- Auto Obby Runner Module
-- Automatically completes obstacle courses

local module = {}

-- Services
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")

-- State
local running = false
local paused = false
local currentStage = 1
local checkpoints = {}
local path = nil

-- Initialize
function module.init()
    print("[Obby] Initializing auto runner...")
    -- Initialization code here
end

-- Start auto obby
function module.start()
    if running then
        print("[Obby] Already running")
        return false
    end
    
    print("[Obby] Starting auto obby...")
    running = true
    paused = false
    
    -- Scan for checkpoints
    module.scanObbyCheckpoints()
    
    -- Start running coroutine
    coroutine.wrap(function()
        module.runObbyLoop()
    end)()
    
    return true
end

-- Pause auto obby
function module.pause()
    if not running then return false end
    
    paused = true
    print("[Obby] Paused")
    return true
end

-- Resume auto obby
function module.resume()
    if not running then return false end
    
    paused = false
    print("[Obby] Resumed")
    return true
end

-- Stop auto obby
function module.stop()
    if not running then return false end
    
    running = false
    paused = false
    print("[Obby] Stopped")
    return true
end

-- Get status
function module.getStatus()
    if not running then return "stopped" end
    if paused then return "paused" end
    return "running"
end

-- Scan for obby checkpoints
function module.scanObbyCheckpoints()
    checkpoints = {}
    
    -- Search patterns for obby checkpoints
    local patterns = {
        "checkpoint", "cp", "stage", "level", "part",
        "platform", "pad", "button", "trigger", "zone"
    }
    
    -- Search in workspace
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            local nameLower = obj.Name:lower()
            
            for _, pattern in ipairs(patterns) do
                if nameLower:find(pattern) and not nameLower:find("kill") then
                    table.insert(checkpoints, {
                        Object = obj,
                        Position = obj.Position,
                        Name = obj.Name,
                        Size = obj.Size
                    })
                    break
                end
            end
        end
    end
    
    -- Sort by position (assuming linear progression)
    table.sort(checkpoints, function(a, b)
        -- Try to sort by Z, then X, then Y
        if math.abs(a.Position.Z - b.Position.Z) > 10 then
            return a.Position.Z < b.Position.Z
        elseif math.abs(a.Position.X - b.Position.X) > 10 then
            return a.Position.X < b.Position.X
        else
            return a.Position.Y < b.Position.Y
        end
    end)
    
    print("[Obby] Found", #checkpoints, "potential checkpoints")
    return checkpoints
end

-- Main obby running loop
function module.runObbyLoop()
    local player = Players.LocalPlayer
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if not character or not humanoid or not hrp then
        print("[Obby] Character not ready")
        running = false
        return
    end
    
    print("[Obby] Starting at checkpoint", currentStage)
    
    while running and currentStage <= #checkpoints do
        if paused then
            task.wait(0.5)
            continue
        end
        
        local cp = checkpoints[currentStage]
        local targetPos = cp.Position + Vector3.new(0, 5, 0)
        
        print("[Obby] Moving to checkpoint", currentStage, "-", cp.Name)
        
        -- Move to checkpoint
        local success = module.moveToPosition(hrp, targetPos, humanoid)
        
        if success then
            print("[Obby] Reached checkpoint", currentStage)
            currentStage = currentStage + 1
            task.wait(0.5) -- Wait before next checkpoint
        else
            print("[Obby] Failed to reach checkpoint", currentStage)
            -- Try next checkpoint
            currentStage = currentStage + 1
            task.wait(1)
        end
        
        -- Check if character still exists
        if not character or not character.Parent then
            print("[Obby] Character lost")
            break
        end
    end
    
    if currentStage > #checkpoints then
        print("[Obby] Completed all checkpoints!")
    end
    
    running = false
end

-- Move character to position
function module.moveToPosition(hrp, targetPos, humanoid)
    local startTime = tick()
    local timeout = 15 -- seconds
    
    while tick() - startTime < timeout do
        if paused or not running then
            return false
        end
        
        if not hrp or not hrp.Parent then
            return false
        end
        
        local currentPos = hrp.Position
        local distance = (targetPos - currentPos).Magnitude
        
        -- If close enough, success
        if distance < 10 then
            return true
        end
        
        -- Calculate direction
        local direction = (targetPos - currentPos).Unit
        
        -- Move towards target
        humanoid:MoveTo(currentPos + direction * math.min(distance, 20))
        
        -- Jump if needed
        if targetPos.Y > currentPos.Y + 5 then
            humanoid.Jump = true
        end
        
        task.wait(0.1)
    end
    
    return false -- Timeout
end

-- Set starting stage
function module.setStage(stage)
    if stage >= 1 and stage <= #checkpoints then
        currentStage = stage
        print("[Obby] Set to stage", stage)
        return true
    end
    return false
end

-- Get progress
function module.getProgress()
    return {
        Current = currentStage,
        Total = #checkpoints,
        Percent = math.floor((currentStage / math.max(#checkpoints, 1)) * 100)
    }
end

return module