local Page = _G.AddMenuBtn("Checkpoint", Vector2.new(124, 524))
Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

local Scan = Instance.new("TextButton", Page)
Scan.Size = UDim2.new(1, -10, 0, 35)
Scan.BackgroundColor3 = _G.Theme.Accent
Scan.Text = "SCAN ALL STAGES"
Scan.TextColor3 = _G.Theme.Text
Scan.Font = Enum.Font.GothamBold
Instance.new("UICorner", Scan)

local Grid = Instance.new("Frame", Page)
Grid.Size = UDim2.new(1, 0, 0, 0)
Grid.BackgroundTransparency = 1
Grid.AutomaticSize = Enum.AutomaticSize.Y
local UIGrid = Instance.new("UIGridLayout", Grid)
UIGrid.CellSize = UDim2.new(0, 40, 0, 40)

Scan.MouseButton1Click:Connect(function()
    for _, v in pairs(Grid:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for i = 1, 50 do -- Contoh simulasi scan
        local b = Instance.new("TextButton", Grid)
        b.Text = tostring(i)
        b.BackgroundColor3 = _G.Theme.Secondary
        b.TextColor3 = _G.Theme.Text
        Instance.new("UICorner", b)
    end
end)
