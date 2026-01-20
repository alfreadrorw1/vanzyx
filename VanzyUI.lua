local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

function Library:CreateWindow(title_text, sub_text)
    local UI = {}
    
    -- SCREEN GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VanzyV5_Fixed"
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = CoreGui

    -- MAIN FRAME (380x190)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 380, 0, 190)
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -95)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    -- BACKGROUND IMAGE
    local BG = Instance.new("ImageLabel")
    BG.Size = UDim2.new(1,0,1,0)
    BG.Image = "https://files.catbox.moe/8cvl4c.jpg"
    BG.ImageTransparency = 0.85
    BG.BackgroundTransparency = 1
    BG.ScaleType = Enum.ScaleType.Crop
    BG.Parent = MainFrame

    -- SIDEBAR
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 110, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    Sidebar.Parent = MainFrame
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0,5)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Parent = Sidebar
    
    -- PADDING ATAS SIDEBAR
    local Pad = Instance.new("Frame")
    Pad.Size = UDim2.new(1,0,0,10)
    Pad.BackgroundTransparency = 1
    Pad.Parent = Sidebar

    -- CONTENT CONTAINER
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -110, 1, 0)
    ContentContainer.Position = UDim2.new(0, 110, 0, 0)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    local Pages = {} -- Menyimpan referensi halaman

    -- DRAGGABLE LOGIC (MOBILE FIX)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)

    -- OPEN BUTTON (LOGO V)
    local OpenBtn = Instance.new("ImageButton")
    OpenBtn.Size = UDim2.new(0, 50, 0, 50)
    OpenBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
    OpenBtn.Image = "https://files.catbox.moe/8cvl4c.jpg"
    OpenBtn.Visible = false
    OpenBtn.Parent = ScreenGui
    local OpenCorner = Instance.new("UICorner"); OpenCorner.CornerRadius = UDim.new(1,0); OpenCorner.Parent = OpenBtn
    
    OpenBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        OpenBtn.Visible = false
    end)

    -- FUNGSI TAB
    function UI:Tab(name)
        -- Button di Sidebar
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0.9, 0, 0, 30)
        TabBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.new(1,1,1)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 12
        TabBtn.Parent = Sidebar
        
        local TabCorner = Instance.new("UICorner"); TabCorner.CornerRadius = UDim.new(0,6); TabCorner.Parent = TabBtn
        
        -- Halaman Konten
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, -10, 1, -10)
        Page.Position = UDim2.new(0, 5, 0, 5)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.Visible = false -- Default hidden
        Page.Parent = ContentContainer
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 5)
        PageLayout.Parent = Page

        -- Switch Logic
        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            Page.Visible = true
            
            -- Animasi Button
            for _, btn in pairs(Sidebar:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play()
                end
            end
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
        end)
        
        table.insert(Pages, Page)
        if #Pages == 1 then Page.Visible = true end -- Show first tab default

        local Elements = {}

        function Elements:Button(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
            Btn.Text = text
            Btn.TextColor3 = Color3.new(1,1,1)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 12
            Btn.Parent = Page
            local c = Instance.new("UICorner"); c.Parent = Btn
            
            Btn.MouseButton1Click:Connect(function()
                pcall(callback)
                Btn.Text = "Success!"
                wait(0.5)
                Btn.Text = text
            end)
        end

        function Elements:Toggle(text, callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 35)
            Frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
            Frame.Parent = Page
            local c = Instance.new("UICorner"); c.Parent = Frame
            
            local Label = Instance.new("TextLabel")
            Label.Text = text
            Label.Size = UDim2.new(0.7,0,1,0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.new(1,1,1)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 12
            Label.Position = UDim2.new(0.05,0,0,0)
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local TglBtn = Instance.new("TextButton")
            TglBtn.Size = UDim2.new(0, 40, 0, 20)
            TglBtn.Position = UDim2.new(0.8, 0, 0.2, 0)
            TglBtn.Text = ""
            TglBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
            TglBtn.Parent = Frame
            local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(1,0); tc.Parent = TglBtn
            
            local state = false
            TglBtn.MouseButton1Click:Connect(function()
                state = not state
                if state then
                    TweenService:Create(TglBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 255, 100)}):Play()
                else
                    TweenService:Create(TglBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
                end
                pcall(callback, state)
            end)
        end
        
        return Elements
    end

    -- MINI MENU FLY SPEED (Floating)
    local Mini = Instance.new("Frame")
    Mini.Size = UDim2.new(0,100,0,40)
    Mini.Position = UDim2.new(0.8,0,0.3,0)
    Mini.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Mini.Parent = ScreenGui
    local mc = Instance.new("UICorner"); mc.Parent = Mini
    
    local v1 = Instance.new("TextButton")
    v1.Size = UDim2.new(0.45,0,0.8,0)
    v1.Position = UDim2.new(0.05,0,0.1,0)
    v1.Text = "v1"
    v1.BackgroundColor3 = Color3.fromRGB(50,50,50)
    v1.TextColor3 = Color3.new(1,1,1)
    v1.Parent = Mini
    local vc1 = Instance.new("UICorner"); vc1.Parent = v1

    local v2 = Instance.new("TextButton")
    v2.Size = UDim2.new(0.45,0,0.8,0)
    v2.Position = UDim2.new(0.5,0,0.1,0)
    v2.Text = "v2"
    v2.BackgroundColor3 = Color3.fromRGB(50,50,50)
    v2.TextColor3 = Color3.new(1,1,1)
    v2.Parent = Mini
    local vc2 = Instance.new("UICorner"); vc2.Parent = v2

    -- CLOSE LOGIC
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Text = "X"
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(0, 10, 1, -40)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    CloseBtn.Parent = Sidebar
    local cc = Instance.new("UICorner"); cc.Parent = CloseBtn
    
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        OpenBtn.Visible = true
    end)
    
    UI.FlySpeedRef = {v1, v2}
    return UI
end

return Library
