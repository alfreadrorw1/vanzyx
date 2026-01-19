--[[
    FLY SYSTEM MODULE
    Mobile Optimized Fly Script
    Delta Executor
--]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- UI References
local PanelScroll = script.Parent.Parent.MainContainer.ContentContainer.RightPanel.PanelContent.PanelScroll

-- Fly Variables
local FlyEnabled = false
local FlySpeed = 50
local BodyVelocity
local BodyGyro

-- Clear panel
for _, child in ipairs(PanelScroll:GetChildren()) do
    if child:IsA("GuiObject") then
        child:Destroy()
    end
end

-- Create Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "FLY SYSTEM"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = PanelScroll

-- Status Indicator
local StatusFrame = Instance.new("Frame")
StatusFrame.Name = "StatusFrame"
StatusFrame.Size = UDim2.new(1, -40, 0, 60)
StatusFrame.Position = UDim2.new(0, 20, 0, 50)
StatusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 10)
StatusCorner.Parent = StatusFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(0, 100, 1, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "STATUS:"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
StatusLabel.TextSize = 16
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusFrame

local StatusValue = Instance.new("TextLabel")
StatusValue.Name = "StatusValue"
StatusValue.Size = UDim2.new(1, -120, 1, 0)
StatusValue.Position = UDim2.new(0, 110, 0, 0)
StatusValue.BackgroundTransparency = 1
StatusValue.Text = "OFF"
StatusValue.TextColor3 = Color3.fromRGB(255, 80, 80)
StatusValue.TextSize = 18
StatusValue.Font = Enum.Font.GothamBold
StatusValue.TextXAlignment = Enum.TextXAlignment.Right
StatusValue.Parent = StatusFrame

StatusFrame.Parent = PanelScroll

-- Speed Control
local SpeedContainer = Instance.new("Frame")
SpeedContainer.Name = "SpeedContainer"
SpeedContainer.Size = UDim2.new(1, -40, 0, 80)
SpeedContainer.Position = UDim2.new(0, 20, 0, 130)
SpeedContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 10)
SpeedCorner.Parent = SpeedContainer

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(1, -20, 0, 30)
SpeedLabel.Position = UDim2.new(0, 10, 0, 5)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "FLY SPEED: " .. FlySpeed
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
SpeedLabel.TextSize = 16
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SpeedContainer

local SpeedSlider = Instance.new("Frame")
SpeedSlider.Name = "SpeedSlider"
SpeedSlider.Size = UDim2.new(1, -20, 0, 30)
SpeedSlider.Position = UDim2.new(0, 10, 0, 40)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SpeedSlider.BorderSizePixel = 0

local SpeedSliderCorner = Instance.new("UICorner")
SpeedSliderCorner.CornerRadius = UDim.new(0, 5)
SpeedSliderCorner.Parent = SpeedSlider

local SpeedFill = Instance.new("Frame")
SpeedFill.Name = "SpeedFill"
SpeedFill.Size = UDim2.new((FlySpeed - 20) / 180, 0, 1, 0)
SpeedFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SpeedFill.BorderSizePixel = 0

local SpeedFillCorner = Instance.new("UICorner")
SpeedFillCorner.CornerRadius = UDim.new(0, 5)
SpeedFillCorner.Parent = SpeedFill

local SpeedButton = Instance.new("TextButton")
SpeedButton.Name = "SpeedButton"
SpeedButton.Size = UDim2.new(0, 20, 0, 20)
SpeedButton.BackgroundColor3 = Color3.white
SpeedButton.Text = ""
SpeedButton.AutoButtonColor = false

local SpeedButtonCorner = Instance.new("UICorner")
SpeedButtonCorner.CornerRadius = UDim.new(0, 10)
SpeedButtonCorner.Parent = SpeedButton

-- Slider logic
local dragging = false
SpeedButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

SpeedButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        local relativeX = math.clamp((input.Position.X - SpeedSlider.AbsolutePosition.X) / SpeedSlider.AbsoluteSize.X, 0, 1)
        FlySpeed = math.floor(20 + (relativeX * 180))
        SpeedFill.Size = UDim2.new(relativeX, 0, 1, 0)
        SpeedLabel.Text = "FLY SPEED: " .. FlySpeed
        SpeedButton.Position = UDim2.new(relativeX, -10, 0.5, -10)
        
        -- Update fly speed if active
        if FlyEnabled and BodyVelocity then
            BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000) * FlySpeed
        end
    end
end)

SpeedFill.Parent = SpeedSlider
SpeedButton.Parent = SpeedSlider
SpeedSlider.Parent = SpeedContainer
SpeedContainer.Parent = PanelScroll

-- Control Buttons Container
local ControlsContainer = Instance.new("Frame")
ControlsContainer.Name = "ControlsContainer"
ControlsContainer.Size = UDim2.new(1, -40, 0, 180)
ControlsContainer.Position = UDim2.new(0, 20, 0, 230)
ControlsContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)

local ControlsCorner = Instance.new("UICorner")
ControlsCorner.CornerRadius = UDim.new(0, 10)
ControlsCorner.Parent = ControlsContainer

local ControlsTitle = Instance.new("TextLabel")
ControlsTitle.Name = "ControlsTitle"
ControlsTitle.Size = UDim2.new(1, -20, 0, 30)
ControlsTitle.Position = UDim2.new(0, 10, 0, 5)
ControlsTitle.BackgroundTransparency = 1
ControlsTitle.Text = "CONTROLS"
ControlsTitle.TextColor3 = Color3.fromRGB(200, 200, 220)
ControlsTitle.TextSize = 18
ControlsTitle.Font = Enum.Font.GothamBold
ControlsTitle.TextXAlignment = Enum.TextXAlignment.Center
ControlsTitle.Parent = ControlsContainer

-- Toggle Fly Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(1, -40, 0, 40)
ToggleButton.Position = UDim2.new(0, 20, 0, 45)
ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
ToggleButton.Text = "FLY: OFF"
ToggleButton.TextColor3 = Color3.white
ToggleButton.TextSize = 16
ToggleButton.Font = Enum.Font.GothamBold

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

-- Up/Down Buttons
local UpButton = Instance.new("TextButton")
UpButton.Name = "UpButton"
UpButton.Size = UDim2.new(0.45, 0, 0, 40)
UpButton.Position = UDim2.new(0, 20, 0, 100)
UpButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
UpButton.Text = "UP"
UpButton.TextColor3 = Color3.white
UpButton.TextSize = 16
UpButton.Font = Enum.Font.GothamBold

local UpCorner = Instance.new("UICorner")
UpCorner.CornerRadius = UDim.new(0, 8)
UpCorner.Parent = UpButton

local DownButton = Instance.new("TextButton")
DownButton.Name = "DownButton"
DownButton.Size = UDim2.new(0.45, 0)
DownButton.Position = UDim2.new(0.55, -10, 0, 100)
DownButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
DownButton.Text = "DOWN"
DownButton.TextColor3 = Color3.white
DownButton.TextSize = 16
DownButton.Font = Enum.Font.GothamBold

local DownCorner = Instance.new("UICorner")
DownCorner.CornerRadius = UDim.new(0, 8)
DownCorner.Parent = DownButton

-- Mobile Control Info
local MobileInfo = Instance.new("TextLabel")
MobileInfo.Name = "MobileInfo"
MobileInfo.Size = UDim2.new(1, -20, 0, 40)
MobileInfo.Position = UDim2.new(0, 10, 0, 150)
MobileInfo.BackgroundTransparency = 1
MobileInfo.Text = "Use Joystick to move forward/backward/left/right"
MobileInfo.TextColor3 = Color3.fromRGB(150, 150, 170)
MobileInfo.TextSize = 12
MobileInfo.Font = Enum.Font.Gotham
MobileInfo.TextXAlignment = Enum.TextXAlignment.Center
MobileInfo.TextWrapped = true
MobileInfo.Parent = ControlsContainer

ToggleButton.Parent = ControlsContainer
UpButton.Parent = ControlsContainer
DownButton.Parent = ControlsContainer
ControlsContainer.Parent = PanelScroll

-- Fly Function
local function EnableFly()
    if not Character or not HumanoidRootPart then return end
    
    FlyEnabled = true
    StatusValue.Text = "ON"
    StatusValue.TextColor3 = Color3.fromRGB(80, 255, 80)
    ToggleButton.Text = "FLY: ON"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 220, 60)
    
    -- Create BodyVelocity
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000) * FlySpeed
    BodyVelocity.P = 10000
    BodyVelocity.Parent = HumanoidRootPart
    
    -- Create BodyGyro
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000) * 500
    BodyGyro.P = 30000
    BodyGyro.D = 200
    BodyGyro.CFrame = HumanoidRootPart.CFrame
    BodyGyro.Parent = HumanoidRootPart
    
    -- Disable gravity
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
    
    print("[Fly System] Fly Enabled | Speed: " .. FlySpeed)
end

local function DisableFly()
    FlyEnabled = false
    StatusValue.Text = "OFF"
    StatusValue.TextColor3 = Color3.fromRGB(255, 80, 80)
    ToggleButton.Text = "FLY: OFF"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    
    -- Remove BodyVelocity and BodyGyro
    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end
    
    if BodyGyro then
        BodyGyro:Destroy()
        BodyGyro = nil
    end
    
    -- Re-enable gravity
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
    
    print("[Fly System] Fly Disabled")
end

-- Toggle Fly
ToggleButton.MouseButton1Click:Connect(function()
    if FlyEnabled then
        DisableFly()
    else
        EnableFly()
    end
end)

-- Up/Down Controls
local verticalVelocity = 0
local verticalSpeed = 30

UpButton.MouseButton1Down:Connect(function()
    if FlyEnabled and BodyVelocity then
        verticalVelocity = verticalSpeed
    end
end)

UpButton.MouseButton1Up:Connect(function()
    verticalVelocity = 0
end)

DownButton.MouseButton1Down:Connect(function()
    if FlyEnabled and BodyVelocity then
        verticalVelocity = -verticalSpeed
    end
end)

DownButton.MouseButton1Up:Connect(function()
    verticalVelocity = 0
end)

-- Character Reconnection
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    if FlyEnabled then
        wait(1)
        EnableFly()
    end
end)

-- Fly Movement Update
RunService.Heartbeat:Connect(function()
    if FlyEnabled and BodyVelocity and BodyGyro and HumanoidRootPart then
        -- Get camera direction
        local Camera = workspace.CurrentCamera
        local lookVector = Camera.CFrame.LookVector
        local rightVector = Camera.CFrame.RightVector
        
        -- Movement direction
        local direction = Vector3.new(0, 0, 0)
        
        -- Check for mobile virtual joystick input
        local moveVector = Vector2.new(0, 0)
        
        -- Forward/Backward (W/S or Joystick Y)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + lookVector
        elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - lookVector
        end
        
        -- Left/Right (A/D or Joystick X)
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - rightVector
        elseif UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + rightVector
        end
        
        -- Apply vertical movement
        direction = direction + Vector3.new(0, verticalVelocity, 0)
        
        -- Normalize and apply speed
        if direction.Magnitude > 0 then
            direction = direction.Unit * FlySpeed
        end
        
        -- Update velocity
        BodyVelocity.Velocity = direction
        
        -- Update gyro to face camera direction
        BodyGyro.CFrame = Camera.CFrame
    end
end)

-- Auto-disable fly on death
Humanoid.Died:Connect(function()
    if FlyEnabled then
        DisableFly()
    end
end)

print("[Fly System] Module Loaded Successfully!")