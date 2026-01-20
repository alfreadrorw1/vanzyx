--[[
    PROJECT: VANZYXXX V17 ICONIC ANIMATED
    STATUS: ANIMATION + ICONS + STYLING + ALL FEATURES
    PLATFORM: MOBILE ONLY (Android/iOS)
    DEV: Gemini AI
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService") -- Service Animasi
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local MarketplaceService = game:GetService("MarketplaceService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--------------------------------------------------------------------------------
-- [GLOBAL CONFIG]
--------------------------------------------------------------------------------
local Config = {
    FlySpeed = 50,
    Flying = false,
    Noclip = false,
    InfJump = false,
    AutoJump = false,
    WallClimb = false,
    SpinBot = false,
    
    AirJump = false,
    AntiVoid = false,
    AntiSlip = false,
    LastGroundPos = nil,
    
    ESP_Name = false,
    ESP_Chams = false,
    FullBright = false,
    GlowStick = false,
    XRay = false
}

local UIRefs = {
    MainFrame = nil,
    MainStroke = nil, -- Untuk ganti warna pinggir
    TitleLabel = nil,
    OpenBtnImage = nil
}

local function GetGuiParent()
    if gethui then return gethui() end
    if syn and syn.protect_gui then 
        local sg = Instance.new("ScreenGui"); syn.protect_gui(sg); sg.Parent = CoreGui; return sg
    end
    return CoreGui
end

--------------------------------------------------------------------------------
-- [UI ENGINE: ANIMATED 380x190]
--------------------------------------------------------------------------------
local Library = {}
local FlyWidgetFrame = nil

function Library:Create()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VanzyV17_Iconic"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = GetGuiParent()

    -- 1. OPEN BUTTON
    local OpenBtn = Instance.new("ImageButton")
    OpenBtn.Name = "OpenButton"
    OpenBtn.Size = UDim2.new(0, 50, 0, 50)
    OpenBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    OpenBtn.BackgroundTransparency = 0.2
    OpenBtn.Image = "rbxassetid://0" 
    OpenBtn.Parent = ScreenGui
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(140, 0, 255); OpenBtn.UIStroke.Thickness = 2
    UIRefs.OpenBtnImage = OpenBtn
    
    local OpenText = Instance.new("TextLabel", OpenBtn); OpenText.Text="V"; OpenText.Size=UDim2.new(1,0,1,0); OpenText.BackgroundTransparency=1; OpenText.TextColor3=Color3.new(1,1,1); OpenText.Font=Enum.Font.GothamBlack; OpenText.TextSize=28; OpenText.ZIndex=0

    -- 2. MAIN FRAME (Starting Hidden/Small for Animation)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Start Small
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- Center Anchor
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- DEFAULT DARK
    MainFrame.ClipsDescendants = true
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui
    UIRefs.MainFrame = MainFrame
    
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    
    -- STROKE (BORDER) - INI YANG AKAN BERUBAH WARNA
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(140, 0, 255) -- Default Purple
    MainStroke.Thickness = 2
    UIRefs.MainStroke = MainStroke

    -- TITLE (RAINBOW CENTER)
    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Text = "VANZY V17 ULTIMATE"
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 14
    Title.TextColor3 = Color3.new(1,1,1)
    UIRefs.TitleLabel = Title
    spawn(function()
        local t = 0; while true do t=t+0.01; if t>1 then t=0 end; Title.TextColor3=Color3.fromHSV(t,1,1); wait(0.05) end
    end)

    -- CLOSE BUTTON (TOP RIGHT X)
    local CloseBtn = Instance.new("TextButton", MainFrame)
    CloseBtn.Size = UDim2.new(0, 25, 0, 25)
    CloseBtn.Position = UDim2.new(1, -5, 0, 5)
    CloseBtn.AnchorPoint = Vector2.new(1, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.Font = Enum.Font.GothamBlack
    CloseBtn.TextSize = 16

    -- SIDEBAR
    local Sidebar = Instance.new("ScrollingFrame", MainFrame)
    Sidebar.Size = UDim2.new(0, 110, 1, -30)
    Sidebar.Position = UDim2.new(0, 0, 0, 30)
    Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Sidebar.ScrollBarThickness = 0
    Sidebar.BorderSizePixel = 0
    local SideLayout = Instance.new("UIListLayout", Sidebar); SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; SideLayout.Padding = UDim.new(0, 5)
    Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 5)

    -- CONTENT
    local Content = Instance.new("Frame", MainFrame)
    Content.Size = UDim2.new(1, -110, 1, -30)
    Content.Position = UDim2.new(0, 110, 0, 30)
    Content.BackgroundTransparency = 1
    local ContentPad = Instance.new("UIPadding", Content); ContentPad.PaddingTop=UDim.new(0,5); ContentPad.PaddingLeft=UDim.new(0,5); ContentPad.PaddingRight=UDim.new(0,5)

    -- ANIMATION LOGIC
    local function ToggleUI(state)
        if state then
            MainFrame.Visible = true
            OpenBtn.Visible = false
            -- Pop Up Animation
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 380, 0, 190)}):Play()
        else
            -- Shrink Animation
            local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
            closeTween:Play()
            closeTween.Completed:Connect(function()
                MainFrame.Visible = false
                OpenBtn.Visible = true
            end)
        end
    end

    -- DRAG LOGIC
    local function MakeDraggable(frame)
        local dragging, dragInput, dragStart, startPos
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = frame.Position
                input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
            end
        end)
        frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
        end)
        UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart; frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    end
    MakeDraggable(MainFrame)
    MakeDraggable(OpenBtn)

    OpenBtn.MouseButton1Click:Connect(function() ToggleUI(true) end)
    CloseBtn.MouseButton1Click:Connect(function() ToggleUI(false) end)

    -- FLY WIDGET
    local FlyWidget = Instance.new("Frame"); FlyWidget.Size = UDim2.new(0, 120, 0, 40); FlyWidget.Position = UDim2.new(0.5, -60, 0.15, 0); FlyWidget.BackgroundColor3 = Color3.fromRGB(25, 25, 25); FlyWidget.Visible = false; FlyWidget.Parent = ScreenGui; Instance.new("UICorner", FlyWidget).CornerRadius=UDim.new(0,6); Instance.new("UIStroke", FlyWidget).Color=Color3.fromRGB(140,0,255)
    MakeDraggable(FlyWidget)
    local SL = Instance.new("TextLabel", FlyWidget); SL.Size=UDim2.new(1,0,0.4,0); SL.BackgroundTransparency=1; SL.Text="SPEED: "..Config.FlySpeed; SL.TextColor3=Color3.new(1,1,1); SL.Font=Enum.Font.GothamBold; SL.TextSize=10
    local B1 = Instance.new("TextButton", FlyWidget); B1.Size=UDim2.new(0.4,0,0.5,0); B1.Position=UDim2.new(0.05,0,0.45,0); B1.BackgroundColor3=Color3.fromRGB(50,50,50); B1.Text="-"; B1.TextColor3=Color3.new(1,1,1); Instance.new("UICorner", B1)
    local B2 = Instance.new("TextButton", FlyWidget); B2.Size=UDim2.new(0.4,0,0.5,0); B2.Position=UDim2.new(0.55,0,0.45,0); B2.BackgroundColor3=Color3.fromRGB(50,50,50); B2.Text="+"; B2.TextColor3=Color3.new(1,1,1); Instance.new("UICorner", B2)
    B1.MouseButton1Click:Connect(function() Config.FlySpeed=math.max(10,Config.FlySpeed-50); SL.Text="SPEED: "..Config.FlySpeed end)
    B2.MouseButton1Click:Connect(function() Config.FlySpeed=Config.FlySpeed+50; SL.Text="SPEED: "..Config.FlySpeed end)
    FlyWidgetFrame = FlyWidget

    -- TAB SYSTEM (WITH ICONS)
    local Tabs = {}
    local FirstTab = true

    function Library:Tab(name, iconId)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0.9, 0, 0, 28)
        TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabBtn.Text = "    "..name -- Spasi untuk icon
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 10
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.Parent = Sidebar
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        
        -- ICON
        if iconId then
            local Icon = Instance.new("ImageLabel", TabBtn)
            Icon.Size = UDim2.new(0, 16, 0, 16)
            Icon.Position = UDim2.new(0, 5, 0.5, -8)
            Icon.BackgroundTransparency = 1
            Icon.Image = iconId
        end

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, -5, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.Visible = false
        Page.Parent = Content
        local PL = Instance.new("UIListLayout"); PL.Padding = UDim.new(0, 4); PL.Parent = Page

        TabBtn.MouseButton1Click:Connect(function() 
            for _, p in pairs(Tabs) do 
                p.Page.Visible=false
                TweenService:Create(p.Btn, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(40,40,40)}):Play()
                p.Btn.TextColor3=Color3.fromRGB(200,200,200) 
            end
            Page.Visible=true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(140, 0, 255)}):Play()
            TabBtn.TextColor3=Color3.new(1,1,1) 
        end)

        if FirstTab then Page.Visible=true; TabBtn.BackgroundColor3=Color3.fromRGB(140, 0, 255); TabBtn.TextColor3=Color3.new(1,1,1); FirstTab=false end
        table.insert(Tabs, {Page = Page, Btn = TabBtn})

        local Elm = {}
        function Elm:Button(text, col, callback)
            local Btn = Instance.new("TextButton"); Btn.Size = UDim2.new(1, 0, 0, 25); Btn.BackgroundColor3 = col or Color3.fromRGB(50, 50, 50); Btn.Text = text; Btn.TextColor3 = Color3.new(1,1,1); Btn.Font = Enum.Font.Gotham; Btn.TextSize = 10; Btn.Parent = Page; Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,6)
            Btn.MouseButton1Click:Connect(function() pcall(callback) end)
        end
        function Elm:Toggle(text, callback)
             local Frame = Instance.new("Frame"); Frame.Size = UDim2.new(1, 0, 0, 25); Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50); Frame.Parent = Page; Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,6)
            local Label = Instance.new("TextLabel"); Label.Size = UDim2.new(0.7, 0, 1, 0); Label.Position = UDim2.new(0.05, 0, 0, 0); Label.BackgroundTransparency = 1; Label.Text = text; Label.TextColor3 = Color3.new(1,1,1); Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Font = Enum.Font.Gotham; Label.TextSize = 10; Label.Parent = Frame
            local Tgl = Instance.new("TextButton"); Tgl.Size = UDim2.new(0, 35, 0, 18); Tgl.Position = UDim2.new(0.8, 0, 0.15, 0); Tgl.BackgroundColor3 = Color3.fromRGB(80, 80, 80); Tgl.Text = ""; Tgl.Parent = Frame; Instance.new("UICorner", Tgl).CornerRadius = UDim.new(1,0)
            local state = false
            Tgl.MouseButton1Click:Connect(function() state = not state; TweenService:Create(Tgl, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(80, 80, 80)}):Play(); callback(state) end)
        end
        function Elm:Input(placeholder, callback)
            local Frame = Instance.new("Frame"); Frame.Size = UDim2.new(1, 0, 0, 25); Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Frame.Parent = Page; Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,6)
            local Box = Instance.new("TextBox"); Box.Size = UDim2.new(0.9, 0, 1, 0); Box.Position = UDim2.new(0.05, 0, 0, 0); Box.BackgroundTransparency = 1; Box.Text = ""; Box.PlaceholderText = placeholder; Box.TextColor3 = Color3.new(1,1,1); Box.Font = Enum.Font.Gotham; Box.TextSize = 10; Box.Parent = Frame
            Box:GetPropertyChangedSignal("Text"):Connect(function() callback(Box.Text) end)
        end
        function Elm:Label(text)
            local Lab = Instance.new("TextLabel"); Lab.Size = UDim2.new(1,0,0,18); Lab.BackgroundTransparency = 1; Lab.Text = text; Lab.TextColor3 = Color3.fromRGB(140, 0, 255); Lab.Font = Enum.Font.GothamBold; Lab.TextSize = 9; Lab.TextXAlignment = Enum.TextXAlignment.Left; Lab.Parent = Page
        end
        function Elm:Container(h)
            local C = Instance.new("ScrollingFrame"); C.Size = UDim2.new(1, 0, 0, h or 60); C.BackgroundColor3 = Color3.fromRGB(30,30,30); C.ScrollBarThickness = 2; C.Parent = Page; Instance.new("UICorner", C).CornerRadius=UDim.new(0,6)
            local Layout = Instance.new("UIListLayout"); Layout.Padding = UDim.new(0,2); Layout.Parent = C
            return C
        end
        function Elm:ColorPicker()
            local C = Instance.new("Frame", Page); C.Size=UDim2.new(1,0,0,30); C.BackgroundTransparency=1
            local Layout = Instance.new("UIListLayout", C); Layout.FillDirection=Enum.FillDirection.Horizontal; Layout.Padding=UDim.new(0,5)
            local Colors = {
                {Color3.fromRGB(140,0,255), "Purple"}, {Color3.fromRGB(255,50,50), "Red"}, {Color3.fromRGB(0,150,255), "Blue"},
                {Color3.fromRGB(50,255,50), "Green"}, {Color3.fromRGB(255,150,0), "Orange"}, {Color3.fromRGB(255,255,255), "White"}
            }
            for _, col in pairs(Colors) do
                local B = Instance.new("TextButton", C); B.Size=UDim2.new(0,20,0,20); B.BackgroundColor3=col[1]; B.Text=""; Instance.new("UICorner", B).CornerRadius=UDim.new(1,0)
                B.MouseButton1Click:Connect(function() 
                    UIRefs.MainStroke.Color = col[1] -- Ganti Warna Border
                    if UIRefs.OpenBtnImage then UIRefs.OpenBtnImage.UIStroke.Color = col[1] end
                end)
            end
        end
        return Elm
    end
    return Library
end

--------------------------------------------------------------------------------
-- [FEATURES]
--------------------------------------------------------------------------------
local UI = Library:Create()

-- >>> 1. ABOUT (REDESIGNED) <<<
local AboutTab = UI:Tab("About", "rbxassetid://7072715938") -- Home Icon

local ProfileCard = Instance.new("Frame"); ProfileCard.Size=UDim2.new(1,0,0,80); ProfileCard.BackgroundColor3=Color3.fromRGB(35,35,35); Instance.new("UICorner",ProfileCard).CornerRadius=UDim.new(0,8); ProfileCard.Parent=AboutTab.Container(85)
-- Gradient
local Grad = Instance.new("UIGradient", ProfileCard); Grad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(40,40,40)), ColorSequenceKeypoint.new(1, Color3.fromRGB(20,20,20))}; Grad.Rotation=45

local ProfImg = Instance.new("ImageLabel", ProfileCard); ProfImg.Size=UDim2.new(0,50,0,50); ProfImg.Position=UDim2.new(0.05,0,0.18,0); ProfImg.BackgroundColor3=Color3.fromRGB(50,50,50); Instance.new("UICorner",ProfImg).CornerRadius=UDim.new(1,0)
spawn(function() pcall(function() ProfImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end) end)

local DispName = Instance.new("TextLabel", ProfileCard); DispName.Text=LocalPlayer.DisplayName; DispName.Size=UDim2.new(0.6,0,0.3,0); DispName.Position=UDim2.new(0.25,0,0.2,0); DispName.TextColor3=Color3.new(1,1,1); DispName.Font=Enum.Font.GothamBlack; DispName.TextXAlignment=Enum.TextXAlignment.Left; DispName.BackgroundTransparency=1; DispName.TextSize=14
local RealName = Instance.new("TextLabel", ProfileCard); RealName.Text="@"..LocalPlayer.Name; RealName.Size=UDim2.new(0.6,0,0.3,0); RealName.Position=UDim2.new(0.25,0,0.5,0); RealName.TextColor3=Color3.fromRGB(180,180,180); RealName.Font=Enum.Font.Gotham; RealName.TextXAlignment=Enum.TextXAlignment.Left; RealName.BackgroundTransparency=1; RealName.TextSize=10

-- Stats Grid
local StatGrid = AboutTab:Container(50); local GL = StatGrid:FindFirstChildWhichIsA("UIListLayout"); if GL then GL:Destroy() end
local GridL = Instance.new("UIGridLayout", StatGrid); GridL.CellSize=UDim2.new(0.3,0,0.8,0); GridL.CellPadding=UDim2.new(0.02,0,0,0)
local function AddStat(t, v) local F=Instance.new("Frame",StatGrid);F.BackgroundColor3=Color3.fromRGB(50,50,50);Instance.new("UICorner",F).CornerRadius=UDim.new(0,4);local L=Instance.new("TextLabel",F);L.Size=UDim2.new(1,0,0.4,0);L.Text=t;L.TextColor3=Color3.fromRGB(150,150,150);L.BackgroundTransparency=1;L.TextSize=8;local V=Instance.new("TextLabel",F);V.Size=UDim2.new(1,0,0.6,0);V.Position=UDim2.new(0,0,0.4,0);V.Text=v;V.TextColor3=Color3.fromRGB(140,0,255);V.BackgroundTransparency=1;V.TextSize=10;V.Font=Enum.Font.GothamBold end
AddStat("ID", game.PlaceId); AddStat("AGE", LocalPlayer.AccountAge); AddStat("PING", "..."); 
spawn(function() while true do wait(1) local p = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString(); StatGrid:GetChildren()[3].TextLabel.Text = math.floor(p:split(" ")[1]).."ms" end end)

-- >>> 2. AUTO CP <<<
local CPTab = UI:Tab("Auto CP", "rbxassetid://7072717950") -- Map Icon
local CPContainer = nil
local function ScanMap()
    if not CPContainer then return end
    for _,v in pairs(CPContainer:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    local raw = {}
    for _,v in pairs(Workspace:GetDescendants()) do if v:IsA("SpawnLocation") or (v:IsA("BasePart") and (v.Name:lower():find("checkpoint") or v.Name:lower():find("stage") or v.Name:lower():find("spawn"))) then table.insert(raw, v) end end
    table.sort(raw, function(a,b) return (tonumber(a.Name:match("%d+")) or 0) < (tonumber(b.Name:match("%d+")) or 0) end)
    if #raw>0 then 
        StarterGui:SetCore("SendNotification",{Title="Scan", Text="Found "..#raw}) 
        for _,p in pairs(raw) do 
            local b=Instance.new("TextButton",CPContainer);b.Size=UDim2.new(1,0,0,25);b.BackgroundColor3=Color3.fromRGB(50,50,50);b.Text=p.Name;b.TextColor3=Color3.new(1,1,1);Instance.new("UICorner",b).CornerRadius=UDim.new(0,4)
            b.MouseButton1Click:Connect(function() LocalPlayer.Character:MoveTo(p.Position+Vector3.new(0,3,0)) end)
        end
    else StarterGui:SetCore("SendNotification",{Title="Scan", Text="No Checkpoints"}) end
end
CPTab:Button("SCAN MAP NOW", Color3.fromRGB(0,150,255), ScanMap)
CPContainer = CPTab:Container(120)

-- >>> 3. MOVEMENT <<<
local MovTab = UI:Tab("Movement", "rbxassetid://7072717894") -- Run Icon
MovTab:Toggle("Fly (+Widget)", function(s) Config.Flying=s; FlyWidgetFrame.Visible=s; if s then spawn(function() local bg=Instance.new("BodyGyro",LocalPlayer.Character.HumanoidRootPart);bg.P=9e4;local bv=Instance.new("BodyVelocity",LocalPlayer.Character.HumanoidRootPart);bv.MaxForce=Vector3.new(9e9,9e9,9e9);while Config.Flying and LocalPlayer.Character do LocalPlayer.Character.Humanoid.PlatformStand=true;bg.CFrame=Camera.CFrame;bv.Velocity=LocalPlayer.Character.Humanoid.MoveDirection.Magnitude>0 and Camera.CFrame.LookVector*Config.FlySpeed or Vector3.zero;RunService.RenderStepped:Wait() end;LocalPlayer.Character.Humanoid.PlatformStand=false;bg:Destroy();bv:Destroy() end) end end)
MovTab:Toggle("Noclip", function(s) Config.Noclip=s; RunService.Stepped:Connect(function() if Config.Noclip and LocalPlayer.Character then for _,v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end end end) end)
MovTab:Toggle("Infinite Jump", function(s) Config.InfJump=s; UserInputService.JumpRequest:Connect(function() if Config.InfJump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end) end)
MovTab:Toggle("Spider / Climb", function(s) Config.WallClimb=s; if s then local b=Instance.new("BodyVelocity",LocalPlayer.Character.HumanoidRootPart);b.MaxForce=Vector3.zero;RunService.RenderStepped:Connect(function() if Config.WallClimb then local r=Ray.new(LocalPlayer.Character.HumanoidRootPart.Position,LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector*2);if workspace:FindPartOnRay(r,LocalPlayer.Character) then b.MaxForce=Vector3.new(0,9e9,0);b.Velocity=Vector3.new(0,20,0) else b.MaxForce=Vector3.zero end else b:Destroy() end end) end end)

-- >>> 4. OBBY <<<
local ObbyTab = UI:Tab("Obby", "rbxassetid://7072720623") -- Ladder Icon
ObbyTab:Toggle("Anti Void", function(s) Config.AntiVoid=s; if s then spawn(function() while Config.AntiVoid do local c=LocalPlayer.Character; if c and c:FindFirstChild("HumanoidRootPart") then local r=Ray.new(c.HumanoidRootPart.Position,Vector3.new(0,-10,0)); if workspace:FindPartOnRay(r,c) then Config.LastGroundPos=c.HumanoidRootPart.CFrame elseif c.HumanoidRootPart.Position.Y<-50 and Config.LastGroundPos then c.HumanoidRootPart.CFrame=Config.LastGroundPos+Vector3.new(0,5,0);c.HumanoidRootPart.Velocity=Vector3.zero end end; wait(0.1) end end) end end)
ObbyTab:Toggle("Air Jump", function(s) Config.AirJump=s; UserInputService.JumpRequest:Connect(function() if Config.AirJump and LocalPlayer.Character then LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end) end)
ObbyTab:Toggle("Anti Slip", function(s) Config.AntiSlip=s; spawn(function() while Config.AntiSlip do if LocalPlayer.Character.Humanoid then LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false);LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false) end;wait(1) end end) end)

-- >>> 5. VISUALS <<<
local VisTab = UI:Tab("Visuals", "rbxassetid://7072717531") -- Eye Icon
VisTab:Toggle("ESP Name", function(s) Config.ESP_Name=s end)
VisTab:Toggle("ESP Chams", function(s) Config.ESP_Chams=s end)
VisTab:Toggle("Full Bright", function(s) Lighting.Brightness=s and 2 or 1; Lighting.GlobalShadows=not s end)
local function ESP(p) if p==LocalPlayer then return end; RunService.RenderStepped:Connect(function() if not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then return end
    if Config.ESP_Chams then if not p.Character:FindFirstChild("H") then Instance.new("Highlight",p.Character).Name="H" end else if p.Character:FindFirstChild("H") then p.Character.H:Destroy() end end
    if Config.ESP_Name then if not p.Character.HumanoidRootPart:FindFirstChild("B") then local b=Instance.new("BillboardGui",p.Character.HumanoidRootPart);b.Name="B";b.Size=UDim2.new(4,0,1,0);b.AlwaysOnTop=true;local t=Instance.new("TextLabel",b);t.Size=UDim2.new(1,0,1,0);t.BackgroundTransparency=1;t.TextColor3=Color3.new(1,1,1);t.TextStrokeTransparency=0;t.Text=p.Name;t.Parent=b end else if p.Character.HumanoidRootPart:FindFirstChild("B") then p.Character.HumanoidRootPart.B:Destroy() end end
end) end
for _,p in pairs(Players:GetPlayers()) do ESP(p) end; Players.PlayerAdded:Connect(ESP)

-- >>> 6. TOOLS <<<
local ToolTab = UI:Tab("Tools", "rbxassetid://7072721682") -- Setting/Tool Icon
ToolTab:Button("Get Tap TP", Color3.fromRGB(0, 180, 0), function()
    local tool = Instance.new("Tool"); tool.Name="Tap Teleport"; tool.RequiresHandle=false; tool.Parent=LocalPlayer.Backpack
    tool.Activated:Connect(function() local mouse=LocalPlayer:GetMouse(); if mouse.Hit then LocalPlayer.Character:MoveTo(mouse.Hit.Position) end end)
    StarterGui:SetCore("SendNotification", {Title="Item Added", Text="Check Backpack!"})
end)
ToolTab:Button("Server Hop", nil, function() local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data; TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1,#servers)].id) end)

-- >>> 7. SETTINGS <<<
local SetTab = UI:Tab("Settings", "rbxassetid://7072721682")
SetTab:Label("Theme Border Color")
SetTab:ColorPicker()
SetTab:Label("Menu Options")
SetTab:Input("Change Title...", function(t) if UIRefs.TitleLabel then UIRefs.TitleLabel.Text = t end end)
SetTab:Input("Change Logo URL...", function(t) if UIRefs.OpenBtnImage then UIRefs.OpenBtnImage.Image = t end end)

StarterGui:SetCore("SendNotification", {Title="VANZY V17", Text="Animated & Icons Loaded!"})
