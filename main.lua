-- Vanzyxxx Auto Script - Modular Version (Fixed)
-- Main controller with GUI and module management

if not game:GetService("RunService"):IsClient() then
    return
end

-- Prevent duplicate execution
if _G.VanzyxxxLoaded then return end
_G.VanzyxxxLoaded = true

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Player
local plr = Players.LocalPlayer

-- Wait for player
repeat task.wait() until plr
repeat task.wait() until plr.PlayerGui

-- Module loader dengan fallback
local function loadModule(moduleName)
    local moduleCode = ""
    
    -- Built-in modules sebagai fallback
    if moduleName == "autocp.lua" then
        moduleCode = [[
            local module = {}
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local plr = Players.LocalPlayer
            
            local active = false
            local teleporting = false
            
            local function waitForCharacter()
                local character = plr.Character
                if not character then
                    character = plr.CharacterAdded:Wait()
                end
                repeat task.wait(0.1) until character:FindFirstChild("HumanoidRootPart")
                return character
            end
            
            local function safeTeleport(hrp, position)
                if not hrp or not hrp.Parent then return false end
                
                local humanoid = hrp.Parent:FindFirstChild("Humanoid")
                local originalCollision = hrp.CanCollide
                
                -- Disable collisions
                hrp.CanCollide = false
                
                -- Store original properties
                local originalWalkSpeed, originalJumpPower
                if humanoid then
                    originalWalkSpeed = humanoid.WalkSpeed
                    originalJumpPower = humanoid.JumpPower
                    humanoid.WalkSpeed = 0
                    humanoid.JumpPower = 0
                end
                
                -- Smooth teleport
                hrp.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
                
                -- Wait for physics
                RunService.Heartbeat:Wait()
                RunService.Heartbeat:Wait()
                
                -- Restore
                hrp.CanCollide = originalCollision
                if humanoid then
                    humanoid.WalkSpeed = originalWalkSpeed or 16
                    humanoid.JumpPower = originalJumpPower or 50
                end
                
                return true
            end
            
            local function getCheckpoints()
                local checkpoints = {}
                local visited = {}
                
                -- Cari semua checkpoint
                for _, obj in pairs(workspace:GetDescendants()) do
                    if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and not visited[obj] then
                        local name = obj.Name:lower()
                        if name:find("checkpoint") or name:find("cp") or 
                           name:find("flag") or name:find("point") or
                           name:find("stage") or name:find("level") then
                            
                            table.insert(checkpoints, {
                                Part = obj,
                                Position = obj.Position
                            })
                            visited[obj] = true
                            
                        elseif obj.Parent then
                            local parentName = obj.Parent.Name:lower()
                            if parentName:find("checkpoint") or parentName:find("cp") then
                                table.insert(checkpoints, {
                                    Part = obj,
                                    Position = obj.Position
                                })
                                visited[obj] = true
                            end
                        end
                    end
                end
                
                -- Cari di Model juga
                for _, model in pairs(workspace:GetChildren()) do
                    if model:IsA("Model") then
                        local modelName = model.Name:lower()
                        if modelName:find("checkpoint") or modelName:find("cp") then
                            local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                            if primary and not visited[primary] then
                                table.insert(checkpoints, {
                                    Part = primary,
                                    Position = primary.Position
                                })
                                visited[primary] = true
                            end
                        end
                    end
                end
                
                -- Sort by Z position (game progression)
                table.sort(checkpoints, function(a, b)
                    return a.Position.Z < b.Position.Z
                end)
                
                return checkpoints
            end
            
            function module.start()
                if active then return end
                active = true
                
                local statusFunc = function(msg) end -- Placeholder
                
                coroutine.wrap(function()
                    local character = waitForCharacter()
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    
                    while active do
                        statusFunc("🔍 Mencari checkpoint...")
                        local checkpoints = getCheckpoints()
                        
                        if #checkpoints == 0 then
                            statusFunc("❌ Tidak ada checkpoint ditemukan")
                            task.wait(2)
                        else
                            statusFunc("🎯 Ditemukan " .. #checkpoints .. " checkpoint")
                            
                            for i, cp in ipairs(checkpoints) do
                                if not active then break end
                                
                                statusFunc("📍 Checkpoint " .. i .. "/" .. #checkpoints)
                                
                                if safeTeleport(hrp, cp.Position) then
                                    for _ = 1, 3 do
                                        if not active then break end
                                        RunService.Heartbeat:Wait()
                                    end
                                end
                                
                                local elapsed = 0
                                while elapsed < 0.3 and active do
                                    RunService.Heartbeat:Wait()
                                    elapsed = elapsed + RunService.Heartbeat:Wait()
                                end
                            end
                            
                            if active then
                                statusFunc("✅ Semua checkpoint selesai")
                                task.wait(2)
                            end
                        end
                    end
                end)()
                
                return {
                    stop = function()
                        active = false
                    end
                }
            end
            
            function module.stop(instance)
                active = false
            end
            
            return module
        ]]
        
    elseif moduleName == "fly.lua" then
        moduleCode = [[
            local module = {}
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local UserInputService = game:GetService("UserInputService")
            local ContextActionService = game:GetService("ContextActionService")
            
            local plr = Players.LocalPlayer
            local active = false
            local flyInstance = nil
            local connections = {}
            
            local FLY_SPEED = 100
            local TILT_AMOUNT = 0.5
            
            local function createFlyController(character)
                if not character then return nil end
                
                local hrp = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChild("Humanoid")
                
                if not hrp or not humanoid then return nil end
                
                -- Buat controller untuk fly
                local velocity = Instance.new("BodyVelocity")
                velocity.Velocity = Vector3.new(0, 0, 0)
                velocity.MaxForce = Vector3.new(100000, 100000, 100000)
                velocity.P = 1250
                velocity.Name = "FlyVelocity"
                
                local gyro = Instance.new("BodyGyro")
                gyro.MaxTorque = Vector3.new(50000, 50000, 50000)
                gyro.P = 3000
                gyro.D = 500
                gyro.CFrame = hrp.CFrame
                gyro.Name = "FlyGyro"
                
                velocity.Parent = hrp
                gyro.Parent = hrp
                
                -- Input untuk mobile touch
                local touchStartPosition = nil
                local touchStartTime = 0
                local isTouching = false
                
                -- Control dengan keyboard/mouse
                local moveDirection = Vector3.new(0, 0, 0)
                local isMoving = false
                
                local function updateMovement()
                    if not hrp or not hrp.Parent then return end
                    
                    -- Hitung arah gerakan
                    local camera = workspace.CurrentCamera
                    if not camera then return end
                    
                    local forward = camera.CFrame.LookVector * moveDirection.Z
                    local right = camera.CFrame.RightVector * moveDirection.X
                    local up = Vector3.new(0, moveDirection.Y, 0)
                    
                    local direction = forward + right + up
                    
                    if direction.Magnitude > 0 then
                        direction = direction.Unit * FLY_SPEED
                        isMoving = true
                    else
                        isMoving = false
                    end
                    
                    velocity.Velocity = direction
                    
                    -- Update gyro untuk ikut kamera
                    gyro.CFrame = CFrame.new(hrp.Position, hrp.Position + camera.CFrame.LookVector)
                end
                
                -- Keyboard controls
                local function onInputBegan(input, gameProcessed)
                    if gameProcessed then return end
                    
                    if input.KeyCode == Enum.KeyCode.W then
                        moveDirection = Vector3.new(moveDirection.X, moveDirection.Y, 1)
                    elseif input.KeyCode == Enum.KeyCode.S then
                        moveDirection = Vector3.new(moveDirection.X, moveDirection.Y, -1)
                    elseif input.KeyCode == Enum.KeyCode.A then
                        moveDirection = Vector3.new(-1, moveDirection.Y, moveDirection.Z)
                    elseif input.KeyCode == Enum.KeyCode.D then
                        moveDirection = Vector3.new(1, moveDirection.Y, moveDirection.Z)
                    elseif input.KeyCode == Enum.KeyCode.Space then
                        moveDirection = Vector3.new(moveDirection.X, 1, moveDirection.Z)
                    elseif input.KeyCode == Enum.KeyCode.LeftControl then
                        moveDirection = Vector3.new(moveDirection.X, -1, moveDirection.Z)
                    end
                    
                    updateMovement()
                end
                
                local function onInputEnded(input, gameProcessed)
                    if gameProcessed then return end
                    
                    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S then
                        moveDirection = Vector3.new(moveDirection.X, moveDirection.Y, 0)
                    elseif input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
                        moveDirection = Vector3.new(0, moveDirection.Y, moveDirection.Z)
                    elseif input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftControl then
                        moveDirection = Vector3.new(moveDirection.X, 0, moveDirection.Z)
                    end
                    
                    updateMovement()
                end
                
                -- Touch controls untuk mobile
                local function onTouchBegan(input, gameProcessed)
                    if gameProcessed then return end
                    
                    if input.UserInputType == Enum.UserInputType.Touch then
                        touchStartPosition = input.Position
                        touchStartTime = tick()
                        isTouching = true
                    end
                end
                
                local function onTouchMoved(input, gameProcessed)
                    if gameProcessed or not touchStartPosition then return end
                    
                    if input.UserInputType == Enum.UserInputType.Touch and isTouching then
                        local delta = input.Position - touchStartPosition
                        local sensitivity = 0.01
                        
                        -- Horizontal movement
                        moveDirection = Vector3.new(
                            math.clamp(delta.X * sensitivity, -1, 1),
                            moveDirection.Y,
                            math.clamp(-delta.Y * sensitivity, -1, 1)  -- Inverse Y untuk natural control
                        )
                        
                        updateMovement()
                    end
                end
                
                local function onTouchEnded(input, gameProcessed)
                    if gameProcessed then return end
                    
                    if input.UserInputType == Enum.UserInputType.Touch then
                        isTouching = false
                        touchStartPosition = nil
                        
                        -- Reset movement jika tidak ada input lain
                        moveDirection = Vector3.new(0, moveDirection.Y, 0)
                        updateMovement()
                    end
                end
                
                -- Virtual joystick untuk mobile
                local function setupVirtualJoystick()
                    -- Akan dibuat di GUI nanti
                end
                
                -- Connect input events
                local inputBegan = UserInputService.InputBegan:Connect(onInputBegan)
                local inputEnded = UserInputService.InputEnded:Connect(onInputEnded)
                local touchBegan = UserInputService.TouchStarted:Connect(onTouchBegan)
                local touchMoved = UserInputService.TouchMoved:Connect(onTouchMoved)
                local touchEnded = UserInputService.TouchEnded:Connect(onTouchEnded)
                
                -- Update loop
                local renderConnection
                renderConnection = RunService.RenderStepped:Connect(updateMovement)
                
                -- Store connections
                table.insert(connections, inputBegan)
                table.insert(connections, inputEnded)
                table.insert(connections, touchBegan)
                table.insert(connections, touchMoved)
                table.insert(connections, touchEnded)
                table.insert(connections, renderConnection)
                
                return {
                    velocity = velocity,
                    gyro = gyro,
                    updateSpeed = function(newSpeed)
                        FLY_SPEED = newSpeed
                    end,
                    destroy = function()
                        if velocity then velocity:Destroy() end
                        if gyro then gyro:Destroy() end
                        
                        for _, conn in ipairs(connections) do
                            conn:Disconnect()
                        end
                        connections = {}
                    end
                }
            end
            
            function module.start()
                if active then return flyInstance end
                
                active = true
                
                -- Wait for character
                local character = plr.Character
                if not character then
                    character = plr.CharacterAdded:Wait()
                end
                
                repeat task.wait(0.1) until character:FindFirstChild("HumanoidRootPart")
                
                -- Create fly controller
                flyInstance = createFlyController(character)
                
                -- Handle respawn
                local charAddedConn
                charAddedConn = plr.CharacterAdded:Connect(function(newChar)
                    task.wait(1)
                    
                    if flyInstance then
                        flyInstance.destroy()
                    end
                    
                    repeat task.wait(0.1) until newChar:FindFirstChild("HumanoidRootPart")
                    flyInstance = createFlyController(newChar)
                end)
                
                table.insert(connections, charAddedConn)
                
                return flyInstance
            end
            
            function module.stop(instance)
                active = false
                
                if instance then
                    instance.destroy()
                end
                
                for _, conn in ipairs(connections) do
                    conn:Disconnect()
                end
                connections = {}
                
                flyInstance = nil
            end
            
            return module
        ]]
        
    elseif moduleName == "autocarry.lua" then
        moduleCode = [[
            local module = {}
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            
            local plr = Players.LocalPlayer
            local active = false
            local carryConnections = {}
            local carriedPlayers = {}
            
            local function waitForCharacter(player)
                local character = player.Character
                if not character then
                    character = player.CharacterAdded:Wait()
                end
                repeat task.wait(0.1) until character:FindFirstChild("HumanoidRootPart")
                return character
            end
            
            local function carryPlayer(targetPlayer)
                if targetPlayer == plr or carriedPlayers[targetPlayer] then
                    return
                end
                
                carriedPlayers[targetPlayer] = true
                
                coroutine.wrap(function()
                    local myCharacter = waitForCharacter(plr)
                    local myHRP = myCharacter:FindFirstChild("HumanoidRootPart")
                    
                    local theirCharacter = waitForCharacter(targetPlayer)
                    local theirHRP = theirCharacter:FindFirstChild("HumanoidRootPart")
                    
                    if not myHRP or not theirHRP then
                        carriedPlayers[targetPlayer] = nil
                        return
                    end
                    
                    -- Update position periodically
                    local updateConnection
                    updateConnection = RunService.Heartbeat:Connect(function()
                        if not active or not myHRP or not theirHRP or not myHRP.Parent or not theirHRP.Parent then
                            if updateConnection then
                                updateConnection:Disconnect()
                            end
                            carriedPlayers[targetPlayer] = nil
                            return
                        end
                        
                        -- Keep their character near ours
                        theirHRP.CFrame = myHRP.CFrame + Vector3.new(0, 3, 0)
                    end)
                    
                    table.insert(carryConnections, updateConnection)
                    
                    -- Handle target player leaving
                    local playerLeftConnection
                    playerLeftConnection = targetPlayer.CharacterRemoving:Connect(function()
                        if updateConnection then
                            updateConnection:Disconnect()
                        end
                        carriedPlayers[targetPlayer] = nil
                    end)
                    
                    table.insert(carryConnections, playerLeftConnection)
                end)()
            end
            
            local function startCarryingAll()
                for _, player in ipairs(Players:GetPlayers()) do
                    carryPlayer(player)
                end
                
                local playerAddedConnection
                playerAddedConnection = Players.PlayerAdded:Connect(function(player)
                    task.wait(2)
                    if active then
                        carryPlayer(player)
                    end
                end)
                
                table.insert(carryConnections, playerAddedConnection)
            end
            
            local function stopCarryingAll()
                carriedPlayers = {}
                
                for _, conn in ipairs(carryConnections) do
                    conn:Disconnect()
                end
                carryConnections = {}
            end
            
            function module.start()
                if active then return end
                
                active = true
                startCarryingAll()
                
                return {
                    stop = function()
                        active = false
                        stopCarryingAll()
                    end
                }
            end
            
            function module.stop(instance)
                active = false
                stopCarryingAll()
            end
            
            return module
        ]]
    end
    
    -- Try to load from GitHub first, then fallback to built-in
    local success, loadedModule = pcall(function()
        local url = "https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/" .. moduleName
        local response = game:HttpGet(url, true)
        return loadstring(response)()
    end)
    
    if success then
        return loadedModule
    else
        print("[Vanzyxxx] Using built-in module for:", moduleName)
        return loadstring(moduleCode)()
    end
end

-- Initialize modules
local Modules = {
    AutoCP = loadModule("autocp.lua"),
    Fly = loadModule("fly.lua"),
    AutoCarry = loadModule("autocarry.lua")
}

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VanzyxxxGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = plr.PlayerGui

-- Remove duplicate GUI
for _, gui in ipairs(plr.PlayerGui:GetChildren()) do
    if gui.Name == "VanzyxxxGUI" and gui ~= ScreenGui then
        gui:Destroy()
    end
end

-- ========================
-- FLOATING DRAGGABLE LOGO
-- ========================
local logo = Instance.new("ImageButton")
logo.Name = "Logo"
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(1, -70, 0.5, -30)
logo.AnchorPoint = Vector2.new(1, 0.5)
logo.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
logo.BackgroundTransparency = 0.3
logo.Image = "rbxassetid://6764432408"
logo.Parent = ScreenGui

-- Logo styling
local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0.2, 0)
logoCorner.Parent = logo

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(100, 150, 255)
logoStroke.Thickness = 2
logoStroke.Parent = logo

-- Logo drag functionality
local dragging = false
local dragInput, dragStart, startPos

local function updateLogoPosition()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    logo.Position = UDim2.new(
        math.clamp(logo.Position.X.Scale, 0, 1),
        math.clamp(logo.Position.X.Offset, 0, viewportSize.X - logo.AbsoluteSize.X),
        math.clamp(logo.Position.Y.Scale, 0, 1),
        math.clamp(logo.Position.Y.Offset, 0, viewportSize.Y - logo.AbsoluteSize.Y)
    )
end

logo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput) and dragStart then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        logo.Position = newPos
        updateLogoPosition()
    end
end)

-- Handle screen resize
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLogoPosition)
updateLogoPosition()

-- ========================
-- VERTICAL MENU
-- ========================
local menuVisible = false
local menu = Instance.new("Frame")
menu.Name = "Menu"
menu.Size = UDim2.new(0, 300, 0, 400)
menu.Position = UDim2.new(0, -310, 0.5, -200)
menu.AnchorPoint = Vector2.new(0, 0.5)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
menu.BackgroundTransparency = 0.1
menu.BorderSizePixel = 0
menu.Visible = false
menu.Parent = ScreenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 12)
menuCorner.Parent = menu

-- Menu header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
header.BorderSizePixel = 0
header.Parent = menu

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Text = "🚀 VANZYXXX"
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Text = "Auto Script System"
subtitle.Size = UDim2.new(1, -50, 0, 20)
subtitle.Position = UDim2.new(0, 15, 0, 30)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.fromRGB(200, 200, 255)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 12
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

-- Close button
local closeBtn = Instance.new("ImageButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0.5, -17.5)
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.BackgroundTransparency = 1
closeBtn.Image = "rbxassetid://6031091004"
closeBtn.ImageColor3 = Color3.fromRGB(220, 80, 80)
closeBtn.Parent = header

-- Status display
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Size = UDim2.new(1, -20, 0, 50)
statusFrame.Position = UDim2.new(0, 10, 0, 70)
statusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
statusFrame.Parent = menu

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Text = "✅ READY"
statusLabel.Size = UDim2.new(1, 0, 1, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextSize = 16
statusLabel.Parent = statusFrame

-- Toggles container
local togglesFrame = Instance.new("ScrollingFrame")
togglesFrame.Name = "Toggles"
togglesFrame.Size = UDim2.new(1, -20, 1, -140)
togglesFrame.Position = UDim2.new(0, 10, 0, 130)
togglesFrame.BackgroundTransparency = 1
togglesFrame.BorderSizePixel = 0
togglesFrame.ScrollBarThickness = 4
togglesFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
togglesFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
togglesFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
togglesFrame.Parent = menu

local togglesLayout = Instance.new("UIListLayout")
togglesLayout.Padding = UDim.new(0, 10)
togglesLayout.Parent = togglesFrame

-- ========================
-- TOGGLE CREATION
-- ========================
local ToggleStates = {
    AutoCP = false,
    Fly = false,
    AutoCarry = false
}

local ActiveModules = {}

-- Fungsi untuk update status
local function updateStatus(message)
    statusLabel.Text = message
    print("[Vanzyxxx]", message)
end

local function createToggle(name, description, defaultColor, activeColor)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name .. "Toggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, 70)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    toggleFrame.BackgroundTransparency = 0.1
    toggleFrame.Parent = togglesFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Text = name
    toggleLabel.Size = UDim2.new(0.7, -10, 0.5, 0)
    toggleLabel.Position = UDim2.new(0, 15, 0, 10)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.Font = Enum.Font.GothamBold
    toggleLabel.TextSize = 18
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Text = description
    descLabel.Size = UDim2.new(0.7, -10, 0.5, 0)
    descLabel.Position = UDim2.new(0, 15, 0, 35)
    descLabel.BackgroundTransparency = 1
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 12
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = toggleFrame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleButton"
    toggleBtn.Text = "OFF"
    toggleBtn.Size = UDim2.new(0.25, 0, 0.6, 0)
    toggleBtn.Position = UDim2.new(0.75, -10, 0.2, 0)
    toggleBtn.BackgroundColor3 = defaultColor
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 14
    toggleBtn.Parent = toggleFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = toggleBtn
    
    -- Toggle functionality
    toggleBtn.MouseButton1Click:Connect(function()
        ToggleStates[name] = not ToggleStates[name]
        
        if ToggleStates[name] then
            toggleBtn.Text = "ON"
            toggleBtn.BackgroundColor3 = activeColor
            
            -- Start module
            if Modules[name] then
                ActiveModules[name] = Modules[name].start()
                updateStatus("▶️ " .. name .. " ENABLED")
            end
        else
            toggleBtn.Text = "OFF"
            toggleBtn.BackgroundColor3 = defaultColor
            
            -- Stop module
            if ActiveModules[name] then
                Modules[name].stop(ActiveModules[name])
                ActiveModules[name] = nil
                updateStatus("✅ READY")
            end
        end
    end)
    
    return toggleFrame
end

-- Create all toggles
createToggle("AutoCP", "Auto complete checkpoints", Color3.fromRGB(80, 80, 120), Color3.fromRGB(50, 180, 80))
createToggle("Fly", "Enable flight mode", Color3.fromRGB(80, 80, 120), Color3.fromRGB(50, 120, 220))
createToggle("AutoCarry", "Carry all players", Color3.fromRGB(80, 80, 120), Color3.fromRGB(220, 120, 50))

-- ========================
-- MOBILE CONTROLS FOR FLY
-- ========================
-- Virtual joystick untuk mobile fly control
local joystick = Instance.new("Frame")
joystick.Name = "MobileJoystick"
joystick.Size = UDim2.new(0, 150, 0, 150)
joystick.Position = UDim2.new(0, 20, 1, -170)
joystick.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
joystick.BackgroundTransparency = 0.7
joystick.Visible = false
joystick.Parent = ScreenGui

local joystickCorner = Instance.new("UICorner")
joystickCorner.CornerRadius = UDim.new(1, 0)
joystickCorner.Parent = joystick

local joystickHandle = Instance.new("Frame")
joystickHandle.Name = "Handle"
joystickHandle.Size = UDim2.new(0, 50, 0, 50)
joystickHandle.Position = UDim2.new(0.5, -25, 0.5, -25)
joystickHandle.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
joystickHandle.BackgroundTransparency = 0.5
joystickHandle.Parent = joystick

local handleCorner = Instance.new("UICorner")
handleCorner.CornerRadius = UDim.new(1, 0)
handleCorner.Parent = joystickHandle

-- Fly movement controls
local flyMovement = {
    Forward = false,
    Backward = false,
    Left = false,
    Right = false,
    Up = false,
    Down = false
}

-- Mobile control buttons
local mobileControls = Instance.new("Frame")
mobileControls.Name = "MobileControls"
mobileControls.Size = UDim2.new(0, 120, 0, 120)
mobileControls.Position = UDim2.new(1, -140, 1, -130)
mobileControls.BackgroundTransparency = 1
mobileControls.Visible = false
mobileControls.Parent = ScreenGui

local function createMobileButton(name, position, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    btn.BackgroundTransparency = 0.5
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = mobileControls
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0.3, 0)
    btnCorner.Parent = btn
    
    btn.MouseButton1Down:Connect(function()
        callback(true)
    end)
    
    btn.MouseButton1Up:Connect(function()
        callback(false)
    end)
    
    btn.TouchLongPress:Connect(function()
        callback(true)
    end)
    
    btn.TouchEnded:Connect(function()
        callback(false)
    end)
    
    return btn
end

-- Create mobile control buttons
createMobileButton("UP", UDim2.new(0.5, -25, 0, 0), function(state)
    flyMovement.Up = state
end)

createMobileButton("DOWN", UDim2.new(0.5, -25, 0.66, 0), function(state)
    flyMovement.Down = state
end)

createMobileButton("LEFT", UDim2.new(0, 0, 0.33, -25), function(state)
    flyMovement.Left = state
end)

createMobileButton("RIGHT", UDim2.new(1, -50, 0.33, -25), function(state)
    flyMovement.Right = state
end)

-- ========================
-- MENU ANIMATION
-- ========================
local function toggleMenu()
    menuVisible = not menuVisible
    
    if menuVisible then
        menu.Visible = true
        local tween = TweenService:Create(menu, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 10, 0.5, -200)
        })
        tween:Play()
        
        -- Show mobile controls if fly is active
        if ToggleStates.Fly then
            mobileControls.Visible = true
            joystick.Visible = true
        end
    else
        local tween = TweenService:Create(menu, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, -310, 0.5, -200)
        })
        tween:Play()
        
        tween.Completed:Connect(function()
            if not menuVisible then
                menu.Visible = false
                mobileControls.Visible = false
                joystick.Visible = false
                
                -- Stop all active modules when menu closes
                for name, _ in pairs(ActiveModules) do
                    if Modules[name] then
                        Modules[name].stop(ActiveModules[name])
                    end
                    ToggleStates[name] = false
                end
                ActiveModules = {}
                
                -- Update toggle buttons
                for _, toggle in ipairs(togglesFrame:GetChildren()) do
                    if toggle:IsA("Frame") then
                        local toggleBtn = toggle:FindFirstChild("ToggleButton")
                        if toggleBtn then
                            toggleBtn.Text = "OFF"
                            toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
                        end
                    end
                end
                
                updateStatus("✅ READY")
            end
        end)
    end
end

-- Connect logo and close button
logo.MouseButton1Click:Connect(toggleMenu)
closeBtn.MouseButton1Click:Connect(toggleMenu)

-- ========================
-- RESPONSIVE DESIGN
-- ========================
local function updateLayout()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local isMobile = UserInputService.TouchEnabled
    
    if isMobile then
        -- Mobile layout
        logo.Size = UDim2.new(0, 70, 0, 70)
        logo.Position = UDim2.new(1, -80, 1, -80)
        
        mobileControls.Visible = ToggleStates.Fly and menuVisible
        joystick.Visible = ToggleStates.Fly and menuVisible
        
        if viewportSize.Y > viewportSize.X then
            -- Portrait
            menu.Size = UDim2.new(0.9, 0, 0, 400)
            menu.Position = UDim2.new(0.05, -menu.AbsoluteSize.X, 0.5, -200)
        else
            -- Landscape
            menu.Size = UDim2.new(0, 320, 0, 400)
            menu.Position = UDim2.new(0, -330, 0.5, -200)
        end
    else
        -- Desktop layout
        logo.Size = UDim2.new(0, 60, 0, 60)
        menu.Size = UDim2.new(0, 300, 0, 400)
        mobileControls.Visible = false
        joystick.Visible = false
    end
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLayout)
UserInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(updateLayout)
updateLayout()

-- ========================
-- AUTO-START FLY MODULE
-- ========================
task.wait(1)

-- Auto-enable Fly on start
if Modules.Fly then
    ToggleStates.Fly = true
    ActiveModules.Fly = Modules.Fly.start()
    updateStatus("✈️ FLY ENABLED (WASD + Space/Ctrl)")
    
    -- Update toggle button
    for _, toggle in ipairs(togglesFrame:GetChildren()) do
        if toggle:IsA("Frame") and toggle.Name == "FlyToggle" then
            local toggleBtn = toggle:FindFirstChild("ToggleButton")
            if toggleBtn then
                toggleBtn.Text = "ON"
                toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
            end
        end
    end
end

-- Auto-show menu on start
toggleMenu()

-- Auto-hide menu after 5 seconds
task.wait(5)
if menuVisible then
    toggleMenu()
end

-- Handle respawn
plr.CharacterAdded:Connect(function(character)
    task.wait(1) -- Wait for character to fully load
    
    -- Re-enable active modules
    for name, _ in pairs(ActiveModules) do
        if Modules[name] then
            Modules[name].stop(ActiveModules[name])
            ActiveModules[name] = Modules[name].start()
        end
    end
end)

-- Mobile joystick control
local joystickActive = false
local joystickStartPos = nil

joystick.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        joystickActive = true
        joystickStartPos = input.Position
    end
end)

joystick.InputChanged:Connect(function(input)
    if joystickActive and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - joystickStartPos
        local maxRadius = joystick.AbsoluteSize.X / 2 - joystickHandle.AbsoluteSize.X / 2
        
        -- Calculate normalized direction
        local direction = Vector2.new(
            math.clamp(delta.X, -maxRadius, maxRadius),
            math.clamp(delta.Y, -maxRadius, maxRadius)
        ) / maxRadius
        
        -- Update handle position
        joystickHandle.Position = UDim2.new(
            0.5, direction.X * maxRadius,
            0.5, direction.Y * maxRadius
        )
        
        -- Update fly movement
        flyMovement.Forward = direction.Y < -0.2
        flyMovement.Backward = direction.Y > 0.2
        flyMovement.Left = direction.X < -0.2
        flyMovement.Right = direction.X > 0.2
    end
end)

joystick.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        joystickActive = false
        joystickStartPos = nil
        
        -- Reset handle
        local tween = TweenService:Create(joystickHandle, TweenInfo.new(0.2), {
            Position = UDim2.new(0.5, -25, 0.5, -25)
        })
        tween:Play()
        
        -- Reset movement
        flyMovement.Forward = false
        flyMovement.Backward = false
        flyMovement.Left = false
        flyMovement.Right = false
    end
end)

print("[Vanzyxxx] System fully loaded!")