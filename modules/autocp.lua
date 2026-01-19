-- Auto Checkpoint Completion Module
-- Cari dan teleport ke semua checkpoint secara otomatis anjay

local module = {}

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")

-- Cari semua checkpoint di game
function module.findCheckpoints()
    local checkpoints = {}
    
    -- Method 1: Cari part bernama "Checkpoint"
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("checkpoint") then
            table.insert(checkpoints, {
                Part = obj,
                Position = obj.Position,
                Name = obj.Name
            })
        end
    end
    
    -- Method 2: Cari folder "Checkpoints"
    local checkpointFolder = Workspace:FindFirstChild("Checkpoints")
    if checkpointFolder then
        for _, obj in ipairs(checkpointFolder:GetDescendants()) do
            if obj:IsA("BasePart") then
                table.insert(checkpoints, {
                    Part = obj,
                    Position = obj.Position,
                    Name = obj.Name
                })
            end
        end
    end
    
    -- Method 3: Cari model dengan nama checkpoint
    for _, model in ipairs(Workspace:GetChildren()) do
        if model:IsA("Model") and model.Name:lower():find("checkpoint") then
            local primary = model:FindFirstChildWhichIsA("BasePart")
            if primary then
                table.insert(checkpoints, {
                    Part = primary,
                    Position = primary.Position,
                    Name = model.Name
                })
            end
        end
    end
    
    -- Urutkan checkpoint
    table.sort(checkpoints, function(a, b)
        -- Coba ekstrak angka dari nama
        local numA = tonumber(string.match(a.Name, "%d+")) or 0
        local numB = tonumber(string.match(b.Name, "%d+")) or 0
        
        if numA ~= numB then
            return numA < numB
        else
            -- Jika tidak ada angka, urutkan berdasarkan posisi Z
            return a.Position.Z < b.Position.Z
        end
    end)
    
    return checkpoints
end

-- Cari summit
function module.findSummit()
    -- Cari summit dengan berbagai nama umum
    local summitNames = {
        "summit", "finish", "end", "victory", "goal",
        "final", "top", "peak", "win", "complete"
    }
    
    -- Cari di workspace
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local lowerName = obj.Name:lower()
            for _, name in ipairs(summitNames) do
                if lowerName:find(name) then
                    return {
                        Part = obj,
                        Position = obj.Position,
                        Name = obj.Name,
                        Type = "SUMMIT"
                    }
                end
            end
        end
    end
    
    -- Cari model summit
    for _, model in ipairs(Workspace:GetChildren()) do
        if model:IsA("Model") then
            local lowerName = model.Name:lower()
            for _, name in ipairs(summitNames) do
                if lowerName:find(name) then
                    local primary = model:FindFirstChildWhichIsA("BasePart")
                    if primary then
                        return {
                            Part = primary,
                            Position = primary.Position,
                            Name = model.Name,
                            Type = "SUMMIT"
                        }
                    end
                end
            end
        end
    end
    
    return nil
end

-- Teleport ke checkpoint dengan aman
function module.teleportToCheckpoint(character, hrp, position, callback)
    local teleportModule = require(script.Parent.autoteleport)
    
    if teleportModule then
        teleportModule.safeTeleport(character, hrp, position, callback)
    else
        -- Fallback teleport sederhana
        if character and hrp then
            hrp.CFrame = CFrame.new(position)
            task.wait(0.2)
            if callback then callback(true) end
        end
    end
end

-- Proses utama complete semua checkpoint
function module.start(character, hrp, humanoid, statusCallback)
    if not character or not hrp then
        if statusCallback then statusCallback("ERROR") end
        return
    end
    
    coroutine.wrap(function()
        -- Nonaktifkan humanoid movement sementara
        if humanoid then
            humanoid.PlatformStand = true
        end
        
        -- Cari semua checkpoint
        local checkpoints = module.findCheckpoints()
        
        if #checkpoints == 0 then
            if statusCallback then statusCallback("NO CHECKPOINTS") end
            return
        end
        
        if statusCallback then statusCallback("FOUND " .. #checkpoints .. " CP") end
        
        -- Teleport ke tiap checkpoint dengan delay
        for i, cp in ipairs(checkpoints) do
            if statusCallback then 
                statusCallback("CP " .. i .. "/" .. #checkpoints .. " - " .. cp.Name)
            end
            
            -- Teleport ke checkpoint saat ini
            module.teleportToCheckpoint(character, hrp, cp.Position, function(success)
                if not success then
                    warn("Failed to teleport to CP " .. i .. " - " .. cp.Name)
                end
            end)
            
            -- Delay antar checkpoint (1 detik)
            task.wait(1)
        end
        
        -- Tunggu di checkpoint terakhir selama 3 detik
        if #checkpoints > 0 then
            local lastCp = checkpoints[#checkpoints]
            
            if statusCallback then 
                statusCallback("WAITING AT LAST CP FOR 3 SECONDS")
            end
            
            module.teleportToCheckpoint(character, hrp, lastCp.Position)
            
            -- Tunggu 3 detik di checkpoint terakhir
            for i = 1, 3 do
                task.wait(1)
                if statusCallback then 
                    statusCallback("WAITING... " .. i .. "/3 SECONDS")
                end
            end
            
            -- Cari dan teleport ke summit
            if statusCallback then statusCallback("SEARCHING FOR SUMMIT...") end
            
            local summit = module.findSummit()
            
            if summit then
                if statusCallback then statusCallback("FOUND SUMMIT: " .. summit.Name) end
                
                -- Teleport ke summit
                module.teleportToCheckpoint(character, hrp, summit.Position, function(success)
                    if success then
                        if statusCallback then statusCallback("TELEPORTED TO SUMMIT!") end
                    else
                        if statusCallback then statusCallback("FAILED TO TELEPORT TO SUMMIT") end
                    end
                end)
                
                -- Tunggu di summit
                task.wait(2)
            else
                if statusCallback then statusCallback("SUMMIT NOT FOUND") end
            end
            
            -- Re-enable humanoid movement
            if humanoid then
                humanoid.PlatformStand = false
            end
            
            if statusCallback then statusCallback("FINISHED") end
        end
    end)()
end

return module