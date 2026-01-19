-- Fly System Module - FIXED VERSION
-- Otomatis aktif saat script dijalankan

local module = {}

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- State variables
local flyEnabled = false
local velocity = nil
local bodyGyro = nil
local character = nil
local hrp = nil
local humanoid = nil
local connection = nil

-- Fly speed configuration
local FLY_SPEED = 50
local FLY_KEYBINDS = {
    [Enum.KeyCode.W] = Vector3.new(0, 0, -1),
    [Enum.KeyCode.S] = Vector3.new(0, 0, 1),
    [Enum.KeyCode.A] = Vector3.new(-1, 0, 0),
    [Enum.KeyCode.D] = Vector3.new(1, 0, 0),
    [Enum.KeyCode.Space] = Vector3.new(0, 1, 0),
    [Enum.KeyCode.LeftShift] = Vector3.new(0, -1, 0)
}

-- Track pressed keys
local keysDown = {}

-- Input handler
local function onInput(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if FLY_KEYBINDS[input.KeyCode] then
            if input.UserInputState == Enum.UserInputState.Begin then
                keysDown[input.KeyCode] = true
            elseif input.UserInputState == Enum.UserInputState.End then
                keysDown[input.KeyCode] = nil
            end
        end
    end
end

-- Initialize fly system
function module.init(char, rootPart, hum)
    character = char
    hrp = rootPart
    humanoid = hum
end

-- Toggle fly on/off
function module.toggle(state)
    if state == nil then
        state = not flyEnabled
    end
    
    if state then
        module.enableFly()
    else
        module.disableFly()
    end
end

-- Enable fly system
function module.enableFly()
    if not character or not hrp then
        warn("Fly: No character or HRP")
        return false
    end
    
    if flyEnabled then
        return true
    end
    
    -- Cleanup existing fly objects
    module.disableFly()
    
    -- Create BodyVelocity for movement
    velocity = Instance.new("BodyVelocity")
    velocity.Velocity = Vector3.new(0, 0, 0)
    velocity.MaxForce = Vector3.new(10000, 10000, 10000)
    velocity.P = 1000
    velocity.Name = "VanzyxxxFlyVelocity"
    velocity.Parent = hrp
    
    -- Create BodyGyro for stabilization
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
    bodyGyro.P = 1000
    bodyGyro.D = 50
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Name = "VanzyxxxFlyGyro"
    bodyGyro.Parent = hrp
    
    -- Nonaktifkan gravity effect
    if humanoid then
        humanoid.PlatformStand = true
    end
    
    -- Connect input events
    UserInputService.InputBegan:Connect(onInput)
    UserInputService.InputEnded:Connect(onInput)
    
    -- Fly control loop
    connection = RunService.Heartbeat:Connect(function(delta)
        if not flyEnabled or not hrp or not velocity then
            return
        end
        
        local direction = Vector3.new(0, 0, 0)
        
        -- Calculate direction from pressed keys
        for keyCode, dir in pairs(FLY_KEYBINDS) do
            if keysDown[keyCode] then
                direction = direction + dir
            end
        end
        
        -- Apply movement if any key is pressed
        if direction.Magnitude > 0 then
            direction = direction.Unit
            
            -- Transform direction relative to camera
            local camera = workspace.CurrentCamera
            if camera then
                local forward = camera.CFrame.LookVector
                local right = camera.CFrame.RightVector
                local up = Vector3.new(0, 1, 0)
                
                local moveX = direction.X * right
                local moveY = direction.Y * up
                local moveZ = direction.Z * forward
                
                direction = (moveX + moveY + moveZ).Unit
            end
            
            -- Apply velocity
            velocity.Velocity = direction * FLY_SPEED
            
            -- Update gyro to look forward
            if bodyGyro then
                bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + camera.CFrame.LookVector)
            end
        else
            -- No input, stop moving but maintain position
            velocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    flyEnabled = true
    print("Fly system: ENABLED")
    return true
end

-- Disable fly system
function module.disableFly()
    -- Remove connection
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    -- Clear keys
    keysDown = {}
    
    -- Remove velocity
    if velocity and velocity.Parent then
        velocity:Destroy()
        velocity = nil
    end
    
    -- Remove gyro
    if bodyGyro and bodyGyro.Parent then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    -- Re-enable physics
    if humanoid then
        humanoid.PlatformStand = false
    end
    
    flyEnabled = false
    print("Fly system: DISABLED")
    return true
end

-- Set character reference (for respawn)
function module.setCharacter(char)
    character = char
    
    if char then
        hrp = char:WaitForChild("HumanoidRootPart", 5)
        humanoid = char:FindFirstChildOfClass("Humanoid")
        
        -- Re-enable fly if it was active
        if flyEnabled then
            task.wait(1) -- Wait for character to stabilize
            module.enableFly()
        end
    end
end

-- Set fly speed
function module.setSpeed(newSpeed)
    FLY_SPEED = math.clamp(newSpeed, 10, 200)
end

-- Get fly state
function module.isEnabled()
    return flyEnabled
end

return module