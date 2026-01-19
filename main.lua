-- Vanzyxxx V5 - RE-FIXED MODULAR
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Global Settings (Bisa diakses dari file lain)
_G.Theme = {
    Main = Color3.fromRGB(20, 20, 25),
    Sidebar = Color3.fromRGB(25, 25, 30),
    Accent = Color3.fromRGB(140, 0, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Secondary = Color3.fromRGB(35, 35, 40)
}

local ScreenGui = Instance.new("ScreenGui", plr.PlayerGui)
ScreenGui.Name = "Vanzy_V5_Fixed"
ScreenGui.ResetOnSpawn = false

-- 1. MINIMIZE LOGO (BULAT V5)
local MiniLogo = Instance.new("TextButton")
MiniLogo.Name = "MiniLogo"
MiniLogo.Size = UDim2.new(0, 50, 0, 50)
MiniLogo.Position = UDim2.new(0, 50, 0, 50)
MiniLogo.BackgroundColor3 = _G.Theme.Accent
MiniLogo.Text = "V5"
MiniLogo.TextColor3 = _G.Theme.Text
MiniLogo.Font = Enum.Font.GothamBlack
MiniLogo.TextSize = 18
MiniLogo.Visible = false
MiniLogo.Parent = ScreenGui
Instance.new("UICorner", MiniLogo).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", MiniLogo).Thickness = 2

-- 2. MAIN FRAME
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 420, 0, 280)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = _G.Theme.Main
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = _G.Theme.Accent

-- 3. TITLE (TENGAH ATAS)
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundTransparency = 1

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.Text = "VANZYXXX V5 PREMIUM"
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextColor3 = _G.Theme.Accent
TitleLabel.TextSize = 16
TitleLabel.BackgroundTransparency = 1

-- 4. SIDEBAR & CONTENT
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 120, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = _G.Theme.Sidebar

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0, 6)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -130, 1, -55)
Content.Position = UDim2.new(0, 125, 0, 50)
Content.BackgroundTransparency = 1

_G.Pages = {}

-- FUNCTION: ADD MENU BUTTON (DENGAN PADDING ICON)
_G.AddMenuBtn = function(name, iconOffset)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.BackgroundColor3 = _G.Theme.Secondary
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)

    local pad = Instance.new("UIPadding", btn)
    pad.PaddingLeft = UDim.new(0, 35) -- Jarak teks agar tidak kena icon

    local ico = Instance.new("ImageLabel", btn)
    ico.Size = UDim2.new(0, 18, 0, 18)
    ico.Position = UDim2.new(0, -27, 0.5, -9) -- Posisi relatif terhadap padding
    ico.BackgroundTransparency = 1
    ico.Image = "rbxassetid://3926305904"
    ico.ImageRectOffset = iconOffset
    ico.ImageRectSize = Vector2.new(36, 36)

    local p = Instance.new("ScrollingFrame", Content)
    p.Name = name
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 2
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    _G.Pages[name] = p

    btn.MouseButton1Click:Connect(function()
        for _, pg in pairs(_G.Pages) do pg.Visible = false end
        p.Visible = true
    end)
    return p
end

-- CLOSE & MINIMIZE LOGIC
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 7)
CloseBtn.Text = "×"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextSize = 20
Instance.new("UICorner", CloseBtn)

local function ToggleUI()
    local visible = MainFrame.Visible
    MainFrame.Visible = not visible
    MiniLogo.Visible = visible
end

CloseBtn.MouseButton1Click:Connect(ToggleUI)
MiniLogo.MouseButton1Click:Connect(ToggleUI)

-- DRAG SYSTEM
local function MakeDraggable(obj)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end
MakeDraggable(MainFrame)
MakeDraggable(MiniLogo)
