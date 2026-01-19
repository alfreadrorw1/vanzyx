-- Fly System Module for Mobile
-- Mobile-friendly fly with joystick controls

local module = {}

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- State
local flyEnabled = false
local velocity = nil
local bodyGyro = nil
local character = nil
local hrp = nil
local humanoid = nil
local joystick = nil
local flySpeed = 50

-- Initialize
function module.init(char, rootPart, hum)
    character = char
    hrp = rootPart
    humanoid = hum
end

-- Toggle fly
function module.toggle(state)
    if state == nil then
        state = not flyEnabled
    end
    
    if state then
        module.enable()
    else
        module.disable()
    end
    
    return flyEnabled
end

-- Enable fly
function module.enable()
    if not character or not hrp then
        print("[Fly] No character found")
        return false
    end
    
    if flyEnabled then return true end
    
    -- Clean old physics objects
    if velocity then velocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    
    -- Create physics for fly
    velocity = Instance.new("BodyVelocity")
    velocity.Velocity = Vector3.new(0, 0, 0)
    velocity.MaxForce = Vector3.new(10000, 10000, 10000)
    velocity.P = 1000
    velocity.Parent = hrp
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.P = 1000
    bodyGyro.Parent = hrp
    
    -- Disable gravity
    if humanoid then
        humanoid.PlatformStand = true
    end
    
    flyEnabled = true
    
    -- Create mobile joystick
    createJoystick()
    
    -- Start control loop
    startControlLoop()
    
    print("[Fly] Enabled with mobile controls")
    return true
end

-- Disable fly
function module.disable()
    if not flyEnabled then return end
    
    flyEnabled = false
    
    -- Remove physics
    if velocity then
        velocity:Destroy()
        velocity = nil
    end
    
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    -- Remove joystick
    if joystick then
        joystick:Destroy()
        joystick = nil
    end
    
    -- Restore gravity
    if humanoid then
        humanoid.PlatformStand = false
    end
    
    print("[Fly] Disabled")
end

-- Set fly speed
function module.setSpeed(speed)
    flySpeed = math.clamp(speed, 10, 200)
    print("[Fly] Speed set to:", flySpeed)
end

-- Get current state
function module.isEnabled()
    return flyEnabled
end

-- Create mobile joystick
function createJoystick()
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    joystick = Instance.new("Frame")
    joystick.Name = "FlyJoystick"
    joystick.Size = UDim2.new(0, 120, 0, 120)
    joystick.Position = UDim2.new(0, 20, 1, -140)
    joystick.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    joystick.BackgroundTransparency = 0.3
    joystick.Visible = true
    joystick.Parent = playerGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = joystick
    
    local center = Instance.new("Frame")
    center.Name = "Center"
    center.Size = UDim2.new(0, 40, 0, 40)
    center.Position = UDim2.new(0.5, -20, 0.5, -20)
    center.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    center.BackgroundTransparency = 0.2
    center.Parent = joystick
    
    local centerCorner = Instance.new("UICorner")
    centerCorner.CornerRadius = UDim.new(1, 0)
    centerCorner.Parent = center
end

-- Control loop for mobile
function startControlLoop()
    if not flyEnabled then return end
    
    coroutine.wrap(function()
        local touchActive = false
        local touchStart = nil
        local joystickPos = joystick.AbsolutePosition + joystick.AbsoluteSize / 2
        
        -- Touch input handling
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                local touchPos = Vector2.new(input.Position.X, input.Position.Y)
                
                -- Check if touch is on joystick
                local joystickBounds = Rect.new(
                    joystick.AbsolutePosition.X - 50,
                    joystick.AbsolutePosition.Y - 50,
                    joystick.AbsolutePosition.X + joystick.AbsoluteSize.X + 50,
                    joystick.AbsolutePosition.Y + joystick.AbsoluteSize.Y + 50
                )
                
                if joystickBounds:ContainsPoint(touchPos) then
                    touchActive = true
                    touchStart = touchPos
                end
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if not touchActive or input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            
            local currentPos = Vector2.new(input.Position.X, input.Position.Y)
            local delta = currentPos - joystickPos
            local distance = delta.Magnitude
            local maxDistance = 40
            
            -- Limit joystick movement
            if distance > maxDistance then
                delta = delta.Unit * maxDistance
            end
            
            -- Update joystick visual
            joystick.Center.Position = UDim2.new(
                0.5, delta.X,
                0.5, delta.Y
            )
            
            -- Convert to movement direction
            local direction = Vector2.new(delta.X / maxDistance, delta.Y / maxDistance)
            
            -- Get camera orientation
            local camera = workspace.CurrentCamera
            local forward = camera.CFrame.LookVector * Vector3.new(1, 0, 1)
            local right = camera.CFrame.RightVector
            
            -- Calculate movement vector
            local moveVector = (right * direction.X + forward * -direction.Y) * flySpeed
            
            -- Apply velocity
            if velocity then
                velocity.Velocity = Vector3.new(moveVector.X, velocity.Velocity.Y, moveVector.Z)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                touchActive = false
                
                -- Reset joystick
                if joystick and joystick.Center then
                    joystick.Center.Position = UDim2.new(0.5, -20, 0.5, -20)
                end
                
                -- Stop horizontal movement
                if velocity then
                    velocity.Velocity = Vector3.new(0, velocity.Velocity.Y, 0)
                end
            end
        end)
        
        -- Keyboard controls for testing
        local upPressed = false
        local downPressed = false
        
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Space then
                upPressed = true
            elseif input.KeyCode == Enum.KeyCode.LeftShift then
                downPressed = true
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Space then
                upPressed = false
            elseif input.KeyCode == Enum.KeyCode.LeftShift then
                downPressed = false
            end
        end)
        
        -- Vertical movement loop
        while flyEnabled and RunService.Heartbeat:Wait() do
            if not velocity then break end
            
            local verticalSpeed = 0
            
            if upPressed then
                verticalSpeed = flySpeed
            elseif downPressed then
                verticalSpeed = -flySpeed
            end
            
            velocity.Velocity = Vector3.new(
                velocity.Velocity.X,
                verticalSpeed,
                velocity.Velocity.Z
            )
        end
    end)()
end

return module