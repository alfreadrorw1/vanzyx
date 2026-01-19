-- Auto Carry Module
-- Automatically carries all players in the game

local module = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Player
local plr = Players.LocalPlayer

-- Module state
local active = false
local carryConnections = {}
local carriedPlayers = {}

local function waitForCharacter(player)
    local character = player.Character
    if not character then
        character = player.CharacterAdded:Wait()
    end
    repeat task.wait() until character:FindFirstChild("HumanoidRootPart")
    return character
end

local function createWeld(part1, part2)
    local weld = Instance.new("Weld")
    weld.Part0 = part1
    weld.Part1 = part2
    weld.C0 = CFrame.new()
    weld.C1 = part1.CFrame:toObjectSpace(part2.CFrame)
    weld.Parent = part1
    return weld
end

local function carryPlayer(targetPlayer)
    if targetPlayer == plr or carriedPlayers[targetPlayer] then
        return
    end
    
    carriedPlayers[targetPlayer] = true
    
    coroutine.wrap(function()
        local myCharacter = waitForCharacter(plr)
        local myHRP = myCharacter:FindFirstChild("HumanoidRootPart")
        
        local theirCharacter = waitForCharacter(targetPlayer)
        local theirHRP = theirCharacter:FindFirstChild("HumanoidRootPart")
        
        if not myHRP or not theirHRP then
            carriedPlayers[targetPlayer] = nil
            return
        end
        
        -- Create weld to carry
        local weld = createWeld(myHRP, theirHRP)
        
        -- Update position periodically (weld might break)
        local updateConnection
        updateConnection = RunService.Heartbeat:Connect(function()
            if not active or not myHRP or not theirHRP or not myHRP.Parent or not theirHRP.Parent then
                if updateConnection then
                    updateConnection:Disconnect()
                end
                carriedPlayers[targetPlayer] = nil
                return
            end
            
            -- Update weld if it exists, otherwise recreate
            if not weld or not weld.Parent then
                weld = createWeld(myHRP, theirHRP)
            end
            
            -- Keep their character upright
            theirHRP.CFrame = CFrame.new(theirHRP.Position) * CFrame.Angles(0, myHRP.CFrame:toEulerAnglesXYZ())
        end)
        
        table.insert(carryConnections, updateConnection)
        
        -- Handle target player leaving
        local playerLeftConnection
        playerLeftConnection = targetPlayer.CharacterRemoving:Connect(function()
            if updateConnection then
                updateConnection:Disconnect()
            end
            if weld then
                weld:Destroy()
            end
            carriedPlayers[targetPlayer] = nil
        end)
        
        table.insert(carryConnections, playerLeftConnection)
    end)()
end

local function startCarryingAll()
    -- Carry existing players
    for _, player in ipairs(Players:GetPlayers()) do
        carryPlayer(player)
    end
    
    -- Carry new players that join
    local playerAddedConnection
    playerAddedConnection = Players.PlayerAdded:Connect(function(player)
        task.wait(2) -- Wait for player to load
        if active then
            carryPlayer(player)
        end
    end)
    
    table.insert(carryConnections, playerAddedConnection)
end

local function stopCarryingAll()
    carriedPlayers = {}
    
    for _, conn in ipairs(carryConnections) do
        conn:Disconnect()
    end
    carryConnections = {}
    
    -- Clean up any remaining welds
    local myCharacter = plr.Character
    if myCharacter then
        local myHRP = myCharacter:FindFirstChild("HumanoidRootPart")
        if myHRP then
            for _, child in ipairs(myHRP:GetChildren()) do
                if child:IsA("Weld") then
                    child:Destroy()
                end
            end
        end
    end
end

function module.start()
    if active then return end
    
    active = true
    startCarryingAll()
    
    return {
        stop = function()
            active = false
            stopCarryingAll()
        end
    }
end

function module.stop(instance)
    active = false
    stopCarryingAll()
end

return module