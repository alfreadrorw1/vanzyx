-- Vanzyxxx Auto Script - Modular Version
-- Main controller with GUI and module management

if not game:GetService("RunService"):IsClient() then
    return
end

-- Prevent duplicate execution
if _G.VanzyxxxLoaded then return end
_G.VanzyxxxLoaded = true

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Player
local plr = Players.LocalPlayer

-- Wait for player
repeat task.wait() until plr
repeat task.wait() until plr.PlayerGui

-- Module loader
local function loadModule(moduleName)
    local url = "https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/" .. moduleName
    local success, moduleScript = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success then
        return moduleScript
    else
        warn("[Vanzyxxx] Failed to load module:", moduleName, moduleScript)
        return nil
    end
end

-- Initialize modules
local Modules = {
    AutoCP = loadModule("autocp.lua"),
    Fly = loadModule("fly.lua"),
    AutoCarry = loadModule("autocarry.lua")
}

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VanzyxxxGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = plr.PlayerGui

-- Remove duplicate GUI
for _, gui in ipairs(plr.PlayerGui:GetChildren()) do
    if gui.Name == "VanzyxxxGUI" and gui ~= ScreenGui then
        gui:Destroy()
    end
end

-- ========================
-- FLOATING DRAGGABLE LOGO
-- ========================
local logo = Instance.new("ImageButton")
logo.Name = "Logo"
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(1, -70, 0.5, -30)
logo.AnchorPoint = Vector2.new(1, 0.5)
logo.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
logo.BackgroundTransparency = 0.3
logo.Image = "rbxassetid://6764432408"
logo.Parent = ScreenGui

-- Logo styling
local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0.2, 0)
logoCorner.Parent = logo

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(100, 150, 255)
logoStroke.Thickness = 2
logoStroke.Parent = logo

local logoShadow = Instance.new("ImageLabel")
logoShadow.Name = "Shadow"
logoShadow.Size = UDim2.new(1, 10, 1, 10)
logoShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
logoShadow.AnchorPoint = Vector2.new(0.5, 0.5)
logoShadow.BackgroundTransparency = 1
logoShadow.Image = "rbxassetid://5554236805"
logoShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
logoShadow.ImageTransparency = 0.8
logoShadow.ScaleType = Enum.ScaleType.Slice
logoShadow.SliceCenter = Rect.new(10, 10, 118, 118)
logoShadow.Parent = logo

-- Logo drag functionality
local dragging = false
local dragInput, dragStart, startPos

local function updateLogoPosition()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    logo.Position = UDim2.new(
        math.clamp(logo.Position.X.Scale, 0, 1),
        math.clamp(logo.Position.X.Offset, 0, viewportSize.X - logo.AbsoluteSize.X),
        math.clamp(logo.Position.Y.Scale, 0, 1),
        math.clamp(logo.Position.Y.Offset, 0, viewportSize.Y - logo.AbsoluteSize.Y)
    )
end

logo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = logo.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

logo.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput) and dragStart then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        logo.Position = newPos
        updateLogoPosition()
    end
end)

-- Handle screen resize
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLogoPosition)
updateLogoPosition()

-- ========================
-- VERTICAL MENU
-- ========================
local menuVisible = false
local menu = Instance.new("Frame")
menu.Name = "Menu"
menu.Size = UDim2.new(0, 280, 1, -20)
menu.Position = UDim2.new(0, -280, 0, 10)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
menu.BackgroundTransparency = 0.1
menu.BorderSizePixel = 0
menu.Visible = false
menu.Parent = ScreenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 8)
menuCorner.Parent = menu

local menuGradient = Instance.new("UIGradient")
menuGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))
})
menuGradient.Rotation = 90
menuGradient.Parent = menu

-- Menu header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
header.BorderSizePixel = 0
header.Parent = menu

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Text = "🚀 VANZYXXX"
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Close button
local closeBtn = Instance.new("ImageButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.BackgroundTransparency = 1
closeBtn.Image = "rbxassetid://6031091004"
closeBtn.ImageColor3 = Color3.fromRGB(220, 80, 80)
closeBtn.Parent = header

-- Status display
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Size = UDim2.new(1, -20, 0, 40)
statusFrame.Position = UDim2.new(0, 10, 0, 60)
statusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
statusFrame.Parent = menu

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Text = "✅ READY"
statusLabel.Size = UDim2.new(1, 0, 1, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextSize = 14
statusLabel.Parent = statusFrame

-- Toggles container
local togglesFrame = Instance.new("ScrollingFrame")
togglesFrame.Name = "Toggles"
togglesFrame.Size = UDim2.new(1, -20, 1, -150)
togglesFrame.Position = UDim2.new(0, 10, 0, 110)
togglesFrame.BackgroundTransparency = 1
togglesFrame.BorderSizePixel = 0
togglesFrame.ScrollBarThickness = 3
togglesFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
togglesFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
togglesFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
togglesFrame.Parent = menu

local togglesLayout = Instance.new("UIListLayout")
togglesLayout.Padding = UDim.new(0, 10)
togglesLayout.Parent = togglesFrame

-- ========================
-- TOGGLE CREATION
-- ========================
local ToggleStates = {
    AutoCP = false,
    Fly = false,
    AutoCarry = false
}

local ActiveModules = {}

local function createToggle(name, description, defaultColor, activeColor)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name .. "Toggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, 50)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    toggleFrame.BackgroundTransparency = 0.1
    toggleFrame.Parent = togglesFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Text = name
    toggleLabel.Size = UDim2.new(0.7, -10, 0.5, 0)
    toggleLabel.Position = UDim2.new(0, 10, 0, 5)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.Font = Enum.Font.GothamBold
    toggleLabel.TextSize = 16
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Text = description
    descLabel.Size = UDim2.new(0.7, -10, 0.5, 0)
    descLabel.Position = UDim2.new(0, 10, 0, 25)
    descLabel.BackgroundTransparency = 1
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 12
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = toggleFrame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleButton"
    toggleBtn.Text = "OFF"
    toggleBtn.Size = UDim2.new(0.25, 0, 0.6, 0)
    toggleBtn.Position = UDim2.new(0.75, -5, 0.2, 0)
    toggleBtn.BackgroundColor3 = defaultColor
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 14
    toggleBtn.Parent = toggleFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = toggleBtn
    
    -- Toggle functionality
    toggleBtn.MouseButton1Click:Connect(function()
        ToggleStates[name] = not ToggleStates[name]
        
        if ToggleStates[name] then
            toggleBtn.Text = "ON"
            toggleBtn.BackgroundColor3 = activeColor
            
            -- Start module
            if Modules[name] then
                ActiveModules[name] = Modules[name].start()
                statusLabel.Text = "▶️ " .. name .. " ENABLED"
            end
        else
            toggleBtn.Text = "OFF"
            toggleBtn.BackgroundColor3 = defaultColor
            
            -- Stop module
            if ActiveModules[name] then
                Modules[name].stop(ActiveModules[name])
                ActiveModules[name] = nil
                statusLabel.Text = "✅ READY"
            end
        end
    end)
    
    return toggleFrame
end

-- Create all toggles
createToggle("AutoCP", "Auto complete checkpoints", Color3.fromRGB(80, 80, 120), Color3.fromRGB(50, 180, 80))
createToggle("Fly", "Enable flight mode", Color3.fromRGB(80, 80, 120), Color3.fromRGB(50, 120, 220))
createToggle("AutoCarry", "Carry all players", Color3.fromRGB(80, 80, 120), Color3.fromRGB(220, 120, 50))

-- ========================
-- MENU ANIMATION
-- ========================
local function toggleMenu()
    menuVisible = not menuVisible
    
    if menuVisible then
        menu.Visible = true
        local tween = TweenService:Create(menu, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 10, 0, 10)
        })
        tween:Play()
    else
        local tween = TweenService:Create(menu, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, -280, 0, 10)
        })
        tween:Play()
        
        tween.Completed:Connect(function()
            if not menuVisible then
                menu.Visible = false
                
                -- Stop all active modules when menu closes
                for name, _ in pairs(ActiveModules) do
                    if Modules[name] then
                        Modules[name].stop(ActiveModules[name])
                    end
                    ToggleStates[name] = false
                end
                ActiveModules = {}
                
                -- Update toggle buttons
                for _, toggle in ipairs(togglesFrame:GetChildren()) do
                    if toggle:IsA("Frame") then
                        local toggleBtn = toggle:FindFirstChild("ToggleButton")
                        if toggleBtn then
                            toggleBtn.Text = "OFF"
                            toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
                        end
                    end
                end
                
                statusLabel.Text = "✅ READY"
            end
        end)
    end
end

-- Connect logo and close button
logo.MouseButton1Click:Connect(toggleMenu)
closeBtn.MouseButton1Click:Connect(toggleMenu)

-- ========================
-- RESPONSIVE DESIGN
-- ========================
local function updateLayout()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    
    if viewportSize.Y > viewportSize.X then
        -- Portrait mode
        menu.Size = UDim2.new(0.9, 0, 0.7, 0)
        menu.Position = UDim2.new(0.05, -menu.AbsoluteSize.X, 0.15, 0)
    else
        -- Landscape mode
        menu.Size = UDim2.new(0, 280, 0.9, 0)
        menu.Position = UDim2.new(0, -280, 0.05, 0)
    end
    
    logo.Size = UDim2.new(0, math.min(60, viewportSize.X * 0.1), 0, math.min(60, viewportSize.X * 0.1))
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLayout)
updateLayout()

-- ========================
-- AUTO-START MODULES
-- ========================
task.wait(1)

-- Auto-enable Fly on start
if Modules.Fly then
    ToggleStates.Fly = true
    ActiveModules.Fly = Modules.Fly.start()
    statusLabel.Text = "✈️ FLY ENABLED"
    
    -- Update toggle button
    for _, toggle in ipairs(togglesFrame:GetChildren()) do
        if toggle:IsA("Frame") and toggle.Name == "FlyToggle" then
            local toggleBtn = toggle:FindFirstChild("ToggleButton")
            if toggleBtn then
                toggleBtn.Text = "ON"
                toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
            end
        end
    end
end

-- Auto-show menu on start
toggleMenu()

-- Auto-hide menu after 8 seconds
task.wait(8)
if menuVisible then
    toggleMenu()
end

-- Handle respawn
plr.CharacterAdded:Connect(function(character)
    task.wait(1) -- Wait for character to fully load
    
    -- Re-enable active modules
    for name, _ in pairs(ActiveModules) do
        if Modules[name] then
            Modules[name].stop(ActiveModules[name])
            ActiveModules[name] = Modules[name].start()
        end
    end
end)

print("[Vanzyxxx] System fully loaded!")