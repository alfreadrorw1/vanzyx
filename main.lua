-- Vanzyxxx Auto Script - ULTRA SIMPLE WORKING VERSION
-- Tanpa module, tanpa GitHub dependencies

if not game:GetService("RunService"):IsClient() then
    return
end

-- Prevent duplicate
if _G.VanzyxxxLoaded then return end
_G.VanzyxxxLoaded = true

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Wait for player
repeat task.wait() until plr
repeat task.wait() until plr.PlayerGui

-- Load modules
local FlyModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vanzyxxx/Scripts/main/fly.lua"))()
local AutoCPModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vanzyxxx/Scripts/main/autocp.lua"))()
local TeleportModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vanzyxxx/Scripts/main/autoteleport.lua"))()

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VanzyxxxGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = plr.PlayerGui

-- Remove duplicate GUI
for _, gui in ipairs(plr.PlayerGui:GetChildren()) do
    if gui.Name == "VanzyxxxGUI" and gui ~= ScreenGui then
        gui:Destroy()
    end
end

print("[Vanzyxxx] GUI Created!")

-- ========================
-- FLOATING LOGO
-- ========================
local logo = Instance.new("ImageButton")
logo.Name = "Logo"
logo.Size = UDim2.new(0, 70, 0, 70)
logo.Position = UDim2.new(1, -80, 0, 20)
logo.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
logo.Image = "rbxassetid://6764432408" -- Roblox default icon
logo.Parent = ScreenGui

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0.3, 0)
logoCorner.Parent = logo

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(100, 150, 255)
logoStroke.Thickness = 3
logoStroke.Parent = logo

-- ========================
-- SIMPLE MENU
-- ========================
local menuVisible = false
local menu = Instance.new("Frame")
menu.Name = "Menu"
menu.Size = UDim2.new(0, 300, 0, 350)
menu.Position = UDim2.new(0.5, -150, 0.5, -175)
menu.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
menu.Visible = false
menu.Parent = ScreenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0.1, 0)
menuCorner.Parent = menu

-- Title
local title = Instance.new("TextLabel")
title.Text = "🚀 VANZYXXX MENU"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = menu

-- Status
local status = Instance.new("TextLabel")
status.Text = "✅ READY"
status.Size = UDim2.new(1, -20, 0, 30)
status.Position = UDim2.new(0, 10, 0, 50)
status.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
status.TextColor3 = Color3.fromRGB(100, 255, 100)
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.Parent = menu

-- Toggle Menu Function
local function toggleMenu()
    menuVisible = not menuVisible
    menu.Visible = menuVisible
    print("[Vanzyxxx] Menu toggled:", menuVisible)
end

-- Logo Click
logo.MouseButton1Click:Connect(toggleMenu)

-- ========================
-- FLY SYSTEM INTEGRATION
-- ========================
local function enableFly()
    local character = plr.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    if FlyModule and FlyModule.init then
        FlyModule.init(character, hrp, humanoid)
        FlyModule.toggle(true)
        status.Text = "✈️ FLY ENABLED"
        print("[Vanzyxxx] Fly enabled")
    end
end

local function disableFly()
    if FlyModule and FlyModule.toggle then
        FlyModule.toggle(false)
        status.Text = "✅ READY"
        print("[Vanzyxxx] Fly disabled")
    end
end

-- ========================
-- AUTO CP INTEGRATION
-- ========================
local function startAutoCP()
    local character = plr.Character
    if not character then
        status.Text = "❌ NO CHARACTER"
        return
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not hrp or not humanoid then
        status.Text = "❌ MISSING HRP/HUMANOID"
        return
    end
    
    if AutoCPModule and AutoCPModule.start then
        AutoCPModule.start(character, hrp, humanoid, function(msg)
            status.Text = msg
        end)
    else
        status.Text = "❌ MODULE ERROR"
    end
end

-- ========================
-- CARRY TELEPORT
-- ========================
local function teleportToTarget()
    local character = plr.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Cari player yang sedang di-carry
    local targetPlayer = nil
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= plr and otherPlayer.Character then
            local otherHrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if otherHrp then
                local distance = (hrp.Position - otherHrp.Position).Magnitude
                if distance < 10 then
                    targetPlayer = otherPlayer
                    break
                end
            end
        end
    end
    
    if not targetPlayer then
        status.Text = "❌ NO PLAYER NEARBY"
        return
    end
    
    local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHrp then
        status.Text = "❌ TARGET NO HRP"
        return
    end
    
    status.Text = "📍 TELEPORTING TO TARGET"
    
    -- Gunakan teleport module jika ada
    if TeleportModule and TeleportModule.safeTeleport then
        TeleportModule.safeTeleport(character, hrp, targetHrp.Position, function(success)
            if success then
                status.Text = "✅ TELEPORTED"
            else
                status.Text = "❌ TELEPORT FAILED"
            end
        end)
    else
        -- Fallback teleport
        hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, -3)
        status.Text = "✅ TELEPORTED"
    end
    
    task.wait(1)
    status.Text = "✅ READY"
end

-- ========================
-- BUTTONS
-- ========================
local buttonY = 90
local function createButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, buttonY)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = menu
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0.1, 0)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    buttonY = buttonY + 40
    return btn
end

-- Create buttons
local flyBtn = createButton("✈️ TOGGLE FLY", Color3.fromRGB(50, 120, 220), function()
    if FlyModule and FlyModule.isEnabled and FlyModule.isEnabled() then
        disableFly()
    else
        enableFly()
    end
end)

createButton("▶️ AUTO COMPLETE CP", Color3.fromRGB(50, 180, 80), function()
    startAutoCP()
end)

createButton("👥 TELEPORT TO CARRY", Color3.fromRGB(220, 120, 50), function()
    teleportToTarget()
end)

createButton("🎯 TELEPORT TO MOUSE", Color3.fromRGB(180, 80, 220), function()
    local mouse = plr:GetMouse()
    local targetPos = mouse.Hit.Position
    local character = plr.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
        status.Text = "📍 TELEPORTED TO MOUSE"
    end
end)

createButton("❌ CLOSE MENU", Color3.fromRGB(220, 80, 80), function()
    toggleMenu()
end)

-- ========================
-- FLY STATUS UPDATER
-- ========================
coroutine.wrap(function()
    while task.wait(0.5) do
        if flyBtn then
            if FlyModule and FlyModule.isEnabled and FlyModule.isEnabled() then
                flyBtn.Text = "✈️ DISABLE FLY"
                flyBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
            else
                flyBtn.Text = "✈️ ENABLE FLY"
                flyBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
            end
        end
    end
end)()

-- ========================
-- AUTO-SHOW MENU ON START
-- ========================
task.wait(1) -- Wait a bit
toggleMenu() -- Show menu

-- Auto-hide after 5 seconds
task.wait(5)
if menuVisible then
    toggleMenu()
end

status.Text = "✅ READY - Click logo"

print("[Vanzyxxx] Script fully loaded!")