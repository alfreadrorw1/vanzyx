-- Auto Teleport All Players Module
-- Teleport semua pemain yang sedang bermain langsung ke spawn pertama

local module = {}

-- Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

-- Player
local plr = Players.LocalPlayer

-- Module state
local active = false
local teleportConnections = {}
local teleportedPlayers = {}

-- Temukan posisi spawn pertama
local function findFirstSpawn()
    -- Method 1: Cari SpawnLocation
    local spawns = {}
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("SpawnLocation") then
            table.insert(spawns, {
                Object = obj,
                Position = obj.Position,
                Name = obj.Name
            })
        end
    end
    
    -- Method 2: Cari part dengan nama spawn
    if #spawns == 0 then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("spawn") or obj.Name:lower():find("start")) then
                table.insert(spawns, {
                    Object = obj,
                    Position = obj.Position,
                    Name = obj.Name
                })
            end
        end
    end
    
    -- Method 3: Cari folder SpawnPoints
    if #spawns == 0 then
        local spawnFolder = workspace:FindFirstChild("SpawnPoints") or workspace:FindFirstChild("Spawns")
        if spawnFolder then
            for _, obj in ipairs(spawnFolder:GetDescendants()) do
                if obj:IsA("BasePart") then
                    table.insert(spawns, {
                        Object = obj,
                        Position = obj.Position,
                        Name = obj.Name
                    })
                end
            end
        end
    end
    
    -- Method 4: Cari area default spawn
    if #spawns == 0 then
        -- Cari area dengan banyak player spawn (biasanya di koordinat tertentu)
        local possibleSpawns = {
            Vector3.new(0, 5, 0),
            Vector3.new(0, 10, 0),
            Vector3.new(0, 15, 0),
            Vector3.new(50, 5, 0),
            Vector3.new(-50, 5, 0),
            Vector3.new(0, 5, 50),
            Vector3.new(0, 5, -50)
        }
        
        for i, pos in ipairs(possibleSpawns) do
            table.insert(spawns, {
                Object = nil,
                Position = pos,
                Name = "DefaultSpawn_" .. i
            })
        end
    end
    
    -- Urutkan spawn (biasanya SpawnLocation1, SpawnLocation2, dll)
    table.sort(spawns, function(a, b)
        -- Coba ekstrak angka dari nama
        local numA = tonumber(string.match(a.Name, "%d+")) or 999
        local numB = tonumber(string.match(b.Name, "%d+")) or 999
        
        return numA < numB
    end)
    
    -- Return spawn pertama
    if #spawns > 0 then
        warn("Found spawn position: " .. spawns[1].Name)
        return spawns[1].Position
    end
    
    -- Fallback: posisi default
    warn("No spawn found, using default position")
    return Vector3.new(0, 100, 0)
end

-- Function untuk teleport player dengan aman
local function teleportPlayer(targetPlayer, position)
    if targetPlayer == plr then
        -- Teleport diri sendiri
        coroutine.wrap(function()
            local character = targetPlayer.Character
            if not character then
                character = targetPlayer.CharacterAdded:Wait()
            end
            
            local hrp = character:WaitForChild("HumanoidRootPart")
            if hrp then
                -- Gunakan CFrame untuk menghindari collision
                hrp.CFrame = CFrame.new(position + Vector3.new(0, 5, 0))
                
                -- Tunggu sebentar untuk memastikan teleport selesai
                task.wait(0.5)
                
                -- Adjust position jika terhalang
                hrp.CFrame = CFrame.new(position + Vector3.new(0, 10, 0))
                
                warn("Teleported self to spawn")
            end
        end)()
    else
        -- Teleport player lain menggunakan RemoteEvent atau langsung
        coroutine.wrap(function()
            local success, errorMsg = pcall(function()
                -- Coba gunakan TeleportService jika memungkinkan
                -- Fallback ke metode lain jika tidak berhasil
                
                local character = targetPlayer.Character
                if not character then
                    character = targetPlayer.CharacterAdded:Wait()
                end
                
                local hrp = character:WaitForChild("HumanoidRootPart")
                if hrp then
                    -- Method 1: Direct teleport (server-side mungkin diperlukan)
                    hrp.CFrame = CFrame.new(position + Vector3.new(math.random(-5, 5), 10, math.random(-5, 5)))
                    
                    warn("Teleported player: " .. targetPlayer.Name)
                end
            end)
            
            if not success then
                warn("Failed to teleport " .. targetPlayer.Name .. ": " .. errorMsg)
            end
        end)()
    end
end

-- Teleport semua pemain ke spawn
local function teleportAllPlayers()
    local spawnPosition = findFirstSpawn()
    warn("Spawning all players at: " .. tostring(spawnPosition))
    
    -- Teleport diri sendiri terlebih dahulu
    teleportPlayer(plr, spawnPosition)
    
    -- Teleport semua player lain
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= plr then
            teleportedPlayers[player] = true
            
            -- Beri jeda antar teleport untuk menghindari lag
            task.wait(0.3)
            teleportPlayer(player, spawnPosition)
        end
    end
    
    warn("All players teleported to spawn!")
end

-- Mulai auto-teleport
local function startAutoTeleport()
    teleportAllPlayers()
    
    -- Teleport pemain baru yang join
    local playerAddedConnection
    playerAddedConnection = Players.PlayerAdded:Connect(function(player)
        task.wait(2) -- Tunggu player load
        
        if active then
            teleportedPlayers[player] = true
            
            local spawnPosition = findFirstSpawn()
            teleportPlayer(player, spawnPosition)
            
            warn("Teleported new player: " .. player.Name)
        end
    end)
    
    table.insert(teleportConnections, playerAddedConnection)
    
    -- Periodic teleport (jika ada player yang escape)
    local periodicCheckConnection
    periodicCheckConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if active then
            -- Check setiap 10 detik
            if tick() % 10 < 0.1 then
                for _, player in ipairs(Players:GetPlayers()) do
                    if not teleportedPlayers[player] then
                        local spawnPosition = findFirstSpawn()
                        teleportPlayer(player, spawnPosition)
                        teleportedPlayers[player] = true
                    end
                end
            end
        end
    end)
    
    table.insert(teleportConnections, periodicCheckConnection)
end

-- Hentikan teleport
local function stopAutoTeleport()
    teleportedPlayers = {}
    
    for _, conn in ipairs(teleportConnections) do
        conn:Disconnect()
    end
    teleportConnections = {}
end

-- Main function
function module.start()
    if active then 
        warn("Teleport module already active!")
        return 
    end
    
    active = true
    warn("Starting auto-teleport all players to spawn...")
    
    startAutoTeleport()
    
    return {
        stop = function()
            module.stop()
        end
    }
end

function module.stop()
    active = false
    stopAutoTeleport()
    warn("Teleport module stopped")
end

-- Function untuk teleport sekali saja
function module.teleportOnce()
    warn("One-time teleport all players to spawn...")
    teleportAllPlayers()
end

-- Function untuk mendapatkan status spawn
function module.getSpawnInfo()
    local spawnPosition = findFirstSpawn()
    return {
        spawnPosition = spawnPosition,
        active = active,
        teleportedCount = table.count(teleportedPlayers)
    }
end

return module