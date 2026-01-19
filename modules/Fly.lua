-- ====================================================
-- FLY MODULE - Mobile Optimized
-- Compatible with Delta Executor
-- ====================================================

local FlyModule = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Variables
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local FlyEnabled = false
local FlySpeed = 50
local FlyConnection = nil

-- Fly velocities
local BodyVelocity = nil
local BodyGyro = nil

-- Mobile controls
local MobileControls = {}
local ControlButtons = {}

-- Function to toggle fly
function FlyModule.ToggleFly()
    FlyEnabled = not FlyEnabled
    
    if FlyEnabled then
        FlyModule.EnableFly()
    else
        FlyModule.DisableFly()
    end
    
    return FlyEnabled
end

-- Function to enable fly
function FlyModule.EnableFly()
    if not Character or not HumanoidRootPart then
        Character = Player.Character
        if Character then
            HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            Humanoid = Character:WaitForChild("Humanoid")
        else
            return
        end
    end
    
    -- Create BodyVelocity for movement
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    BodyVelocity.P = 10000
    BodyVelocity.Name = "FlyVelocity"
    BodyVelocity.Parent = HumanoidRootPart
    
    -- Create BodyGyro for stability
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    BodyGyro.P = 10000
    BodyGyro.D = 500
    BodyGyro.CFrame = HumanoidRootPart.CFrame
    BodyGyro.Name = "FlyGyro"
    BodyGyro.Parent = HumanoidRootPart
    
    -- Disable gravity while flying
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    
    -- Start fly loop
    FlyConnection = RunService.Heartbeat:Connect(FlyModule.FlyLoop)
    
    -- Create mobile controls if on touch device
    if UserInputService.TouchEnabled then
        FlyModule.CreateMobileControls()
    end
end

-- Function to disable fly
function FlyModule.DisableFly()
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    
    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end
    
    if BodyGyro then
        BodyGyro:Destroy()
        BodyGyro = nil
    end
    
    -- Re-enable gravity
    if Humanoid then
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
    end
    
    -- Remove mobile controls
    FlyModule.RemoveMobileControls()
end

-- Main fly loop
function FlyModule.FlyLoop()
    if not Character or not HumanoidRootPart or not BodyVelocity or not BodyGyro then
        return
    end
    
    -- Update gyro to match camera
    local Camera = workspace.CurrentCamera
    if Camera then
        BodyGyro.CFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + Camera.CFrame.LookVector)
    end
    
    -- Calculate movement direction
    local Direction = Vector3.new(0, 0, 0)
    
    -- Keyboard controls
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        Direction = Direction + Vector3.new(0, 0, -1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        Direction = Direction + Vector3.new(0, 0, 1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        Direction = Direction + Vector3.new(-1, 0, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        Direction = Direction + Vector3.new(1, 0, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        Direction = Direction + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        Direction = Direction + Vector3.new(0, -1, 0)
    end
    
    -- Normalize direction and apply speed
    if Direction.Magnitude > 0 then
        Direction = Direction.Unit * FlySpeed
    end
    
    -- Apply velocity
    BodyVelocity.Velocity = Direction
end

-- Function to set fly speed
function FlyModule.SetSpeed(speed)
    FlySpeed = math.clamp(speed, 1, 200)
    return FlySpeed
end

-- Function to create mobile controls
function FlyModule.CreateMobileControls()
    if not Player.PlayerGui then return end
    
    -- Create screen GUI for controls
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FlyControls"
    ScreenGui.Parent = Player.PlayerGui
    
    -- Create joystick for movement
    local JoystickFrame = Instance.new("Frame")
    JoystickFrame.Name = "Joystick"
    JoystickFrame.Size = UDim2.new(0, 150, 0, 150)
    JoystickFrame.Position = UDim2.new(0, 50, 1, -200)
    JoystickFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    JoystickFrame.BackgroundTransparency = 0.3
    JoystickFrame.BorderSizePixel = 0
    
    local JoystickCorner = Instance.new("UICorner")
    JoystickCorner.CornerRadius = UDim.new(0.5, 0)
    JoystickCorner.Parent = JoystickFrame
    
    -- Joystick knob
    local JoystickKnob = Instance.new("Frame")
    JoystickKnob.Name = "Knob"
    JoystickKnob.Size = UDim2.new(0, 50, 0, 50)
    JoystickKnob.Position = UDim2.new(0.5, -25, 0.5, -25)
    JoystickKnob.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    JoystickKnob.BackgroundTransparency = 0.2
    JoystickKnob.BorderSizePixel = 0
    
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(0.5, 0)
    KnobCorner.Parent = JoystickKnob
    
    JoystickKnob.Parent = JoystickFrame
    
    -- Up button
    local UpButton = Instance.new("TextButton")
    UpButton.Name = "Up"
    UpButton.Size = UDim2.new(0, 60, 0, 60)
    UpButton.Position = UDim2.new(1, -70, 0, 50)
    UpButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    UpButton.BackgroundTransparency = 0.3
    UpButton.Text = "↑"
    UpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    UpButton.TextSize = 24
    UpButton.Font = Enum.Font.GothamBold
    
    local UpCorner = Instance.new("UICorner")
    UpCorner.CornerRadius = UDim.new(0.5, 0)
    UpCorner.Parent = UpButton
    
    -- Down button
    local DownButton = Instance.new("TextButton")
    DownButton.Name = "Down"
    DownButton.Size = UDim2.new(0, 60, 0, 60)
    DownButton.Position = UDim2.new(1, -70, 0, 120)
    DownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    DownButton.BackgroundTransparency = 0.3
    DownButton.Text = "↓"
    DownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DownButton.TextSize = 24
    DownButton.Font = Enum.Font.GothamBold
    
    local DownCorner = Instance.new("UICorner")
    DownCorner.CornerRadius = UDim.new(0.5, 0)
    DownCorner.Parent = DownButton
    
    -- Store controls
    MobileControls = {
        ScreenGui = ScreenGui,
        Joystick = JoystickFrame,
        UpButton = UpButton,
        DownButton = DownButton
    }
    
    ControlButtons = {
        Up = false,
        Down = false,
        Forward = false,
        Backward = false,
        Left = false,
        Right = false
    }
    
    -- Add controls to screen
    JoystickFrame.Parent = ScreenGui
    UpButton.Parent = ScreenGui
    DownButton.Parent = ScreenGui
    
    -- Setup joystick functionality
    local function UpdateJoystick(input)
        local absolutePosition = input.Position
        local relativePosition = absolutePosition - JoystickFrame.AbsolutePosition
        local center = Vector2.new(75, 75) -- Half of joystick size
        
        local delta = relativePosition - center
        local magnitude = delta.Magnitude
        local maxMagnitude = 50 -- Max distance from center
        
        if magnitude > maxMagnitude then
            delta = delta.Unit * maxMagnitude
        end
        
        -- Update knob position
        JoystickKnob.Position = UDim2.new(0, center.x + delta.x - 25, 0, center.y + delta.y - 25)
        
        -- Update movement direction
        local xRatio = delta.x / maxMagnitude
        local yRatio = delta.y / maxMagnitude
        
        ControlButtons.Forward = yRatio < -0.2
        ControlButtons.Backward = yRatio > 0.2
        ControlButtons.Left = xRatio < -0.2
        ControlButtons.Right = xRatio > 0.2
    end
    
    -- Joystick input handling
    JoystickFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            UpdateJoystick(input)
        end
    end)
    
    JoystickFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            UpdateJoystick(input)
        end
    end)
    
    JoystickFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            -- Reset joystick
            JoystickKnob.Position = UDim2.new(0.5, -25, 0.5, -25)
            
            -- Reset controls
            for key in pairs(ControlButtons) do
                ControlButtons[key] = false
            end
        end
    end)
    
    -- Button controls
    UpButton.MouseButton1Down:Connect(function()
        ControlButtons.Up = true
    end)
    
    UpButton.MouseButton1Up:Connect(function()
        ControlButtons.Up = false
    end)
    
    DownButton.MouseButton1Down:Connect(function()
        ControlButtons.Down = true
    end)
    
    DownButton.MouseButton1Up:Connect(function()
        ControlButtons.Down = false
    end)
    
    -- Update fly loop for mobile controls
    if FlyConnection then
        FlyConnection:Disconnect()
    end
    
    FlyConnection = RunService.Heartbeat:Connect(function()
        if not BodyVelocity then return end
        
        local Direction = Vector3.new(0, 0, 0)
        
        -- Apply mobile controls
        if ControlButtons.Forward then
            Direction = Direction + Vector3.new(0, 0, -1)
        end
        if ControlButtons.Backward then
            Direction = Direction + Vector3.new(0, 0, 1)
        end
        if ControlButtons.Left then
            Direction = Direction + Vector3.new(-1, 0, 0)
        end
        if ControlButtons.Right then
            Direction = Direction + Vector3.new(1, 0, 0)
        end
        if ControlButtons.Up then
            Direction = Direction + Vector3.new(0, 1, 0)
        end
        if ControlButtons.Down then
            Direction = Direction + Vector3.new(0, -1, 0)
        end
        
        -- Normalize and apply speed
        if Direction.Magnitude > 0 then
            Direction = Direction.Unit * FlySpeed
        end
        
        -- Apply velocity
        BodyVelocity.Velocity = Direction
    end)
end

-- Function to remove mobile controls
function FlyModule.RemoveMobileControls()
    if MobileControls.ScreenGui then
        MobileControls.ScreenGui:Destroy()
        MobileControls = {}
        ControlButtons = {}
    end
end

-- Function to create UI elements
function FlyModule.CreateUI(container)
    -- Clear existing UI
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    
    -- Create toggle fly button
    local FlyButton = Instance.new("TextButton")
    FlyButton.Name = "ToggleFly"
    FlyButton.Size = UDim2.new(1, 0, 0, 45)
    FlyButton.BackgroundColor3 = FlyEnabled and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 0, 0)
    FlyButton.Text = FlyEnabled and "✈️ FLY: ON" or "✈️ FLY: OFF"
    FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FlyButton.TextSize = 16
    FlyButton.Font = Enum.Font.GothamBold
    
    local FlyCorner = Instance.new("UICorner")
    FlyCorner.CornerRadius = UDim.new(0, 8)
    FlyCorner.Parent = FlyButton
    
    -- Speed slider
    local SpeedFrame = Instance.new("Frame")
    SpeedFrame.Name = "SpeedFrame"
    SpeedFrame.Size = UDim2.new(1, 0, 0, 60)
    SpeedFrame.BackgroundTransparency = 1
    
    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Name = "SpeedLabel"
    SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.Text = "Fly Speed: " .. FlySpeed
    SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedLabel.TextSize = 14
    SpeedLabel.Font = Enum.Font.Gotham
    
    local SpeedSlider = Instance.new("TextBox")
    SpeedSlider.Name = "SpeedSlider"
    SpeedSlider.Size = UDim2.new(1, 0, 0, 30)
    SpeedSlider.Position = UDim2.new(0, 0, 0, 25)
    SpeedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    SpeedSlider.Text = tostring(FlySpeed)
    SpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedSlider.TextSize = 14
    SpeedSlider.Font = Enum.Font.Gotham
    SpeedSlider.PlaceholderText = "Enter speed (1-200)"
    
    local SpeedSliderCorner = Instance.new("UICorner")
    SpeedSliderCorner.CornerRadius = UDim.new(0, 6)
    SpeedSliderCorner.Parent = SpeedSlider
    
    -- Controls info
    local ControlsInfo = Instance.new("TextLabel")
    ControlsInfo.Name = "ControlsInfo"
    ControlsInfo.Size = UDim2.new(1, 0, 0, 80)
    ControlsInfo.BackgroundTransparency = 1
    ControlsInfo.Text = "📱 Mobile Controls:\n• Joystick: Movement\n• ↑ Button: Fly Up\n• ↓ Button: Fly Down\n• WASD + Space/Ctrl on Keyboard"
    ControlsInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
    ControlsInfo.TextSize = 12
    ControlsInfo.Font = Enum.Font.Gotham
    ControlsInfo.TextWrapped = true
    
    -- Button functionality
    FlyButton.MouseButton1Click:Connect(function()
        local newState = FlyModule.ToggleFly()
        FlyButton.BackgroundColor3 = newState and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 0, 0)
        FlyButton.Text = newState and "✈️ FLY: ON" or "✈️ FLY: OFF"
    end)
    
    -- Speed slider functionality
    SpeedSlider.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local speed = tonumber(SpeedSlider.Text)
            if speed then
                FlySpeed = FlyModule.SetSpeed(speed)
                SpeedLabel.Text = "Fly Speed: " .. FlySpeed
                SpeedSlider.Text = tostring(FlySpeed)
            else
                SpeedSlider.Text = tostring(FlySpeed)
            end
        end
    end)
    
    -- Add to container
    FlyButton.Parent = container
    SpeedFrame.Parent = container
    SpeedLabel.Parent = SpeedFrame
    SpeedSlider.Parent = SpeedFrame
    ControlsInfo.Parent = container
end

-- Cleanup function
function FlyModule.Cleanup()
    FlyModule.DisableFly()
end

return FlyModule