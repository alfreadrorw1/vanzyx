-- Vanzyxxx Main Core
-- Auto Script Executor for Roblox Games

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Prevent duplicate execution
if _G.VANZYX_LOADED then return end
_G.VANZYX_LOADED = true

-- Main variables
local CoreGui = game:GetService("CoreGui")
local VanzyxFolder = Instance.new("Folder")
VanzyxFolder.Name = "Vanzyxxx"
VanzyxFolder.Parent = CoreGui

-- UI Library
local function CreateUI()
    -- Destroy existing UI
    for _, obj in ipairs(VanzyxFolder:GetChildren()) do
        obj:Destroy()
    end
    
    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VanzyxUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = VanzyxFolder
    
    -- Floating Logo
    local LogoButton = Instance.new("ImageButton")
    LogoButton.Name = "Logo"
    LogoButton.Size = UDim2.new(0, 60, 0, 60)
    LogoButton.Position = UDim2.new(0.5, -30, 0.1, 0)
    LogoButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    LogoButton.BackgroundTransparency = 0.3
    LogoButton.Image = "rbxassetid://7072718366" -- Default Roblox logo
    LogoButton.ScaleType = Enum.ScaleType.Fit
    
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 15)
    LogoCorner.Parent = LogoButton
    
    LogoButton.Parent = ScreenGui
    
    -- Menu Frame
    local MenuFrame = Instance.new("Frame")
    MenuFrame.Name = "Menu"
    MenuFrame.Size = UDim2.new(0, 250, 0, 300)
    MenuFrame.Position = UDim2.new(0.5, -125, 0.1, 70)
    MenuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MenuFrame.BackgroundTransparency = 0.1
    MenuFrame.Visible = false
    MenuFrame.BorderSizePixel = 0
    
    local MenuCorner = Instance.new("UICorner")
    MenuCorner.CornerRadius = UDim.new(0, 12)
    MenuCorner.Parent = MenuFrame
    
    local MenuStroke = Instance.new("UIStroke")
    MenuStroke.Color = Color3.fromRGB(100, 100, 255)
    MenuStroke.Thickness = 2
    MenuStroke.Parent = MenuFrame
    
    -- Menu Top Bar
    local MenuTop = Instance.new("Frame")
    MenuTop.Name = "TopBar"
    MenuTop.Size = UDim2.new(1, 0, 0, 40)
    MenuTop.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    MenuTop.BorderSizePixel = 0
    
    local MenuTopCorner = Instance.new("UICorner")
    MenuTopCorner.CornerRadius = UDim.new(0, 12)
    MenuTopCorner.Parent = MenuTop
    
    local MenuTitle = Instance.new("TextLabel")
    MenuTitle.Name = "Title"
    MenuTitle.Size = UDim2.new(1, -20, 1, 0)
    MenuTitle.Position = UDim2.new(0, 10, 0, 0)
    MenuTitle.BackgroundTransparency = 1
    MenuTitle.Text = "VANZYXXX v2.0"
    MenuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MenuTitle.TextSize = 18
    MenuTitle.Font = Enum.Font.GothamBold
    MenuTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    MenuTop.Parent = MenuFrame
    MenuTitle.Parent = MenuTop
    
    -- Status Panel
    local StatusFrame = Instance.new("Frame")
    StatusFrame.Name = "StatusPanel"
    StatusFrame.Size = UDim2.new(1, -20, 0, 60)
    StatusFrame.Position = UDim2.new(0, 10, 0, 50)
    StatusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    StatusFrame.BorderSizePixel = 0
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 8)
    StatusCorner.Parent = StatusFrame
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "Label"
    StatusLabel.Size = UDim2.new(1, 0, 0, 20)
    StatusLabel.Position = UDim2.new(0, 0, 0, 5)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "STATUS:"
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.TextSize = 14
    StatusLabel.Font = Enum.Font.Gotham
    
    local StatusText = Instance.new("TextLabel")
    StatusText.Name = "Text"
    StatusText.Size = UDim2.new(1, 0, 0, 30)
    StatusText.Position = UDim2.new(0, 0, 0, 25)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "RUNNING"
    StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
    StatusText.TextSize = 20
    StatusText.Font = Enum.Font.GothamBold
    
    StatusFrame.Parent = MenuFrame
    StatusLabel.Parent = StatusFrame
    StatusText.Parent = StatusFrame
    
    -- Modules Panel
    local ModulesFrame = Instance.new("Frame")
    ModulesFrame.Name = "ModulesPanel"
    ModulesFrame.Size = UDim2.new(1, -20, 0, 160)
    ModulesFrame.Position = UDim2.new(0, 10, 0, 120)
    ModulesFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ModulesFrame.BorderSizePixel = 0
    
    local ModulesCorner = Instance.new("UICorner")
    ModulesCorner.CornerRadius = UDim.new(0, 8)
    ModulesCorner.Parent = ModulesFrame
    
    local ModulesTitle = Instance.new("TextLabel")
    ModulesTitle.Name = "Title"
    ModulesTitle.Size = UDim2.new(1, 0, 0, 25)
    ModulesTitle.BackgroundTransparency = 1
    ModulesTitle.Text = "MODULES"
    ModulesTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
    ModulesTitle.TextSize = 16
    ModulesTitle.Font = Enum.Font.GothamBold
    
    ModulesFrame.Parent = MenuFrame
    ModulesTitle.Parent = ModulesFrame
    
    MenuFrame.Parent = ScreenGui
    
    -- Dragging functionality
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function UpdateDrag(input)
        local delta = input.Position - dragStart
        LogoButton.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    LogoButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = LogoButton.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
            
            -- Toggle menu
            MenuFrame.Visible = not MenuFrame.Visible
            if MenuFrame.Visible then
                MenuFrame.Position = UDim2.new(
                    LogoButton.Position.X.Scale,
                    LogoButton.Position.X.Offset,
                    LogoButton.Position.Y.Scale,
                    LogoButton.Position.Y.Offset + 70
                )
            end
        end
    end)
    
    LogoButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            UpdateDrag(input)
            
            -- Update menu position
            if MenuFrame.Visible then
                MenuFrame.Position = UDim2.new(
                    LogoButton.Position.X.Scale,
                    LogoButton.Position.X.Offset,
                    LogoButton.Position.Y.Scale,
                    LogoButton.Position.Y.Offset + 70
                )
            end
        end
    end)
    
    return {
        ScreenGui = ScreenGui,
        Logo = LogoButton,
        Menu = MenuFrame,
        StatusText = StatusText,
        ModulesFrame = ModulesFrame
    }
end

-- Module loader
local function LoadModule(moduleName)
    local moduleUrl = "https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/" .. moduleName
    local success, moduleScript = pcall(function()
        return loadstring(game:HttpGet(moduleUrl, true))()
    end)
    
    if success then
        return moduleScript
    else
        warn("Failed to load module:", moduleName, moduleScript)
        return nil
    end
end

-- Main execution
local UI = CreateUI()

-- Load modules
local AutoCP = LoadModule("autocp.lua")
local FlyModule = LoadModule("fly.lua")
local AutoCarry = LoadModule("autocarry.lua")

-- Start modules automatically
if AutoCP then
    task.spawn(function()
        local status = AutoCP.Start()
        UI.StatusText.Text = status
    end)
end

-- Handle character added
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(1) -- Wait for character to load
    
    if AutoCP and _G.AutoCPRunning then
        task.spawn(function()
            local status = AutoCP.Start()
            UI.StatusText.Text = status
        end)
    end
end)

-- Auto re-execute on respawn
LocalPlayer.CharacterAdded:Connect(function()
    if _G.AutoExecuteOnRespawn then
        task.wait(0.5)
        -- Re-initialize modules
    end
end)

-- Set default status
UI.StatusText.Text = "INITIALIZING..."

-- Wait for character
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

task.wait(1)
UI.StatusText.Text = "RUNNING"

print("[Vanzyxxx] System loaded successfully!")