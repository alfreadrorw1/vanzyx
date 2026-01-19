--[[
    Delta Executor - Modular Menu System
    Creator: Roblox Lua Developer
    Compatible: Android/Mobile
    No Key System | No External Libraries
--]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Player
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaExecutorUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Main Container
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(0, 600, 0, 400)
MainContainer.Position = UDim2.new(0.5, -300, 0.5, -200)
MainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
MainContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainContainer.BorderSizePixel = 0
MainContainer.ClipsDescendants = true

-- Corner & Shadow
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainContainer

local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0.5, -10, 0.5, -10)
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://8577661197"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.8
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
Shadow.ZIndex = -1
Shadow.Parent = MainContainer

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
Header.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

-- Logo
local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 32, 0, 32)
Logo.Position = UDim2.new(0, 15, 0.5, -16)
Logo.AnchorPoint = Vector2.new(0, 0.5)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://10734964822" -- Delta-like logo
Logo.Parent = Header

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 0, 30)
Title.Position = UDim2.new(0, 60, 0.5, -15)
Title.AnchorPoint = Vector2.new(0, 0.5)
Title.BackgroundTransparency = 1
Title.Text = "DELTA EXECUTOR"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Position = UDim2.new(1, -40, 0.5, -16)
CloseButton.AnchorPoint = Vector2.new(1, 0.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.white
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    script:Destroy()
end)
CloseButton.Parent = Header

Header.Parent = MainContainer

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, 0, 1, -50)
ContentContainer.Position = UDim2.new(0, 0, 0, 50)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainContainer

-- Sidebar (Left - 30%)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0.3, 0, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Sidebar.BorderSizePixel = 0

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 0, 0, 12)
SidebarCorner.Parent = Sidebar

-- Sidebar Buttons Container
local SidebarButtons = Instance.new("ScrollingFrame")
SidebarButtons.Name = "SidebarButtons"
SidebarButtons.Size = UDim2.new(1, -10, 1, -20)
SidebarButtons.Position = UDim2.new(0, 5, 0, 10)
SidebarButtons.BackgroundTransparency = 1
SidebarButtons.BorderSizePixel = 0
SidebarButtons.ScrollBarThickness = 4
SidebarButtons.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
SidebarButtons.CanvasSize = UDim2.new(0, 0, 0, 0)

local ButtonsLayout = Instance.new("UIListLayout")
ButtonsLayout.Padding = UDim.new(0, 8)
ButtonsLayout.Parent = SidebarButtons

SidebarButtons.Parent = Sidebar
Sidebar.Parent = ContentContainer

-- Right Panel (70%)
local RightPanel = Instance.new("Frame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(0.7, 0, 1, 0)
RightPanel.Position = UDim2.new(0.3, 0, 0, 0)
RightPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
RightPanel.BorderSizePixel = 0

local RightPanelCorner = Instance.new("UICorner")
RightPanelCorner.CornerRadius = UDim.new(0, 0, 0, 12)
RightPanelCorner.Parent = RightPanel

-- Right Panel Content
local PanelContent = Instance.new("Frame")
PanelContent.Name = "PanelContent"
PanelContent.Size = UDim2.new(1, -20, 1, -20)
PanelContent.Position = UDim2.new(0, 10, 0, 10)
PanelContent.BackgroundTransparency = 1

local PanelScroll = Instance.new("ScrollingFrame")
PanelScroll.Name = "PanelScroll"
PanelScroll.Size = UDim2.new(1, 0, 1, 0)
PanelScroll.BackgroundTransparency = 1
PanelScroll.BorderSizePixel = 0
PanelScroll.ScrollBarThickness = 6
PanelScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)

local PanelLayout = Instance.new("UIListLayout")
PanelLayout.Padding = UDim.new(0, 10)
PanelLayout.Parent = PanelScroll

PanelScroll.Parent = PanelContent
PanelContent.Parent = RightPanel
RightPanel.Parent = ContentContainer

-- Module System
local Modules = {}
local ActiveModule = nil

-- Function to create sidebar button
local function createSidebarButton(name, icon)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "Button"
    Button.Size = UDim2.new(1, -10, 0, 50)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Button.Text = ""
    Button.AutoButtonColor = false
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.Size = UDim2.new(0, 24, 0, 24)
    Icon.Position = UDim2.new(0, 15, 0.5, -12)
    Icon.AnchorPoint = Vector2.new(0, 0.5)
    Icon.BackgroundTransparency = 1
    Icon.Image = icon or "rbxassetid://10734964822"
    Icon.ImageColor3 = Color3.fromRGB(150, 150, 170)
    Icon.Parent = Button
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 50, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(200, 200, 220)
    Label.TextSize = 16
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button
    
    local Highlight = Instance.new("Frame")
    Highlight.Name = "Highlight"
    Highlight.Size = UDim2.new(0, 4, 0.7, 0)
    Highlight.Position = UDim2.new(0, 0, 0.15, 0)
    Highlight.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Highlight.Visible = false
    Highlight.Parent = Button
    
    -- Button hover effect
    Button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(55, 55, 65)
        }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        if ActiveModule ~= name then
            game:GetService("TweenService"):Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            }):Play()
        end
    end)
    
    return Button
end

-- Function to load module
local function loadModule(moduleName)
    if Modules[moduleName] then
        -- Unload current module
        if ActiveModule and ActiveModule ~= moduleName then
            local oldButton = SidebarButtons:FindFirstChild(ActiveModule .. "Button")
            if oldButton then
                oldButton.Highlight.Visible = false
                game:GetService("TweenService"):Create(oldButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                }):Play()
            end
        end
        
        -- Set active module
        ActiveModule = moduleName
        
        -- Update button highlight
        local button = SidebarButtons:FindFirstChild(moduleName .. "Button")
        if button then
            button.Highlight.Visible = true
            game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 75)
            }):Play()
        end
        
        -- Clear panel
        for _, child in ipairs(PanelScroll:GetChildren()) do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end
        
        -- Load module content
        Modules[moduleName]()
        
        -- Auto resize panel
        PanelScroll.CanvasSize = UDim2.new(0, 0, 0, PanelLayout.AbsoluteContentSize.Y + 20)
    end
end

-- Function to add module
local function addModule(name, icon, func)
    Modules[name] = func
    
    local button = createSidebarButton(name, icon)
    button.Parent = SidebarButtons
    
    button.MouseButton1Click:Connect(function()
        loadModule(name)
    end)
    
    -- Update scroll size
    SidebarButtons.CanvasSize = UDim2.new(0, 0, 0, ButtonsLayout.AbsoluteContentSize.Y + 20)
end

-- Initialize Modules
local function initializeModules()
    -- Auto Obby Module
    addModule("Auto Obby", "rbxassetid://10734975645", function()
        -- This will load from module file
        loadstring(game:HttpGet("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/obby.lua"))()
    end)
    
    -- Checkpoint Module
    addModule("Checkpoints", "rbxassetid://10734973111", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/cekpoint.lua"))()
    end)
    
    -- Teleport Players Module
    addModule("Teleport Players", "rbxassetid://10734968922", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/teleportplayers.lua"))()
    end)
    
    -- Fly Module
    addModule("Fly System", "rbxassetid://10734967234", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/fly.lua"))()
    end)
end

-- Make UI draggable
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainContainer.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput) then
        update(input)
    end
end)

-- Mobile touch optimizations
if UserInputService.TouchEnabled then
    MainContainer.Size = UDim2.new(0, 550, 0, 380)
    MainContainer.Position = UDim2.new(0.5, -275, 0.5, -190)
    
    -- Make buttons easier to tap
    for _, button in ipairs(SidebarButtons:GetChildren()) do
        if button:IsA("TextButton") then
            button.Size = UDim2.new(1, -10, 0, 60)
        end
    end
end

-- Final setup
initializeModules()
MainContainer.Parent = ScreenGui
ScreenGui.Parent = PlayerGui

-- Auto load first module
loadModule("Auto Obby")

print("[Delta Executor] UI Loaded Successfully!")