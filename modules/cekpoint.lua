--[[
    CHECKPOINT SELECTOR MODULE
    Delta Executor
--]]

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- UI References
local PanelScroll = script.Parent.Parent.MainContainer.ContentContainer.RightPanel.PanelContent.PanelScroll

-- Checkpoint Variables
local Checkpoints = {}
local CheckpointButtons = {}

-- Clear panel
for _, child in ipairs(PanelScroll:GetChildren()) do
    if child:IsA("GuiObject") then
        child:Destroy()
    end
end

-- Create Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "CHECKPOINT SELECTOR"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = PanelScroll

-- Info Label
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Name = "InfoLabel"
InfoLabel.Size = UDim2.new(1, -40, 0, 60)
InfoLabel.Position = UDim2.new(0, 20, 0, 50)
InfoLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
InfoLabel.TextSize = 14
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextXAlignment = Enum.TextXAlignment.Center
InfoLabel.TextWrapped = true
InfoLabel.Text = "Auto-detecting checkpoints...\nLooking for parts named: checkpoint, cp, stage"

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 10)
InfoCorner.Parent = InfoLabel

InfoLabel.Parent = PanelScroll

-- Controls Container
local ControlsContainer = Instance.new("Frame")
ControlsContainer.Name = "ControlsContainer"
ControlsContainer.Size = UDim2.new(1, -40, 0, 50)
ControlsContainer.Position = UDim2.new(0, 20, 0, 120)
ControlsContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)

local ControlsCorner = Instance.new("UICorner")
ControlsCorner.CornerRadius = UDim.new(0, 10)
ControlsCorner.Parent = ControlsContainer

-- Refresh Button
local RefreshButton = Instance.new("TextButton")
RefreshButton.Name = "RefreshButton"
RefreshButton.Size = UDim2.new(0.48, 0, 0.8, 0)
RefreshButton.Position = UDim2.new(0.02, 0, 0.1, 0)
RefreshButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
RefreshButton.Text = "🔄 REFRESH"
RefreshButton.TextColor3 = Color3.white
RefreshButton.TextSize = 14
RefreshButton.Font = Enum.Font.GothamBold

local RefreshCorner = Instance.new("UICorner")
RefreshCorner.CornerRadius = UDim.new(0, 8)
RefreshCorner.Parent = RefreshButton

-- Teleport All Button
local TeleportAllButton = Instance.new("TextButton")
TeleportAllButton.Name = "TeleportAllButton"
TeleportAllButton.Size = UDim2.new(0.48, 0, 0.8, 0)
TeleportAllButton.Position = UDim2.new(0.5, 0, 0.1, 0)
TeleportAllButton.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
TeleportAllButton.Text = "TELEPORT ALL"
TeleportAllButton.TextColor3 = Color3.white
TeleportAllButton.TextSize = 14
TeleportAllButton.Font = Enum.Font.GothamBold

local TeleportAllCorner = Instance.new("UICorner")
TeleportAllCorner.CornerRadius = UDim.new(0, 8)
TeleportAllCorner.Parent = TeleportAllButton

RefreshButton.Parent = ControlsContainer
TeleportAllButton.Parent = ControlsContainer
ControlsContainer.Parent = PanelScroll

-- Checkpoints List Container
local ListContainer = Instance.new("Frame")
ListContainer.Name = "ListContainer"
ListContainer.Size = UDim2.new(1, -40, 0, 300)
ListContainer.Position = UDim2.new(0, 20, 0, 180)
ListContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ListContainer.ClipsDescendants = true

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 10)
ListCorner.Parent = ListContainer

-- Scrolling Frame for Checkpoints
local CheckpointsScroll = Instance.new("ScrollingFrame")
CheckpointsScroll.Name = "CheckpointsScroll"
CheckpointsScroll.Size = UDim2.new(1, -10, 1, -10)
CheckpointsScroll.Position = UDim2.new(0, 5, 0, 5)
CheckpointsScroll.BackgroundTransparency = 1
CheckpointsScroll.BorderSizePixel = 0
CheckpointsScroll.ScrollBarThickness = 6
CheckpointsScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)

local CheckpointsLayout = Instance.new("UIListLayout")
CheckpointsLayout.Padding = UDim.new(0, 8)
CheckpointsLayout.Parent = CheckpointsScroll

CheckpointsScroll.Parent = ListContainer
ListContainer.Parent = PanelScroll

-- Function to find checkpoints
local function findCheckpoints()
    Checkpoints = {}
    CheckpointButtons = {}
    
    -- Clear existing buttons
    for _, child in ipairs(CheckpointsScroll:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    
    -- Search in workspace
    local function searchInModel(model)
        for _, obj in ipairs(model:GetDescendants()) do
            if obj:IsA("BasePart") then
                local name = obj.Name:lower()
                if name:find("checkpoint") or name:find("cp") or name:find("stage") or name:find("point") then
                    table.insert(Checkpoints, {
                        Part = obj,
                        Name = obj.Name,
                        Position = obj.Position,
                        Parent = obj.Parent.Name
                    })
                end
            end
        end
    end
    
    -- Search in main workspace
    searchInModel(Workspace)
    
    -- Search in any "Checkpoints" folder
    local checkpointsFolder = Workspace:FindFirstChild("Checkpoints")
    if checkpointsFolder then
        searchInModel(checkpointsFolder)
    end
    
    -- Update info label
    InfoLabel.Text = string.format("Found %d checkpoints", #Checkpoints)
    
    -- Create buttons for each checkpoint
    for i, checkpoint in ipairs(Checkpoints) do
        local Button = Instance.new("TextButton")
        Button.Name = "CheckpointButton_" .. i
        Button.Size = UDim2.new(1, -10, 0, 50)
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        Button.Text = ""
        Button.AutoButtonColor = false
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = Button
        
        -- Number Badge
        local NumberBadge = Instance.new("Frame")
        NumberBadge.Name = "NumberBadge"
        NumberBadge.Size = UDim2.new(0, 30, 0, 30)
        NumberBadge.Position = UDim2.new(0, 10, 0.5, -15)
        NumberBadge.AnchorPoint = Vector2.new(0, 0.5)
        NumberBadge.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        
        local NumberCorner = Instance.new("UICorner")
        NumberCorner.CornerRadius = UDim.new(0, 6)
        NumberCorner.Parent = NumberBadge
        
        local NumberText = Instance.new("TextLabel")
        NumberText.Name = "NumberText"
        NumberText.Size = UDim2.new(1, 0, 1, 0)
        NumberText.BackgroundTransparency = 1
        NumberText.Text = tostring(i)
        NumberText.TextColor3 = Color3.white
        NumberText.TextSize = 14
        NumberText.Font = Enum.Font.GothamBold
        NumberText.Parent = NumberBadge
        
        NumberBadge.Parent = Button
        
        -- Checkpoint Info
        local NameLabel = Instance.new("TextLabel")
        NameLabel.Name = "NameLabel"
        NameLabel.Size = UDim2.new(0.7, -50, 0.5, 0)
        NameLabel.Position = UDim2.new(0, 50, 0, 5)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Text = checkpoint.Name
        NameLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
        NameLabel.TextSize = 14
        NameLabel.Font = Enum.Font.GothamBold
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        NameLabel.Parent = Button
        
        local ParentLabel = Instance.new("TextLabel")
        ParentLabel.Name = "ParentLabel"
        ParentLabel.Size = UDim2.new(0.7, -50, 0.5, 0)
        ParentLabel.Position = UDim2.new(0, 50, 0.5, 0)
        ParentLabel.BackgroundTransparency = 1
        ParentLabel.Text = "in " .. checkpoint.Parent
        ParentLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
        ParentLabel.TextSize = 12
        ParentLabel.Font = Enum.Font.Gotham
        ParentLabel.TextXAlignment = Enum.TextXAlignment.Left
        ParentLabel.TextTruncate = Enum.TextTruncate.AtEnd
        ParentLabel.Parent = Button
        
        -- Teleport Button
        local TeleportBtn = Instance.new("TextButton")
        TeleportBtn.Name = "TeleportBtn"
        TeleportBtn.Size = UDim2.new(0.25, 0, 0.7, 0)
        TeleportBtn.Position = UDim2.new(0.75, 5, 0.15, 0)
        TeleportBtn.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
        TeleportBtn.Text = "TP"
        TeleportBtn.TextColor3 = Color3.white
        TeleportBtn.TextSize = 12
        TeleportBtn.Font = Enum.Font.GothamBold
        
        local TeleportCorner = Instance.new("UICorner")
        TeleportCorner.CornerRadius = UDim.new(0, 6)
        TeleportCorner.Parent = TeleportBtn
        
        TeleportBtn.MouseButton1Click:Connect(function()
            if Character and HumanoidRootPart then
                local targetCFrame = CFrame.new(checkpoint.Position + Vector3.new(0, 5, 0))
                HumanoidRootPart.CFrame = targetCFrame
                print("[Checkpoint] Teleported to: " .. checkpoint.Name)
            end
        end)
        
        TeleportBtn.Parent = Button
        
        -- Button hover effects
        Button.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            }):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            }):Play()
        end)
        
        Button.Parent = CheckpointsScroll
        CheckpointButtons[i] = Button
    end
    
    -- Update scroll size
    CheckpointsScroll.CanvasSize = UDim2.new(0, 0, 0, CheckpointsLayout.AbsoluteContentSize.Y + 20)
end

-- Refresh Button Click
RefreshButton.MouseButton1Click:Connect(function()
    findCheckpoints()
    print("[Checkpoint] Refreshed checkpoints list")
end)

-- Teleport All Button Click
TeleportAllButton.MouseButton1Click:Connect(function()
    if Character and HumanoidRootPart then
        local players = Players:GetPlayers()
        local myPosition = HumanoidRootPart.Position
        
        for _, player in ipairs(players) do
            if player ~= LocalPlayer then
                local char = player.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = CFrame.new(myPosition + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)))
                    end
                end
            end
        end
        print("[Checkpoint] Teleported all players to you")
    end
end)

-- Initial scan
findCheckpoints()

print("[Checkpoint] Module Loaded Successfully!")