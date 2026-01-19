-- ESP System
-- Visual boxes around players

local module = {}
local espEnabled = false
local espBoxes = {}

module.name = "esp"
module.description = "Visual ESP for players"

function module.toggle(state)
    espEnabled = state
    
    if espEnabled then
        module.createESP()
    else
        module.clearESP()
    end
end

function module.createESP()
    module.clearESP()
    
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= module.Player then
            module.createESPBox(player)
        end
    end
    
    -- Listen for new players
    game.Players.PlayerAdded:Connect(function(player)
        if espEnabled then
            module.createESPBox(player)
        end
    end)
    
    -- Listen for player leaving
    game.Players.PlayerRemoving:Connect(function(player)
        if espBoxes[player] then
            espBoxes[player]:Destroy()
            espBoxes[player] = nil
        end
    end)
    
    module.Logger.log("ESP enabled", "SUCCESS")
end

function module.createESPBox(player)
    if espBoxes[player] then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESP_" .. player.Name
    box.Adornee = nil
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, 6, 4)
    box.Color3 = player.Team and player.Team.Color or Color3.fromRGB(255, 0, 0)
    box.Transparency = 0.7
    box.Parent = workspace
    
    espBoxes[player] = box
    
    -- Update position
    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        if not espEnabled or not player or not player.Character then
            if connection then connection:Disconnect() end
            box:Destroy()
            espBoxes[player] = nil
            return
        end
        
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            box.Adornee = hrp
        end
    end)
end

function module.clearESP()
    for player, box in pairs(espBoxes) do
        if box then
            box:Destroy()
        end
    end
    espBoxes = {}
    
    module.Logger.log("ESP cleared", "INFO")
end

function module.setColor(player, color)
    if espBoxes[player] then
        espBoxes[player].Color3 = color
    end
end

return module