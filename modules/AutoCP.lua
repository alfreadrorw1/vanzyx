-- Auto Checkpoint Completion Module - FIXED VERSION
-- Cari dan teleport ke semua checkpoint secara otomatis

local module = {}

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Cari semua checkpoint di game (lebih komprehensif)
function module.findCheckpoints()
    local checkpoints = {}
    
    print("Mencari checkpoints...")
    
    -- Method 1: Cari semua BasePart dengan nama mengandung checkpoint
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local nameLower = obj.Name:lower()
            if nameLower:find("checkpoint") or 
               nameLower:find("cp") or 
               nameLower:find("point") or
               nameLower:find("flag") or
               nameLower:find("stage") or
               nameLower:find("level") then
                table.insert(checkpoints, {
                    Part = obj,
                    Position = obj.Position,
                    Name = obj.Name
                })
            end
        elseif obj:IsA("Model") then
            local nameLower = obj.Name:lower()
            if nameLower:find("checkpoint") or 
               nameLower:find("cp") or 
               nameLower:find("point") then
                local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if primary then
                    table.insert(checkpoints, {
                        Part = primary,
                        Position = primary.Position,
                        Name = obj.Name
                    })
                end
            end
        end
    end
    
    -- Method 2: Cari folder khusus
    local folderNames = {"Checkpoints", "CP", "Points", "Stages", "Levels"}
    for _, folderName in ipairs(folderNames) do
        local folder = Workspace:FindFirstChild(folderName)
        if folder then
            for _, obj in ipairs(folder:GetDescendants()) do
                if obj:IsA("BasePart") then
                    table.insert(checkpoints, {
                        Part = obj,
                        Position = obj.Position,
                        Name = obj.Name
                    })
                end
            end
        end
    end
    
    -- Method 3: Cari part dengan warna tertentu (sering checkpoint berwarna)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.BrickColor == BrickColor.new("Bright green") then
            -- Skip jika sudah ada
            local exists = false
            for _, cp in ipairs(checkpoints) do
                if cp.Part == obj then
                    exists = true
                    break
                end
            end
            if not exists then
                table.insert(checkpoints, {
                    Part = obj,
                    Position = obj.Position,
                    Name = obj.Name .. " (Green)"
                })
            end
        end
    end
    
    -- Remove duplicates
    local uniqueCheckpoints = {}
    local positions = {}
    for _, cp in ipairs(checkpoints) do
        local posKey = math.floor(cp.Position.X) .. "_" .. math.floor(cp.Position.Y) .. "_" .. math.floor(cp.Position.Z)
        if not positions[posKey] then
            positions[posKey] = true
            table.insert(uniqueCheckpoints, cp)
        end
    end
    
    -- Urutkan berdasarkan posisi
    table.sort(uniqueCheckpoints, function(a, b)
        -- Prioritas: checkpoint dengan angka di nama
        local numA = tonumber(string.match(a.Name, "%d+")) or 9999
        local numB = tonumber(string.match(b.Name, "%d+")) or 9999
        
        if numA ~= numB then
            return numA < numB
        else
            -- Jika tidak ada angka, urutkan berdasarkan posisi X lalu Z
            if math.abs(a.Position.X - b.Position.X) > 10 then
                return a.Position.X < b.Position.X
            else
                return a.Position.Z < b.Position.Z
            end
        end
    end)
    
    print("Ditemukan " .. #uniqueCheckpoints .. " checkpoint")
    for i, cp in ipairs(uniqueCheckpoints) do
        print(i .. ". " .. cp.Name .. " at " .. tostring(cp.Position))
    end
    
    return uniqueCheckpoints
end

-- Teleport ke checkpoint
function module.teleportToCheckpoint(character, hrp, position)
    if not character or not hrp then
        return false
    end
    
    -- Disable collision sementara
    local parts = {}
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(parts, part)
            part.CanCollide = false
        end
    end
    
    -- Teleport dengan offset agar tidak stuck di dalam part
    local targetPos = position + Vector3.new(0, 5, 0)
    hrp.CFrame = CFrame.new(targetPos)
    
    -- Tunggu stabilisasi
    task.wait(0.3)
    
    -- Re-enable collision
    for _, part in ipairs(parts) do
        if part then
            part.CanCollide = true
        end
    end
    
    return true
end

-- Proses utama complete semua checkpoint
function module.start(character, hrp, humanoid, statusCallback)
    if not character or not hrp then
        if statusCallback then 
            statusCallback("❌ ERROR: NO CHARACTER/HRP")
        end
        return false
    end
    
    local success, err = pcall(function()
        if statusCallback then 
            statusCallback("🔍 MENCARI CHECKPOINTS...")
        end
        
        task.wait(0.5)
        
        -- Nonaktifkan humanoid physics sementara
        local wasPlatformStand = false
        if humanoid then
            wasPlatformStand = humanoid.PlatformStand
            humanoid.PlatformStand = true
        end
        
        -- Cari semua checkpoint
        local checkpoints = module.findCheckpoints()
        
        if #checkpoints == 0 then
            if statusCallback then 
                statusCallback("❌ TIDAK ADA CHECKPOINT")
            end
            
            -- Restore humanoid state
            if humanoid then
                humanoid.PlatformStand = wasPlatformStand
            end
            return false
        end
        
        if statusCallback then 
            statusCallback("🎯 " .. #checkpoints .. " CHECKPOINT DITEMUKAN")
        end
        
        task.wait(1)
        
        -- Teleport ke tiap checkpoint
        for i, cp in ipairs(checkpoints) do
            if statusCallback then 
                statusCallback("📍 CHECKPOINT " .. i .. "/" .. #checkpoints)
            end
            
            print("Teleporting to checkpoint " .. i .. ": " .. cp.Name)
            
            -- Teleport dengan progress bar
            local success = module.teleportToCheckpoint(character, hrp, cp.Position)
            
            if not success then
                warn("Gagal teleport ke checkpoint " .. i)
                if statusCallback then 
                    statusCallback("⚠️ GAGAL CP " .. i)
                end
            end
            
            -- Delay antar checkpoint
            task.wait(0.5)
        end
        
        -- Tunggu di checkpoint terakhir
        if #checkpoints > 0 then
            local lastCp = checkpoints[#checkpoints]
            module.teleportToCheckpoint(character, hrp, lastCp.Position)
            
            task.wait(1)
            
            -- Restore humanoid state
            if humanoid then
                humanoid.PlatformStand = wasPlatformStand
            end
            
            if statusCallback then 
                statusCallback("🎉 SELESAI! " .. #checkpoints .. " CP")
            end
            
            print("Auto CP selesai! Total: " .. #checkpoints .. " checkpoint")
        end
        
        return true
    end)
    
    if not success then
        warn("Error in Auto CP:", err)
        if statusCallback then 
            statusCallback("❌ ERROR: " .. tostring(err))
        end
        return false
    end
    
    return true
end

return module