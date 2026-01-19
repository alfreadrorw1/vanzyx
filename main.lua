-- [[ VANZYXXX PREMIUM V6 - MAIN ]]
-- UI STYLE: HORIZONTAL / DARK RED GOTHIC
-- COMPATIBLE: DELTA EXECUTOR (MOBILE)

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Global Storage untuk Modul
_G.VanzyModules = {}
_G.CurrentTheme = Color3.fromRGB(180, 0, 0) -- Red Accent

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui", plr.PlayerGui)
ScreenGui.Name = "Vanzyxxx_Premium"
ScreenGui.ResetOnSpawn = false

-- [[ UI MAIN CONTAINER ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 260)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 8)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = _G.CurrentTheme
Stroke.Thickness = 1.5

-- [[ TOP BAR ]]
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "  FREE SCRIPTS | Auto Walk"
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local PremiumBadge = Instance.new("TextLabel", TopBar)
PremiumBadge.Text = "PREMIUM SCRIPT"
PremiumBadge.Size = UDim2.new(0, 100, 0, 20)
PremiumBadge.Position = UDim2.new(0.6, 0, 0.5, -10)
PremiumBadge.BackgroundColor3 = _G.CurrentTheme
PremiumBadge.TextColor3 = Color3.new(1, 1, 1)
PremiumBadge.Font = Enum.Font.GothamBlack
PremiumBadge.TextSize = 10
Instance.new("UICorner", PremiumBadge)

-- [[ SIDEBAR ]]
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 100, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0, 2)

-- [[ CONTENT AREA ]]
local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -110, 1, -45)
Content.Position = UDim2.new(0, 105, 0, 40)
Content.BackgroundTransparency = 1

local Pages = {}

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", Content)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0,0,0,0)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.ScrollBarThickness = 2
    Pages[name] = Page
    return Page
end

-- Default Home Page
local Home = CreatePage("Home")
Home.Visible = true
local LogoBig = Instance.new("ImageLabel", Home)
LogoBig.Size = UDim2.new(0, 100, 0, 100)
LogoBig.Position = UDim2.new(0.5, -50, 0.3, -50)
LogoBig.Image = "rbxassetid://6031070978" -- Gothic Logo Placeholder
LogoBig.BackgroundTransparency = 1
LogoBig.ImageColor3 = _G.CurrentTheme

local WelcomeText = Instance.new("TextLabel", Home)
WelcomeText.Text = "FREE SCRIPT\nVANZYXXX V6"
WelcomeText.Size = UDim2.new(1, 0, 0, 50)
WelcomeText.Position = UDim2.new(0, 0, 0.6, 0)
WelcomeText.Font = Enum.Font.GothamBlack
WelcomeText.TextColor3 = Color3.new(1,1,1)
WelcomeText.TextSize = 18
WelcomeText.BackgroundTransparency = 1

-- Sidebar Button Generator
local function AddMenu(name, iconId)
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundTransparency = 1
    Btn.Text = "  " .. name
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    Btn.TextSize = 10
    Btn.TextXAlignment = Enum.TextXAlignment.Left

    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        if Pages[name] then Pages[name].Visible = true end
        
        -- Highlight Effect
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then 
                TweenService:Create(b, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
            end
        end
        TweenService:Create(Btn, TweenInfo.new(0.3), {TextColor3 = _G.CurrentTheme}):Play()
    end)
end

-- Load Modul (Simulasi - Ganti URL GitHub Anda nanti)
AddMenu("DASHBOARD", "")
AddMenu("MAIN SERVER", "")
AddMenu("AUTO WALK", "")
AddMenu("TELEPORT", "")
AddMenu("FLY", "")
AddMenu("SETTINGS", "")

-- [[ DRAG SYSTEM ]]
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
