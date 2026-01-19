-- Fly Module
-- Provides flight functionality with smooth controls

local module = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Player
local plr = Players.LocalPlayer

-- Module state
local active = false
local flyInstance = nil
local connections = {}

-- Configuration
local FLY_SPEED = 50
local FLY_KEYBINDS = {
    Forward = Enum.KeyCode.W,
    Backward = Enum.KeyCode.S,
    Left = Enum.KeyCode.A,
    Right = Enum.KeyCode.D,
    Up = Enum.KeyCode.Space,
    Down = Enum.KeyCode.LeftControl
}

local function createFlyController(character)
    if not character then return nil end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not hrp or not humanoid then return nil end
    
    -- Create fly controllers
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
    
    -- Attach to HRP
    velocity.Parent = hrp
    gyro.Parent = hrp
    
    -- Store input states
    local inputs = {
        Forward = false,
        Backward = false,
        Left = false,
        Right = false,
        Up = false,
        Down = false
    }
    
    -- Update velocity based on inputs
    local function updateVelocity()
        if not hrp or not hrp.Parent then return end
        
        local direction = Vector3.new(0, 0, 0)
        
        if inputs.Forward then
            direction = direction + hrp.CFrame.LookVector
        end
        if inputs.Backward then
            direction = direction - hrp.CFrame.LookVector
        end
        if inputs.Left then
            direction = direction - hrp.CFrame.RightVector
        end
        if inputs.Right then
            direction = direction + hrp.CFrame.RightVector
        end
        if inputs.Up then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if inputs.Down then
            direction = direction + Vector3.new(0, -1, 0)
        end
        
        -- Normalize and apply speed
        if direction.Magnitude > 0 then
            direction = direction.Unit * FLY_SPEED
        end
        
        velocity.Velocity = direction
    end
    
    -- Input handling
    local function onInputBegan(input, gameProcessed)
        if gameProcessed then return end
        
        for action, key in pairs(FLY_KEYBINDS) do
            if input.KeyCode == key then
                inputs[action] = true
                updateVelocity()
                break
            end
        end
    end
    
    local function onInputEnded(input, gameProcessed)
        if gameProcessed then return end
        
        for action, key in pairs(FLY_KEYBINDS) do
            if input.KeyCode == key then
                inputs[action] = false
                updateVelocity()
                break
            end
        end
    end
    
    -- Connect input events
    local inputBegan = UserInputService.InputBegan:Connect(onInputBegan)
    local inputEnded = UserInputService.InputEnded:Connect(onInputEnded)
    
    -- Update gyro to follow camera
    local renderConnection
    renderConnection = RunService.RenderStepped:Connect(function()
        if not hrp or not hrp.Parent then
            renderConnection:Disconnect()
            return
        end
        
        local cam = workspace.CurrentCamera
        if cam then
            gyro.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
        end
    end)
    
    -- Store connections for cleanup
    table.insert(connections, inputBegan)
    table.insert(connections, inputEnded)
    table.insert(connections, renderConnection)
    
    return {
        velocity = velocity,
        gyro = gyro,
        updateSpeed = function(newSpeed)
            FLY_SPEED = newSpeed
            updateVelocity()
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
    
    repeat task.wait() until character:FindFirstChild("HumanoidRootPart")
    
    -- Create fly controller
    flyInstance = createFlyController(character)
    
    -- Handle respawn
    local charAddedConn
    charAddedConn = plr.CharacterAdded:Connect(function(newChar)
        task.wait(1) -- Wait for character to load
        
        if flyInstance then
            flyInstance.destroy()
        end
        
        repeat task.wait() until newChar:FindFirstChild("HumanoidRootPart")
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