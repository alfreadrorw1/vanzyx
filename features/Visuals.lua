local Tab = Window:Tab("Visuals")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local ESP_State = false

Tab:Toggle("ESP Player", function(state)
    ESP_State = state
    
    -- Loop updater
    spawn(function()
        while ESP_State do
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= Players.LocalPlayer and plr.Character then
                    if not plr.Character:FindFirstChild("Highlight") then
                        local hl = Instance.new("Highlight")
                        hl.FillColor = Color3.fromRGB(255,0,0)
                        hl.OutlineColor = Color3.fromRGB(255,255,255)
                        hl.Parent = plr.Character
                    end
                end
            end
            wait(1)
            -- Cleanup jika ESP dimatikan loop berikutnya
            if not ESP_State then
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr.Character and plr.Character:FindFirstChild("Highlight") then
                        plr.Character.Highlight:Destroy()
                    end
                end
            end
        end
    end)
    
    -- Instant cleanup off
    if not state then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Highlight") then
                plr.Character.Highlight:Destroy()
            end
        end
    end
end)

Tab:Toggle("Full Bright", function(state)
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 10000
    end
end)
