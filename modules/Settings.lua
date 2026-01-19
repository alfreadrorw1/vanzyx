local Page = _G.AddMenuBtn("Settings", Vector2.new(464, 324))
Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

local function CreateColorOption(name, color)
    local btn = Instance.new("TextButton", Page)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = color
    btn.Text = "Set Theme: " .. name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G.Theme.Accent = color
        -- Update UI yang sudah ada
        MainStroke.Color = color
        TitleLabel.TextColor3 = color
        MiniLogo.BackgroundColor3 = color
    end)
end

CreateColorOption("V-Purple", Color3.fromRGB(140, 0, 255))
CreateColorOption("Fire-Red", Color3.fromRGB(255, 50, 50))
CreateColorOption("Ocean-Blue", Color3.fromRGB(0, 150, 255))
CreateColorOption("Nature-Green", Color3.fromRGB(0, 200, 100))
