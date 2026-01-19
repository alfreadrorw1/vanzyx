--[[
    DELTA EXECUTOR - SIMPLE VERSION
    Guaranteed to show UI
--]]

-- Tunggu game load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Tunggu player
local Players = game:GetService("Players")
local player = Players.LocalPlayer
repeat wait() until player

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Buat ScreenGui langsung
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaExecutorUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

-- Main Container - PASTIKAN VISIBLE
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(0, 500, 0, 350)
MainContainer.Position = UDim2.new(0.5, -250, 0.5, -175)
MainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
MainContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainContainer.BackgroundTransparency = 0
MainContainer.BorderSizePixel = 0
MainContainer.Visible = true
MainContainer.Active = true
MainContainer.Selectable = true

-- Corner
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainContainer

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
Header.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

-- Logo & Title Section
local LogoFrame = Instance.new("Frame")
LogoFrame.Name = "LogoFrame"
LogoFrame.Size = UDim2.new(0.6, 0, 1, 0)
LogoFrame.BackgroundTransparency = 1

-- Logo
local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 32, 0, 32)
Logo.Position = UDim2.new(0, 10, 0.5, -16)
Logo.AnchorPoint = Vector2.new(0, 0.5)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://10734964822"
Logo.ImageColor3 = Color3.fromRGB(0, 170, 255)

-- Title dengan teks yang Anda inginkan
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 0, 30)
Title.Position = UDim2.new(0, 50, 0.5, -15)
Title.AnchorPoint = Vector2.new(0, 0.5)
Title.BackgroundTransparency = 1
Title.Text = "Blue Panther | 65\nEXP Mx.Vanzyxxx\n@AlfredR0rw"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 10
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.RichText = true
Title.TextYAlignment = Enum.TextYAlignment.Top

Logo.Parent = LogoFrame
Title.Parent = LogoFrame
LogoFrame.Parent = Header

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.AnchorPoint = Vector2.new(1, 0.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.white
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
CloseButton.Parent = Header

Header.Parent = MainContainer

-- Content Area
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, 0, 1, -40)
Content.Position = UDim2.new(0, 0, 0, 40)
Content.BackgroundTransparency = 1

-- Sidebar (30%)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0.3, 0, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)

local SidebarButtons = Instance.new("ScrollingFrame")
SidebarButtons.Name = "SidebarButtons"
SidebarButtons.Size = UDim2.new(1, -5, 1, -10)
SidebarButtons.Position = UDim2.new(0, 5, 0, 5)
SidebarButtons.BackgroundTransparency = 1
SidebarButtons.ScrollBarThickness = 3
SidebarButtons.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)

local ButtonsLayout = Instance.new("UIListLayout")
ButtonsLayout.Padding = UDim.new(0, 5)
ButtonsLayout.Parent = SidebarButtons

SidebarButtons.Parent = Sidebar
Sidebar.Parent = Content

-- Right Panel (70%)
local RightPanel = Instance.new("Frame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(0.7, 0, 1, 0)
RightPanel.Position = UDim2.new(0.3, 0, 0, 0)
RightPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 35)

local PanelContent = Instance.new("ScrollingFrame")
PanelContent.Name = "PanelContent"
PanelContent.Size = UDim2.new(1, -10, 1, -10)
PanelContent.Position = UDim2.new(0, 5, 0, 5)
PanelContent.BackgroundTransparency = 1
PanelContent.ScrollBarThickness = 4
PanelContent.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)

local PanelLayout = Instance.new("UIListLayout")
PanelLayout.Padding = UDim.new(0, 8)
PanelLayout.Parent = PanelContent

PanelContent.Parent = RightPanel
RightPanel.Parent = Content
Content.Parent = MainContainer

-- Function untuk buat button sidebar
local function createSideButton(name, icon)
    local button = Instance.new("TextButton")
    button.Name = name .. "Btn"
    button.Size = UDim2.new(1, 0, 0, 45)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    button.Text = ""
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    local iconImg = Instance.new("ImageLabel")
    iconImg.Name = "Icon"
    iconImg.Size = UDim2.new(0, 20, 0, 20)
    iconImg.Position = UDim2.new(0, 10, 0.5, -10)
    iconImg.AnchorPoint = Vector2.new(0, 0.5)
    iconImg.BackgroundTransparency = 1
    iconImg.Image = icon
    iconImg.ImageColor3 = Color3.fromRGB(150, 150, 170)
    iconImg.Parent = button
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 35, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = button
    
    local highlight = Instance.new("Frame")
    highlight.Name = "Highlight"
    highlight.Size = UDim2.new(0, 3, 0.7, 0)
    highlight.Position = UDim2.new(0, 0, 0.15, 0)
    highlight.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    highlight.Visible = false
    highlight.Parent = button
    
    return button
end

-- Function untuk clear panel
local function clearPanel()
    for _, child in ipairs(PanelContent:GetChildren()) do
        if child:IsA("GuiObject") and child.Name ~= "PanelLayout" then
            child:Destroy()
        end
    end
    PanelContent.CanvasSize = UDim2.new(0, 0, 0, 0)
end

-- Function untuk load module langsung (inline)
local function loadModule(name)
    clearPanel()
    
    -- Update button highlight
    for _, child in ipairs(SidebarButtons:GetChildren()) do
        if child:IsA("TextButton") then
            child.Highlight.Visible = child.Name == name .. "Btn"
            child.BackgroundColor3 = child.Highlight.Visible and Color3.fromRGB(60, 60, 75) or Color3.fromRGB(45, 45, 55)
        end
    end
    
    -- Tampilkan module content
    local title = Instance.new("TextLabel")
    title.Name = "ModuleTitle"
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    title.TextColor3 = Color3.fromRGB(0, 170, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Text = name:upper()
    title.TextXAlignment = Enum.TextXAlignment.Center
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = title
    
    title.Parent = PanelContent
    
    -- Tambahkan konten berdasarkan module
    if name == "Auto Obby" then
        -- Auto Obby content
        local info = Instance.new("TextLabel")
        info.Name = "Info"
        info.Size = UDim2.new(1, -20, 0, 100)
        info.Position = UDim2.new(0, 10, 0, 60)
        info.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        info.TextColor3 = Color3.fromRGB(200, 200, 220)
        info.TextSize = 14
        info.Font = Enum.Font.Gotham
        info.Text = "• Auto detect checkpoints\n• Auto run & jump\n• Anti-stuck system\n• Start/Pause/Resume/Stop"
        info.TextXAlignment = Enum.TextXAlignment.Left
        info.TextYAlignment = Enum.TextYAlignment.Top
        info.RichText = true
        
        local infoCorner = Instance.new("UICorner")
        infoCorner.CornerRadius = UDim.new(0, 8)
        infoCorner.Parent = info
        
        local startBtn = Instance.new("TextButton")
        startBtn.Name = "StartBtn"
        startBtn.Size = UDim2.new(0.8, 0, 0, 40)
        startBtn.Position = UDim2.new(0.1, 0, 0, 170)
        startBtn.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
        startBtn.Text = "▶ START AUTO OBBY"
        startBtn.TextColor3 = Color3.white
        startBtn.TextSize = 14
        startBtn.Font = Enum.Font.GothamBold
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = startBtn
        
        startBtn.MouseButton1Click:Connect(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/obby.lua"))()
        end)
        
        info.Parent = PanelContent
        startBtn.Parent = PanelContent
        
    elseif name == "Checkpoints" then
        -- Checkpoints content
        local info = Instance.new("TextLabel")
        info.Name = "Info"
        info.Size = UDim2.new(1, -20, 0, 100)
        info.Position = UDim2.new(0, 10, 0, 60)
        info.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        info.TextColor3 = Color3.fromRGB(200, 200, 220)
        info.TextSize = 14
        info.Font = Enum.Font.Gotham
        info.Text = "• Scan all checkpoints\n• Auto teleport\n• Refresh & update\n• Select specific checkpoint"
        info.TextXAlignment = Enum.TextXAlignment.Left
        info.TextYAlignment = Enum.TextYAlignment.Top
        info.RichText = true
        
        local infoCorner = Instance.new("UICorner")
        infoCorner.CornerRadius = UDim.new(0, 8)
        infoCorner.Parent = info
        
        local scanBtn = Instance.new("TextButton")
        scanBtn.Name = "ScanBtn"
        scanBtn.Size = UDim2.new(0.8, 0, 0, 40)
        scanBtn.Position = UDim2.new(0.1, 0, 0, 170)
        scanBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        scanBtn.Text = "🔍 SCAN CHECKPOINTS"
        scanBtn.TextColor3 = Color3.white
        scanBtn.TextSize = 14
        scanBtn.Font = Enum.Font.GothamBold
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = scanBtn
        
        scanBtn.MouseButton1Click:Connect(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/cekpoint.lua"))()
        end)
        
        info.Parent = PanelContent
        scanBtn.Parent = PanelContent
        
    elseif name == "Teleport Players" then
        -- Teleport Players content
        local info = Instance.new("TextLabel")
        info.Name = "Info"
        info.Size = UDim2.new(1, -20, 0, 120)
        info.Position = UDim2.new(0, 10, 0, 60)
        info.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        info.TextColor3 = Color3.fromRGB(200, 200, 220)
        info.TextSize = 14
        info.Font = Enum.Font.Gotham
        info.Text = "DUAL MODE:\n\n• Player → You: Teleport player to your position\n• You → Player: Teleport to player's position\n• Multi-select players\n• Search & refresh list"
        info.TextXAlignment = Enum.TextXAlignment.Left
        info.TextYAlignment = Enum.TextYAlignment.Top
        info.RichText = true
        
        local infoCorner = Instance.new("UICorner")
        infoCorner.CornerRadius = UDim.new(0, 8)
        infoCorner.Parent = info
        
        local tpBtn = Instance.new("TextButton")
        tpBtn.Name = "TPBtn"
        tpBtn.Size = UDim2.new(0.8, 0, 0, 40)
        tpBtn.Position = UDim2.new(0.1, 0, 0, 190)
        tpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        tpBtn.Text = "TELEPORT SYSTEM"
        tpBtn.TextColor3 = Color3.white
        tpBtn.TextSize = 14
        tpBtn.Font = Enum.Font.GothamBold
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = tpBtn
        
        tpBtn.MouseButton1Click:Connect(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/teleportplayers.lua"))()
        end)
        
        info.Parent = PanelContent
        tpBtn.Parent = PanelContent
        
    elseif name == "Fly System" then
        -- Fly System content
        local info = Instance.new("TextLabel")
        info.Name = "Info"
        info.Size = UDim2.new(1, -20, 0, 100)
        info.Position = UDim2.new(0, 10, 0, 60)
        info.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        info.TextColor3 = Color3.fromRGB(200, 200, 220)
        info.TextSize = 14
        info.Font = Enum.Font.Gotham
        info.Text = "• Mobile optimized\n• Joystick support\n• Speed control\n• Up/Down buttons\n• Camera stable"
        info.TextXAlignment = Enum.TextXAlignment.Left
        info.TextYAlignment = Enum.TextYAlignment.Top
        info.RichText = true
        
        local infoCorner = Instance.new("UICorner")
        infoCorner.CornerRadius = UDim.new(0, 8)
        infoCorner.Parent = info
        
        local flyBtn = Instance.new("TextButton")
        flyBtn.Name = "FlyBtn"
        flyBtn.Size = UDim2.new(0.8, 0, 0, 40)
        flyBtn.Position = UDim2.new(0.1, 0, 0, 170)
        flyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        flyBtn.Text = "✈ ACTIVATE FLY"
        flyBtn.TextColor3 = Color3.white
        flyBtn.TextSize = 14
        flyBtn.Font = Enum.Font.GothamBold
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = flyBtn
        
        flyBtn.MouseButton1Click:Connect(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/fly.lua"))()
        end)
        
        info.Parent = PanelContent
        flyBtn.Parent = PanelContent
    end
    
    -- Update canvas size
    PanelContent.CanvasSize = UDim2.new(0, 0, 0, PanelLayout.AbsoluteContentSize.Y + 20)
end

-- Tambahkan modules
local modules = {
    {"Auto Obby", "rbxassetid://10734975645"},
    {"Checkpoints", "rbxassetid://10734973111"},
    {"Teleport Players", "rbxassetid://10734968922"},
    {"Fly System", "rbxassetid://10734967234"}
}

for i, module in ipairs(modules) do
    local name, icon = module[1], module[2]
    local button = createSideButton(name, icon)
    button.Parent = SidebarButtons
    
    button.MouseButton1Click:Connect(function()
        loadModule(name)
    end)
end

-- Update sidebar size
SidebarButtons.CanvasSize = UDim2.new(0, 0, 0, ButtonsLayout.AbsoluteContentSize.Y + 10)

-- Load first module
loadModule("Auto Obby")

-- Make draggable
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainContainer.Position
    end
end)

Header.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        MainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

Header.InputEnded:Connect(function()
    dragging = false
end)

-- Parent ke PlayerGui (PASTIKAN INI DILAKUKAN)
ScreenGui.Parent = player:WaitForChild("PlayerGui")
MainContainer.Parent = ScreenGui

-- Konfirmasi UI muncul
print("==========================================")
print("DELTA EXECUTOR LOADED SUCCESSFULLY!")
print("Blue Panther | 65")
print("EXP Mx.Vanzyxxx")
print("@AlfredR0rw")
print("==========================================")

-- Tampilkan notifikasi kecil
local notif = Instance.new("TextLabel")
notif.Name = "Notif"
notif.Size = UDim2.new(0, 250, 0, 60)
notif.Position = UDim2.new(0.5, -125, 0.1, 0)
notif.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
notif.TextColor3 = Color3.fromRGB(0, 170, 255)
notif.Text = "DELTA EXECUTOR\nUI Loaded Successfully!"
notif.TextSize = 14
notif.Font = Enum.Font.GothamBold
notif.TextYAlignment = Enum.TextYAlignment.Center
notif.ZIndex = 1000

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 8)
notifCorner.Parent = notif

notif.Parent = ScreenGui

-- Auto hide notifikasi setelah 3 detik
delay(3, function()
    if notif then
        notif:Destroy()
    end
end)

-- Return ScreenGui untuk kontrol eksternal
return ScreenGui