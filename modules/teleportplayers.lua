-- Teleport Players Module
-- Dual mode: Player→Me or Me→Player

local module = {}

-- Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

-- State
local teleportMode = "playerToMe" -- "playerToMe" or "meToPlayer"
local selectedPlayers = {}
local lastTeleportTime = 0
local teleportCooldown = 2

-- Get all players (excluding self)
function module.getPlayers()
    local playerList = {}
    local localPlayer = Players.LocalPlayer
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(playerList, {
                Player = player,
                Name = player.Name,
                DisplayName = player.DisplayName,
                Character = player.Character,
                Distance = 0
            })
        end
    end
    
    -- Calculate distances
    local localChar = localPlayer.Character
    local localHrp = localChar and localChar:FindFirstChild("HumanoidRootPart")
    
    if localHrp then
        for _, data in ipairs(playerList) do
            local char = data.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                data.Distance = math.floor((localHrp.Position - hrp.Position).Magnitude)
                data.Position = hrp.Position
            else
                data.Distance = -1
            end
        end
    end
    
    -- Sort by distance
    table.sort(playerList, function(a, b)
        if a.Distance >= 0 and b.Distance >= 0 then
            return a.Distance < b.Distance
        end
        return a.Name < b.Name
    end)
    
    return playerList
end

-- Set teleport mode
function module.setMode(mode)
    if mode == "playerToMe" or mode == "meToPlayer" then
        teleportMode = mode
        print("[Teleport] Mode set to:", mode)
        return true
    end
    return false
end

-- Get current mode
function module.getMode()
    return teleportMode
end

-- Select/deselect player
function module.togglePlayer(playerName)
    if selectedPlayers[playerName] then
        selectedPlayers[playerName] = nil
        print("[Teleport] Deselected:", playerName)
        return false
    else
        selectedPlayers[playerName] = true
        print("[Teleport] Selected:", playerName)
        return true
    end
end

-- Get selected players
function module.getSelectedPlayers()
    local selected = {}
    for name in pairs(selectedPlayers) do
        table.insert(selected, name)
    end
    return selected
end

-- Clear selection
function module.clearSelection()
    selectedPlayers = {}
    print("[Teleport] Selection cleared")
end

-- Teleport player to me
function module.teleportPlayerToMe(playerName)
    local localPlayer = Players.LocalPlayer
    local targetPlayer = Players:FindFirstChild(playerName)
    
    if not targetPlayer then
        print("[Teleport] Player not found:", playerName)
        return false
    end
    
    local localChar = localPlayer.Character
    local targetChar = targetPlayer.Character
    
    if not localChar or not targetChar then
        print("[Teleport] Character not found")
        return false
    end
    
    local localHrp = localChar:FindFirstChild("HumanoidRootPart")
    local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
    
    if not localHrp or not targetHrp then
        print("[Teleport] HRP not found")
        return false
    end
    
    -- Check cooldown
    local now = tick()
    if now - lastTeleportTime < teleportCooldown then
        print("[Teleport] Cooldown active")
        return false
    end
    
    lastTeleportTime = now
    
    -- Safe teleport with bypass
    local function performTeleport()
        -- Save target collision states
        local collisionStates = {}
        for _, part in ipairs(targetChar:GetDescendants()) do
            if part:IsA("BasePart") then
                collisionStates[part] = part.CanCollide
                part.CanCollide = false
            end
        end
        
        -- Get teleport position (slightly offset)
        local offset = CFrame.new(0, 0, -4)
        targetHrp.CFrame = localHrp.CFrame * offset
        
        -- Restore collision
        task.wait(0.3)
        for part, canCollide in pairs(collisionStates) do
            if part then
                part.CanCollide = canCollide
            end
        end
        
        return true
    end
    
    local success, err = pcall(performTeleport)
    
    if success then
        print("[Teleport] Successfully teleported", playerName, "to you")
        return true
    else
        print("[Teleport] Failed:", err)
        return false
    end
end

-- Teleport me to player
function module.teleportMeToPlayer(playerName)
    local localPlayer = Players.LocalPlayer
    local targetPlayer = Players:FindFirstChild(playerName)
    
    if not targetPlayer then
        print("[Teleport] Player not found:", playerName)
        return false
    end
    
    local localChar = localPlayer.Character
    local targetChar = targetPlayer.Character
    
    if not localChar or not targetChar then
        print("[Teleport] Character not found")
        return false
    end
    
    local localHrp = localChar:FindFirstChild("HumanoidRootPart")
    local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
    
    if not localHrp or not targetHrp then
        print("[Teleport] HRP not found")
        return false
    end
    
    -- Check cooldown
    local now = tick()
    if now - lastTeleportTime < teleportCooldown then
        print("[Teleport] Cooldown active")
        return false
    end
    
    lastTeleportTime = now
    
    -- Safe teleport with bypass
    local function performTeleport()
        -- Save local collision states
        local collisionStates = {}
        for _, part in ipairs(localChar:GetDescendants()) do
            if part:IsA("BasePart") then
                collisionStates[part] = part.CanCollide
                part.CanCollide = false
            end
        end
        
        -- Staged teleport (anti-cheat bypass)
        local targetPos = targetHrp.Position + Vector3.new(0, 3, 0)
        local currentPos = localHrp.Position
        local steps = 6
        
        for i = 1, steps do
            local t = i / steps
            local interpPos = currentPos:Lerp(targetPos, t)
            localHrp.CFrame = CFrame.new(interpPos)
            task.wait(0.06)
        end
        
        -- Final position
        localHrp.CFrame = CFrame.new(targetPos)
        
        -- Restore collision
        task.wait(0.3)
        for part, canCollide in pairs(collisionStates) do
            if part then
                part.CanCollide = canCollide
            end
        end
        
        return true
    end
    
    local success, err = pcall(performTeleport)
    
    if success then
        print("[Teleport] Successfully teleported to", playerName)
        return true
    else
        print("[Teleport] Failed:", err)
        return false
    end
end

-- Execute teleport based on mode
function module.executeTeleport(callback)
    local selected = module.getSelectedPlayers()
    
    if #selected == 0 then
        if callback then callback("❌ No players selected") end
        return false
    end
    
    local successCount = 0
    
    for _, playerName in ipairs(selected) do
        local success = false
        
        if teleportMode == "playerToMe" then
            success = module.teleportPlayerToMe(playerName)
        else -- meToPlayer
            success = module.teleportMeToPlayer(playerName)
            
            -- If teleporting to player, only do first one
            break
        end
        
        if success then
            successCount = successCount + 1
            task.wait(0.5)
        end
    end
    
    local message = string.format("✅ Teleported %d players", successCount)
    if callback then callback(message) end
    
    return successCount > 0
end

-- Search players by name
function module.searchPlayers(searchTerm)
    local allPlayers = module.getPlayers()
    local results = {}
    
    searchTerm = searchTerm:lower()
    
    for _, playerData in ipairs(allPlayers) do
        if playerData.Name:lower():find(searchTerm) or
           playerData.DisplayName:lower():find(searchTerm) then
            table.insert(results, playerData)
        end
    end
    
    return results
end

return module