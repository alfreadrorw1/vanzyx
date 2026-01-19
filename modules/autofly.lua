-- Advanced Auto Fly System
-- Auto-enables on load, has speed control, smooth movement

local module = {}
local flyEnabled = true
local velocity, bodyGyro
local flySpeed = 50
local keysDown = {}

-- Key bindings
local FLY_KEYS = {
    [Enum.KeyCode.W] = Vector3.new(0, 0, -1),
    [Enum.KeyCode.S] = Vector3.new(0, 0, 1),
    [Enum.KeyCode.A] = Vector3.new(-1, 0, 0),
    [Enum.KeyCode.D] = Vector3.new(1, 0, 0),
    [Enum.KeyCode.Space] = Vector3.new(0, 1, 0),
    [Enum.KeyCode.LeftShift] = Vector3.new(0, -1, 0),
    [Enum.KeyCode.E] = Vector3.new(0, 0.5, 0),
    [Enum.KeyCode.Q] = Vector3.new(0, -0.5, 0)
}

-- Module info
module.name = "autofly"
module.description = "Advanced flying system with smooth controls"

-- Initialize fly system
function module.init()
    module.Logger.log("Fly system initialized", "INFO")
end

-- Toggle fly on/off
function module.toggle(state)
    flyEnabled = state
    
    if flyEnabled then
        module.enableFly()
    else
        module.disableFly()
    end
    
    return flyEnabled
end

-- Enable fly
function module.enableFly()
    local character = module.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Cleanup old
    module.disableFly()
    
    -- Create physics objects
    velocity = Instance.new("BodyVelocity")
    velocity.Velocity = Vector3.new(0, 0, 0)
    velocity.MaxForce = Vector3.new(10000, 10000, 10000)
    velocity.P = 5000
    velocity.Name = "VanzyxxxFlyVelocity"
    velocity.Parent = hrp
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
    bodyGyro.P = 5000
    bodyGyro.D = 1000
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Name = "VanzyxxxFlyGyro"
    bodyGyro.Parent = hrp
    
    -- Disable gravity
    if module.Humanoid then
        module.Humanoid.PlatformStand = true
    end
    
    -- Key tracking
    module.UserInputService.InputBegan:Connect(function(input)
        if FLY_KEYS[input.KeyCode] then
            keysDown[input.KeyCode] = true
        end
    end)
    
    module.UserInputService.InputEnded:Connect(function(input)
        if FLY_KEYS[input.KeyCode] then
            keysDown[input.KeyCode] = nil
        end
    end)
    
    -- Flight loop
    module.RunService.Heartbeat:Connect(function()
        if not flyEnabled or not velocity or not hrp then return end
        
        local direction = Vector3.new(0, 0, 0)
        
        -- Calculate direction from keys
        for keyCode, dir in pairs(FLY_KEYS) do
            if keysDown[keyCode] then
                direction = direction + dir
            end
        end
        
        -- Apply movement
        if direction.Magnitude > 0 then
            direction = direction.Unit
            
            -- Camera relative movement
            local cam = workspace.CurrentCamera
            if cam then
                local forward = cam.CFrame.LookVector
                local right = cam.CFrame.RightVector
                local up = Vector3.new(0, 1, 0)
                
                direction = (direction.X * right) + (direction.Y * up) + (direction.Z * forward)
                direction = direction.Unit
            end
            
            velocity.Velocity = direction * flySpeed
            
            -- Smooth rotation
            if bodyGyro then
                bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + direction)
            end
        else
            velocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    module.Logger.log("Fly enabled with speed: " .. flySpeed, "SUCCESS")
end

-- Disable fly
function module.disableFly()
    if velocity then velocity:Destroy() velocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    
    if module.Humanoid then
        module.Humanoid.PlatformStand = false
    end
    
    keysDown = {}
    module.Logger.log("Fly disabled", "INFO")
end

-- Set fly speed
function module.setSpeed(speed)
    flySpeed = math.clamp(speed, 10, 200)
    module.Logger.log("Fly speed set to: " .. flySpeed, "INFO")
end

-- Character respawn handler
function module.onCharacterAdded(newChar)
    if flyEnabled then
        task.wait(1) -- Wait for character to stabilize
        module.enableFly()
    end
end

-- Get current state
function module.getState()
    return {
        enabled = flyEnabled,
        speed = flySpeed,
        keys = keysDown
    }
end

return module