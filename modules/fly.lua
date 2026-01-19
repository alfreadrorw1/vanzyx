-- Fly Module

local module = {}

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Player
local player = Players.LocalPlayer
local character = player.Character
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChild("Humanoid")

-- Module state
local active = false
local flying = false
local bodyVelocity
local flySpeed = 50

-- Input states
local inputs = {
    forward = false,
    backward = false,
    left = false,
    right = false,
    up = false,
    down = false
}

-- Key bindings
local keyBindings = {
    [Enum.KeyCode.W] = "forward",
    [Enum.KeyCode.S] = "backward",
    [Enum.KeyCode.A] = "left",
    [Enum.KeyCode.D] = "right",
    [Enum.KeyCode.Space] = "up",
    [Enum.KeyCode.LeftShift] = "down",
    [Enum.KeyCode.E] = "down"
}

-- Create BodyVelocity for flying
local function createBodyVelocity()
    if not humanoidRootPart then return nil end
    
    -- Remove existing BodyVelocity
    if bodyVelocity then
        bodyVelocity:Destroy()
    end
    
    -- Create new BodyVelocity
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    bodyVelocity.P = 10000
    bodyVelocity.Parent = humanoidRootPart
    
    return bodyVelocity
end

-- Handle input
local function onInputBegan(input, gameProcessed)
    if gameProcessed or not active or not flying then return end
    
    local key = keyBindings[input.KeyCode]
    if key then
        inputs[key] = true
    end
end

local function onInputEnded(input, gameProcessed)
    if gameProcessed or not active then return end
    
    local key = keyBindings[input.KeyCode]
    if key then
        inputs[key] = false
    end
end

-- Calculate fly direction
local function calculateFlyDirection()
    local direction = Vector3.new(0, 0, 0)
    
    if inputs.forward then
        direction = direction + Workspace.CurrentCamera.CFrame.LookVector
    end
    if inputs.backward then
        direction = direction - Workspace.CurrentCamera.CFrame.LookVector
    end
    if inputs.left then
        direction = direction - Workspace.CurrentCamera.CFrame.RightVector
    end
    if inputs.right then
        direction = direction + Workspace.CurrentCamera.CFrame.RightVector
    end
    if inputs.up then
        direction = direction + Vector3.new(0, 1, 0)
    end
    if inputs.down then
        direction = direction + Vector3.new(0, -1, 0)
    end
    
    -- Normalize direction if moving
    if direction.Magnitude > 0 then
        direction = direction.Unit
    end
    
    return direction * flySpeed
end

-- Fly loop
local function flyLoop()
    if not active or not flying or not humanoidRootPart then return end
    
    -- Create BodyVelocity if needed
    if not bodyVelocity or not bodyVelocity.Parent then
        bodyVelocity = createBodyVelocity()
        if not bodyVelocity then return end
    end
    
    -- Disable humanoid states
    if humanoid then
        humanoid.PlatformStand = true
    end
    
    -- Fly loop
    while active and flying and humanoidRootPart do
        local velocity = calculateFlyDirection()
        bodyVelocity.Velocity = velocity
        
        RunService.Heartbeat:Wait()
    end
    
    -- Cleanup
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    if humanoid then
        humanoid.PlatformStand = false
    end
end

-- Character added handler
local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    humanoid = character:FindFirstChild("Humanoid")
    
    if active and flying then
        -- Restart flying with new character
        task.wait(0.5)
        if active and flying then
            spawn(flyLoop)
        end
    end
end

-- Module functions
function module.activate()
    if active then return end
    
    active = true
    flying = true
    print("Fly activated")
    
    -- Set up input listeners
    UserInputService.InputBegan:Connect(onInputBegan)
    UserInputService.InputEnded:Connect(onInputEnded)
    
    -- Set up character monitoring
    player.CharacterAdded:Connect(onCharacterAdded)
    
    -- Start flying
    spawn(flyLoop)
end

function module.deactivate()
    if not active then return end
    
    active = false
    flying = false
    
    -- Cleanup
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    if humanoid then
        humanoid.PlatformStand = false
    end
    
    -- Reset inputs
    for key in pairs(inputs) do
        inputs[key] = false
    end
    
    print("Fly deactivated")
end

-- Set fly speed (optional)
function module.setSpeed(speed)
    flySpeed = math.clamp(speed, 10, 200)
end

-- Return module
return module