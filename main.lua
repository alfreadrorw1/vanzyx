-- Vanzyxxx Auto Script Executor
-- Core System - LocalScript

if not game:GetService("RunService"):IsClient() then
    return
end

-- Cegah duplicate execution
if _G.VanzyxxxExecuted then
    return
end
_G.VanzyxxxExecuted = true

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Modules
local modules = {
    autocp = nil,
    autoteleport = nil,
    fly = nil
}

-- Load modules from GitHub
local function loadModule(name)
    local success, module = pcall(function()
        local url = "https://raw.githubusercontent.com/vanzyx/main/main/modules/" .. name .. ".lua"
        local source = game:HttpGet(url)
        return loadstring(source)()
    end)
    
    if success then
        modules[name] = module
        return module
    else
        warn("Failed to load module: " .. name .. " - " .. module)
        return nil
    end
end

-- GUI Manager
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VanzyxxxGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Cegah duplicate GUI
for _, gui in ipairs(Player.PlayerGui:GetChildren()) do
    if gui.Name == "VanzyxxxGUI" then
        gui:Destroy()
    end
end

-- Floating Logo
local logoUrl = "https://raw.githubusercontent.com/vanzyx/main/main/img/logo.png"
local logo = Instance.new("ImageButton")
logo.Name = "FloatingLogo"
logo.Image = logoUrl
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(0.9, 0, 0.1, 0)
logo.BackgroundTransparency = 1
logo.AnchorPoint = Vector2.new(0.5, 0.5)
logo.Parent = ScreenGui

-- UICorner untuk logo
local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0.3, 0)
logoCorner.Parent = logo

-- Draggable Logo
local dragging = false
local dragInput, dragStart, startPos

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
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        logo.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Main Menu (toggle on logo click)
local menuVisible = false
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainMenu"
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Visible = false
mainFrame.Parent = ScreenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0.08, 0)
menuCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "Vanzyxxx Auto Executor"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Text = "STATUS: LOADING..."
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 50)
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame
statusLabel.PaddingLeft = UDim.new(0, 10)

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0.05, 0)
statusCorner.Parent = statusLabel

-- Fly Toggle
local flyToggle = Instance.new("TextButton")
flyToggle.Name = "FlyToggle"
flyToggle.Text = "✈️ FLY: ON"
flyToggle.Size = UDim2.new(1, -20, 0, 40)
flyToggle.Position = UDim2.new(0, 10, 0, 90)
flyToggle.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
flyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 14
flyToggle.Parent = mainFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0.05, 0)
flyCorner.Parent = flyToggle

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Text = "✕"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.5, 0)
closeCorner.Parent = closeButton

-- Toggle Menu Function
local function toggleMenu()
    menuVisible = not menuVisible
    mainFrame.Visible = menuVisible
end

logo.MouseButton1Click:Connect(toggleMenu)
closeButton.MouseButton1Click:Connect(toggleMenu)

-- Status Management
local currentStatus = "RUNNING"
local function updateStatus(newStatus)
    currentStatus = newStatus
    statusLabel.Text = "STATUS: " .. newStatus
    
    if newStatus == "RUNNING" then
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    elseif newStatus == "FINISHED" then
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    elseif newStatus == "ERROR" then
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end

-- Character Handling
local function onCharacterAdded(newChar)
    Character = newChar
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    Humanoid = newChar:WaitForChild("Humanoid")
    
    -- Reinitialize modules if needed
    if modules.fly then
        modules.fly.setCharacter(newChar)
    end
end

Player.CharacterAdded:Connect(onCharacterAdded)

-- Main Execution
coroutine.wrap(function()
    updateStatus("LOADING MODULES")
    
    -- Load semua module
    loadModule("autocp")
    loadModule("autoteleport")
    loadModule("fly")
    
    -- Inisialisasi fly system
    if modules.fly then
        modules.fly.init(Character, HumanoidRootPart, Humanoid)
        modules.fly.toggle(true)
    end
    
    -- Setup fly toggle
    local flyEnabled = true
    flyToggle.MouseButton1Click:Connect(function()
        flyEnabled = not flyEnabled
        if modules.fly then
            modules.fly.toggle(flyEnabled)
        end
        flyToggle.Text = flyEnabled and "✈️ FLY: ON" or "✈️ FLY: OFF"
        flyToggle.BackgroundColor3 = flyEnabled and Color3.fromRGB(50, 120, 220) or Color3.fromRGB(100, 100, 120)
    end)
    
    updateStatus("RUNNING")
    
    -- Start auto CP completion
    if modules.autocp then
        modules.autocp.start(
            Character,
            HumanoidRootPart,
            Humanoid,
            function(status)
                updateStatus(status)
                
                -- Matikan fly jika selesai
                if status == "FINISHED" and modules.fly then
                    modules.fly.toggle(false)
                    flyEnabled = false
                    flyToggle.Text = "✈️ FLY: OFF"
                    flyToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
                end
            end
        )
    end
    
    -- Auto-hide menu setelah beberapa detik
    task.wait(5)
    if menuVisible then
        toggleMenu()
    end
end)()