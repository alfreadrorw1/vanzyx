-- Auto Carry System
-- Automatically carry other players

local module = {}
local carrying = false
local carriedPlayer = nil
local weld = nil

module.name = "autocarry"
module.description = "Carry other players automatically"

function module.toggle(state)
    if state then
        return module.startCarry()
    else
        module.stopCarry()
        return false
    end
end

function module.startCarry(playerName)
    if carrying then
        module.Logger.log("Already carrying someone", "WARN")
        return false
    end
    
    -- Find target player
    local targetPlayer = nil
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Name:lower():find(playerName:lower()) or player.DisplayName:lower():find(playerName:lower()) then
            targetPlayer = player
            break
        end
    end
    
    if not targetPlayer or targetPlayer == module.Player then
        module.Logger.log("Player not found: " .. (playerName or "nil"), "ERROR")
        return false
    end
    
    -- Wait for characters
    if not targetPlayer.Character then
        module.Logger.log("Target player has no character", "ERROR")
        return false
    end
    
    local targetHrp = targetPlayer.Character:WaitForChild("HumanoidRootPart", 5)
    local myHrp = module.HumanoidRootPart
    
    if not targetHrp or not myHrp then
        module.Logger.log("Missing HumanoidRootPart", "ERROR")
        return false
    end
    
    -- Create weld
    weld = Instance.new("Weld")
    weld.Part0 = myHrp
    weld.Part1 = targetHrp
    weld.C0 = CFrame.new(0, 0, -2) -- Carry in front
    weld.Parent = myHrp
    
    carrying = true
    carriedPlayer = targetPlayer
    module.Logger.log("Now carrying: " .. targetPlayer.Name, "SUCCESS")
    
    -- Monitor if carried player leaves
    targetPlayer.CharacterRemoving:Connect(function()
        if carrying then
            module.stopCarry()
        end
    end)
    
    return true
end

function module.stopCarry()
    if weld then
        weld:Destroy()
        weld = nil
    end
    
    carrying = false
    carriedPlayer = nil
    module.Logger.log("Stopped carrying", "INFO")
end

function module.carryNearest()
    local closestPlayer = nil
    local closestDistance = math.huge
    local myPosition = module.HumanoidRootPart.Position
    
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= module.Player and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local distance = (hrp.Position - myPosition).Magnitude
                if distance < closestDistance and distance < 20 then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    if closestPlayer then
        return module.startCarry(closestPlayer.Name)
    else
        module.Logger.log("No players nearby to carry", "WARN")
        return false
    end
end

function module.getCarryStatus()
    return {
        carrying = carrying,
        player = carriedPlayer and carriedPlayer.Name or nil
    }
end

return module