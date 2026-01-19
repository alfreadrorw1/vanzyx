-- ============================================
-- VANZYXXX ENHANCED ADMIN SCRIPT
-- Infinite Yield Inspired Features
-- Version: 2.1 - Professional Edition
-- ============================================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Player references
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = Workspace.CurrentCamera
local mouse = player:GetMouse()

-- Configuration
local scriptVersion = "2.1"
local scriptAuthor = "Vanzyxxx"
local adminPrefix = ";"
local commands = {}
local aliases = {}
local selectedPlayer = player
local selectedPlayers = {}
local isAdminMode = false
local flySpeed = 50
local walkSpeed = 16
local jumpPower = 50
local noclip = false
local clip = true
local infJump = false
local espEnabled = false
local boxes = {}
local tracers = {}
local nameTags = {}
local antiAfk = false
local clickTeleport = false
local autoFarm = false
local autoCollect = false
local serverHop = false
local antiKick = false
local antiBan = false
local autoRejoin = false
local loopKill = false
local loopTp = false
local loopTools = false
local aimbotEnabled = false
local silentAim = false
local triggerBot = false
local fovCircle
local aimbotFov = 50
local aimbotKey = Enum.UserInputType.MouseButton2
local aimbotTeamCheck = true
local aimbotWallCheck = true
local aimbotSmoothness = 0.1
local espTeamCheck = true
local espColor = Color3.fromRGB(0, 255, 0)
local espTransparency = 0.7
local espThickness = 1
local espFont = "Code"
local espFontSize = 14

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VanzyxxxAdmin"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create floating logo
local logoButton = Instance.new("ImageButton")
logoButton.Name = "LogoButton"
logoButton.Image = "https://files.catbox.moe/2znol1.jpg"
logoButton.Size = UDim2.new(0, 70, 0, 70)
logoButton.Position = UDim2.new(1, -80, 0.5, -35)
logoButton.AnchorPoint = Vector2.new(0.5, 0.5)
logoButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
logoButton.BackgroundTransparency = 0.5
logoButton.AutoButtonColor = false
logoButton.ImageTransparency = 0.2

-- Logo styling
local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 15)
logoCorner.Parent = logoButton

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(255, 50, 50)
logoStroke.Thickness = 3
logoStroke.Transparency = 0.3
logoStroke.Parent = logoButton

-- Logo glow effect
local logoGlow = Instance.new("ImageLabel")
logoGlow.Name = "LogoGlow"
logoGlow.Image = "rbxassetid://8992230677"
logoGlow.Size = UDim2.new(1.2, 0, 1.2, 0)
logoGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
logoGlow.AnchorPoint = Vector2.new(0.5, 0.5)
logoGlow.BackgroundTransparency = 1
logoGlow.ImageTransparency = 0.7
logoGlow.ImageColor3 = Color3.fromRGB(255, 50, 50)
logoGlow.ZIndex = -1
logoGlow.Parent = logoButton

-- Hover effect for logo
logoButton.MouseEnter:Connect(function()
    TweenService:Create(logoButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 80, 0, 80),
        BackgroundTransparency = 0.3,
        ImageTransparency = 0
    }):Play()
    TweenService:Create(logoGlow, TweenInfo.new(0.3), {
        ImageTransparency = 0.5
    }):Play()
end)

logoButton.MouseLeave:Connect(function()
    TweenService:Create(logoButton, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 70, 0, 70),
        BackgroundTransparency = 0.5,
        ImageTransparency = 0.2
    }):Play()
    TweenService:Create(logoGlow, TweenInfo.new(0.3), {
        ImageTransparency = 0.7
    }):Play()
end)

logoButton.Parent = screenGui

-- Main Admin Window
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 550)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true

-- Main frame styling
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 50, 50)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.3
mainStroke.Parent = mainFrame

-- Background effect
local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 15, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
})
bgGradient.Rotation = 45
bgGradient.Transparency = NumberSequence.new(0.9)
bgGradient.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12, 0, 0)
titleCorner.Parent = titleBar

-- Title text with glow
local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(0.7, 0, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "⚡ VANZYXXX ADMIN v" .. scriptVersion
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 18
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.TextStrokeTransparency = 0.5
titleText.TextStrokeColor3 = Color3.fromRGB(255, 50, 50)
titleText.Parent = titleBar

-- Subtitle
local subtitleText = Instance.new("TextLabel")
subtitleText.Name = "SubtitleText"
subtitleText.Size = UDim2.new(0.7, 0, 0, 20)
subtitleText.Position = UDim2.new(0, 15, 0, 25)
subtitleText.BackgroundTransparency = 1
subtitleText.Text = "Infinite Yield Inspired"
subtitleText.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitleText.TextSize = 12
subtitleText.Font = Enum.Font.Gotham
subtitleText.TextXAlignment = Enum.TextXAlignment.Left
subtitleText.Parent = titleBar

-- Control buttons container
local controlButtons = Instance.new("Frame")
controlButtons.Name = "ControlButtons"
controlButtons.Size = UDim2.new(0.3, 0, 1, 0)
controlButtons.Position = UDim2.new(0.7, 0, 0, 0)
controlButtons.BackgroundTransparency = 1
controlButtons.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(0.66, 0, 0.5, -15)
closeButton.AnchorPoint = Vector2.new(0.5, 0.5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BackgroundTransparency = 0.3
closeButton.Text = "×"
closeButton.TextColor3 = Color3.white
closeButton.TextSize = 24
closeButton.Font = Enum.Font.GothamBold
closeButton.AutoButtonColor = true

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    wait(0.3)
    mainFrame.Visible = false
    mainFrame.Size = UDim2.new(0, 450, 0, 550)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
end)

-- Minimize button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(0.33, 0, 0.5, -15)
minimizeButton.AnchorPoint = Vector2.new(0.5, 0.5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
minimizeButton.BackgroundTransparency = 0.3
minimizeButton.Text = "―"
minimizeButton.TextColor3 = Color3.white
minimizeButton.TextSize = 24
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.AutoButtonColor = true

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(1, 0)
minimizeCorner.Parent = minimizeButton

local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 450, 0, 45)
        }):Play()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 450, 0, 550)
        }):Play()
    end
end)

-- Pin button (keep on top)
local pinButton = Instance.new("TextButton")
pinButton.Name = "PinButton"
pinButton.Size = UDim2.new(0, 30, 0, 30)
pinButton.Position = UDim2.new(0, 0, 0.5, -15)
pinButton.AnchorPoint = Vector2.new(0.5, 0.5)
pinButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
pinButton.BackgroundTransparency = 0.3
pinButton.Text = "📌"
pinButton.TextColor3 = Color3.white
pinButton.TextSize = 16
pinButton.Font = Enum.Font.GothamBold
pinButton.AutoButtonColor = true

local pinCorner = Instance.new("UICorner")
pinCorner.CornerRadius = UDim.new(1, 0)
pinCorner.Parent = pinButton

local isPinned = false
pinButton.MouseButton1Click:Connect(function()
    isPinned = not isPinned
    if isPinned then
        screenGui.DisplayOrder = 999
        pinButton.BackgroundColor3 = Color3.fromRGB(255, 255, 50)
        pinButton.Text = "📍"
    else
        screenGui.DisplayOrder = 1
        pinButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        pinButton.Text = "📌"
    end
end)

closeButton.Parent = controlButtons
minimizeButton.Parent = controlButtons
pinButton.Parent = controlButtons
titleBar.Parent = mainFrame

-- Tab system
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, 0, 0, 40)
tabContainer.Position = UDim2.new(0, 0, 0, 45)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

-- Tabs
local tabs = {"Home", "Player", "World", "Combat", "Teleport", "Scripts"}
local tabButtons = {}
local tabFrames = {}

for i, tabName in ipairs(tabs) do
    -- Tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName .. "Tab"
    tabButton.Size = UDim2.new(1 / #tabs, 0, 1, 0)
    tabButton.Position = UDim2.new((i-1) / #tabs, 0, 0, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    tabButton.BackgroundTransparency = 0.5
    tabButton.Text = tabName
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.Gotham
    tabButton.AutoButtonColor = false
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 0)
    tabCorner.Parent = tabButton
    
    tabButton.Parent = tabContainer
    tabButtons[tabName] = tabButton
    
    -- Tab content frame
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = tabName .. "Frame"
    tabFrame.Size = UDim2.new(1, -20, 1, -90)
    tabFrame.Position = UDim2.new(0, 10, 0, 90)
    tabFrame.BackgroundTransparency = 1
    tabFrame.ScrollBarThickness = 5
    tabFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
    tabFrame.Visible = (i == 1)
    tabFrame.Parent = mainFrame
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 10)
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.Parent = tabFrame
    
    tabFrames[tabName] = tabFrame
    
    -- Tab click event
    tabButton.MouseButton1Click:Connect(function()
        for _, frame in pairs(tabFrames) do
            frame.Visible = false
        end
        for _, btn in pairs(tabButtons) do
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                TextColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
        end
        
        tabFrame.Visible = true
        TweenService:Create(tabButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 50, 50),
            TextColor3 = Color3.white
        }):Play()
    end)
end

-- Activate first tab
tabButtons["Home"].BackgroundColor3 = Color3.fromRGB(255, 50, 50)
tabButtons["Home"].TextColor3 = Color3.white

-- Content area
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, 0, 1, -85)
contentArea.Position = UDim2.new(0, 0, 0, 85)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

-- ========================
-- HOME TAB CONTENT
-- ========================
local homeFrame = tabFrames["Home"]

-- Welcome section
local welcomeSection = createSection("🎮 WELCOME TO VANZYXXX ADMIN", homeFrame)
welcomeSection.LayoutOrder = 1

local welcomeText = Instance.new("TextLabel")
welcomeText.Name = "WelcomeText"
welcomeText.Size = UDim2.new(1, -20, 0, 80)
welcomeText.Position = UDim2.new(0, 10, 0, 10)
welcomeText.BackgroundTransparency = 1
welcomeText.Text = "Infinite Yield inspired admin script\n\nPrefix: " .. adminPrefix .. "\nVersion: " .. scriptVersion .. "\nMade with ❤️ by " .. scriptAuthor
welcomeText.TextColor3 = Color3.fromRGB(220, 220, 220)
welcomeText.TextSize = 14
welcomeText.Font = Enum.Font.Gotham
welcomeText.TextXAlignment = Enum.TextXAlignment.Left
welcomeText.TextYAlignment = Enum.TextYAlignment.Top
welcomeText.Parent = welcomeSection

-- Quick Actions
local quickSection = createSection("⚡ QUICK ACTIONS", homeFrame)
quickSection.LayoutOrder = 2

local quickButtons = {
    {"🪽 FLY", Color3.fromRGB(0, 150, 255), toggleFly},
    {"👻 NOCLIP", Color3.fromRGB(150, 0, 255), toggleNoclip},
    {"⚡ SPEED", Color3.fromRGB(255, 150, 0), toggleSpeed},
    {"🔫 AIMBOT", Color3.fromRGB(255, 50, 50), toggleAimbot},
    {"📦 ESP", Color3.fromRGB(50, 255, 50), toggleESP},
    {"💾 SCRIPT HUB", Color3.fromRGB(255, 50, 150), openScriptHub}
}

local quickGrid = Instance.new("UIGridLayout")
quickGrid.CellPadding = UDim2.new(0, 10, 0, 10)
quickGrid.CellSize = UDim2.new(0.48, 0, 0, 40)
quickGrid.SortOrder = Enum.SortOrder.LayoutOrder
quickGrid.Parent = quickSection

for i, btnData in ipairs(quickButtons) do
    local btn = createButton(btnData[1], btnData[2], quickSection)
    btn.LayoutOrder = i
    btn.MouseButton1Click:Connect(btnData[3])
end

-- Status Panel
local statusSection = createSection("📊 SYSTEM STATUS", homeFrame)
statusSection.LayoutOrder = 3

local statusGrid = Instance.new("UIGridLayout")
statusGrid.CellPadding = UDim2.new(0, 10, 0, 5)
statusGrid.CellSize = UDim2.new(1, 0, 0, 25)
statusGrid.SortOrder = Enum.SortOrder.LayoutOrder
statusGrid.Parent = statusSection

local statusItems = {
    {"Player:", player.Name},
    {"FPS:", "60"},
    {"Ping:", "0ms"},
    {"Server Time:", os.date("%H:%M:%S")},
    {"Admin Mode:", isAdminMode and "ON" or "OFF"},
    {"Fly:", "OFF"},
    {"Noclip:", "OFF"},
    {"ESP:", "OFF"}
}

local statusLabels = {}
for i, item in ipairs(statusItems) do
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 25)
    container.BackgroundTransparency = 1
    container.LayoutOrder = i
    container.Parent = statusSection
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = item[1]
    label.TextColor3 = Color3.fromRGB(180, 180, 180)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local value = Instance.new("TextLabel")
    value.Size = UDim2.new(0.5, 0, 1, 0)
    value.Position = UDim2.new(0.5, 0, 0, 0)
    value.BackgroundTransparency = 1
    value.Text = item[2]
    value.TextColor3 = Color3.fromRGB(255, 255, 255)
    value.TextSize = 13
    value.Font = Enum.Font.GothamBold
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.Parent = container
    
    statusLabels[item[1]] = value
end

-- ========================
-- PLAYER TAB CONTENT
-- ========================
local playerFrame = tabFrames["Player"]

-- Player List
local playerListSection = createSection("👥 PLAYER LIST", playerFrame)
playerListSection.LayoutOrder = 1

local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Name = "PlayerScroll"
playerScroll.Size = UDim2.new(1, -20, 0, 200)
playerScroll.Position = UDim2.new(0, 10, 0, 10)
playerScroll.BackgroundTransparency = 1
playerScroll.ScrollBarThickness = 5
playerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playerScroll.Parent = playerListSection

local playerListLayout = Instance.new("UIListLayout")
playerListLayout.Padding = UDim.new(0, 5)
playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerListLayout.Parent = playerScroll

-- Player Controls
local playerControlsSection = createSection("🎮 PLAYER CONTROLS", playerFrame)
playerControlsSection.LayoutOrder = 2

local playerControlButtons = {
    {"KILL", Color3.fromRGB(255, 50, 50), function() killPlayer(selectedPlayer) end},
    {"KICK", Color3.fromRGB(255, 100, 50), function() kickPlayer(selectedPlayer) end},
    {"FREEZE", Color3.fromRGB(50, 150, 255), function() freezePlayer(selectedPlayer) end},
    {"THAW", Color3.fromRGB(50, 200, 150), function() thawPlayer(selectedPlayer) end},
    {"TELEPORT TO", Color3.fromRGB(150, 50, 255), function() teleportToPlayer(selectedPlayer) end},
    {"BRING", Color3.fromRGB(255, 150, 50), function() bringPlayer(selectedPlayer) end},
    {"GOD MODE", Color3.fromRGB(50, 255, 50), function() toggleGodMode(selectedPlayer) end},
    {"INVISIBLE", Color3.fromRGB(150, 150, 150), function() toggleInvisible(selectedPlayer) end}
}

local playerGrid = Instance.new("UIGridLayout")
playerGrid.CellPadding = UDim2.new(0, 10, 0, 10)
playerGrid.CellSize = UDim2.new(0.48, 0, 0, 40)
playerGrid.SortOrder = Enum.SortOrder.LayoutOrder
playerGrid.Parent = playerControlsSection

for i, btnData in ipairs(playerControlButtons) do
    local btn = createButton(btnData[1], btnData[2], playerControlsSection)
    btn.LayoutOrder = i
    btn.MouseButton1Click:Connect(btnData[3])
end

-- ========================
-- WORLD TAB CONTENT
-- ========================
local worldFrame = tabFrames["World"]

local worldControls = {
    {"REMOVE TOOLS", Color3.fromRGB(255, 50, 50), removeAllTools},
    {"CLEAR MAP", Color3.fromRGB(255, 100, 50), clearMap},
    {"LOW GFX", Color3.fromRGB(50, 150, 255), setLowGraphics},
    {"MAX GFX", Color3.fromRGB(150, 50, 255), setMaxGraphics},
    {"DAY", Color3.fromRGB(255, 255, 100), setDay},
    {"NIGHT", Color3.fromRGB(50, 50, 150), setNight},
    {"FOG ON", Color3.fromRGB(150, 150, 150), enableFog},
    {"FOG OFF", Color3.fromRGB(200, 200, 200), disableFog},
    {"GRAVITY LOW", Color3.fromRGB(100, 255, 100), lowGravity},
    {"GRAVITY HIGH", Color3.fromRGB(255, 100, 100), highGravity},
    {"EXPLODE ALL", Color3.fromRGB(255, 50, 50), explodeAll},
    {"FIRE ALL", Color3.fromRGB(255, 100, 50), fireAll}
}

local worldGrid = Instance.new("UIGridLayout")
worldGrid.CellPadding = UDim2.new(0, 10, 0, 10)
worldGrid.CellSize = UDim2.new(0.48, 0, 0, 40)
worldGrid.SortOrder = Enum.SortOrder.LayoutOrder
worldGrid.Parent = worldFrame

for i, btnData in ipairs(worldControls) do
    local btn = createButton(btnData[1], btnData[2], worldFrame)
    btn.LayoutOrder = i
    btn.MouseButton1Click:Connect(btnData[3])
end

-- ========================
-- COMBAT TAB CONTENT
-- ========================
local combatFrame = tabFrames["Combat"]

local combatControls = {
    {"AIMBOT ON", Color3.fromRGB(255, 50, 50), toggleAimbot},
    {"SILENT AIM", Color3.fromRGB(255, 100, 50), toggleSilentAim},
    {"TRIGGER BOT", Color3.fromRGB(255, 150, 50), toggleTriggerBot},
    {"AUTO SHOOT", Color3.fromRGB(255, 50, 100), toggleAutoShoot},
    {"INF AMMO", Color3.fromRGB(50, 255, 50), toggleInfiniteAmmo},
    {"NO RECOIL", Color3.fromRGB(100, 255, 100), toggleNoRecoil},
    {"RAPID FIRE", Color3.fromRGB(255, 255, 50), toggleRapidFire},
    {"INSTANT KILL", Color3.fromRGB(255, 50, 50), toggleInstantKill},
    {"WALLBANG", Color3.fromRGB(150, 50, 255), toggleWallbang},
    {"AUTO RELOAD", Color3.fromRGB(50, 150, 255), toggleAutoReload}
}

local combatGrid = Instance.new("UIGridLayout")
combatGrid.CellPadding = UDim2.new(0, 10, 0, 10)
combatGrid.CellSize = UDim2.new(0.48, 0, 0, 40)
combatGrid.SortOrder = Enum.SortOrder.LayoutOrder
combatGrid.Parent = combatFrame

for i, btnData in ipairs(combatControls) do
    local btn = createButton(btnData[1], btnData[2], combatFrame)
    btn.LayoutOrder = i
    btn.MouseButton1Click:Connect(btnData[3])
end

-- ========================
-- TELEPORT TAB CONTENT
-- ========================
local teleportFrame = tabFrames["Teleport"]

local teleportControls = {
    {"SPAWN", Color3.fromRGB(50, 150, 255), teleportToSpawn},
    {"BASE", Color3.fromRGB(100, 255, 100), teleportToBase},
    {"SECRET", Color3.fromRGB(255, 150, 50), teleportToSecret},
    {"UNDER MAP", Color3.fromRGB(255, 50, 150), teleportUnderMap},
    {"ABOVE MAP", Color3.fromRGB(150, 50, 255), teleportAboveMap},
    {"SAVE POS", Color3.fromRGB(255, 255, 50), savePosition},
    {"LOAD POS", Color3.fromRGB(50, 255, 255), loadPosition},
    {"WAYPOINT", Color3.fromRGB(255, 50, 50), setWaypoint}
}

local teleportGrid = Instance.new("UIGridLayout")
teleportGrid.CellPadding = UDim2.new(0, 10, 0, 10)
teleportGrid.CellSize = UDim2.new(0.48, 0, 0, 40)
teleportGrid.SortOrder = Enum.SortOrder.LayoutOrder
teleportGrid.Parent = teleportFrame

for i, btnData in ipairs(teleportControls) do
    local btn = createButton(btnData[1], btnData[2], teleportFrame)
    btn.LayoutOrder = i
    btn.MouseButton1Click:Connect(btnData[3])
end

-- ========================
-- SCRIPTS TAB CONTENT
-- ========================
local scriptsFrame = tabFrames["Scripts"]

local scriptButtons = {
    {"INFINITE YIELD", Color3.fromRGB(255, 50, 50), function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end},
    {"DEX EXPLORER", Color3.fromRGB(50, 150, 255), function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"))() end},
    {"REMOTE SPY", Color3.fromRGB(255, 150, 50), function() loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"))() end},
    {"CMD-X", Color3.fromRGB(50, 255, 50), function() loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source", true))() end},
    {"HOOHAA ADMIN", Color3.fromRGB(255, 50, 150), function() loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))() end},
    {"FATES ADMIN", Color3.fromRGB(150, 50, 255), function() loadstring(game:HttpGet("https://raw.githubusercontent.com/fatesc/fates-admin/main/main.lua"))() end},
    {"ORCA", Color3.fromRGB(50, 255, 255), function() loadstring(game:HttpGet("https://raw.githubusercontent.com/richie0866/orca/master/public/snapshot", true))() end},
    {"SYNAPSE X", Color3.fromRGB(255, 255, 50), function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Psx0/Synapse-X/master/source", true))() end) end}
}

local scriptsGrid = Instance.new("UIGridLayout")
scriptsGrid.CellPadding = UDim2.new(0, 10, 0, 10)
scriptsGrid.CellSize = UDim2.new(0.48, 0, 0, 40)
scriptsGrid.SortOrder = Enum.SortOrder.LayoutOrder
scriptsGrid.Parent = scriptsFrame

for i, btnData in ipairs(scriptButtons) do
    local btn = createButton(btnData[1], btnData[2], scriptsFrame)
    btn.LayoutOrder = i
    btn.MouseButton1Click:Connect(btnData[3])
end

-- Command Line at bottom
local commandBar = Instance.new("Frame")
commandBar.Name = "CommandBar"
commandBar.Size = UDim2.new(1, 0, 0, 50)
commandBar.Position = UDim2.new(0, 0, 1, -50)
commandBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
commandBar.BackgroundTransparency = 0.2
commandBar.Parent = mainFrame

local commandCorner = Instance.new("UICorner")
commandCorner.CornerRadius = UDim.new(0, 0, 0, 12)
commandCorner.Parent = commandBar

local prefixLabel = Instance.new("TextLabel")
prefixLabel.Name = "PrefixLabel"
prefixLabel.Size = UDim2.new(0, 30, 1, 0)
prefixLabel.BackgroundTransparency = 1
prefixLabel.Text = adminPrefix
prefixLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
prefixLabel.TextSize = 18
prefixLabel.Font = Enum.Font.GothamBold
prefixLabel.Parent = commandBar

local commandBox = Instance.new("TextBox")
commandBox.Name = "CommandBox"
commandBox.Size = UDim2.new(1, -80, 1, -10)
commandBox.Position = UDim2.new(0, 35, 0, 5)
commandBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
commandBox.BackgroundTransparency = 0.5
commandBox.Text = ""
commandBox.TextColor3 = Color3.white
commandBox.TextSize = 14
commandBox.Font = Enum.Font.Gotham
commandBox.PlaceholderText = "Type commands here..."
commandBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
commandBox.ClearTextOnFocus = false
commandBox.Parent = commandBar

local commandCorner2 = Instance.new("UICorner")
commandCorner2.CornerRadius = UDim.new(0, 8)
commandCorner2.Parent = commandBox

local executeButton = Instance.new("TextButton")
executeButton.Name = "ExecuteButton"
executeButton.Size = UDim2.new(0, 30, 0, 30)
executeButton.Position = UDim2.new(1, -35, 0.5, -15)
executeButton.AnchorPoint = Vector2.new(0.5, 0.5)
executeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
executeButton.BackgroundTransparency = 0.3
executeButton.Text = "▶"
executeButton.TextColor3 = Color3.white
executeButton.TextSize = 16
executeButton.Font = Enum.Font.GothamBold
executeButton.AutoButtonColor = true
executeButton.Parent = commandBar

local executeCorner = Instance.new("UICorner")
executeCorner.CornerRadius = UDim.new(1, 0)
executeCorner.Parent = executeButton

mainFrame.Parent = screenGui
mainFrame.Visible = false

-- Make window draggable
local dragging = false
local dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Logo toggle functionality
logoButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 450, 0, 550),
            Position = UDim2.new(0.5, -225, 0.5, -275)
        }):Play()
    end
    TweenService:Create(logoButton, TweenInfo.new(0.2), {
        Rotation = mainFrame.Visible and 360 or 0,
        BackgroundTransparency = mainFrame.Visible and 0.3 or 0.5
    }):Play()
end)

-- Helper functions
function createSection(title, parent)
    local section = Instance.new("Frame")
    section.Name = title:gsub("%s+", "") .. "Section"
    section.Size = UDim2.new(1, -20, 0, 0)
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    section.BackgroundTransparency = 0.5
    section.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = section
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 50, 50)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = section
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = section
    
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -20, 1, -40)
    content.Position = UDim2.new(0, 10, 0, 35)
    content.BackgroundTransparency = 1
    content.Parent = section
    
    return content
end

function createButton(text, color, parent)
    local button = Instance.new("TextButton")
    button.Name = text:gsub("%s+", "") .. "Button"
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = color
    button.BackgroundTransparency = 0.3
    button.Text = text
    button.TextColor3 = Color3.white
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.AutoButtonColor = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 2
    stroke.Transparency = 0.5
    stroke.Parent = button
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.1,
            Size = UDim2.new(1.02, 0, 1.05, 0)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.3,
            Size = UDim2.new(1, 0, 1, 0)
        }):Play()
    end)
    
    button.Parent = parent
    return button
end

-- Player list updater
function updatePlayerList()
    for _, child in ipairs(playerScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        local playerBtn = Instance.new("TextButton")
        playerBtn.Name = plr.Name
        playerBtn.Size = UDim2.new(1, 0, 0, 30)
        playerBtn.BackgroundColor3 = plr == selectedPlayer and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(40, 40, 45)
        playerBtn.BackgroundTransparency = 0.5
        playerBtn.Text = plr.Name .. (plr == player and " (YOU)" or "")
        playerBtn.TextColor3 = Color3.white
        playerBtn.TextSize = 13
        playerBtn.Font = Enum.Font.Gotham
        playerBtn.AutoButtonColor = true
        playerBtn.LayoutOrder = #playerScroll:GetChildren()
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = playerBtn
        
        playerBtn.MouseButton1Click:Connect(function()
            selectedPlayer = plr
            updatePlayerList()
        end)
        
        playerBtn.Parent = playerScroll
    end
    
    playerScroll.CanvasSize = UDim2.new(0, 0, 0, #playerScroll:GetChildren() * 35)
end

-- Command system
function registerCommand(cmd, func, alias)
    commands[cmd:lower()] = func
    if alias then
        for _, a in ipairs(alias) do
            aliases[a:lower()] = cmd:lower()
        end
    end
end

function executeCommand(cmd, args)
    local cmdLower = cmd:lower()
    local actualCmd = aliases[cmdLower] or cmdLower
    
    if commands[actualCmd] then
        pcall(commands[actualCmd], args)
        return true
    end
    return false
end

-- Basic commands (Infinite Yield style)
registerCommand("fly", function(args)
    toggleFly()
end, {"f", "flight"})

registerCommand("noclip", function(args)
    toggleNoclip()
end, {"nc", "ghost"})

registerCommand("clip", function(args)
    clip = not clip
    sendNotification("Clip: " .. (clip and "ON" or "OFF"))
end)

registerCommand("speed", function(args)
    if args and args[1] then
        local speed = tonumber(args[1])
        if speed then
            walkSpeed = speed
            humanoid.WalkSpeed = speed
            sendNotification("Speed set to " .. speed)
        end
    else
        sendNotification("Current speed: " .. walkSpeed)
    end
end, {"ws", "walkspeed"})

registerCommand("jumppower", function(args)
    if args and args[1] then
        local power = tonumber(args[1])
        if power then
            jumpPower = power
            humanoid.JumpPower = power
            sendNotification("Jump power set to " .. power)
        end
    else
        sendNotification("Current jump power: " .. jumpPower)
    end
end, {"jp", "jump"})

registerCommand("goto", function(args)
    if args and args[1] then
        local target = findPlayer(args[1])
        if target then
            teleportToPlayer(target)
        end
    end
end, {"tp", "teleport"})

registerCommand("bring", function(args)
    if args and args[1] then
        local target = findPlayer(args[1])
        if target then
            bringPlayer(target)
        end
    end
end, {"summon"})

registerCommand("kill", function(args)
    if args and args[1] then
        local target = findPlayer(args[1])
        if target then
            killPlayer(target)
        end
    end
end, {"k"})

registerCommand("kick", function(args)
    if args and args[1] then
        local target = findPlayer(args[1])
        if target then
            kickPlayer(target)
        end
    end
end)

registerCommand("freeze", function(args)
    if args and args[1] then
        local target = findPlayer(args[1])
        if target then
            freezePlayer(target)
        end
    end
end, {"fr"})

registerCommand("thaw", function(args)
    if args and args[1] then
        local target = findPlayer(args[1])
        if target then
            thawPlayer(target)
        end
    end
end, {"unfreeze", "melt"})

registerCommand("esp", function(args)
    toggleESP()
end, {"boxesp", "boxes"})

registerCommand("aimbot", function(args)
    toggleAimbot()
end, {"aim", "ab"})

registerCommand("rejoin", function(args)
    TeleportService:Teleport(game.PlaceId, player)
end, {"rj"})

registerCommand("serverhop", function(args)
    serverHop = true
    hopServer()
end, {"hop", "sh"})

registerCommand("antiafk", function(args)
    antiAfk = not antiAfk
    sendNotification("Anti-AFK: " .. (antiAfk and "ON" or "OFF"))
end, {"afk"})

registerCommand("infinitejump", function(args)
    infJump = not infJump
    sendNotification("Infinite Jump: " .. (infJump and "ON" or "OFF"))
end, {"ij", "infjump"})

registerCommand("clicktp", function(args)
    clickTeleport = not clickTeleport
    sendNotification("Click TP: " .. (clickTeleport and "ON" or "OFF"))
end, {"ctp"})

registerCommand("godmode", function(args)
    if args and args[1] then
        local target = findPlayer(args[1])
        if target then
            toggleGodMode(target)
        end
    else
        toggleGodMode(player)
    end
end, {"god"})

registerCommand("invisible", function(args)
    if args and args[1] then
        local target = findPlayer(args[1])
        if target then
            toggleInvisible(target)
        end
    else
        toggleInvisible(player)
    end
end, {"invis", "vanish"})

registerCommand("tools", function(args)
    giveAllTools()
end, {"alltools", "givetools"})

registerCommand("gear", function(args)
    giveAllGear()
end, {"allgear", "givegear"})

registerCommand("refresh", function(args)
    character:BreakJoints()
end, {"respawn", "re"})

registerCommand("day", function(args)
    setDay()
end)

registerCommand("night", function(args)
    setNight()
end)

registerCommand("time", function(args)
    if args and args[1] then
        local time = tonumber(args[1])
        if time then
            Lighting.ClockTime = time
        end
    end
end)

registerCommand("fog", function(args)
    if args and args[1] == "on" then
        enableFog()
    elseif args and args[1] == "off" then
        disableFog()
    else
        Lighting.FogEnd = 100000
    end
end)

registerCommand("gravity", function(args)
    if args and args[1] then
        local grav = tonumber(args[1])
        if grav then
            Workspace.Gravity = grav
        end
    end
end, {"grav"})

registerCommand("explode", function(args)
    if args and args[1] then
        local target = findPlayer(args[1])
        if target then
            explodePlayer(target)
        end
    else
        explodeAll()
    end
end, {"boom"})

registerCommand("fire", function(args)
    if args and args[1] then
        local target = findPlayer(args[1])
        if target then
            firePlayer(target)
        end
    else
        fireAll()
    end
end, {"burn"})

registerCommand("unfire", function(args)
    removeAllFire()
end, {"extinguish"})

registerCommand("sit", function(args)
    humanoid.Sit = true
end)

registerCommand("unsit", function(args)
    humanoid.Sit = false
end, {"stand"})

registerCommand("loopkill", function(args)
    if args and args[1] then
        local target = findPlayer(args[1])
        if target then
            loopKill = not loopKill
            if loopKill then
                spawn(function()
                    while loopKill do
                        killPlayer(target)
                        wait(1)
                    end
                end)
            end
        end
    end
end, {"lk"})

registerCommand("looptp", function(args)
    if args and args[1] then
        local target = findPlayer(args[1])
        if target then
            loopTp = not loopTp
            if loopTp then
                spawn(function()
                    while loopTp do
                        teleportToPlayer(target)
                        wait(0.1)
                    end
                end)
            end
        end
    end
end, {"ltp"})

registerCommand("fling", function(args)
    if args and args[1] then
        local target = findPlayer(args[1])
        if target then
            flingPlayer(target)
        end
    end
end, {"yeet"})

registerCommand("spin", function(args)
    local speed = args and tonumber(args[1]) or 50
    spinCharacter(speed)
end)

registerCommand("unspin", function(args)
    unspinCharacter()
end, {"stopspin"})

registerCommand("size", function(args)
    if args and args[1] then
        local scale = tonumber(args[1]) or 1
        resizeCharacter(scale)
    end
end, {"scale"})

registerCommand("normalize", function(args)
    resizeCharacter(1)
end, {"normal", "resetsize"})

registerCommand("headless", function(args)
    toggleHeadless()
end)

registerCommand("blockhead", function(args)
    giveBlockHead()
end, {"cubehead"})

registerCommand("dog", function(args)
    becomeDog()
end, {"woof"})

registerCommand("cat", function(args)
    becomeCat()
end, {"meow"})

registerCommand("reset", function(args)
    resetCharacter()
end, {"normalchar"})

registerCommand("void", function(args)
    teleportToVoid()
end, {"abyss"})

registerCommand("ambient", function(args)
    if args and #args >= 3 then
        local r, g, b = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
        if r and g and b then
            Lighting.Ambient = Color3.fromRGB(r, g, b)
        end
    end
end)

registerCommand("brightness", function(args)
    if args and args[1] then
        local bright = tonumber(args[1])
        if bright then
            Lighting.Brightness = bright
        end
    end
end, {"bright"})

registerCommand("clear", function(args)
    clearChat()
end, {"cls", "clearchat"})

registerCommand("help", function(args)
    showHelp()
end, {"cmds", "commands"})

-- Command execution from textbox
executeButton.MouseButton1Click:Connect(function()
    local text = commandBox.Text
    if text == "" then return end
    
    commandBox.Text = ""
    
    local args = {}
    for arg in text:gmatch("%S+") do
        table.insert(args, arg)
    end
    
    if #args > 0 then
        local cmd = table.remove(args, 1)
        if cmd:sub(1, #adminPrefix) == adminPrefix then
            cmd = cmd:sub(#adminPrefix + 1)
        end
        
        if not executeCommand(cmd, args) then
            sendNotification("Unknown command: " .. cmd, Color3.fromRGB(255, 50, 50))
        end
    end
end)

commandBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        executeButton.MouseButton1Click:Connect()
    end
end)

-- Chat listener for prefix commands
local chatHook
pcall(function()
    local chatBar = player:WaitForChild("PlayerGui"):WaitForChild("Chat"):WaitForChild("Frame").ChatBarParentFrame.Frame.BoxFrame.Frame.TextBox
    chatHook = chatBar:GetPropertyChangedSignal("Text"):Connect(function()
        local text = chatBar.Text
        if text:sub(1, #adminPrefix) == adminPrefix then
            chatBar.Text = ""
            
            local args = {}
            for arg in text:gmatch("%S+") do
                table.insert(args, arg)
            end
            
            if #args > 0 then
                local cmd = table.remove(args, 1):sub(#adminPrefix + 1)
                executeCommand(cmd, args)
            end
        end
    end)
end)

-- Feature implementations
function sendNotification(message, color)
    color = color or Color3.fromRGB(255, 50, 50)
    
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 60)
    notif.Position = UDim2.new(1, 10, 1, -70)
    notif.AnchorPoint = Vector2.new(1, 1)
    notif.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    notif.BackgroundTransparency = 0.2
    notif.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 2
    stroke.Parent = notif
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, -20)
    label.Position = UDim2.new(0, 10, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = Color3.white
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextWrapped = true
    label.Parent = notif
    
    TweenService:Create(notif, TweenInfo.new(0.3), {
        Position = UDim2.new(1, -10, 1, -70)
    }):Play()
    
    wait(3)
    
    TweenService:Create(notif, TweenInfo.new(0.3), {
        Position = UDim2.new(1, 10, 1, -70)
    }):Play()
    wait(0.3)
    notif:Destroy()
end

function findPlayer(name)
    name = name:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Name:lower():find(name) == 1 or plr.DisplayName:lower():find(name) == 1 then
            return plr
        end
    end
    return nil
end

function toggleFly()
    -- Fly implementation from previous script
    sendNotification("Fly feature coming soon!", Color3.fromRGB(255, 150, 50))
end

function toggleNoclip()
    noclip = not noclip
    sendNotification("Noclip: " .. (noclip and "ON" or "OFF"))
    statusLabels["Noclip:"].Text = noclip and "ON" or "OFF"
end

function toggleSpeed()
    local newSpeed = walkSpeed == 16 and 100 or 16
    walkSpeed = newSpeed
    humanoid.WalkSpeed = newSpeed
    sendNotification("Speed: " .. newSpeed)
end

function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    sendNotification("Aimbot: " .. (aimbotEnabled and "ON" or "OFF"))
    statusLabels["Aimbot:"].Text = aimbotEnabled and "ON" or "OFF"
end

function toggleESP()
    espEnabled = not espEnabled
    sendNotification("ESP: " .. (espEnabled and "ON" or "OFF"))
    statusLabels["ESP:"].Text = espEnabled and "ON" or "OFF"
end

function openScriptHub()
    sendNotification("Opening Script Hub...")
    -- Could open another GUI with more scripts
end

function killPlayer(target)
    if target.Character then
        target.Character:BreakJoints()
        sendNotification("Killed " .. target.Name)
    end
end

function kickPlayer(target)
    -- This would require server-side access
    sendNotification("Cannot kick " .. target.Name .. " (client-side only)")
end

function freezePlayer(target)
    if target.Character then
        local humanoid = target.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
            sendNotification("Froze " .. target.Name)
        end
    end
end

function thawPlayer(target)
    if target.Character then
        local humanoid = target.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
            sendNotification("Thawed " .. target.Name)
        end
    end
end

function teleportToPlayer(target)
    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        rootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        sendNotification("Teleported to " .. target.Name)
    end
end

function bringPlayer(target)
    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        target.Character.HumanoidRootPart.CFrame = rootPart.CFrame
        sendNotification("Brought " .. target.Name)
    end
end

function toggleGodMode(target)
    if target.Character then
        local humanoid = target.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            sendNotification("God mode for " .. target.Name)
        end
    end
end

function toggleInvisible(target)
    if target.Character then
        for _, part in ipairs(target.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = part.Transparency == 1 and 0 or 1
            end
        end
        sendNotification("Invisibility toggled for " .. target.Name)
    end
end

-- Initialize player list
updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Anti-AFK
if antiAfk then
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if infJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Click Teleport
if clickTeleport then
    mouse.Button1Down:Connect(function()
        if mouse.Target then
            rootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 5, 0))
        end
    end)
end

-- Noclip loop
RunService.Stepped:Connect(function()
    if noclip and character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- FPS counter
local fps = 0
local lastTime = tick()
RunService.RenderStepped:Connect(function()
    fps = math.floor(1 / (tick() - lastTime))
    lastTime = tick()
    if statusLabels["FPS:"] then
        statusLabels["FPS:"].Text = fps
    end
end)

-- Update time
spawn(function()
    while true do
        if statusLabels["Server Time:"] then
            statusLabels["Server Time:"].Text = os.date("%H:%M:%S")
        end
        wait(1)
    end
end)

-- Send welcome message
sendNotification("⚡ Vanzyxxx Admin v" .. scriptVersion .. " Loaded!\nPrefix: " .. adminPrefix .. "\nType " .. adminPrefix .. "help for commands", Color3.fromRGB(255, 50, 50))

print("============================================")
print("⚡ VANZYXXX ADMIN v" .. scriptVersion)
print("Infinite Yield Inspired")
print("Prefix: " .. adminPrefix)
print("Type " .. adminPrefix .. "help for commands")
print("============================================")