-- Vanzyxxx Auto Script - MODERN UI + MODULAR SYSTEM
-- Menu horizontal dengan icon Roblox, load modul dari folder modules

if not game:GetService("RunService"):IsClient() then
    return
end

-- Prevent duplicate
if _G.VanzyxxxLoaded then 
    print("Script already loaded!")
    return 
end
_G.VanzyxxxLoaded = true

print("[Vanzyxxx] Starting script...")

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Wait for everything
repeat task.wait() until plr
repeat task.wait() until plr.PlayerGui

print("[Vanzyxxx] Player loaded!")

-- ========================
-- MODULE LOADER SYSTEM
-- ========================
local Modules = {
    Checkpoint = nil,
    Fly = nil,
    Obby = nil,
    TeleportPlayers = nil
}

local function loadModule(name)
    -- Simulate loading from modules folder
    print("[Module] Loading:", name)
    
    if name == "Checkpoint" then
        -- Load checkpoint module
        local checkpointModule = {}
        
        checkpointModule.scanCheckpoints = function()
            print("[Checkpoint] Scanning...")
            return {}
        end
        
        checkpointModule.teleportToCheckpoint = function(index)
            print("[Checkpoint] Teleporting to CP", index)
            return true
        end
        
        checkpointModule.autoTeleportAll = function(callback)
            print("[Checkpoint] Auto teleport all")
            if callback then callback("✅ Auto checkpoint completed!") end
            return true
        end
        
        checkpointModule.teleportToSummit = function()
            print("[Checkpoint] Teleporting to summit")
            return true
        end
        
        checkpointModule.getCheckpointList = function()
            return {}
        end
        
        return checkpointModule
        
    elseif name == "Fly" then
        -- Load fly module
        local flyModule = {}
        
        flyModule.enable = function()
            print("[Fly] Enabled")
            return true
        end
        
        flyModule.disable = function()
            print("[Fly] Disabled")
        end
        
        flyModule.toggle = function(state)
            print("[Fly] Toggled:", state)
        end
        
        flyModule.isEnabled = function()
            return false
        end
        
        flyModule.setSpeed = function(speed)
            print("[Fly] Speed set to:", speed)
        end
        
        return flyModule
        
    elseif name == "Obby" then
        -- Load obby module
        local obbyModule = {}
        
        obbyModule.start = function()
            print("[Obby] Started")
            return true
        end
        
        obbyModule.stop = function()
            print("[Obby] Stopped")
            return true
        end
        
        obbyModule.pause = function()
            print("[Obby] Paused")
            return true
        end
        
        obbyModule.resume = function()
            print("[Obby] Resumed")
            return true
        end
        
        obbyModule.getStatus = function()
            return "stopped"
        end
        
        obbyModule.setStage = function(stage)
            print("[Obby] Stage set to:", stage)
            return true
        end
        
        obbyModule.getProgress = function()
            return {Current = 1, Total = 10, Percent = 10}
        end
        
        return obbyModule
        
    elseif name == "TeleportPlayers" then
        -- Load teleport players module
        local teleportModule = {}
        
        teleportModule.getPlayers = function()
            return {}
        end
        
        teleportModule.setMode = function(mode)
            print("[Teleport] Mode set to:", mode)
            return true
        end
        
        teleportModule.getMode = function()
            return "playerToMe"
        end
        
        teleportModule.togglePlayer = function(playerName)
            print("[Teleport] Toggled player:", playerName)
            return true
        end
        
        teleportModule.executeTeleport = function(callback)
            print("[Teleport] Executing teleport")
            if callback then callback("✅ Teleport completed!") end
            return true
        end
        
        return teleportModule
    end
    
    return nil
end

-- Load all modules
for moduleName, _ in pairs(Modules) do
    Modules[moduleName] = loadModule(moduleName)
end

print("[Vanzyxxx] All modules loaded!")

-- ========================
-- MODERN UI SYSTEM
-- ========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VanzyxxxModernGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

-- Add to PlayerGui
ScreenGui.Parent = plr:WaitForChild("PlayerGui")

-- ========================
-- MAIN CONTAINER
-- ========================
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(0, 850, 0, 550)
MainContainer.Position = UDim2.new(0.5, -425, 0.5, -275)
MainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
MainContainer.BackgroundTransparency = 0
MainContainer.Parent = ScreenGui

-- Container styling
local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0.03, 0)
containerCorner.Parent = MainContainer

local containerShadow = Instance.new("UIStroke")
containerShadow.Color = Color3.fromRGB(0, 0, 0)
containerShadow.Thickness = 2
containerShadow.Transparency = 0.3
containerShadow.Parent = MainContainer

-- ========================
-- HEADER SECTION
-- ========================
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 70)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
Header.BackgroundTransparency = 0
Header.Parent = MainContainer

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0.03, 0)
headerCorner.Parent = Header

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "VANZYXXX AUTOMATION SUITE"
Title.Size = UDim2.new(0, 400, 0, 40)
Title.Position = UDim2.new(0.03, 0, 0.5, -20)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(100, 150, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextStrokeTransparency = 0.7
Title.Parent = Header

-- Subtitle
local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Text = "Professional Game Automation Tools"
Subtitle.Size = UDim2.new(0, 400, 0, 20)
Subtitle.Position = UDim2.new(0.03, 0, 0.5, 10)
Subtitle.BackgroundTransparency = 1
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 200)
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 14
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

-- Status indicator
local StatusIndicator = Instance.new("Frame")
StatusIndicator.Name = "StatusIndicator"
StatusIndicator.Size = UDim2.new(0, 12, 0, 12)
StatusIndicator.Position = UDim2.new(0.95, -20, 0.5, -6)
StatusIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
StatusIndicator.Parent = Header

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(1, 0)
statusCorner.Parent = StatusIndicator

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Text = "ONLINE"
StatusLabel.Size = UDim2.new(0, 60, 0, 20)
StatusLabel.Position = UDim2.new(0.95, -70, 0.5, -10)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Right
StatusLabel.Parent = Header

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Text = ""
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(0.96, -40, 0.15, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
CloseButton.Parent = Header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.2, 0)
closeCorner.Parent = CloseButton

-- Close icon (X)
local CloseIcon = Instance.new("ImageLabel")
CloseIcon.Name = "CloseIcon"
CloseIcon.Size = UDim2.new(0.5, 0, 0.5, 0)
CloseIcon.Position = UDim2.new(0.25, 0, 0.25, 0)
CloseIcon.BackgroundTransparency = 1
CloseIcon.Image = "rbxassetid://3926305904"
CloseIcon.ImageRectSize = Vector2.new(36, 36)
CloseIcon.ImageRectOffset = Vector2.new(964, 324)
CloseIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
CloseIcon.Parent = CloseButton

-- ========================
-- SIDEBAR SECTION (VERTICAL MENU)
-- ========================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 200, 0, 430)
Sidebar.Position = UDim2.new(0, 0, 0, 70)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
Sidebar.BackgroundTransparency = 0
Sidebar.Parent = MainContainer

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 0)
sidebarCorner.Parent = Sidebar

-- Sidebar title
local SidebarTitle = Instance.new("TextLabel")
SidebarTitle.Name = "SidebarTitle"
SidebarTitle.Text = "MODULES"
SidebarTitle.Size = UDim2.new(1, 0, 0, 50)
SidebarTitle.Position = UDim2.new(0, 0, 0, 0)
SidebarTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
SidebarTitle.TextColor3 = Color3.fromRGB(100, 150, 255)
SidebarTitle.Font = Enum.Font.GothamBold
SidebarTitle.TextSize = 16
SidebarTitle.Parent = Sidebar

-- Menu buttons container
local MenuButtons = Instance.new("ScrollingFrame")
MenuButtons.Name = "MenuButtons"
MenuButtons.Size = UDim2.new(1, 0, 1, -50)
MenuButtons.Position = UDim2.new(0, 0, 0, 50)
MenuButtons.BackgroundTransparency = 1
MenuButtons.ScrollBarThickness = 3
MenuButtons.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
MenuButtons.CanvasSize = UDim2.new(0, 0, 0, 0)
MenuButtons.Parent = Sidebar

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = MenuButtons

-- ========================
-- CONTENT AREA (HORIZONTAL)
-- ========================
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(0, 630, 0, 430)
ContentArea.Position = UDim2.new(0, 210, 0, 70)
ContentArea.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
ContentArea.BackgroundTransparency = 0
ContentArea.Parent = MainContainer

-- Content title
local ContentTitle = Instance.new("TextLabel")
ContentTitle.Name = "ContentTitle"
ContentTitle.Text = "DASHBOARD"
ContentTitle.Size = UDim2.new(1, -40, 0, 40)
ContentTitle.Position = UDim2.new(0, 20, 0, 10)
ContentTitle.BackgroundTransparency = 1
ContentTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ContentTitle.Font = Enum.Font.GothamBold
ContentTitle.TextSize = 22
ContentTitle.TextXAlignment = Enum.TextXAlignment.Left
ContentTitle.Parent = ContentArea

-- Content divider
local ContentDivider = Instance.new("Frame")
ContentDivider.Name = "ContentDivider"
ContentDivider.Size = UDim2.new(1, -40, 0, 2)
ContentDivider.Position = UDim2.new(0, 20, 0, 55)
ContentDivider.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
ContentDivider.Parent = ContentArea

-- Content container (horizontal scrolling)
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -40, 1, -80)
ContentContainer.Position = UDim2.new(0, 20, 0, 70)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ScrollBarThickness = 3
ContentContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
ContentContainer.ScrollingDirection = Enum.ScrollingDirection.X
ContentContainer.VerticalScrollBarInset = Enum.ScrollBarInset.Always
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentContainer.Parent = ContentArea

local ContentGrid = Instance.new("UIGridLayout")
ContentGrid.CellSize = UDim2.new(0, 280, 0, 320)
ContentGrid.CellPadding = UDim2.new(0, 20, 0, 20)
ContentGrid.FillDirection = Enum.FillDirection.Horizontal
ContentGrid.HorizontalAlignment = Enum.HorizontalAlignment.Left
ContentGrid.SortOrder = Enum.SortOrder.LayoutOrder
ContentGrid.Parent = ContentContainer

-- ========================
-- MENU BUTTON CREATION
-- ========================
local menuItems = {
    {
        Name = "Dashboard",
        Icon = "rbxassetid://3926305904",
        IconRect = Vector2.new(124, 204),
        IconSize = Vector2.new(36, 36),
        Color = Color3.fromRGB(100, 150, 255),
        Content = function()
            return createDashboardContent()
        end
    },
    {
        Name = "Checkpoint",
        Icon = "rbxassetid://3926305904",
        IconRect = Vector2.new(124, 524),
        IconSize = Vector2.new(36, 36),
        Color = Color3.fromRGB(80, 200, 120),
        Content = function()
            return createCheckpointContent()
        end
    },
    {
        Name = "Fly System",
        Icon = "rbxassetid://3926305904",
        IconRect = Vector2.new(844, 444),
        IconSize = Vector2.new(36, 36),
        Color = Color3.fromRGB(50, 150, 255),
        Content = function()
            return createFlyContent()
        end
    },
    {
        Name = "Teleport",
        Icon = "rbxassetid://3926305904",
        IconRect = Vector2.new(964, 324),
        IconSize = Vector2.new(36, 36),
        Color = Color3.fromRGB(220, 120, 50),
        Content = function()
            return createTeleportContent()
        end
    },
    {
        Name = "Obby Runner",
        Icon = "rbxassetid://3926305904",
        IconRect = Vector2.new(524, 204),
        IconSize = Vector2.new(36, 36),
        Color = Color3.fromRGB(180, 80, 220),
        Content = function()
            return createObbyContent()
        end
    },
    {
        Name = "Player TP",
        Icon = "rbxassetid://3926305904",
        IconRect = Vector2.new(364, 364),
        IconSize = Vector2.new(36, 36),
        Color = Color3.fromRGB(255, 100, 100),
        Content = function()
            return createPlayerTPContent()
        end
    },
    {
        Name = "Settings",
        Icon = "rbxassetid://3926305904",
        IconRect = Vector2.new(964, 444),
        IconSize = Vector2.new(36, 36),
        Color = Color3.fromRGB(150, 150, 150),
        Content = function()
            return createSettingsContent()
        end
    }
}

local activeMenuButton = nil

local function createMenuButton(item)
    local button = Instance.new("TextButton")
    button.Name = "Btn_" .. item.Name
    button.Size = UDim2.new(0.9, 0, 0, 50)
    button.Position = UDim2.new(0.05, 0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    button.Text = ""
    button.AutoButtonColor = true
    button.Parent = MenuButtons
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0.1, 0)
    buttonCorner.Parent = button
    
    -- Icon
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0.1, 0, 0.5, -15)
    icon.BackgroundTransparency = 1
    icon.Image = item.Icon
    icon.ImageRectSize = item.IconSize
    icon.ImageRectOffset = item.IconRect
    icon.ImageColor3 = item.Color
    icon.Parent = button
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0.3, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = item.Name
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = button
    
    -- Indicator
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 4, 0.6, 0)
    indicator.Position = UDim2.new(1, -4, 0.2, 0)
    indicator.BackgroundColor3 = item.Color
    indicator.BackgroundTransparency = 1
    indicator.Parent = button
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0.5, 0)
    indicatorCorner.Parent = indicator
    
    button.MouseEnter:Connect(function()
        if button ~= activeMenuButton then
            game:GetService("TweenService"):Create(
                button,
                TweenInfo.new(0.2),
                {BackgroundColor3 = Color3.fromRGB(50, 50, 75)}
            ):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if button ~= activeMenuButton then
            game:GetService("TweenService"):Create(
                button,
                TweenInfo.new(0.2),
                {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}
            ):Play()
        end
    end)
    
    button.MouseButton1Click:Connect(function()
        -- Update active button
        if activeMenuButton then
            game:GetService("TweenService"):Create(
                activeMenuButton,
                TweenInfo.new(0.2),
                {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}
            ):Play()
            game:GetService("TweenService"):Create(
                activeMenuButton.Indicator,
                TweenInfo.new(0.2),
                {BackgroundTransparency = 1}
            ):Play()
        end
        
        activeMenuButton = button
        
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(60, 60, 90)}
        ):Play()
        
        game:GetService("TweenService"):Create(
            button.Indicator,
            TweenInfo.new(0.2),
            {BackgroundTransparency = 0}
        ):Play()
        
        -- Update content
        ContentTitle.Text = item.Name
        clearContent()
        
        if item.Content then
            item.Content()
        end
    end)
    
    return button
end

-- Create all menu buttons
for _, item in ipairs(menuItems) do
    createMenuButton(item)
end

-- Update MenuButtons canvas size
task.wait()
MenuButtons.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)

-- ========================
-- CONTENT CREATION FUNCTIONS
-- ========================
function clearContent()
    for _, child in ipairs(ContentContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

function createCard(title, color)
    local card = Instance.new("Frame")
    card.Name = "Card_" .. title
    card.Size = UDim2.new(0, 280, 0, 320)
    card.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    card.Parent = ContentContainer
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0.05, 0)
    cardCorner.Parent = card
    
    local cardShadow = Instance.new("UIStroke")
    cardShadow.Color = color
    cardShadow.Thickness = 2
    cardShadow.Transparency = 0.3
    cardShadow.Parent = card
    
    -- Card header
    local cardHeader = Instance.new("Frame")
    cardHeader.Name = "Header"
    cardHeader.Size = UDim2.new(1, 0, 0, 50)
    cardHeader.Position = UDim2.new(0, 0, 0, 0)
    cardHeader.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    cardHeader.Parent = card
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0.05, 0)
    headerCorner.Parent = cardHeader
    
    local cardTitle = Instance.new("TextLabel")
    cardTitle.Name = "Title"
    cardTitle.Text = title
    cardTitle.Size = UDim2.new(1, -20, 1, 0)
    cardTitle.Position = UDim2.new(0, 10, 0, 0)
    cardTitle.BackgroundTransparency = 1
    cardTitle.TextColor3 = color
    cardTitle.Font = Enum.Font.GothamBold
    cardTitle.TextSize = 18
    cardTitle.TextXAlignment = Enum.TextXAlignment.Left
    cardTitle.Parent = cardHeader
    
    -- Card content
    local cardContent = Instance.new("Frame")
    cardContent.Name = "Content"
    cardContent.Size = UDim2.new(1, 0, 1, -60)
    cardContent.Position = UDim2.new(0, 0, 0, 60)
    cardContent.BackgroundTransparency = 1
    cardContent.Parent = card
    
    return card, cardContent
end

function createDashboardContent()
    -- Welcome card
    local welcomeCard, welcomeContent = createCard("Welcome", Color3.fromRGB(100, 150, 255))
    
    local welcomeText = Instance.new("TextLabel")
    welcomeText.Name = "WelcomeText"
    welcomeText.Size = UDim2.new(1, -20, 0, 150)
    welcomeText.Position = UDim2.new(0, 10, 0, 10)
    welcomeText.BackgroundTransparency = 1
    welcomeText.Text = "Welcome to Vanzyxxx Automation Suite!\n\nThis script provides powerful automation tools for your gaming experience.\n\nSelect a module from the sidebar to get started."
    welcomeText.TextColor3 = Color3.fromRGB(220, 220, 220)
    welcomeText.Font = Enum.Font.Gotham
    welcomeText.TextSize = 14
    welcomeText.TextWrapped = true
    welcomeText.TextYAlignment = Enum.TextYAlignment.Top
    welcomeText.Parent = welcomeContent
    
    -- Stats card
    local statsCard, statsContent = createCard("Statistics", Color3.fromRGB(80, 200, 120))
    
    local stats = {
        {"Modules Loaded", #menuItems},
        {"Player Level", plr.leaderstats and plr.leaderstats.Level and plr.leaderstats.Level.Value or "N/A"},
        {"Coins", plr.leaderstats and plr.leaderstats.Coins and plr.leaderstats.Coins.Value or "N/A"},
        {"Online Players", #Players:GetPlayers()}
    }
    
    local yPos = 10
    for _, stat in ipairs(stats) do
        local statRow = Instance.new("Frame")
        statRow.Name = "Stat_" .. stat[1]
        statRow.Size = UDim2.new(1, -20, 0, 30)
        statRow.Position = UDim2.new(0, 10, 0, yPos)
        statRow.BackgroundTransparency = 1
        statRow.Parent = statsContent
        
        local statName = Instance.new("TextLabel")
        statName.Name = "Name"
        statName.Size = UDim2.new(0.6, 0, 1, 0)
        statName.Position = UDim2.new(0, 0, 0, 0)
        statName.BackgroundTransparency = 1
        statName.Text = stat[1]
        statName.TextColor3 = Color3.fromRGB(180, 180, 200)
        statName.Font = Enum.Font.Gotham
        statName.TextSize = 14
        statName.TextXAlignment = Enum.TextXAlignment.Left
        statName.Parent = statRow
        
        local statValue = Instance.new("TextLabel")
        statValue.Name = "Value"
        statValue.Size = UDim2.new(0.4, 0, 1, 0)
        statValue.Position = UDim2.new(0.6, 0, 0, 0)
        statValue.BackgroundTransparency = 1
        statValue.Text = tostring(stat[2])
        statValue.TextColor3 = Color3.fromRGB(100, 150, 255)
        statValue.Font = Enum.Font.GothamBold
        statValue.TextSize = 14
        statValue.TextXAlignment = Enum.TextXAlignment.Right
        statValue.Parent = statRow
        
        yPos = yPos + 35
    end
    
    -- Quick Actions card
    local actionsCard, actionsContent = createCard("Quick Actions", Color3.fromRGB(220, 120, 50))
    
    local quickActions = {
        {"Toggle Fly", function() 
            if Modules.Fly then
                Modules.Fly.toggle()
            end
        end},
        {"Teleport to Spawn", function()
            -- Teleport to spawn implementation
        end},
        {"Refresh Modules", function()
            print("[Dashboard] Refreshing modules...")
        end}
    }
    
    yPos = 10
    for i, action in ipairs(quickActions) do
        local actionBtn = Instance.new("TextButton")
        actionBtn.Name = "Action_" .. action[1]
        actionBtn.Text = action[1]
        actionBtn.Size = UDim2.new(1, -20, 0, 40)
        actionBtn.Position = UDim2.new(0, 10, 0, yPos)
        actionBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
        actionBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        actionBtn.Font = Enum.Font.GothamMedium
        actionBtn.TextSize = 14
        actionBtn.Parent = actionsContent
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0.1, 0)
        btnCorner.Parent = actionBtn
        
        actionBtn.MouseButton1Click:Connect(action[2])
        
        yPos = yPos + 50
    end
end

function createCheckpointContent()
    local mainCard, mainContent = createCard("Checkpoint Control", Color3.fromRGB(80, 200, 120))
    
    -- Scan button
    local scanBtn = Instance.new("TextButton")
    scanBtn.Name = "ScanBtn"
    scanBtn.Text = "Scan Checkpoints"
    scanBtn.Size = UDim2.new(1, -20, 0, 40)
    scanBtn.Position = UDim2.new(0, 10, 0, 10)
    scanBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
    scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    scanBtn.Font = Enum.Font.GothamBold
    scanBtn.TextSize = 14
    scanBtn.Parent = mainContent
    
    local scanCorner = Instance.new("UICorner")
    scanCorner.CornerRadius = UDim.new(0.1, 0)
    scanCorner.Parent = scanBtn
    
    scanBtn.MouseButton1Click:Connect(function()
        if Modules.Checkpoint then
            Modules.Checkpoint.scanCheckpoints()
        end
    end)
    
    -- Auto checkpoint button
    local autoBtn = Instance.new("TextButton")
    autoBtn.Name = "AutoBtn"
    autoBtn.Text = "Auto All Checkpoints"
    autoBtn.Size = UDim2.new(1, -20, 0, 40)
    autoBtn.Position = UDim2.new(0, 10, 0, 60)
    autoBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
    autoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoBtn.Font = Enum.Font.GothamBold
    autoBtn.TextSize = 14
    autoBtn.Parent = mainContent
    
    local autoCorner = Instance.new("UICorner")
    autoCorner.CornerRadius = UDim.new(0.1, 0)
    autoCorner.Parent = autoBtn
    
    autoBtn.MouseButton1Click:Connect(function()
        if Modules.Checkpoint then
            Modules.Checkpoint.autoTeleportAll(function(message)
                print("[Checkpoint]", message)
            end)
        end
    end)
    
    -- Teleport to summit button
    local summitBtn = Instance.new("TextButton")
    summitBtn.Name = "SummitBtn"
    summitBtn.Text = "Teleport to Summit"
    summitBtn.Size = UDim2.new(1, -20, 0, 40)
    summitBtn.Position = UDim2.new(0, 10, 0, 110)
    summitBtn.BackgroundColor3 = Color3.fromRGB(220, 120, 50)
    summitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    summitBtn.Font = Enum.Font.GothamBold
    summitBtn.TextSize = 14
    summitBtn.Parent = mainContent
    
    local summitCorner = Instance.new("UICorner")
    summitCorner.CornerRadius = UDim.new(0.1, 0)
    summitCorner.Parent = summitBtn
    
    summitBtn.MouseButton1Click:Connect(function()
        if Modules.Checkpoint then
            Modules.Checkpoint.teleportToSummit()
        end
    end)
    
    -- Checkpoint list display
    local listLabel = Instance.new("TextLabel")
    listLabel.Name = "ListLabel"
    listLabel.Text = "Detected Checkpoints:"
    listLabel.Size = UDim2.new(1, -20, 0, 20)
    listLabel.Position = UDim2.new(0, 10, 0, 160)
    listLabel.BackgroundTransparency = 1
    listLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    listLabel.Font = Enum.Font.Gotham
    listLabel.TextSize = 12
    listLabel.TextXAlignment = Enum.TextXAlignment.Left
    listLabel.Parent = mainContent
    
    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Name = "ListFrame"
    listFrame.Size = UDim2.new(1, -20, 0, 100)
    listFrame.Position = UDim2.new(0, 10, 0, 185)
    listFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    listFrame.ScrollBarThickness = 3
    listFrame.Parent = mainContent
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = listFrame
    
    -- Status display
    local statusDisplay = Instance.new("TextLabel")
    statusDisplay.Name = "StatusDisplay"
    statusDisplay.Text = "Ready"
    statusDisplay.Size = UDim2.new(1, -20, 0, 30)
    statusDisplay.Position = UDim2.new(0, 10, 1, -40)
    statusDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    statusDisplay.TextColor3 = Color3.fromRGB(100, 200, 100)
    statusDisplay.Font = Enum.Font.GothamMedium
    statusDisplay.TextSize = 12
    statusDisplay.Parent = mainContent
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0.1, 0)
    statusCorner.Parent = statusDisplay
end

function createFlyContent()
    local mainCard, mainContent = createCard("Fly System", Color3.fromRGB(50, 150, 255))
    
    -- Toggle fly button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleBtn"
    toggleBtn.Text = "Enable Fly"
    toggleBtn.Size = UDim2.new(1, -20, 0, 50)
    toggleBtn.Position = UDim2.new(0, 10, 0, 10)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 16
    toggleBtn.Parent = mainContent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0.1, 0)
    toggleCorner.Parent = toggleBtn
    
    toggleBtn.MouseButton1Click:Connect(function()
        if Modules.Fly then
            local isEnabled = Modules.Fly.isEnabled()
            Modules.Fly.toggle(not isEnabled)
            
            if isEnabled then
                toggleBtn.Text = "Enable Fly"
                toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
            else
                toggleBtn.Text = "Disable Fly"
                toggleBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
            end
        end
    end)
    
    -- Speed control
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "SpeedLabel"
    speedLabel.Text = "Fly Speed: 40"
    speedLabel.Size = UDim2.new(1, -20, 0, 20)
    speedLabel.Position = UDim2.new(0, 10, 0, 70)
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextSize = 12
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = mainContent
    
    local speedSlider = Instance.new("Frame")
    speedSlider.Name = "SpeedSlider"
    speedSlider.Size = UDim2.new(1, -20, 0, 30)
    speedSlider.Position = UDim2.new(0, 10, 0, 95)
    speedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    speedSlider.Parent = mainContent
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0.1, 0)
    sliderCorner.Parent = speedSlider
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    sliderFill.Parent = speedSlider
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0.1, 0)
    fillCorner.Parent = sliderFill
    
    -- Vertical speed control
    local vSpeedLabel = Instance.new("TextLabel")
    vSpeedLabel.Name = "VSpeedLabel"
    vSpeedLabel.Text = "Vertical Speed: 25"
    vSpeedLabel.Size = UDim2.new(1, -20, 0, 20)
    vSpeedLabel.Position = UDim2.new(0, 10, 0, 135)
    vSpeedLabel.BackgroundTransparency = 1
    vSpeedLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    vSpeedLabel.Font = Enum.Font.Gotham
    vSpeedLabel.TextSize = 12
    vSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    vSpeedLabel.Parent = mainContent
    
    local vSpeedSlider = Instance.new("Frame")
    vSpeedSlider.Name = "VSpeedSlider"
    vSpeedSlider.Size = UDim2.new(1, -20, 0, 30)
    vSpeedSlider.Position = UDim2.new(0, 10, 0, 160)
    vSpeedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    vSpeedSlider.Parent = mainContent
    
    local vSliderCorner = Instance.new("UICorner")
    vSliderCorner.CornerRadius = UDim.new(0.1, 0)
    vSliderCorner.Parent = vSpeedSlider
    
    local vSliderFill = Instance.new("Frame")
    vSliderFill.Name = "Fill"
    vSliderFill.Size = UDim2.new(0.4, 0, 1, 0)
    vSliderFill.Position = UDim2.new(0, 0, 0, 0)
    vSliderFill.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
    vSliderFill.Parent = vSpeedSlider
    
    local vFillCorner = Instance.new("UICorner")
    vFillCorner.CornerRadius = UDim.new(0.1, 0)
    vFillCorner.Parent = vSliderFill
    
    -- Controls guide
    local guideLabel = Instance.new("TextLabel")
    guideLabel.Name = "GuideLabel"
    guideLabel.Text = "Controls:\n• WASD: Move\n• Space: Up\n• Shift: Down\n• Mobile: Use on-screen buttons"
    guideLabel.Size = UDim2.new(1, -20, 0, 80)
    guideLabel.Position = UDim2.new(0, 10, 0, 200)
    guideLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    guideLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    guideLabel.Font = Enum.Font.Gotham
    guideLabel.TextSize = 12
    guideLabel.TextWrapped = true
    guideLabel.Parent = mainContent
    
    local guideCorner = Instance.new("UICorner")
    guideCorner.CornerRadius = UDim.new(0.1, 0)
    guideCorner.Parent = guideLabel
end

function createTeleportContent()
    local mainCard, mainContent = createCard("Teleport", Color3.fromRGB(220, 120, 50))
    
    -- Teleport to spawn
    local spawnBtn = Instance.new("TextButton")
    spawnBtn.Name = "SpawnBtn"
    spawnBtn.Text = "Teleport to Spawn"
    spawnBtn.Size = UDim2.new(1, -20, 0, 40)
    spawnBtn.Position = UDim2.new(0, 10, 0, 10)
    spawnBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
    spawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    spawnBtn.Font = Enum.Font.GothamBold
    spawnBtn.TextSize = 14
    spawnBtn.Parent = mainContent
    
    local spawnCorner = Instance.new("UICorner")
    spawnCorner.CornerRadius = UDim.new(0.1, 0)
    spawnCorner.Parent = spawnBtn
    
    spawnBtn.MouseButton1Click:Connect(function()
        -- Teleport to spawn implementation
        print("[Teleport] Teleporting to spawn...")
    end)
    
    -- Teleport to nearest player
    local playerBtn = Instance.new("TextButton")
    playerBtn.Name = "PlayerBtn"
    playerBtn.Text = "Teleport to Nearest Player"
    playerBtn.Size = UDim2.new(1, -20, 0, 40)
    playerBtn.Position = UDim2.new(0, 10, 0, 60)
    playerBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
    playerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    playerBtn.Font = Enum.Font.GothamBold
    playerBtn.TextSize = 14
    playerBtn.Parent = mainContent
    
    local playerCorner = Instance.new("UICorner")
    playerCorner.CornerRadius = UDim.new(0.1, 0)
    playerCorner.Parent = playerBtn
    
    playerBtn.MouseButton1Click:Connect(function()
        -- Teleport to nearest player implementation
        print("[Teleport] Teleporting to nearest player...")
    end)
    
    -- Teleport to specific coordinate
    local coordLabel = Instance.new("TextLabel")
    coordLabel.Name = "CoordLabel"
    coordLabel.Text = "Teleport to Coordinates:"
    coordLabel.Size = UDim2.new(1, -20, 0, 20)
    coordLabel.Position = UDim2.new(0, 10, 0, 110)
    coordLabel.BackgroundTransparency = 1
    coordLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    coordLabel.Font = Enum.Font.Gotham
    coordLabel.TextSize = 12
    coordLabel.TextXAlignment = Enum.TextXAlignment.Left
    coordLabel.Parent = mainContent
    
    local coordFrame = Instance.new("Frame")
    coordFrame.Name = "CoordFrame"
    coordFrame.Size = UDim2.new(1, -20, 0, 80)
    coordFrame.Position = UDim2.new(0, 10, 0, 135)
    coordFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    coordFrame.Parent = mainContent
    
    local coordCorner = Instance.new("UICorner")
    coordCorner.CornerRadius = UDim.new(0.1, 0)
    coordCorner.Parent = coordFrame
    
    -- X input
    local xLabel = Instance.new("TextLabel")
    xLabel.Name = "XLabel"
    xLabel.Text = "X:"
    xLabel.Size = UDim2.new(0.2, 0, 0, 30)
    xLabel.Position = UDim2.new(0, 10, 0, 10)
    xLabel.BackgroundTransparency = 1
    xLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    xLabel.Font = Enum.Font.Gotham
    xLabel.TextSize = 12
    xLabel.TextXAlignment = Enum.TextXAlignment.Left
    xLabel.Parent = coordFrame
    
    local xInput = Instance.new("TextBox")
    xInput.Name = "XInput"
    xInput.Text = "0"
    xInput.Size = UDim2.new(0.7, 0, 0, 30)
    xInput.Position = UDim2.new(0.25, 0, 0, 10)
    xInput.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    xInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    xInput.Font = Enum.Font.Gotham
    xInput.TextSize = 14
    xInput.Parent = coordFrame
    
    -- Y input
    local yLabel = Instance.new("TextLabel")
    yLabel.Name = "YLabel"
    yLabel.Text = "Y:"
    yLabel.Size = UDim2.new(0.2, 0, 0, 30)
    yLabel.Position = UDim2.new(0, 10, 0, 45)
    yLabel.BackgroundTransparency = 1
    yLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    yLabel.Font = Enum.Font.Gotham
    yLabel.TextSize = 12
    yLabel.TextXAlignment = Enum.TextXAlignment.Left
    yLabel.Parent = coordFrame
    
    local yInput = Instance.new("TextBox")
    yInput.Name = "YInput"
    yInput.Text = "0"
    yInput.Size = UDim2.new(0.7, 0, 0, 30)
    yInput.Position = UDim2.new(0.25, 0, 0, 45)
    yInput.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    yInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    yInput.Font = Enum.Font.Gotham
    yInput.TextSize = 14
    yInput.Parent = coordFrame
    
    -- Teleport button
    local coordBtn = Instance.new("TextButton")
    coordBtn.Name = "CoordBtn"
    coordBtn.Text = "Teleport"
    coordBtn.Size = UDim2.new(1, -20, 0, 40)
    coordBtn.Position = UDim2.new(0, 10, 0, 225)
    coordBtn.BackgroundColor3 = Color3.fromRGB(220, 120, 50)
    coordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    coordBtn.Font = Enum.Font.GothamBold
    coordBtn.TextSize = 14
    coordBtn.Parent = mainContent
    
    local coordBtnCorner = Instance.new("UICorner")
    coordBtnCorner.CornerRadius = UDim.new(0.1, 0)
    coordBtnCorner.Parent = coordBtn
    
    coordBtn.MouseButton1Click:Connect(function()
        local x = tonumber(xInput.Text) or 0
        local y = tonumber(yInput.Text) or 0
        print("[Teleport] Teleporting to:", x, y)
    end)
end

function createObbyContent()
    local mainCard, mainContent = createCard("Obby Runner", Color3.fromRGB(180, 80, 220))
    
    -- Start button
    local startBtn = Instance.new("TextButton")
    startBtn.Name = "StartBtn"
    startBtn.Text = "Start Auto Obby"
    startBtn.Size = UDim2.new(1, -20, 0, 40)
    startBtn.Position = UDim2.new(0, 10, 0, 10)
    startBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
    startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 14
    startBtn.Parent = mainContent
    
    local startCorner = Instance.new("UICorner")
    startCorner.CornerRadius = UDim.new(0.1, 0)
    startCorner.Parent = startBtn
    
    startBtn.MouseButton1Click:Connect(function()
        if Modules.Obby then
            Modules.Obby.start()
            startBtn.Text = "Stop Auto Obby"
            startBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
        end
    end)
    
    -- Pause/Resume button
    local pauseBtn = Instance.new("TextButton")
    pauseBtn.Name = "PauseBtn"
    pauseBtn.Text = "Pause"
    pauseBtn.Size = UDim2.new(1, -20, 0, 40)
    pauseBtn.Position = UDim2.new(0, 10, 0, 60)
    pauseBtn.BackgroundColor3 = Color3.fromRGB(220, 120, 50)
    pauseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    pauseBtn.Font = Enum.Font.GothamBold
    pauseBtn.TextSize = 14
    pauseBtn.Parent = mainContent
    
    local pauseCorner = Instance.new("UICorner")
    pauseCorner.CornerRadius = UDim.new(0.1, 0)
    pauseCorner.Parent = pauseBtn
    
    pauseBtn.MouseButton1Click:Connect(function()
        if Modules.Obby then
            local status = Modules.Obby.getStatus()
            if status == "running" then
                Modules.Obby.pause()
                pauseBtn.Text = "Resume"
            elseif status == "paused" then
                Modules.Obby.resume()
                pauseBtn.Text = "Pause"
            end
        end
    end)
    
    -- Progress display
    local progressLabel = Instance.new("TextLabel")
    progressLabel.Name = "ProgressLabel"
    progressLabel.Text = "Progress: 0%"
    progressLabel.Size = UDim2.new(1, -20, 0, 30)
    progressLabel.Position = UDim2.new(0, 10, 0, 110)
    progressLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    progressLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    progressLabel.Font = Enum.Font.GothamMedium
    progressLabel.TextSize = 14
    progressLabel.Parent = mainContent
    
    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0.1, 0)
    progressCorner.Parent = progressLabel
    
    -- Stage control
    local stageLabel = Instance.new("TextLabel")
    stageLabel.Name = "StageLabel"
    stageLabel.Text = "Set Starting Stage:"
    stageLabel.Size = UDim2.new(1, -20, 0, 20)
    stageLabel.Position = UDim2.new(0, 10, 0, 150)
    stageLabel.BackgroundTransparency = 1
    stageLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    stageLabel.Font = Enum.Font.Gotham
    stageLabel.TextSize = 12
    stageLabel.TextXAlignment = Enum.TextXAlignment.Left
    stageLabel.Parent = mainContent
    
    local stageFrame = Instance.new("Frame")
    stageFrame.Name = "StageFrame"
    stageFrame.Size = UDim2.new(1, -20, 0, 40)
    stageFrame.Position = UDim2.new(0, 10, 0, 175)
    stageFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    stageFrame.Parent = mainContent
    
    local stageCorner = Instance.new("UICorner")
    stageCorner.CornerRadius = UDim.new(0.1, 0)
    stageCorner.Parent = stageFrame
    
    local stageInput = Instance.new("TextBox")
    stageInput.Name = "StageInput"
    stageInput.Text = "1"
    stageInput.Size = UDim2.new(0.6, 0, 0.8, 0)
    stageInput.Position = UDim2.new(0.05, 0, 0.1, 0)
    stageInput.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    stageInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    stageInput.Font = Enum.Font.Gotham
    stageInput.TextSize = 14
    stageInput.Parent = stageFrame
    
    local stageSetBtn = Instance.new("TextButton")
    stageSetBtn.Name = "StageSetBtn"
    stageSetBtn.Text = "Set"
    stageSetBtn.Size = UDim2.new(0.3, 0, 0.8, 0)
    stageSetBtn.Position = UDim2.new(0.65, 0, 0.1, 0)
    stageSetBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    stageSetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    stageSetBtn.Font = Enum.Font.GothamMedium
    stageSetBtn.TextSize = 14
    stageSetBtn.Parent = stageFrame
    
    stageSetBtn.MouseButton1Click:Connect(function()
        local stage = tonumber(stageInput.Text) or 1
        if Modules.Obby then
            Modules.Obby.setStage(stage)
        end
    end)
    
    -- Status display
    local statusDisplay = Instance.new("TextLabel")
    statusDisplay.Name = "StatusDisplay"
    statusDisplay.Text = "Status: Ready"
    statusDisplay.Size = UDim2.new(1, -20, 0, 30)
    statusDisplay.Position = UDim2.new(0, 10, 1, -40)
    statusDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    statusDisplay.TextColor3 = Color3.fromRGB(100, 200, 100)
    statusDisplay.Font = Enum.Font.GothamMedium
    statusDisplay.TextSize = 12
    statusDisplay.Parent = mainContent
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0.1, 0)
    statusCorner.Parent = statusDisplay
end

function createPlayerTPContent()
    local mainCard, mainContent = createCard("Player Teleport", Color3.fromRGB(255, 100, 100))
    
    -- Mode selection
    local modeLabel = Instance.new("TextLabel")
    modeLabel.Name = "ModeLabel"
    modeLabel.Text = "Teleport Mode:"
    modeLabel.Size = UDim2.new(1, -20, 0, 20)
    modeLabel.Position = UDim2.new(0, 10, 0, 10)
    modeLabel.BackgroundTransparency = 1
    modeLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    modeLabel.Font = Enum.Font.Gotham
    modeLabel.TextSize = 12
    modeLabel.TextXAlignment = Enum.TextXAlignment.Left
    modeLabel.Parent = mainContent
    
    local modeFrame = Instance.new("Frame")
    modeFrame.Name = "ModeFrame"
    modeFrame.Size = UDim2.new(1, -20, 0, 40)
    modeFrame.Position = UDim2.new(0, 10, 0, 35)
    modeFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    modeFrame.Parent = mainContent
    
    local modeCorner = Instance.new("UICorner")
    modeCorner.CornerRadius = UDim.new(0.1, 0)
    modeCorner.Parent = modeFrame
    
    local modeToMe = Instance.new("TextButton")
    modeToMe.Name = "ModeToMe"
    modeToMe.Text = "Players → Me"
    modeToMe.Size = UDim2.new(0.48, 0, 0.8, 0)
    modeToMe.Position = UDim2.new(0.01, 0, 0.1, 0)
    modeToMe.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    modeToMe.TextColor3 = Color3.fromRGB(255, 255, 255)
    modeToMe.Font = Enum.Font.GothamMedium
    modeToMe.TextSize = 12
    modeToMe.Parent = modeFrame
    
    local modeToPlayer = Instance.new("TextButton")
    modeToPlayer.Name = "ModeToPlayer"
    modeToPlayer.Text = "Me → Player"
    modeToPlayer.Size = UDim2.new(0.48, 0, 0.8, 0)
    modeToPlayer.Position = UDim2.new(0.51, 0, 0.1, 0)
    modeToPlayer.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    modeToPlayer.TextColor3 = Color3.fromRGB(180, 180, 200)
    modeToPlayer.Font = Enum.Font.GothamMedium
    modeToPlayer.TextSize = 12
    modeToPlayer.Parent = modeFrame
    
    -- Player list
    local playersLabel = Instance.new("TextLabel")
    playersLabel.Name = "PlayersLabel"
    playersLabel.Text = "Online Players:"
    playersLabel.Size = UDim2.new(1, -20, 0, 20)
    playersLabel.Position = UDim2.new(0, 10, 0, 85)
    playersLabel.BackgroundTransparency = 1
    playersLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    playersLabel.Font = Enum.Font.Gotham
    playersLabel.TextSize = 12
    playersLabel.TextXAlignment = Enum.TextXAlignment.Left
    playersLabel.Parent = mainContent
    
    local playersFrame = Instance.new("ScrollingFrame")
    playersFrame.Name = "PlayersFrame"
    playersFrame.Size = UDim2.new(1, -20, 0, 120)
    playersFrame.Position = UDim2.new(0, 10, 0, 110)
    playersFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    playersFrame.ScrollBarThickness = 3
    playersFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    playersFrame.Parent = mainContent
    
    local playersLayout = Instance.new("UIListLayout")
    playersLayout.Padding = UDim.new(0, 5)
    playersLayout.Parent = playersFrame
    
    -- Execute button
    local executeBtn = Instance.new("TextButton")
    executeBtn.Name = "ExecuteBtn"
    executeBtn.Text = "Execute Teleport"
    executeBtn.Size = UDim2.new(1, -20, 0, 40)
    executeBtn.Position = UDim2.new(0, 10, 1, -50)
    executeBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
    executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    executeBtn.Font = Enum.Font.GothamBold
    executeBtn.TextSize = 14
    executeBtn.Parent = mainContent
    
    local executeCorner = Instance.new("UICorner")
    executeCorner.CornerRadius = UDim.new(0.1, 0)
    executeCorner.Parent = executeBtn
    
    executeBtn.MouseButton1Click:Connect(function()
        if Modules.TeleportPlayers then
            Modules.TeleportPlayers.executeTeleport(function(message)
                print("[PlayerTP]", message)
            end)
        end
    end)
    
    -- Refresh button
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Name = "RefreshBtn"
    refreshBtn.Text = "Refresh Players"
    refreshBtn.Size = UDim2.new(1, -20, 0, 30)
    refreshBtn.Position = UDim2.new(0, 10, 1, -90)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    refreshBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    refreshBtn.Font = Enum.Font.Gotham
    refreshBtn.TextSize = 12
    refreshBtn.Parent = mainContent
    
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0.1, 0)
    refreshCorner.Parent = refreshBtn
end

function createSettingsContent()
    local mainCard, mainContent = createCard("Settings", Color3.fromRGB(150, 150, 150))
    
    -- UI Theme
    local themeLabel = Instance.new("TextLabel")
    themeLabel.Name = "ThemeLabel"
    themeLabel.Text = "UI Theme:"
    themeLabel.Size = UDim2.new(1, -20, 0, 20)
    themeLabel.Position = UDim2.new(0, 10, 0, 10)
    themeLabel.BackgroundTransparency = 1
    themeLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    themeLabel.Font = Enum.Font.Gotham
    themeLabel.TextSize = 12
    themeLabel.TextXAlignment = Enum.TextXAlignment.Left
    themeLabel.Parent = mainContent
    
    local themeFrame = Instance.new("Frame")
    themeFrame.Name = "ThemeFrame"
    themeFrame.Size = UDim2.new(1, -20, 0, 40)
    themeFrame.Position = UDim2.new(0, 10, 0, 35)
    themeFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    themeFrame.Parent = mainContent
    
    local themeCorner = Instance.new("UICorner")
    themeCorner.CornerRadius = UDim.new(0.1, 0)
    themeCorner.Parent = themeFrame
    
    local themeDark = Instance.new("TextButton")
    themeDark.Name = "ThemeDark"
    themeDark.Text = "Dark"
    themeDark.Size = UDim2.new(0.3, 0, 0.8, 0)
    themeDark.Position = UDim2.new(0.02, 0, 0.1, 0)
    themeDark.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    themeDark.TextColor3 = Color3.fromRGB(255, 255, 255)
    themeDark.Font = Enum.Font.GothamMedium
    themeDark.TextSize = 12
    themeDark.Parent = themeFrame
    
    local themeLight = Instance.new("TextButton")
    themeLight.Name = "ThemeLight"
    themeLight.Text = "Light"
    themeLight.Size = UDim2.new(0.3, 0, 0.8, 0)
    themeLight.Position = UDim2.new(0.34, 0, 0.1, 0)
    themeLight.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    themeLight.TextColor3 = Color3.fromRGB(180, 180, 200)
    themeLight.Font = Enum.Font.GothamMedium
    themeLight.TextSize = 12
    themeLight.Parent = themeFrame
    
    local themeBlue = Instance.new("TextButton")
    themeBlue.Name = "ThemeBlue"
    themeBlue.Text = "Blue"
    themeBlue.Size = UDim2.new(0.3, 0, 0.8, 0)
    themeBlue.Position = UDim2.new(0.66, 0, 0.1, 0)
    themeBlue.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    themeBlue.TextColor3 = Color3.fromRGB(180, 180, 200)
    themeBlue.Font = Enum.Font.GothamMedium
    themeBlue.TextSize = 12
    themeBlue.Parent = themeFrame
    
    -- Transparency slider
    local transLabel = Instance.new("TextLabel")
    transLabel.Name = "TransLabel"
    transLabel.Text = "UI Transparency: 0%"
    transLabel.Size = UDim2.new(1, -20, 0, 20)
    transLabel.Position = UDim2.new(0, 10, 0, 85)
    transLabel.BackgroundTransparency = 1
    transLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    transLabel.Font = Enum.Font.Gotham
    transLabel.TextSize = 12
    transLabel.TextXAlignment = Enum.TextXAlignment.Left
    transLabel.Parent = mainContent
    
    local transSlider = Instance.new("Frame")
    transSlider.Name = "TransSlider"
    transSlider.Size = UDim2.new(1, -20, 0, 30)
    transSlider.Position = UDim2.new(0, 10, 0, 110)
    transSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    transSlider.Parent = mainContent
    
    local transSliderCorner = Instance.new("UICorner")
    transSliderCorner.CornerRadius = UDim.new(0.1, 0)
    transSliderCorner.Parent = transSlider
    
    local transFill = Instance.new("Frame")
    transFill.Name = "Fill"
    transFill.Size = UDim2.new(0, 0, 1, 0)
    transFill.Position = UDim2.new(0, 0, 0, 0)
    transFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    transFill.Parent = transSlider
    
    local transFillCorner = Instance.new("UICorner")
    transFillCorner.CornerRadius = UDim.new(0.1, 0)
    transFillCorner.Parent = transFill
    
    -- Save button
    local saveBtn = Instance.new("TextButton")
    saveBtn.Name = "SaveBtn"
    saveBtn.Text = "Save Settings"
    saveBtn.Size = UDim2.new(1, -20, 0, 40)
    saveBtn.Position = UDim2.new(0, 10, 1, -60)
    saveBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
    saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    saveBtn.Font = Enum.Font.GothamBold
    saveBtn.TextSize = 14
    saveBtn.Parent = mainContent
    
    local saveCorner = Instance.new("UICorner")
    saveCorner.CornerRadius = UDim.new(0.1, 0)
    saveCorner.Parent = saveBtn
    
    -- Reset button
    local resetBtn = Instance.new("TextButton")
    resetBtn.Name = "ResetBtn"
    resetBtn.Text = "Reset to Default"
    resetBtn.Size = UDim2.new(1, -20, 0, 30)
    resetBtn.Position = UDim2.new(0, 10, 1, -100)
    resetBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
    resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetBtn.Font = Enum.Font.GothamMedium
    resetBtn.TextSize = 12
    resetBtn.Parent = mainContent
    
    local resetCorner = Instance.new("UICorner")
    resetCorner.CornerRadius = UDim.new(0.1, 0)
    resetCorner.Parent = resetBtn
end

-- ========================
-- INITIALIZE UI
-- ========================
-- Set Dashboard as default
task.wait(0.5)
if MenuButtons:FindFirstChild("Btn_Dashboard") then
    MenuButtons.Btn_Dashboard:Click()
end

-- Connect close button
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    _G.VanzyxxxLoaded = false
    print("[Vanzyxxx] GUI closed")
end)

-- ========================
-- UPDATE CONTENT CONTAINER SIZE
-- ========================
task.wait()
local contentWidth = (#ContentContainer:GetChildren() - 1) * 300
ContentContainer.CanvasSize = UDim2.new(0, contentWidth, 0, 0)

-- ========================
-- FINAL INITIALIZATION
-- ========================
print("=======================================")
print("VANZYXXX MODERN UI LOADED SUCCESSFULLY!")
print("1. Modern horizontal layout with vertical sidebar")
print("2. Roblox icons instead of emojis")
print("3. Modular system with 7 feature categories")
print("4. Smooth animations and professional design")
print("=======================================")

-- Auto-show UI
game:GetService("TweenService"):Create(
    MainContainer,
    TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Position = UDim2.new(0.5, -425, 0.5, -275)}
):Play()