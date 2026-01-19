-- Fly System Module for Mobile
-- Mobile-friendly fly system

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

-- Mobile joystick
function module.createJoystick(parent)
    local joystickFrame = Instance.new("Frame")
    joystickFrame.Name = "FlyJoystick"
    joystickFrame.Size = UDim2.new(0, 150, 0, 150)
    joystickFrame.Position = UDim2.new(0, 20, 1, -170)
    joystickFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    joystickFrame.BackgroundTransparency = 0.4
    joystickFrame.Visible = false
    joystickFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = joystickFrame
    
    local center = Instance.new("Frame")
    center.Name = "Center"
    center.Size = UDim2.new(0, 50, 0, 50)
    center.Position = UDim2.new(0.5, -25, 0.5, -25)
    center.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    center.Parent = joystickFrame
    
    local centerCorner = Instance.new("UICorner")
    centerCorner.CornerRadius = UDim.new(1, 0)
    centerCorner.Parent = center
    
    return joystickFrame
end

function module.init(char, rootPart, hum)
    character = char
    hrp = rootPart
    humanoid = hum
end

function module.toggle(state)
    if state == nil then
        state = not flyEnabled
    end
    
    if state then
        module.enable()
    else
        module.disable()
    end
end

function module.enable()
    if not character or not hrp then
        return false
    end
    
    if flyEnabled then return true end
    
    -- Clean old
    if velocity then velocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    
    -- Create physics
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
    
    -- Create mobile controls
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    joystick = module.createJoystick(playerGui)
    joystick.Visible = true
    
    -- Mobile control loop
    coroutine.wrap(function()
        local touchActive = false
        local touchStart = nil
        local joystickCenter = joystick.AbsolutePosition + joystick.AbsoluteSize / 2
        
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                local touchPos = Vector2.new(input.Position.X, input.Position.Y)
                local joystickRect = Rect.new(
                    joystick.AbsolutePosition.X,
                    joystick.AbsolutePosition.Y,
                    joystick.AbsolutePosition.X + joystick.AbsoluteSize.X,
                    joystick.AbsolutePosition.Y + joystick.AbsoluteSize.Y
                )
                
                if joystickRect:ContainsPoint(touchPos) then
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
            local delta = currentPos - joystickCenter
            local distance = delta.Magnitude
            local maxDist = 50
            
            if distance > maxDist then
                delta = delta.Unit * maxDist
            end
            
            -- Update joystick visual
            joystick.Center.Position = UDim2.new(
                0.5, delta.X,
                0.5, delta.Y
            )
            
            -- Convert to movement
            local direction = Vector2.new(delta.X / maxDist, delta.Y / maxDist)
            local camera = workspace.CurrentCamera
            
            local moveDir = Vector3.new(
                direction.X * 3,
                0,
                -direction.Y * 3
            )
            
            local forward = camera.CFrame.LookVector * Vector3.new(1, 0, 1)
            local right = camera.CFrame.RightVector
            
            velocity.Velocity = (right * moveDir.X + forward * moveDir.Z) * 40
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                touchActive = false
                joystick.Center.Position = UDim2.new(0.5, -25, 0.5, -25)
                velocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end)()
    
    print("Fly: Enabled for mobile")
    return true
end

function module.disable()
    flyEnabled = false
    
    if velocity then
        velocity:Destroy()
        velocity = nil
    end
    
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    if joystick then
        joystick:Destroy()
        joystick = nil
    end
    
    if humanoid then
        humanoid.PlatformStand = false
    end
    
    print("Fly: Disabled")
end

function module.isEnabled()
    return flyEnabled
end

return module