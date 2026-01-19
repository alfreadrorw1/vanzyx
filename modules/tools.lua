-- Extra Tools Module
-- Various utility functions

local module = {}

module.name = "tools"
module.description = "Various utility tools"

function module.toggle(state)
    -- This module doesn't have a simple toggle
    return true
end

-- Bring all players to you
function module.bringAllPlayers()
    local myPosition = module.HumanoidRootPart.Position
    
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= module.Player and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(myPosition + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)))
            end
        end
    end
    
    module.Logger.log("Brought all players", "SUCCESS")
end

-- Kick all players (requires server access)
function module.kickAllPlayers()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= module.Player then
            player:Kick("Vanzyxxx Script")
        end
    end
    module.Logger.log("Kicked all players", "INFO")
end

-- Server hop
function module.serverHop()
    local servers = {}
    
    local success, result = pcall(function()
        local response = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100")
        local data = game:GetService("HttpService"):JSONDecode(response)
        servers = data.data
    end)
    
    if success and #servers > 0 then
        local randomServer = servers[math.random(1, #servers)]
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, randomServer.id, module.Player)
    else
        module.Logger.log("Failed to get servers", "ERROR")
    end
end

-- Rejoin server
function module.rejoin()
    game:GetService("TeleportService"):Teleport(game.PlaceId, module.Player)
end

-- Infinite jump
function module.infiniteJump(toggle)
    if toggle then
        module.UserInputService.JumpRequest:Connect(function()
            if module.Humanoid then
                module.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        module.Logger.log("Infinite jump enabled", "SUCCESS")
    else
        module.Logger.log("Infinite jump feature", "INFO")
    end
end

-- X-Ray vision
function module.xray(toggle)
    if toggle then
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency < 0.5 then
                part.Transparency = 0.5
            end
        end
        module.Logger.log("X-Ray enabled", "SUCCESS")
    else
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency == 0.5 then
                part.Transparency = 0
            end
        end
        module.Logger.log("X-Ray disabled", "INFO")
    end
end

return module