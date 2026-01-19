local SpeedPage = _G.AddMenuBtn("Speed", Vector2.new(844, 444))
local SpeedEnabled = false

local Toggle = Instance.new("TextButton", SpeedPage)
Toggle.Size = UDim2.new(1, -5, 0, 40)
Toggle.Text = "SPEED 500x: OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Toggle)

Toggle.MouseButton1Click:Connect(function()
    SpeedEnabled = not SpeedEnabled
    Toggle.Text = SpeedEnabled and "SPEED 500x: ON" or "SPEED 500x: OFF"
    Toggle.BackgroundColor3 = SpeedEnabled and Color3.fromRGB(140, 0, 255) or Color3.fromRGB(40, 40, 50)
    
    task.spawn(function()
        while SpeedEnabled do
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 500
            end
            task.wait(0.1)
        end
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end)
end)
