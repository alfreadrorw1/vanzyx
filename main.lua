-- DELTA EXECUTOR - ALL IN ONE
-- Semua fitur dalam 1 file

-- Langsung buat UI
local screen = Instance.new("ScreenGui")
screen.Name = "DeltaExecutor"
screen.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 500, 0, 350)
frame.Position = UDim2.new(0.5, -250, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BorderSizePixel = 0
frame.Parent = screen

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Shadow
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

-- HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
header.Parent = frame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Logo
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 35, 0, 35)
logo.Position = UDim2.new(0, 10, 0.5, -17.5)
logo.AnchorPoint = Vector2.new(0, 0.5)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://10734964822"
logo.ImageColor3 = Color3.fromRGB(0, 170, 255)
logo.Parent = header

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0, 55, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Blue Panther | 65\nEXP Mx.Vanzyxxx\n@AlfredR0rw"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.TextSize = 11
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.RichText = true
title.Parent = header

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0.5, -17.5)
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.white
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- CONTENT AREA
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -50)
content.Position = UDim2.new(0, 0, 0, 50)
content.BackgroundTransparency = 1
content.Parent = frame

-- Sidebar (35%)
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0.35, 0, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
sidebar.Parent = content

-- Right Panel (65%)
local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(0.65, 0, 1, 0)
rightPanel.Position = UDim2.new(0.35, 0, 0, 0)
rightPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
rightPanel.Parent = content

-- Scroll untuk right panel
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

-- Function untuk clear panel
local function clearPanel()
    for _, child in ipairs(rightScroll:GetChildren()) do
        if child:IsA("GuiObject") and child.Name ~= "RightLayout" then
            child:Destroy()
        end
    end
end

-- Function untuk buat sidebar button
local function createSidebarButton(text, icon, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = ""
    btn.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    -- Icon
    local btnIcon = Instance.new("ImageLabel")
    btnIcon.Size = UDim2.new(0, 24, 0, 24)
    btnIcon.Position = UDim2.new(0, 12, 0.5, -12)
    btnIcon.AnchorPoint = Vector2.new(0, 0.5)
    btnIcon.BackgroundTransparency = 1
    btnIcon.Image = icon
    btnIcon.ImageColor3 = Color3.fromRGB(150, 150, 170)
    btnIcon.Parent = btn
    
    -- Text
    local btnText = Instance.new("TextLabel")
    btnText.Size = UDim2.new(1, -45, 1, 0)
    btnText.Position = UDim2.new(0, 45, 0, 0)
    btnText.BackgroundTransparency = 1
    btnText.Text = text
    btnText.TextColor3 = Color3.fromRGB(200, 200, 220)
    btnText.TextSize = 13
    btnText.Font = Enum.Font.Gotham
    btnText.TextXAlignment = Enum.TextXAlignment.Left
    btnText.Parent = btn
    
    -- Highlight
    local highlight = Instance.new("Frame")
    highlight.Size = UDim2.new(0, 4, 0.7, 0)
    highlight.Position = UDim2.new(0, 0, 0.15, 0)
    highlight.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    highlight.Visible = false
    highlight.Parent = btn
    
    return btn, highlight
end

-- Variabel untuk fitur
local activeModule = nil
local moduleHighlights = {}

-- MODULE 1: AUTO OBBY SYSTEM
local function loadAutoObby()
    clearPanel()
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 45)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    title.TextColor3 = Color3.fromRGB(0, 170, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Text = "AUTO OBBY"
    title.TextXAlignment = Enum.TextXAlignment.Center
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    title.Parent = rightScroll
    
    -- Info
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 100)
    info.Position = UDim2.new(0, 10, 0, 65)
    info.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    info.TextColor3 = Color3.fromRGB(200, 200, 220)
    info.TextSize = 13
    info.Font = Enum.Font.Gotham
    info.Text = "Auto complete obby dengan fitur:\n• Auto detect checkpoint\n• Auto run & jump\n• Anti-stuck system\n• Start/Pause/Resume/Stop"
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.RichText = true
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = info
    info.Parent = rightScroll
    
    -- Start Button
    local startBtn = Instance.new("TextButton")
    startBtn.Size = UDim2.new(0.9, 0, 0, 45)
    startBtn.Position = UDim2.new(0.05, 0, 0, 175)
    startBtn.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
    startBtn.Text = "▶ START AUTO OBBY"
    startBtn.TextColor3 = Color3.white
    startBtn.TextSize = 15
    startBtn.Font = Enum.Font.GothamBold
    
    local startCorner = Instance.new("UICorner")
    startCorner.CornerRadius = UDim.new(0, 8)
    startCorner.Parent = startBtn
    startBtn.Parent = rightScroll
    
    -- Status
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0.9, 0, 0, 30)
    status.Position = UDim2.new(0.05, 0, 0, 230)
    status.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    status.TextColor3 = Color3.fromRGB(200, 200, 220)
    status.Text = "Status: Ready"
    status.TextSize = 12
    status.Font = Enum.Font.Gotham
    status.TextXAlignment = Enum.TextXAlignment.Center
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = status
    status.Parent = rightScroll
    
    -- Auto Obby Logic
    local running = false
    local checkpoints = {}
    
    local function scanCheckpoints()
        checkpoints = {}
        local workspace = game:GetService("Workspace")
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local name = obj.Name:lower()
                if name:find("checkpoint") or name:find("cp") or name:find("stage") or name:find("point") then
                    table.insert(checkpoints, {
                        Part = obj,
                        Position = obj.Position,
                        Name = obj.Name
                    })
                end
            end
        end
        
        return #checkpoints
    end
    
    startBtn.MouseButton1Click:Connect(function()
        if not running then
            -- Start
            running = true
            startBtn.Text = "⏸ PAUSE AUTO OBBY"
            startBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
            status.Text = "Status: Running..."
            
            -- Scan checkpoints
            local count = scanCheckpoints()
            status.Text = "Status: Found " .. count .. " checkpoints"
            
            -- Start auto movement
            spawn(function()
                local humanoid = game.Players.LocalPlayer.Character.Humanoid
                humanoid.WalkSpeed = 22
                
                for i, cp in ipairs(checkpoints) do
                    if not running then break end
                    
                    -- Move to checkpoint
                    humanoid:MoveTo(cp.Position)
                    
                    -- Wait until close or timeout
                    local startTime = tick()
                    while (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - cp.Position).Magnitude > 5 and tick() - startTime < 5 do
                        if not running then break end
                        wait(0.1)
                    end
                    
                    -- Jump
                    if running then
                        humanoid.Jump = true
                        wait(0.3)
                        humanoid.Jump = false
                    end
                    
                    status.Text = "Status: CP " .. i .. "/" .. #checkpoints
                    wait(0.2)
                end
                
                if running then
                    status.Text = "Status: Finished!"
                    startBtn.Text = "▶ START AUTO OBBY"
                    startBtn.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
                    running = false
                    humanoid.WalkSpeed = 16
                end
            end)
        else
            -- Pause
            running = false
            startBtn.Text = "▶ START AUTO OBBY"
            startBtn.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
            status.Text = "Status: Paused"
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end)
    
    -- Auto scan on load
    local count = scanCheckpoints()
    status.Text = "Status: Found " .. count .. " checkpoints"
end

-- MODULE 2: CHECKPOINT SELECTOR
local function loadCheckpoints()
    clearPanel()
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 45)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    title.TextColor3 = Color3.fromRGB(0, 170, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Text = "CHECKPOINT SELECTOR"
    title.TextXAlignment = Enum.TextXAlignment.Center
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    title.Parent = rightScroll
    
    -- Info
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 80)
    info.Position = UDim2.new(0, 10, 0, 65)
    info.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    info.TextColor3 = Color3.fromRGB(200, 200, 220)
    info.TextSize = 13
    info.Font = Enum.Font.Gotham
    info.Text = "Scan semua checkpoint:\n• checkpoint, cp, stage\n• Teleport otomatis\n• Refresh real-time"
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.RichText = true
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = info
    info.Parent = rightScroll
    
    -- Scan Button
    local scanBtn = Instance.new("TextButton")
    scanBtn.Size = UDim2.new(0.9, 0, 0, 45)
    scanBtn.Position = UDim2.new(0.05, 0, 0, 155)
    scanBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    scanBtn.Text = "🔍 SCAN CHECKPOINTS"
    scanBtn.TextColor3 = Color3.white
    scanBtn.TextSize = 15
    scanBtn.Font = Enum.Font.GothamBold
    
    local scanCorner = Instance.new("UICorner")
    scanCorner.CornerRadius = UDim.new(0, 8)
    scanCorner.Parent = scanBtn
    scanBtn.Parent = rightScroll
    
    -- Teleport All Button
    local tpAllBtn = Instance.new("TextButton")
    tpAllBtn.Size = UDim2.new(0.9, 0, 0, 45)
    tpAllBtn.Position = UDim2.new(0.05, 0, 0, 210)
    tpAllBtn.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
    tpAllBtn.Text = "📍 TELEPORT ALL PLAYERS"
    tpAllBtn.TextColor3 = Color3.white
    tpAllBtn.TextSize = 15
    tpAllBtn.Font = Enum.Font.GothamBold
    
    local tpCorner = Instance.new("UICorner")
    tpCorner.CornerRadius = UDim.new(0, 8)
    tpCorner.Parent = tpAllBtn
    tpAllBtn.Parent = rightScroll
    
    -- Status
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0.9, 0, 0, 60)
    status.Position = UDim2.new(0.05, 0, 0, 265)
    status.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    status.TextColor3 = Color3.fromRGB(200, 200, 220)
    status.Text = "Ready to scan..."
    status.TextSize = 12
    status.Font = Enum.Font.Gotham
    status.TextXAlignment = Enum.TextXAlignment.Center
    status.TextYAlignment = Enum.TextYAlignment.Center
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 8)
    statusCorner.Parent = status
    status.Parent = rightScroll
    
    -- Checkpoint Logic
    local checkpoints = {}
    
    scanBtn.MouseButton1Click:Connect(function()
        checkpoints = {}
        local workspace = game:GetService("Workspace")
        
        -- Cari di workspace
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local name = obj.Name:lower()
                if name:find("checkpoint") or name:find("cp") or name:find("stage") or name:find("point") then
                    table.insert(checkpoints, {
                        Part = obj,
                        Position = obj.Position,
                        Name = obj.Name,
                        Parent = obj.Parent.Name
                    })
                end
            end
        end
        
        -- Cari folder Checkpoints
        local cpFolder = workspace:FindFirstChild("Checkpoints")
        if cpFolder then
            for _, obj in pairs(cpFolder:GetDescendants()) do
                if obj:IsA("BasePart") then
                    table.insert(checkpoints, {
                        Part = obj,
                        Position = obj.Position,
                        Name = obj.Name,
                        Parent = "Checkpoints"
                    })
                end
            end
        end
        
        status.Text = "Found " .. #checkpoints .. " checkpoints!\nClick Teleport to go to first CP."
    end)
    
    tpAllBtn.MouseButton1Click:Connect(function()
        if #checkpoints > 0 then
            -- Teleport semua player ke checkpoint pertama
            local players = game:GetService("Players"):GetPlayers()
            local targetPos = checkpoints[1].Position
            
            for _, player in pairs(players) do
                if player ~= game.Players.LocalPlayer then
                    local char = player.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = CFrame.new(targetPos + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)))
                        end
                    end
                end
            end
            
            -- Teleport diri sendiri juga
            local myChar = game.Players.LocalPlayer.Character
            if myChar then
                local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    myHRP.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
                end
            end
            
            status.Text = "Teleported all players to checkpoint!"
        else
            status.Text = "Scan checkpoints first!"
        end
    end)
end

-- MODULE 3: TELEPORT PLAYERS (DUAL MODE)
local function loadTeleportPlayers()
    clearPanel()
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 45)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    title.TextColor3 = Color3.fromRGB(0, 170, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Text = "TELEPORT PLAYERS"
    title.TextXAlignment = Enum.TextXAlignment.Center
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    title.Parent = rightScroll
    
    -- Info
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 100)
    info.Position = UDim2.new(0, 10, 0, 65)
    info.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    info.TextColor3 = Color3.fromRGB(200, 200, 220)
    info.TextSize = 13
    info.Font = Enum.Font.Gotham
    info.Text = "DUAL MODE TELEPORT:\n\n1️⃣ Player → You\n   Teleport player ke posisi Anda\n\n2️⃣ You → Player\n   Teleport ke posisi player"
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.RichText = true
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = info
    info.Parent = rightScroll
    
    -- Mode Selector
    local modeFrame = Instance.new("Frame")
    modeFrame.Size = UDim2.new(1, -20, 0, 50)
    modeFrame.Position = UDim2.new(0, 10, 0, 175)
    modeFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    
    local modeCorner = Instance.new("UICorner")
    modeCorner.CornerRadius = UDim.new(0, 8)
    modeCorner.Parent = modeFrame
    modeFrame.Parent = rightScroll
    
    local modeLabel = Instance.new("TextLabel")
    modeLabel.Size = UDim2.new(0.3, 0, 1, 0)
    modeLabel.BackgroundTransparency = 1
    modeLabel.Text = "MODE:"
    modeLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    modeLabel.TextSize = 14
    modeLabel.Font = Enum.Font.GothamBold
    modeLabel.TextXAlignment = Enum.TextXAlignment.Left
    modeLabel.Parent = modeFrame
    
    local modeBtn = Instance.new("TextButton")
    modeBtn.Size = UDim2.new(0.65, 0, 0.7, 0)
    modeBtn.Position = UDim2.new(0.3, 0, 0.15, 0)
    modeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    modeBtn.Text = "Player → You"
    modeBtn.TextColor3 = Color3.white
    modeBtn.TextSize = 13
    modeBtn.Font = Enum.Font.GothamBold
    
    local modeBtnCorner = Instance.new("UICorner")
    modeBtnCorner.CornerRadius = UDim.new(0, 6)
    modeBtnCorner.Parent = modeBtn
    modeBtn.Parent = modeFrame
    
    -- Teleport Button
    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(0.9, 0, 0, 45)
    tpBtn.Position = UDim2.new(0.05, 0, 0, 235)
    tpBtn.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
    tpBtn.Text = "TELEPORT PLAYER → YOU"
    tpBtn.TextColor3 = Color3.white
    tpBtn.TextSize = 15
    tpBtn.Font = Enum.Font.GothamBold
    
    local tpCorner = Instance.new("UICorner")
    tpCorner.CornerRadius = UDim.new(0, 8)
    tpCorner.Parent = tpBtn
    tpBtn.Parent = rightScroll
    
    -- Players List
    local playersFrame = Instance.new("Frame")
    playersFrame.Size = UDim2.new(1, -20, 0, 80)
    playersFrame.Position = UDim2.new(0, 10, 0, 290)
    playersFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    
    local playersCorner = Instance.new("UICorner")
    playersCorner.CornerRadius = UDim.new(0, 8)
    playersCorner.Parent = playersFrame
    playersFrame.Parent = rightScroll
    
    local playersLabel = Instance.new("TextLabel")
    playersLabel.Size = UDim2.new(1, 0, 0.4, 0)
    playersLabel.BackgroundTransparency = 1
    playersLabel.Text = "PLAYERS ONLINE:"
    playersLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    playersLabel.TextSize = 12
    playersLabel.Font = Enum.Font.GothamBold
    playersLabel.TextXAlignment = Enum.TextXAlignment.Center
    playersLabel.Parent = playersFrame
    
    local playersCount = Instance.new("TextLabel")
    playersCount.Size = UDim2.new(1, 0, 0.6, 0)
    playersCount.Position = UDim2.new(0, 0, 0.4, 0)
    playersCount.BackgroundTransparency = 1
    playersCount.Text = "Loading..."
    playersCount.TextColor3 = Color3.fromRGB(0, 170, 255)
    playersCount.TextSize = 16
    playersCount.Font = Enum.Font.GothamBold
    playersCount.TextXAlignment = Enum.TextXAlignment.Center
    playersCount.Parent = playersFrame
    
    -- Teleport Logic
    local teleportMode = "toYou" -- "toYou" or "toPlayer"
    
    local function updatePlayersCount()
        local players = game:GetService("Players"):GetPlayers()
        local count = #players - 1 -- Exclude self
        playersCount.Text = count .. " player(s) online"
    end
    
    modeBtn.MouseButton1Click:Connect(function()
        if teleportMode == "toYou" then
            teleportMode = "toPlayer"
            modeBtn.Text = "You → Player"
            modeBtn.BackgroundColor3 = Color3.fromRGB(220, 120, 0)
            tpBtn.Text = "TELEPORT YOU → PLAYER"
        else
            teleportMode = "toYou"
            modeBtn.Text = "Player → You"
            modeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            tpBtn.Text = "TELEPORT PLAYER → YOU"
        end
    end)
    
    tpBtn.MouseButton1Click:Connect(function()
        local players = game:GetService("Players"):GetPlayers()
        local localPlayer = game.Players.LocalPlayer
        local teleported = 0
        
        for _, player in pairs(players) do
            if player ~= localPlayer then
                local targetChar = player.Character
                local myChar = localPlayer.Character
                
                if targetChar and myChar then
                    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                    
                    if targetHRP and myHRP then
                        if teleportMode == "toYou" then
                            -- Teleport player to me
                            targetHRP.CFrame = myHRP.CFrame + Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
                        else
                            -- Teleport me to player
                            myHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
                        end
                        teleported = teleported + 1
                    end
                end
            end
        end
        
        playersCount.Text = teleported .. " player(s) teleported!"
    end)
    
    -- Initial update
    updatePlayersCount()
end

-- MODULE 4: FLY SYSTEM (MOBILE)
local function loadFlySystem()
    clearPanel()
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 45)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    title.TextColor3 = Color3.fromRGB(0, 170, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Text = "FLY SYSTEM"
    title.TextXAlignment = Enum.TextXAlignment.Center
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    title.Parent = rightScroll
    
    -- Info
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 80)
    info.Position = UDim2.new(0, 10, 0, 65)
    info.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    info.TextColor3 = Color3.fromRGB(200, 200, 220)
    info.TextSize = 13
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
    flyBtn.Size = UDim2.new(0.9, 0, 0, 50)
    flyBtn.Position = UDim2.new(0.05, 0, 0, 155)
    flyBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    flyBtn.Text = "✈ FLY: OFF"
    flyBtn.TextColor3 = Color3.white
    flyBtn.TextSize = 16
    flyBtn.Font = Enum.Font.GothamBold
    
    local flyCorner = Instance.new("UICorner")
    flyCorner.CornerRadius = UDim.new(0, 8)
    flyCorner.Parent = flyBtn
    flyBtn.Parent = rightScroll
    
    -- Speed Control
    local speedFrame = Instance.new("Frame")
    speedFrame.Size = UDim2.new(1, -20, 0, 70)
    speedFrame.Position = UDim2.new(0, 10, 0, 215)
    speedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 8)
    speedCorner.Parent = speedFrame
    speedFrame.Parent = rightScroll
    
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(1, 0, 0.4, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "FLY SPEED: 50"
    speedLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    speedLabel.TextSize = 14
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextXAlignment = Enum.TextXAlignment.Center
    speedLabel.Parent = speedFrame
    
    -- Speed Slider
    local speedSlider = Instance.new("Frame")
    speedSlider.Size = UDim2.new(0.8, 0, 0, 20)
    speedSlider.Position = UDim2.new(0.1, 0, 0.6, 0)
    speedSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = speedSlider
    speedSlider.Parent = speedFrame
    
    local speedFill = Instance.new("Frame")
    speedFill.Size = UDim2.new(0.5, 0, 1, 0)
    speedFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    speedFill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = speedFill
    speedFill.Parent = speedSlider
    
    -- Up/Down Buttons
    local upBtn = Instance.new("TextButton")
    upBtn.Size = UDim2.new(0.4, 0, 0, 40)
    upBtn.Position = UDim2.new(0.05, 0, 0, 295)
    upBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    upBtn.Text = "UP"
    upBtn.TextColor3 = Color3.white
    upBtn.TextSize = 14
    upBtn.Font = Enum.Font.GothamBold
    
    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 8)
    upCorner.Parent = upBtn
    upBtn.Parent = rightScroll
    
    local downBtn = Instance.new("TextButton")
    downBtn.Size = UDim2.new(0.4, 0, 0, 40)
    downBtn.Position = UDim2.new(0.55, 0, 0, 295)
    downBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    downBtn.Text = "DOWN"
    downBtn.TextColor3 = Color3.white
    downBtn.TextSize = 14
    downBtn.Font = Enum.Font.GothamBold
    
    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 8)
    downCorner.Parent = downBtn
    downBtn.Parent = rightScroll
    
    -- Status
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0.9, 0, 0, 30)
    status.Position = UDim2.new(0.05, 0, 0, 345)
    status.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    status.TextColor3 = Color3.fromRGB(200, 200, 220)
    status.Text = "Ready to fly"
    status.TextSize = 12
    status.Font = Enum.Font.Gotham
    status.TextXAlignment = Enum.TextXAlignment.Center
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = status
    status.Parent = rightScroll
    
    -- Fly System Logic
    local flying = false
    local flySpeed = 50
    local verticalSpeed = 0
    local bodyVelocity, bodyGyro
    
    local function enableFly()
        local char = game.Players.LocalPlayer.Character
        if not char then
            status.Text = "No character found!"
            return
        end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            status.Text = "No HumanoidRootPart!"
            return
        end
        
        flying = true
        flyBtn.Text = "✈ FLY: ON"
        flyBtn.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
        status.Text = "Flying at speed: " .. flySpeed
        
        -- Create BodyVelocity
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000) * flySpeed
        bodyVelocity.P = 10000
        bodyVelocity.Parent = hrp
        
        -- Create BodyGyro
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000) * 500
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
        status.Text = "Fly disabled"
        verticalSpeed = 0
        
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
    
    -- Update fly speed
    local function updateFlySpeed(newSpeed)
        flySpeed = math.clamp(newSpeed, 20, 100)
        speedLabel.Text = "FLY SPEED: " .. flySpeed
        speedFill.Size = UDim2.new((flySpeed - 20) / 80, 0, 1, 0)
        
        if flying and bodyVelocity then
            bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000) * flySpeed
            status.Text = "Flying at speed: " .. flySpeed
        end
    end
    
    -- Button events
    flyBtn.MouseButton1Click:Connect(function()
        if flying then
            disableFly()
        else
            enableFly()
        end
    end)
    
    upBtn.MouseButton1Down:Connect(function()
        verticalSpeed = 30
    end)
    
    upBtn.MouseButton1Up:Connect(function()
        verticalSpeed = 0
    end)
    
    downBtn.MouseButton1Down:Connect(function()
        verticalSpeed = -30
    end)
    
    downBtn.MouseButton1Up:Connect(function()
        verticalSpeed = 0
    end)
    
    -- Speed slider interaction
    local draggingSlider = false
    speedSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = true
        end
    end)
    
    speedSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local relativeX = math.clamp((input.Position.X - speedSlider.AbsolutePosition.X) / speedSlider.AbsoluteSize.X, 0, 1)
            updateFlySpeed(20 + (relativeX * 80))
        end
    end)
    
    -- Fly movement update
    game:GetService("RunService").Heartbeat:Connect(function()
        if flying and bodyVelocity and bodyGyro then
            local camera = workspace.CurrentCamera
            local lookVector = camera.CFrame.LookVector
            local rightVector = camera.CFrame.RightVector
            
            local direction = Vector3.new(0, verticalSpeed, 0)
            
            -- Get input for movement
            local moveVector = Vector2.new(0, 0)
            
            -- Apply movement
            if direction.Magnitude > 0 then
                direction = direction.Unit * flySpeed
            end
            
            -- Update velocity
            bodyVelocity.Velocity = direction
            
            -- Update gyro to face camera direction
            bodyGyro.CFrame = camera.CFrame
        end
    end)
    
    -- Initial setup
    updateFlySpeed(50)
end

-- Buat sidebar buttons
local button1, highlight1 = createSidebarButton("Auto Obby", "rbxassetid://10734975645", 10)
local button2, highlight2 = createSidebarButton("Checkpoints", "rbxassetid://10734973111", 70)
local button3, highlight3 = createSidebarButton("Teleport Players", "rbxassetid://10734968922", 130)
local button4, highlight4 = createSidebarButton("Fly System", "rbxassetid://10734967234", 190)

-- Parent buttons
button1.Parent = sidebar
button2.Parent = sidebar
button3.Parent = sidebar
button4.Parent = sidebar

-- Store highlights
moduleHighlights["Auto Obby"] = highlight1
moduleHighlights["Checkpoints"] = highlight2
moduleHighlights["Teleport Players"] = highlight3
moduleHighlights["Fly System"] = highlight4

-- Function untuk load module
local function loadModule(moduleName)
    -- Reset semua highlights
    for name, highlight in pairs(moduleHighlights) do
        highlight.Visible = (name == moduleName)
    end
    
    -- Reset semua button colors
    for _, btn in ipairs(sidebar:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        end
    end
    
    -- Highlight button aktif
    local activeBtn = sidebar:FindFirstChild(moduleName .. "Button") or 
                     sidebar:FindFirstChild(moduleName:gsub(" ", "") .. "Button")
    if activeBtn then
        activeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    end
    
    -- Set active module
    activeModule = moduleName
    
    -- Load module
    if moduleName == "Auto Obby" then
        loadAutoObby()
    elseif moduleName == "Checkpoints" then
        loadCheckpoints()
    elseif moduleName == "Teleport Players" then
        loadTeleportPlayers()
    elseif moduleName == "Fly System" then
        loadFlySystem()
    end
    
    -- Update scroll size
    rightScroll.CanvasSize = UDim2.new(0, 0, 0, rightLayout.AbsoluteContentSize.Y + 20)
end

-- Connect button clicks
button1.MouseButton1Click:Connect(function() loadModule("Auto Obby") end)
button2.MouseButton1Click:Connect(function() loadModule("Checkpoints") end)
button3.MouseButton1Click:Connect(function() loadModule("Teleport Players") end)
button4.MouseButton1Click:Connect(function() loadModule("Fly System") end)

-- Load module pertama
loadModule("Auto Obby")

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

-- Close button function
closeBtn.MouseButton1Click:Connect(function()
    screen:Destroy()
end)

-- Print success
print("==========================================")
print("DELTA EXECUTOR - ALL IN ONE")
print("Blue Panther | 65")
print("EXP Mx.Vanzyxxx")
print("@AlfredR0rw")
print("==========================================")

-- Return screen untuk kontrol eksternal
return screen