-- Checkpoint Selector Module
-- Scans and teleports to checkpoints

local module = {}

-- Services
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- Checkpoint data
local checkpoints = {}
local checkpointNames = {
    "checkpoint", "cp", "point", "stage", "level",
    "flag", "marker", "spawn", "start", "end",
    "finish", "goal", "target", "destination"
}

-- Find all checkpoints
function module.scanCheckpoints()
    checkpoints = {}
    
    print("[Checkpoint] Scanning for checkpoints...")
    
    -- Method 1: Search by name in workspace
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            local nameLower = obj.Name:lower()
            
            for _, keyword in ipairs(checkpointNames) do
                if nameLower:find(keyword) then
                    table.insert(checkpoints, {
                        Object = obj,
                        Position = obj.Position,
                        Name = obj.Name,
                        Type = "Part"
                    })
                    break
                end
            end
        end
    end
    
    -- Method 2: Search in folders
    local folderNames = {"Checkpoints", "CP", "Points", "Stages", "Levels"}
    for _, folderName in ipairs(folderNames) do
        local folder = Workspace:FindFirstChild(folderName)
        if folder then
            for _, obj in ipairs(folder:GetDescendants()) do
                if obj:IsA("BasePart") or obj:IsA("MeshPart") then
                    table.insert(checkpoints, {
                        Object = obj,
                        Position = obj.Position,
                        Name = folderName .. "/" .. obj.Name,
                        Type = "FolderPart"
                    })
                end
            end
        end
    end
    
    -- Method 3: Search models
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") then
            local nameLower = obj.Name:lower()
            for _, keyword in ipairs(checkpointNames) do
                if nameLower:find(keyword) and obj.PrimaryPart then
                    table.insert(checkpoints, {
                        Object = obj,
                        Position = obj.PrimaryPart.Position,
                        Name = obj.Name,
                        Type = "Model"
                    })
                    break
                end
            end
        end
    end
    
    -- Remove duplicates by position
    local unique = {}
    local seen = {}
    
    for _, cp in ipairs(checkpoints) do
        local key = string.format("%d_%d_%d",
            math.floor(cp.Position.X / 5) * 5,
            math.floor(cp.Position.Y / 5) * 5,
            math.floor(cp.Position.Z / 5) * 5
        )
        
        if not seen[key] then
            seen[key] = true
            table.insert(unique, cp)
        end
    end
    
    checkpoints = unique
    
    -- Sort by position (assuming linear progression)
    table.sort(checkpoints, function(a, b)
        return (a.Position.Z + a.Position.X) < (b.Position.Z + b.Position.X)
    end)
    
    print("[Checkpoint] Found " .. #checkpoints .. " checkpoints")
    return checkpoints
end

-- Teleport to specific checkpoint
function module.teleportToCheckpoint(index)
    local player = Players.LocalPlayer
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if not hrp then
        print("[Checkpoint] No character found")
        return false
    end
    
    if index < 1 or index > #checkpoints then
        print("[Checkpoint] Invalid checkpoint index")
        return false
    end
    
    local cp = checkpoints[index]
    
    print("[Checkpoint] Teleporting to: " .. cp.Name)
    
    -- Safe teleport with anti-cheat bypass
    local function safeTeleport()
        -- Disable collision temporarily
        local parts = {}
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                parts[part] = part.CanCollide
                part.CanCollide = false
            end
        end
        
        -- Staged teleport (anti-cheat)
        local targetPos = cp.Position + Vector3.new(0, 5, 0)
        local currentPos = hrp.Position
        local steps = 5
        
        for i = 1, steps do
            local t = i / steps
            local interpPos = currentPos:Lerp(targetPos, t)
            hrp.CFrame = CFrame.new(interpPos)
            task.wait(0.05)
        end
        
        -- Final position
        hrp.CFrame = CFrame.new(targetPos)
        
        -- Restore collision
        task.wait(0.2)
        for part, canCollide in pairs(parts) do
            if part then
                part.CanCollide = canCollide
            end
        end
        
        return true
    end
    
    local success, err = pcall(safeTeleport)
    
    if success then
        print("[Checkpoint] Teleport successful")
        return true
    else
        print("[Checkpoint] Teleport failed:", err)
        return false
    end
end

-- Get checkpoint list for UI
function module.getCheckpointList()
    local list = {}
    
    for i, cp in ipairs(checkpoints) do
        table.insert(list, {
            Index = i,
            Name = cp.Name,
            Position = string.format("(%d, %d, %d)",
                math.floor(cp.Position.X),
                math.floor(cp.Position.Y),
                math.floor(cp.Position.Z)
            ),
            Type = cp.Type
        })
    end
    
    return list
end

-- Auto teleport to all checkpoints
function module.autoTeleportAll(callback)
    local player = Players.LocalPlayer
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if not hrp then
        if callback then callback("❌ No character") end
        return false
    end
    
    if #checkpoints == 0 then
        module.scanCheckpoints()
    end
    
    if #checkpoints == 0 then
        if callback then callback("❌ No checkpoints found") end
        return false
    end
    
    coroutine.wrap(function()
        if callback then callback("🎯 Found " .. #checkpoints .. " checkpoints") end
        task.wait(1)