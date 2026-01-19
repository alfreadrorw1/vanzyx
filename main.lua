-- Vanzyxxx Auto Script - UPGRADED VERSION
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
-- UPGRADED MENU DESIGN
-- ========================
local menuVisible = false
local menu = Instance.new("Frame")
menu.Name = "Menu"
menu.Size = UDim2.new(0, 350, 0, 380)
menu.Position = UDim2.new(0.5, -175, 0.5, -190)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
menu.Visible = false
menu.Parent = ScreenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0.08, 0)
menuCorner.Parent = menu

-- Header with close button
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
header.Parent = menu

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0.08, 0.08, 0, 0)
headerCorner.Parent = header

-- Title
local title = Instance.new("TextLabel")
title.Text = "🚀 VANZYXXX ULTRA MENU"
title.Size = UDim2.new(0.8, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Close button (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Text = "×"
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.2, 0)
closeCorner.Parent = closeBtn

-- Status bar
local statusBar = Instance.new("Frame")
statusBar.Name = "StatusBar"
statusBar.Size = UDim2.new(1, -30, 0, 35)
statusBar.Position = UDim2.new(0, 15, 0, 55)
statusBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
statusBar.Parent = menu

local statusBarCorner = Instance.new("UICorner")
statusBarCorner.CornerRadius = UDim.new(0.1, 0)
statusBarCorner.Parent = statusBar

local status = Instance.new("TextLabel")
status.Name = "Status"
status.Text = "✅ READY"
status.Size = UDim2.new(1, -20, 1, 0)
status.Position = UDim2.new(0, 10, 0, 0)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(100, 255, 100)
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = statusBar

-- Scroll container for features
local scrollContainer = Instance.new("ScrollingFrame")
scrollContainer.Name = "FeaturesContainer"
scrollContainer.Size = UDim2.new(1, -30, 0, 250)
scrollContainer.Position = UDim2.new(0, 15, 0, 100)
scrollContainer.BackgroundTransparency = 1
scrollContainer.BorderSizePixel = 0
scrollContainer.ScrollBarThickness = 5
scrollContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 120)
scrollContainer.Parent = menu

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.Parent = scrollContainer

-- ========================
-- FEATURE VARIABLES
-- ========================
local flyEnabled = false
local flyMenuVisible = false
local carryEnabled = false
local autoCPRunning = false

local velocity
local bodyGyro

-- ========================
-- FLY MENU (Small Rectangle)
-- ========================
local flyMenu
local flyMenuFrame

local function createFlyMenu()
    if flyMenu then flyMenu:Destroy() end
    
    flyMenu = Instance.new("ScreenGui")
    flyMenu.Name = "FlyMenuGUI"
    flyMenu.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    flyMenu.Parent = plr.PlayerGui
    
    flyMenuFrame = Instance.new("Frame")
    flyMenuFrame.Name = "FlyMenu"
    flyMenuFrame.Size = UDim2.new(0, 150, 0, 180)
    flyMenuFrame.Position = UDim2.new(0, 20, 0.5, -90)
    flyMenuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    flyMenuFrame.Visible = false
    flyMenuFrame.Parent = flyMenu
    
    local flyMenuCorner = Instance.new("UICorner")
    flyMenuCorner.CornerRadius = UDim.new(0.1, 0)
    flyMenuCorner.Parent = flyMenuFrame
    
    -- Fly title
    local flyTitle = Instance.new("TextLabel")
    flyTitle.Text = "✈️ FLY CONTROL"
    flyTitle.Size = UDim2.new(1, 0, 0, 35)
    flyTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    flyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyTitle.Font = Enum.Font.GothamBold
    flyTitle.TextSize = 14
    flyTitle.Parent = flyMenuFrame
    
    -- Version selection
    local v1Btn = Instance.new("TextButton")
    v1Btn.Text = "V1 - Normal"
    v1Btn.Size = UDim2.new(1, -20, 0, 30)
    v1Btn.Position = UDim2.new(0, 10, 0, 45)
    v1Btn.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
    v1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    v1Btn.Font = Enum.Font.Gotham
    v1Btn.TextSize = 12
    v1Btn.Parent = flyMenuFrame
    
    local v1Corner = Instance.new("UICorner")
    v1Corner.CornerRadius = UDim.new(0.1, 0)
    v1Corner.Parent = v1Btn
    
    local v2Btn = Instance.new("TextButton")
    v2Btn.Text = "V2 - Advanced"
    v2Btn.Size = UDim2.new(1, -20, 0, 30)
    v2Btn.Position = UDim2.new(0, 10, 0, 85)
    v2Btn.BackgroundColor3 = Color3.fromRGB(80, 160, 240)
    v2Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    v2Btn.Font = Enum.Font.Gotham
    v2Btn.TextSize = 12
    v2Btn.Parent = flyMenuFrame
    
    local v2Corner = Instance.new("UICorner")
    v2Corner.CornerRadius = UDim.new(0.1, 0)
    v2Corner.Parent = v2Btn
    
    -- Close fly menu
    local closeFlyBtn = Instance.new("TextButton")
    closeFlyBtn.Text = "❌ CLOSE"
    closeFlyBtn.Size = UDim2.new(1, -20, 0, 25)
    closeFlyBtn.Position = UDim2.new(0, 10, 0, 145)
    closeFlyBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
    closeFlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeFlyBtn.Font = Enum.Font.Gotham
    closeFlyBtn.TextSize = 11
    closeFlyBtn.Parent = flyMenuFrame
    
    local closeFlyCorner = Instance.new("UICorner")
    closeFlyCorner.CornerRadius = UDim.new(0.1, 0)
    closeFlyCorner.Parent = closeFlyBtn
    
    -- Button functions
    v1Btn.MouseButton1Click:Connect(function()
        enableFly("v1")
    end)
    
    v2Btn.MouseButton1Click:Connect(function()
        enableFly("v2")
    end)
    
    closeFlyBtn.MouseButton1Click:Connect(function()
        toggleFlyMenu()
    end)
end

-- ========================
-- CARRY MENU
-- ========================
local carryMenu

local function createCarryMenu()
    if carryMenu then carryMenu:Destroy() end
    
    -- Remove fly menu if exists
    if flyMenu then 
        flyMenu:Destroy()
        flyMenu = nil
    end
    
    carryMenu = Instance.new("ScreenGui")
    carryMenu.Name = "CarryMenuGUI"
    carryMenu.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    carryMenu.Parent = plr.PlayerGui
    
    local carryFrame = Instance.new("Frame")
    carryFrame.Name = "CarryMenu"
    carryFrame.Size = UDim2.new(0, 150, 0, 120)
    carryFrame.Position = UDim2.new(0, 20, 0.5, -60)
    carryFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    carryFrame.Visible = true
    carryFrame.Parent = carryMenu
    
    local carryCorner = Instance.new("UICorner")
    carryCorner.CornerRadius = UDim.new(0.1, 0)
    carryCorner.Parent = carryFrame
    
    -- Carry title
    local carryTitle = Instance.new("TextLabel")
    carryTitle.Text = "👥 CARRY SYSTEM"
    carryTitle.Size = UDim2.new(1, 0, 0, 30)
    carryTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    carryTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    carryTitle.Font = Enum.Font.GothamBold
    carryTitle.TextSize = 14
    carryTitle.Parent = carryFrame
    
    -- On button
    local carryOnBtn = Instance.new("TextButton")
    carryOnBtn.Text = "✅ ON - Carry All"
    carryOnBtn.Size = UDim2.new(1, -20, 0, 30)
    carryOnBtn.Position = UDim2.new(0, 10, 0, 40)
    carryOnBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
    carryOnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    carryOnBtn.Font = Enum.Font.Gotham
    carryOnBtn.TextSize = 12
    carryOnBtn.Parent = carryFrame
    
    local carryOnCorner = Instance.new("UICorner")
    carryOnCorner.CornerRadius = UDim.new(0.1, 0)
    carryOnCorner.Parent = carryOnBtn
    
    -- Off button
    local carryOffBtn = Instance.new("TextButton")
    carryOffBtn.Text = "❌ OFF"
    carryOffBtn.Size = UDim2.new(1, -20, 0, 30)
    carryOffBtn.Position = UDim2.new(0, 10, 0, 80)
    carryOffBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
    carryOffBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    carryOffBtn.Font = Enum.Font.Gotham
    carryOffBtn.TextSize = 12
    carryOffBtn.Parent = carryFrame
    
    local carryOffCorner = Instance.new("UICorner")
    carryOffCorner.CornerRadius = UDim.new(0.1, 0)
    carryOffCorner.Parent = carryOffBtn
    
    -- Button functions
    carryOnBtn.MouseButton1Click:Connect(function()
        enableCarry()
    end)
    
    carryOffBtn.MouseButton1Click:Connect(function()
        disableCarry()
        if carryMenu then
            carryMenu:Destroy()
            carryMenu = nil
        end
    end)
end

-- ========================
-- FLY SYSTEM
-- ========================
local function enableFly(version)
    if flyEnabled then disableFly() end
    
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
    
    if version == "v2" then
        velocity.MaxForce = Vector3.new(40000, 40000, 40000)
    else
        velocity.MaxForce = Vector3.new(10000, 10000, 10000)
    end
    
    velocity.Parent = hrp
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.P = 1000
    bodyGyro.Parent = hrp
    
    flyEnabled = true
    status.Text = "✈️ FLY " .. version:upper() .. " ENABLED"
    print("[Vanzyxxx] Fly " .. version .. " enabled")
    
    -- Movement control
    local moveSpeed = version == "v2" and 120 or 80
    
    local flyConnection
    flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if not flyEnabled then
            flyConnection:Disconnect()
            return
        end
        
        local moveVector = Vector3.new(0, 0, 0)
        
        -- W, A, S, D controls
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
            moveVector = moveVector + (hrp.CFrame.LookVector * moveSpeed)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
            moveVector = moveVector - (hrp.CFrame.LookVector * moveSpeed)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
            moveVector = moveVector + (hrp.CFrame.RightVector * moveSpeed)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
            moveVector = moveVector - (hrp.CFrame.RightVector * moveSpeed)
        end
        
        -- Space and Shift for up/down
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
            moveVector = moveVector + Vector3.new(0, moveSpeed, 0)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
            moveVector = moveVector - Vector3.new(0, moveSpeed, 0)
        end
        
        if velocity then
            velocity.Velocity = moveVector
        end
    end)
    
    -- Hide fly menu
    if flyMenuFrame then
        flyMenuFrame.Visible = false
    end
end

local function disableFly()
    if velocity then velocity:Destroy() velocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    flyEnabled = false
    status.Text = "✅ READY"
    print("[Vanzyxxx] Fly disabled")
end

-- ========================
-- CARRY SYSTEM
-- ========================
local function enableCarry()
    if carryEnabled then return end
    
    status.Text = "👥 CARRYING ALL PLAYERS..."
    
    local character = plr.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Teleport all players to me
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= plr then
            local otherChar = otherPlayer.Character
            if otherChar then
                local otherHrp = otherChar:FindFirstChild("HumanoidRootPart")
                if otherHrp then
                    -- Create weld to carry
                    local weld = Instance.new("Weld")
                    weld.Part0 = hrp
                    weld.Part1 = otherHrp
                    weld.C0 = CFrame.new(0, 0, -5)
                    weld.Parent = hrp
                    
                    print("[Vanzyxxx] Carrying: " .. otherPlayer.Name)
                end
            end
        end
    end
    
    carryEnabled = true
    status.Text = "✅ ALL PLAYERS CARRIED"
    print("[Vanzyxxx] Carry enabled")
end

local function disableCarry()
    -- Remove all welds
    local character = plr.Character
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, child in ipairs(hrp:GetChildren()) do
                if child:IsA("Weld") then
                    child:Destroy()
                end
            end
        end
    end
    
    carryEnabled = false
    status.Text = "✅ CARRY DISABLED"
    print("[Vanzyxxx] Carry disabled")
end

-- ========================
-- AUTO CHECKPOINT SYSTEM
-- ========================
local function findAndTeleportToCheckpoints()
    if autoCPRunning then return end
    autoCPRunning = true
    
    status.Text = "🔍 FINDING CHECKPOINTS..."
    
    -- Find all checkpoints
    local checkpoints = {}
    local checkpointNumbers = {}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local lowerName = obj.Name:lower()
            if lowerName:find("checkpoint") or lowerName:find("cp") then
                -- Extract number from name
                local num = tonumber(lowerName:match("%d+"))
                if num then
                    checkpointNumbers[num] = obj
                else
                    table.insert(checkpoints, obj)
                end
            end
        end
    end
    
    -- Sort numbered checkpoints
    local sortedCheckpoints = {}
    for i = 1, #checkpointNumbers do
        if checkpointNumbers[i] then
            table.insert(sortedCheckpoints, checkpointNumbers[i])
        end
    end
    
    -- Add unnumbered checkpoints
    for _, cp in ipairs(checkpoints) do
        table.insert(sortedCheckpoints, cp)
    end
    
    if #sortedCheckpoints == 0 then
        status.Text = "❌ NO CHECKPOINTS FOUND"
        autoCPRunning = false
        return
    end
    
    status.Text = "🚀 TELEPORTING TO " .. #sortedCheckpoints .. " CHECKPOINTS"
    
    -- Teleport to each checkpoint
    for i, cp in ipairs(sortedCheckpoints) do
        if not autoCPRunning then break end
        
        local character = plr.Character
        if not character then break end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then break end
        
        status.Text = "📍 CP " .. i .. "/" .. #sortedCheckpoints
        
        -- Teleport
        hrp.CFrame = CFrame.new(cp.Position + Vector3.new(0, 5, 0))
        
        -- If last checkpoint, wait and teleport to summit
        if i == #sortedCheckpoints then
            status.Text = "⏳ LAST CP - WAITING 3s..."
            task.wait(3)
            
            -- Find summit
            local summit
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("summit") or obj.Name:lower():find("finish")) then
                    summit = obj
                    break
                end
            end
            
            if summit then
                status.Text = "🏔️ TELEPORTING TO SUMMIT"
                hrp.CFrame = CFrame.new(summit.Position + Vector3.new(0, 5, 0))
                task.wait(1)
            end
            
            status.Text = "🎉 FINISHED!"
            break
        end
        
        task.wait(0.3)
    end
    
    autoCPRunning = false
end

-- ========================
-- MENU FUNCTIONS
-- ========================
local function toggleMenu()
    menuVisible = not menuVisible
    menu.Visible = menuVisible
    print("[Vanzyxxx] Menu toggled:", menuVisible)
end

local function toggleFlyMenu()
    if not flyMenu then
        createFlyMenu()
    end
    
    flyMenuVisible = not flyMenuVisible
    flyMenuFrame.Visible = flyMenuVisible
end

-- ========================
-- CREATE FEATURE BUTTONS
-- ========================
local function createFeatureButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = scrollContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0.08, 0)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

-- Add buttons to scroll container
createFeatureButton("✈️ START FLY (V1/V2)", Color3.fromRGB(50, 120, 220), function()
    if flyEnabled then
        disableFly()
    else
        toggleFlyMenu()
    end
end)

createFeatureButton("👥 START CARRY ALL", Color3.fromRGB(180, 80, 180), function()
    if carryEnabled then
        disableCarry()
        if carryMenu then
            carryMenu:Destroy()
            carryMenu = nil
        end
    else
        createCarryMenu()
    end
end)

createFeatureButton("▶️ AUTO ALL CHECKPOINTS", Color3.fromRGB(50, 180, 80), function()
    if autoCPRunning then
        autoCPRunning = false
        status.Text = "⏹️ STOPPED"
    else
        findAndTeleportToCheckpoints()
    end
end)

createFeatureButton("📍 TELEPORT TO SPAWN", Color3.fromRGB(220, 160, 50), function()
    local spawn = workspace:FindFirstChild("SpawnLocation")
    if spawn then
        local character = plr.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(spawn.Position + Vector3.new(0, 5, 0))
                status.Text = "📍 TELEPORTED TO SPAWN"
            end
        end
    end
end)

-- ========================
-- CONNECT EVENTS
-- ========================
logo.MouseButton1Click:Connect(toggleMenu)
closeBtn.MouseButton1Click:Connect(toggleMenu)

-- Auto update scroll container size
uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollContainer.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
end)

-- ========================
-- INITIALIZATION
-- ========================
task.wait(1)
-- Menu will not auto-show anymore

print("[Vanzyxxx] Script fully loaded! Click logo to open menu.")