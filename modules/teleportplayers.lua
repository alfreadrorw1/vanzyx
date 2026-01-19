--[[
    TELEPORT PLAYERS MODULE
    Dual Mode Teleport System
    Delta Executor
--]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- UI References
local PanelScroll = script.Parent.Parent.MainContainer.ContentContainer.RightPanel.PanelContent.PanelScroll

-- Variables
local TeleportMode = "ToPlayer" -- "ToPlayer" or "ToMe"
local SelectedPlayers = {}
local SearchText = ""

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
Title.Text = "PLAYER TELEPORT"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = PanelScroll

-- Mode Selector
local ModeContainer = Instance.new("Frame")
ModeContainer.Name = "ModeContainer"
ModeContainer.Size = UDim2.new(1, -40, 0, 60)
ModeContainer.Position = UDim2.new(0, 20, 0, 50)
ModeContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)

local ModeCorner = Instance.new("UICorner")
ModeCorner.CornerRadius = UDim.new(0, 10)
ModeCorner.Parent = ModeContainer

local ModeLabel = Instance.new("TextLabel")
ModeLabel.Name = "ModeLabel"
ModeLabel.Size = UDim2.new(0.3, 0, 1, 0)
ModeLabel.BackgroundTransparency = 1
ModeLabel.Text = "MODE:"
ModeLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
ModeLabel.TextSize = 16
ModeLabel.Font = Enum.Font.GothamBold
ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
ModeLabel.Parent = ModeContainer

-- Mode Buttons Container
local ModeButtons = Instance.new("Frame")
ModeButtons.Name = "ModeButtons"
ModeButtons.Size = UDim2.new(0.7, -10, 0.7, 0)
ModeButtons.Position = UDim2.new(0.3, 0, 0.15, 0)
ModeButtons.BackgroundTransparency = 1

-- To Player Button
local ToPlayerButton = Instance.new("TextButton")
ToPlayerButton.Name = "ToPlayerButton"
ToPlayerButton.Size = UDim2.new(0.48, 0, 1, 0)
ToPlayerButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToPlayerButton.Text = "ME → PLAYER"
ToPlayerButton.TextColor3 = Color3.white
ToPlayerButton.TextSize = 12
ToPlayerButton.Font = Enum.Font.GothamBold

local ToPlayerCorner = Instance.new("UICorner")
ToPlayerCorner.CornerRadius = UDim.new(0, 6)
ToPlayerCorner.Parent = ToPlayerButton

-- To Me Button
local ToMeButton = Instance.new("TextButton")
ToMeButton.Name = "ToMeButton"
ToMeButton.Size = UDim2.new(0.48, 0, 1, 0)
ToMeButton.Position = UDim2.new(0.52, 0, 0, 0)
ToMeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ToMeButton.Text = "PLAYER → ME"
ToMeButton.TextColor3 = Color3.fromRGB(180, 180, 200)
ToMeButton.TextSize = 12
ToMeButton.Font = Enum.Font.GothamBold

local ToMeCorner = Instance.new("UICorner")
ToMeCorner.CornerRadius = UDim.new(0, 6)
ToMeCorner.Parent = ToMeButton

-- Mode switching function
local function updateModeButtons()
    if TeleportMode == "ToPlayer" then
        ToPlayerButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        ToPlayerButton.TextColor3 = Color3.white
        ToMeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        ToMeButton.TextColor3 = Color3.fromRGB(180, 180, 200)
    else
        ToPlayerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        ToPlayerButton.TextColor3 = Color3.fromRGB(180, 180, 200)
        ToMeButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        ToMeButton.TextColor3 = Color3.white
    end
end

ToPlayerButton.MouseButton1Click:Connect(function()
    TeleportMode = "ToPlayer"
    updateModeButtons()
    print("[Teleport] Mode changed: ME → PLAYER")
end)

ToMeButton.MouseButton1Click:Connect(function()
    TeleportMode = "ToMe"
    updateModeButtons()
    print("[Teleport] Mode changed: PLAYER → ME")
end)

ToPlayerButton.Parent = ModeButtons
ToMeButton.Parent = ModeButtons
ModeButtons.Parent = ModeContainer
ModeContainer.Parent = PanelScroll

-- Search Container
local SearchContainer = Instance.new("Frame")
SearchContainer.Name = "SearchContainer"
SearchContainer.Size = UDim2.new(1, -40, 0, 50)
SearchContainer.Position = UDim2.new(0, 20, 0, 120)
SearchContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 10)
SearchCorner.Parent = SearchContainer

local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(0.7, -10, 0.7, 0)
SearchBox.Position = UDim2.new(0.02, 0, 0.15, 0)
SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SearchBox.TextColor3 = Color3.fromRGB(220, 220, 240)
SearchBox.PlaceholderText = "Search players..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
SearchBox.Text = ""
SearchBox.TextSize = 14
SearchBox.Font = Enum.Font.Gotham
SearchBox.ClearTextOnFocus = false

local SearchBoxCorner = Instance.new("UICorner")
SearchBoxCorner.CornerRadius = UDim.new(0, 6)
SearchBoxCorner.Parent = SearchBox

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    SearchText = SearchBox.Text:lower()
    refreshPlayersList()
end)

local SearchButton = Instance.new("TextButton")
SearchButton.Name = "SearchButton"
SearchButton.Size = UDim2.new(0.28, 0, 0.7, 0)
SearchButton.Position = UDim2.new(0.72, 0, 0.15, 0)
SearchButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SearchButton.Text = "SEARCH"
SearchButton.TextColor3 = Color3.white
SearchButton.TextSize = 12
SearchButton.Font = Enum.Font.GothamBold

local SearchButtonCorner = Instance.new("UICorner")
SearchButtonCorner.CornerRadius = UDim.new(0, 6)
SearchButtonCorner.Parent = SearchButton

SearchButton.MouseButton1Click:Connect(function()
    refreshPlayersList()
end)

SearchBox.Parent = SearchContainer
SearchButton.Parent = SearchContainer
SearchContainer.Parent = PanelScroll

-- Controls Container
local ControlsContainer = Instance.new("Frame")
ControlsContainer.Name = "ControlsContainer"
ControlsContainer.Size = UDim2.new(1, -40, 0, 50)
ControlsContainer.Position = UDim2.new(0, 20, 0, 180)
ControlsContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)

local ControlsCorner = Instance.new("UICorner")
ControlsCorner.CornerRadius = UDim.new(0, 10)
ControlsCorner.Parent = ControlsContainer

-- Select All Button
local SelectAllButton = Instance.new("TextButton")
SelectAllButton.Name = "SelectAllButton"
SelectAllButton.Size = UDim2.new(0.32, 0, 0.7, 0)
SelectAllButton.Position = UDim2.new(0.02, 0, 0.15, 0)
SelectAllButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SelectAllButton.Text = "SELECT ALL"
SelectAllButton.TextColor3 = Color3.white
SelectAllButton.TextSize = 12
SelectAllButton.Font = Enum.Font.GothamBold

local SelectAllCorner = Instance.new("UICorner")
SelectAllCorner.CornerRadius = UDim.new(0, 6)
SelectAllCorner.Parent = SelectAllButton

-- Deselect All Button
local DeselectAllButton = Instance.new("TextButton")
DeselectAllButton.Name = "DeselectAllButton"
DeselectAllButton.Size = UDim2.new(0.32, 0, 0.7, 0)
DeselectAllButton.Position = UDim2.new(0.34, 0, 0.15, 0)
DeselectAllButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
DeselectAllButton.Text = "DESELECT ALL"
DeselectAllButton.TextColor3 = Color3.fromRGB(200, 200, 220)
DeselectAllButton.TextSize = 12
DeselectAllButton.Font = Enum.Font.GothamBold

local DeselectAllCorner = Instance.new("UICorner")
DeselectAllCorner.CornerRadius = UDim.new(0, 6)
DeselectAllCorner.Parent = DeselectAllButton

-- Teleport Selected Button
local TeleportSelectedButton = Instance.new("TextButton")
TeleportSelectedButton.Name = "TeleportSelectedButton"
TeleportSelectedButton.Size = UDim2.new(0.32, 0, 0.7, 0)
TeleportSelectedButton.Position = UDim2.new(0.66, 0, 0.15, 0)
TeleportSelectedButton.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
TeleportSelectedButton.Text = "TELEPORT"
TeleportSelectedButton.TextColor3 = Color3.white
TeleportSelectedButton.TextSize = 12
TeleportSelectedButton.Font = Enum.Font.GothamBold

local TeleportSelectedCorner = Instance.new("UICorner")
TeleportSelectedCorner.CornerRadius = UDim.new(0, 6)
TeleportSelectedCorner.Parent = TeleportSelectedButton

SelectAllButton.Parent = ControlsContainer
DeselectAllButton.Parent = ControlsContainer
TeleportSelectedButton.Parent = ControlsContainer
ControlsContainer.Parent = PanelScroll

-- Players List Container
local PlayersContainer = Instance.new("Frame")
PlayersContainer.Name = "PlayersContainer"
PlayersContainer.Size = UDim2.new(1, -40, 0, 300)
PlayersContainer.Position = UDim2.new(0, 20, 0, 240)
PlayersContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
PlayersContainer.ClipsDescendants = true

local PlayersCorner = Instance.new("UICorner")
PlayersCorner.CornerRadius = UDim.new(0, 10)
PlayersCorner.Parent = PlayersContainer

-- Scrolling Frame for Players
local PlayersScroll = Instance.new("ScrollingFrame")
PlayersScroll.Name = "PlayersScroll"
PlayersScroll.Size = UDim2.new(1, -10, 1, -10)
PlayersScroll.Position = UDim2.new(0, 5, 0, 5)
PlayersScroll.BackgroundTransparency = 1
PlayersScroll.BorderSizePixel = 0
PlayersScroll.ScrollBarThickness = 6
PlayersScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)

local PlayersLayout = Instance.new("UIListLayout")
PlayersLayout.Padding = UDim.new(0, 8)
PlayersLayout.Parent = PlayersScroll

PlayersScroll.Parent = PlayersContainer
PlayersContainer.Parent = PanelScroll

-- Function to create player button
local function createPlayerButton(player)
    local Button = Instance.new("TextButton")
    Button.Name = "PlayerButton_" .. player.UserId
    Button.Size = UDim2.new(1, -10, 0, 60)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Button.Text = ""
    Button.AutoButtonColor = false
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    -- Player Avatar
    local Avatar = Instance.new("ImageLabel")
    Avatar.Name = "Avatar"
    Avatar.Size = UDim2.new(0, 40, 0, 40)
    Avatar.Position = UDim2.new(0, 10, 0.5, -20)
    Avatar.AnchorPoint = Vector2.new(0, 0.5)
    Avatar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png"
    
    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(0, 8)
    AvatarCorner.Parent = Avatar
    
    Avatar.Parent = Button
    
    -- Player Info
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "NameLabel"
    NameLabel.Size = UDim2.new(0.5, -60, 0.5, 0)
    NameLabel.Position = UDim2.new(0, 60, 0, 5)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = player.Name
    NameLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
    NameLabel.TextSize = 14
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    NameLabel.Parent = Button
    
    local DisplayLabel = Instance.new("TextLabel")
    DisplayLabel.Name = "DisplayLabel"
    DisplayLabel.Size = UDim2.new(0.5, -60, 0.5, 0)
    DisplayLabel.Position = UDim2.new(0, 60, 0.5, 0)
    DisplayLabel.BackgroundTransparency = 1
    DisplayLabel.Text = "@" .. player.DisplayName
    DisplayLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    DisplayLabel.TextSize = 12
    DisplayLabel.Font = Enum.Font.Gotham
    DisplayLabel.TextXAlignment = Enum.TextXAlignment.Left
    DisplayLabel.TextTruncate = Enum.TextTruncate.AtEnd
    DisplayLabel.Parent = Button
    
    -- Selection Checkbox
    local Checkbox = Instance.new("TextButton")
    Checkbox.Name = "Checkbox"
    Checkbox.Size = UDim2.new(0, 24, 0, 24)
    Checkbox.Position = UDim2.new(0.85, -12, 0.5, -12)
    Checkbox.AnchorPoint = Vector2.new(0.5, 0.5)
    Checkbox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    Checkbox.Text = ""
    Checkbox.AutoButtonColor = false
    
    local CheckboxCorner = Instance.new("UICorner")
    CheckboxCorner.CornerRadius = UDim.new(0, 4)
    CheckboxCorner.Parent = Checkbox
    
    local CheckIcon = Instance.new("ImageLabel")
    CheckIcon.Name = "CheckIcon"
    CheckIcon.Size = UDim2.new(0, 16, 0, 16)
    CheckIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
    CheckIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    CheckIcon.BackgroundTransparency = 1
    CheckIcon.Image = "rbxassetid://10734980055"
    CheckIcon.ImageColor3 = Color3.fromRGB(0, 170, 255)
    CheckIcon.Visible = false
    CheckIcon.Parent = Checkbox
    
    -- Toggle selection
    Checkbox.MouseButton1Click:Connect(function()
        if SelectedPlayers[player] then
            SelectedPlayers[player] = nil
            CheckIcon.Visible = false
            Checkbox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        else
            SelectedPlayers[player] = true
            CheckIcon.Visible = true
            Checkbox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        end
    end)
    
    Checkbox.Parent = Button
    
    -- Teleport Button (Single)
    local TeleportBtn = Instance.new("TextButton")
    TeleportBtn.Name = "TeleportBtn"
    TeleportBtn.Size = UDim2.new(0, 60, 0, 30)
    TeleportBtn.Position = UDim2.new(0.7, 10, 0.5, -15)
    TeleportBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TeleportBtn.Text = "TP"
    TeleportBtn.TextColor3 = Color3.white
    TeleportBtn.TextSize = 12
    TeleportBtn.Font = Enum.Font.GothamBold
    
    local TeleportCorner = Instance.new("UICorner")
    TeleportCorner.CornerRadius = UDim.new(0, 6)
    TeleportCorner.Parent = TeleportBtn
    
    TeleportBtn.MouseButton1Click:Connect(function()
        teleportPlayer(player)
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
    
    return Button
end

-- Function to refresh players list
local function refreshPlayersList()
    -- Clear existing buttons
    for _, child in ipairs(PlayersScroll:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    
    -- Get and sort players
    local players = Players:GetPlayers()
    table.sort(players, function(a, b)
        return a.Name:lower() < b.Name:lower()
    end)
    
    -- Filter by search text
    local filteredPlayers = {}
    for _, player in ipairs(players) do
        if player ~= LocalPlayer then
            if SearchText == "" or player.Name:lower():find(SearchText) or player.DisplayName:lower():find(SearchText) then
                table.insert(filteredPlayers, player)
            end
        end
    end
    
    -- Create buttons for filtered players
    for _, player in ipairs(filteredPlayers) do
        local button = createPlayerButton(player)
        button.Parent = PlayersScroll
    end
    
    -- Update scroll size
    PlayersScroll.CanvasSize = UDim2.new(0, 0, 0, PlayersLayout.AbsoluteContentSize.Y + 20)
end

-- Function to teleport player
local function teleportPlayer(player)
    local targetChar = player.Character
    local myChar = LocalPlayer.Character
    
    if not targetChar or not myChar then return end
    
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    
    if not targetHRP or not myHRP then return end
    
    if TeleportMode == "ToPlayer" then
        -- Teleport me to player
        myHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
        print("[Teleport] Teleported to: " .. player.Name)
    else
        -- Teleport player to me
        targetHRP.CFrame = myHRP.CFrame + Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
        print("[Teleport] Teleported " .. player.Name .. " to you")
    end
end

-- Control Button Functions
SelectAllButton.MouseButton1Click:Connect(function()
    SelectedPlayers = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            SelectedPlayers[player] = true
        end
    end
    refreshPlayersList()
    print("[Teleport] Selected all players")
end)

DeselectAllButton.MouseButton1Click:Connect(function()
    SelectedPlayers = {}
    refreshPlayersList()
    print("[Teleport] Deselected all players")
end)

TeleportSelectedButton.MouseButton1Click:Connect(function()
    for player, _ in pairs(SelectedPlayers) do
        teleportPlayer(player)
        wait(0.1) -- Small delay to prevent issues
    end
    print("[Teleport] Teleported " .. #SelectedPlayers .. " players")
end)

-- Player added/removed events
Players.PlayerAdded:Connect(function(player)
    wait(1) -- Wait for player to load
    refreshPlayersList()
end)

Players.PlayerRemoving:Connect(function(player)
    SelectedPlayers[player] = nil
    refreshPlayersList()
end)

-- Initial refresh
refreshPlayersList()

print("[Teleport Players] Module Loaded Successfully!")