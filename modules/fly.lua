-- Fly Module with multiple modes
-- Automatically activates on script start

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local module = {}

-- Configuration
local FLY_SPEED = 50
local FLY_KEY = Enum.KeyCode.E
local isFlying = false
local flyMode = "v2" -- v1, v2, v3
local bodyVelocity

-- Create UI elements for fly control
local function CreateFlyUI(parentFrame)
    local FlyFrame = Instance.new("Frame")
    FlyFrame.Name = "FlyControls"
    FlyFrame.Size = UDim2.new(1, -10, 0, 100)
    FlyFrame.Position = UDim2.new(0, 5, 0, 30)
    FlyFrame.BackgroundTransparency = 1
    
    -- Title
    local FlyTitle = Instance.new("TextLabel")
    FlyTitle.Name = "Title"
    FlyTitle.Size = UDim2.new(1, 0, 0, 20)
    FlyTitle.BackgroundTransparency = 1
    FlyTitle.Text = "FLY CONTROLS"
    FlyTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
    FlyTitle.TextSize = 14
    FlyTitle.Font = Enum.Font.GothamBold
    FlyTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Status
    local FlyStatus = Instance.new("TextLabel")
    FlyStatus.Name = "Status"
    FlyStatus.Size = UDim2.new(1, 0, 0, 20)
    FlyStatus.Position = UDim2.new(0, 0, 0, 20)
    FlyStatus.BackgroundTransparency = 1
    FlyStatus.Text = "Status: OFF"
    FlyStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    FlyStatus.TextSize = 12
    FlyStatus.Font = Enum.Font.Gotham
    FlyStatus.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Mode selector
    local ModeFrame = Instance.new("Frame")
    ModeFrame.Name = "ModeSelector"
    ModeFrame.Size = UDim2.new(1, 0, 0, 40)
    ModeFrame.Position = UDim2.new(0, 0, 0, 45)
    ModeFrame.BackgroundTransparency = 1
    
    local function CreateModeButton(name, positionX, mode)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(0.3, 0, 1, 0)
        button.Position = UDim2.new(positionX, 0, 0, 0)
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        button.Text = name
        button.TextColor3 = Color3.fromRGB(200, 200, 200)
        button.TextSize = 12
        button.Font = Enum.Font.Gotham
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = button
        
        button.MouseButton1Click:Connect(function()
            flyMode = mode
            UpdateModeButtons()
        end)
        
        return button
    end
    
    local v1Button = CreateModeButton("v1", 0, "v1")
    local v2Button = CreateModeButton("v2", 0.33, "v2")
    v2Button.BackgroundColor3 = Color3.fromRGB(80, 80, 120) -- Default selected
    local v3Button = CreateModeButton("v3", 0.66, "v3")
    
    local function UpdateModeButtons()
        v1Button.BackgroundColor3 = flyMode == "v1" and Color3.fromRGB(80, 80, 120) or Color3.fromRGB(60, 60, 80)
        v2Button.BackgroundColor3 = flyMode == "v2" and Color3.fromRGB(80, 80, 120) or Color3.fromRGB(60, 60, 80)
        v3Button.BackgroundColor3 = flyMode == "v3" and Color3.fromRGB(80, 80, 120) or Color3.fromRGB(60, 60, 80)
    end
    
    v1Button.Parent = ModeFrame
    v2Button.Parent = ModeFrame
    v3Button.Parent = ModeFrame
    
    FlyTitle.Parent = FlyFrame
    FlyStatus.Parent = FlyFrame
    ModeFrame.Parent = FlyFrame
    
    -- Toggle button
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "Toggle"
    ToggleButton.Size = UDim2.new(1, 0, 0, 25)
    ToggleButton.Position = UDim2.new(0, 0, 0, 90)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
    ToggleButton.Text = "TOGGLE FLY"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 14
    ToggleButton.Font = Enum.Font.GothamBold
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = ToggleButton
    
    ToggleButton.MouseButton1Click:Connect(function()
        module.Toggle()
        FlyStatus.Text = "Status: " .. (isFlying and "ON" or "OFF")
        FlyStatus.TextColor3 = isFlying and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        ToggleButton.BackgroundColor3 = isFlying and Color3.fromRGB(100, 60, 60) or Color3.fromRGB(60, 100, 60)
        ToggleButton.Text = isFlying and "DISABLE FLY" or "ENABLE FLY"
    end)
    
    ToggleButton.Parent = FlyFrame
    FlyFrame.Parent = parentFrame
    
    return {
        Status = FlyStatus,
        ToggleButton = ToggleButton
    }
end

-- Different fly implementations
local function FlyV1() -- BodyVelocity method
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Create BodyVelocity
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    bodyVelocity.P = 10000
    bodyVelocity.Parent = rootPart
    
    humanoid.PlatformStand = true
    
    local camera = workspace.CurrentCamera
    local flying = true
    
    local function UpdateFly()
        while flying and bodyVelocity and bodyVelocity.Parent do
            local direction = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                direction = direction - Vector3.new(0, 1, 0)
            end
            
            if direction.Magnitude > 0 then
                direction = direction.Unit * FLY_SPEED
            end
            
            bodyVelocity.Velocity = direction
            
            RunService.RenderStepped:Wait()
        end
    end
    
    task.spawn(UpdateFly)
    
    return function()
        flying = false
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        humanoid.PlatformStand = false
    end
end

local function FlyV2() -- CFrame method
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    humanoid.PlatformStand = true
    
    local camera = workspace.CurrentCamera
    local flying = true
    
    local function UpdateFly()
        while flying do
            local direction = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                direction = direction - Vector3.new(0, 1, 0)
            end
            
            if direction.Magnitude > 0 then
                direction = direction.Unit * FLY_SPEED
                rootPart.CFrame = rootPart.CFrame + direction * 0.1
            end
            
            RunService.RenderStepped:Wait()
        end
    end
    
    task.spawn(UpdateFly)
    
    return function()
        flying = false
        humanoid.PlatformStand = false
    end
end

local function FlyV3() -- LinearVelocity method (newer)
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Create LinearVelocity constraint
    local linearVelocity = Instance.new("LinearVelocity")
    linearVelocity.VectorVelocity = Vector3.new(0, 0, 0)
    linearVelocity.MaxForce = 10000
    linearVelocity.Attachment0 = Instance.new("Attachment")
    linearVelocity.Attachment0.Parent = rootPart
    linearVelocity.Parent = rootPart
    
    humanoid.PlatformStand = true
    
    local camera = workspace.CurrentCamera
    local flying = true
    
    local function UpdateFly()
        while flying and linearVelocity and linearVelocity.Parent do
            local direction = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                direction = direction - Vector3.new(0, 1, 0)
            end
            
            if direction.Magnitude > 0 then
                direction = direction.Unit * FLY_SPEED
                linearVelocity.VectorVelocity = direction
            else
                linearVelocity.VectorVelocity = Vector3.new(0, 0, 0)
            end
            
            RunService.RenderStepped:Wait()
        end
    end
    
    task.spawn(UpdateFly)
    
    return function()
        flying = false
        if linearVelocity then
            linearVelocity:Destroy()
        end
        if linearVelocity.Attachment0 then
            linearVelocity.Attachment0:Destroy()
        end
        humanoid.PlatformStand = false
    end
end

-- Main fly functions
function module.Enable()
    if isFlying then return end
    
    isFlying = true
    _G.FlyEnabled = true
    
    local disableFunction
    
    if flyMode == "v1" then
        disableFunction = FlyV1()
    elseif flyMode == "v2" then
        disableFunction = FlyV2()
    else -- v3
        disableFunction = FlyV3()
    end
    
    _G.DisableFly = function()
        if disableFunction then
            disableFunction()
        end
        isFlying = false
        _G.FlyEnabled = false
    end
    
    print("[Fly] Enabled with mode:", flyMode)
end

function module.Disable()
    if not isFlying then return end
    
    if _G.DisableFly then
        _G.DisableFly()
    end
    
    isFlying = false
    _G.FlyEnabled = false
    print("[Fly] Disabled")
end

function module.Toggle()
    if isFlying then
        module.Disable()
    else
        module.Enable()
    end
end

function module.SetMode(mode)
    if mode == "v1" or mode == "v2" or mode == "v3" then
        flyMode = mode
        print("[Fly] Mode set to:", mode)
        
        -- If currently flying, restart with new mode
        if isFlying then
            module.Disable()
            task.wait(0.1)
            module.Enable()
        end
    end
end

function module.GetStatus()
    return isFlying and "ON" or "OFF"
end

function module.GetMode()
    return flyMode
end

-- Auto-start fly when AutoCP is done (optional)
_G.AutoDisableFlyOnComplete = true

-- Create UI when module loads
task.spawn(function()
    task.wait(1) -- Wait for main UI to load
    if _G.VanzyxUI then
        local uiElements = CreateFlyUI(_G.VanzyxUI.ModulesFrame)
        _G.FlyUI = uiElements
    end
end)

return module