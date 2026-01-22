local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- CONFIG & LINKS
local LogoURL = "https://files.catbox.moe/io8o2d.png"
local LocalPath = "VanzyLogo.jpg"
pcall(function() if not isfile(LocalPath) then writefile(LocalPath, game:HttpGet(LogoURL)) end end)
local FinalLogo = (getcustomasset and isfile(LocalPath)) and getcustomasset(LocalPath) or LogoURL

local GithubAura = "https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/aura.json"
local GithubSky = "https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/sky.json"
local AutoCPFile = "SaveCp.json"
local GithubCP = "https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/SaveCp.json"

local Config = {
    FlySpeed = 50, Flying = false, Noclip = false, InfJump = false, 
    SpeedHack = false, SpeedVal = 50,
    ESP_Box = false, ESP_Name = false, ESP_Health = false,
    MenuTitle = "Vanzyxxx",
    RainbowTheme = false,
    CustomColor = Color3.fromRGB(160, 32, 240),
    AutoPlaying = false,
    TapTP = false,
    LastSaveTime = 0
}

local UIRefs = { MainFrame = nil, Sidebar = nil, Content = nil, Title = nil, MainStroke = nil, OpenBtnStroke = nil }

local function GetGuiParent()
    if gethui then return gethui() end
    if syn and syn.protect_gui then local sg = Instance.new("ScreenGui"); syn.protect_gui(sg); sg.Parent = CoreGui; return sg end
    return CoreGui
end

local Theme = {
    Main = Color3.fromRGB(20, 10, 30),
    Sidebar = Color3.fromRGB(30, 15, 45),
    Accent = Config.CustomColor,
    Text = Color3.fromRGB(255, 255, 255),
    Button = Color3.fromRGB(45, 25, 60),
    ButtonDark = Color3.fromRGB(35, 20, 50),
    ButtonRed = Color3.fromRGB(100, 30, 30),
    Confirm = Color3.fromRGB(40, 100, 40),
    PlayBtn = Color3.fromRGB(255, 170, 0)
}

local Library = {}
local FlyWidgetFrame = nil
local MiniWidget = nil 
local CPManagerFrame = nil 
local CPMainList = nil 
local CPDetailList = nil 
local RefreshCPList -- Forward declaration

spawn(function()
    while true do
        if Config.RainbowTheme then
            local hue = tick() % 5 / 5
            Theme.Accent = Color3.fromHSV(hue, 1, 1)
            Config.CustomColor = Theme.Accent
        else
            Theme.Accent = Config.CustomColor
        end
        if UIRefs.MainStroke then UIRefs.MainStroke.Color = Theme.Accent end
        if UIRefs.OpenBtnStroke then UIRefs.OpenBtnStroke.Color = Theme.Accent end
        if UIRefs.Title then UIRefs.Title.TextColor3 = Theme.Accent end
        if MiniWidget then MiniWidget.UIStroke.Color = Theme.Accent end
        wait(0.05)
    end
end)

function Library:Create()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Vanzyxxx"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = GetGuiParent()
    
    local OpenBtn = Instance.new("ImageButton", ScreenGui); OpenBtn.Name="Open"; OpenBtn.Size=UDim2.new(0,50,0,50); OpenBtn.Position=UDim2.new(0.05,0,0.2,0); OpenBtn.BackgroundColor3=Theme.Main; OpenBtn.Image=FinalLogo; Instance.new("UICorner",OpenBtn).CornerRadius=UDim.new(1,0); 
    local OS=Instance.new("UIStroke",OpenBtn); OS.Color=Theme.Accent; OS.Thickness=2
    UIRefs.OpenBtnStroke = OS

    local MainFrame = Instance.new("Frame", ScreenGui); MainFrame.Name="Main"; MainFrame.Size=UDim2.new(0,400,0,220); MainFrame.Position=UDim2.new(0.5,-200,0.5,-110); MainFrame.BackgroundColor3=Theme.Main; MainFrame.ClipsDescendants=true; MainFrame.Visible=false; Instance.new("UICorner",MainFrame).CornerRadius=UDim.new(0,12); 
    local MS=Instance.new("UIStroke",MainFrame); MS.Color=Theme.Accent; MS.Thickness=2
    UIRefs.MainFrame = MainFrame; UIRefs.MainStroke = MS
    
    local UIScale = Instance.new("UIScale", MainFrame); UIScale.Scale = 0

    local Title = Instance.new("TextLabel", MainFrame); Title.Size=UDim2.new(1,-100,0,30); Title.Position=UDim2.new(0,10,0,0); Title.BackgroundTransparency=1; Title.Text=Config.MenuTitle; Title.Font=Enum.Font.GothamBlack; Title.TextSize=16; Title.TextColor3 = Theme.Accent; Title.TextXAlignment = Enum.TextXAlignment.Left; UIRefs.Title = Title

    local BtnContainer = Instance.new("Frame", MainFrame); BtnContainer.Size = UDim2.new(0, 120, 0, 30); BtnContainer.Position = UDim2.new(1, -125, 0, 0); BtnContainer.BackgroundTransparency = 1
    local CloseX = Instance.new("TextButton", BtnContainer); CloseX.Size=UDim2.new(0,30,0,30); CloseX.Position=UDim2.new(1,-30,0,0); CloseX.BackgroundTransparency=1; CloseX.Text="X"; CloseX.TextColor3=Color3.fromRGB(255,50,50); CloseX.Font=Enum.Font.GothamBlack; CloseX.TextSize=18
    local LayoutBtn = Instance.new("TextButton", BtnContainer); LayoutBtn.Size=UDim2.new(0,30,0,30); LayoutBtn.Position=UDim2.new(1,-60,0,0); LayoutBtn.BackgroundTransparency=1; LayoutBtn.Text="+"; LayoutBtn.TextColor3=Color3.fromRGB(255,200,50); LayoutBtn.Font=Enum.Font.GothamBlack; LayoutBtn.TextSize=20
    local MinBtn = Instance.new("TextButton", BtnContainer); MinBtn.Size=UDim2.new(0,30,0,30); MinBtn.Position=UDim2.new(1,-90,0,0); MinBtn.BackgroundTransparency=1; MinBtn.Text="_"; MinBtn.TextColor3=Theme.Accent; MinBtn.Font=Enum.Font.GothamBlack; MinBtn.TextSize=18

    local Sidebar = Instance.new("ScrollingFrame", MainFrame); Sidebar.Size=UDim2.new(0,110,1,-35); Sidebar.Position=UDim2.new(0,0,0,35); Sidebar.BackgroundColor3=Theme.Sidebar; Sidebar.ScrollBarThickness=0; Sidebar.BorderSizePixel=0
    UIRefs.Sidebar = Sidebar
    local SideLayout = Instance.new("UIListLayout", Sidebar); SideLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center; SideLayout.Padding=UDim.new(0,6); Instance.new("UIPadding", Sidebar).PaddingTop=UDim.new(0,10)

    local Content = Instance.new("Frame", MainFrame); Content.Size=UDim2.new(1,-110,1,-35); Content.Position=UDim2.new(0,110,0,35); Content.BackgroundTransparency=1
    UIRefs.Content = Content

    local function Drag(f, handle)
        handle = handle or f
        local d, ds, sp
        handle.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then d=true; ds=i.Position; sp=f.Position; i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then d=false end end) end end)
        UserInputService.InputChanged:Connect(function(i) if (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) and d then local dt=i.Position-ds; f.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dt.X,sp.Y.Scale,sp.Y.Offset+dt.Y) end end)
    end
    Drag(MainFrame); Drag(OpenBtn)

    local function ToggleMenu(state)
        if state then MainFrame.Visible=true; OpenBtn.Visible=false; TweenService:Create(UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Scale=1}):Play()
        else local tw=TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale=0}); tw:Play(); tw.Completed:Connect(function() MainFrame.Visible=false; OpenBtn.Visible=true end) end
    end
    
    local isVertical = false
    local function ToggleLayout()
        isVertical = not isVertical
        if isVertical then 
            LayoutBtn.Text = "-"; TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size=UDim2.new(0,220,0,400)}):Play()
            Sidebar.Size = UDim2.new(0,60,1,-35); Content.Size = UDim2.new(1,-60,1,-35); Content.Position = UDim2.new(0,60,0,35); MainFrame.Position = UDim2.new(0.5,-110,0.5,-200)
        else 
            LayoutBtn.Text = "+"; TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size=UDim2.new(0,400,0,220)}):Play()
            Sidebar.Size = UDim2.new(0,110,1,-35); Content.Size = UDim2.new(1,-110,1,-35); Content.Position = UDim2.new(0,110,0,35); MainFrame.Position = UDim2.new(0.5,-200,0.5,-110)
        end
    end

    OpenBtn.MouseButton1Click:Connect(function() ToggleMenu(true) end)
    MinBtn.MouseButton1Click:Connect(function() ToggleMenu(false) end)
    LayoutBtn.MouseButton1Click:Connect(ToggleLayout)

    local GlobalPopup = Instance.new("Frame", ScreenGui); GlobalPopup.Size = UDim2.new(0,240,0,130); GlobalPopup.Position = UDim2.new(0.5,-120,0.5,-65); GlobalPopup.BackgroundColor3 = Theme.Main; GlobalPopup.Visible = false; GlobalPopup.ZIndex = 50; Instance.new("UICorner", GlobalPopup).CornerRadius = UDim.new(0,12); Instance.new("UIStroke", GlobalPopup).Color = Theme.Accent; Instance.new("UIStroke", GlobalPopup).Thickness = 2
    local GPTitle = Instance.new("TextLabel", GlobalPopup); GPTitle.Size = UDim2.new(1,0,0,30); GPTitle.BackgroundTransparency = 1; GPTitle.Text = "CONFIRMATION"; GPTitle.TextColor3 = Theme.Accent; GPTitle.Font = Enum.Font.GothamBlack; GPTitle.TextSize = 14; GPTitle.ZIndex=51
    local GPDesc = Instance.new("TextLabel", GlobalPopup); GPDesc.Size = UDim2.new(0.9,0,0.4,0); GPDesc.Position = UDim2.new(0.05,0,0.25,0); GPDesc.BackgroundTransparency = 1; GPDesc.Text = "Are you sure?"; GPDesc.TextColor3 = Theme.Text; GPDesc.Font = Enum.Font.Gotham; GPDesc.TextSize = 12; GPDesc.TextWrapped = true; GPDesc.ZIndex=51
    local GPYes = Instance.new("TextButton", GlobalPopup); GPYes.Size = UDim2.new(0.4,0,0.25,0); GPYes.Position = UDim2.new(0.05,0,0.7,0); GPYes.BackgroundColor3 = Theme.Confirm; GPYes.Text = "YES"; GPYes.TextColor3 = Theme.Text; Instance.new("UICorner", GPYes).CornerRadius = UDim.new(0,6); GPYes.ZIndex=51
    local GPNo = Instance.new("TextButton", GlobalPopup); GPNo.Size = UDim2.new(0.4,0,0.25,0); GPNo.Position = UDim2.new(0.55,0,0.7,0); GPNo.BackgroundColor3 = Theme.ButtonRed; GPNo.Text = "NO"; GPNo.TextColor3 = Theme.Text; Instance.new("UICorner", GPNo).CornerRadius = UDim.new(0,6); GPNo.ZIndex=51

    local PopupAction = nil
    GPNo.MouseButton1Click:Connect(function() GlobalPopup.Visible = false; PopupAction = nil end)
    GPYes.MouseButton1Click:Connect(function() if PopupAction then PopupAction() end; GlobalPopup.Visible = false end)

    function Library:Confirm(text, callback)
        GPDesc.Text = text; PopupAction = callback; GlobalPopup.Visible = true
    end

    CloseX.MouseButton1Click:Connect(function()
        Library:Confirm("Close script?", function()
            Config.Flying = false; Config.SpeedHack = false; Config.TapTP = false
            if LocalPlayer.Character then
                 local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
                 if hum then hum.PlatformStand = false; hum.WalkSpeed = 16 end
                 local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                 if root then 
                    root.AssemblyLinearVelocity = Vector3.zero
                    if root:FindFirstChild("FlyVelocity") then root.FlyVelocity:Destroy() end
                    if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
                 end
            end
            ScreenGui:Destroy()
        end)
    end)

    local FW = Instance.new("Frame", ScreenGui); FW.Size=UDim2.new(0,140,0,50); FW.Position=UDim2.new(0.5,-70,0.1,0); FW.BackgroundColor3=Theme.Sidebar; FW.Visible=false; Instance.new("UICorner",FW).CornerRadius=UDim.new(0,8); Instance.new("UIStroke",FW).Color=Theme.Accent; Drag(FW); FlyWidgetFrame=FW
    local SL = Instance.new("TextLabel", FW); SL.Size=UDim2.new(1,0,0.4,0); SL.BackgroundTransparency=1; SL.Text="SPEED: 50"; SL.TextColor3=Theme.Text; SL.Font=Enum.Font.GothamBold; SL.TextSize=11
    local FBMinus = Instance.new("TextButton", FW); FBMinus.Size=UDim2.new(0.25,0,0.5,0); FBMinus.Position=UDim2.new(0.05,0,0.45,0); FBMinus.BackgroundColor3=Theme.Button; FBMinus.Text="-"; FBMinus.TextColor3=Theme.Text; Instance.new("UICorner", FBMinus)
    local FBToggle = Instance.new("TextButton", FW); FBToggle.Size=UDim2.new(0.35,0,0.5,0); FBToggle.Position=UDim2.new(0.325,0,0.45,0); FBToggle.BackgroundColor3=Theme.Accent; FBToggle.Text="ON"; FBToggle.TextColor3=Theme.Text; Instance.new("UICorner", FBToggle)
    local FBPlus = Instance.new("TextButton", FW); FBPlus.Size=UDim2.new(0.25,0,0.5,0); FBPlus.Position=UDim2.new(0.7,0,0.45,0); FBPlus.BackgroundColor3=Theme.Button; FBPlus.Text="+"; FBPlus.TextColor3=Theme.Text; Instance.new("UICorner", FBPlus)
    
    FBMinus.MouseButton1Click:Connect(function() Config.FlySpeed=math.max(10,Config.FlySpeed-10); SL.Text="SPEED: "..Config.FlySpeed end)
    FBPlus.MouseButton1Click:Connect(function() Config.FlySpeed=Config.FlySpeed+10; SL.Text="SPEED: "..Config.FlySpeed end)
    
    -- [[ UPDATED FLY BUTTON LOGIC ]]
    FBToggle.MouseButton1Click:Connect(function() 
        Config.Flying = not Config.Flying 
        FBToggle.Text = Config.Flying and "ON" or "OFF"
        FBToggle.BackgroundColor3 = Config.Flying and Theme.Accent or Theme.ButtonRed
        
        if not Config.Flying and LocalPlayer.Character then
            -- RESET CHARACTER WHEN OFF
            LocalPlayer.Character.Humanoid.PlatformStand = false
            local root = LocalPlayer.Character.HumanoidRootPart
            if root then
                root.AssemblyLinearVelocity = Vector3.zero
                if root:FindFirstChild("FlyVelocity") then root.FlyVelocity:Destroy() end
                if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
            end
        end
    end)

    local MW = Instance.new("Frame", ScreenGui); MW.Name="MiniWidget"; MW.Size=UDim2.new(0,140,0,45); MW.Position=UDim2.new(0.8,-70,0.4,0); MW.BackgroundColor3=Theme.Main; MW.Visible=false; Instance.new("UICorner",MW).CornerRadius=UDim.new(0,8); Instance.new("UIStroke",MW).Color=Theme.Accent; Instance.new("UIStroke",MW).Thickness=2; MiniWidget=MW
    local DragBtn = Instance.new("TextButton", MW); DragBtn.Size=UDim2.new(0,30,1,0); DragBtn.BackgroundTransparency=1; DragBtn.Text="[+]"; DragBtn.TextColor3=Theme.Accent; DragBtn.Font=Enum.Font.GothamBlack; DragBtn.TextSize=14
    local SaveAct = Instance.new("TextButton", MW); SaveAct.Size=UDim2.new(0,70,1,0); SaveAct.Position=UDim2.new(0,30,0,0); SaveAct.BackgroundTransparency=1; SaveAct.Text="SAVE"; SaveAct.TextColor3=Theme.Text; SaveAct.Font=Enum.Font.GothamBlack; SaveAct.TextSize=16
    local OpenMenu = Instance.new("TextButton", MW); OpenMenu.Size=UDim2.new(0,30,1,0); OpenMenu.Position=UDim2.new(0,100,0,0); OpenMenu.BackgroundTransparency=1; OpenMenu.Text="[×]"; OpenMenu.TextColor3=Color3.fromRGB(255,200,50); OpenMenu.Font=Enum.Font.GothamBlack; OpenMenu.TextSize=14
    Drag(MW, DragBtn)

    -- >>> CP MANAGER FRAME <<<
    local CPF = Instance.new("Frame", ScreenGui); CPF.Name="CPManager"; CPF.Size=UDim2.new(0,320,0,380); CPF.Position=UDim2.new(0.5,-160,0.5,-190); CPF.BackgroundColor3=Theme.Main; CPF.Visible=false; CPF.ZIndex=30; Instance.new("UICorner",CPF).CornerRadius=UDim.new(0,10); Instance.new("UIStroke",CPF).Color=Theme.Accent; CPManagerFrame=CPF
    
    local CPFHeader = Instance.new("TextLabel", CPF); CPFHeader.Size=UDim2.new(1,-30,0,30); CPFHeader.Position=UDim2.new(0,10,0,0); CPFHeader.BackgroundTransparency=1; CPFHeader.Text="CHECKPOINT MANAGER"; CPFHeader.TextColor3=Theme.Accent; CPFHeader.Font=Enum.Font.GothamBlack; CPFHeader.TextXAlignment=Enum.TextXAlignment.Left; CPFHeader.ZIndex=31
    local CPFClose = Instance.new("TextButton", CPF); CPFClose.Size=UDim2.new(0,30,0,30); CPFClose.Position=UDim2.new(1,-30,0,0); CPFClose.BackgroundTransparency=1; CPFClose.Text="X"; CPFClose.TextColor3=Color3.fromRGB(255,50,50); CPFClose.Font=Enum.Font.GothamBold; CPFClose.TextSize=18; CPFClose.ZIndex=35
    
    local CPList = Instance.new("ScrollingFrame", CPF); CPList.Size=UDim2.new(1,-10,0.75,-5); CPList.Position=UDim2.new(0,5,0.1,0); CPList.BackgroundTransparency=1; CPList.ScrollBarThickness=2; CPList.ZIndex=31; Instance.new("UIListLayout", CPList).Padding=UDim.new(0,4); CPMainList=CPList
    local CPDetails = Instance.new("ScrollingFrame", CPF); CPDetails.Size=UDim2.new(1,-10,0.75,-5); CPDetails.Position=UDim2.new(0,5,0.1,0); CPDetails.BackgroundTransparency=1; CPDetails.ScrollBarThickness=2; CPDetails.Visible=false; CPDetails.ZIndex=31; Instance.new("UIListLayout", CPDetails).Padding=UDim.new(0,4); CPDetailList=CPDetails

    local CPLoadLocal = Instance.new("TextButton", CPF); CPLoadLocal.Size=UDim2.new(0.3,0,0,35); CPLoadLocal.Position=UDim2.new(0.03,0,0.88,0); CPLoadLocal.BackgroundColor3=Theme.ButtonDark; CPLoadLocal.Text="Load Local"; CPLoadLocal.TextColor3=Theme.Text; Instance.new("UICorner", CPLoadLocal); CPLoadLocal.ZIndex=32
    local CPPlayBtn = Instance.new("TextButton", CPF); CPPlayBtn.Size=UDim2.new(0.3,0,0,35); CPPlayBtn.Position=UDim2.new(0.35,0,0.88,0); CPPlayBtn.BackgroundColor3=Theme.PlayBtn; CPPlayBtn.Text="PLAY"; CPPlayBtn.TextColor3=Theme.Text; CPPlayBtn.Font = Enum.Font.GothamBlack; Instance.new("UICorner", CPPlayBtn); CPPlayBtn.ZIndex=32
    local CPLoadGit = Instance.new("TextButton", CPF); CPLoadGit.Size=UDim2.new(0.3,0,0,35); CPLoadGit.Position=UDim2.new(0.67,0,0.88,0); CPLoadGit.BackgroundColor3=Theme.Button; CPLoadGit.Text="Load Github"; CPLoadGit.TextColor3=Theme.Text; Instance.new("UICorner", CPLoadGit); CPLoadGit.ZIndex=32
    
    CPFClose.MouseButton1Click:Connect(function() CPF.Visible = false; Config.AutoPlaying = false end)
    OpenMenu.MouseButton1Click:Connect(function() CPF.Visible = true; RefreshCPList() end)

    local Tabs = {}
    function Library:Tab(n)
        local B = Instance.new("TextButton", Sidebar); B.Size=UDim2.new(0.85,0,0,28); B.BackgroundColor3=Theme.Button; B.Text=n; B.TextColor3=Color3.fromRGB(200,200,200); B.Font=Enum.Font.GothamBold; B.TextSize=10; Instance.new("UICorner",B).CornerRadius=UDim.new(0,6)
        local P = Instance.new("ScrollingFrame", Content); P.Size=UDim2.new(1,-5,1,0); P.BackgroundTransparency=1; P.ScrollBarThickness=2; P.Visible=false; P.AutomaticCanvasSize = Enum.AutomaticSize.Y; P.CanvasSize = UDim2.new(0,0,0,0)
        local L=Instance.new("UIListLayout", P); L.Padding=UDim.new(0,5)
        Instance.new("UIPadding", P).PaddingTop=UDim.new(0,5); Instance.new("UIPadding", P).PaddingLeft=UDim.new(0,5)
        B.MouseButton1Click:Connect(function() for _,t in pairs(Tabs) do t.P.Visible=false; t.B.BackgroundColor3=Theme.Button; t.B.TextColor3=Color3.fromRGB(200,200,200) end; P.Visible=true; B.BackgroundColor3=Theme.Accent; B.TextColor3=Color3.new(1,1,1) end)
        table.insert(Tabs, {P=P, B=B})
        local E = {}
        function E:Button(t, c, f) local b=Instance.new("TextButton",P); b.Size=UDim2.new(1,0,0,26); b.BackgroundColor3=c or Theme.Button; b.Text=t; b.TextColor3=Color3.new(1,1,1); b.Font=Enum.Font.Gotham; b.TextSize=11; Instance.new("UICorner",b).CornerRadius=UDim.new(0,6); b.MouseButton1Click:Connect(function() pcall(f) end) end
        function E:Toggle(t, f) local fr=Instance.new("Frame",P); fr.Size=UDim2.new(1,0,0,26); fr.BackgroundColor3=Theme.Button; Instance.new("UICorner",fr).CornerRadius=UDim.new(0,6); local l=Instance.new("TextLabel",fr); l.Size=UDim2.new(0.65,0,1,0); l.Position=UDim2.new(0.05,0,0,0); l.BackgroundTransparency=1; l.Text=t; l.TextColor3=Color3.new(1,1,1); l.TextXAlignment=Enum.TextXAlignment.Left; l.Font=Enum.Font.Gotham; l.TextSize=11; local b=Instance.new("TextButton",fr); b.Size=UDim2.new(0,30,0,18); b.Position=UDim2.new(0.75,0,0.15,0); b.BackgroundColor3=Color3.fromRGB(60,60,60); b.Text=""; Instance.new("UICorner",b).CornerRadius=UDim.new(1,0); local s=false; b.MouseButton1Click:Connect(function() s=not s; b.BackgroundColor3=s and Theme.Accent or Color3.fromRGB(60,60,60); f(s) end) end
        function E:Input(p, f) local fr=Instance.new("Frame",P); fr.Size=UDim2.new(1,0,0,26); fr.BackgroundColor3=Color3.fromRGB(35,35,35); Instance.new("UICorner",fr).CornerRadius=UDim.new(0,6); local bx=Instance.new("TextBox",fr); bx.Size=UDim2.new(0.9,0,1,0); bx.Position=UDim2.new(0.05,0,0,0); bx.BackgroundTransparency=1; bx.Text=""; bx.PlaceholderText=p; bx.TextColor3=Color3.new(1,1,1); bx.Font=Enum.Font.Gotham; bx.TextSize=11; bx:GetPropertyChangedSignal("Text"):Connect(function() f(bx.Text) end) end
        function E:Label(t) local l=Instance.new("TextLabel",P); l.Size=UDim2.new(1,0,0,20); l.BackgroundTransparency=1; l.Text=t; l.TextColor3=Theme.Accent; l.Font=Enum.Font.GothamBold; l.TextSize=10; l.TextXAlignment=Enum.TextXAlignment.Left end
        function E:Slider(t,min,max,f) local fr=Instance.new("Frame",P);fr.Size=UDim2.new(1,0,0,32);fr.BackgroundColor3=Theme.Button;Instance.new("UICorner",fr).CornerRadius=UDim.new(0,6);local l=Instance.new("TextLabel",fr);l.Size=UDim2.new(1,0,0.5,0);l.Position=UDim2.new(0.05,0,0,0);l.BackgroundTransparency=1;l.Text=t;l.TextColor3=Color3.new(1,1,1);l.TextSize=10;l.TextXAlignment=Enum.TextXAlignment.Left;local b=Instance.new("TextButton",fr);b.Size=UDim2.new(0.9,0,0.3,0);b.Position=UDim2.new(0.05,0,0.6,0);b.BackgroundColor3=Color3.fromRGB(30,30,30);b.Text="";local fil=Instance.new("Frame",b);fil.Size=UDim2.new(0,0,1,0);fil.BackgroundColor3=Theme.Accent;b.MouseButton1Down:Connect(function() local m;m=RunService.RenderStepped:Connect(function() local s=math.clamp((UserInputService:GetMouseLocation().X-b.AbsolutePosition.X)/b.AbsoluteSize.X,0,1);fil.Size=UDim2.new(s,0,1,0);f(min+(max-min)*s);if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then m:Disconnect() end end) end) end
        function E:Container(h) local c=Instance.new("ScrollingFrame",P); c.Size=UDim2.new(1,0,0,h); c.BackgroundColor3=Color3.fromRGB(25,25,25); c.ScrollBarThickness=2; Instance.new("UICorner",c).CornerRadius=UDim.new(0,6); local l=Instance.new("UIListLayout",c); l.Padding=UDim.new(0,2); c.AutomaticCanvasSize = Enum.AutomaticSize.Y; return c end
        return E
    end
    return Library, DragBtn, SaveAct, CPLoadLocal, CPLoadGit, CPMainList, CPDetailList, CPPlayBtn
end

local UI, DragBtn, SaveAct, LoadLocalBtn, LoadGitBtn, CPMainList, CPDetailList, CPPlayBtn = Library:Create()

-- [[ AURA & SKY TABS ]]
local AuraTab = UI:Tab("Auras")
local AuraContainer = AuraTab:Container(150)
local function UpdateAura(id)
    pcall(function()
        if LocalPlayer.Character:FindFirstChild("VanzyAura") then LocalPlayer.Character.VanzyAura:Destroy() end
        local objs = game:GetObjects("rbxassetid://"..id)
        if objs[1] then
            local aura = objs[1]; aura.Name = "VanzyAura"
            for _,v in pairs(aura:GetDescendants()) do if v:IsA("BasePart") or v:IsA("MeshPart") then v.Transparency=1;v.CanCollide=false;v.Massless=true;v.CastShadow=false;v.Anchored=false elseif v:IsA("Decal") then v.Transparency=1 end end
            aura.Parent = LocalPlayer.Character
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local primary = aura:IsA("Model") and aura.PrimaryPart or aura:FindFirstChildWhichIsA("BasePart")
            if root and primary then primary.CFrame = root.CFrame; local w = Instance.new("WeldConstraint", primary); w.Part0 = root; w.Part1 = primary; w.Parent = primary end
            StarterGui:SetCore("SendNotification", {Title="Aura", Text="Applied!"})
        end
    end)
end
local function LoadAuras()
    pcall(function()
        for _,v in pairs(AuraContainer:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        local JSON = HttpService:JSONDecode(game:HttpGet(GithubAura))
        for _, a in pairs(JSON) do
            local b = Instance.new("TextButton", AuraContainer); b.Size = UDim2.new(1,0,0,25); b.BackgroundColor3 = Theme.ButtonDark; b.Text = a.Name; b.TextColor3 = Theme.Text; b.Font = Enum.Font.Gotham; b.TextSize = 11; Instance.new("UICorner",b).CornerRadius=UDim.new(0,4); b.MouseButton1Click:Connect(function() UpdateAura(a.ID) end)
        end
        StarterGui:SetCore("SendNotification", {Title="Aura", Text="List Loaded!"})
    end)
end
AuraTab:Button("Refresh List (GitHub)", Theme.Button, LoadAuras)
AuraTab:Button("Reset Aura", Theme.ButtonRed, function() if LocalPlayer.Character:FindFirstChild("VanzyAura") then LocalPlayer.Character.VanzyAura:Destroy(); StarterGui:SetCore("SendNotification", {Title="Aura", Text="Removed!"}) end end)

local SkyTab = UI:Tab("Sky")
local SkyContainer = SkyTab:Container(150)
local function UpdateSky(id)
    pcall(function()
        for _,v in pairs(Lighting:GetChildren()) do if v:IsA("Sky") or v:IsA("Atmosphere") then v:Destroy() end end
        local objects = game:GetObjects("rbxassetid://"..id)
        if objects[1] then
            local asset = objects[1]; if asset:IsA("Model") then local foundSky = asset:FindFirstChildOfClass("Sky"); if foundSky then foundSky.Parent = Lighting else asset.Parent = Lighting end; local foundAtmos = asset:FindFirstChildOfClass("Atmosphere"); if foundAtmos then foundAtmos.Parent = Lighting end elseif asset:IsA("Sky") then asset.Parent = Lighting end
            StarterGui:SetCore("SendNotification", {Title="Sky", Text="Changed!"})
        end
    end)
end
local function LoadSkies()
    pcall(function()
        for _,v in pairs(SkyContainer:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        local JSON = HttpService:JSONDecode(game:HttpGet(GithubSky))
        for _, s in pairs(JSON) do
            local b = Instance.new("TextButton", SkyContainer); b.Size = UDim2.new(1,0,0,25); b.BackgroundColor3 = Theme.ButtonDark; b.Text = s.Name; b.TextColor3 = Theme.Text; b.Font = Enum.Font.Gotham; b.TextSize = 11; Instance.new("UICorner",b).CornerRadius=UDim.new(0,4); b.MouseButton1Click:Connect(function() UpdateSky(s.ID) end)
        end
        StarterGui:SetCore("SendNotification", {Title="Sky", Text="List Loaded!"})
    end)
end
SkyTab:Button("Refresh List (GitHub)", Theme.Button, LoadSkies)
SkyTab:Button("Reset Sky", Theme.ButtonRed, function() for _,v in pairs(Lighting:GetChildren()) do if v:IsA("Sky") or v:IsA("Atmosphere") then v:Destroy() end end; StarterGui:SetCore("SendNotification", {Title="Sky", Text="Reset!"}) end)

-- [[ ITEMS TAB ]]
local ItemTab = UI:Tab("Items")
ItemTab:Label("Click/Tap Utilities")

-- FIXED TAP TP LOGIC (DRAG DETECTION)
ItemTab:Toggle("Tap to Teleport", function(s) 
    Config.TapTP = s 
end)

local TapStartPos = Vector2.zero
local IsTapping = false

UserInputService.InputBegan:Connect(function(input, gpe)
    if not Config.TapTP or gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        IsTapping = true
        TapStartPos = UserInputService:GetMouseLocation()
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if not Config.TapTP or gpe then return end
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and IsTapping then
        IsTapping = false
        local EndPos = UserInputService:GetMouseLocation()
        if (EndPos - TapStartPos).Magnitude < 15 then 
            local ray = Camera:ViewportPointToRay(EndPos.X, EndPos.Y)
            local res = workspace:Raycast(ray.Origin, ray.Direction * 1000)
            if res and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                root.CFrame = CFrame.new(res.Position + Vector3.new(0, 3, 0))
            end
        end
    end
end)

-- [[ MOVEMENT TAB ]]
local Mov = UI:Tab("Movement")
Mov:Label("Fly V3 (Fixed Gravity & Tilt)")

-- COMPLETELY REWRITTEN FLY LOGIC
-- Uses BodyVelocity for stability and BodyGyro for Tilt Animation
RunService.Heartbeat:Connect(function()
    if not Config.Flying then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum then return end

    -- Enable PlatformStand to disable default physics/animations
    hum.PlatformStand = true

    -- Velocity Handler
    local bv = root:FindFirstChild("FlyVelocity")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = root
    end

    -- Gyro Handler (For Rotation/Tilt)
    local bg = root:FindFirstChild("FlyGyro")
    if not bg then
        bg = Instance.new("BodyGyro")
        bg.Name = "FlyGyro"
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.P = 10000 -- Responsiveness
        bg.D = 100 -- Damping
        bg.Parent = root
    end

    -- Calculate Movement Direction
    local moveDir = hum.MoveDirection
    local camCFrame = Camera.CFrame
    local targetVelocity = Vector3.zero

    if moveDir.Magnitude > 0 then
        targetVelocity = camCFrame.LookVector * Config.FlySpeed
    else
        targetVelocity = Vector3.zero
    end
    
    bv.Velocity = targetVelocity

    -- Calculate Tilt Animation
    -- Forward/Backward Tilt
    local forwardTilt = 0
    local sideTilt = 0
    
    -- Getting Controls (W,S,A,D) relative to camera
    local lv = camCFrame.LookVector
    local rv = camCFrame.RightVector
    local dotFwd = moveDir:Dot(lv)
    local dotRight = moveDir:Dot(rv)

    if moveDir.Magnitude > 0 then
        -- Tilt forward (negative X rotation) when moving forward
        if dotFwd > 0.5 then forwardTilt = -45 end
        -- Tilt backward (positive X rotation) when moving backward
        if dotFwd < -0.5 then forwardTilt = 25 end
        -- Tilt sideways (Z rotation)
        if dotRight > 0.5 then sideTilt = -45 end -- Right
        if dotRight < -0.5 then sideTilt = 45 end -- Left
    end

    -- Smoothly interpolate current CFrame to target tilt
    local targetCFrame = camCFrame * CFrame.Angles(math.rad(forwardTilt), 0, math.rad(sideTilt))
    bg.CFrame = targetCFrame
end)

Mov:Toggle("Fly (Menu)", function(s) Config.Flying=s; FlyWidgetFrame.Visible=s end)
Mov:Toggle("Speed Hack", function(s) Config.SpeedHack=s; spawn(function() while Config.SpeedHack do LocalPlayer.Character.Humanoid.WalkSpeed=Config.SpeedVal;wait() end;LocalPlayer.Character.Humanoid.WalkSpeed=16 end) end)
Mov:Slider("Speed Value", 16, 200, function(v) Config.SpeedVal=v end)
Mov:Label("Jump Modifiers")
Mov:Toggle("Infinite Jump", function(s) Config.InfJump=s end)
UserInputService.JumpRequest:Connect(function() if Config.InfJump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)
Mov:Label("Utility")
Mov:Toggle("Noclip", function(s) Config.Noclip=s; RunService.Stepped:Connect(function() if Config.Noclip then for _,v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end end end) end)
Mov:Toggle("Wall Climb", function(s) Config.WallClimb=s; if s then local b=Instance.new("BodyVelocity",LocalPlayer.Character.HumanoidRootPart);b.MaxForce=Vector3.zero;RunService.RenderStepped:Connect(function() if Config.WallClimb then local r=Ray.new(LocalPlayer.Character.HumanoidRootPart.Position,LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector*2);if workspace:FindPartOnRay(r,LocalPlayer.Character) then b.MaxForce=Vector3.new(0,9e9,0);b.Velocity=Vector3.new(0,20,0) else b.MaxForce=Vector3.zero end else b:Destroy() end end) end end)

-- [[ S/L CP LOGIC ]]
local CP_UI = UI:Tab("S/L CP")
local function GetMapID() return tostring(game.PlaceId) end
local function GetMapName() local success, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end); if success and info then return info.Name else return "Unknown Map" end end
local function LoadData() if isfile(AutoCPFile) then return HttpService:JSONDecode(readfile(AutoCPFile)) end return {} end
local function SaveData(data) writefile(AutoCPFile, HttpService:JSONEncode(data)) end

-- REFRESH CP LIST
function RefreshCPList()
    for _,v in pairs(CPMainList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for _,v in pairs(CPDetailList:GetChildren()) do if v:IsA("Frame") or v:IsA("TextButton") then v:Destroy() end end
    local Data = LoadData(); CPMainList.Visible = true; CPDetailList.Visible = false
    for id, mapInfo in pairs(Data) do
        local MapFrame = Instance.new("Frame", CPMainList); MapFrame.Size=UDim2.new(1,0,0,30); MapFrame.BackgroundColor3=Theme.Sidebar; MapFrame.ZIndex=32; Instance.new("UICorner", MapFrame)
        local MapBtn = Instance.new("TextButton", MapFrame); MapBtn.Size=UDim2.new(0.8,0,1,0); MapBtn.BackgroundTransparency=1; MapBtn.Text="📁 "..mapInfo.MapName; MapBtn.TextColor3=Theme.Accent; MapBtn.TextXAlignment=Enum.TextXAlignment.Left; MapBtn.Font=Enum.Font.GothamBold; MapBtn.TextSize=12; MapBtn.ZIndex=33; Instance.new("UIPadding",MapBtn).PaddingLeft=UDim.new(0,5)
        local DelMap = Instance.new("TextButton", MapFrame); DelMap.Size=UDim2.new(0.2,0,1,0); DelMap.Position=UDim2.new(0.8,0,0,0); DelMap.BackgroundColor3=Theme.ButtonRed; DelMap.Text="DEL"; DelMap.TextColor3=Theme.Text; Instance.new("UICorner", DelMap); DelMap.ZIndex=33
        MapBtn.MouseButton1Click:Connect(function()
            CPMainList.Visible = false; CPDetailList.Visible = true
            for _,v in pairs(CPDetailList:GetChildren()) do if v:IsA("Frame") or v:IsA("TextButton") then v:Destroy() end end
            local BackBtn = Instance.new("TextButton", CPDetailList); BackBtn.Size=UDim2.new(1,0,0,25); BackBtn.BackgroundColor3=Theme.ButtonRed; BackBtn.Text="< BACK"; BackBtn.TextColor3=Theme.Text; Instance.new("UICorner", BackBtn); BackBtn.ZIndex=33
            BackBtn.MouseButton1Click:Connect(function() CPDetailList.Visible = false; CPMainList.Visible = true end)
            for i, cp in ipairs(mapInfo.CPs) do
                local CPFrame = Instance.new("Frame", CPDetailList); CPFrame.Size=UDim2.new(0.9,0,0,25); CPFrame.BackgroundColor3=Theme.Button; Instance.new("UICorner", CPFrame); CPFrame.ZIndex=32
                local TPBtn = Instance.new("TextButton", CPFrame); TPBtn.Size=UDim2.new(0.8,0,1,0); TPBtn.BackgroundTransparency=1; TPBtn.Text="📍 "..cp.Name; TPBtn.TextColor3=Theme.Text; TPBtn.TextSize=11; TPBtn.ZIndex=33
                local DelCP = Instance.new("TextButton", CPFrame); DelCP.Size=UDim2.new(0.2,0,1,0); DelCP.Position=UDim2.new(0.8,0,0,0); DelCP.BackgroundColor3=Theme.ButtonRed; DelCP.Text="X"; DelCP.TextColor3=Theme.Text; Instance.new("UICorner", DelCP); DelCP.ZIndex=33
                TPBtn.MouseButton1Click:Connect(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(cp.X, cp.Y + 3, cp.Z) end end)
                DelCP.MouseButton1Click:Connect(function() Library:Confirm("Delete CP: "..cp.Name.."?", function() table.remove(Data[id].CPs, i); SaveData(Data); MapBtn.MouseButton1Click:Fire() end) end)
            end
            CPDetailList.CanvasSize = UDim2.new(0,0,0, CPDetailList.UIListLayout.AbsoluteContentSize.Y + 50)
        end)
        DelMap.MouseButton1Click:Connect(function() Library:Confirm("Delete Map FOLDER: "..mapInfo.MapName.."?", function() Data[id] = nil; SaveData(Data); RefreshCPList() end) end)
    end
    CPMainList.CanvasSize = UDim2.new(0,0,0, CPMainList.UIListLayout.AbsoluteContentSize.Y + 50)
end

-- DOUBLE CLICK SAVE WITH POPUP
SaveAct.MouseButton1Click:Connect(function()
    local Data = LoadData(); local ID = GetMapID(); local Name = GetMapName()
    if not Data[ID] then Data[ID] = {MapName = Name, CPs = {}} end
    
    local CurrentTime = tick()
    local IsDouble = (CurrentTime - Config.LastSaveTime) < 0.5
    Config.LastSaveTime = CurrentTime

    local Pos = LocalPlayer.Character.HumanoidRootPart.Position
    local Count = #Data[ID].CPs
    
    if IsDouble then
        -- POPUP FOR SUMMIT
        Library:Confirm("Save as SUMMIT (Finish)?", function()
             table.insert(Data[ID].CPs, {Name = "SUMMIT", X = Pos.X, Y = Pos.Y, Z = Pos.Z})
             SaveData(Data)
             RefreshCPList()
             StarterGui:SetCore("SendNotification", {Title="Saved", Text="SUMMIT"})
        end)
    else
        -- POPUP FOR NORMAL CP
        local CPName = (Count == 0) and "Spawn" or "CP"..tostring(Count)
        Library:Confirm("Save as "..CPName.."?", function()
            table.insert(Data[ID].CPs, {Name = CPName, X = Pos.X, Y = Pos.Y, Z = Pos.Z})
            SaveData(Data)
            RefreshCPList()
            StarterGui:SetCore("SendNotification", {Title="Saved", Text=CPName})
        end)
    end
end)

LoadLocalBtn.MouseButton1Click:Connect(function() RefreshCPList(); StarterGui:SetCore("SendNotification", {Title="Success", Text="Refreshed Local!"}) end)
LoadGitBtn.MouseButton1Click:Connect(function() pcall(function() local WebData = game:HttpGet(GithubCP); writefile(AutoCPFile, WebData); wait(0.1); RefreshCPList(); StarterGui:SetCore("SendNotification", {Title="Success", Text="Loaded from GitHub"}) end) end)

-- SMART PLAY (RESUME) LOGIC
CPPlayBtn.MouseButton1Click:Connect(function()
    if Config.AutoPlaying then 
        Config.AutoPlaying = false; StarterGui:SetCore("SendNotification", {Title="Auto Play", Text="Stopped"})
        CPPlayBtn.Text = "PLAY"; CPPlayBtn.BackgroundColor3 = Theme.PlayBtn; return 
    end

    local Data = LoadData(); local ID = GetMapID()
    if Data[ID] and Data[ID].CPs and #Data[ID].CPs > 0 then
        Config.AutoPlaying = true
        CPPlayBtn.Text = "STOP"; CPPlayBtn.BackgroundColor3 = Theme.ButtonRed
        
        spawn(function()
            local PlayerPos = LocalPlayer.Character.HumanoidRootPart.Position
            local ClosestIndex = 1
            local MinDist = 9999999
            
            -- Find closest CP
            for i, cp in ipairs(Data[ID].CPs) do
                local Dist = (PlayerPos - Vector3.new(cp.X, cp.Y, cp.Z)).Magnitude
                if Dist < MinDist then MinDist = Dist; ClosestIndex = i end
            end
            
            -- Start from next CP if very close, otherwise start from closest
            local StartIndex = (MinDist < 10) and (ClosestIndex + 1) or ClosestIndex
            if StartIndex > #Data[ID].CPs then StartIndex = 1 end -- Loop if finished
            
            StarterGui:SetCore("SendNotification", {Title="Auto Play", Text="Resuming from CP"..StartIndex})

            for i = StartIndex, #Data[ID].CPs do
                if not Config.AutoPlaying then break end
                local cp = Data[ID].CPs[i]
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(cp.X, cp.Y + 3, cp.Z)
                end
                task.wait(0.75)
            end
            Config.AutoPlaying = false; CPPlayBtn.Text = "PLAY"; CPPlayBtn.BackgroundColor3 = Theme.PlayBtn
            StarterGui:SetCore("SendNotification", {Title="Auto Play", Text="Finished!"})
        end)
    else
        StarterGui:SetCore("SendNotification", {Title="Error", Text="No CPs found!"})
    end
end)

CP_UI:Label("Quick Controls")
CP_UI:Toggle("Show Mini Button", function(s) MiniWidget.Visible = s end)
CP_UI:Button("Open Manager", Theme.ButtonDark, function() CPManagerFrame.Visible = true; RefreshCPList() end)

local Vis = UI:Tab("Visuals")
Vis:Toggle("ESP Box", function(s) Config.ESP_Box=s end)
Vis:Toggle("ESP Name", function(s) Config.ESP_Name=s end)
Vis:Toggle("ESP Health", function(s) Config.ESP_Health=s end)
Vis:Toggle("Full Bright", function(s) Lighting.Brightness=s and 2 or 1; Lighting.GlobalShadows=not s end)
spawn(function()
    while true do
        if Config.ESP_Box or Config.ESP_Name or Config.ESP_Health then
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local bb=p.Character.HumanoidRootPart:FindFirstChild("V_BB")
                    if not bb then
                        bb=Instance.new("BillboardGui",p.Character.HumanoidRootPart);bb.Name="V_BB";bb.Size=UDim2.new(4,0,5,0);bb.AlwaysOnTop=true
                        local f=Instance.new("Frame",bb);f.Size=UDim2.new(1,0,1,0);f.BackgroundTransparency=1;Instance.new("UIStroke",f).Color=Color3.new(1,0,0)
                        local t=Instance.new("TextLabel",bb);t.Size=UDim2.new(1,0,0,15);t.Position=UDim2.new(0,0,-0.2,0);t.BackgroundTransparency=1;t.TextColor3=Color3.new(1,1,1);t.TextStrokeTransparency=0
                    end
                    bb.Enabled=true; bb.Frame.UIStroke.Enabled=Config.ESP_Box
                    local txt=""; if Config.ESP_Name then txt=txt..p.Name.."\n" end; if Config.ESP_Health then txt=txt.."HP:"..math.floor(p.Character.Humanoid.Health) end
                    bb.TextLabel.Text=txt
                end
            end
        end
        wait(1)
    end
end)

local Set = UI:Tab("Settings")
Set:Input("Change Menu Title...", function(t) Config.MenuTitle=t; UIRefs.Title.Text=t end)
Set:Toggle("Rainbow Mode", function(s) Config.RainbowTheme = s end)
Set:Label("Custom Color (RGB)")
local R, G, B = 160, 32, 240
Set:Slider("Red", 0, 255, function(v) R=v; Config.CustomColor = Color3.fromRGB(R, G, B) end)
Set:Slider("Green", 0, 255, function(v) G=v; Config.CustomColor = Color3.fromRGB(R, G, B) end)
Set:Slider("Blue", 0, 255, function(v) B=v; Config.CustomColor = Color3.fromRGB(R, G, B) end)

-- IMPROVED FPS BOOSTER
Set:Toggle("FPS Booster (Extreme)", function(s) 
    Config.FPSBoost = s
    if s then 
        game.Lighting.GlobalShadows = false
        for _,v in pairs(game:GetDescendants()) do 
            if v:IsA("BasePart") then v.Material=Enum.Material.SmoothPlastic; v.CastShadow=false end
            if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then v.Enabled = false end
        end 
    end 
end)
Set:Button("Rejoin Server", Theme.ButtonDark, function() TeleportService:Teleport(game.PlaceId) end)

local vu = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function() vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame); wait(1); vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end)

StarterGui:SetCore("SendNotification", {Title="Vanzyxxx", Text="Final V6 (Gravity & Tilt) Loaded!"})
