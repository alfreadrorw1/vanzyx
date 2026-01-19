-- Vanzyxxx Main Script
-- LocalScript for client-side execution

-- Anti-duplicate check
if _G.VanzyxxxMainLoaded then
    return
end
_G.VanzyxxxMainLoaded = true

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- Player
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Module loader
local function loadModule(moduleName)
    local modules = {
        autocp = "https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/autocp.lua",
        fly = "https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/fly.lua",
        autocarry = "https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/autocarry.lua"
    }
    
    if modules[moduleName] then
        local success, module = pcall(function()
            return loadstring(game:HttpGet(modules[moduleName]))()
        end)
        
        if success then
            return module
        else
            warn("Failed to load module", moduleName, ":", module)
            return nil
        end
    end
    return nil
end

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VanzyxxxGUI"
screenGui.DisplayOrder = 999
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = CoreGui

-- Floating Logo (Draggable)
local logoButton = Instance.new("ImageButton")
logoButton.Name = "LogoButton"
logoButton.Size = UDim2.new(0, 60, 0, 60)
logoButton.Position = UDim2.new(0.5, -30, 0, 20)
logoButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
logoButton.AutoButtonColor = false
logoButton.Image = "rbxassetid://7072725342" -- Placeholder image ID
logoButton.ScaleType = Enum.ScaleType.Fit

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 12)
logoCorner.Parent = logoButton

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(0, 170, 255)
logoStroke.Thickness = 2
logoStroke.Parent = logoButton

logoButton.Parent = screenGui

-- Dragging functionality
local dragging = false
local dragInput, dragStart, startPos

logoButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = logoButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

logoButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        logoButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Main Menu Frame
local menuFrame = Instance.new("Frame")
menuFrame.Name = "MenuFrame"
menuFrame.Size = UDim2.new(0, 300, 0, 400)
menuFrame.Position = UDim2.new(0, 20, 0.5, -200)
menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
menuFrame.BackgroundTransparency = 0.1
menuFrame.Visible = false

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 12)
menuCorner.Parent = menuFrame

local menuStroke = Instance.new("UIStroke")
menuStroke.Color = Color3.fromRGB(50, 50, 60)
menuStroke.Thickness = 2
menuStroke.Parent = menuFrame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

closeButton.Parent = menuFrame

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 20, 0, 10)
title.BackgroundTransparency = 1
title.Text = "VANZYXXX"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = menuFrame

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 0, 60)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: READY"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 16
statusLabel.Parent = menuFrame

-- Toggles Container
local togglesContainer = Instance.new("ScrollingFrame")
togglesContainer.Name = "TogglesContainer"
togglesContainer.Size = UDim2.new(1, -40, 0, 250)
togglesContainer.Position = UDim2.new(0, 20, 0, 100)
togglesContainer.BackgroundTransparency = 1
togglesContainer.ScrollBarThickness = 4
togglesContainer.CanvasSize = UDim2.new(0, 0, 0, 160)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = togglesContainer

togglesContainer.Parent = menuFrame

-- Stop All Button
local stopAllButton = Instance.new("TextButton")
stopAllButton.Name = "StopAllButton"
stopAllButton.Size = UDim2.new(1, -40, 0, 40)
stopAllButton.Position = UDim2.new(0, 20, 1, -50)
stopAllButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
stopAllButton.Text = "STOP ALL FEATURES"
stopAllButton.TextColor3 = Color3.white
stopAllButton.Font = Enum.Font.GothamBold
stopAllButton.TextSize = 16

local stopAllCorner = Instance.new("UICorner")
stopAllCorner.CornerRadius = UDim.new(0, 8)
stopAllCorner.Parent = stopAllButton

stopAllButton.Parent = menuFrame

menuFrame.Parent = screenGui

-- Feature Toggles
local features = {
    {
        name = "Auto Complete CP",
        module = "autocp",
        default = false
    },
    {
        name = "Fly",
        module = "fly",
        default = false
    },
    {
        name = "Auto Carry",
        module = "autocarry",
        default = false
    }
}

local featureStates = {}
local activeModules = {}

-- Create toggle buttons
for i, feature in ipairs(features) do
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = feature.name .. "Toggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.LayoutOrder = i
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "Label"
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 0, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = feature.name
    toggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextSize = 16
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 60, 0, 30)
    toggleButton.Position = UDim2.new(1, -60, 0.5, -15)
    toggleButton.BackgroundColor3 = feature.default and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 0, 0)
    toggleButton.Text = feature.default and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.white
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 14
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleButton
    
    toggleButton.Parent = toggleFrame
    toggleFrame.Parent = togglesContainer
    
    -- Store state
    featureStates[feature.name] = feature.default
    
    -- Toggle functionality
    toggleButton.MouseButton1Click:Connect(function()
        featureStates[feature.name] = not featureStates[feature.name]
        
        if featureStates[feature.name] then
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
            toggleButton.Text = "ON"
            
            -- Load and activate module
            if not activeModules[feature.name] then
                local module = loadModule(feature.module)
                if module then
                    activeModules[feature.name] = module
                    module.activate()
                    statusLabel.Text = "Status: " .. feature.name .. " ACTIVATED"
                end
            end
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
            toggleButton.Text = "OFF"
            
            -- Deactivate module
            if activeModules[feature.name] then
                activeModules[feature.name].deactivate()
                activeModules[feature.name] = nil
                statusLabel.Text = "Status: " .. feature.name .. " DEACTIVATED"
            end
        end
    end)
end

-- Logo click to toggle menu
logoButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = false
    -- Stop all active features when menu closes
    for name, module in pairs(activeModules) do
        if module and module.deactivate then
            module.deactivate()
        end
    end
    activeModules = {}
    statusLabel.Text = "Status: ALL STOPPED"
    
    -- Reset toggle buttons
    for i, feature in ipairs(features) do
        local toggleFrame = togglesContainer:FindFirstChild(feature.name .. "Toggle")
        if toggleFrame then
            local toggleButton = toggleFrame:FindFirstChild("ToggleButton")
            if toggleButton then
                toggleButton.BackgroundColor3 = feature.default and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 0, 0)
                toggleButton.Text = feature.default and "ON" or "OFF"
                featureStates[feature.name] = feature.default
            end
        end
    end
end)

-- Stop All Button functionality
stopAllButton.MouseButton1Click:Connect(function()
    for name, module in pairs(activeModules) do
        if module and module.deactivate then
            module.deactivate()
        end
    end
    activeModules = {}
    statusLabel.Text = "Status: ALL STOPPED"
    
    -- Reset all toggle buttons to OFF
    for i, feature in ipairs(features) do
        local toggleFrame = togglesContainer:FindFirstChild(feature.name .. "Toggle")
        if toggleFrame then
            local toggleButton = toggleFrame:FindFirstChild("ToggleButton")
            if toggleButton then
                toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
                toggleButton.Text = "OFF"
                featureStates[feature.name] = false
            end
        end
    end
end)

-- Respawn handling
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    
    -- Re-activate features if they were active
    for name, isActive in pairs(featureStates) do
        if isActive and activeModules[name] then
            local module = activeModules[name]
            if module and module.deactivate then
                module.deactivate()
            end
            -- Small delay before reactivating
            task.wait(1)
            if module and module.activate then
                module.activate()
            end
        end
    end
end)

-- Mobile responsiveness
local function updateLayout()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    
    if viewportSize.Y > viewportSize.X then
        -- Portrait mode
        menuFrame.Size = UDim2.new(0, 280, 0, 350)
        menuFrame.Position = UDim2.new(0, 10, 0.5, -175)
        logoButton.Size = UDim2.new(0, 50, 0, 50)
    else
        -- Landscape mode
        menuFrame.Size = UDim2.new(0, 300, 0, 400)
        menuFrame.Position = UDim2.new(0, 20, 0.5, -200)
        logoButton.Size = UDim2.new(0, 60, 0, 60)
    end
end

-- Initial layout
updateLayout()

-- Update on viewport change
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLayout)

-- Auto-activate default features
task.wait(1) -- Wait for character to load

for i, feature in ipairs(features) do
    if feature.default then
        local toggleFrame = togglesContainer:FindFirstChild(feature.name .. "Toggle")
        if toggleFrame then
            local toggleButton = toggleFrame:FindFirstChild("ToggleButton")
            if toggleButton then
                -- Simulate click to activate
                spawn(function()
                    task.wait(0.5 * i) -- Stagger activation
                    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
                    toggleButton.Text = "ON"
                    featureStates[feature.name] = true
                    
                    -- Load and activate module
                    local module = loadModule(feature.module)
                    if module then
                        activeModules[feature.name] = module
                        module.activate()
                        statusLabel.Text = "Status: " .. feature.name .. " ACTIVATED"
                    end
                end)
            end
        end
    end
end

-- Cleanup on script termination
game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        for name, module in pairs(activeModules) do
            if module and module.deactivate then
                module.deactivate()
            end
        end
        screenGui:Destroy()
        _G.VanzyxxxMainLoaded = false
    end
end)

statusLabel.Text = "Status: SYSTEM LOADED"