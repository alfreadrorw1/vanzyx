-- Speed Hack System
-- Increase movement speed

local module = {}
local speedEnabled = false
local originalWalkSpeed = 16
local speedMultiplier = 3

module.name = "speed"
module.description = "Increase movement speed"

function module.toggle(state)
    speedEnabled = state
    
    if speedEnabled then
        module.enableSpeed()
    else
        module.disableSpeed()
    end
end

function module.enableSpeed()
    if not module.Humanoid then return end
    
    originalWalkSpeed = module.Humanoid.WalkSpeed
    module.Humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
    
    module.Logger.log("Speed enabled: " .. module.Humanoid.WalkSpeed .. " studs/s", "SUCCESS")
end

function module.disableSpeed()
    if module.Humanoid then
        module.Humanoid.WalkSpeed = originalWalkSpeed
    end
    
    module.Logger.log("Speed disabled", "INFO")
end

function module.setMultiplier(mult)
    speedMultiplier = math.clamp(mult, 1, 10)
    
    if speedEnabled and module.Humanoid then
        module.Humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
    end
    
    module.Logger.log("Speed multiplier set to: " .. speedMultiplier, "INFO")
end

-- Character respawn handler
function module.onCharacterAdded(newChar)
    local humanoid = newChar:WaitForChild("Humanoid")
    if speedEnabled then
        originalWalkSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
    end
end

return module