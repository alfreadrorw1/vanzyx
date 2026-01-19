-- Fly System Module
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

-- Initialize fly system
function module.init(char, rootPart, hum)
    character = char
    hrp = rootPart
    humanoid = hum
end

-- Toggle fly on/off
function module.toggle(state)
    flyEnabled = state
    
    if flyEnabled then
        module.enableFly()
    else
        module.disableFly()
    end
end

-- Enable fly system
function module.enableFly()
    if not character or not hrp then
        return
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
    
    -- Fly control loop
    coroutine.wrap(function()
        local camera = workspace.CurrentCamera
        local keysDown = {}
        
        -- Track key states
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
        
        UserInputService.InputBegan:Connect(onInput)
        UserInputService.InputEnded:Connect(onInput)
        
        while flyEnabled and hrp and velocity do
            local direction = Vector3.new(0, 0, 0)
            
            -- Calculate direction from pressed keys
            for keyCode, dir in pairs(FLY_KEYBINDS) do
                if keysDown[keyCode] then
                    direction = direction + dir
                end
            end
            
            -- Apply camera relative movement
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
                    bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + direction)
                end
            else
                -- No input, stop moving
                velocity.Velocity = Vector3.new(0, 0, 0)
                
                -- Maintain current rotation
                if bodyGyro then
                    bodyGyro.CFrame = hrp.CFrame
                end
            end
            
            task.wait()
        end
    end)()
    
    print("Fly system: ENABLED")
end

-- Disable fly system
function module.disableFly()
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
    
    print("Fly system: DISABLED")
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

-- Auto-disable on character death
local function onCharacterDied()
    if flyEnabled then
        module.disableFly()
        task.wait(1)
        if character and character.Parent then
            module.enableFly()
        end
    end
end

-- Connect death event
if humanoid then
    humanoid.Died:Connect(onCharacterDied)
end

return module