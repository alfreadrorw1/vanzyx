-- Auto Carry Module

local module = {}

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Player
local player = Players.LocalPlayer
local character = player.Character
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

-- Module state
local active = false
local carrying = false
local carriedPlayers = {}
local weldConnections = {}

-- Create weld between two parts
local function createWeld(part1, part2)
    local weld = Instance.new("Weld")
    weld.Part0 = part1
    weld.Part1 = part2
    weld.C0 = CFrame.new()
    weld.C1 = part1.CFrame:inverse() * part2.CFrame
    weld.Parent = part1
    
    return weld
end

-- Carry a player
local function carryPlayer(targetPlayer)
    if not active or not carrying then return end
    if targetPlayer == player then return end
    
    local targetCharacter = targetPlayer.Character
    if not targetCharacter then return end
    
    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    -- Check if already carrying
    if carriedPlayers[targetPlayer] then return end
    
    -- Create weld to carry player
    local weld = createWeld(humanoidRootPart, targetRoot)
    carriedPlayers[targetPlayer] = {
        weld = weld,
        character = targetCharacter
    }
    
    print("Carrying player:", targetPlayer.Name)
end

-- Stop carrying a player
local function stopCarryPlayer(targetPlayer)
    local carryData = carriedPlayers[targetPlayer]
    if not carryData then return end
    
    -- Remove weld
    if carryData.weld and carryData.weld.Parent then
        carryData.weld:Destroy()
    end
    
    carriedPlayers[targetPlayer] = nil
    print("Stopped carrying player:", targetPlayer.Name)
end

-- Stop carrying all players
local function stopCarryAll()
    for targetPlayer, carryData in pairs(carriedPlayers) do
        if carryData.weld and carryData.weld.Parent then
            carryData.weld:Destroy()
        end
    end
    
    carriedPlayers = {}
    print("Stopped carrying all players")
end

-- Monitor players joining
local function monitorPlayers()
    -- Carry existing players
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if active and carrying then
            carryPlayer(otherPlayer)
        end
    end
    
    -- Monitor new players
    local playerAddedConnection = Players.PlayerAdded:Connect(function(newPlayer)
        if active and carrying then
            task.wait(2) -- Wait for character to load
            carryPlayer(newPlayer)
        end
    end)
    
    -- Monitor players leaving
    local playerRemovingConnection = Players.PlayerRemoving:Connect(function(leavingPlayer)
        stopCarryPlayer(leavingPlayer)
    end)
    
    -- Store connections
    weldConnections["playerAdded"] = playerAddedConnection
    weldConnections["playerRemoving"] = playerRemovingConnection
end

-- Character added handler
local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    
    if active and carrying then
        -- Stop all carrying and restart
        stopCarryAll()
        task.wait(1)
        
        if active and carrying then
            -- Re-carry all players
            for _, otherPlayer in ipairs(Players:GetPlayers()) do
                if otherPlayer ~= player then
                    carryPlayer(otherPlayer)
                end
            end
        end
    end
end

-- Module functions
function module.activate()
    if active then return end
    
    active = true
    carrying = true
    print("Auto Carry activated")
    
    -- Set up character monitoring
    player.CharacterAdded:Connect(onCharacterAdded)
    
    -- Start monitoring players
    monitorPlayers()
    
    -- Carry all current players
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            carryPlayer(otherPlayer)
        end
    end
end

function module.deactivate()
    if not active then return end
    
    active = false
    carrying = false
    
    -- Stop carrying all players
    stopCarryAll()
    
    -- Disconnect connections
    for _, connection in pairs(weldConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    
    weldConnections = {}
    
    print("Auto Carry deactivated")
end

-- Return module
return module