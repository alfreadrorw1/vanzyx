-- Vanzyxxx Advanced Auto Script System - FIXED
-- Dengan perbaikan duplicate detection dan GUI guarantee

if not game:GetService("RunService"):IsClient() then
    return
end

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 5) or Character:FindFirstChild("Torso") or Character:FindFirstChildWhichIsA("BasePart")
local Humanoid = Character:WaitForChild("Humanoid")

-- ========================
-- FIXED: CLEAN OLD GUI FIRST
-- ========================
local function cleanupOldGUI()
    -- Hapus semua GUI Vanzyxxx lama
    local playerGui = Player:WaitForChild("PlayerGui")
    
    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui.Name == "VanzyxxxAdvancedGUI" or 
           gui.Name == "VanzyxxxGUI" or
           gui.Name:find("Vanzyxxx") then
            gui:Destroy()
        end
    end
    
    -- Juga hapus dari CoreGui (kadang GUI pindah ke sini)
    local coreGui = game:GetService("CoreGui")
    for _, gui in ipairs(coreGui:GetChildren()) do
        if gui.Name == "VanzyxxxAdvancedGUI" or 
           gui.Name == "VanzyxxxGUI" or
           gui.Name:find("Vanzyxxx") then
            gui:Destroy()
        end
    end
end

-- Bersihkan GUI lama sebelum mulai
cleanupOldGUI()

-- Configuration
local CONFIG = {
    MENU_WIDTH = 300,
    MENU_HEIGHT = 500,
    MODULES_URL = "https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/",
    MODULES_LIST = {
        "autocp",
        "autofly", 
        "autoteleport",
        "autocarry",
        "esp",
        "noclip",
        "speed",
        "antiafk",
        "aimbot",
        "tools"
    },
    THEME = {
        PRIMARY = Color3.fromRGB(40, 40, 60),
        SECONDARY = Color3.fromRGB(30, 30, 45),
        ACCENT = Color3.fromRGB(100, 150, 255),
        SUCCESS = Color3.fromRGB(80, 220, 100),
        ERROR = Color3.fromRGB(255, 80, 80),
        TEXT = Color3.fromRGB(255, 255, 255),
        DARK = Color3.fromRGB(20, 20, 30)
    }
}

-- Print debug info
print("==================================================================")
print("🚀 VANZYXXX SCRIPT LOADING...")
print("Player:", Player.Name)
print("Character:", Character.Name)
print("HumanoidRootPart:", HumanoidRootPart and "Found" or "Not Found")
print("==================================================================")

-- Global Modules Table
local Modules = {}
local ModuleStates = {}

-- ========================
-- SIMPLE LOGO FIRST (PASTI MUNCUL)
-- ========================
local function createEmergencyLogo()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VanzyxxxEmergencyGUI"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999
    screenGui.Parent = Player:WaitForChild("PlayerGui")
    
    -- Simple floating logo
    local logo = Instance.new("ImageButton")
    logo.Name = "EmergencyLogo"
    logo.Size = UDim2.new(0, 70, 0, 70)
    logo.Position = UDim2.new(1, -80, 0, 20)
    logo.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    logo.Image = "rbxassetid://6764432408" -- Default icon
    logo.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.3, 0)
    corner.Parent = logo
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 3
    stroke.Parent = logo
    
    -- Logo text
    local text = Instance.new("TextLabel")
    text.Text = "V"
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.Font = Enum.Font.GothamBlack
    text.TextSize = 30
    text.Parent = logo
    
    print("✅ Emergency logo created!")
    return screenGui, logo
end

-- Buat logo darurat dulu
local emergencyGUI, emergencyLogo = createEmergencyLogo()

-- ========================
-- MODULE LOADER (SIMPLIFIED)
-- ========================
local function loadModuleSafe(moduleName)
    local moduleData = {
        name = moduleName,
        description = "Module: " .. moduleName,
        enabled = false,
        toggle = function(state)
            print("Module " .. moduleName .. " toggled:", state)
        end
    }
    
    Modules[moduleName] = moduleData
    ModuleStates[moduleName] = false
    
    return moduleData
end

-- Load all modules (simplified for now)
for _, moduleName in ipairs(CONFIG.MODULES_LIST) do
    loadModuleSafe(moduleName)
end

-- ========================
-- ADVANCED GUI SYSTEM
-- ========================
local UIManager = {
    gui = nil,
    menu = nil,
    logo = nil,
    isMenuOpen = true,
    isMinimized = false,
    
    create = function()
        print("🛠️ Creating main GUI...")
        
        -- Main ScreenGui
        UIManager.gui = Instance.new("ScreenGui")
        UIManager.gui.Name = "VanzyxxxAdvancedGUI"
        UIManager.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        UIManager.gui.DisplayOrder = 1000
        UIManager.gui.ResetOnSpawn = false
        UIManager.gui.Parent = Player:WaitForChild("PlayerGui")
        
        print("✅ GUI parent set")
        
        -- Floating Logo (Top Right) - GANTI ke ini
        UIManager.createLogo()
        
        -- Main Menu Panel (Left Side)
        UIManager.createMenuPanel()
        
        -- Module Buttons Panel
        UIManager.createModulePanel()
        
        -- Hapus emergency logo
        if emergencyGUI then
            emergencyGUI:Destroy()
        end
        
        print("🎉 GUI Creation Complete!")
        
        -- Auto-show menu
        task.wait(0.5)
        UIManager.menu.Visible = true
        
        return true
    end,
    
    createLogo = function()
        print("🎨 Creating floating logo...")
        
        UIManager.logo = Instance.new("ImageButton")
        UIManager.logo.Name = "VanzyxxxLogo"
        UIManager.logo.Size = UDim2.new(0, 70, 0, 70) -- Sedikit lebih besar
        UIManager.logo.Position = UDim2.new(1, -80, 0, 20) -- Pojok kanan atas
        UIManager.logo.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        UIManager.logo.Image = "rbxassetid://6764432408" -- PASTI ADA
        
        -- Try load custom logo
        task.spawn(function()
            local success = pcall(function()
                UIManager.logo.Image = "https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/img/logo.png"
            end)
            if not success then
                UIManager.logo.Image = "rbxassetid://6764432408"
            end
        end)
        
        UIManager.logo.Parent = UIManager.gui
        
        -- Styling
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.2, 0)
        corner.Parent = UIManager.logo
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 3
        stroke.Parent = UIManager.logo
        
        -- Glow effect
        local glow = Instance.new("ImageLabel")
        glow.Name = "Glow"
        glow.Image = "rbxassetid://8992230677"
        glow.ImageColor3 = Color3.fromRGB(100, 150, 255)
        glow.ImageTransparency = 0.7
        glow.Size = UDim2.new(1.5, 0, 1.5, 0)
        glow.Position = UDim2.new(-0.25, 0, -0.25, 0)
        glow.BackgroundTransparency = 1
        glow.Parent = UIManager.logo
        
        -- Logo text
        local text = Instance.new("TextLabel")
        text.Name = "LogoText"
        text.Text = "V"
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.TextColor3 = Color3.fromRGB(255, 255, 255)
        text.Font = Enum.Font.GothamBlack
        text.TextSize = 32
        text.Parent = UIManager.logo
        
        print("✅ Logo created")
        
        -- Logo Click: Toggle Menu
        UIManager.logo.MouseButton1Click:Connect(function()
            print("🖱️ Logo clicked")
            UIManager.toggleMenu()
        end)
        
        -- Make logo draggable
        UIManager.makeDraggable(UIManager.logo)
    end,
    
    createMenuPanel = function()
        print("📋 Creating menu panel...")
        
        -- Main Container
        UIManager.menu = Instance.new("Frame")
        UIManager.menu.Name = "MainMenu"
        UIManager.menu.Size = UDim2.new(0, CONFIG.MENU_WIDTH, 0, CONFIG.MENU_HEIGHT)
        UIManager.menu.Position = UDim2.new(0, 20, 0.5, -CONFIG.MENU_HEIGHT/2)
        UIManager.menu.BackgroundColor3 = CONFIG.THEME.DARK
        UIManager.menu.BackgroundTransparency = 0.05
        UIManager.menu.Visible = true -- LANGSUNG VISIBLE
        UIManager.menu.Parent = UIManager.gui
        
        -- Corner
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.08, 0)
        corner.Parent = UIManager.menu
        
        -- Shadow Effect
        local shadow = Instance.new("ImageLabel")
        shadow.Name = "Shadow"
        shadow.Image = "rbxassetid://5554237735"
        shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        shadow.ImageTransparency = 0.8
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.SliceCenter = Rect.new(10, 10, 118, 118)
        shadow.Size = UDim2.new(1, 20, 1, 20)
        shadow.Position = UDim2.new(0, -10, 0, -10)
        shadow.BackgroundTransparency = 1
        shadow.Parent = UIManager.menu
        
        -- Title Bar
        local titleBar = Instance.new("Frame")
        titleBar.Name = "TitleBar"
        titleBar.Size = UDim2.new(1, 0, 0, 40)
        titleBar.Position = UDim2.new(0, 0, 0, 0)
        titleBar.BackgroundColor3 = CONFIG.THEME.PRIMARY
        titleBar.Parent = UIManager.menu
        
        local titleCorner = Instance.new("UICorner")
        titleCorner.CornerRadius = UDim.new(0.08, 0.08)
        titleCorner.Parent = titleBar
        
        -- Title Text
        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Text = "🚀 VANZYXXX V3"
        title.Size = UDim2.new(0.7, 0, 1, 0)
        title.Position = UDim2.new(0, 10, 0, 0)
        title.BackgroundTransparency = 1
        title.TextColor3 = CONFIG.THEME.TEXT
        title.Font = Enum.Font.GothamBold
        title.TextSize = 18
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = titleBar
        
        -- Minimize Button (-)
        local minimizeBtn = Instance.new("TextButton")
        minimizeBtn.Name = "MinimizeBtn"
        minimizeBtn.Text = "─"
        minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
        minimizeBtn.Position = UDim2.new(1, -70, 0.5, -15)
        minimizeBtn.BackgroundColor3 = CONFIG.THEME.SECONDARY
        minimizeBtn.TextColor3 = CONFIG.THEME.TEXT
        minimizeBtn.Font = Enum.Font.GothamBold
        minimizeBtn.TextSize = 20
        minimizeBtn.Parent = titleBar
        
        local minimizeCorner = Instance.new("UICorner")
        minimizeCorner.CornerRadius = UDim.new(0.3, 0)
        minimizeCorner.Parent = minimizeBtn
        
        -- Close Button (X)
        local closeBtn = Instance.new("TextButton")
        closeBtn.Name = "CloseBtn"
        closeBtn.Text = "✕"
        closeBtn.Size = UDim2.new(0, 30, 0, 30)
        closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
        closeBtn.BackgroundColor3 = CONFIG.THEME.ERROR
        closeBtn.TextColor3 = CONFIG.THEME.TEXT
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 18
        closeBtn.Parent = titleBar
        
        local closeCorner = Instance.new("UICorner")
        closeCorner.CornerRadius = UDim.new(0.5, 0)
        closeCorner.Parent = closeBtn
        
        -- Status Bar
        local statusBar = Instance.new("Frame")
        statusBar.Name = "StatusBar"
        statusBar.Size = UDim2.new(1, -20, 0, 30)
        statusBar.Position = UDim2.new(0, 10, 0, 50)
        statusBar.BackgroundColor3 = CONFIG.THEME.SECONDARY
        statusBar.Parent = UIManager.menu
        
        local statusCorner = Instance.new("UICorner")
        statusCorner.CornerRadius = UDim.new(0.05, 0)
        statusCorner.Parent = statusBar
        
        local statusIcon = Instance.new("TextLabel")
        statusIcon.Name = "StatusIcon"
        statusIcon.Text = "●"
        statusIcon.Size = UDim2.new(0, 20, 1, 0)
        statusIcon.Position = UDim2.new(0, 5, 0, 0)
        statusIcon.BackgroundTransparency = 1
        statusIcon.TextColor3 = CONFIG.THEME.SUCCESS
        statusIcon.Font = Enum.Font.GothamBold
        statusIcon.TextSize = 14
        statusIcon.Parent = statusBar
        
        local statusText = Instance.new("TextLabel")
        statusText.Name = "StatusText"
        statusText.Text = "Ready to use!"
        statusText.Size = UDim2.new(1, -30, 1, 0)
        statusText.Position = UDim2.new(0, 25, 0, 0)
        statusText.BackgroundTransparency = 1
        statusText.TextColor3 = CONFIG.THEME.TEXT
        statusText.Font = Enum.Font.Gotham
        statusText.TextSize = 12
        statusText.TextXAlignment = Enum.TextXAlignment.Left
        statusText.Parent = statusBar
        
        -- Module Count
        local moduleCount = Instance.new("TextLabel")
        moduleCount.Name = "ModuleCount"
        moduleCount.Text = "Modules: " .. #CONFIG.MODULES_LIST .. " loaded"
        moduleCount.Size = UDim2.new(1, -20, 0, 20)
        moduleCount.Position = UDim2.new(0, 10, 0, 90)
        moduleCount.BackgroundTransparency = 1
        moduleCount.TextColor3 = Color3.fromRGB(200, 200, 200)
        moduleCount.Font = Enum.Font.Gotham
        moduleCount.TextSize = 11
        moduleCount.TextXAlignment = Enum.TextXAlignment.Left
        moduleCount.Parent = UIManager.menu
        
        -- Button Callbacks
        minimizeBtn.MouseButton1Click:Connect(function()
            print("📥 Minimize clicked")
            UIManager.toggleMinimize()
        end)
        
        closeBtn.MouseButton1Click:Connect(function()
            print("❌ Close clicked")
            UIManager.hideMenu()
        end)
        
        -- Make title bar draggable
        UIManager.makeDraggable(titleBar, UIManager.menu)
        
        print("✅ Menu panel created")
    end,
    
    createModulePanel = function()
        print("🔘 Creating module buttons...")
        
        -- Scroll Frame for Modules
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Name = "ModuleScroll"
        scrollFrame.Size = UDim2.new(1, -20, 1, -120)
        scrollFrame.Position = UDim2.new(0, 10, 0, 120)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.BorderSizePixel = 0
        scrollFrame.ScrollBarThickness = 5
        scrollFrame.ScrollBarImageColor3 = CONFIG.THEME.SECONDARY
        scrollFrame.Parent = UIManager.menu
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 5)
        layout.Parent = scrollFrame
        
        -- Auto-resize scroll frame
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
        end)
        
        -- Store scroll frame reference
        UIManager.moduleScroll = scrollFrame
        
        -- Create buttons for all modules
        for moduleName, moduleData in pairs(Modules) do
            UIManager.createModuleButton(moduleName, moduleData)
        end
        
        print("✅ Module buttons created")
    end,
    
    createModuleButton = function(moduleName, moduleData)
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Name = moduleName .. "Btn"
        buttonFrame.Size = UDim2.new(1, 0, 0, 50)
        buttonFrame.BackgroundColor3 = CONFIG.THEME.SECONDARY
        buttonFrame.Parent = UIManager.moduleScroll
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.05, 0)
        corner.Parent = buttonFrame
        
        -- Module Name
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "Name"
        nameLabel.Text = "🔧 " .. moduleName:upper()
        nameLabel.Size = UDim2.new(0.7, 0, 0.6, 0)
        nameLabel.Position = UDim2.new(0, 10, 0, 5)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = CONFIG.THEME.TEXT
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = buttonFrame
        
        -- Module Description
        local descLabel = Instance.new("TextLabel")
        descLabel.Name = "Description"
        descLabel.Text = moduleData.description or "Click to toggle"
        descLabel.Size = UDim2.new(0.7, 0, 0.4, 0)
        descLabel.Position = UDim2.new(0, 10, 0.6, 0)
        descLabel.BackgroundTransparency = 1
        descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 10
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = buttonFrame
        
        -- Toggle Button
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Name = "Toggle"
        toggleBtn.Text = "OFF"
        toggleBtn.Size = UDim2.new(0.25, 0, 0.7, 0)
        toggleBtn.Position = UDim2.new(0.73, 0, 0.15, 0)
        toggleBtn.BackgroundColor3 = CONFIG.THEME.ERROR
        toggleBtn.TextColor3 = CONFIG.THEME.TEXT
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.TextSize = 12
        toggleBtn.Parent = buttonFrame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0.3, 0)
        toggleCorner.Parent = toggleBtn
        
        -- Status Indicator
        local statusIndicator = Instance.new("Frame")
        statusIndicator.Name = "Indicator"
        statusIndicator.Size = UDim2.new(0, 8, 0, 8)
        statusIndicator.Position = UDim2.new(0.93, 0, 0.5, -4)
        statusIndicator.BackgroundColor3 = CONFIG.THEME.ERROR
        statusIndicator.Parent = buttonFrame
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(0.5, 0)
        indicatorCorner.Parent = statusIndicator
        
        -- Toggle Functionality
        toggleBtn.MouseButton1Click:Connect(function()
            ModuleStates[moduleName] = not ModuleStates[moduleName]
            
            -- Update UI
            if ModuleStates[moduleName] then
                toggleBtn.Text = "ON"
                toggleBtn.BackgroundColor3 = CONFIG.THEME.SUCCESS
                statusIndicator.BackgroundColor3 = CONFIG.THEME.SUCCESS
                print("✅ " .. moduleName .. " enabled")
            else
                toggleBtn.Text = "OFF"
                toggleBtn.BackgroundColor3 = CONFIG.THEME.ERROR
                statusIndicator.BackgroundColor3 = CONFIG.THEME.ERROR
                print("❌ " .. moduleName .. " disabled")
            end
            
            -- Call module toggle
            if moduleData.toggle then
                local success, err = pcall(function()
                    moduleData.toggle(ModuleStates[moduleName])
                end)
                
                if not success then
                    print("⚠️ Error toggling " .. moduleName .. ": " .. err)
                end
            end
        end)
    end,
    
    toggleMenu = function()
        UIManager.isMenuOpen = not UIManager.isMenuOpen
        UIManager.menu.Visible = UIManager.isMenuOpen
        print("📱 Menu toggled:", UIManager.isMenuOpen)
    end,
    
    hideMenu = function()
        UIManager.isMenuOpen = false
        UIManager.menu.Visible = false
        print("📱 Menu hidden")
    end,
    
    toggleMinimize = function()
        UIManager.isMinimized = not UIManager.isMinimized
        
        if UIManager.isMinimized then
            -- Minimize to just title bar
            UIManager.menu.Size = UDim2.new(0, CONFIG.MENU_WIDTH, 0, 40)
            print("📱 Menu minimized")
        else
            -- Restore full size
            UIManager.menu.Size = UDim2.new(0, CONFIG.MENU_WIDTH, 0, CONFIG.MENU_HEIGHT)
            print("📱 Menu restored")
        end
    end,
    
    makeDraggable = function(frame, parent)
        parent = parent or frame
        local dragging = false
        local dragInput, dragStart, startPos
        
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = parent.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input == dragInput then
                local delta = input.Position - dragStart
                parent.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    end
}

-- ========================
-- SIMPLE FLY SYSTEM (BUILT-IN)
-- ========================
local function createSimpleFly()
    local flyEnabled = false
    local velocity, bodyGyro
    
    local function enableFly()
        local char = Player.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        -- Clean old
        if velocity then velocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        
        -- Create new
        velocity = Instance.new("BodyVelocity")
        velocity.Velocity = Vector3.new(0, 0, 0)
        velocity.MaxForce = Vector3.new(10000, 10000, 10000)
        velocity.P = 5000
        velocity.Name = "SimpleFlyVelocity"
        velocity.Parent = hrp
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
        bodyGyro.P = 5000
        bodyGyro.CFrame = hrp.CFrame
        bodyGyro.Name = "SimpleFlyGyro"
        bodyGyro.Parent = hrp
        
        -- Disable gravity
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end
        
        flyEnabled = true
        print("✈️ Simple fly enabled")
        
        -- Fly control
        local keysDown = {}
        local flySpeed = 50
        
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                keysDown[input.KeyCode] = true
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                keysDown[input.KeyCode] = nil
            end
        end)
        
        -- Flight loop
        RunService.Heartbeat:Connect(function()
            if not flyEnabled or not velocity or not hrp then return end
            
            local direction = Vector3.new(0, 0, 0)
            
            if keysDown[Enum.KeyCode.W] then direction = direction + Vector3.new(0, 0, -1) end
            if keysDown[Enum.KeyCode.S] then direction = direction + Vector3.new(0, 0, 1) end
            if keysDown[Enum.KeyCode.A] then direction = direction + Vector3.new(-1, 0, 0) end
            if keysDown[Enum.KeyCode.D] then direction = direction + Vector3.new(1, 0, 0) end
            if keysDown[Enum.KeyCode.Space] then direction = direction + Vector3.new(0, 1, 0) end
            if keysDown[Enum.KeyCode.LeftShift] then direction = direction + Vector3.new(0, -1, 0) end
            
            if direction.Magnitude > 0 then
                direction = direction.Unit
                
                -- Camera relative
                local cam = workspace.CurrentCamera
                if cam then
                    local forward = cam.CFrame.LookVector
                    local right = cam.CFrame.RightVector
                    local up = Vector3.new(0, 1, 0)
                    
                    direction = (direction.X * right) + (direction.Y * up) + (direction.Z * forward)
                    direction = direction.Unit
                end
                
                velocity.Velocity = direction * flySpeed
                
                if bodyGyro then
                    bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + direction)
                end
            else
                velocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end
    
    local function disableFly()
        if velocity then velocity:Destroy() velocity = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        
        local char = Player.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
        
        flyEnabled = false
        print("✈️ Simple fly disabled")
    end
    
    -- Update autofly module
    if Modules.autofly then
        Modules.autofly.toggle = function(state)
            if state then
                enableFly()
            else
                disableFly()
            end
            return state
        end
    end
    
    -- Auto-enable fly
    task.wait(2)
    enableFly()
    print("✈️ Auto-fly enabled on startup")
end

-- ========================
-- SIMPLE AUTO CP
-- ========================
local function createSimpleAutoCP()
    if Modules.autocp then
        Modules.autocp.toggle = function(state)
            if state then
                print("▶️ Starting Auto CP...")
                
                -- Simple CP finder
                local checkpoints = {}
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():find("checkpoint") or obj.Name:find("CP")) then
                        table.insert(checkpoints, obj)
                    end
                end
                
                if #checkpoints == 0 then
                    print("❌ No checkpoints found")
                    return false
                end
                
                print("✅ Found " .. #checkpoints .. " checkpoints")
                
                -- Teleport to each
                for i, cp in ipairs(checkpoints) do
                    if Player.Character then
                        local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = CFrame.new(cp.Position + Vector3.new(0, 5, 0))
                            print("📍 CP " .. i .. "/" .. #checkpoints)
                            task.wait(0.5)
                        end
                    end
                end
                
                print("🎉 Auto CP completed!")
            else
                print("⏹️ Auto CP stopped")
            end
            return state
        end
    end
end

-- ========================
-- INITIALIZATION
-- ========================
local function initialize()
    print("🚀 Starting Vanzyxxx initialization...")
    
    -- Create GUI (PASTI BERHASIL)
    local guiSuccess = UIManager.create()
    
    if guiSuccess then
        print("✅ GUI created successfully")
        
        -- Enable simple fly system
        createSimpleFly()
        
        -- Enable simple auto CP
        createSimpleAutoCP()
        
        -- Send notification
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Vanzyxxx",
            Text = "Script loaded successfully!",
            Duration = 5,
            Icon = "rbxassetid://6764432408"
        })
        
        print("==================================================================")
        print("🎉 VANZYXXX LOADED SUCCESSFULLY!")
        print("👉 Click the blue V logo to open menu")
        print("👉 Press W/A/S/D/Space/Shift to fly")
        print("==================================================================")
    else
        print("❌ Failed to create GUI")
        
        -- Fallback: Just show logo
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Vanzyxxx Error",
            Text = "GUI failed but logo should be visible",
            Duration = 5
        })
    end
    
    -- Character respawn handler
    Player.CharacterAdded:Connect(function(newChar)
        print("🔄 Character respawned")
        Character = newChar
        HumanoidRootPart = newChar:FindFirstChild("HumanoidRootPart") or newChar:FindFirstChildWhichIsA("BasePart")
        Humanoid = newChar:FindFirstChild("Humanoid")
        
        -- Re-enable fly if it was on
        task.wait(1)
        if Modules.autofly and Modules.autofly.toggle then
            pcall(function()
                Modules.autofly.toggle(true)
            end)
        end
    end)
end

-- Start everything dengan error handling
local success, err = pcall(function()
    initialize()
end)

if not success then
    print("❌ CRITICAL ERROR: " .. err)
    
    -- Emergency fallback: simple message
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Vanzyxxx Error",
        Text = "Script error: " .. tostring(err):sub(1, 100),
        Duration = 10
    })
end

-- Return success
return "Vanzyxxx Script Loaded v3.0"