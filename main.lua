-- Vanzyxxx V5 - MODULAR VERSION
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Folder Modules (Pastikan folder ini ada atau gunakan script loader)
local Theme = {
    Main = Color3.fromRGB(20, 20, 25),
    Sidebar = Color3.fromRGB(25, 25, 30),
    Accent = Color3.fromRGB(140, 0, 255),
    Text = Color3.fromRGB(255, 255, 255)
}

local ScreenGui = Instance.new("ScreenGui", plr.PlayerGui)
ScreenGui.Name = "Vanzyxxx_Modular"
ScreenGui.ResetOnSpawn = false

-- MAIN FRAME
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Theme.Main
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Theme.Accent

-- TITLE (PINDAH KE ATAS TENGAH)
local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "VANZYXXX V5"
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 18
TitleLabel.TextColor3 = Theme.Accent

-- SIDEBAR
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 110, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0, 5)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- CONTENT AREA
local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -120, 1, -50)
Content.Position = UDim2.new(0, 115, 0, 45)
Content.BackgroundTransparency = 1

local Pages = {}

-- Helper Function: Button dengan Icon (Padding Fix)
_G.AddMenuBtn = function(name, iconOffset)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn)

    local ico = Instance.new("ImageLabel", btn)
    ico.Size = UDim2.new(0, 16, 0, 16)
    ico.Position = UDim2.new(0, 8, 0.5, -8) -- Jarak 8 pixel dari kiri
    ico.BackgroundTransparency = 1
    ico.Image = "rbxassetid://3926305904"
    ico.ImageRectOffset = iconOffset
    ico.ImageRectSize = Vector2.new(36, 36)

    -- Text Padding (Agar text tidak menabrak icon)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    local padding = Instance.new("UIPadding", btn)
    padding.PaddingLeft = UDim.new(0, 30) -- Memberi ruang untuk icon

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        if Pages[name] then Pages[name].Visible = true end
    end)
    
    local p = Instance.new("ScrollingFrame", Content)
    p.Name = name
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Pages[name] = p
    return p
end

-- Load Modules (Simulasi pemanggilan file lain)
-- loadstring(game:HttpGet("link_ke_checkpoint.lua"))()
