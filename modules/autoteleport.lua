-- Safe Teleport Module
-- Teleport with anti-cheat bypass

local module = {}

-- Staged teleport
function module.stagedTeleport(character, hrp, targetPosition)
    if not character or not hrp then
        return false
    end
    
    local currentPos = hrp.Position
    local distance = (targetPosition - currentPos).Magnitude
    
    -- If close, teleport directly
    if distance < 50 then
        hrp.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0))
        return true
    end
    
    -- Calculate steps
    local steps = math.min(8, math.floor(distance / 30))
    steps = math.max(3, steps)
    
    -- Disable collision
    local parts = {}
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(parts, part)
            part.CanCollide = false
        end
    end
    
    -- Staged teleport
    for i = 1, steps do
        local t = i / steps
        local interpPos = currentPos:Lerp(targetPosition, t)
        interpPos = interpPos + Vector3.new(0, 8, 0)
        
        hrp.CFrame = CFrame.new(interpPos)
        task.wait(0.06)
        
        if not character or not character.Parent then
            break
        end
    end
    
    -- Final position
    hrp.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0))
    
    -- Re-enable collision
    task.wait(0.2)
    for _, part in ipairs(parts) do
        if part then
            part.CanCollide = true
        end
    end
    
    return true
end

-- Safe teleport
function module.safeTeleport(character, hrp, targetPosition, callback)
    local success, err = pcall(function()
        if not character or not hrp then
            return false
        end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local wasPlatform = false
        
        if humanoid then
            wasPlatform = humanoid.PlatformStand
            humanoid.PlatformStand = true
        end
        
        local result = module.stagedTeleport(character, hrp, targetPosition)
        
        task.wait(0.3)
        
        if humanoid then
            humanoid.PlatformStand = wasPlatform
        end
        
        return result
    end)
    
    if callback then
        callback(success)
    end
    
    return success
end

-- Instant teleport (for carry)
function module.instantTeleport(character, hrp, targetPosition)
    if not character or not hrp then
        return false
    end
    
    hrp.CFrame = CFrame.new(targetPosition + Vector3.new(0, 3, 0))
    return true
end

return module