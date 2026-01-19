-- Auto Checkpoint Module
-- Simple auto checkpoint finder

local module = {}

-- Services
local Workspace = game:GetService("Workspace")

-- Find all checkpoints
function module.findCheckpoints()
    local checkpoints = {}
    
    print("Searching for checkpoints...")
    
    -- Method 1: Find by name
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local nameLower = obj.Name:lower()
            if nameLower:find("checkpoint") or 
               nameLower:find("cp") or 
               nameLower:find("point") or
               nameLower:find("cekpoint") or
               nameLower:find("cekpoin") or
               nameLower:find("flag") then
                table.insert(checkpoints, {
                    Part = obj,
                    Position = obj.Position,
                    Name = obj.Name
                })
            end
        end
    end
    
    -- Method 2: Find in checkpoint folders
    local folders = {"Checkpoints", "CP", "Points", "CekPoint", "cekpoint", "cekpoin", "point"}
    for _, folderName in ipairs(folders) do
        local folder = Workspace:FindFirstChild(folderName)
        if folder then
            for _, obj in ipairs(folder:GetDescendants()) do
                if obj:IsA("BasePart") then
                    table.insert(checkpoints, {
                        Part = obj,
                        Position = obj.Position,
                        Name = folderName .. "/" .. obj.Name
                    })
                end
            end
        end
    end
    
    -- Remove duplicates
    local unique = {}
    local seen = {}
    for _, cp in ipairs(checkpoints) do
        local key = math.floor(cp.Position.X) .. "_" .. 
                    math.floor(cp.Position.Y) .. "_" .. 
                    math.floor(cp.Position.Z)
        if not seen[key] then
            seen[key] = true
            table.insert(unique, cp)
        end
    end
    
    -- Sort by position
    table.sort(unique, function(a, b)
        return a.Position.Z < b.Position.Z
    end)
    
    print("Found " .. #unique .. " checkpoints")
    return unique
end

-- Start auto checkpoint
function module.start(character, hrp, humanoid, callback)
    if not character or not hrp then
        if callback then callback("❌ ERROR") end
        return false
    end
    
    coroutine.wrap(function()
        -- Disable physics temporarily
        local wasPlatformStand = false
        if humanoid then
            wasPlatformStand = humanoid.PlatformStand
            humanoid.PlatformStand = true
        end
        
        if callback then callback("🔍 SEARCHING...") end
        task.wait(1)
        
        -- Find checkpoints
        local checkpoints = module.findCheckpoints()
        
        if #checkpoints == 0 then
            if callback then callback("❌ NO CHECKPOINTS") end
            if humanoid then humanoid.PlatformStand = wasPlatformStand end
            return
        end
        
        if callback then callback("🎯 " .. #checkpoints .. " FOUND") end
        task.wait(1)
        
        -- Teleport to each checkpoint
        for i, cp in ipairs(checkpoints) do
            if callback then callback("📍 " .. i .. "/" .. #checkpoints) end
            
            -- Disable collision
            local parts = {}
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    table.insert(parts, part)
                    part.CanCollide = false
                end
            end
            
            -- Teleport
            hrp.CFrame = CFrame.new(cp.Position + Vector3.new(0, 5, 0))
            
            -- Wait
            task.wait(0.5)
            
            -- Re-enable collision
            for _, part in ipairs(parts) do
                if part then
                    part.CanCollide = true
                end
            end
            
            task.wait(0.5)
        end
        
        -- Restore physics
        if humanoid then
            humanoid.PlatformStand = wasPlatformStand
        end
        
        if callback then callback("🎉 COMPLETED!") end
        
    end)()
    
    return true
end

return module