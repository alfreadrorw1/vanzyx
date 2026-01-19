-- Vanzyxxx Auto Script Executor - FIXED VERSION
-- Core System - LocalScript

if not game:GetService("RunService"):IsClient() then
    return
end

-- Cegah duplicate execution
if _G.VanzyxxxExecuted then
    print("[Vanzyxxx] Script already running, skipping...")
    return
end
_G.VanzyxxxExecuted = true

print("[Vanzyxxx] Initializing script...")

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 10)
local Humanoid = Character:WaitForChild("Humanoid")

-- Debug logging
local function log(message)
    print("[Vanzyxxx] " .. message)
end

-- GUI Manager
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VanzyxxxGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Cegah duplicate GUI
for _, gui in ipairs(Player.PlayerGui:GetChildren()) do
    if gui.Name == "VanzyxxxGUI" then
        gui:Destroy()
        break
    end
end

-- Load modules dengan error handling lebih baik
local modules = {
    autocp = nil,
    autoteleport = nil,
    fly = nil
}

-- URL Configuration
local BASE_URL = "https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/"
local MODULES_URL = BASE_URL .. "modules/"

-- Function untuk load module dengan retry
local function loadModule(name)
    for attempt = 1, 3 do
        local success, result = pcall(function()
            local url = MODULES_URL .. name .. ".lua"
            log("Loading module: " .. url .. " (Attempt " .. attempt .. ")")
            
            local source = game:HttpGet(url, true)
            if not source or source == "" then
                error("Empty source from GitHub")
            end
            
            local moduleFunc, err = loadstring(source)
            if not moduleFunc then
                error("Failed to compile module: " .. (err or "Unknown"))
            end
            
            return moduleFunc()
        end)
        
        if success then
            log("Module " .. name .. " loaded successfully")
            return result
        else
            log("Failed to load module " .. name .. ": " .. result)
            if attempt < 3 then
                task.wait(1) -- Wait before retry
            end
        end
    end
    
    return nil
end

-- Load modules in background
task.spawn(function()
    modules.autocp = loadModule("autocp") or {
        start = function() 
            log("AutoCP module not loaded, using fallback")
        end
    }
    
    modules.autoteleport = loadModule("autoteleport") or {
        safeTeleport = function(char, hrp, pos, cb)
            if char and hrp then
                hrp.CFrame = CFrame.new(pos)
                if cb then cb(true) end
            end
        end
    }
    
    modules.fly = loadModule("fly") or {
        init = function() end,
        toggle = function() end,
        setCharacter = function() end
    }
end)

-- ========================
-- FLOATING LOGO
-- ========================
local logoUrl = "https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/img/logo.png"
local logo = Instance.new("ImageButton")
logo.Name = "FloatingLogo"
logo.Image = "rbxassetid://0" -- Placeholder, will load from URL
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(0.95, -30, 0.1, 0)
logo.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
logo.BackgroundTransparency = 0.2
logo.BorderSizePixel = 0
logo.AnchorPoint = Vector2.new(1, 0)
logo.Parent = ScreenGui

-- Try to load logo from URL
task.spawn(function()
    local success = pcall(function()
        logo.Image = logoUrl
    end)
    
    if not success then
        logo.Image = "rbxassetid://6764432408" -- Default Roblox icon
        logo.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    end
end)

-- UICorner untuk logo
local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0.2, 0)
logoCorner.Parent = logo

-- Logo glow effect
local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(100, 150, 255)
logoStroke.Thickness = 2
logoStroke.Parent = logo

-- ========================
-- MAIN MENU
-- ========================
local menuVisible = false
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainMenu"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Visible = false
mainFrame.BorderSizePixel = 0
mainFrame.Parent = ScreenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0.08, 0)
menuCorner.Parent = mainFrame

local menuShadow = Instance.new("ImageLabel")
menuShadow.Name = "Shadow"
menuShadow.Image = "rbxassetid://5554237735"
menuShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
menuShadow.ImageTransparency = 0.8
menuShadow.ScaleType = Enum.ScaleType.Slice
menuShadow.SliceCenter = Rect.new(10, 10, 118, 118)
menuShadow.Size = UDim2.new(1, 20, 1, 20)
menuShadow.Position = UDim2.new(0, -10, 0, -10)
menuShadow.BackgroundTransparency = 1
menuShadow.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0.08, 0.08)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "🚀 Vanzyxxx Executor"
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Text = "×"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.5, 0)
closeCorner.Parent = closeButton

-- Status Display
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Size = UDim2.new(1, -20, 0, 40)
statusFrame.Position = UDim2.new(0, 10, 0, 45)
statusFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
statusFrame.BorderSizePixel = 0
statusFrame.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0.05, 0)
statusCorner.Parent = statusFrame

local statusIcon = Instance.new("TextLabel")
statusIcon.Name = "StatusIcon"
statusIcon.Text = "●"
statusIcon.Size = UDim2.new(0, 30, 1, 0)
statusIcon.Position = UDim2.new(0, 5, 0, 0)
statusIcon.BackgroundTransparency = 1
statusIcon.TextColor3 = Color3.fromRGB(100, 255, 100)
statusIcon.Font = Enum.Font.GothamBold
statusIcon.TextSize = 20
statusIcon.Parent = statusFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Text = "Loading modules..."
statusLabel.Size = UDim2.new(1, -40, 1, 0)
statusLabel.Position = UDim2.new(0, 35, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusFrame

-- Control Buttons
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Name = "ButtonsFrame"
buttonsFrame.Size = UDim2.new(1, -20, 0, 90)
buttonsFrame.Position = UDim2.new(0, 10, 0, 100)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = mainFrame

-- Fly Toggle Button
local flyToggle = Instance.new("TextButton")
flyToggle.Name = "FlyToggle"
flyToggle.Text = "✈️ FLY: OFF"
flyToggle.Size = UDim2.new(0.48, 0, 0, 40)
flyToggle.Position = UDim2.new(0, 0, 0, 0)
flyToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
flyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 14
flyToggle.Parent = buttonsFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0.1, 0)
flyCorner.Parent = flyToggle

-- Start Auto CP Button
local startButton = Instance.new("TextButton")
startButton.Name = "StartButton"
startButton.Text = "▶️ START AUTO CP"
startButton.Size = UDim2.new(0.48, 0, 0, 40)
startButton.Position = UDim2.new(0.52, 0, 0, 0)
startButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
startButton.Font = Enum.Font.GothamBold
startButton.TextSize = 12
startButton.Parent = buttonsFrame

local startCorner = Instance.new("UICorner")
startCorner.CornerRadius = UDim.new(0.1, 0)
startCorner.Parent = startButton

-- Teleport Test Button
local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Text = "📍 TEST TELEPORT"
teleportButton.Size = UDim2.new(1, 0, 0, 40)
teleportButton.Position = UDim2.new(0, 0, 0, 50)
teleportButton.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextSize = 12
teleportButton.Parent = buttonsFrame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0.1, 0)
teleportCorner.Parent = teleportButton

-- ========================
-- MENU FUNCTIONS
-- ========================
local function updateStatus(newStatus, isError)
    statusLabel.Text = newStatus
    
    if isError then
        statusIcon.TextColor3 = Color3.fromRGB(255, 80, 80)
        statusIcon.Text = "⚠️"
    elseif newStatus == "READY" or newStatus == "RUNNING" then
        statusIcon.TextColor3 = Color3.fromRGB(100, 255, 100)
        statusIcon.Text = "●"
    elseif newStatus == "FINISHED" then
        statusIcon.TextColor3 = Color3.fromRGB(255, 200, 50)
        statusIcon.Text = "✓"
    else
        statusIcon.TextColor3 = Color3.fromRGB(100, 150, 255)
        statusIcon.Text = "●"
    end
end

local function toggleMenu()
    menuVisible = not menuVisible
    mainFrame.Visible = menuVisible
    
    if menuVisible then
        -- Animate menu popup
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 300, 0, 200),
            Position = UDim2.new(0.5, -150, 0.5, -100)
        })
        tween:Play()
    end
end

-- Logo click to toggle menu
logo.MouseButton1Click:Connect(toggleMenu)

-- Close button click
closeButton.MouseButton1Click:Connect(function()
    toggleMenu()
end)

-- Draggable logo
local dragging = false
local dragInput, dragStart, startPos

local function updateLogoDrag(input)
    if not dragging then return end
    
    local delta = input.Position - dragStart
    logo.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

logo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput then
        updateLogoDrag(input)
    end
end)

-- ========================
-- FLY SYSTEM CONTROL
-- ========================
local flyEnabled = false
local flyToggleConnection = flyToggle.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    
    if modules.fly then
        local success = pcall(function()
            modules.fly.init(Character, HumanoidRootPart, Humanoid)
            modules.fly.toggle(flyEnabled)
        end)
        
        if success then
            flyToggle.Text = flyEnabled and "✈️ FLY: ON" or "✈️ FLY: OFF"
            flyToggle.BackgroundColor3 = flyEnabled and Color3.fromRGB(50, 150, 220) or Color3.fromRGB(80, 80, 100)
            updateStatus(flyEnabled and "Fly enabled" or "Fly disabled")
        else
            updateStatus("Fly module error", true)
        end
    else
        updateStatus("Fly module not loaded", true)
    end
end)

-- ========================
-- AUTO CP CONTROL
-- ========================
local startButtonConnection = startButton.MouseButton1Click:Connect(function()
    updateStatus("Starting Auto CP...")
    
    if modules.autocp then
        task.spawn(function()
            modules.autocp.start(
                Character,
                HumanoidRootPart,
                Humanoid,
                function(status)
                    updateStatus(status)
                    
                    -- Disable fly when finished
                    if status == "FINISHED" and flyEnabled then
                        flyEnabled = false
                        flyToggle.Text = "✈️ FLY: OFF"
                        flyToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
                        
                        if modules.fly then
                            pcall(function() modules.fly.toggle(false) end)
                        end
                    end
                end
            )
        end)
    else
        updateStatus("AutoCP module not loaded", true)
    end
end)

-- ========================
-- TEST TELEPORT
-- ========================
local teleportButtonConnection = teleportButton.MouseButton1Click:Connect(function()
    if modules.autoteleport and HumanoidRootPart then
        updateStatus("Testing teleport...")
        
        local targetPos = HumanoidRootPart.Position + Vector3.new(0, 50, 0)
        
        local success = pcall(function()
            modules.autoteleport.safeTeleport(Character, HumanoidRootPart, targetPos, function(success)
                updateStatus(success and "Teleport test OK" or "Teleport failed", not success)
            end)
        end)
        
        if not success then
            updateStatus("Teleport error", true)
        end
    else
        updateStatus("Teleport module error", true)
    end
end)

-- ========================
-- CHARACTER HANDLING
-- ========================
local function onCharacterAdded(newChar)
    Character = newChar
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart", 5)
    Humanoid = newChar:FindFirstChildOfClass("Humanoid")
    
    if HumanoidRootPart then
        updateStatus("Character respawned")
        
        -- Reinitialize fly if it was active
        if flyEnabled and modules.fly then
            task.wait(1) -- Wait for character to stabilize
            pcall(function()
                modules.fly.setCharacter(newChar)
                modules.fly.toggle(true)
            end)
        end
    end
end

Player.CharacterAdded:Connect(onCharacterAdded)

-- ========================
-- INITIALIZATION
-- ========================
task.spawn(function()
    log("Script initialized successfully")
    updateStatus("Initializing...")
    
    -- Wait for modules to load
    for i = 1, 30 do -- 3 second timeout
        if modules.autocp and modules.autoteleport and modules.fly then
            break
        end
        task.wait(0.1)
    end
    
    -- Initialize fly system
    if modules.fly then
        local success = pcall(function()
            modules.fly.init(Character, HumanoidRootPart, Humanoid)
        end)
        
        if success then
            updateStatus("Modules loaded")
        else
            updateStatus("Fly init failed, continuing...")
        end
    else
        updateStatus("Fly module missing")
    end
    
    updateStatus("READY - Click logo for menu")
    
    -- Auto-show menu for first time
    task.wait(1)
    if not menuVisible then
        toggleMenu()
        
        -- Auto-hide after 5 seconds
        task.wait(5)
        if menuVisible then
            toggleMenu()
        end
    end
    
    -- Auto-start fly if you want it enabled by default
    -- Uncomment if you want fly to be ON by default:
    --[[
    task.wait(2)
    flyEnabled = true
    if modules.fly then
        pcall(function()
            modules.fly.toggle(true)
            flyToggle.Text = "✈️ FLY: ON"
            flyToggle.BackgroundColor3 = Color3.fromRGB(50, 150, 220)
            updateStatus("Auto-fly enabled")
        end)
    end
    ]]
end)

-- Cleanup on script termination
game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == Player then
        _G.VanzyxxxExecuted = false
        
        -- Disable fly
        if modules.fly then
            pcall(function() modules.fly.toggle(false) end)
        end
        
        -- Remove GUI
        if ScreenGui and ScreenGui.Parent then
            ScreenGui:Destroy()
        end
    end
end)

-- Success message
log("Vanzyxxx Executor loaded successfully!")
return "Vanzyxxx Executor v1.0"