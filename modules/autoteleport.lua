-- Smart Teleport System
-- Safe teleport with anti-kick and collision handling

local module = {}

module.name = "autoteleport"
module.description = "Smart teleport system with anti-kick protection"

function module.toggle(state)
    -- This module is always active, toggle does nothing
    return true
end

function module.teleport(position, options)
    options = options or {}
    local character = module.Character
    local hrp = module.HumanoidRootPart
    
    if not character or not hrp then
        module.Logger.log("Cannot teleport: No character", "ERROR")
        return false
    end
    
    local originalPosition = hrp.Position
    local distance = (position - originalPosition).Magnitude
    
    module.Logger.log("Teleporting " .. math.floor(distance) .. " studs", "INFO")
    
    -- Determine method based on distance
    if distance < 100 then
        return module.instantTeleport(position)
    else
        return module.safeTeleport(position, options.steps or math.min(10, math.floor(distance / 50)))
    end
end

function module.instantTeleport(position)
    local hrp = module.HumanoidRootPart
    if not hrp then return false end
    
    -- Temporarily disable collision
    local parts = {}
    for _, part in ipairs(module.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(parts, part)
            part.CanCollide = false
        end
    end
    
    -- Teleport
    hrp.CFrame = CFrame.new(position + Vector3.new(0, 5, 0))
    
    -- Wait and restore collision
    task.wait(0.2)
    for _, part in ipairs(parts) do
        if part then
            part.CanCollide = true
        end
    end
    
    return true
end

function module.safeTeleport(position, steps)
    steps = steps or 10
    local hrp = module.HumanoidRootPart
    if not hrp then return false end
    
    local startPos = hrp.Position
    local success = true
    
    -- Disable collision
    local parts = {}
    for _, part in ipairs(module.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(parts, part)
            part.CanCollide = false
        end
    end
    
    -- Staged teleport
    for i = 1, steps do
        if not hrp or not hrp.Parent then break end
        
        local t = i / steps
        local lerpPos = startPos:Lerp(position, t)
        lerpPos = lerpPos + Vector3.new(0, 3, 0) -- Slight height
        
        hrp.CFrame = CFrame.new(lerpPos)
        task.wait(0.05)
    end
    
    -- Final position
    if hrp and hrp.Parent then
        hrp.CFrame = CFrame.new(position + Vector3.new(0, 5, 0))
    end
    
    -- Restore collision
    task.wait(0.3)
    for _, part in ipairs(parts) do
        if part and part.Parent then
            part.CanCollide = true
        end
    end
    
    return success
end

-- Teleport to player
function module.teleportToPlayer(playerName)
    local targetPlayer = nil
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Name:lower():find(playerName:lower()) then
            targetPlayer = player
            break
        end
    end
    
    if not targetPlayer or not targetPlayer.Character then
        module.Logger.log("Player not found: " .. playerName, "ERROR")
        return false
    end
    
    local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHrp then return false end
    
    return module.teleport(targetHrp.Position)
end

-- Teleport to coordinate
function module.teleportToCoordinate(x, y, z)
    return module.teleport(Vector3.new(x, y, z))
end

return module