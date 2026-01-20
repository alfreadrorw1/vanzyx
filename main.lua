--[[
    PROJECT: VANZYXXX V22 FINAL (MAXIMUM)
    STATUS: ALL ASSETS ADDED + SPLIT TABS
    PLATFORM: MOBILE ONLY (Android/iOS)
    DEV: Gemini AI
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

--------------------------------------------------------------------------------
-- [LOGO SYSTEM]
--------------------------------------------------------------------------------
local LogoURL = "https://files.catbox.moe/bm2fcp.jpg"
local LocalPath = "VanzyLogoV22.jpg"
pcall(function() if not isfile(LocalPath) then writefile(LocalPath, game:HttpGet(LogoURL)) end end)
local FinalLogo = (getcustomasset and isfile(LocalPath)) and getcustomasset(LocalPath) or LogoURL

--------------------------------------------------------------------------------
-- [GLOBAL CONFIG]
--------------------------------------------------------------------------------
local Config = {
    -- Movement
    FlySpeed = 50, Flying = false, Noclip = false, InfJump = false, AutoJump = false,
    WallClimb = false, SpinBot = false, SpeedHack = false, SpeedVal = 50,
    JesusMode = false, HighJump = false, SwimMode = false, Phase = false, SafeWalk = false,
    
    -- Visuals
    ESP_Box = false, ESP_Name = false, ESP_Chams = false, ESP_Tracer = false,
    ESP_Health = false, ESP_Distance = false, RainbowChams = false,
    FullBright = false, XRay = false,
    
    -- Tools/Obby
    AntiVoid = false, AirJump = false, AntiSlip = false, ChatSpy = false, Invisible = false,
    FlingAura = false, AutoFarmTouch = false, LagSwitch = false, ClickDelete = false,
    
    -- Settings
    MenuTitle = "VANZY V22 MAX"
}

local UIRefs = { MainFrame = nil, Sidebar = nil, Content = nil, Title = nil }

local function GetGuiParent()
    if gethui then return gethui() end
    if syn and syn.protect_gui then local sg = Instance.new("ScreenGui"); syn.protect_gui(sg); sg.Parent = CoreGui; return sg end
    return CoreGui
end

--------------------------------------------------------------------------------
-- [UI ENGINE]
--------------------------------------------------------------------------------
local Library = {}
local FlyWidgetFrame = nil

function Library:Create()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VanzyV22_Max"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = GetGuiParent()
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- OPEN BUTTON
    local OpenBtn = Instance.new("ImageButton", ScreenGui); OpenBtn.Name="Open"; OpenBtn.Size=UDim2.new(0,50,0,50); OpenBtn.Position=UDim2.new(0.05,0,0.2,0); OpenBtn.BackgroundColor3=Color3.new(0,0,0); OpenBtn.Image=FinalLogo; Instance.new("UICorner",OpenBtn).CornerRadius=UDim.new(1,0); local OS=Instance.new("UIStroke",OpenBtn); OS.Color=Color3.fromRGB(140,0,255); OS.Thickness=2

    -- MAIN FRAME
    local MainFrame = Instance.new("Frame", ScreenGui); MainFrame.Name="Main"; MainFrame.Size=UDim2.new(0,380,0,190); MainFrame.Position=UDim2.new(0.5,-190,0.5,-95); MainFrame.BackgroundColor3=Color3.fromRGB(20,20,20); MainFrame.ClipsDescendants=true; MainFrame.Visible=false; Instance.new("UICorner",MainFrame).CornerRadius=UDim.new(0,10); local MS=Instance.new("UIStroke",MainFrame); MS.Color=Color3.fromRGB(140,0,255); MS.Thickness=2
    UIRefs.MainFrame = MainFrame
    
    local UIScale = Instance.new("UIScale", MainFrame); UIScale.Scale = 0

    -- TITLE
    local Title = Instance.new("TextLabel", MainFrame); Title.Size=UDim2.new(1,-100,0,25); Title.Position=UDim2.new(0,5,0,0); Title.BackgroundTransparency=1; Title.Text=Config.MenuTitle; Title.Font=Enum.Font.GothamBlack; Title.TextSize=14; Title.TextXAlignment = Enum.TextXAlignment.Left; UIRefs.Title = Title
    spawn(function() local t=0; while true do t=t+0.01; if t>1 then t=0 end; Title.TextColor3=Color3.fromHSV(t,1,1); wait(0.05) end end)

    ----------------------------------------------------------------------------
    -- [TOP BAR BUTTONS]
    ----------------------------------------------------------------------------
    local BtnContainer = Instance.new("Frame", MainFrame)
    BtnContainer.Size = UDim2.new(0, 90, 0, 25)
    BtnContainer.Position = UDim2.new(1, -95, 0, 0)
    BtnContainer.BackgroundTransparency = 1

    local CloseX = Instance.new("TextButton", BtnContainer); CloseX.Size=UDim2.new(0,25,0,25); CloseX.Position=UDim2.new(1,-25,0,0); CloseX.BackgroundTransparency=1; CloseX.Text="X"; CloseX.TextColor3=Color3.fromRGB(255,50,50); CloseX.Font=Enum.Font.GothamBlack; CloseX.TextSize=16
    local LayoutBtn = Instance.new("TextButton", BtnContainer); LayoutBtn.Size=UDim2.new(0,25,0,25); LayoutBtn.Position=UDim2.new(1,-50,0,0); LayoutBtn.BackgroundTransparency=1; LayoutBtn.Text="+"; LayoutBtn.TextColor3=Color3.fromRGB(255,200,50); LayoutBtn.Font=Enum.Font.GothamBlack; LayoutBtn.TextSize=18
    local MinBtn = Instance.new("TextButton", BtnContainer); MinBtn.Size=UDim2.new(0,25,0,25); MinBtn.Position=UDim2.new(1,-75,0,0); MinBtn.BackgroundTransparency=1; MinBtn.Text="_"; MinBtn.TextColor3=Color3.fromRGB(50,200,255); MinBtn.Font=Enum.Font.GothamBlack; MinBtn.TextSize=16

    -- CONFIRMATION POPUP
    local ConfirmFrame = Instance.new("Frame", ScreenGui); ConfirmFrame.Size=UDim2.new(0,200,0,100); ConfirmFrame.Position=UDim2.new(0.5,-100,0.5,-50); ConfirmFrame.BackgroundColor3=Color3.fromRGB(30,30,30); ConfirmFrame.Visible=false; ConfirmFrame.ZIndex=10; Instance.new("UICorner",ConfirmFrame); Instance.new("UIStroke",ConfirmFrame).Color=Color3.fromRGB(255,50,50)
    local CTxt = Instance.new("TextLabel",ConfirmFrame); CTxt.Size=UDim2.new(1,0,0.5,0); CTxt.BackgroundTransparency=1; CTxt.Text="Close Window & Destroy?"; CTxt.TextColor3=Color3.new(1,1,1); CTxt.Font=Enum.Font.GothamBold; CTxt.TextSize=12; CTxt.ZIndex=11
    local CYes = Instance.new("TextButton",ConfirmFrame); CYes.Size=UDim2.new(0.4,0,0.3,0); CYes.Position=UDim2.new(0.05,0,0.6,0); CYes.BackgroundColor3=Color3.fromRGB(200,50,50); CYes.Text="YES"; CYes.TextColor3=Color3.new(1,1,1); Instance.new("UICorner",CYes); CYes.ZIndex=11
    local CNo = Instance.new("TextButton",ConfirmFrame); CNo.Size=UDim2.new(0.4,0,0.3,0); CNo.Position=UDim2.new(0.55,0,0.6,0); CNo.BackgroundColor3=Color3.fromRGB(50,200,50); CNo.Text="CANCEL"; CNo.TextColor3=Color3.new(1,1,1); Instance.new("UICorner",CNo); CNo.ZIndex=11

    -- SIDEBAR & CONTENT
    local Sidebar = Instance.new("ScrollingFrame", MainFrame); Sidebar.Size=UDim2.new(0,100,1,-25); Sidebar.Position=UDim2.new(0,0,0,25); Sidebar.BackgroundColor3=Color3.fromRGB(30,30,30); Sidebar.ScrollBarThickness=0
    UIRefs.Sidebar = Sidebar
    local SideLayout = Instance.new("UIListLayout", Sidebar); SideLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center; SideLayout.Padding=UDim.new(0,5); Instance.new("UIPadding", Sidebar).PaddingTop=UDim.new(0,5)

    local Content = Instance.new("Frame", MainFrame); Content.Size=UDim2.new(1,-100,1,-25); Content.Position=UDim2.new(0,100,0,25); Content.BackgroundTransparency=1
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
        if isVertical then LayoutBtn.Text="-"; TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size=UDim2.new(0,200,0,350)}):Play(); Sidebar.Size=UDim2.new(0,70,1,-25); Content.Size=UDim2.new(1,-70,1,-25); Content.Position=UDim2.new(0,70,0,25); MainFrame.Position=UDim2.new(0.5,-100,0.5,-175)
        else LayoutBtn.Text="+"; TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size=UDim2.new(0,380,0,190)}):Play(); Sidebar.Size=UDim2.new(0,100,1,-25); Content.Size=UDim2.new(1,-100,1,-25); Content.Position=UDim2.new(0,100,0,25); MainFrame.Position=UDim2.new(0.5,-190,0.5,-95) end
    end

    OpenBtn.MouseButton1Click:Connect(function() ToggleMenu(true) end)
    MinBtn.MouseButton1Click:Connect(function() ToggleMenu(false) end)
    LayoutBtn.MouseButton1Click:Connect(ToggleLayout)
    CloseX.MouseButton1Click:Connect(function() ConfirmFrame.Visible = true end)
    CYes.MouseButton1Click:Connect(function() ScreenGui:Destroy(); Config.Flying=false; Config.FlingAura=false; end)
    CNo.MouseButton1Click:Connect(function() ConfirmFrame.Visible = false end)

    -- FLY WIDGET
    local FW = Instance.new("Frame", ScreenGui); FW.Size=UDim2.new(0,120,0,40); FW.Position=UDim2.new(0.5,-60,0.15,0); FW.BackgroundColor3=Color3.fromRGB(25,25,25); FW.Visible=false; Instance.new("UICorner",FW).CornerRadius=UDim.new(0,6); Instance.new("UIStroke",FW).Color=Color3.fromRGB(140,0,255); Drag(FW); FlyWidgetFrame=FW
    local SL = Instance.new("TextLabel", FW); SL.Size=UDim2.new(1,0,0.4,0); SL.BackgroundTransparency=1; SL.Text="SPEED: 50"; SL.TextColor3=Color3.new(1,1,1); SL.Font=Enum.Font.GothamBold; SL.TextSize=10
    local B1 = Instance.new("TextButton", FW); B1.Size=UDim2.new(0.4,0,0.5,0); B1.Position=UDim2.new(0.05,0,0.45,0); B1.BackgroundColor3=Color3.fromRGB(50,50,50); B1.Text="-"; B1.TextColor3=Color3.new(1,1,1); Instance.new("UICorner", B1)
    local B2 = Instance.new("TextButton", FW); B2.Size=UDim2.new(0.4,0,0.5,0); B2.Position=UDim2.new(0.55,0,0.45,0); B2.BackgroundColor3=Color3.fromRGB(50,50,50); B2.Text="+"; B2.TextColor3=Color3.new(1,1,1); Instance.new("UICorner", B2)
    B1.MouseButton1Click:Connect(function() Config.FlySpeed=math.max(10,Config.FlySpeed-50); SL.Text="SPEED: "..Config.FlySpeed end)
    B2.MouseButton1Click:Connect(function() Config.FlySpeed=Config.FlySpeed+50; SL.Text="SPEED: "..Config.FlySpeed end)

    local Tabs = {}
    function Library:Tab(n)
        local B = Instance.new("TextButton", Sidebar); B.Size=UDim2.new(0.9,0,0,25); B.BackgroundColor3=Color3.fromRGB(40,40,40); B.Text=n; B.TextColor3=Color3.fromRGB(200,200,200); B.Font=Enum.Font.GothamBold; B.TextSize=10; Instance.new("UICorner",B).CornerRadius=UDim.new(0,4)
        local P = Instance.new("ScrollingFrame", Content); P.Size=UDim2.new(1,-5,1,0); P.BackgroundTransparency=1; P.ScrollBarThickness=2; P.Visible=false; 
        P.AutomaticCanvasSize = Enum.AutomaticSize.Y
        P.CanvasSize = UDim2.new(0,0,0,0)
        local L=Instance.new("UIListLayout", P); L.Padding=UDim.new(0,4)
        Instance.new("UIPadding", P).PaddingTop=UDim.new(0,5); Instance.new("UIPadding", P).PaddingLeft=UDim.new(0,5)

        B.MouseButton1Click:Connect(function() for _,t in pairs(Tabs) do t.P.Visible=false; t.B.BackgroundColor3=Color3.fromRGB(40,40,40); t.B.TextColor3=Color3.fromRGB(200,200,200) end; P.Visible=true; B.BackgroundColor3=Color3.fromRGB(140,0,255); B.TextColor3=Color3.new(1,1,1) end)
        table.insert(Tabs, {P=P, B=B})
        local E = {}
        function E:Button(t, c, f) local b=Instance.new("TextButton",P); b.Size=UDim2.new(1,0,0,22); b.BackgroundColor3=c or Color3.fromRGB(50,50,50); b.Text=t; b.TextColor3=Color3.new(1,1,1); b.Font=Enum.Font.Gotham; b.TextSize=10; Instance.new("UICorner",b).CornerRadius=UDim.new(0,4); b.MouseButton1Click:Connect(function() pcall(f) end) end
        function E:Toggle(t, f) local fr=Instance.new("Frame",P); fr.Size=UDim2.new(1,0,0,22); fr.BackgroundColor3=Color3.fromRGB(50,50,50); Instance.new("UICorner",fr).CornerRadius=UDim.new(0,4); local l=Instance.new("TextLabel",fr); l.Size=UDim2.new(0.7,0,1,0); l.Position=UDim2.new(0.05,0,0,0); l.BackgroundTransparency=1; l.Text=t; l.TextColor3=Color3.new(1,1,1); l.TextXAlignment=Enum.TextXAlignment.Left; l.Font=Enum.Font.Gotham; l.TextSize=10; local b=Instance.new("TextButton",fr); b.Size=UDim2.new(0,30,0,16); b.Position=UDim2.new(0.85,0,0.15,0); b.BackgroundColor3=Color3.fromRGB(80,80,80); b.Text=""; Instance.new("UICorner",b).CornerRadius=UDim.new(1,0); local s=false; b.MouseButton1Click:Connect(function() s=not s; b.BackgroundColor3=s and Color3.fromRGB(50,200,50) or Color3.fromRGB(80,80,80); f(s) end) end
        function E:Input(p, f) local fr=Instance.new("Frame",P); fr.Size=UDim2.new(1,0,0,22); fr.BackgroundColor3=Color3.fromRGB(40,40,40); Instance.new("UICorner",fr).CornerRadius=UDim.new(0,4); local bx=Instance.new("TextBox",fr); bx.Size=UDim2.new(0.9,0,1,0); bx.Position=UDim2.new(0.05,0,0,0); bx.BackgroundTransparency=1; bx.Text=""; bx.PlaceholderText=p; bx.TextColor3=Color3.new(1,1,1); bx.Font=Enum.Font.Gotham; bx.TextSize=10; bx:GetPropertyChangedSignal("Text"):Connect(function() f(bx.Text) end) end
        function E:Label(t) local l=Instance.new("TextLabel",P); l.Size=UDim2.new(1,0,0,18); l.BackgroundTransparency=1; l.Text=t; l.TextColor3=Color3.fromRGB(140,0,255); l.Font=Enum.Font.GothamBold; l.TextSize=9; l.TextXAlignment=Enum.TextXAlignment.Left end
        function E:ColorPicker() local C=Instance.new("Frame",P);C.Size=UDim2.new(1,0,0,25);C.BackgroundTransparency=1;local L=Instance.new("UIListLayout",C);L.FillDirection=Enum.FillDirection.Horizontal;L.Padding=UDim.new(0,5);local Cols={{Color3.fromRGB(140,0,255)},{Color3.fromRGB(255,50,50)},{Color3.fromRGB(0,150,255)},{Color3.fromRGB(50,255,50)},{Color3.fromRGB(255,255,255)}};for _,c in pairs(Cols) do local B=Instance.new("TextButton",C);B.Size=UDim2.new(0,20,0,20);B.BackgroundColor3=c[1];B.Text="";Instance.new("UICorner",B).CornerRadius=UDim.new(1,0);B.MouseButton1Click:Connect(function() MS.Color=c[1]; OS.Color=c[1] end) end end
        function E:Slider(t,min,max,f) local fr=Instance.new("Frame",P);fr.Size=UDim2.new(1,0,0,30);fr.BackgroundColor3=Color3.fromRGB(50,50,50);Instance.new("UICorner",fr).CornerRadius=UDim.new(0,4);local l=Instance.new("TextLabel",fr);l.Size=UDim2.new(1,0,0.5,0);l.Position=UDim2.new(0.05,0,0,0);l.BackgroundTransparency=1;l.Text=t;l.TextColor3=Color3.new(1,1,1);l.TextSize=10;l.TextXAlignment=Enum.TextXAlignment.Left;local b=Instance.new("TextButton",fr);b.Size=UDim2.new(0.9,0,0.3,0);b.Position=UDim2.new(0.05,0,0.6,0);b.BackgroundColor3=Color3.fromRGB(30,30,30);b.Text="";local fil=Instance.new("Frame",b);fil.Size=UDim2.new(0,0,1,0);fil.BackgroundColor3=Color3.fromRGB(140,0,255);b.MouseButton1Down:Connect(function() local m;m=RunService.RenderStepped:Connect(function() local s=math.clamp((UserInputService:GetMouseLocation().X-b.AbsolutePosition.X)/b.AbsoluteSize.X,0,1);fil.Size=UDim2.new(s,0,1,0);f(min+(max-min)*s);if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then m:Disconnect() end end) end) end
        function E:Container(h) local c=Instance.new("ScrollingFrame",P); c.Size=UDim2.new(1,0,0,h); c.BackgroundColor3=Color3.fromRGB(30,30,30); c.ScrollBarThickness=2; Instance.new("UICorner",c).CornerRadius=UDim.new(0,4); local l=Instance.new("UIListLayout",c); l.Padding=UDim.new(0,2); return c end
        return E
    end
    return Library
end

local UI = Library:Create()

-- >>> 0. ABOUT <<<
local About = UI:Tab("About")
local PF = Instance.new("Frame", About.Container(120)); PF.Size=UDim2.new(1,0,1,0); PF.BackgroundTransparency=1
local Img = Instance.new("ImageLabel", PF); Img.Size=UDim2.new(0,60,0,60); Img.Position=UDim2.new(0.05,0,0.1,0); Img.BackgroundColor3=Color3.fromRGB(50,50,50); Instance.new("UICorner",Img).CornerRadius=UDim.new(1,0); Instance.new("UIStroke",Img).Color=Color3.fromRGB(140,0,255)
spawn(function() pcall(function() Img.Image=Players:GetUserThumbnailAsync(LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420) end) end)
local NL = Instance.new("TextLabel", PF); NL.Text=LocalPlayer.DisplayName; NL.Size=UDim2.new(0.6,0,0.2,0); NL.Position=UDim2.new(0.35,0,0.1,0); NL.BackgroundTransparency=1; NL.TextColor3=Color3.new(1,1,1); NL.Font=Enum.Font.GothamBlack; NL.TextXAlignment=Enum.TextXAlignment.Left; NL.TextSize=14
local UL = Instance.new("TextLabel", PF); UL.Text="@"..LocalPlayer.Name; UL.Size=UDim2.new(0.6,0,0.2,0); UL.Position=UDim2.new(0.35,0,0.3,0); UL.BackgroundTransparency=1; UL.TextColor3=Color3.fromRGB(150,150,150); UL.Font=Enum.Font.Gotham; UL.TextXAlignment=Enum.TextXAlignment.Left; UL.TextSize=10
local SF = Instance.new("Frame", PF); SF.Size=UDim2.new(0.9,0,0.4,0); SF.Position=UDim2.new(0.05,0,0.55,0); SF.BackgroundColor3=Color3.fromRGB(40,40,40); Instance.new("UICorner",SF)
local SL = Instance.new("UIListLayout", SF); SL.SortOrder=Enum.SortOrder.LayoutOrder; SL.Padding=UDim.new(0,2)
local function AddInfo(txt) local t=Instance.new("TextLabel",SF);t.Size=UDim2.new(1,0,0,12);t.BackgroundTransparency=1;t.Text=txt;t.TextColor3=Color3.fromRGB(200,200,200);t.TextSize=9;t.Font=Enum.Font.Gotham end
AddInfo(" ID: "..LocalPlayer.UserId)
AddInfo(" Age: "..LocalPlayer.AccountAge.." Days")
AddInfo(" Executor: "..(identifyexecutor and identifyexecutor() or "Unknown"))
AddInfo(" Game: "..game.PlaceId)
spawn(function() while true do AddInfo(" Time: "..os.date("%X")); SF.ChildAdded:Wait(); for i,v in pairs(SF:GetChildren()) do if v:IsA("TextLabel") and i>6 then v:Destroy() end end; wait(1) end end)

-- >>> 1. MOVEMENT <<<
local Mov = UI:Tab("Movement")
Mov:Label("Flight & Speed")
Mov:Toggle("Fly (Menu)", function(s) Config.Flying=s; FlyWidgetFrame.Visible=s; if s then spawn(function() local bg=Instance.new("BodyGyro",LocalPlayer.Character.HumanoidRootPart);bg.P=9e4;local bv=Instance.new("BodyVelocity",LocalPlayer.Character.HumanoidRootPart);bv.MaxForce=Vector3.new(9e9,9e9,9e9);while Config.Flying do LocalPlayer.Character.Humanoid.PlatformStand=true;bg.CFrame=Camera.CFrame;bv.Velocity=LocalPlayer.Character.Humanoid.MoveDirection.Magnitude>0 and Camera.CFrame.LookVector*Config.FlySpeed or Vector3.zero;RunService.RenderStepped:Wait() end;LocalPlayer.Character.Humanoid.PlatformStand=false;bg:Destroy();bv:Destroy() end) end end)
Mov:Toggle("Speed Hack", function(s) Config.SpeedHack=s; spawn(function() while Config.SpeedHack do LocalPlayer.Character.Humanoid.WalkSpeed=Config.SpeedVal;wait() end;LocalPlayer.Character.Humanoid.WalkSpeed=16 end) end)
Mov:Slider("Speed Val", 16, 200, function(v) Config.SpeedVal=v end)
Mov:Label("Physics")
Mov:Toggle("Noclip", function(s) Config.Noclip=s; RunService.Stepped:Connect(function() if Config.Noclip then for _,v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end end end) end)
Mov:Toggle("Infinite Jump", function(s) Config.InfJump=s; UserInputService.JumpRequest:Connect(function() if Config.InfJump then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end) end)
Mov:Toggle("High Jump", function(s) Config.HighJump=s; LocalPlayer.Character.Humanoid.JumpPower=s and 100 or 50 end)
Mov:Toggle("Auto Jump", function(s) Config.AutoJump=s; spawn(function() while Config.AutoJump do if LocalPlayer.Character.Humanoid.FloorMaterial~=Enum.Material.Air then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end;wait(0.1) end end) end)
Mov:Label("Special")
Mov:Toggle("Spider (Climb)", function(s) Config.WallClimb=s; if s then local b=Instance.new("BodyVelocity",LocalPlayer.Character.HumanoidRootPart);b.MaxForce=Vector3.zero;RunService.RenderStepped:Connect(function() if Config.WallClimb then local r=Ray.new(LocalPlayer.Character.HumanoidRootPart.Position,LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector*2);if workspace:FindPartOnRay(r,LocalPlayer.Character) then b.MaxForce=Vector3.new(0,9e9,0);b.Velocity=Vector3.new(0,20,0) else b.MaxForce=Vector3.zero end else b:Destroy() end end) end end)
Mov:Toggle("Jesus Mode", function(s) Config.JesusMode=s; for _,v in pairs(workspace:GetDescendants()) do if v.Name=="Water" then v.CanCollide=s end end end)
Mov:Toggle("Swim Mode", function(s) Config.SwimMode=s; if s then LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true) end end)
Mov:Toggle("SpinBot", function(s) Config.SpinBot=s; if s then spawn(function() while Config.SpinBot do LocalPlayer.Character.HumanoidRootPart.CFrame=LocalPlayer.Character.HumanoidRootPart.CFrame*CFrame.Angles(0,math.rad(100),0);RunService.RenderStepped:Wait() end end) end end)
Mov:Toggle("Phase", function(s) if s then LocalPlayer.Character.HumanoidRootPart.CFrame=LocalPlayer.Character.HumanoidRootPart.CFrame*CFrame.new(0,0,-5) end end)
Mov:Toggle("Safe Walk", function(s) Config.SafeWalk=s; RunService.RenderStepped:Connect(function() if Config.SafeWalk then local r=Ray.new(LocalPlayer.Character.HumanoidRootPart.Position+LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector*2,Vector3.new(0,-10,0)); if not workspace:FindPartOnRay(r,LocalPlayer.Character) then LocalPlayer.Character.Humanoid.WalkSpeed=0 else LocalPlayer.Character.Humanoid.WalkSpeed=16 end end end) end)

-- >>> 2. VISUALS <<<
local Vis = UI:Tab("Visuals")
Vis:Toggle("ESP Box", function(s) Config.ESP_Box=s end)
Vis:Toggle("ESP Name", function(s) Config.ESP_Name=s end)
Vis:Toggle("ESP Chams", function(s) Config.ESP_Chams=s end)
Vis:Toggle("ESP Tracer", function(s) Config.ESP_Tracer=s end)
Vis:Toggle("ESP Health", function(s) Config.ESP_Health=s end)
Vis:Toggle("ESP Distance", function(s) Config.ESP_Distance=s end)
Vis:Toggle("Rainbow Chams", function(s) Config.RainbowChams=s; spawn(function() while Config.RainbowChams do for _,v in pairs(workspace:GetDescendants()) do if v.Name=="V_HL" then v.FillColor=Color3.fromHSV(tick()%5/5,1,1) end end;wait(0.1) end end) end)
Vis:Toggle("Full Bright", function(s) Lighting.Brightness=s and 2 or 1; Lighting.GlobalShadows=not s end)
Vis:Toggle("X-Ray", function(s) for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then v.LocalTransparencyModifier=s and 0.5 or 0 end end end)
-- ESP Loop
spawn(function()
    while true do
        if Config.ESP_Name or Config.ESP_Box or Config.ESP_Chams or Config.ESP_Tracer then
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if Config.ESP_Chams and not p.Character:FindFirstChild("V_HL") then Instance.new("Highlight",p.Character).Name="V_HL"
                    elseif not Config.ESP_Chams and p.Character:FindFirstChild("V_HL") then p.Character.V_HL:Destroy() end
                    local bb=p.Character.HumanoidRootPart:FindFirstChild("V_BB")
                    if (Config.ESP_Name or Config.ESP_Box or Config.ESP_Health) and not bb then
                        bb=Instance.new("BillboardGui",p.Character.HumanoidRootPart);bb.Name="V_BB";bb.Size=UDim2.new(4,0,5,0);bb.AlwaysOnTop=true
                        local f=Instance.new("Frame",bb);f.Size=UDim2.new(1,0,1,0);f.BackgroundTransparency=1;Instance.new("UIStroke",f).Color=Color3.new(1,0,0)
                        local t=Instance.new("TextLabel",bb);t.Size=UDim2.new(1,0,0,15);t.Position=UDim2.new(0,0,-0.2,0);t.BackgroundTransparency=1;t.TextColor3=Color3.new(1,1,1);t.TextStrokeTransparency=0
                    end
                    if bb then
                        bb.Enabled=true; bb.Frame.UIStroke.Enabled=Config.ESP_Box
                        local txt=""; if Config.ESP_Name then txt=txt..p.Name.." " end; if Config.ESP_Distance then txt=txt.."["..math.floor((LocalPlayer.Character.HumanoidRootPart.Position-p.Character.HumanoidRootPart.Position).Magnitude).."m] " end; if Config.ESP_Health then txt=txt.."HP:"..math.floor(p.Character.Humanoid.Health) end
                        bb.TextLabel.Text=txt
                    end
                end
            end
        end
        wait(0.5)
    end
end)

-- >>> 3. TOOLS (UPDATED DELETE) <<<
local Tool = UI:Tab("Tools")
Tool:Toggle("Invisible", function(s) 
    if s then LocalPlayer.Character.HumanoidRootPart.Transparency=1; for _,v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency=1 end end 
    else LocalPlayer.Character.HumanoidRootPart.Transparency=1; for _,v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("BasePart") and v.Name~="HumanoidRootPart" then v.Transparency=0 end end end
end)
Tool:Toggle("Chat Spy", function(s) Config.ChatSpy=s; if s then for _,p in pairs(Players:GetPlayers()) do p.Chatted:Connect(function(m) if Config.ChatSpy then print("[SPY] "..p.Name..": "..m) end end) end end end)
Tool:Toggle("FLING AURA (Killer)", function(s) 
    Config.FlingAura=s; 
    if s then 
        local fa = Instance.new("Part", LocalPlayer.Character); fa.Name="AuraRing"; fa.Size=Vector3.new(10,1,10); fa.Transparency=0.5; fa.BrickColor=BrickColor.new("Really red"); fa.Material=Enum.Material.Neon; fa.CanCollide=false; fa.Anchored=true
        spawn(function() 
            while Config.FlingAura and LocalPlayer.Character do 
                if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    fa.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-3,0) * CFrame.Angles(0,tick(),0)
                    for _,p in pairs(Players:GetPlayers()) do 
                        if p~=LocalPlayer and p.Character then 
                            local r=p.Character:FindFirstChild("HumanoidRootPart")
                            if r and (r.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then 
                                r.AssemblyLinearVelocity=Vector3.new(0,500,0); r.AssemblyAngularVelocity=Vector3.new(1000,1000,1000) 
                            end 
                        end 
                    end
                end
                wait(0.1) 
            end
            fa:Destroy()
        end)
    end 
end)
Tool:Toggle("Auto Farm (Touch)", function(s) Config.AutoFarmTouch=s; spawn(function() while Config.AutoFarmTouch do for _,v in pairs(workspace:GetDescendants()) do if v:IsA("TouchTransmitter") then firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent, 0); wait(); firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent, 1) end end;wait(1) end end) end)
Tool:Toggle("Lag Switch", function(s) settings().Network.IncomingReplicationLag=s and 1000 or 0 end)
Tool:Toggle("Anti Void", function(s) Config.AntiVoid=s; spawn(function() while Config.AntiVoid do local c=LocalPlayer.Character; if c and c:FindFirstChild("HumanoidRootPart") then local r=Ray.new(c.HumanoidRootPart.Position,Vector3.new(0,-10,0)); if workspace:FindPartOnRay(r,c) then Config.LastGroundPos=c.HumanoidRootPart.CFrame elseif c.HumanoidRootPart.Position.Y<-50 and Config.LastGroundPos then c.HumanoidRootPart.CFrame=Config.LastGroundPos+Vector3.new(0,5,0);c.HumanoidRootPart.Velocity=Vector3.zero end end; wait(0.1) end end) end)
Tool:Toggle("Air Jump", function(s) Config.AirJump=s; UserInputService.JumpRequest:Connect(function() if Config.AirJump and LocalPlayer.Character then LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end) end)
Tool:Toggle("Anti Slip", function(s) Config.AntiSlip=s; spawn(function() while Config.AntiSlip do if LocalPlayer.Character.Humanoid then LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false) end;wait(1) end end) end)
Tool:Button("Get Tap TP", Color3.fromRGB(0, 180, 0), function() local t=Instance.new("Tool",LocalPlayer.Backpack);t.Name="Tap Teleport";t.RequiresHandle=false; t.Activated:Connect(function() if Mouse.Hit then LocalPlayer.Character:MoveTo(Mouse.Hit.Position) end end) end)
Tool:Button("Delete Tool (881355752)", Color3.fromRGB(200,0,0), function() 
    local t=Instance.new("Tool",LocalPlayer.Backpack); t.Name="Delete"; t.RequiresHandle=false; t.TextureId="rbxassetid://881355752"
    t.Activated:Connect(function() if Mouse.Target then Mouse.Target:Destroy() end end)
end)

-- >>> COMMON LOADER FUNCTIONS <<<
local function LoadAsset(id, type)
    StarterGui:SetCore("SendNotification", {Title="Loading", Text="Fetching Asset..."})
    local s, asset = pcall(function() return game:GetObjects("rbxassetid://"..id)[1] end)
    if not s or not asset then StarterGui:SetCore("SendNotification", {Title="Error", Text="Failed to load ID"}); return end
    
    if type == "Aura" or type == "VFX" then
        if LocalPlayer.Character:FindFirstChild("VanzyAura") then LocalPlayer.Character.VanzyAura:Destroy() end
        asset.Name = "VanzyAura"
        asset.Parent = LocalPlayer.Character
        for _,v in pairs(asset:GetDescendants()) do 
            if v:IsA("BasePart") then v.CanCollide=false; v.Massless=true; v.Transparency=1 end 
            if v:IsA("Humanoid") then v:Destroy() end
        end
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local pp = asset:IsA("Model") and asset.PrimaryPart or asset:FindFirstChildWhichIsA("BasePart") or asset
        if root and pp and pp:IsA("BasePart") then
            pp.CFrame = root.CFrame
            local w = Instance.new("WeldConstraint", pp); w.Part0 = root; w.Part1 = pp
        end
    elseif type == "Weapon" then
        local r = LocalPlayer.Character:FindFirstChild("RightHand") or LocalPlayer.Character:FindFirstChild("Right Arm")
        if not r then return end
        if LocalPlayer.Character:FindFirstChild("VanzyWeapon") then LocalPlayer.Character.VanzyWeapon:Destroy() end
        asset.Name = "VanzyWeapon"
        asset.Parent = LocalPlayer.Character
        local handle = asset:IsA("Model") and asset.PrimaryPart or asset:FindFirstChild("Handle") or asset:FindFirstChildWhichIsA("BasePart") or asset
        if handle and handle:IsA("BasePart") then
            handle.CFrame = r.CFrame * CFrame.Angles(0, math.rad(90), 0)
            local w = Instance.new("WeldConstraint", handle); w.Part0 = r; w.Part1 = handle
            for _,v in pairs(asset:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false; v.Anchored=false end end
        end
    end
end

-- >>> 4. AURAS (SPLIT TAB) <<<
local AT = UI:Tab("Auras")
AT:Button("Remove Aura", Color3.fromRGB(200,50,50), function() if LocalPlayer.Character:FindFirstChild("VanzyAura") then LocalPlayer.Character.VanzyAura:Destroy() end end)
AT:Label("-- OLD --")
AT:Button("Killer Red", Color3.fromRGB(100,0,0), function() LoadAsset("74417067882526", "Aura") end)
AT:Button("Random Flux", Color3.fromRGB(0,200,255), function() LoadAsset("106192507657319", "Aura") end)
AT:Button("Super Saiyan", Color3.fromRGB(255,150,0), function() LoadAsset("10545989953", "Aura") end)
AT:Label("-- NEW --")
AT:Button("Dark Aura VFX", Color3.fromRGB(50,0,50), function() LoadAsset("72031022600603", "Aura") end)
AT:Button("General Aura", Color3.fromRGB(150,150,150), function() LoadAsset("134112632165590", "Aura") end)
AT:Button("Clock Aura", Color3.fromRGB(200,150,50), function() LoadAsset("10807233179", "Aura") end)
AT:Button("Sol's Aggression", Color3.fromRGB(255,50,50), function() LoadAsset("79836629707795", "Aura") end)
AT:Button("Red Aura V3", Color3.fromRGB(200,0,0), function() LoadAsset("83362489061204", "Aura") end)
AT:Button("Blue Aura", Color3.fromRGB(0,0,255), function() LoadAsset("14645384079", "Aura") end)

-- >>> 5. WEAPONS (SPLIT TAB) <<<
local WT = UI:Tab("Weapons")
WT:Button("Remove Weapon", Color3.fromRGB(200,50,50), function() if LocalPlayer.Character:FindFirstChild("VanzyWeapon") then LocalPlayer.Character.VanzyWeapon:Destroy() end end)
WT:Button("Nunchucks", Color3.fromRGB(50,50,50), function() LoadAsset("393467000", "Weapon") end)
WT:Button("Katana", Color3.fromRGB(50,50,50), function() LoadAsset("5249216966", "Weapon") end)
WT:Button("Uranium Bar", Color3.fromRGB(50,255,50), function() LoadAsset("11706254515", "Weapon") end)
WT:Button("Spinner of Doom", Color3.fromRGB(100,0,0), function() LoadAsset("517144164", "Weapon") end)
WT:Button("Rainbow Lightsaber", Color3.fromRGB(255,50,255), function() LoadAsset("13073491349", "Weapon") end)

-- >>> 6. VFX / ANIMASI (NEW TAB) <<<
local VT = UI:Tab("VFX/Anim")
VT:Button("Remove VFX", Color3.fromRGB(200,50,50), function() if LocalPlayer.Character:FindFirstChild("VanzyAura") then LocalPlayer.Character.VanzyAura:Destroy() end end)
VT:Button("Particle Chaos", Color3.fromRGB(100,0,100), function() LoadAsset("9465639023", "VFX") end)
VT:Button("Shocker Breaker", Color3.fromRGB(0,255,255), function() LoadAsset("15830624402", "VFX") end)
VT:Button("Morphs BB", Color3.fromRGB(100,200,100), function() LoadAsset("8969795366", "VFX") end)
VT:Button("Stun Hand (Slap)", Color3.fromRGB(255,200,0), function() LoadAsset("9380694477", "VFX") end)

-- >>> 7. WORLD / SKY (SPLIT TAB + NEW SKIES) <<<
local World = UI:Tab("World")
local function SetSky(id)
    pcall(function()
        if Lighting:FindFirstChild("VanzySky") then Lighting.VanzySky:Destroy() end
        local s = Instance.new("Sky"); s.Name="VanzySky"; s.SkyboxBk="rbxassetid://"..id; s.SkyboxDn="rbxassetid://"..id; s.SkyboxFt="rbxassetid://"..id; s.SkyboxLf="rbxassetid://"..id; s.SkyboxRt="rbxassetid://"..id; s.SkyboxUp="rbxassetid://"..id; s.Parent=Lighting
    end)
end
World:Button("Reset Sky", Color3.fromRGB(100,100,100), function() if Lighting:FindFirstChild("VanzySky") then Lighting.VanzySky:Destroy() end end)
World:Label("-- OLD --")
World:Button("Galaxy Nebula Space", Color3.fromRGB(20,0,50), function() SetSky("18618101697") end)
World:Button("Galaxy Sky", Color3.fromRGB(50,0,100), function() SetSky("11284918730") end)
World:Button("Cartoon Sky", Color3.fromRGB(0,150,255), function() SetSky("15313376186") end)
World:Button("Pink Sky", Color3.fromRGB(255,100,150), function() SetSky("12635340429") end)
World:Button("Obby Sky", Color3.fromRGB(50,200,200), function() SetSky("127719608807122") end)
World:Button("Neon City", Color3.fromRGB(150,0,255), function() SetSky("4683026098") end)
World:Button("CakeUp Galaxy", Color3.fromRGB(100,50,150), function() SetSky("15983996673") end)
World:Label("-- NEW --")
World:Button("Space Sky", Color3.fromRGB(20,20,50), function() SetSky("11336743666") end)
World:Button("Halloween Sky", Color3.fromRGB(200,100,0), function() SetSky("184827381") end)
World:Button("Space Sky HD", Color3.fromRGB(0,0,100), function() SetSky("16262385808") end)
World:Button("Tropical Sunset", Color3.fromRGB(255,150,50), function() SetSky("169210648") end)
World:Button("Sunless Space", Color3.fromRGB(10,10,30), function() SetSky("9322203902") end)
World:Button("Dark Green", Color3.fromRGB(0,50,0), function() SetSky("566612745") end)
World:Button("Purple Sky", Color3.fromRGB(100,0,150), function() SetSky("5094389324") end)
World:Button("Desert Sunset", Color3.fromRGB(200,100,50), function() SetSky("18618065108") end)
World:Button("Paris Night", Color3.fromRGB(0,0,50), function() SetSky("10644495614") end)

-- >>> 8. MAP SCANNER <<<
local CPTab = UI:Tab("Auto CP")
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

-- >>> 9. SETTINGS <<<
local Set = UI:Tab("Settings")
Set:Input("Set Menu Title...", function(t) Config.MenuTitle=t; UIRefs.Title.Text=t end)
Set:Input("Set Player Name...", function(t) if LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.DisplayName=t end end)
Set:Input("Set Rank Tag...", function(t) 
    local bb=Instance.new("BillboardGui",LocalPlayer.Character.Head);bb.Size=UDim2.new(0,100,0,50);bb.StudsOffset=Vector3.new(0,3,0);bb.AlwaysOnTop=true
    local l=Instance.new("TextLabel",bb);l.Size=UDim2.new(1,0,1,0);l.BackgroundTransparency=1;l.Text="["..t.."]";l.TextColor3=Color3.fromRGB(255,0,0);l.TextStrokeTransparency=0 
end)
Set:Label("Theme Border Color")
Set:ColorPicker()
Set:Slider("Menu Transparency", 0, 1, function(v) UIRefs.MainFrame.BackgroundTransparency=v end)
Set:Button("Rejoin Server", nil, function() TeleportService:Teleport(game.PlaceId) end)

StarterGui:SetCore("SendNotification", {Title="VANZY V22", Text="MAXIMUM: All Assets Loaded!"})
