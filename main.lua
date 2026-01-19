-- ====================================================
-- VANZYX EXPLOIT SCRIPT - MAIN FILE
-- Compatible with Delta Executor (Mobile)
-- ====================================================

-- Main configuration
local config = {
    Title = "VANZYX HUB",
    Version = "v1.0",
    Author = "Alfred",
    Color = Color3.fromRGB(40, 40, 50),
    AccentColor = Color3.fromRGB(0, 170, 255)
}

-- Cache services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Local player check
local Player = Players.LocalPlayer
if not Player then
    Player = Players.PlayerAdded:Wait()
end

-- Create main screen GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VanzYXMain"
ScreenGui.DisplayOrder = 999
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Create main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = config.Color
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Add shadow effect
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(20, 20, 30)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Create title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.BorderSizePixel = 0

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 12)
TitleBarCorner.Parent = TitleBar

-- Logo/Icon
local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.Position = UDim2.new(0, 15, 0.5, -15)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://10734958920" -- Placeholder image ID

-- Title text
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 0, 40)
Title.Position = UDim2.new(0, 55, 0.5, -20)
Title.BackgroundTransparency = 1
Title.Text = config.Title
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Version text
local Version = Instance.new("TextLabel")
Version.Name = "Version"
Version.Size = UDim2.new(0, 60, 0, 20)
Version.Position = UDim2.new(1, -70, 0, 5)
Version.BackgroundTransparency = 1
Version.Text = config.Version
Version.TextColor3 = Color3.fromRGB(150, 150, 150)
Version.TextSize = 12
Version.Font = Enum.Font.Gotham
Version.TextXAlignment = Enum.TextXAlignment.Right

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0.5, -15)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold

local CloseButtonCorner = Instance.new("UICorner")
CloseButtonCorner.CornerRadius = UDim.new(0, 6)
CloseButtonCorner.Parent = CloseButton

-- Create tabs container
local TabsContainer = Instance.new("Frame")
TabsContainer.Name = "TabsContainer"
TabsContainer.Size = UDim2.new(1, 0, 0, 40)
TabsContainer.Position = UDim2.new(0, 0, 0, 50)
TabsContainer.BackgroundTransparency = 1

-- Create buttons container
local ButtonsContainer = Instance.new("ScrollingFrame")
ButtonsContainer.Name = "ButtonsContainer"
ButtonsContainer.Size = UDim2.new(1, -20, 1, -110)
ButtonsContainer.Position = UDim2.new(0, 10, 0, 100)
ButtonsContainer.BackgroundTransparency = 1
ButtonsContainer.ScrollBarThickness = 4
ButtonsContainer.ScrollBarImageColor3 = config.AccentColor
ButtonsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ButtonsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Create tabs
local Tabs = {
    "Main",
    "Auto Obby",
    "Checkpoint",
    "Teleport",
    "Fly",
    "Settings"
}

-- Module storage
local Modules = {}
local CurrentTab = "Main"

-- Function to load module
local function LoadModule(moduleName)
    local success, result = pcall(function()
        if moduleName == "fly" then
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/fly.lua"))()
        elseif moduleName == "cekpoint" then
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/cekpoint.lua"))()
        elseif moduleName == "teleportplayers" then
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/teleportplayers.lua"))()
        end
    end)
    
    if success then
        Modules[moduleName] = result
        return result
    else
        warn("Failed to load module:", moduleName, result)
        return nil
    end
end

-- Function to create button
local function CreateButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = text .. "Button"
    Button.Size = UDim2.new(1, 0, 0, 45)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 16
    Button.Font = Enum.Font.Gotham
    Button.AutoButtonColor = true
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(30, 30, 40)
    ButtonStroke.Thickness = 1
    ButtonStroke.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return Button
end

-- Function to update tab
local function UpdateTab(tabName)
    CurrentTab = tabName
    
    -- Clear buttons
    for _, child in ipairs(ButtonsContainer:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    
    -- Add buttons based on tab
    if tabName == "Main" then
        local button1 = CreateButton("🚀 Auto Obby Run", function()
            UpdateTab("Auto Obby")
        end)
        button1.Parent = ButtonsContainer
        
        local button2 = CreateButton("📍 Checkpoint Teleport", function()
            UpdateTab("Checkpoint")
        end)
        button2.Parent = ButtonsContainer
        
        local button3 = CreateButton("👤 Teleport Players", function()
            UpdateTab("Teleport")
        end)
        button3.Parent = ButtonsContainer
        
        local button4 = CreateButton("✈️ Fly System", function()
            UpdateTab("Fly")
        end)
        button4.Parent = ButtonsContainer
        
        local button5 = CreateButton("⚙️ Settings", function()
            UpdateTab("Settings")
        end)
        button5.Parent = ButtonsContainer
        
    elseif tabName == "Auto Obby" then
        -- Auto Obby buttons will be added by module
        local button1 = CreateButton("▶️ Start Auto Obby", function()
            local module = LoadModule("cekpoint")
            if module and module.StartAutoObby then
                module.StartAutoObby()
            end
        end)
        button1.Parent = ButtonsContainer
        
        local button2 = CreateButton("⏸️ Pause Auto Obby", function()
            local module = LoadModule("cekpoint")
            if module and module.PauseAutoObby then
                module.PauseAutoObby()
            end
        end)
        button2.Parent = ButtonsContainer
        
        local button3 = CreateButton("⏹️ Stop Auto Obby", function()
            local module = LoadModule("cekpoint")
            if module and module.StopAutoObby then
                module.StopAutoObby()
            end
        end)
        button3.Parent = ButtonsContainer
        
    elseif tabName == "Checkpoint" then
        local module = LoadModule("cekpoint")
        if module and module.CreateUI then
            module.CreateUI(ButtonsContainer)
        end
        
    elseif tabName == "Teleport" then
        local module = LoadModule("teleportplayers")
        if module and module.CreateUI then
            module.CreateUI(ButtonsContainer)
        end
        
    elseif tabName == "Fly" then
        local module = LoadModule("fly")
        if module and module.CreateUI then
            module.CreateUI(ButtonsContainer)
        end
        
    elseif tabName == "Settings" then
        local button1 = CreateButton("🎨 Change Theme", function()
            -- Theme changer would go here
        end)
        button1.Parent = ButtonsContainer
        
        local button2 = CreateButton("📱 Mobile Optimize", function()
            -- Mobile optimization
        end)
        button2.Parent = ButtonsContainer
        
        local button3 = CreateButton("🔄 Refresh UI", function()
            -- Refresh UI
        end)
        button3.Parent = ButtonsContainer
    end
end

-- Create tab buttons
local function CreateTabs()
    local tabWidth = 1 / #Tabs
    
    for i, tabName in ipairs(Tabs) do
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Size = UDim2.new(tabWidth, -4, 1, 0)
        TabButton.Position = UDim2.new((i-1) * tabWidth, 2, 0, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        
        TabButton.MouseButton1Click:Connect(function()
            UpdateTab(tabName)
            
            -- Update all tab colors
            for _, tabBtn in ipairs(TabsContainer:GetChildren()) do
                if tabBtn:IsA("TextButton") then
                    if tabBtn.Name == tabName .. "Tab" then
                        tabBtn.BackgroundColor3 = config.AccentColor
                        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    else
                        tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                        tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    end
                end
            end
        end)
        
        TabButton.Parent = TabsContainer
    end
end

-- Make UI draggable
local dragging
local dragInput
local dragStart
local startPos

local function UpdateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
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

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        UpdateInput(input)
    end
end)

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    
    -- Clean up modules
    for name, module in pairs(Modules) do
        if module and module.Cleanup then
            module.Cleanup()
        end
    end
end)

-- Mobile optimization
if UserInputService.TouchEnabled then
    -- Adjust for touch screens
    MainFrame.Size = UDim2.new(0, 320, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
    
    -- Make buttons easier to touch
    for _, button in ipairs(ButtonsContainer:GetChildren()) do
        if button:IsA("TextButton") then
            button.Size = UDim2.new(1, 0, 0, 50)
        end
    end
end

-- Assemble UI
TitleBar.Parent = MainFrame
Logo.Parent = TitleBar
Title.Parent = TitleBar
Version.Parent = TitleBar
CloseButton.Parent = TitleBar
TabsContainer.Parent = MainFrame
ButtonsContainer.Parent = MainFrame
MainFrame.Parent = ScreenGui
ScreenGui.Parent = CoreGui

-- Initialize
CreateTabs()
UpdateTab("Main")

-- Make UI visible with fade in
MainFrame.BackgroundTransparency = 1
TitleBar.BackgroundTransparency = 1

local fadeIn = TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.1})
local fadeInTitle = TweenService:Create(TitleBar, TweenInfo.new(0.5), {BackgroundTransparency = 0})

fadeIn:Play()
fadeInTitle:Play()

-- Return screen gui for external control
return {
    GUI = ScreenGui,
    UpdateTab = UpdateTab,
    LoadModule = LoadModule,
    Config = config
}