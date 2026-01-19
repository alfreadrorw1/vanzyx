-- DELTA EXECUTOR MINIMAL
-- Script ini PASTI muncul

-- Langsung buat UI tanpa menunggu apa-apa
local player = game.Players.LocalPlayer
local PlayerGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui")

-- Hapus UI lama jika ada
if PlayerGui:FindFirstChild("DeltaExecutorUI") then
    PlayerGui.DeltaExecutorUI:Destroy()
end

-- Buat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaExecutorUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 320)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

-- Corner
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- Shadow Effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 15, 1, 15)
Shadow.Position = UDim2.new(0.5, -7.5, 0.5, -7.5)
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://8577661197"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.7
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
Shadow.ZIndex = -1
Shadow.Parent = MainFrame

-- HEADER
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 45)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

-- Title dengan teks yang Anda inginkan
local TitleFrame = Instance.new("Frame")
TitleFrame.Name = "TitleFrame"
TitleFrame.Size = UDim2.new(0.7, 0, 1, 0)
TitleFrame.BackgroundTransparency = 1
TitleFrame.Parent = Header

local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.Position = UDim2.new(0, 10, 0.5, -15)
Logo.AnchorPoint = Vector2.new(0, 0.5)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://10734964822"
Logo.ImageColor3 = Color3.fromRGB(0, 170, 255)
Logo.Parent = TitleFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 40, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Blue Panther | 65\nEXP Mx.Vanzyxxx\n@AlfredR0rw"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 10
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextYAlignment = Enum.TextYAlignment.Center
Title.RichText = true
Title.Parent = TitleFrame

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
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- CONTENT AREA
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, 0, 1, -45)
Content.Position = UDim2.new(0, 0, 0, 45)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Sidebar (Left 35%)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0.35, 0, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Sidebar.Parent = Content

-- Sidebar Buttons
local SidebarButtons = Instance.new("ScrollingFrame")
SidebarButtons.Name = "SidebarButtons"
SidebarButtons.Size = UDim2.new(1, -5, 1, -10)
SidebarButtons.Position = UDim2.new(0, 5, 0, 5)
SidebarButtons.BackgroundTransparency = 1
SidebarButtons.ScrollBarThickness = 3
SidebarButtons.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
SidebarButtons.Parent = Sidebar

local ButtonsLayout = Instance.new("UIListLayout")
ButtonsLayout.Padding = UDim.new(0, 5)
ButtonsLayout.Parent = SidebarButtons

-- Right Panel (65%)
local RightPanel = Instance.new("Frame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(0.65, 0, 1, 0)
RightPanel.Position = UDim2.new(0.35, 0, 0, 0)
RightPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
RightPanel.Parent = Content

-- Panel Content
local PanelContent = Instance.new("ScrollingFrame")
PanelContent.Name = "PanelContent"
PanelContent.Size = UDim2.new(1, -10, 1, -10)
PanelContent.Position = UDim2.new(0, 5, 0, 5)
PanelContent.BackgroundTransparency = 1
PanelContent.ScrollBarThickness = 4
PanelContent.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
PanelContent.Parent = RightPanel

local PanelLayout = Instance.new("UIListLayout")
PanelLayout.Padding = UDim.new(0, 8)
PanelLayout.Parent = PanelContent

-- Function untuk clear panel
local function clearPanel()
    for _, child in ipairs(PanelContent:GetChildren()) do
        if child:IsA("GuiObject") and child.Name ~= "PanelLayout" then
            child:Destroy()
        end
    end
end

-- Function untuk buat sidebar button
local function createButton(name, icon)
    local button = Instance.new("TextButton")
    button.Name = name .. "Btn"
    button.Size = UDim2.new(1, 0, 0, 45)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    button.Text = ""
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    local iconImg = Instance.new("ImageLabel")
    iconImg.Name = "Icon"
    iconImg.Size = UDim2.new(0, 22, 0, 22)
    iconImg.Position = UDim2.new(0, 10, 0.5, -11)
    iconImg.AnchorPoint = Vector2.new(0, 0.5)
    iconImg.BackgroundTransparency = 1
    iconImg.Image = icon
    iconImg.ImageColor3 = Color3.fromRGB(150, 150, 170)
    iconImg.Parent = button
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 40, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = button
    
    local highlight = Instance.new("Frame")
    highlight.Name = "Highlight"
    highlight.Size = UDim2.new(0, 3, 0.7, 0)
    highlight.Position = UDim2.new(0, 0, 0.15, 0)
    highlight.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    highlight.Visible = false
    highlight.Parent = button
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        if not button.Highlight.Visible then
            button.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not button.Highlight.Visible then
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        end
    end)
    
    return button
end

-- Function untuk load module
local function loadModule(name)
    -- Reset semua highlight
    for _, child in ipairs(SidebarButtons:GetChildren()) do
        if child:IsA("TextButton") then
            child.Highlight.Visible = false
            child.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        end
    end
    
    -- Set highlight untuk button aktif
    local activeButton = SidebarButtons:FindFirstChild(name .. "Btn")
    if activeButton then
        activeButton.Highlight.Visible = true
        activeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    end
    
    -- Clear dan isi panel
    clearPanel()
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    title.TextColor3 = Color3.fromRGB(0, 170, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Text = name:upper()
    title.TextXAlignment = Enum.TextXAlignment.Center
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    title.Parent = PanelContent
    
    -- Content berdasarkan module
    if name == "Auto Obby" then
        local info = Instance.new("TextLabel")
        info.Name = "Info"
        info.Size = UDim2.new(1, -20, 0, 120)
        info.Position = UDim2.new(0, 10, 0, 60)
        info.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        info.TextColor3 = Color3.fromRGB(200, 200, 220)
        info.TextSize = 12
        info.Font = Enum.Font.Gotham
        info.Text = "Features:\n• Auto run & jump\n• Checkpoint detection\n• Anti-stuck system\n• Start/Pause/Stop"
        info.TextXAlignment = Enum.TextXAlignment.Left
        info.TextYAlignment = Enum.TextYAlignment.Top
        info.RichText = true
        
        local infoCorner = Instance.new("UICorner")
        infoCorner.CornerRadius = UDim.new(0, 8)
        infoCorner.Parent = info
        info.Parent = PanelContent
        
        local loadBtn = Instance.new("TextButton")
        loadBtn.Name = "LoadBtn"
        loadBtn.Size = UDim2.new(0.8, 0, 0, 40)
        loadBtn.Position = UDim2.new(0.1, 0, 0, 190)
        loadBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        loadBtn.Text = "LOAD AUTO OBBY"
        loadBtn.TextColor3 = Color3.white
        loadBtn.TextSize = 14
        loadBtn.Font = Enum.Font.GothamBold
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = loadBtn
        
        loadBtn.MouseButton1Click:Connect(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/obby.lua"))()
        end)
        
        loadBtn.Parent = PanelContent
        
    elseif name == "Checkpoints" then
        local info = Instance.new("TextLabel")
        info.Name = "Info"
        info.Size = UDim2.new(1, -20, 0, 100)
        info.Position = UDim2.new(0, 10, 0, 60)
        info.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        info.TextColor3 = Color3.fromRGB(200, 200, 220)
        info.TextSize = 12
        info.Font = Enum.Font.Gotham
        info.Text = "Features:\n• Scan all checkpoints\n• Auto teleport\n• Select specific CP\n• Refresh list"
        info.TextXAlignment = Enum.TextXAlignment.Left
        info.TextYAlignment = Enum.TextYAlignment.Top
        info.RichText = true
        
        local infoCorner = Instance.new("UICorner")
        infoCorner.CornerRadius = UDim.new(0, 8)
        infoCorner.Parent = info
        info.Parent = PanelContent
        
        local loadBtn = Instance.new("TextButton")
        loadBtn.Name = "LoadBtn"
        loadBtn.Size = UDim2.new(0.8, 0, 0, 40)
        loadBtn.Position = UDim2.new(0.1, 0, 0, 170)
        loadBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        loadBtn.Text = "LOAD CHECKPOINTS"
        loadBtn.TextColor3 = Color3.white
        loadBtn.TextSize = 14
        loadBtn.Font = Enum.Font.GothamBold
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = loadBtn
        
        loadBtn.MouseButton1Click:Connect(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/cekpoint.lua"))()
        end)
        
        loadBtn.Parent = PanelContent
        
    elseif name == "Teleport Players" then
        local info = Instance.new("TextLabel")
        info.Name = "Info"
        info.Size = UDim2.new(1, -20, 0, 120)
        info.Position = UDim2.new(0, 10, 0, 60)
        info.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        info.TextColor3 = Color3.fromRGB(200, 200, 220)
        info.TextSize = 12
        info.Font = Enum.Font.Gotham
        info.Text = "Features:\n• Teleport to player\n• Teleport player to you\n• Multi-select players\n• Search & refresh"
        info.TextXAlignment = Enum.TextXAlignment.Left
        info.TextYAlignment = Enum.TextYAlignment.Top
        info.RichText = true
        
        local infoCorner = Instance.new("UICorner")
        infoCorner.CornerRadius = UDim.new(0, 8)
        infoCorner.Parent = info
        info.Parent = PanelContent
        
        local loadBtn = Instance.new("TextButton")
        loadBtn.Name = "LoadBtn"
        loadBtn.Size = UDim2.new(0.8, 0, 0, 40)
        loadBtn.Position = UDim2.new(0.1, 0, 0, 190)
        loadBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        loadBtn.Text = "LOAD TELEPORT"
        loadBtn.TextColor3 = Color3.white
        loadBtn.TextSize = 14
        loadBtn.Font = Enum.Font.GothamBold
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = loadBtn
        
        loadBtn.MouseButton1Click:Connect(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/teleportplayers.lua"))()
        end)
        
        loadBtn.Parent = PanelContent
        
    elseif name == "Fly System" then
        local info = Instance.new("TextLabel")
        info.Name = "Info"
        info.Size = UDim2.new(1, -20, 0, 100)
        info.Position = UDim2.new(0, 10, 0, 60)
        info.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        info.TextColor3 = Color3.fromRGB(200, 200, 220)
        info.TextSize = 12
        info.Font = Enum.Font.Gotham
        info.Text = "Features:\n• Mobile optimized fly\n• Joystick support\n• Speed control\n• Up/Down buttons"
        info.TextXAlignment = Enum.TextXAlignment.Left
        info.TextYAlignment = Enum.TextYAlignment.Top
        info.RichText = true
        
        local infoCorner = Instance.new("UICorner")
        infoCorner.CornerRadius = UDim.new(0, 8)
        infoCorner.Parent = info
        info.Parent = PanelContent
        
        local loadBtn = Instance.new("TextButton")
        loadBtn.Name = "LoadBtn"
        loadBtn.Size = UDim2.new(0.8, 0, 0, 40)
        loadBtn.Position = UDim2.new(0.1, 0, 0, 170)
        loadBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        loadBtn.Text = "LOAD FLY SYSTEM"
        loadBtn.TextColor3 = Color3.white
        loadBtn.TextSize = 14
        loadBtn.Font = Enum.Font.GothamBold
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = loadBtn
        
        loadBtn.MouseButton1Click:Connect(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/modules/fly.lua"))()
        end)
        
        loadBtn.Parent = PanelContent
    end
    
    -- Update canvas size
    PanelContent.CanvasSize = UDim2.new(0, 0, 0, PanelLayout.AbsoluteContentSize.Y + 20)
end

-- Tambahkan buttons
local modules = {
    {"Auto Obby", "rbxassetid://10734975645"},
    {"Checkpoints", "rbxassetid://10734973111"},
    {"Teleport Players", "rbxassetid://10734968922"},
    {"Fly System", "rbxassetid://10734967234"}
}

for _, module in ipairs(modules) do
    local name, icon = module[1], module[2]
    local button = createButton(name, icon)
    button.Parent = SidebarButtons
    
    button.MouseButton1Click:Connect(function()
        loadModule(name)
    end)
end

-- Update sidebar size
SidebarButtons.CanvasSize = UDim2.new(0, 0, 0, ButtonsLayout.AbsoluteContentSize.Y + 10)

-- Load module pertama
loadModule("Auto Obby")

-- Draggable function
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Print success message
print("======================================")
print("DELTA EXECUTOR LOADED!")
print("Blue Panther | 65")
print("EXP Mx.Vanzyxxx")
print("@AlfredR0rw")
print("======================================")

-- Tampilkan notifikasi
local notification = Instance.new("TextLabel")
notification.Name = "Notification"
notification.Size = UDim2.new(0, 200, 0, 50)
notification.Position = UDim2.new(0.5, -100, 0.1, 0)
notification.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
notification.TextColor3 = Color3.fromRGB(0, 170, 255)
notification.Text = "DELTA EXECUTOR\nUI Loaded Successfully!"
notification.TextSize = 12
notification.Font = Enum.Font.GothamBold
notification.TextYAlignment = Enum.TextYAlignment.Center
notification.Parent = ScreenGui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 8)
notifCorner.Parent = notification

-- Auto hide notifikasi
game:GetService("RunService").Heartbeat:Wait()
wait(3)
notification:Destroy()

-- Pastikan UI visible
MainFrame.Visible = true
ScreenGui.Enabled = true

return ScreenGui