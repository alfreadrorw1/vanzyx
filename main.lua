-- Vanzyxxx Mobile Executor - UI Horizontal
-- Automatically shows menu on execution

if not game:GetService("RunService"):IsClient() then
    return
end

-- Prevent duplicate execution
if _G.VanzyxxxMobileLoaded then
    print("[Vanzyxxx] Script already loaded!")
    return
end
_G.VanzyxxxMobileLoaded = true

print("[Vanzyxxx] Starting mobile executor...")

-- Services
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Wait for player
repeat task.wait() until plr
repeat task.wait() until plr.PlayerGui

print("[Vanzyxxx] Player loaded!")

-- ========================
-- MODULE LOADER
-- ========================
local Modules = {}
local function loadModule(name)
    if Modules[name] then return Modules[name] end
    
    -- In production, load from GitHub
    -- local url = "https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/" .. name
    -- local success, module = pcall(function()
    --     return loadstring(game:HttpGet(url))()
    -- end)
    
    -- For now, load from local modules folder
    local module = require(script:WaitForChild("Modules"):WaitForChild(name:gsub(".lua", "")))
    Modules[name] = module
    return module
end

-- ========================
-- CREATE MAIN UI (HORIZONTAL LAYOUT)
-- ========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VanzyxxxMobile"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = plr:WaitForChild("PlayerGui")

-- Main Container (Horizontal)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainContainer"
MainFrame.Size = UDim2.new(0.8, 0, 0.7, 0)
MainFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

-- Make draggable
local dragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Styling
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.03, 0)
corner.Parent = MainFrame

local shadow = Instance.new("UIStroke")
shadow.Color = Color3.fromRGB(0, 0, 0)
shadow.Thickness = 2
shadow.Transparency = 0.7
shadow.Parent = MainFrame

-- Header Bar
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 50)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Header.Parent = MainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0.03, 0)
headerCorner.Parent = Header

-- Logo
local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 40, 0, 40)
Logo.Position = UDim2.new(0, 10, 0, 5)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://6764432408"
Logo.Parent = Header

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "VANZYXXX MOBILE"
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0.1, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(100, 150, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseButton"
CloseBtn.Text = "✕"
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = Header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.2, 0)
closeCorner.Parent = CloseBtn

-- ========================
-- SIDEBAR & PANEL LAYOUT
-- ========================
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, 0, 1, -50)
ContentArea.Position = UDim2.new(0, 0, 0, 50)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

-- Left Sidebar (30%)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0.3, 0, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
Sidebar.Parent = ContentArea

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0.02, 0)
sidebarCorner.Parent = Sidebar

-- Right Panel (70%)
local RightPanel = Instance.new("Frame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(0.7, 0, 1, 0)
RightPanel.Position = UDim2.new(0.3, 0, 0, 0)
RightPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
RightPanel.Parent = ContentArea

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0.02, 0)
panelCorner.Parent = RightPanel

-- ========================
-- SIDEBAR BUTTONS
-- ========================
local SidebarButtons = {
    {Name = "🏃 AUTO OBBY", Icon = "🏃", Module = "obby.lua"},
    {Name = "📍 CHECKPOINT", Icon = "📍", Module = "cekpoint.lua"},
    {Name = "👤 TELEPORT", Icon = "👤", Module = "teleportplayers.lua"},
    {Name = "✈️ FLY", Icon = "✈️", Module = "fly.lua"}
}

local buttonY = 10
local selectedButton = nil

local function createSidebarButton(info, index)
    local button = Instance.new("TextButton")
    button.Name = "Btn_" .. info.Name
    button.Text = "   " .. info.Icon .. " " .. info.Name
    button.Size = UDim2.new(0.9, 0, 0, 45)
    button.Position = UDim2.new(0.05, 0, 0, buttonY)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    button.TextColor3 = Color3.fromRGB(200, 200, 220)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.AutoButtonColor = true
    button.Parent = Sidebar
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0.08, 0)
    buttonCorner.Parent = button
    
    -- Highlight effect
    local highlight = Instance.new("Frame")
    highlight.Name = "Highlight"
    highlight.Size = UDim2.new(0.03, 0, 0.7, 0)
    highlight.Position = UDim2.new(0, 5, 0.15, 0)
    highlight.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    highlight.Visible = false
    highlight.Parent = button
    
    local highlightCorner = Instance.new("UICorner")
    highlightCorner.CornerRadius = UDim.new(1, 0)
    highlightCorner.Parent = highlight
    
    button.MouseButton1Click:Connect(function()
        -- Deselect previous
        if selectedButton then
            selectedButton.Highlight.Visible = false
            selectedButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        end
        
        -- Select current
        selectedButton = button
        button.Highlight.Visible = true
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
        
        -- Load module and show in right panel
        loadModule(info.Module)
        
        -- Show module UI in right panel
        print("Loading module:", info.Module)
        -- Module-specific UI will be created here
    end)
    
    buttonY = buttonY + 50
    return button
end

-- Create all sidebar buttons
local buttons = {}
for i, info in ipairs(SidebarButtons) do
    local btn = createSidebarButton(info, i)
    buttons[i] = btn
end

-- ========================
-- RIGHT PANEL CONTENT MANAGER
-- ========================
local function clearRightPanel()
    for _, child in ipairs(RightPanel:GetChildren()) do
        if child.Name ~= "UICorner" then
            child:Destroy()
        end
    end
end

local function showTitle(title)
    clearRightPanel()
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "PanelTitle"
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.Position = UDim2.new(0, 0, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.Parent = RightPanel
end

-- ========================
-- MODULE UI LOADERS
-- ========================
local ModuleUI = {}

ModuleUI["obby.lua"] = function()
    showTitle("🏃 AUTO OBBY RUN")
    
    -- Control buttons
    local buttonY = 60
    local buttons = {
        {Text = "▶️ START", Color = Color3.fromRGB(50, 180, 80)},
        {Text = "⏸️ PAUSE", Color = Color3.fromRGB(220, 180, 50)},
        {Text = "⏹️ STOP", Color = Color3.fromRGB(220, 80, 80)},
        {Text = "🔄 RESUME", Color = Color3.fromRGB(50, 120, 220)}
    }
    
    for _, btnInfo in ipairs(buttons) do
        local btn = Instance.new("TextButton")
        btn.Text = btnInfo.Text
        btn.Size = UDim2.new(0.9, 0, 0, 45)
        btn.Position = UDim2.new(0.05, 0, 0, buttonY)
        btn.BackgroundColor3 = btnInfo.Color
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.Parent = RightPanel
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.1, 0)
        corner.Parent = btn
        
        buttonY = buttonY + 55
    end
    
    -- Status label
    local status = Instance.new("TextLabel")
    status.Text = "Status: READY"
    status.Size = UDim2.new(0.9, 0, 0, 30)
    status.Position = UDim2.new(0.05, 0, 0, buttonY + 10)
    status.BackgroundTransparency = 1
    status.TextColor3 = Color3.fromRGB(100, 255, 100)
    status.Font = Enum.Font.Gotham
    status.TextSize = 14
    status.Parent = RightPanel
end

ModuleUI["cekpoint.lua"] = function()
    showTitle("📍 CHECKPOINT SELECTOR")
    
    -- Search bar
    local searchBox = Instance.new("TextBox")
    searchBox.PlaceholderText = "Search checkpoints..."
    searchBox.Size = UDim2.new(0.9, 0, 0, 35)
    searchBox.Position = UDim2.new(0.05, 0, 0, 60)
    searchBox.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 14
    searchBox.Parent = RightPanel
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0.1, 0)
    searchCorner.Parent = searchBox
    
    -- Refresh button
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Text = "🔄 REFRESH"
    refreshBtn.Size = UDim2.new(0.9, 0, 0, 40)
    refreshBtn.Position = UDim2.new(0.05, 0, 0, 105)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.TextSize = 14
    refreshBtn.Parent = RightPanel
    
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0.1, 0)
    refreshCorner.Parent = refreshBtn
    
    -- Checkpoints list (scrollable)
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(0.9, 0, 0, 200)
    scrollFrame.Position = UDim2.new(0.05, 0, 0, 155)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = RightPanel
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0.1, 0)
    scrollCorner.Parent = scrollFrame
end

ModuleUI["teleportplayers.lua"] = function()
    showTitle("👤 TELEPORT PLAYERS")
    
    -- Mode selector
    local modeFrame = Instance.new("Frame")
    modeFrame.Size = UDim2.new(0.9, 0, 0, 40)
    modeFrame.Position = UDim2.new(0.05, 0, 0, 60)
    modeFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    modeFrame.Parent = RightPanel
    
    local modeCorner = Instance.new("UICorner")
    modeCorner.CornerRadius = UDim.new(0.1, 0)
    modeCorner.Parent = modeFrame
    
    local mode1 = Instance.new("TextButton")
    mode1.Text = "Player → Me"
    mode1.Size = UDim2.new(0.48, 0, 0.9, 0)
    mode1.Position = UDim2.new(0.01, 0, 0.05, 0)
    mode1.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
    mode1.TextColor3 = Color3.fromRGB(255, 255, 255)
    mode1.Font = Enum.Font.GothamBold
    mode1.TextSize = 12
    mode1.Parent = modeFrame
    
    local mode2 = Instance.new("TextButton")
    mode2.Text = "Me → Player"
    mode2.Size = UDim2.new(0.48, 0, 0.9, 0)
    mode2.Position = UDim2.new(0.51, 0, 0.05, 0)
    mode2.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    mode2.TextColor3 = Color3.fromRGB(200, 200, 220)
    mode2.Font = Enum.Font.GothamBold
    mode2.TextSize = 12
    mode2.Parent = modeFrame
    
    -- Search
    local searchBox = Instance.new("TextBox")
    searchBox.PlaceholderText = "Search players..."
    searchBox.Size = UDim2.new(0.9, 0, 0, 35)
    searchBox.Position = UDim2.new(0.05, 0, 0, 110)
    searchBox.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 14
    searchBox.Parent = RightPanel
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0.1, 0)
    searchCorner.Parent = searchBox
    
    -- Teleport button
    local teleportBtn = Instance.new("TextButton")
    teleportBtn.Text = "📤 TELEPORT SELECTED"
    teleportBtn.Size = UDim2.new(0.9, 0, 0, 45)
    teleportBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
    teleportBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
    teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportBtn.Font = Enum.Font.GothamBold
    teleportBtn.TextSize = 16
    teleportBtn.Parent = RightPanel
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0.1, 0)
    btnCorner.Parent = teleportBtn
end

ModuleUI["fly.lua"] = function()
    showTitle("✈️ FLY SYSTEM")
    
    -- Toggle button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Text = "✈️ ENABLE FLY"
    toggleBtn.Size = UDim2.new(0.9, 0, 0, 50)
    toggleBtn.Position = UDim2.new(0.05, 0, 0, 60)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 16
    toggleBtn.Parent = RightPanel
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0.1, 0)
    btnCorner.Parent = toggleBtn
    
    -- Speed control
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Text = "Speed: 50"
    speedLabel.Size = UDim2.new(0.9, 0, 0, 30)
    speedLabel.Position = UDim2.new(0.05, 0, 0, 120)
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextSize = 14
    speedLabel.Parent = RightPanel
    
    local speedSlider = Instance.new("Frame")
    speedSlider.Size = UDim2.new(0.9, 0, 0, 20)
    speedSlider.Position = UDim2.new(0.05, 0, 0, 150)
    speedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    speedSlider.Parent = RightPanel
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0.5, 0)
    sliderCorner.Parent = speedSlider
    
    -- Vertical controls
    local upBtn = Instance.new("TextButton")
    upBtn.Text = "⬆️ UP"
    upBtn.Size = UDim2.new(0.4, 0, 0, 40)
    upBtn.Position = UDim2.new(0.05, 0, 0, 180)
    upBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    upBtn.Font = Enum.Font.GothamBold
    upBtn.TextSize = 14
    upBtn.Parent = RightPanel
    
    local downBtn = Instance.new("TextButton")
    downBtn.Text = "⬇️ DOWN"
    downBtn.Size = UDim2.new(0.4, 0, 0, 40)
    downBtn.Position = UDim2.new(0.55, 0, 0, 180)
    downBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    downBtn.Font = Enum.Font.GothamBold
    downBtn.TextSize = 14
    downBtn.Parent = RightPanel
    
    local controlCorner = Instance.new("UICorner")
    controlCorner.CornerRadius = UDim.new(0.1, 0)
    controlCorner.Parent = upBtn
    controlCorner:Clone().Parent = downBtn
end

-- ========================
-- EVENT HANDLERS
-- ========================
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    _G.VanzyxxxMobileLoaded = false
    print("[Vanzyxxx] Menu closed")
end)

-- Auto-select first button on load
task.wait(0.5)
if buttons[1] then
    buttons[1]:MouseButton1Click()
end

print("=======================================")
print("VANZYXXX MOBILE EXECUTOR LOADED!")
print("UI Layout: Horizontal Sidebar + Panel")
print("Modules: Auto Obby, Checkpoint, Teleport, Fly")
print("=======================================")