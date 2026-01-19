-- Aimbot System
-- Auto-aim at nearest player

local module = {}
local aimbotEnabled = false
local aimConnection = nil
local targetPlayer = nil

module.name = "aimbot"
module.description = "Auto-aim at nearest player"

function module.toggle(state)
    aimbotEnabled = state
    
    if aimbotEnabled then
        module.enableAimbot()
    else
        module.disableAimbot()
    end
end

function module.enableAimbot()
    module.disableAimbot()
    
    aimConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if not aimbotEnabled or not module.Character then return end
        
        local myHrp = module.HumanoidRootPart
        if not myHrp then return end
        
        -- Find nearest player
        local nearestPlayer = nil
        local nearestDistance = math.huge
        
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= module.Player and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local distance = (hrp.Position - myHrp.Position).Magnitude
                    if distance < nearestDistance and distance < 100 then
                        nearestDistance = distance
                        nearestPlayer = player
                    end
                end
            end
        end
        
        if nearestPlayer and nearestPlayer.Character then
            local targetHrp = nearestPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHrp then
                -- Aim at target
                local cam = workspace.CurrentCamera
                if cam then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, targetHrp.Position)
                end
                targetPlayer = nearestPlayer
            end
        end
    end)
    
    module.Logger.log("Aimbot enabled", "SUCCESS")
end

function module.disableAimbot()
    if aimConnection then
        aimConnection:Disconnect()
        aimConnection = nil
    end
    targetPlayer = nil
    
    module.Logger.log("Aimbot disabled", "INFO")
end

function module.getTarget()
    return targetPlayer and targetPlayer.Name or nil
end

return module