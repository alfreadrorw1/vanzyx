-- ====================================================
-- TELEPORT PLAYERS MODULE
-- Compatible with Delta Executor
-- ====================================================

local TeleportModule = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")

-- Variables
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local SelectedPlayers = {}
local PlayerList = {}

-- Function to get all players
function TeleportModule.GetPlayers()
    PlayerList = {}
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player then
            table.insert(PlayerList, {
                Name = player.Name,
                DisplayName = player.DisplayName,
                UserId = player.UserId,
                Character = player.Character,
                Selected = SelectedPlayers[player.Name] or false
            })
        end
    end
    
    return PlayerList
end

-- Function to select/deselect player
function TeleportModule.TogglePlayer(playerName)
    if SelectedPlayers[playerName] then
        SelectedPlayers[playerName] = nil
    else
        SelectedPlayers[playerName] = true
    end
    
    return SelectedPlayers[playerName]
end

-- Function to select all players
function TeleportModule.SelectAll()
    for _, player in ipairs(PlayerList) do
        SelectedPlayers[player.Name] = true
    end
    
    return SelectedPlayers
end

-- Function to deselect all players
function TeleportModule.DeselectAll()
    SelectedPlayers = {}
    return SelectedPlayers
end

-- Function to teleport selected players to my position
function TeleportModule.TeleportToMe()
    if not HumanoidRootPart then
        return false, "Your character not found"
    end
    
    local teleported = 0
    local errors = {}
    
    for playerName, selected in pairs(SelectedPlayers) do
        if selected then
            local targetPlayer = Players:FindFirstChild(playerName)
            if targetPlayer and targetPlayer.Character then
                local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetHRP then
                    -- Teleport to a position near me
                    local offset = Vector3.new(
                        math.random(-5, 5),
                        0,
                        math.random(-5, 5)
                    )
                    targetHRP.CFrame = CFrame.new(HumanoidRootPart.Position + offset)
                    teleported = teleported + 1
                else
                    table.insert(errors, playerName .. ": No HumanoidRootPart")
                end
            else
                table.insert(errors, playerName .. ": Player/Character not found")
            end
        end
    end
    
    local message = "Teleported " .. teleported .. " players"
    if #errors > 0 then
        message = message .. " (" .. #errors .. " errors)"
    end
    
    return true, message
end

-- Function to teleport selected players to checkpoint
function TeleportModule.TeleportToCheckpoint(checkpointPosition)
    if not checkpointPosition then
        return false, "No checkpoint position provided"
    end
    
    local teleported = 0
    local errors = {}
    
    for playerName, selected in pairs(SelectedPlayers) do
        if selected then
            local targetPlayer = Players:FindFirstChild(playerName)
            if targetPlayer and targetPlayer.Character then
                local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetHRP then
                    -- Teleport to checkpoint with offset
                    local offset = Vector3.new(
                        math.random(-5, 5),
                        5,
                        math.random(-5, 5)
                    )
                    targetHRP.CFrame = CFrame.new(checkpointPosition + offset)
                    teleported = teleported + 1
                else
                    table.insert(errors, playerName .. ": No HumanoidRootPart")
                end
            else
                table.insert(errors, playerName .. ": Player/Character not found")
            end
        end
    end
    
    local message = "Teleported " .. teleported .. " players to checkpoint"
    if #errors > 0 then
        message = message .. " (" .. #errors .. " errors)"
    end
    
    return true, message
end

-- Function to bring selected players to me
function TeleportModule.BringToMe()
    return TeleportModule.TeleportToMe()
end

-- Function to search players by name
function TeleportModule.SearchPlayers(searchTerm)
    local results = {}
    searchTerm = searchTerm:lower()
    
    for _, player in ipairs(PlayerList) do
        local nameMatch = player.Name:lower():find(searchTerm)
        local displayMatch = player.DisplayName:lower():find(searchTerm)
        
        if nameMatch or displayMatch then
            table.insert(results, player)
        end
    end
    
    return results
end

-- Function to create UI elements
function TeleportModule.CreateUI(container)
    -- Clear existing UI
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    
    -- Get players
    TeleportModule.GetPlayers()
    
    -- Search bar
    local SearchFrame = Instance.new("Frame")
    SearchFrame.Name = "SearchFrame"
    SearchFrame.Size = UDim2.new(1, 0, 0, 40)
    SearchFrame.BackgroundTransparency = 1
    
    local SearchBox = Instance.new("TextBox")
    SearchBox.Name = "SearchBox"
    SearchBox.Size = UDim2.new(1, 0, 1, 0)
    SearchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    SearchBox.Text = ""
    SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.TextSize = 14
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.PlaceholderText = "🔍 Search players..."
    SearchBox.ClearTextOnFocus = false
    
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 8)
    SearchCorner.Parent = SearchBox
    
    -- Players list frame
    local PlayersFrame = Instance.new("ScrollingFrame")
    PlayersFrame.Name = "PlayersList"
    PlayersFrame.Size = UDim2.new(1, 0, 0, 200)
    PlayersFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    PlayersFrame.BackgroundTransparency = 0.1
    PlayersFrame.ScrollBarThickness = 4
    PlayersFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    PlayersFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local PlayersCorner = Instance.new("UICorner")
    PlayersCorner.CornerRadius = UDim.new(0, 8)
    PlayersCorner.Parent = PlayersFrame
    
    -- Selection controls
    local SelectAllButton = Instance.new("TextButton")
    SelectAllButton.Name = "SelectAll"
    SelectAllButton.Size = UDim2.new(0.48, 0, 0, 35)
    SelectAllButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    SelectAllButton.Text = "✅ Select All"
    SelectAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SelectAllButton.TextSize = 14
    SelectAllButton.Font = Enum.Font.GothamBold
    
    local SelectAllCorner = Instance.new("UICorner")
    SelectAllCorner.CornerRadius = UDim.new(0, 6)
    SelectAllCorner.Parent = SelectAllButton
    
    local DeselectAllButton = Instance.new("TextButton")
    DeselectAllButton.Name = "DeselectAll"
    DeselectAllButton.Size = UDim2.new(0.48, 0, 0, 35)
    DeselectAllButton.Position = UDim2.new(0.52, 0, 0, 0)
    DeselectAllButton.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
    DeselectAllButton.Text = "❌ Deselect All"
    DeselectAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DeselectAllButton.TextSize = 14
    DeselectAllButton.Font = Enum.Font.GothamBold
    
    local DeselectAllCorner = Instance.new("UICorner")
    DeselectAllCorner.CornerRadius = UDim.new(0, 6)
    DeselectAllCorner.Parent = DeselectAllButton
    
    -- Teleport buttons
    local TeleportToMeButton = Instance.new("TextButton")
    TeleportToMeButton.Name = "TeleportToMe"
    TeleportToMeButton.Size = UDim2.new(1, 0, 0, 45)
    TeleportToMeButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
    TeleportToMeButton.Text = "🧲 Teleport Players to ME"
    TeleportToMeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportToMeButton.TextSize = 16
    TeleportToMeButton.Font = Enum.Font.GothamBold
    
    local TeleportToMeCorner = Instance.new("UICorner")
    TeleportToMeCorner.CornerRadius = UDim.new(0, 8)
    TeleportToMeCorner.Parent = TeleportToMeButton
    
    local BringToMeButton = Instance.new("TextButton")
    BringToMeButton.Name = "BringToMe"
    BringToMeButton.Size = UDim2.new(1, 0, 0, 45)
    BringToMeButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    BringToMeButton.Text = "🚀 Bring Players to ME"
    BringToMeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    BringToMeButton.TextSize = 16
    BringToMeButton.Font = Enum.Font.GothamBold
    
    local BringToMeCorner = Instance.new("UICorner")
    BringToMeCorner.CornerRadius = UDim.new(0, 8)
    BringToMeCorner.Parent = BringToMeButton
    
    -- Refresh button
    local RefreshButton = Instance.new("TextButton")
    RefreshButton.Name = "RefreshPlayers"
    RefreshButton.Size = UDim2.new(1, 0, 0, 35)
    RefreshButton.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    RefreshButton.Text = "🔄 Refresh Player List"
    RefreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    RefreshButton.TextSize = 14
    RefreshButton.Font = Enum.Font.GothamBold
    
    local RefreshCorner = Instance.new("UICorner")
    RefreshCorner.CornerRadius = UDim.new(0, 6)
    RefreshCorner.Parent = RefreshButton
    
    -- Status label
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "Status"
    StatusLabel.Size = UDim2.new(1, 0, 0, 30)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "👥 Select players to teleport"
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextWrapped = true
    
    -- Function to update player list
    local function UpdatePlayerList(searchTerm)
        for _, child in ipairs(PlayersFrame:GetChildren()) do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end
        
        local playersToShow = PlayerList
        
        if searchTerm and searchTerm ~= "" then
            playersToShow = TeleportModule.SearchPlayers(searchTerm)
        end
        
        for i, player in ipairs(playersToShow) do
            local PlayerButton = Instance.new("TextButton")
            PlayerButton.Name = player.Name
            PlayerButton.Size = UDim2.new(1, -10, 0, 35)
            PlayerButton.Position = UDim2.new(0, 5, 0, (i-1) * 40)
            PlayerButton.BackgroundColor3 = player.Selected and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(60, 60, 70)
            PlayerButton.Text = "👤 " .. player.DisplayName .. " (@" .. player.Name .. ")"
            PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerButton.TextSize = 12
            PlayerButton.Font = Enum.Font.Gotham
            PlayerButton.TextXAlignment = Enum.TextXAlignment.Left
            
            local PlayerCorner = Instance.new("UICorner")
            PlayerCorner.CornerRadius = UDim.new(0, 6)
            PlayerCorner.Parent = PlayerButton
            
            -- Add selection indicator
            local SelectionIndicator = Instance.new("TextLabel")
            SelectionIndicator.Name = "Indicator"
            SelectionIndicator.Size = UDim2.new(0, 20, 0, 20)
            SelectionIndicator.Position = UDim2.new(1, -25, 0.5, -10)
            SelectionIndicator.BackgroundTransparency = 1
            SelectionIndicator.Text = player.Selected and "✅" or "⬜"
            SelectionIndicator.TextColor3 = Color3.fromRGB(255, 255, 255)
            SelectionIndicator.TextSize = 14
            SelectionIndicator.Font = Enum.Font.GothamBold
            
            SelectionIndicator.Parent = PlayerButton
            
            -- Click functionality
            PlayerButton.MouseButton1Click:Connect(function()
                local selected = TeleportModule.TogglePlayer(player.Name)
                PlayerButton.BackgroundColor3 = selected and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(60, 60, 70)
                SelectionIndicator.Text = selected and "✅" or "⬜"
                
                -- Update status
                local selectedCount = 0
                for _ in pairs(SelectedPlayers) do
                    selectedCount = selectedCount + 1
                end
                StatusLabel.Text = "👥 " .. selectedCount .. " player(s) selected"
            end)
            
            PlayerButton.Parent = PlayersFrame
        end
    end
    
    -- Initial update
    UpdatePlayerList("")
    
    -- Search functionality
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        UpdatePlayerList(SearchBox.Text)
    end)
    
    -- Button functionality
    SelectAllButton.MouseButton1Click:Connect(function()
        TeleportModule.SelectAll()
        UpdatePlayerList(SearchBox.Text)
        StatusLabel.Text = "👥 " .. #PlayerList .. " player(s) selected"
    end)
    
    DeselectAllButton.MouseButton1Click:Connect(function()
        TeleportModule.DeselectAll()
        UpdatePlayerList(SearchBox.Text)
        StatusLabel.Text = "👥 0 player(s) selected"
    end)
    
    TeleportToMeButton.MouseButton1Click:Connect(function()
        local success, message = TeleportModule.TeleportToMe()
        StatusLabel.Text = message
    end)
    
    BringToMeButton.MouseButton1Click:Connect(function()
        local success, message = TeleportModule.BringToMe()
        StatusLabel.Text = message
    end)
    
    RefreshButton.MouseButton1Click:Connect(function()
        TeleportModule.GetPlayers()
        UpdatePlayerList(SearchBox.Text)
        StatusLabel.Text = "🔄 Player list refreshed"
    end)
    
    -- Auto-refresh players every 10 seconds
    local refreshConnection
    refreshConnection = RunService.Heartbeat:Connect(function()
        if tick() % 10 < 0.1 then
            TeleportModule.GetPlayers()
            UpdatePlayerList(SearchBox.Text)
        end
    end)
    
    -- Cleanup connection when UI is destroyed
    container.Destroying:Connect(function()
        if refreshConnection then
            refreshConnection:Disconnect()
        end
    end)
    
    -- Add to container
    SearchBox.Parent = SearchFrame
    SearchFrame.Parent = container
    PlayersFrame.Parent = container
    
    local ControlFrame = Instance.new("Frame")
    ControlFrame.Name = "ControlFrame"
    ControlFrame.Size = UDim2.new(1, 0, 0, 35)
    ControlFrame.BackgroundTransparency = 1
    ControlFrame.Parent = container
    
    SelectAllButton.Parent = ControlFrame
    DeselectAllButton.Parent = ControlFrame
    
    TeleportToMeButton.Parent = container
    BringToMeButton.Parent = container
    RefreshButton.Parent = container
    StatusLabel.Parent = container
end

-- Cleanup function
function TeleportModule.Cleanup()
    SelectedPlayers = {}
    PlayerList = {}
end

return TeleportModule