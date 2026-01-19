--[[
    Delta Executor - Modular Menu System
    Creator: Roblox Lua Developer
    Compatible: Android/Mobile
    No Key System | No External Libraries
--]]

-- Tunggu sampai game siap
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Tunggu sampai Player muncul
local Players = game:GetService("Players")
local player = Players.LocalPlayer
if not player then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    player = Players.LocalPlayer
end

-- Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Tunggu sampai Character dan PlayerGui siap
repeat wait() until player.Character
local PlayerGui = player:WaitForChild("PlayerGui")

-- Fungsi untuk membuat UI utama
local function createMainUI()
    -- Hapus UI lama jika ada
    local oldUI = PlayerGui:FindFirstChild("DeltaExecutorUI")
    if oldUI then
        oldUI:Destroy()
    end

    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DeltaExecutorUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 999

    -- Main Container
    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Size = UDim2.new(0, 550, 0, 380)
    MainContainer.Position = UDim2.new(0.5, -275, 0.5, -190)
    MainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    MainContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainContainer.BackgroundTransparency = 0
    MainContainer.BorderSizePixel = 0
    MainContainer.ClipsDescendants = true
    MainContainer.Visible = true

    -- Corner & Shadow
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = MainContainer

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.Position = UDim2.new(0.5, -10, 0.5, -10)
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://8577661197"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = -1
    Shadow.Parent = MainContainer

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    Header.BorderSizePixel = 0
    Header.BackgroundTransparency = 0

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header

    -- Logo
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(0, 28, 0, 28)
    Logo.Position = UDim2.new(0, 12, 0.5, -14)
    Logo.AnchorPoint = Vector2.new(0, 0.5)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://10734964822"
    Logo.ImageColor3 = Color3.fromRGB(0, 170, 255)
    Logo.Parent = Header

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 180, 0, 30)
    Title.Position = UDim2.new(0, 50, 0.5, -15)
    Title.AnchorPoint = Vector2.new(0, 0.5)
    Title.BackgroundTransparency = 1
    Title.Text = "DELTA EXECUTOR"
    Title.TextColor3 = Color3.fromRGB(0, 170, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextTransparency = 0
    Title.Parent = Header

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
    CloseButton.AnchorPoint = Vector2.new(1, 0.5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.white
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextTransparency = 0

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    CloseButton.Parent = Header

    Header.Parent = MainContainer

    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, 0, 1, -45)
    ContentContainer.Position = UDim2.new(0, 0, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    ContentContainer.Parent = MainContainer

    -- Sidebar (Left - 35%)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0.35, 0, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Sidebar.BorderSizePixel = 0
    Sidebar.BackgroundTransparency = 0

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 0, 0, 12)
    SidebarCorner.Parent = Sidebar

    -- Sidebar Buttons Container
    local SidebarButtons = Instance.new("ScrollingFrame")
    SidebarButtons.Name = "SidebarButtons"
    SidebarButtons.Size = UDim2.new(1, -5, 1, -10)
    SidebarButtons.Position = UDim2.new(0, 5, 0, 5)
    SidebarButtons.BackgroundTransparency = 1
    SidebarButtons.BorderSizePixel = 0
    SidebarButtons.ScrollBarThickness = 3
    SidebarButtons.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
    SidebarButtons.CanvasSize = UDim2.new(0, 0, 0, 0)

    local ButtonsLayout = Instance.new("UIListLayout")
    ButtonsLayout.Padding = UDim.new(0, 6)
    ButtonsLayout.Parent = SidebarButtons

    SidebarButtons.Parent = Sidebar
    Sidebar.Parent = ContentContainer

    -- Right Panel (65%)
    local RightPanel = Instance.new("Frame")
    RightPanel.Name = "RightPanel"
    RightPanel.Size = UDim2.new(0.65, 0, 1, 0)
    RightPanel.Position = UDim2.new(0.35, 0, 0, 0)
    RightPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    RightPanel.BorderSizePixel = 0
    RightPanel.BackgroundTransparency = 0

    local RightPanelCorner = Instance.new("UICorner")
    RightPanelCorner.CornerRadius = UDim.new(0, 0, 0, 12)
    RightPanelCorner.Parent = RightPanel

    -- Right Panel Content
    local PanelContent = Instance.new("Frame")
    PanelContent.Name = "PanelContent"
    PanelContent.Size = UDim2.new(1, -10, 1, -10)
    PanelContent.Position = UDim2.new(0, 5, 0, 5)
    PanelContent.BackgroundTransparency = 1
    PanelContent.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

    local PanelScroll = Instance.new("ScrollingFrame")
    PanelScroll.Name = "PanelScroll"
    PanelScroll.Size = UDim2.new(1, 0, 1, 0)
    PanelScroll.BackgroundTransparency = 1
    PanelScroll.BorderSizePixel = 0
    PanelScroll.ScrollBarThickness = 4
    PanelScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
    PanelScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

    local PanelLayout = Instance.new("UIListLayout")
    PanelLayout.Padding = UDim.new(0, 8)
    PanelLayout.Parent = PanelScroll

    PanelScroll.Parent = PanelContent
    PanelContent.Parent = RightPanel
    RightPanel.Parent = ContentContainer

    -- Module System
    local Modules = {}
    local ActiveModule = nil

    -- Function to create sidebar button
    local function createSidebarButton(name, icon)
        local Button = Instance.new("TextButton")
        Button.Name = name .. "Button"
        Button.Size = UDim2.new(1, -5, 0, 50)
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        Button.Text = ""
        Button.AutoButtonColor = false
        Button.BackgroundTransparency = 0
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = Button
        
        local Icon = Instance.new("ImageLabel")
        Icon.Name = "Icon"
        Icon.Size = UDim2.new(0, 22, 0, 22)
        Icon.Position = UDim2.new(0, 12, 0.5, -11)
        Icon.AnchorPoint = Vector2.new(0, 0.5)
        Icon.BackgroundTransparency = 1
        Icon.Image = icon or "rbxassetid://10734964822"
        Icon.ImageColor3 = Color3.fromRGB(150, 150, 170)
        Icon.Parent = Button
        
        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.Size = UDim2.new(1, -50, 1, 0)
        Label.Position = UDim2.new(0, 42, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(200, 200, 220)
        Label.TextSize = 14
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.TextTransparency = 0
        Label.Parent = Button
        
        local Highlight = Instance.new("Frame")
        Highlight.Name = "Highlight"
        Highlight.Size = UDim2.new(0, 3, 0.7, 0)
        Highlight.Position = UDim2.new(0, 0, 0.15, 0)
        Highlight.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        Highlight.Visible = false
        Highlight.Parent = Button
        
        -- Button hover effect
        Button.MouseEnter:Connect(function()
            if ActiveModule ~= name then
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(55, 55, 65)
                }):Play()
            end
        end)
        
        Button.MouseLeave:Connect(function()
            if ActiveModule ~= name then
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                }):Play()
            end
        end)
        
        return Button
    end

    -- Function to clear panel
    local function clearPanel()
        for _, child in ipairs(PanelScroll:GetChildren()) do
            if child:IsA("GuiObject") and child.Name ~= "PanelLayout" then
                child:Destroy()
            end
        end
        PanelScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    end

    -- Function to load module
    local function loadModule(moduleName, moduleFunction)
        if not moduleFunction then return end
        
        -- Unload current module
        if ActiveModule then
            local oldButton = SidebarButtons:FindFirstChild(ActiveModule .. "Button")
            if oldButton then
                oldButton.Highlight.Visible = false
                TweenService:Create(oldButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 55)
                }):Play()
            end
        end
        
        -- Set active module
        ActiveModule = moduleName
        
        -- Update button highlight
        local button = SidebarButtons:FindFirstChild(moduleName .. "Button")
        if button then
            button.Highlight.Visible = true
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 75)
            }):Play()
        end
        
        -- Clear panel
        clearPanel()
        
        -- Load module content
        moduleFunction()
        
        -- Auto resize panel
        PanelScroll.CanvasSize = UDim2.new(0, 0, 0, PanelLayout.AbsoluteContentSize.Y + 20)
    end

    -- Function to add module
    local function addModule(name, icon, func)
        Modules[name] = func
        
        local button = createSidebarButton(name, icon)
        button.Parent = SidebarButtons
        
        button.MouseButton1Click:Connect(function()
            loadModule(name, func)
        end)
        
        -- Update scroll size
        SidebarButtons.CanvasSize = UDim2.new(0, 0, 0, ButtonsLayout.AbsoluteContentSize.Y + 20)
        
        return button
    end

    -- Function untuk load module dari URL
    local function loadModuleFromURL(url)
        local success, result = pcall(function()
            return loadstring(game:HttpGet(url))()
        end)
        
        if not success then
            -- Tampilkan error di panel
            clearPanel()
            
            local ErrorLabel = Instance.new("TextLabel")
            ErrorLabel.Name = "ErrorLabel"
            ErrorLabel.Size = UDim2.new(1, -20, 0, 100)
            ErrorLabel.Position = UDim2.new(0, 10, 0, 10)
            ErrorLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            ErrorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            ErrorLabel.TextSize = 14
            ErrorLabel.Font = Enum.Font.Gotham
            ErrorLabel.TextXAlignment = Enum.TextXAlignment.Left
            ErrorLabel.TextYAlignment = Enum.TextYAlignment.Top
            ErrorLabel.TextWrapped = true
            ErrorLabel.Text = "Failed to load module:\n" .. tostring(result)
            
            local ErrorCorner = Instance.new("UICorner")
            ErrorCorner.CornerRadius = UDim.new(0, 8)
            ErrorCorner.Parent = ErrorLabel
            
            ErrorLabel.Parent = PanelScroll
            PanelScroll.CanvasSize = UDim2.new(0, 0, 0, 120)
        end
        
        return success
    end

    -- Initialize Modules
    local function initializeModules()
        -- Auto Obby Module
        addModule("Auto Obby", "rbxassetid://10734975645", function()
            clearPanel()
            
            -- Tampilkan loading
            local LoadingLabel = Instance.new("TextLabel")
            LoadingLabel.Name = "LoadingLabel"
            LoadingLabel.Size = UDim2.new(1, -20, 0, 50)
            LoadingLabel.Position = UDim2.new(0, 10, 0, 10)
            LoadingLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            LoadingLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
            LoadingLabel.TextSize = 16
            LoadingLabel.Font = Enum.Font.Gotham
            LoadingLabel.Text = "Loading Auto Obby Module..."
            LoadingLabel.TextXAlignment = Enum.TextXAlignment.Center
            
            local LoadingCorner = Instance.new("UICorner")
            LoadingCorner.CornerRadius = UDim.new(0, 8)
            LoadingCorner.Parent = LoadingLabel
            
            LoadingLabel.Parent = PanelScroll
            
            -- Load module (gunakan URL GitHub Anda)
            local success = loadModuleFromURL("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/obby.lua")
            
            if not success then
                -- Fallback ke inline module
                local ModuleContent = Instance.new("TextLabel")
                ModuleContent.Name = "ModuleContent"
                ModuleContent.Size = UDim2.new(1, -20, 0, 200)
                ModuleContent.Position = UDim2.new(0, 10, 0, 70)
                ModuleContent.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                ModuleContent.TextColor3 = Color3.fromRGB(0, 170, 255)
                ModuleContent.TextSize = 20
                ModuleContent.Font = Enum.Font.GothamBold
                ModuleContent.Text = "AUTO OBBY MODULE"
                ModuleContent.TextXAlignment = Enum.TextXAlignment.Center
                
                local ContentCorner = Instance.new("UICorner")
                ContentCorner.CornerRadius = UDim.new(0, 8)
                ContentCorner.Parent = ModuleContent
                
                ModuleContent.Parent = PanelScroll
                PanelScroll.CanvasSize = UDim2.new(0, 0, 0, 280)
            end
        end)
        
        -- Checkpoint Module
        addModule("Checkpoints", "rbxassetid://10734973111", function()
            clearPanel()
            local LoadingLabel = Instance.new("TextLabel")
            LoadingLabel.Name = "LoadingLabel"
            LoadingLabel.Size = UDim2.new(1, -20, 0, 50)
            LoadingLabel.Position = UDim2.new(0, 10, 0, 10)
            LoadingLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            LoadingLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
            LoadingLabel.TextSize = 16
            LoadingLabel.Font = Enum.Font.Gotham
            LoadingLabel.Text = "Loading Checkpoints Module..."
            LoadingLabel.TextXAlignment = Enum.TextXAlignment.Center
            
            local LoadingCorner = Instance.new("UICorner")
            LoadingCorner.CornerRadius = UDim.new(0, 8)
            LoadingCorner.Parent = LoadingLabel
            
            LoadingLabel.Parent = PanelScroll
            
            loadModuleFromURL("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/cekpoint.lua")
        end)
        
        -- Teleport Players Module
        addModule("Teleport Players", "rbxassetid://10734968922", function()
            clearPanel()
            local LoadingLabel = Instance.new("TextLabel")
            LoadingLabel.Name = "LoadingLabel"
            LoadingLabel.Size = UDim2.new(1, -20, 0, 50)
            LoadingLabel.Position = UDim2.new(0, 10, 0, 10)
            LoadingLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            LoadingLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
            LoadingLabel.TextSize = 16
            LoadingLabel.Font = Enum.Font.Gotham
            LoadingLabel.Text = "Loading Teleport Module..."
            LoadingLabel.TextXAlignment = Enum.TextXAlignment.Center
            
            local LoadingCorner = Instance.new("UICorner")
            LoadingCorner.CornerRadius = UDim.new(0, 8)
            LoadingCorner.Parent = LoadingLabel
            
            LoadingLabel.Parent = PanelScroll
            
            loadModuleFromURL("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/teleportplayers.lua")
        end)
        
        -- Fly Module
        addModule("Fly System", "rbxassetid://10734967234", function()
            clearPanel()
            local LoadingLabel = Instance.new("TextLabel")
            LoadingLabel.Name = "LoadingLabel"
            LoadingLabel.Size = UDim2.new(1, -20, 0, 50)
            LoadingLabel.Position = UDim2.new(0, 10, 0, 10)
            LoadingLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            LoadingLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
            LoadingLabel.TextSize = 16
            LoadingLabel.Font = Enum.Font.Gotham
            LoadingLabel.Text = "Loading Fly Module..."
            LoadingLabel.TextXAlignment = Enum.TextXAlignment.Center
            
            local LoadingCorner = Instance.new("UICorner")
            LoadingCorner.CornerRadius = UDim.new(0, 8)
            LoadingCorner.Parent = LoadingLabel
            
            LoadingLabel.Parent = PanelScroll
            
            loadModuleFromURL("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/fly.lua")
        end)
    end

    -- Make UI draggable
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        MainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainContainer.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input == dragInput) then
            update(input)
        end
    end)

    -- Mobile optimizations
    if UserInputService.TouchEnabled then
        MainContainer.Size = UDim2.new(0, 500, 0, 350)
        MainContainer.Position = UDim2.new(0.5, -250, 0.5, -175)
        
        -- Make buttons larger for touch
        for _, child in ipairs(SidebarButtons:GetChildren()) do
            if child:IsA("TextButton") then
                child.Size = UDim2.new(1, -5, 0, 55)
            end
        end
    end

    -- Initialize
    initializeModules()
    
    -- Auto load first module
    wait(0.1)
    local firstButton = SidebarButtons:FindFirstChild("Auto ObbyButton")
    if firstButton then
        firstButton:Fire("MouseButton1Click")
    end

    -- Parent UI terakhir
    MainContainer.Parent = ScreenGui
    ScreenGui.Parent = PlayerGui
    
    -- Fade in effect
    MainContainer.Visible = true
    MainContainer.BackgroundTransparency = 1
    TweenService:Create(MainContainer, TweenInfo.new(0.5), {
        BackgroundTransparency = 0
    }):Play()

    print("[Delta Executor] UI Loaded Successfully!")
    
    return ScreenGui
end

-- Coba buat UI
local success, err = pcall(createMainUI)
if not success then
    warn("[Delta Executor] Error creating UI: " .. tostring(err))
    
    -- Fallback: Simple notification
    local notification = Instance.new("ScreenGui", PlayerGui)
    notification.Name = "DeltaNotification"
    
    local frame = Instance.new("Frame", notification)
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0.5, -50)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 12)
    
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "DELTA EXECUTOR"
    title.TextColor3 = Color3.fromRGB(0, 170, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    
    local msg = Instance.new("TextLabel", frame)
    msg.Size = UDim2.new(1, -20, 0, 40)
    msg.Position = UDim2.new(0, 10, 0, 50)
    msg.BackgroundTransparency = 1
    msg.Text = "UI Loaded with basic mode"
    msg.TextColor3 = Color3.fromRGB(200, 200, 220)
    msg.TextSize = 14
    msg.Font = Enum.Font.Gotham
    
    wait(3)
    notification:Destroy()
end