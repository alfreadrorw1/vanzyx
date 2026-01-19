-- Fly Module dengan kontrol analog
local module = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local plr = Players.LocalPlayer
local active = false
local flyController = nil
local connections = {}

local FLY_SPEED = 100
local TILT_SPEED = 2

local function createFlySystem(character)
    if not character then return nil end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not hrp or not humanoid then return nil end
    
    -- Buat velocity dan gyro
    local velocity = Instance.new("BodyVelocity")
    velocity.Velocity = Vector3.new(0, 0, 0)
    velocity.MaxForce = Vector3.new(100000, 100000, 100000)
    velocity.P = 1250
    
    local gyro = Instance.new("BodyGyro")
    gyro.MaxTorque = Vector3.new(50000, 50000, 50000)
    gyro.P = 3000
    gyro.D = 500
    gyro.CFrame = hrp.CFrame
    
    velocity.Parent = hrp
    gyro.Parent = hrp
    
    -- State untuk kontrol
    local moveDirection = Vector3.new(0, 0, 0)
    local camera = workspace.CurrentCamera
    
    -- Fungsi update movement
    local function updateMovement()
        if not hrp or not hrp.Parent or not camera then return end
        
        -- Hitung arah berdasarkan input
        local forward = camera.CFrame.LookVector * moveDirection.Z
        local right = camera.CFrame.RightVector * moveDirection.X
        local up = Vector3.new(0, moveDirection.Y, 0)
        
        local direction = forward + right + up
        
        if direction.Magnitude > 0 then
            direction = direction.Unit * FLY_SPEED
        end
        
        velocity.Velocity = direction
        
        -- Update rotation untuk ikut kamera
        gyro.CFrame = CFrame.new(hrp.Position, hrp.Position + camera.CFrame.LookVector)
    end
    
    -- Keyboard controls
    local function onInputBegan(input, gameProcessed)
        if gameProcessed then return end
        
        -- Movement keys
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
    
    -- Touch/analog controls
    local touchStartPos = nil
    local touchActive = false
    
    local function onTouchBegan(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.Touch then
            touchStartPos = input.Position
            touchActive = true
        end
    end
    
    local function onTouchMoved(input, gameProcessed)
        if gameProcessed or not touchStartPos then return end
        
        if input.UserInputType == Enum.UserInputType.Touch and touchActive then
            local delta = input.Position - touchStartPos
            local sensitivity = 0.005
            
            -- Analog stick simulation
            moveDirection = Vector3.new(
                math.clamp(delta.X * sensitivity, -1, 1),
                moveDirection.Y,
                math.clamp(-delta.Y * sensitivity, -1, 1)  -- Inverted Y for natural feel
            )
            
            updateMovement()
        end
    end
    
    local function onTouchEnded(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.Touch then
            touchActive = false
            touchStartPos = nil
            
            -- Reset horizontal movement
            moveDirection = Vector3.new(0, moveDirection.Y, 0)
            updateMovement()
        end
    end
    
    -- Connect semua event
    local conn1 = UserInputService.InputBegan:Connect(onInputBegan)
    local conn2 = UserInputService.InputEnded:Connect(onInputEnded)
    local conn3 = UserInputService.TouchStarted:Connect(onTouchBegan)
    local conn4 = UserInputService.TouchMoved:Connect(onTouchMoved)
    local conn5 = UserInputService.TouchEnded:Connect(onTouchEnded)
    
    -- Update loop
    local renderConn = RunService.RenderStepped:Connect(updateMovement)
    
    -- Simpan semua connections
    table.insert(connections, conn1)
    table.insert(connections, conn2)
    table.insert(connections, conn3)
    table.insert(connections, conn4)
    table.insert(connections, conn5)
    table.insert(connections, renderConn)
    
    return {
        velocity = velocity,
        gyro = gyro,
        setSpeed = function(speed)
            FLY_SPEED = speed
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
    if active then return flyController end
    
    active = true
    
    -- Tunggu character
    local character = plr.Character
    if not character then
        character = plr.CharacterAdded:Wait()
    end
    
    repeat task.wait(0.1) until character:FindFirstChild("HumanoidRootPart")
    
    -- Buat fly system
    flyController = createFlySystem(character)
    
    -- Handle respawn
    local charConn = plr.CharacterAdded:Connect(function(newChar)
        task.wait(1)
        
        if flyController then
            flyController.destroy()
        end
        
        repeat task.wait(0.1) until newChar:FindFirstChild("HumanoidRootPart")
        flyController = createFlySystem(newChar)
    end)
    
    table.insert(connections, charConn)
    
    return flyController
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
    
    flyController = nil
end

return module