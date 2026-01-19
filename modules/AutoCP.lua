-- Auto Checkpoint Completion Module
-- Cari dan teleport ke semua checkpoint secara otomatis

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

-- Cari posisi summit/finish
function module.findSummit()
    -- Method 1: Cari objek dengan nama "Summit"
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("summit") then
            return obj.Position
        end
    end
    
    -- Method 2: Cari "Finish"
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("finish") then
            return obj.Position
        end
    end
    
    -- Method 3: Cari area dengan posisi tertinggi
    local highestPart = nil
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Position.Y > 500 then
            if not highestPart or obj.Position.Y > highestPart.Position.Y then
                highestPart = obj
            end
        end
    end
    
    if highestPart then
        return highestPart.Position + Vector3.new(0, 10, 0)
    end
    
    -- Default: posisi tinggi
    return Vector3.new(0, 1000, 0)
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

-- Teleport ke summit
function module.teleportToSummit(character, hrp)
    local summitPosition = module.findSummit()
    module.teleportToCheckpoint(character, hrp, summitPosition, function(success)
        if success then
            warn("SUCCESS: Teleported to summit!")
        else
            warn("WARNING: Teleport to summit might have failed")
        end
    end)
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
        
        -- Teleport ke tiap checkpoint
        for i, cp in ipairs(checkpoints) do
            if statusCallback then 
                statusCallback("CP " .. i .. "/" .. #checkpoints)
            end
            
            -- Teleport ke checkpoint
            module.teleportToCheckpoint(character, hrp, cp.Position, function(success)
                if not success then
                    warn("Failed to teleport to CP " .. i)
                end
            end)
            
            -- Delay 1 detik di setiap checkpoint sebelum pindah ke checkpoint berikutnya
            task.wait(1)
        end
        
        -- Tunggu 3 detik di checkpoint terakhir sebelum teleport ke summit
        if #checkpoints > 0 then
            local lastCp = checkpoints[#checkpoints]
            module.teleportToCheckpoint(character, hrp, lastCp.Position)
            
            if statusCallback then 
                statusCallback("WAITING 3 SEC AT LAST CP...")
            end
            
            -- Tunggu 3 detik di checkpoint terakhir
            task.wait(3)
            
            -- Teleport ke summit
            if statusCallback then 
                statusCallback("TELEPORTING TO SUMMIT...")
            end
            
            module.teleportToSummit(character, hrp)
            
            -- Tunggu 1 detik setelah teleport ke summit
            task.wait(1)
            
            -- Re-enable humanoid movement
            if humanoid then
                humanoid.PlatformStand = false
            end
            
            if statusCallback then statusCallback("FINISHED AT SUMMIT!") end
        end
    end)()
end

return module