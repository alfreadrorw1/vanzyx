-- Fly System Module for Mobile
-- Mobile-friendly fly system with up/down buttons

local module = {}

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- State
local flyEnabled = false
local velocity = nil
local bodyGyro = nil
local character = nil
local hrp = nil
local humanoid = nil
local joystick = nil
local upButton = nil
local downButton = nil
local uiParent = nil
local upPressed = false
local downPressed = false
local moveDirection = Vector3.new(0, 0, 0)
local verticalSpeed = 0
local flySpeed = 40
local verticalFlySpeed = 25

-- Create UI elements for mobile
function module.createMobileUI(parent)
    uiParent = parent
    
    -- Joystick untuk gerakan horizontal
    local joystickFrame = Instance.new("Frame")
    joystickFrame.Name = "FlyJoystick"
    joystickFrame.Size = UDim2.new(0, 150, 0, 150)
    joystickFrame.Position = UDim2.new(0, 30, 1, -200)
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
    
    joystick = joystickFrame
    
    -- Up Button
    local upBtn = Instance.new("TextButton")
    upBtn.Name = "FlyUpButton"
    upBtn.Size = UDim2.new(0, 80, 0, 80)
    upBtn.Position = UDim2.new(1, -200, 1, -250)
    upBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
    upBtn.BackgroundTransparency = 0.3
    upBtn.Text = "⬆"
    upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    upBtn.TextSize = 40
    upBtn.Visible = false
    upBtn.Parent = parent
    
    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 20)
    upCorner.Parent = upBtn
    
    local upStroke = Instance.new("UIStroke")
    upStroke.Color = Color3.fromRGB(200, 255, 200)
    upStroke.Thickness = 2
    upStroke.Parent = upBtn
    
    upButton = upBtn
    
    -- Down Button
    local downBtn = Instance.new("TextButton")
    downBtn.Name = "FlyDownButton"
    downBtn.Size = UDim2.new(0, 80, 0, 80)
    downBtn.Position = UDim2.new(1, -200, 1, -150)
    downBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 120)
    downBtn.BackgroundTransparency = 0.3
    downBtn.Text = "⬇"
    downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    downBtn.TextSize = 40
    downBtn.Visible = false
    downBtn.Parent = parent
    
    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 20)
    downCorner.Parent = downBtn
    
    local downStroke = Instance.new("UIStroke")
    downStroke.Color = Color3.fromRGB(255, 200, 200)
    downStroke.Thickness = 2
    downStroke.Parent = downBtn
    
    downButton = downBtn
    
    -- Info Text
    local infoText = Instance.new("TextLabel")
    infoText.Name = "FlyInfo"
    infoText.Size = UDim2.new(0, 200, 0, 40)
    infoText.Position = UDim2.new(0.5, -100, 0, 50)
    infoText.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    infoText.BackgroundTransparency = 0.7
    infoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoText.Text = "🎮 Fly Mode: ON"
    infoText.TextSize = 18
    infoText.Visible = false
    infoText.Parent = parent
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 10)
    infoCorner.Parent = infoText
    
    return {
        Joystick = joystick,
        UpButton = upButton,
        DownButton = downButton,
        Info = infoText
    }
end

-- Button press animation
function module.animateButtonPress(button, isPressed)
    if not button then return end
    
    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if isPressed then
        local tween = TweenService:Create(button, tweenInfo, {
            BackgroundTransparency = 0.1,
            Size = UDim2.new(0, 70, 0, 70)
        })
        tween:Play()
    else
        local tween = TweenService:Create(button, tweenInfo, {
            BackgroundTransparency = 0.3,
            Size = UDim2.new(0, 80, 0, 80)
        })
        tween:Play()
    end
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
    
    -- Create mobile UI jika belum ada
    if not joystick or not upButton or not downButton then
        local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "FlyControls"
        screenGui.Parent = playerGui
        screenGui.ResetOnSpawn = false
        
        local uiElements = module.createMobileUI(screenGui)
        joystick = uiElements.Joystick
        upButton = uiElements.UpButton
        downButton = uiElements.DownButton
    end
    
    -- Tampilkan UI
    joystick.Visible = true
    upButton.Visible = true
    downButton.Visible = true
    if joystick.Parent.Parent:FindFirstChild("FlyInfo") then
        joystick.Parent.Parent.FlyInfo.Visible = true
    end
    
    -- Setup button events
    local upBtnConnection = nil
    local downBtnConnection = nil
    
    -- Button untuk naik
    upBtnConnection = upButton.MouseButton1Down:Connect(function()
        upPressed = true
        module.animateButtonPress(upButton, true)
    end)
    
    upButton.MouseButton1Up:Connect(function()
        upPressed = false
        module.animateButtonPress(upButton, false)
    end)
    
    upButton.MouseLeave:Connect(function()
        upPressed = false
        module.animateButtonPress(upButton, false)
    end)
    
    -- Button untuk turun
    downBtnConnection = downButton.MouseButton1Down:Connect(function()
        downPressed = true
        module.animateButtonPress(downButton, true)
    end)
    
    downButton.MouseButton1Up:Connect(function()
        downPressed = false
        module.animateButtonPress(downButton, false)
    end)
    
    downButton.MouseLeave:Connect(function()
        downPressed = false
        module.animateButtonPress(downButton, false)
    end)
    
    -- Mobile joystick control loop
    coroutine.wrap(function()
        local touchActive = false
        local touchStart = nil
        local joystickCenter = Vector2.new(0, 0)
        
        -- Update joystick center position setiap frame
        local connection = RunService.RenderStepped:Connect(function()
            if not flyEnabled or not joystick or not velocity then
                if connection then
                    connection:Disconnect()
                end
                return
            end
            
            -- Update joystick center
            joystickCenter = joystick.AbsolutePosition + joystick.AbsoluteSize / 2
            
            -- Handle joystick input
            local horizontalMove = Vector3.new(0, 0, 0)
            
            if touchActive then
                local delta = (touchStart - joystickCenter)
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
                
                horizontalMove = Vector3.new(
                    direction.X * flySpeed,
                    0,
                    -direction.Y * flySpeed
                )
            else
                -- Reset joystick visual jika tidak aktif
                joystick.Center.Position = UDim2.new(0.5, -25, 0.5, -25)
            end
            
            -- Handle vertical movement dari button
            local verticalMove = 0
            if upPressed then
                verticalMove = verticalFlySpeed
            elseif downPressed then
                verticalMove = -verticalFlySpeed
            end
            
            -- Combine movements
            local forward = workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)
            local right = workspace.CurrentCamera.CFrame.RightVector
            
            local finalVelocity = (right * horizontalMove.X + forward * horizontalMove.Z) * 1.5
            finalVelocity = finalVelocity + Vector3.new(0, verticalMove, 0)
            
            velocity.Velocity = finalVelocity
        end)
        
        -- Touch input handling
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch and flyEnabled then
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
            if touchActive and input.UserInputType == Enum.UserInputType.Touch and flyEnabled then
                touchStart = Vector2.new(input.Position.X, input.Position.Y)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                touchActive = false
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
    
    -- Hide UI elements
    if joystick then
        joystick.Visible = false
    end
    
    if upButton then
        upButton.Visible = false
        module.animateButtonPress(upButton, false)
    end
    
    if downButton then
        downButton.Visible = false
        module.animateButtonPress(downButton, false)
    end
    
    -- Hide info text
    if uiParent and uiParent:FindFirstChild("FlyInfo") then
        uiParent.FlyInfo.Visible = false
    end
    
    upPressed = false
    downPressed = false
    
    if humanoid then
        humanoid.PlatformStand = false
    end
    
    print("Fly: Disabled")
end

function module.isEnabled()
    return flyEnabled
end

-- Set fly speed
function module.setSpeed(newSpeed)
    flySpeed = newSpeed
end

-- Set vertical fly speed
function module.setVerticalSpeed(newSpeed)
    verticalFlySpeed = newSpeed
end

-- Update UI position (untuk landscape/portrait changes)
function module.updateUIPosition()
    if not joystick or not upButton or not downButton then return end
    
    -- Update positions based on screen size
    local screenSize = workspace.CurrentCamera.ViewportSize
    
    joystick.Position = UDim2.new(0, 30, 1, -200)
    
    upButton.Position = UDim2.new(1, -200, 1, -250)
    downButton.Position = UDim2.new(1, -200, 1, -150)
end

return module