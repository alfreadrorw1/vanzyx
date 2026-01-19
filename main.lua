-- Vanzyxxx Advanced Auto Script System
-- Modular Design dengan Auto-Load Modules

if not game:GetService("RunService"):IsClient() then
    return
end

-- Prevent duplicate execution
if _G.VanzyxxxLoaded then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Vanzyxxx",
        Text = "Script already running!",
        Duration = 3
    })
    return
end
_G.VanzyxxxLoaded = true

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 5)
local Humanoid = Character:WaitForChild("Humanoid")

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

-- Global Modules Table
local Modules = {}
local ModuleStates = {}

-- Logging System
local Logger = {
    log = function(message, type)
        local prefix = type == "ERROR" and "❌" or type == "WARN" and "⚠️" or "✅"
        print("[Vanzyxxx] " .. prefix .. " " .. message)
    end,
    
    notify = function(title, message, duration)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = message,
            Duration = duration or 3
        })
    end
}

-- ========================
-- MODULE AUTO-LOAD SYSTEM
-- ========================
local ModuleLoader = {
    loaded = 0,
    total = #CONFIG.MODULES_LIST,
    
    loadModule = function(moduleName)
        local success, result = pcall(function()
            local url = CONFIG.MODULES_URL .. moduleName .. ".lua"
            Logger.log("Loading: " .. moduleName, "INFO")
            
            -- Try to load from GitHub
            local source = game:HttpGet(url, true)
            if not source or source == "" then
                error("Empty source for " .. moduleName)
            end
            
            -- Create module environment
            local env = {
                require = require,
                game = game,
                workspace = workspace,
                Players = Players,
                TweenService = TweenService,
                RunService = RunService,
                UserInputService = UserInputService,
                Player = Player,
                Character = Character,
                HumanoidRootPart = HumanoidRootPart,
                Humanoid = Humanoid,
                Logger = Logger,
                Config = CONFIG,
                Modules = Modules
            }
            
            setfenv(loadstring(source), setmetatable(env, {__index = _G}))
            
            local moduleFunc = loadstring(source)
            if not moduleFunc then
                error("Failed to compile module")
            end
            
            local module = moduleFunc()
            Modules[moduleName] = module
            ModuleStates[moduleName] = false
            
            Logger.log(moduleName .. " loaded successfully!", "SUCCESS")
            return true
        end)
        
        if not success then
            Logger.log("Failed to load " .. moduleName .. ": " .. result, "ERROR")
            Modules[moduleName] = {
                name = moduleName,
                enabled = false,
                toggle = function() 
                    Logger.notify("Module Error", moduleName .. " failed to load!", 3)
                end,
                description = "Failed to load module"
            }
            return false
        end
        return true
    end,
    
    loadAll = function()
        Logger.log("Loading " .. CONFIG.loaded .. "/" .. CONFIG.total .. " modules...", "INFO")
        
        for _, moduleName in ipairs(CONFIG.MODULES_LIST) do
            task.spawn(function()
                ModuleLoader.loadModule(moduleName)
                ModuleLoader.loaded = ModuleLoader.loaded + 1
            end)
        end
        
        -- Wait for all modules to load
        repeat
            task.wait(0.1)
        until ModuleLoader.loaded >= CONFIG.total
        
        Logger.log("All modules loaded!", "SUCCESS")
    end
}

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
        -- Main ScreenGui
        UIManager.gui = Instance.new("ScreenGui")
        UIManager.gui.Name = "VanzyxxxAdvancedGUI"
        UIManager.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        UIManager.gui.ResetOnSpawn = false
        UIManager.gui.Parent = Player:WaitForChild("PlayerGui")
        
        -- Remove duplicates
        for _, existing in ipairs(Player.PlayerGui:GetChildren()) do
            if existing.Name == "VanzyxxxAdvancedGUI" then
                existing:Destroy()
            end
        end
        
        -- Floating Logo (Top Right)
        UIManager.createLogo()
        
        -- Main Menu Panel (Left Side)
        UIManager.createMenuPanel()
        
        -- Module Buttons Panel
        UIManager.createModulePanel()
        
        Logger.log("GUI Created Successfully", "SUCCESS")
    end,
    
    createLogo = function()
        UIManager.logo = Instance.new("ImageButton")
        UIManager.logo.Name = "VanzyxxxLogo"
        UIManager.logo.Size = UDim2.new(0, 60, 0, 60)
        UIManager.logo.Position = UDim2.new(1, -70, 0, 20)
        UIManager.logo.BackgroundColor3 = CONFIG.THEME.PRIMARY
        UIManager.logo.Image = "rbxassetid://6764432408" -- Default Roblox icon
        UIManager.logo.Parent = UIManager.gui
        
        -- Try to load custom logo
        task.spawn(function()
            pcall(function()
                UIManager.logo.Image = "https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/img/logo.png"
            end)
        end)
        
        -- Styling
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.2, 0)
        corner.Parent = UIManager.logo
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = CONFIG.THEME.ACCENT
        stroke.Thickness = 3
        stroke.Parent = UIManager.logo
        
        -- Logo Click: Toggle Menu
        UIManager.logo.MouseButton1Click:Connect(function()
            UIManager.toggleMenu()
        end)
        
        -- Make logo draggable
        UIManager.makeDraggable(UIManager.logo)
    end,
    
    createMenuPanel = function()
        -- Main Container
        UIManager.menu = Instance.new("Frame")
        UIManager.menu.Name = "MainMenu"
        UIManager.menu.Size = UDim2.new(0, CONFIG.MENU_WIDTH, 0, CONFIG.MENU_HEIGHT)
        UIManager.menu.Position = UDim2.new(0, 20, 0.5, -CONFIG.MENU_HEIGHT/2)
        UIManager.menu.BackgroundColor3 = CONFIG.THEME.DARK
        UIManager.menu.BackgroundTransparency = 0.05
        UIManager.menu.Visible = true
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
        statusText.Text = "Loading modules..."
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
        moduleCount.Text = "Modules: 0/" .. CONFIG.total
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
            UIManager.toggleMinimize()
        end)
        
        closeBtn.MouseButton1Click:Connect(function()
            UIManager.hideMenu()
        end)
        
        -- Make title bar draggable
        UIManager.makeDraggable(titleBar, UIManager.menu)
    end,
    
    createModulePanel = function()
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
        descLabel.Text = moduleData.description or "No description"
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
            else
                toggleBtn.Text = "OFF"
                toggleBtn.BackgroundColor3 = CONFIG.THEME.ERROR
                statusIndicator.BackgroundColor3 = CONFIG.THEME.ERROR
            end
            
            -- Call module toggle function
            if Modules[moduleName] and Modules[moduleName].toggle then
                local success, err = pcall(function()
                    Modules[moduleName].toggle(ModuleStates[moduleName])
                end)
                
                if not success then
                    Logger.log("Error toggling " .. moduleName .. ": " .. err, "ERROR")
                    ModuleStates[moduleName] = not ModuleStates[moduleName] -- Revert
                    toggleBtn.Text = "OFF"
                    toggleBtn.BackgroundColor3 = CONFIG.THEME.ERROR
                    statusIndicator.BackgroundColor3 = CONFIG.THEME.ERROR
                end
            end
        end)
        
        return buttonFrame
    end,
    
    updateStatus = function(text, isError)
        local statusText = UIManager.menu:FindFirstChild("StatusBar"):FindFirstChild("StatusText")
        local statusIcon = UIManager.menu:FindFirstChild("StatusBar"):FindFirstChild("StatusIcon")
        
        if statusText then
            statusText.Text = text
        end
        
        if statusIcon then
            if isError then
                statusIcon.TextColor3 = CONFIG.THEME.ERROR
                statusIcon.Text = "⚠️"
            else
                statusIcon.TextColor3 = CONFIG.THEME.SUCCESS
                statusIcon.Text = "●"
            end
        end
    end,
    
    updateModuleCount = function(loaded, total)
        local moduleCount = UIManager.menu:FindFirstChild("ModuleCount")
        if moduleCount then
            moduleCount.Text = "Modules: " .. loaded .. "/" .. total
        end
    end,
    
    toggleMenu = function()
        UIManager.isMenuOpen = not UIManager.isMenuOpen
        UIManager.menu.Visible = UIManager.isMenuOpen
        
        if UIManager.isMenuOpen then
            -- Animate in
            UIManager.menu.Position = UDim2.new(0, -CONFIG.MENU_WIDTH, 0.5, -CONFIG.MENU_HEIGHT/2)
            local tween = TweenService:Create(UIManager.menu, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0, 20, 0.5, -CONFIG.MENU_HEIGHT/2)
            })
            tween:Play()
        end
    end,
    
    hideMenu = function()
        UIManager.isMenuOpen = false
        UIManager.menu.Visible = false
    end,
    
    toggleMinimize = function()
        UIManager.isMinimized = not UIManager.isMinimized
        
        if UIManager.isMinimized then
            -- Minimize to just title bar
            UIManager.menu.Size = UDim2.new(0, CONFIG.MENU_WIDTH, 0, 40)
        else
            -- Restore full size
            UIManager.menu.Size = UDim2.new(0, CONFIG.MENU_WIDTH, 0, CONFIG.MENU_HEIGHT)
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
-- INITIALIZATION
-- ========================
local function initialize()
    Logger.log("Initializing Vanzyxxx Advanced System...", "INFO")
    
    -- Create GUI First (so user can see something)
    UIManager.create()
    UIManager.updateStatus("Creating GUI...", false)
    
    -- Load modules in background
    task.spawn(function()
        UIManager.updateStatus("Loading modules...", false)
        ModuleLoader.loadAll()
        
        -- Create module buttons
        for moduleName, moduleData in pairs(Modules) do
            if UIManager.moduleScroll then
                local button = UIManager.createModuleButton(moduleName, moduleData)
                task.wait() -- Prevent UI freeze
            end
        end
        
        UIManager.updateStatus("Ready! " .. ModuleLoader.loaded .. " modules loaded", false)
        UIManager.updateModuleCount(ModuleLoader.loaded, CONFIG.total)
        
        -- Auto-start some modules
        task.wait(1)
        if Modules.autofly then
            ModuleStates.autofly = true
            Modules.autofly.toggle(true)
            Logger.notify("Auto-Fly", "Fly system auto-enabled!", 3)
        end
    end)
    
    -- Character respawn handling
    Player.CharacterAdded:Connect(function(newChar)
        Character = newChar
        HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart", 5)
        Humanoid = newChar:WaitForChild("Humanoid")
        
        -- Reinitialize modules that need character
        for moduleName, isEnabled in pairs(ModuleStates) do
            if isEnabled and Modules[moduleName] and Modules[moduleName].onCharacterAdded then
                pcall(function()
                    Modules[moduleName].onCharacterAdded(newChar)
                end)
            end
        end
        
        Logger.log("Character respawned, modules reinitialized", "INFO")
    end)
    
    -- Anti-AFK
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local lastActivity = os.time()
    
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        if ModuleStates.antiafk then
            VirtualInputManager:SendKeyEvent(true, "Space", false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, "Space", false, game)
            lastActivity = os.time()
        end
    end)
    
    Logger.log("System initialized successfully!", "SUCCESS")
    Logger.notify("Vanzyxxx", "System loaded with " .. #CONFIG.MODULES_LIST .. " modules!", 5)
end

-- Start everything
initialize()

-- Return modules table for external access
return {
    Modules = Modules,
    Config = CONFIG,
    UI = UIManager,
    Logger = Logger
}