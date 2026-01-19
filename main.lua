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

-- Wait for player
repeat task.wait() until plr
repeat task.wait() until plr.PlayerGui

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
menu.Size = UDim2.new(0, 250, 0, 180)
menu.Position = UDim2.new(0.5, -125, 0.5, -90)
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
-- SIMPLE FLY SYSTEM (Built-in)
-- ========================
local flyEnabled = false
local velocity
local bodyGyro

local function enableFly()
    local character = plr.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Clean old
    if velocity then velocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    
    -- Create new
    velocity = Instance.new("BodyVelocity")
    velocity.Velocity = Vector3.new(0, 0, 0)
    velocity.MaxForce = Vector3.new(10000, 10000, 10000)
    velocity.Parent = hrp
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp
    
    flyEnabled = true
    status.Text = "✈️ FLY ENABLED"
    print("[Vanzyxxx] Fly enabled")
end

local function disableFly()
    if velocity then velocity:Destroy() velocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    flyEnabled = false
    status.Text = "✅ READY"
    print("[Vanzyxxx] Fly disabled")
end

-- ========================
-- AUTO TELEPORT SIMPLE
-- ========================
local function teleportTo(position)
    local character = plr.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    status.Text = "📍 TELEPORTING..."
    
    -- Simple teleport
    hrp.CFrame = CFrame.new(position + Vector3.new(0, 5, 0))
    
    task.wait(0.5)
    status.Text = "✅ READY"
end

-- ========================
-- AUTO FIND CHECKPOINTS
-- ========================
local function findAndTeleportToCheckpoints()
    status.Text = "🔍 FINDING CP..."
    
    local checkpoints = {}
    
    -- Find checkpoints
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("checkpoint") or obj.Name:lower():find("cp")) then
            table.insert(checkpoints, obj)
        end
    end
    
    if #checkpoints == 0 then
        status.Text = "❌ NO CP FOUND"
        return
    end
    
    status.Text = "🚀 TELEPORTING TO " .. #checkpoints .. " CP"
    
    -- Teleport to each
    for i, cp in ipairs(checkpoints) do
        teleportTo(cp.Position)
        status.Text = "📍 CP " .. i .. "/" .. #checkpoints
        task.wait(0.3)
    end
    
    status.Text = "🎉 FINISHED!"
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
end

-- Create buttons
createButton("✈️ TOGGLE FLY", Color3.fromRGB(50, 120, 220), function()
    if flyEnabled then
        disableFly()
    else
        enableFly()
    end
end)

createButton("▶️ START AUTO CP", Color3.fromRGB(50, 180, 80), function()
    findAndTeleportToCheckpoints()
end)

createButton("❌ CLOSE MENU", Color3.fromRGB(220, 80, 80), function()
    toggleMenu()
end)

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