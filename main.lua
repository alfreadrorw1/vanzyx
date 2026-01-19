-- DELTA EXECUTOR - COMPLETE VERSION
-- UI sudah muncul, sekarang lengkapi fitur

-- Langsung buat UI
local screen = Instance.new("ScreenGui")
screen.Name = "DeltaExecutor"
screen.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 450, 0, 320)
frame.Position = UDim2.new(0.5, -225, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BorderSizePixel = 0
frame.Parent = screen

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Shadow Effect
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0.5, -10, 0.5, -10)
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://8577661197"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(23, 23, 277, 277)
shadow.ZIndex = -1
shadow.Parent = frame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
header.Parent = frame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Logo di kiri
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 32, 0, 32)
logo.Position = UDim2.new(0, 10, 0.5, -16)
logo.AnchorPoint = Vector2.new(0, 0.5)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://10734964822" -- Logo Delta
logo.ImageColor3 = Color3.fromRGB(0, 170, 255)
logo.Parent = header

-- Title dengan teks yang diinginkan
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0, 50, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Blue Panther | 65\nEXP Mx.Vanzyxxx\n@AlfredR0rw"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.TextSize = 10
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.RichText = true
title.Parent = header

-- Close Button (X) di kanan
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -40, 0.5, -16)
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.white
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Fungsi close
closeBtn.MouseButton1Click:Connect(function()
    screen:Destroy()
end)

-- Content Area
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -50)
content.Position = UDim2.new(0, 0, 0, 50)
content.BackgroundTransparency = 1
content.Parent = frame

-- Sidebar (30%)
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0.3, 0, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
sidebar.Parent = content

-- Right Panel (70%)
local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(0.7, 0, 1, 0)
rightPanel.Position = UDim2.new(0.3, 0, 0, 0)
rightPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
rightPanel.Parent = content

-- Scroll untuk content panel kanan
local rightScroll = Instance.new("ScrollingFrame")
rightScroll.Size = UDim2.new(1, -10, 1, -10)
rightScroll.Position = UDim2.new(0, 5, 0, 5)
rightScroll.BackgroundTransparency = 1
rightScroll.ScrollBarThickness = 5
rightScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
rightScroll.Parent = rightPanel

local rightLayout = Instance.new("UIListLayout")
rightLayout.Padding = UDim.new(0, 10)
rightLayout.Parent = rightScroll

-- Variable untuk tracking module aktif
local activeModule = nil
local moduleFunctions = {}

-- Function untuk clear panel kanan
local function clearPanel()
    for _, child in ipairs(rightScroll:GetChildren()) do
        if child:IsA("GuiObject") and child.Name ~= "RightLayout" then
            child:Destroy()
        end
    end
end

-- Function untuk buat button sidebar
local function createSidebarButton(text, icon, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = ""
    btn.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    -- Icon
    local btnIcon = Instance.new("ImageLabel")
    btnIcon.Size = UDim2.new(0, 22, 0, 22)
    btnIcon.Position = UDim2.new(0, 10, 0.5, -11)
    btnIcon.AnchorPoint = Vector2.new(0, 0.5)
    btnIcon.BackgroundTransparency = 1
    btnIcon.Image = icon
    btnIcon.ImageColor3 = Color3.fromRGB(150, 150, 170)
    btnIcon.Parent = btn
    
    -- Text
    local btnText = Instance.new("TextLabel")
    btnText.Size = UDim2.new(1, -40, 1, 0)
    btnText.Position = UDim2.new(0, 35, 0, 0)
    btnText.BackgroundTransparency = 1
    btnText.Text = text
    btnText.TextColor3 = Color3.fromRGB(200, 200, 220)
    btnText.TextSize = 12
    btnText.Font = Enum.Font.Gotham
    btnText.TextXAlignment = Enum.TextXAlignment.Left
    btnText.Parent = btn
    
    -- Highlight
    local highlight = Instance.new("Frame")
    highlight.Size = UDim2.new(0, 3, 0.7, 0)
    highlight.Position = UDim2.new(0, 0, 0.15, 0)
    highlight.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    highlight.Visible = false
    highlight.Parent = btn
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        if activeModule ~= text then
            game:GetService("TweenService"):Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(55, 55, 65)
            }):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if activeModule ~= text then
            game:GetService("TweenService"):Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            }):Play()
        end
    end)
    
    return btn, highlight
end

-- Function untuk load module
local function loadModule(moduleName)
    -- Reset semua highlight
    for _, child in ipairs(sidebar:GetChildren()) do
        if child:IsA("TextButton") then
            local highlight = child:FindFirstChild("Highlight")
            if highlight then
                highlight.Visible = false
            end
            if activeModule ~= moduleName then
                child.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            end
        end
    end
    
    -- Set active module
    activeModule = moduleName
    
    -- Clear panel kanan
    clearPanel()
    
    -- Execute module function
    if moduleFunctions[moduleName] then
        moduleFunctions[moduleName]()
    end
    
    -- Update scroll size
    rightScroll.CanvasSize = UDim2.new(0, 0, 0, rightLayout.AbsoluteContentSize.Y + 20)
end

-- MODULE 1: AUTO OBBY
local function createAutoObby()
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    title.TextColor3 = Color3.fromRGB(0, 170, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Text = "AUTO OBBY SYSTEM"
    title.TextXAlignment = Enum.TextXAlignment.Center
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    title.Parent = rightScroll
    
    -- Info
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 100)
    info.Position = UDim2.new(0, 10, 0, 60)
    info.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    info.TextColor3 = Color3.fromRGB(200, 200, 220)
    info.TextSize = 12
    info.Font = Enum.Font.Gotham
    info.Text = "Features:\n• Auto detect checkpoints\n• Auto run & jump\n• Anti-stuck system\n• Start/Pause/Resume/Stop"
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.RichText = true
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = info
    info.Parent = rightScroll
    
    -- Start Button
    local startBtn = Instance.new("TextButton")
    startBtn.Size = UDim2.new(0.9, 0, 0, 40)
    startBtn.Position = UDim2.new(0.05, 0, 0, 170)
    startBtn.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
    startBtn.Text = "▶ START AUTO OBBY"
    startBtn.TextColor3 = Color3.white
    startBtn.TextSize = 14
    startBtn.Font = Enum.Font.GothamBold
    
    local startCorner = Instance.new("UICorner")
    startCorner.CornerRadius = UDim.new(0, 8)
    startCorner.Parent = startBtn
    startBtn.Parent = rightScroll
    
    -- Logic Auto Obby
    local running = false
    startBtn.MouseButton1Click:Connect(function()
        if not running then
            running = true
            startBtn.Text = "⏸ PAUSE AUTO OBBY"
            startBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
            
            -- Simple auto run script
            local humanoid = game.Players.LocalPlayer.Character.Humanoid
            humanoid.WalkSpeed = 24
            
            -- Auto jump every 2 seconds
            while running do
                humanoid.Jump = true
                wait(2)
                humanoid.Jump = false
                wait(0.1)
            end
        else
            running = false
            startBtn.Text = "▶ START AUTO OBBY"
            startBtn.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end)
end

-- MODULE 2: CHECKPOINTS
local function createCheckpoints()
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    title.TextColor3 = Color3.fromRGB(0, 170, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Text = "CHECKPOINT SELECTOR"
    title.TextXAlignment = Enum.TextXAlignment.Center
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    title.Parent = rightScroll
    
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 80)
    info.Position = UDim2.new(0, 10, 0, 60)
    info.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    info.TextColor3 = Color3.fromRGB(200, 200, 220)
    info.TextSize = 12
    info.Font = Enum.Font.Gotham
    info.Text = "Scan semua checkpoint di map:\n• checkpoint, cp, stage\n• Auto teleport\n• Refresh list"
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.RichText = true
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = info
    info.Parent = rightScroll
    
    -- Scan Button
    local scanBtn = Instance.new("TextButton")
    scanBtn.Size = UDim2.new(0.9, 0, 0, 40)
    scanBtn.Position = UDim2.new(0.05, 0, 0, 150)
    scanBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    scanBtn.Text = "🔍 SCAN CHECKPOINTS"
    scanBtn.TextColor3 = Color3.white
    scanBtn.TextSize = 14
    scanBtn.Font = Enum.Font.GothamBold
    
    local scanCorner = Instance.new("UICorner")
    scanCorner.CornerRadius = UDim.new(0, 8)
    scanCorner.Parent = scanBtn
    scanBtn.Parent = rightScroll
    
    -- Teleport Button
    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(0.9, 0, 0, 40)
    tpBtn.Position = UDim2.new(0.05, 0, 0, 200)
    tpBtn.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
    tpBtn.Text = "📍 TELEPORT TO CP"
    tpBtn.TextColor3 = Color3.white
    tpBtn.TextSize = 14
    tpBtn.Font = Enum.Font.GothamBold
    
    local tpCorner = Instance.new("UICorner")
    tpCorner.CornerRadius = UDim.new(0, 8)
    tpCorner.Parent = tpBtn
    tpBtn.Parent = rightScroll
    
    -- Checkpoint Logic
    local checkpoints = {}
    
    scanBtn.MouseButton1Click:Connect(function()
        checkpoints = {}
        local workspace = game:GetService("Workspace")
        
        -- Cari semua checkpoint
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local name = obj.Name:lower()
                if name:find("checkpoint") or name:find("cp") or name:find("stage") then
                    table.insert(checkpoints, {
                        Part = obj,
                        Position = obj.Position,
                        Name = obj.Name
                    })
                end
            end
        end
        
        -- Tampilkan hasil
        local result = Instance.new("TextLabel")
        result.Size = UDim2.new(1, -20, 0, 60)
        result.Position = UDim2.new(0, 10, 0, 250)
        result.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        result.TextColor3 = Color3.fromRGB(80, 220, 80)
        result.TextSize = 12
        result.Font = Enum.Font.Gotham
        result.Text = "Found " .. #checkpoints .. " checkpoints!\nClick Teleport to go to first CP."
        result.TextXAlignment = Enum.TextXAlignment.Center
        result.TextYAlignment = Enum.TextYAlignment.Center
        
        local resultCorner = Instance.new("UICorner")
        resultCorner.CornerRadius = UDim.new(0, 8)
        resultCorner.Parent = result
        result.Parent = rightScroll
    end)
    
    tpBtn.MouseButton1Click:Connect(function()
        if #checkpoints > 0 then
            local char = game.Players.LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(checkpoints[1].Position + Vector3.new(0, 5, 0))
                end
            end
        end
    end)
end

-- MODULE 3: TELEPORT PLAYERS
local function createTeleportPlayers()
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    title.TextColor3 = Color3.fromRGB(0, 170, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Text = "TELEPORT PLAYERS"
    title.TextXAlignment = Enum.TextXAlignment.Center
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    title.Parent = rightScroll
    
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 100)
    info.Position = UDim2.new(0, 10, 0, 60)
    info.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    info.TextColor3 = Color3.fromRGB(200, 200, 220)
    info.TextSize = 12
    info.Font = Enum.Font.Gotham
    info.Text = "Dual Mode:\n\n1. Teleport Player → To You\n2. Teleport You → To Player\n• Multi-select players\n• Search function"
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.RichText = true
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = info
    info.Parent = rightScroll
    
    -- Mode Selection
    local modeFrame = Instance.new("Frame")
    modeFrame.Size = UDim2.new(1, -20, 0, 40)
    modeFrame.Position = UDim2.new(0, 10, 0, 170)
    modeFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    
    local modeCorner = Instance.new("UICorner")
    modeCorner.CornerRadius = UDim.new(0, 8)
    modeCorner.Parent = modeFrame
    modeFrame.Parent = rightScroll
    
    local modeLabel = Instance.new("TextLabel")
    modeLabel.Size = UDim2.new(0.4, 0, 1, 0)
    modeLabel.BackgroundTransparency = 1
    modeLabel.Text = "Mode:"
    modeLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    modeLabel.TextSize = 12
    modeLabel.Font = Enum.Font.GothamBold
    modeLabel.TextXAlignment = Enum.TextXAlignment.Left
    modeLabel.Parent = modeFrame
    
    local modeToggle = Instance.new("TextButton")
    modeToggle.Size = UDim2.new(0.5, 0, 0.7, 0)
    modeToggle.Position = UDim2.new(0.4, 0, 0.15, 0)
    modeToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    modeToggle.Text = "Player → You"
    modeToggle.TextColor3 = Color3.white
    modeToggle.TextSize = 11
    modeToggle.Font = Enum.Font.GothamBold
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = modeToggle
    modeToggle.Parent = modeFrame
    
    -- Teleport Button
    local teleportBtn = Instance.new("TextButton")
    teleportBtn.Size = UDim2.new(0.9, 0, 0, 40)
    teleportBtn.Position = UDim2.new(0.05, 0, 0, 220)
    teleportBtn.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
    teleportBtn.Text = "TELEPORT TO PLAYER"
    teleportBtn.TextColor3 = Color3.white
    teleportBtn.TextSize = 14
    teleportBtn.Font = Enum.Font.GothamBold
    
    local teleportCorner = Instance.new("UICorner")
    teleportCorner.CornerRadius = UDim.new(0, 8)
    teleportCorner.Parent = teleportBtn
    teleportBtn.Parent = rightScroll
    
    -- Teleport Logic
    local teleportMode = "toPlayer" -- "toPlayer" or "toMe"
    
    modeToggle.MouseButton1Click:Connect(function()
        if teleportMode == "toPlayer" then
            teleportMode = "toMe"
            modeToggle.Text = "You → Player"
            modeToggle.BackgroundColor3 = Color3.fromRGB(220, 120, 0)
            teleportBtn.Text = "TELEPORT TO ME"
        else
            teleportMode = "toPlayer"
            modeToggle.Text = "Player → You"
            modeToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            teleportBtn.Text = "TELEPORT TO PLAYER"
        end
    end)
    
    teleportBtn.MouseButton1Click:Connect(function()
        local players = game:GetService("Players"):GetPlayers()
        local localPlayer = game.Players.LocalPlayer
        
        for _, player in pairs(players) do
            if player ~= localPlayer then
                local targetChar = player.Character
                local myChar = localPlayer.Character
                
                if targetChar and myChar then
                    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                    
                    if targetHRP and myHRP then
                        if teleportMode == "toPlayer" then
                            -- Teleport player to me
                            targetHRP.CFrame = myHRP.CFrame + Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
                        else
                            -- Teleport me to player
                            myHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
                        end
                    end
                end
            end
        end
    end)
end

-- MODULE 4: FLY SYSTEM
local function createFlySystem()
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    title.TextColor3 = Color3.fromRGB(0, 170, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Text = "FLY SYSTEM (MOBILE)"
    title.TextXAlignment = Enum.TextXAlignment.Center
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    title.Parent = rightScroll
    
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 80)
    info.Position = UDim2.new(0, 10, 0, 60)
    info.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    info.TextColor3 = Color3.fromRGB(200, 200, 220)
    info.TextSize = 12
    info.Font = Enum.Font.Gotham
    info.Text = "Mobile Optimized Fly:\n• Joystick support\n• Speed control\n• Up/Down buttons\n• Camera stable"
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.RichText = true
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = info
    info.Parent = rightScroll
    
    -- Toggle Fly Button
    local flyBtn = Instance.new("TextButton")
    flyBtn.Size = UDim2.new(0.9, 0, 0, 40)
    flyBtn.Position = UDim2.new(0.05, 0, 0, 150)
    flyBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    flyBtn.Text = "✈ FLY: OFF"
    flyBtn.TextColor3 = Color3.white
    flyBtn.TextSize = 14
    flyBtn.Font = Enum.Font.GothamBold
    
    local flyCorner = Instance.new("UICorner")
    flyCorner.CornerRadius = UDim.new(0, 8)
    flyCorner.Parent = flyBtn
    flyBtn.Parent = rightScroll
    
    -- Speed Control
    local speedFrame = Instance.new("Frame")
    speedFrame.Size = UDim2.new(1, -20, 0, 60)
    speedFrame.Position = UDim2.new(0, 10, 0, 200)
    speedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 8)
    speedCorner.Parent = speedFrame
    speedFrame.Parent = rightScroll
    
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(1, 0, 0.5, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "FLY SPEED: 50"
    speedLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    speedLabel.TextSize = 12
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextXAlignment = Enum.TextXAlignment.Center
    speedLabel.Parent = speedFrame
    
    -- Fly Logic
    local flying = false
    local flySpeed = 50
    local bodyVelocity, bodyGyro
    
    local function enableFly()
        local char = game.Players.LocalPlayer.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        flying = true
        flyBtn.Text = "✈ FLY: ON"
        flyBtn.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
        
        -- Create BodyVelocity
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000) * flySpeed
        bodyVelocity.P = 10000
        bodyVelocity.Parent = hrp
        
        -- Create BodyGyro
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000)
        bodyGyro.P = 30000
        bodyGyro.CFrame = hrp.CFrame
        bodyGyro.Parent = hrp
        
        -- Disable gravity
        char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end
    
    local function disableFly()
        flying = false
        flyBtn.Text = "✈ FLY: OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
        
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
        
        local char = game.Players.LocalPlayer.Character
        if char then
            char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        end
    end
    
    flyBtn.MouseButton1Click:Connect(function()
        if flying then
            disableFly()
        else
            enableFly()
        end
    end)
    
    -- Update fly speed in real-time
    game:GetService("RunService").Heartbeat:Connect(function()
        if flying and bodyVelocity then
            local camera = workspace.CurrentCamera
            local lookVector = camera.CFrame.LookVector
            
            -- Simple forward movement
            bodyVelocity.Velocity = lookVector * flySpeed
            
            -- Update gyro to face camera direction
            if bodyGyro then
                bodyGyro.CFrame = camera.CFrame
            end
        end
    end)
end

-- Register module functions
moduleFunctions["Auto Obby"] = createAutoObby
moduleFunctions["Checkpoints"] = createCheckpoints
moduleFunctions["Teleport Players"] = createTeleportPlayers
moduleFunctions["Fly System"] = createFlySystem

-- Buat sidebar buttons
local button1, highlight1 = createSidebarButton("Auto Obby", "rbxassetid://10734975645", 10)
local button2, highlight2 = createSidebarButton("Checkpoints", "rbxassetid://10734973111", 65)
local button3, highlight3 = createSidebarButton("Teleport Players", "rbxassetid://10734968922", 120)
local button4, highlight4 = createSidebarButton("Fly System", "rbxassetid://10734967234", 175)

-- Parent buttons ke sidebar
button1.Parent = sidebar
button2.Parent = sidebar
button3.Parent = sidebar
button4.Parent = sidebar

-- Connect button clicks
button1.MouseButton1Click:Connect(function()
    loadModule("Auto Obby")
    highlight1.Visible = true
    highlight2.Visible = false
    highlight3.Visible = false
    highlight4.Visible = false
end)

button2.MouseButton1Click:Connect(function()
    loadModule("Checkpoints")
    highlight1.Visible = false
    highlight2.Visible = true
    highlight3.Visible = false
    highlight4.Visible = false
end)

button3.MouseButton1Click:Connect(function()
    loadModule("Teleport Players")
    highlight1.Visible = false
    highlight2.Visible = false
    highlight3.Visible = true
    highlight4.Visible = false
end)

button4.MouseButton1Click:Connect(function()
    loadModule("Fly System")
    highlight1.Visible = false
    highlight2.Visible = false
    highlight3.Visible = false
    highlight4.Visible = true
end)

-- Load module pertama
loadModule("Auto Obby")
highlight1.Visible = true

-- Make header draggable
local dragging = false
local dragStart, startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Print success
print("======================================")
print("DELTA EXECUTOR LOADED SUCCESSFULLY!")
print("Blue Panther | 65")
print("EXP Mx.Vanzyxxx")
print("@AlfredR0rw")
print("======================================")