local CPPage = _G.AddMenuBtn("CP", Vector2.new(124, 524))
local UIList = Instance.new("UIListLayout", CPPage)
UIList.Padding = UDim.new(0, 5)

local GridBox = Instance.new("Frame", CPPage)
GridBox.Size = UDim2.new(1, -5, 0, 100)
GridBox.BackgroundTransparency = 1
local Grid = Instance.new("UIGridLayout", GridBox)
Grid.CellSize = UDim2.new(0, 35, 0, 35)

local ScanBtn = Instance.new("TextButton", CPPage)
ScanBtn.Size = UDim2.new(1, -5, 0, 30)
ScanBtn.Text = "SCAN STAGES"
ScanBtn.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
ScanBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", ScanBtn)

ScanBtn.MouseButton1Click:Connect(function()
    for _, c in pairs(GridBox:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    
    local stages = {}
    for _, v in pairs(workspace:GetDescendants()) do
        local num = tonumber(v.Name:match("%d+"))
        if num and (v.Name:lower():find("stage") or v.Name:lower():find("checkpoint")) then
            table.insert(stages, {part = v, n = num})
        end
    end
    table.sort(stages, function(a,b) return a.n < b.n end)

    for _, data in ipairs(stages) do
        local b = Instance.new("TextButton", GridBox)
        b.Text = tostring(data.n)
        b.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        b.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = data.part.CFrame + Vector3.new(0,3,0)
        end)
    end
end)
