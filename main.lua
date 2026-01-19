-- Vanzyxxx Auto Script - MAIN FILE (Mobile Friendly)
-- Logo bisa diklik untuk buka/tutup menu

if not game:GetService("RunService"):IsClient() then
    return
end

-- Prevent duplicate
if _G.VanzyxxxLoaded then return end
_G.VanzyxxxLoaded = true

local Players = game:GetService("Players")
local plr = Players.LocalPlayer

-- Wait for player
repeat task.wait() until plr
repeat task.wait() until plr.PlayerGui

print("[Vanzyxxx] Starting script...")

-- Load modules (akan dibuat di file terpisah)
local FlyModule, AutoCPModule, TeleportModule

-- Coba load modules
pcall(function()
    FlyModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vanzyxxx/Scripts/main/fly.lua"))()
end)

-- ========================
-- CREATE GUI
-- ========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VanzyxxxGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = plr.PlayerGui

-- Remove duplicate GUI
for _, gui in ipairs(plr.PlayerGui:GetChildren()) do
    if gui.Name == "VanzyxxxGUI" then
        gui:Destroy()
    end
end

-- ========================
-- FLOATING LOGO
-- ========================
local logo = Instance.new("ImageButton")
logo.Name = "Logo"
logo.Size = UDim2.new(0, 80, 0, 80)
logo.Position = UDim2.new(1, -90, 0, 20)
logo.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
logo.Image = "rbxassetid://6764432408"
logo.Parent = ScreenGui

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0.2, 0)
logoCorner.Parent = logo

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(100, 150, 255)
logoStroke.Thickness = 4
logoStroke.Parent = logo

-- ========================
-- MENU PRINCIPAL
-- ========================
local menuVisible = false
local menu = Instance.new("Frame")
menu.Name = "Menu"
menu.Size = UDim2.new(0, 320, 0, 400)
menu.Position = UDim2.new(0.5, -160, 0.5, -200)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
menu.Visible = false
menu.Parent = ScreenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0.1, 0)
menuCorner.Parent = menu

-- Title
local title = Instance.new("TextLabel")
title.Text = "🚀 VANZYXXX MENU"
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = menu

-- Status
local status = Instance.new("TextLabel")
status.Text = "✅ READY"
status.Size = UDim2.new(1, -20, 0, 40)
status.Position = UDim2.new(0, 10, 0, 60)
status.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
status.TextColor3 = Color3.fromRGB(100, 255, 100)
status.Font = Enum.Font.Gotham
status.TextSize = 16
status.Parent = menu

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.Parent = menu

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.2, 0)
closeCorner.Parent = closeBtn

-- ========================
-- TOGGLE MENU FUNCTION
-- ========================
local function toggleMenu()
    menuVisible = not menuVisible
    menu.Visible = menuVisible
    
    if menuVisible then
        logo.BackgroundColor3 = Color3.fromRGB(80, 100, 150)
        logoStroke.Color = Color3.fromRGB(150, 200, 255)
    else
        logo.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        logoStroke.Color = Color3.fromRGB(100, 150, 255)
    end
    
    print("[Menu] " .. (menuVisible and "Opened" or "Closed"))
end

-- Logo click untuk buka/tutup menu
logo.MouseButton1Click:Connect(toggleMenu)

-- Close button click
closeBtn.MouseButton1Click:Connect(toggleMenu)

-- ========================
-- FLY SYSTEM (Simple)
-- ========================
local flyEnabled = false
local flyVelocity = nil
local flyGyro = nil

local function enableFly()
    local character = plr.Character
    if not character then 
        status.Text = "❌ NO CHARACTER"
        return 
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        status.Text = "❌ NO ROOT PART"
        return 
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Clean old
    if flyVelocity then flyVelocity:Destroy() end
    if flyGyro then flyGyro:Destroy() end
    
    -- Create new
    flyVelocity = Instance.new("BodyVelocity")
    flyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    flyVelocity.P = 1000
    flyVelocity.Parent = hrp
    
    flyGyro = Instance.new("BodyGyro")
    flyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
    flyGyro.CFrame = hrp.CFrame
    flyGyro.P = 1000
    flyGyro.Parent = hrp
    
    humanoid.PlatformStand = true
    
    flyEnabled = true
    status.Text = "✈️ FLY ENABLED"
    
    print("[Fly] Enabled")
end

local function disableFly()
    if flyVelocity then 
        flyVelocity:Destroy() 
        flyVelocity = nil 
    end
    
    if flyGyro then 
        flyGyro:Destroy() 
        flyGyro = nil 
    end
    
    local character = plr.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    
    flyEnabled = false
    status.Text = "✅ READY"
    print("[Fly] Disabled")
end

-- ========================
-- AUTO CHECKPOINT
-- ========================
local function startAutoCP()
    -- Load module
    if not AutoCPModule then
        pcall(function()
            AutoCPModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vanzyxxx/Scripts/main/autocp.lua"))()
        end)
    end
    
    if AutoCPModule and AutoCPModule.start then
        local character = plr.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if hrp and humanoid then
                AutoCPModule.start(character, hrp, humanoid, function(msg)
                    status.Text = msg
                end)
            else
                status.Text = "❌ MISSING PARTS"
            end
        else
            status.Text = "❌ NO CHARACTER"
        end
    else
        status.Text = "❌ MODULE ERROR"
    end
end

-- ========================
-- TELEPORT TO NEAREST PLAYER
-- ========================
local function teleportToNearest()
    local character = plr.Character
    if not character then 
        status.Text = "❌ NO CHARACTER"
        return 
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        status.Text = "❌ NO ROOT PART"
        return 
    end
    
    -- Cari player terdekat
    local nearestPlayer = nil
    local nearestDistance = math.huge
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= plr and otherPlayer.Character then
            local otherHrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if otherHrp then
                local distance = (hrp.Position - otherHrp.Position).Magnitude
                if distance < nearestDistance and distance < 100 then
                    nearestDistance = distance
                    nearestPlayer = otherPlayer
                end
            end
        end
    end
    
    if not nearestPlayer then
        status.Text = "❌ NO PLAYERS NEARBY"
        return
    end
    
    local targetHrp = nearestPlayer.Character:FindFirstChild("HumanoidRootPart")
    if targetHrp then
        status.Text = "📍 TELEPORTING..."
        hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, -5)
        task.wait(0.5)
        status.Text = "✅ TELEPORTED"
    end
end

-- ========================
-- CREATE BUTTONS
-- ========================
local buttonY = 110
local function createButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.Position = UDim2.new(0, 10, 0, buttonY)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = menu
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0.1, 0)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        callback()
        -- Auto close menu setelah klik (opsional)
        task.wait(0.1)
        toggleMenu()
    end)
    
    buttonY = buttonY + 50
    return btn
end

-- Create buttons
local flyBtn = createButton("✈️ TOGGLE FLY", Color3.fromRGB(50, 120, 220), function()
    if flyEnabled then
        disableFly()
        flyBtn.Text = "✈️ ENABLE FLY"
        flyBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
    else
        enableFly()
        flyBtn.Text = "✈️ DISABLE FLY"
        flyBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
    end
end)

createButton("▶️ AUTO CHECKPOINT", Color3.fromRGB(50, 180, 80), function()
    startAutoCP()
end)

createButton("👤 TELEPORT TO PLAYER", Color3.fromRGB(220, 120, 50), function()
    teleportToNearest()
end)

createButton("📌 TELEPORT TO SPAWN", Color3.fromRGB(180, 80, 220), function()
    local character = plr.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local spawn = workspace:FindFirstChild("Spawn") or workspace:FindFirstChild("SpawnLocation")
        if spawn then
            character.HumanoidRootPart.CFrame = CFrame.new(spawn.Position + Vector3.new(0, 5, 0))
            status.Text = "📍 AT SPAWN"
        else
            status.Text = "❌ NO SPAWN FOUND"
        end
    end
end)

-- ========================
-- INITIALIZE
-- ========================
print("[Vanzyxxx] Script loaded successfully!")
print("[Vanzyxxx] Click the blue logo to open menu")