-- Vanzyxxx Auto Script - MENU PASTI MUNCUL
-- Logo di pojok kanan atas, klik untuk buka menu

if not game:GetService("RunService"):IsClient() then
    return
end

-- Prevent duplicate
if _G.VanzyxxxLoaded then 
    print("Script already loaded!")
    return 
end
_G.VanzyxxxLoaded = true

print("[Vanzyxxx] Starting script...")

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Wait for everything
repeat task.wait() until plr
repeat task.wait() until plr.PlayerGui

print("[Vanzyxxx] Player loaded!")

-- ========================
-- STEP 1: CREATE BASIC GUI (PASTI MUNCUL)
-- ========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VanzyxxxGUIMain"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999 -- Highest priority

-- Add to PlayerGui IMMEDIATELY
ScreenGui.Parent = plr:WaitForChild("PlayerGui")

print("[Vanzyxxx] ScreenGui created and parented!")

-- ========================
-- STEP 2: CREATE LOGO BUTTON (PASTI MUNCUL)
-- ========================
local logo = Instance.new("ImageButton")
logo.Name = "LogoButton"
logo.Size = UDim2.new(0, 70, 0, 70)
logo.Position = UDim2.new(1, -80, 0, 20) -- Top right corner
logo.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
logo.BackgroundTransparency = 0
logo.Image = "rbxassetid://6764432408" -- Roblox icon
logo.ImageTransparency = 0

-- Make sure logo is visible
logo.Active = true
logo.Selectable = true
logo.Visible = true

logo.Parent = ScreenGui

print("[Vanzyxxx] Logo button created!")

-- Styling for logo
local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0.2, 0)
logoCorner.Parent = logo

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(100, 150, 255)
logoStroke.Thickness = 3
logoStroke.Parent = logo

-- Add glow effect
local logoGlow = Instance.new("UIStroke")
logoGlow.Color = Color3.fromRGB(100, 150, 255)
logoGlow.Thickness = 6
logoGlow.Transparency = 0.7
logoGlow.Name = "Glow"
logoGlow.Parent = logo

-- ========================
-- STEP 3: CREATE MENU FRAME (DIBUAT TAPI DISEMBUNYIKAN DULU)
-- ========================
local menuVisible = false
local menu = Instance.new("Frame")
menu.Name = "MainMenu"
menu.Size = UDim2.new(0, 300, 0, 350)
menu.Position = UDim2.new(0.5, -150, 0.5, -175) -- Center screen
menu.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
menu.BackgroundTransparency = 0
menu.Visible = false -- Start hidden
menu.Parent = ScreenGui

print("[Vanzyxxx] Menu frame created!")

-- Style menu
local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0.1, 0)
menuCorner.Parent = menu

local menuShadow = Instance.new("UIStroke")
menuShadow.Color = Color3.fromRGB(0, 0, 0)
menuShadow.Thickness = 3
menuShadow.Transparency = 0.5
menuShadow.Parent = menu

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "🚀 VANZYXXX MENU"
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextStrokeTransparency = 0
title.Parent = menu

-- Status bar
local status = Instance.new("TextLabel")
status.Name = "Status"
status.Text = "✅ READY"
status.Size = UDim2.new(1, -20, 0, 35)
status.Position = UDim2.new(0, 10, 0, 60)
status.BackgroundColor3 = Color3.fromRGB(45, 45, 75)
status.TextColor3 = Color3.fromRGB(100, 255, 100)
status.Font = Enum.Font.Gotham
status.TextSize = 16
status.Parent = menu

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Text = "✕"
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

print("[Vanzyxxx] All UI elements created!")

-- ========================
-- STEP 4: TOGGLE MENU FUNCTION
-- ========================
local function toggleMenu()
    menuVisible = not menuVisible
    menu.Visible = menuVisible
    
    if menuVisible then
        -- Menu opened
        logo.BackgroundColor3 = Color3.fromRGB(80, 100, 150)
        logoStroke.Color = Color3.fromRGB(150, 200, 255)
        print("[Menu] Opened!")
    else
        -- Menu closed
        logo.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
        logoStroke.Color = Color3.fromRGB(100, 150, 255)
        print("[Menu] Closed!")
    end
end

-- ========================
-- STEP 5: CONNECT CLICK EVENTS
-- ========================
-- Logo click to open/close menu
logo.MouseButton1Click:Connect(function()
    print("Logo clicked! Toggling menu...")
    toggleMenu()
end)

-- Close button click
closeBtn.MouseButton1Click:Connect(function()
    print("Close button clicked!")
    toggleMenu()
end)

-- ========================
-- STEP 6: CREATE BUTTONS INSIDE MENU
-- ========================
local buttonY = 105 -- Starting Y position for buttons

local function createButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Name = "Btn_" .. text
    btn.Text = text
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.Position = UDim2.new(0, 10, 0, buttonY)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.AutoButtonColor = true
    btn.Parent = menu
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0.1, 0)
    btnCorner.Parent = btn
    
    -- Click event
    btn.MouseButton1Click:Connect(function()
        print("Button clicked:", text)
        if callback then
            callback()
        end
    end)
    
    buttonY = buttonY + 50
    return btn
end

print("[Vanzyxxx] Creating buttons...")

-- ========================
-- STEP 7: FLY SYSTEM
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
    if not humanoid then 
        status.Text = "❌ NO HUMANOID"
        return 
    end
    
    -- Clean old
    if flyVelocity then flyVelocity:Destroy() end
    if flyGyro then flyGyro:Destroy() end
    
    -- Create fly objects
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
    
    -- Disable gravity
    humanoid.PlatformStand = true
    
    flyEnabled = true
    status.Text = "✈️ FLY ENABLED"
    
    print("[Fly] Enabled!")
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
    
    print("[Fly] Disabled!")
end

-- ========================
-- STEP 8: AUTO CHECKPOINT
-- ========================
local function autoCheckpoint()
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
    
    status.Text = "🔍 SEARCHING CP..."
    
    -- Simple checkpoint finder
    local checkpoints = {}
    
    -- Find checkpoints in workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local nameLower = obj.Name:lower()
            if nameLower:find("checkpoint") or nameLower:find("cp") then
                table.insert(checkpoints, {
                    Part = obj,
                    Position = obj.Position,
                    Name = obj.Name
                })
            end
        end
    end
    
    if #checkpoints == 0 then
        status.Text = "❌ NO CP FOUND"
        return
    end
    
    status.Text = "🎯 FOUND " .. #checkpoints .. " CP"
    task.wait(1)
    
    -- Teleport to each checkpoint
    for i, cp in ipairs(checkpoints) do
        status.Text = "📍 CP " .. i .. "/" .. #checkpoints
        
        -- Disable collision
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        -- Teleport
        hrp.CFrame = CFrame.new(cp.Position + Vector3.new(0, 5, 0))
        
        -- Wait and restore collision
        task.wait(0.5)
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        
        task.wait(0.5)
    end
    
    status.Text = "🎉 COMPLETED!"
    print("[AutoCP] Done!")
end

-- ========================
-- STEP 9: TELEPORT FUNCTIONS
-- ========================
local function teleportToNearestPlayer()
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
    
    -- Find nearest player
    local nearestPlayer = nil
    local nearestDistance = math.huge
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= plr and otherPlayer.Character then
            local otherHrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if otherHrp then
                local distance = (hrp.Position - otherHrp.Position).Magnitude
                if distance < nearestDistance then
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
        hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, -3)
        task.wait(0.5)
        status.Text = "✅ TELEPORTED"
    end
end

local function teleportToSpawn()
    local character = plr.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        -- Find spawn location
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name:lower():find("spawn") or obj.Name:lower():find("start") then
                local targetPos = obj.Position
                if obj:IsA("BasePart") then
                    targetPos = obj.Position
                elseif obj:IsA("Model") then
                    local primary = obj.PrimaryPart
                    if primary then
                        targetPos = primary.Position
                    end
                end
                
                character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
                status.Text = "📍 AT SPAWN"
                return
            end
        end
        
        -- Default to 0,0,0 if no spawn found
        character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
        status.Text = "📍 CENTER MAP"
    end
end

-- ========================
-- STEP 10: CREATE ALL BUTTONS
-- ========================
print("[Vanzyxxx] Creating menu buttons...")

-- Fly Toggle Button
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

-- Auto Checkpoint Button
createButton("▶️ AUTO CHECKPOINT", Color3.fromRGB(50, 180, 80), function()
    autoCheckpoint()
end)

-- Teleport to Player Button
createButton("👤 TELEPORT TO PLAYER", Color3.fromRGB(220, 120, 50), function()
    teleportToNearestPlayer()
end)

-- Teleport to Spawn Button
createButton("📌 TELEPORT TO SPAWN", Color3.fromRGB(180, 80, 220), function()
    teleportToSpawn()
end)

-- Noclip Button
createButton("👻 TOGGLE NOCLIP", Color3.fromRGB(100, 100, 200), function()
    local character = plr.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not part.CanCollide
            end
        end
        status.Text = part.CanCollide and "✅ NOCLIP OFF" or "👻 NOCLIP ON"
    end
end)

-- ========================
-- STEP 11: AUTO-SHOW MENU ON START (TESTING)
-- ========================
-- Tunggu 1 detik lalu tampilkan menu untuk testing
task.wait(1)
print("[Vanzyxxx] Auto-showing menu for testing...")
toggleMenu() -- Buka menu otomatis

-- Auto-close setelah 10 detik
task.wait(10)
if menuVisible then
    print("[Vanzyxxx] Auto-closing menu...")
    toggleMenu()
end

-- ========================
-- STEP 12: FINAL MESSAGE
-- ========================
print("=======================================")
print("VANZYXXX SCRIPT LOADED SUCCESSFULLY!")
print("1. Logo biru di pojok kanan atas")
print("2. Klik logo untuk buka/tutup menu")
print("3. Menu ada di tengah layar")
print("=======================================")

-- Notify player
status.Text = "✅ READY - Click logo!"