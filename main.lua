--[[
    PROJECT: VanzyxxxXXX V23 ULTIMATE (FIXED)
    UPDATE: SCROLL FIX, SKY FIX, RAINBOW THEME, CUSTOM COLOR
    PLATFORM: MOBILE ONLY (DELTA/HYDROGEN/ARCEUS/CODEX)
]]

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

--------------------------------------------------------------------------------
-- [LOGO SYSTEM]
--------------------------------------------------------------------------------
local LogoURL = "https://files.catbox.moe/bm2fcp.jpg"
local LocalPath = "VanzyLogoV23.jpg"
pcall(function() if not isfile(LocalPath) then writefile(LocalPath, game:HttpGet(LogoURL)) end end)
local FinalLogo = (getcustomasset and isfile(LocalPath)) and getcustomasset(LocalPath) or LogoURL

--------------------------------------------------------------------------------
-- [GLOBAL CONFIG]
--------------------------------------------------------------------------------
local Config = {
    -- Movement
    FlySpeed = 50, Flying = false, Noclip = false, InfJump = false, 
    HighJump = false, WallClimb = false, SpeedHack = false, SpeedVal = 50,
    -- Hold to Jump
    HoldJump = false, HoldPower = 0, MaxHoldPower = 150, Charging = false,
    
    -- Visuals
    ESP_Box = false, ESP_Name = false, ESP_Health = false,
    
    -- Tools
    AntiVoid = false, AirJump = false, AntiSlip = false, Invisible = false,
    FlingAura = false,
    
    -- New Systems
    AutoSaveCP = false,
    MiniButtonActive = false,
    
    -- Theme & Settings
    MenuTitle = "Vanzyxxx",
    FPSBoost = false,
    RainbowTheme = false,
    CustomColor = Color3.fromRGB(160, 32, 240) -- Default Purple
}

local UIRefs = { 
    MainFrame = nil, 
    Sidebar = nil, 
    Content = nil, 
    Title = nil,
    MainStroke = nil,
    OpenBtnStroke = nil,
    ActiveButtons = {} -- Store buttons to update color
}

local CPFileName = "MapsCp.json" -- Legacy
local AutoCPFile = "SaveCp.json" -- New System
local AuraFile = "VanzyAuras.json"
local SkyFile = "VanzySkies.json"
local WepFile = "VanzyWeapons.json"

local function GetGuiParent()
    if gethui then return gethui() end
    if syn and syn.protect_gui then local sg = Instance.new("ScreenGui"); syn.protect_gui(sg); sg.Parent = CoreGui; return sg end
    return CoreGui
end

--------------------------------------------------------------------------------
-- [UI ENGINE - DARK PURPLE THEME]
--------------------------------------------------------------------------------
local Theme = {
    Main = Color3.fromRGB(20, 10, 30),
    Sidebar = Color3.fromRGB(30, 15, 45),
    Accent = Config.CustomColor, -- Dynamic
    Text = Color3.fromRGB(255, 255, 255),
    Button = Color3.fromRGB(45, 25, 60),
    ButtonDark = Color3.fromRGB(35, 20, 50),
    ButtonRed = Color3.fromRGB(100, 30, 30),
    Confirm = Color3.fromRGB(40, 100, 40)
}

local Library = {}
local FlyWidgetFrame = nil
local SaveCpButton = nil -- Mini Button ref

-- RAINBOW & THEME UPDATE LOOP
spawn(function()
    while true do
        if Config.RainbowTheme then
            local hue = tick() % 5 / 5
            local color = Color3.fromHSV(hue, 1, 1)
            Theme.Accent = color
            Config.CustomColor = color
        else
            Theme.Accent = Config.CustomColor
        end
        
        -- Apply to Main Strokes
        if UIRefs.MainStroke then UIRefs.MainStroke.Color = Theme.Accent end
        if UIRefs.OpenBtnStroke then UIRefs.OpenBtnStroke.Color = Theme.Accent end
        if UIRefs.Title then UIRefs.Title.TextColor3 = Theme.Accent end
        
        -- Apply to Active Tab Buttons (Optional optimization: only update active)
        if SaveCpButton then SaveCpButton.BackgroundColor3 = Theme.Accent end
        
        wait(0.05)
    end
end)

function Library:Create()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VanzyV23_Ultimate"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = GetGuiParent()
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- OPEN BUTTON
    local OpenBtn = Instance.new("ImageButton", ScreenGui); OpenBtn.Name="Open"; OpenBtn.Size=UDim2.new(0,50,0,50); OpenBtn.Position=UDim2.new(0.05,0,0.2,0); OpenBtn.BackgroundColor3=Theme.Main; OpenBtn.Image=FinalLogo; Instance.new("UICorner",OpenBtn).CornerRadius=UDim.new(1,0); 
    local OS=Instance.new("UIStroke",OpenBtn); OS.Color=Theme.Accent; OS.Thickness=2
    UIRefs.OpenBtnStroke = OS

    -- MAIN FRAME
    local MainFrame = Instance.new("Frame", ScreenGui); MainFrame.Name="Main"; MainFrame.Size=UDim2.new(0,400,0,220); MainFrame.Position=UDim2.new(0.5,-200,0.5,-110); MainFrame.BackgroundColor3=Theme.Main; MainFrame.ClipsDescendants=true; MainFrame.Visible=false; Instance.new("UICorner",MainFrame).CornerRadius=UDim.new(0,12); 
    local MS=Instance.new("UIStroke",MainFrame); MS.Color=Theme.Accent; MS.Thickness=2
    UIRefs.MainFrame = MainFrame
    UIRefs.MainStroke = MS
    
    local UIScale = Instance.new("UIScale", MainFrame); UIScale.Scale = 0

    -- TITLE
    local Title = Instance.new("TextLabel", MainFrame); Title.Size=UDim2.new(1,-100,0,30); Title.Position=UDim2.new(0,10,0,0); Title.BackgroundTransparency=1; Title.Text=Config.MenuTitle; Title.Font=Enum.Font.GothamBlack; Title.TextSize=16; Title.TextColor3 = Theme.Accent; Title.TextXAlignment = Enum.TextXAlignment.Left; UIRefs.Title = Title

    -- TOP BAR BUTTONS
    local BtnContainer = Instance.new("Frame", MainFrame)
    BtnContainer.Size = UDim2.new(0, 120, 0, 30)
    BtnContainer.Position = UDim2.new(1, -125, 0, 0)
    BtnContainer.BackgroundTransparency = 1

    local CloseX = Instance.new("TextButton", BtnContainer); CloseX.Size=UDim2.new(0,30,0,30); CloseX.Position=UDim2.new(1,-30,0,0); CloseX.BackgroundTransparency=1; CloseX.Text="X"; CloseX.TextColor3=Color3.fromRGB(255,50,50); CloseX.Font=Enum.Font.GothamBlack; CloseX.TextSize=18
    
    local LayoutBtn = Instance.new("TextButton", BtnContainer); LayoutBtn.Size=UDim2.new(0,30,0,30); LayoutBtn.Position=UDim2.new(1,-60,0,0); LayoutBtn.BackgroundTransparency=1; LayoutBtn.Text="+"; LayoutBtn.TextColor3=Color3.fromRGB(255,200,50); LayoutBtn.Font=Enum.Font.GothamBlack; LayoutBtn.TextSize=20
    
    local MinBtn = Instance.new("TextButton", BtnContainer); MinBtn.Size=UDim2.new(0,30,0,30); MinBtn.Position=UDim2.new(1,-90,0,0); MinBtn.BackgroundTransparency=1; MinBtn.Text="_"; MinBtn.TextColor3=Theme.Accent; MinBtn.Font=Enum.Font.GothamBlack; MinBtn.TextSize=18

    -- SIDEBAR & CONTENT
    local Sidebar = Instance.new("ScrollingFrame", MainFrame); Sidebar.Size=UDim2.new(0,110,1,-35); Sidebar.Position=UDim2.new(0,0,0,35); Sidebar.BackgroundColor3=Theme.Sidebar; Sidebar.ScrollBarThickness=0; Sidebar.BorderSizePixel=0
    UIRefs.Sidebar = Sidebar
    local SideLayout = Instance.new("UIListLayout", Sidebar); SideLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center; SideLayout.Padding=UDim.new(0,6); Instance.new("UIPadding", Sidebar).PaddingTop=UDim.new(0,10)

    local Content = Instance.new("Frame", MainFrame); Content.Size=UDim2.new(1,-110,1,-35); Content.Position=UDim2.new(0,110,0,35); Content.BackgroundTransparency=1
    UIRefs.Content = Content

    -- DRAG & LOGIC
    local function Drag(f)
        local d, ds, sp
        f.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then d=true; ds=i.Position; sp=f.Position; i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then d=false end end) end end)
        UserInputService.InputChanged:Connect(function(i) if (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) and d then local dt=i.Position-ds; f.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dt.X,sp.Y.Scale,sp.Y.Offset+dt.Y) end end)
    end
    Drag(MainFrame); Drag(OpenBtn)

    local isOpen, isVertical = false, false
    local function ToggleMenu(state)
        isOpen = state
        if isOpen then MainFrame.Visible=true; OpenBtn.Visible=false; TweenService:Create(UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Scale=1}):Play()
        else local tw=TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale=0}); tw:Play(); tw.Completed:Connect(function() MainFrame.Visible=false; OpenBtn.Visible=true end) end
    end
    
    local function ToggleLayout()
        isVertical = not isVertical
        if isVertical then 
            LayoutBtn.Text = "-"
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size=UDim2.new(0,220,0,400)}):Play()
            Sidebar.Size = UDim2.new(0,60,1,-35); Content.Size = UDim2.new(1,-60,1,-35); Content.Position = UDim2.new(0,60,0,35)
            MainFrame.Position = UDim2.new(0.5,-110,0.5,-200)
        else 
            LayoutBtn.Text = "+"
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size=UDim2.new(0,400,0,220)}):Play()
            Sidebar.Size = UDim2.new(0,110,1,-35); Content.Size = UDim2.new(1,-110,1,-35); Content.Position = UDim2.new(0,110,0,35)
            MainFrame.Position = UDim2.new(0.5,-200,0.5,-110)
        end
    end

    OpenBtn.MouseButton1Click:Connect(function() ToggleMenu(true) end)
    MinBtn.MouseButton1Click:Connect(function() ToggleMenu(false) end)
    LayoutBtn.MouseButton1Click:Connect(ToggleLayout)
    CloseX.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- FLY WIDGET
    local FW = Instance.new("Frame", ScreenGui); FW.Size=UDim2.new(0,130,0,45); FW.Position=UDim2.new(0.5,-65,0.15,0); FW.BackgroundColor3=Theme.Sidebar; FW.Visible=false; Instance.new("UICorner",FW).CornerRadius=UDim.new(0,8); Instance.new("UIStroke",FW).Color=Theme.Accent; Drag(FW); FlyWidgetFrame=FW
    local SL = Instance.new("TextLabel", FW); SL.Size=UDim2.new(1,0,0.4,0); SL.BackgroundTransparency=1; SL.Text="SPEED: 50"; SL.TextColor3=Theme.Text; SL.Font=Enum.Font.GothamBold; SL.TextSize=11
    local B1 = Instance.new("TextButton", FW); B1.Size=UDim2.new(0.4,0,0.5,0); B1.Position=UDim2.new(0.05,0,0.45,0); B1.BackgroundColor3=Theme.Button; B1.Text="-"; B1.TextColor3=Theme.Text; Instance.new("UICorner", B1)
    local B2 = Instance.new("TextButton", FW); B2.Size=UDim2.new(0.4,0,0.5,0); B2.Position=UDim2.new(0.55,0,0.45,0); B2.BackgroundColor3=Theme.Button; B2.Text="+"; B2.TextColor3=Theme.Text; Instance.new("UICorner", B2)
    B1.MouseButton1Click:Connect(function() Config.FlySpeed=math.max(10,Config.FlySpeed-25); SL.Text="SPEED: "..Config.FlySpeed end)
    B2.MouseButton1Click:Connect(function() Config.FlySpeed=Config.FlySpeed+25; SL.Text="SPEED: "..Config.FlySpeed end)

    -- MINI SAVE CP BUTTON (Floating)
    local MSC = Instance.new("TextButton", ScreenGui)
    MSC.Name = "MiniSaveBtn"
    MSC.Size = UDim2.new(0,80,0,30)
    MSC.Position = UDim2.new(0.8,0,0.3,0)
    MSC.BackgroundColor3 = Theme.Accent
    MSC.Text = "SaveCp"
    MSC.TextColor3 = Theme.Text
    MSC.Font = Enum.Font.GothamBold
    MSC.Visible = false
    Instance.new("UICorner", MSC).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", MSC).Color = Theme.Main
    Drag(MSC)
    SaveCpButton = MSC

    -- POPUP CONFIRMATION
    local Popup = Instance.new("Frame", ScreenGui); Popup.Size = UDim2.new(0,200,0,100); Popup.Position = UDim2.new(0.5,-100,0.5,-50); Popup.BackgroundColor3 = Theme.Main; Popup.Visible = false; Instance.new("UICorner", Popup).CornerRadius = UDim.new(0,10); Instance.new("UIStroke", Popup).Color = Theme.Accent
    local PTxt = Instance.new("TextLabel", Popup); PTxt.Size = UDim2.new(1,0,0.4,0); PTxt.BackgroundTransparency = 1; PTxt.Text = "Confirm Save CP?"; PTxt.TextColor3 = Theme.Text; PTxt.Font = Enum.Font.GothamBold
    local PYes = Instance.new("TextButton", Popup); PYes.Size = UDim2.new(0.4,0,0.3,0); PYes.Position = UDim2.new(0.05,0,0.5,0); PYes.BackgroundColor3 = Theme.Confirm; PYes.Text = "CONFIRM"; PYes.TextColor3 = Theme.Text; Instance.new("UICorner", PYes).CornerRadius = UDim.new(0,6)
    local PNo = Instance.new("TextButton", Popup); PNo.Size = UDim2.new(0.4,0,0.3,0); PNo.Position = UDim2.new(0.55,0,0.5,0); PNo.BackgroundColor3 = Theme.ButtonRed; PNo.Text = "CANCEL"; PNo.TextColor3 = Theme.Text; Instance.new("UICorner", PNo).CornerRadius = UDim.new(0,6)
    
    local PendingSaveAction = nil
    PNo.MouseButton1Click:Connect(function() Popup.Visible = false; PendingSaveAction = nil end)
    PYes.MouseButton1Click:Connect(function() if PendingSaveAction then PendingSaveAction() end; Popup.Visible = false end)

    local Tabs = {}
    function Library:Tab(n)
        local B = Instance.new("TextButton", Sidebar); B.Size=UDim2.new(0.85,0,0,28); B.BackgroundColor3=Theme.Button; B.Text=n; B.TextColor3=Color3.fromRGB(200,200,200); B.Font=Enum.Font.GothamBold; B.TextSize=10; Instance.new("UICorner",B).CornerRadius=UDim.new(0,6)
        local P = Instance.new("ScrollingFrame", Content); P.Size=UDim2.new(1,-5,1,0); P.BackgroundTransparency=1; P.ScrollBarThickness=2; P.Visible=false; P.AutomaticCanvasSize = Enum.AutomaticSize.Y; P.CanvasSize = UDim2.new(0,0,0,0)
        local L=Instance.new("UIListLayout", P); L.Padding=UDim.new(0,5)
        Instance.new("UIPadding", P).PaddingTop=UDim.new(0,5); Instance.new("UIPadding", P).PaddingLeft=UDim.new(0,5)
        
        B.MouseButton1Click:Connect(function() 
            for _,t in pairs(Tabs) do t.P.Visible=false; t.B.BackgroundColor3=Theme.Button; t.B.TextColor3=Color3.fromRGB(200,200,200) end
            P.Visible=true; B.BackgroundColor3=Theme.Accent; B.TextColor3=Color3.new(1,1,1) 
        end)
        table.insert(Tabs, {P=P, B=B})
        
        local E = {}
        function E:Button(t, c, f) 
            local b=Instance.new("TextButton",P); b.Size=UDim2.new(1,0,0,26); b.BackgroundColor3=c or Theme.Button; b.Text=t; b.TextColor3=Color3.new(1,1,1); b.Font=Enum.Font.Gotham; b.TextSize=11; Instance.new("UICorner",b).CornerRadius=UDim.new(0,6); 
            b.MouseButton1Click:Connect(function() pcall(f) end) 
        end
        function E:Toggle(t, f) local fr=Instance.new("Frame",P); fr.Size=UDim2.new(1,0,0,26); fr.BackgroundColor3=Theme.Button; Instance.new("UICorner",fr).CornerRadius=UDim.new(0,6); local l=Instance.new("TextLabel",fr); l.Size=UDim2.new(0.65,0,1,0); l.Position=UDim2.new(0.05,0,0,0); l.BackgroundTransparency=1; l.Text=t; l.TextColor3=Color3.new(1,1,1); l.TextXAlignment=Enum.TextXAlignment.Left; l.Font=Enum.Font.Gotham; l.TextSize=11; local b=Instance.new("TextButton",fr); b.Size=UDim2.new(0,30,0,18); b.Position=UDim2.new(0.75,0,0.15,0); b.BackgroundColor3=Color3.fromRGB(60,60,60); b.Text=""; Instance.new("UICorner",b).CornerRadius=UDim.new(1,0); local s=false; b.MouseButton1Click:Connect(function() s=not s; b.BackgroundColor3=s and Theme.Accent or Color3.fromRGB(60,60,60); f(s) end) end
        function E:Input(p, f) local fr=Instance.new("Frame",P); fr.Size=UDim2.new(1,0,0,26); fr.BackgroundColor3=Color3.fromRGB(35,35,35); Instance.new("UICorner",fr).CornerRadius=UDim.new(0,6); local bx=Instance.new("TextBox",fr); bx.Size=UDim2.new(0.9,0,1,0); bx.Position=UDim2.new(0.05,0,0,0); bx.BackgroundTransparency=1; bx.Text=""; bx.PlaceholderText=p; bx.TextColor3=Color3.new(1,1,1); bx.Font=Enum.Font.Gotham; bx.TextSize=11; bx:GetPropertyChangedSignal("Text"):Connect(function() f(bx.Text) end) end
        function E:Label(t) local l=Instance.new("TextLabel",P); l.Size=UDim2.new(1,0,0,20); l.BackgroundTransparency=1; l.Text=t; l.TextColor3=Theme.Accent; l.Font=Enum.Font.GothamBold; l.TextSize=10; l.TextXAlignment=Enum.TextXAlignment.Left; table.insert(UIRefs.ActiveButtons, l) -- Hack to update label color
            spawn(function() while l.Parent do l.TextColor3 = Theme.Accent; wait(0.2) end end)
        end
        function E:Container(h) local c=Instance.new("ScrollingFrame",P); c.Size=UDim2.new(1,0,0,h); c.BackgroundColor3=Color3.fromRGB(25,25,25); c.ScrollBarThickness=2; Instance.new("UICorner",c).CornerRadius=UDim.new(0,6); local l=Instance.new("UIListLayout",c); l.Padding=UDim.new(0,2); c.AutomaticCanvasSize = Enum.AutomaticSize.Y; return c end
        function E:Slider(t,min,max,f) local fr=Instance.new("Frame",P);fr.Size=UDim2.new(1,0,0,32);fr.BackgroundColor3=Theme.Button;Instance.new("UICorner",fr).CornerRadius=UDim.new(0,6);local l=Instance.new("TextLabel",fr);l.Size=UDim2.new(1,0,0.5,0);l.Position=UDim2.new(0.05,0,0,0);l.BackgroundTransparency=1;l.Text=t;l.TextColor3=Color3.new(1,1,1);l.TextSize=10;l.TextXAlignment=Enum.TextXAlignment.Left;local b=Instance.new("TextButton",fr);b.Size=UDim2.new(0.9,0,0.3,0);b.Position=UDim2.new(0.05,0,0.6,0);b.BackgroundColor3=Color3.fromRGB(30,30,30);b.Text="";local fil=Instance.new("Frame",b);fil.Size=UDim2.new(0,0,1,0);fil.BackgroundColor3=Theme.Accent;b.MouseButton1Down:Connect(function() local m;m=RunService.RenderStepped:Connect(function() local s=math.clamp((UserInputService:GetMouseLocation().X-b.AbsolutePosition.X)/b.AbsoluteSize.X,0,1);fil.Size=UDim2.new(s,0,1,0);f(min+(max-min)*s);if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then m:Disconnect() end end) end)
            spawn(function() while fil.Parent do fil.BackgroundColor3 = Theme.Accent; wait(0.2) end end)
        end
        
        function Library:ShowPopup(callback)
            PendingSaveAction = callback
            Popup.Visible = true
        end
        return E
    end
    return Library
end

local UI = Library:Create()

-- >>> 0. ABOUT TAB <<<
local About = UI:Tab("About")
About:Label("Developer Info")
local function LinkBtn(txt, link)
    About:Button(txt, Theme.ButtonDark, function()
        setclipboard(link)
        StarterGui:SetCore("SendNotification", {Title="Link Copied", Text=txt})
        if link:find("http") then 
            pcall(function() game:OpenScreenshotsFolder() end) 
        end
    end)
end
LinkBtn("WhatsApp", "https://wa.me/628123456789") 
LinkBtn("GitHub", "https://github.com/Vanzy")
LinkBtn("Telegram", "https://t.me/Vanzy")
LinkBtn("Discord", "https://discord.gg/Vanzy")

-- >>> 1. MOVEMENT <<<
local Mov = UI:Tab("Movement")
Mov:Label("Flight & Speed")
Mov:Toggle("Fly (Menu)", function(s) Config.Flying=s; FlyWidgetFrame.Visible=s; if s then spawn(function() local bg=Instance.new("BodyGyro",LocalPlayer.Character.HumanoidRootPart);bg.P=9e4;local bv=Instance.new("BodyVelocity",LocalPlayer.Character.HumanoidRootPart);bv.MaxForce=Vector3.new(9e9,9e9,9e9);while Config.Flying do LocalPlayer.Character.Humanoid.PlatformStand=true;bg.CFrame=Camera.CFrame;bv.Velocity=LocalPlayer.Character.Humanoid.MoveDirection.Magnitude>0 and Camera.CFrame.LookVector*Config.FlySpeed or Vector3.zero;RunService.RenderStepped:Wait() end;LocalPlayer.Character.Humanoid.PlatformStand=false;bg:Destroy();bv:Destroy() end) end end)
Mov:Toggle("Speed Hack", function(s) Config.SpeedHack=s; spawn(function() while Config.SpeedHack do LocalPlayer.Character.Humanoid.WalkSpeed=Config.SpeedVal;wait() end;LocalPlayer.Character.Humanoid.WalkSpeed=16 end) end)
Mov:Slider("Speed Value", 16, 200, function(v) Config.SpeedVal=v end)

Mov:Label("Jump Modifiers")
Mov:Toggle("Infinite Jump", function(s) Config.InfJump=s end)
UserInputService.JumpRequest:Connect(function() if Config.InfJump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)
Mov:Toggle("High Jump", function(s) Config.HighJump=s; LocalPlayer.Character.Humanoid.JumpPower=s and 100 or 50 end)

Mov:Toggle("Hold-to-Jump (Mobile)", function(s) Config.HoldJump = s; if not s then Config.HoldPower = 0 end end)
Mov:Slider("Max Hold Power", 50, 300, function(v) Config.MaxHoldPower = v end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if Config.HoldJump and (input.UserInputType == Enum.UserInputType.Touch or input.KeyCode == Enum.KeyCode.Space) then
        Config.Charging = true; Config.HoldPower = 0
        spawn(function() while Config.Charging and Config.HoldJump do Config.HoldPower = math.min(Config.HoldPower + 5, Config.MaxHoldPower); StarterGui:SetCore("SendNotification", {Title="Charging...", Text="Power: "..Config.HoldPower, Duration=0.2}); wait(0.05) end end)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if Config.HoldJump and (input.UserInputType == Enum.UserInputType.Touch or input.KeyCode == Enum.KeyCode.Space) then
        Config.Charging = false; if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then local Hum = LocalPlayer.Character.Humanoid; Hum.JumpPower = math.max(50, Config.HoldPower); Hum:ChangeState(Enum.HumanoidStateType.Jumping); wait(0.2); Hum.JumpPower = 50 end
    end
end)

Mov:Label("Utility")
Mov:Toggle("Noclip", function(s) Config.Noclip=s; RunService.Stepped:Connect(function() if Config.Noclip then for _,v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end end end) end)
Mov:Toggle("Wall Climb (Spider)", function(s) Config.WallClimb=s; if s then local b=Instance.new("BodyVelocity",LocalPlayer.Character.HumanoidRootPart);b.MaxForce=Vector3.zero;RunService.RenderStepped:Connect(function() if Config.WallClimb then local r=Ray.new(LocalPlayer.Character.HumanoidRootPart.Position,LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector*2);if workspace:FindPartOnRay(r,LocalPlayer.Character) then b.MaxForce=Vector3.new(0,9e9,0);b.Velocity=Vector3.new(0,20,0) else b.MaxForce=Vector3.zero end else b:Destroy() end end) end end)

-- >>> 2. SAVE / LOAD CP (UPDATED SCROLL FIX) <<<
local CP_UI = UI:Tab("S/L CP")

-- HELPER FOR AUTO SAVE
local function GetMapID() return tostring(game.PlaceId) end
local function GetMapName()
    local success, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
    if success and info then return info.Name else return "Unknown Map" end
end
local function LoadAutoCPData()
    if isfile(AutoCPFile) then return HttpService:JSONDecode(readfile(AutoCPFile)) end
    return {}
end
local function SaveAutoCPData(data) writefile(AutoCPFile, HttpService:JSONEncode(data)) end

-- LOGIC FOR MINI BUTTON
local function ExecuteAutoSave()
    local Data = LoadAutoCPData()
    local ID = GetMapID()
    local Name = GetMapName()
    
    if not Data[ID] then Data[ID] = {MapName = Name, CPs = {}} end
    
    local Count = #Data[ID].CPs
    local NextName = (Count == 0) and "Spawn" or "CP" .. tostring(Count)
    local Pos = LocalPlayer.Character.HumanoidRootPart.Position
    
    table.insert(Data[ID].CPs, {Name = NextName, X = Pos.X, Y = Pos.Y, Z = Pos.Z})
    SaveAutoCPData(Data)
    StarterGui:SetCore("SendNotification", {Title="Auto Save", Text="Saved: "..NextName})
end

SaveCpButton.MouseButton1Click:Connect(function()
    Library:ShowPopup(ExecuteAutoSave)
end)

CP_UI:Label("Auto Save System")
CP_UI:Toggle("Enable Auto Save CP", function(s)
    Config.AutoSaveCP = s
    SaveCpButton.Visible = s
    if s then StarterGui:SetCore("SendNotification", {Title="System", Text="Mini Button Enabled"}) end
end)

CP_UI:Label("Load CheckSpawn")
local AutoLoadContainer = CP_UI:Container(150)

local function RefreshAutoMaps()
    for _,v in pairs(AutoLoadContainer:GetChildren()) do if v:IsA("TextButton") or v:IsA("Frame") or v:IsA("TextLabel") then v:Destroy() end end
    local Data = LoadAutoCPData()
    
    local CurrID = GetMapID()
    if Data[CurrID] then
        local Lbl = Instance.new("TextLabel", AutoLoadContainer); Lbl.Size=UDim2.new(1,0,0,20); Lbl.BackgroundTransparency=1; Lbl.Text="Current Map: "..Data[CurrID].MapName; Lbl.TextColor3=Color3.fromRGB(100,255,100); Lbl.Font=Enum.Font.GothamBold; Lbl.TextSize=10
    end
    
    for id, mapData in pairs(Data) do
        local Btn = Instance.new("TextButton", AutoLoadContainer); Btn.Size=UDim2.new(1,0,0,25); Btn.BackgroundColor3=Theme.ButtonDark; Btn.Text="📂 " .. mapData.MapName; Btn.TextColor3=Theme.Accent; Instance.new("UICorner", Btn)
        Btn.MouseButton1Click:Connect(function()
            -- Show CPs for this map
            for _,v in pairs(AutoLoadContainer:GetChildren()) do if v:IsA("TextButton") and v.Name~="Back" then v:Destroy() end end
            local Back = Instance.new("TextButton", AutoLoadContainer); Back.Name="Back"; Back.Size=UDim2.new(1,0,0,20); Back.BackgroundColor3=Theme.ButtonRed; Back.Text="< Back"; Back.TextColor3=Theme.Text; Back.MouseButton1Click:Connect(RefreshAutoMaps)
            
            for _, cp in ipairs(mapData.CPs) do
                local CPBtn = Instance.new("TextButton", AutoLoadContainer); CPBtn.Size=UDim2.new(1,0,0,25); CPBtn.BackgroundColor3=Theme.Button; CPBtn.Text="📍 " .. cp.Name; CPBtn.TextColor3=Theme.Text
                CPBtn.MouseButton1Click:Connect(function()
                     if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(cp.X, cp.Y + 3, cp.Z)
                    end
                end)
            end
            -- FIX: MANUALLY UPDATE CANVAS SIZE FOR DEEP LISTS
            AutoLoadContainer.CanvasSize = UDim2.new(0, 0, 0, AutoLoadContainer.UIListLayout.AbsoluteContentSize.Y + 50)
        end)
    end
    -- FIX: INITIAL UPDATE CANVAS SIZE
    wait(0.1)
    AutoLoadContainer.CanvasSize = UDim2.new(0, 0, 0, AutoLoadContainer.UIListLayout.AbsoluteContentSize.Y + 50)
end
CP_UI:Button("Refresh Maps", Theme.ButtonDark, RefreshAutoMaps)


-- MANUAL SYSTEM (OLD)
CP_UI:Label("Manual Save System (JSON)")
local InputMap = ""
local InputCP = ""
CP_UI:Input("Map Name (e.g. TowerHell)", function(t) InputMap = t end)
CP_UI:Input("CP Name (e.g. Spawn, CP1)", function(t) InputCP = t end)

local function GetCPData() if isfile(CPFileName) then return HttpService:JSONDecode(readfile(CPFileName)) end return {} end
local function SaveCPData(data) writefile(CPFileName, HttpService:JSONEncode(data)) end

CP_UI:Button("SAVE CURRENT POS", Theme.Accent, function()
    if InputMap == "" or InputCP == "" then StarterGui:SetCore("SendNotification", {Title="Error", Text="Enter Map & CP Name!"}) return end
    local Data = GetCPData()
    if not Data[InputMap] then Data[InputMap] = {} end
    local Pos = LocalPlayer.Character.HumanoidRootPart.Position
    Data[InputMap][InputCP] = {x = Pos.X, y = Pos.Y, z = Pos.Z}
    SaveCPData(Data)
    StarterGui:SetCore("SendNotification", {Title="Success", Text="Saved: "..InputCP})
end)

-- >>> 3. VISUALS (Existing) <<<
local Vis = UI:Tab("Visuals")
Vis:Label("Basic ESP")
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

-- >>> 4. TOOLS (Existing) <<<
local Tool = UI:Tab("Tools")
Tool:Toggle("Invisible", function(s) if s then LocalPlayer.Character.HumanoidRootPart.Transparency=1; for _,v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency=1 end end else LocalPlayer.Character.HumanoidRootPart.Transparency=1; for _,v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("BasePart") and v.Name~="HumanoidRootPart" then v.Transparency=0 end end end end)
Tool:Toggle("Fling Aura", function(s) Config.FlingAura=s; if s then local fa = Instance.new("Part", LocalPlayer.Character); fa.Name="AuraRing"; fa.Size=Vector3.new(10,1,10); fa.Transparency=0.5; fa.BrickColor=BrickColor.new("Really red"); fa.Material=Enum.Material.Neon; fa.CanCollide=false; fa.Anchored=true; spawn(function() while Config.FlingAura and LocalPlayer.Character do if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then fa.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-3,0) * CFrame.Angles(0,tick(),0); for _,p in pairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then local r=p.Character:FindFirstChild("HumanoidRootPart"); if r and (r.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then r.AssemblyLinearVelocity=Vector3.new(0,500,0); r.AssemblyAngularVelocity=Vector3.new(1000,1000,1000) end end end end; wait(0.1) end; fa:Destroy() end) end end)
Tool:Toggle("Anti Void", function(s) Config.AntiVoid=s; spawn(function() while Config.AntiVoid do local c=LocalPlayer.Character; if c and c:FindFirstChild("HumanoidRootPart") then local r=Ray.new(c.HumanoidRootPart.Position,Vector3.new(0,-10,0)); if workspace:FindPartOnRay(r,c) then Config.LastGroundPos=c.HumanoidRootPart.CFrame elseif c.HumanoidRootPart.Position.Y<-50 and Config.LastGroundPos then c.HumanoidRootPart.CFrame=Config.LastGroundPos+Vector3.new(0,5,0);c.HumanoidRootPart.Velocity=Vector3.zero end end; wait(0.1) end end) end)
Tool:Toggle("Air Jump", function(s) Config.AirJump=s; UserInputService.JumpRequest:Connect(function() if Config.AirJump and LocalPlayer.Character then LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end) end)
Tool:Button("Click Delete Tool", Theme.ButtonRed, function() local t=Instance.new("Tool",LocalPlayer.Backpack); t.Name="Delete"; t.RequiresHandle=false; t.TextureId="rbxassetid://881355752"; t.Activated:Connect(function() if Mouse.Target then Mouse.Target:Destroy() end end) end)

-- >>> 5. AURAS (FIXED & ELEGANT) <<<
local AT = UI:Tab("Auras")
local function LoadAuraFixed(id)
    StarterGui:SetCore("SendNotification", {Title="Loading", Text="Fetching Aura..."})
    local s, asset = pcall(function() return game:GetObjects("rbxassetid://"..id)[1] end)
    if not s or not asset then StarterGui:SetCore("SendNotification", {Title="Error", Text="Failed to load ID"}); return end
    
    if LocalPlayer.Character:FindFirstChild("VanzyAura") then LocalPlayer.Character.VanzyAura:Destroy() end
    
    asset.Name = "VanzyAura"
    asset.Parent = LocalPlayer.Character
    
    for _, v in pairs(asset:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false; v.Anchored = false; v.Massless = true
            v.Transparency = 1 
        elseif v:IsA("Decal") then
            v.Transparency = 1
        elseif v:IsA("Humanoid") then
            v:Destroy() 
        end
    end
    
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local pp = asset:IsA("Model") and asset.PrimaryPart or asset:FindFirstChild("HumanoidRootPart") or asset:FindFirstChildWhichIsA("BasePart")
    
    if root and pp then 
        pp.CFrame = root.CFrame
        local w = Instance.new("WeldConstraint", pp); w.Part0 = root; w.Part1 = pp
    else 
        for _, v in pairs(asset:GetChildren()) do 
            if v:IsA("BasePart") then 
                v.CFrame = root.CFrame
                local w = Instance.new("WeldConstraint", v); w.Part0 = root; w.Part1 = v 
            end 
        end 
    end
end

AT:Button("Remove Aura", Theme.ButtonRed, function() if LocalPlayer.Character:FindFirstChild("VanzyAura") then LocalPlayer.Character.VanzyAura:Destroy() end end)
AT:Button("Killer Red", Theme.ButtonDark, function() LoadAuraFixed("74417067882526") end)
AT:Button("Super Saiyan", Theme.ButtonDark, function() LoadAuraFixed("10545989953") end)
AT:Button("Dark Aura", Theme.ButtonDark, function() LoadAuraFixed("72031022600603") end)
AT:Button("Blue Aura", Theme.ButtonDark, function() LoadAuraFixed("14645384079") end)

-- >>> 6. WORLD (FIXED SKY) <<<
local World = UI:Tab("World")
local function SetSkyFixed(id)
    pcall(function()
        -- FIX: CLEAR EXISTING LIGHTING EFFECTS THAT BLOCK SKY
        for _,v in pairs(Lighting:GetChildren()) do 
            if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") then v:Destroy() end 
        end
        
        local s = Instance.new("Sky")
        s.Name = "VanzySky"
        s.SkyboxBk = "rbxassetid://"..id
        s.SkyboxDn = "rbxassetid://"..id
        s.SkyboxFt = "rbxassetid://"..id
        s.SkyboxLf = "rbxassetid://"..id
        s.SkyboxRt = "rbxassetid://"..id
        s.SkyboxUp = "rbxassetid://"..id
        s.Parent = Lighting
        
        StarterGui:SetCore("SendNotification", {Title="World", Text="Sky Applied!"})
    end)
end

World:Button("Reset Sky", Theme.ButtonRed, function() if Lighting:FindFirstChild("VanzySky") then Lighting.VanzySky:Destroy() end end)
World:Button("Galaxy Sky", Theme.ButtonDark, function() SetSkyFixed("11284918730") end)
World:Button("Cartoon Sky", Theme.ButtonDark, function() SetSkyFixed("15313376186") end)
World:Button("Purple Sky", Theme.ButtonDark, function() SetSkyFixed("5094389324") end)
World:Button("Night Sky", Theme.ButtonDark, function() SetSkyFixed("10644495614") end)

-- >>> 7. WEAPONS <<<
local Wep = UI:Tab("Weapons")
local function GiveWeapon(id)
    StarterGui:SetCore("SendNotification", {Title="Weapons", Text="Equipping..."})
    local s, items = pcall(function() return game:GetObjects("rbxassetid://"..id) end)
    if s and items then
        for _, item in pairs(items) do
            if item:IsA("Tool") then
                item.Parent = LocalPlayer.Backpack
            end
        end
    else
        StarterGui:SetCore("SendNotification", {Title="Error", Text="Invalid ID"})
    end
end
Wep:Button("Linked Sword", Theme.ButtonDark, function() GiveWeapon("125013769") end)
Wep:Button("Darkheart", Theme.ButtonDark, function() GiveWeapon("16895215") end)
Wep:Button("Illumina", Theme.ButtonDark, function() GiveWeapon("16641274") end)
Wep:Button("Hyperlaser", Theme.ButtonDark, function() GiveWeapon("130113146") end)

-- >>> 8. AUTO CP (SCANNER) <<<
local CPTab = UI:Tab("Map Scan")
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
            local b=Instance.new("TextButton",CPContainer);b.Size=UDim2.new(1,0,0,25);b.BackgroundColor3=Theme.Button;b.Text=p.Name;b.TextColor3=Color3.new(1,1,1);Instance.new("UICorner",b).CornerRadius=UDim.new(0,4)
            b.MouseButton1Click:Connect(function() LocalPlayer.Character:MoveTo(p.Position+Vector3.new(0,3,0)) end)
        end
        -- FIX: UPDATE CANVAS SIZE
        CPContainer.CanvasSize = UDim2.new(0, 0, 0, CPContainer.UIListLayout.AbsoluteContentSize.Y + 50)
    else StarterGui:SetCore("SendNotification",{Title="Scan", Text="No Checkpoints"}) end
end
CPTab:Button("SCAN MAP NOW", Theme.Accent, ScanMap)
CPContainer = CPTab:Container(120)

-- >>> 9. SETTINGS & THEME <<<
local Set = UI:Tab("Settings")
Set:Input("Change Menu Title...", function(t) Config.MenuTitle=t; UIRefs.Title.Text=t end)
Set:Input("Set Rank Tag...", function(t) local bb=Instance.new("BillboardGui",LocalPlayer.Character.Head);bb.Size=UDim2.new(0,100,0,50);bb.StudsOffset=Vector3.new(0,3,0);bb.AlwaysOnTop=true;local l=Instance.new("TextLabel",bb);l.Size=UDim2.new(1,0,1,0);l.BackgroundTransparency=1;l.Text="["..t.."]";l.TextColor3=Color3.fromRGB(255,0,0);l.TextStrokeTransparency=0 end)

Set:Label("Theme Settings")
Set:Toggle("Rainbow Mode", function(s) Config.RainbowTheme = s end)

Set:Label("Custom Color (RGB)")
local R, G, B = 160, 32, 240
Set:Slider("Red", 0, 255, function(v) R=v; Config.CustomColor = Color3.fromRGB(R, G, B) end)
Set:Slider("Green", 0, 255, function(v) G=v; Config.CustomColor = Color3.fromRGB(R, G, B) end)
Set:Slider("Blue", 0, 255, function(v) B=v; Config.CustomColor = Color3.fromRGB(R, G, B) end)

Set:Label("Performance")
Set:Toggle("FPS Booster", function(s) 
    Config.FPSBoost = s
    if s then
        for _,v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic; v.Reflectance = 0; v.CastShadow = false
            elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end
        end
    end
end)
Set:Button("Rejoin Server", Theme.ButtonDark, function() TeleportService:Teleport(game.PlaceId) end)

-- ANTI AFK
local vu = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function() vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame); wait(1); vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end)

StarterGui:SetCore("SendNotification", {Title="Vanzyxxx", Text="Welcome To Script"})
