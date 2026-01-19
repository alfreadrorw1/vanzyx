-- Auto Complete Checkpoints Module
-- Handles automatic checkpoint completion with sorting and safe teleportation

local module = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Player
local plr = Players.LocalPlayer

-- Module state
local active = false
local currentConnection = nil

-- Utility functions
local function waitForCharacter()
    local character = plr.Character
    if not character then
        character = plr.CharacterAdded:Wait()
    end
    repeat task.wait() until character:FindFirstChild("HumanoidRootPart")
    return character
end

local function safeTeleport(hrp, position)
    if not hrp or not hrp.Parent then return false end
    
    local humanoid = hrp.Parent:FindFirstChild("Humanoid")
    local originalCollision = hrp.CanCollide
    local originalTransparency = hrp.Transparency
    
    -- Disable collisions and make invisible during teleport
    hrp.CanCollide = false
    hrp.Transparency = 1
    
    -- Store original humanoid properties
    local originalWalkSpeed, originalJumpPower
    if humanoid then
        originalWalkSpeed = humanoid.WalkSpeed
        originalJumpPower = humanoid.JumpPower
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
    end
    
    -- Teleport with CFrame to preserve orientation
    hrp.CFrame = CFrame.new(position + Vector3.new(0, 5, 0))
    
    -- Wait for physics
    RunService.Heartbeat:Wait()
    RunService.Heartbeat:Wait()
    
    -- Restore properties
    hrp.CanCollide = originalCollision
    hrp.Transparency = originalTransparency
    
    if humanoid then
        humanoid.WalkSpeed = originalWalkSpeed or 16
        humanoid.JumpPower = originalJumpPower or 50
    end
    
    return true
end

local function extractNumber(str)
    local num = str:match("%d+")
    return num and tonumber(num) or 0
end

local function getCheckpoints()
    local checkpoints = {}
    
    -- Search for checkpoints in workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
            local name = obj.Name:lower()
            if name:find("checkpoint") or name:find("cp") or name:find("flag") or name:find("point") then
                -- Check if it's in a checkpoint folder
                local parent = obj.Parent
                if parent and (parent.Name:lower():find("checkpoint") or parent.Name:lower():find("cp")) then
                    table.insert(checkpoints, {
                        Part = obj,
                        Position = obj.Position,
                        Number = extractNumber(parent.Name) * 1000 + extractNumber(obj.Name)
                    })
                else
                    table.insert(checkpoints, {
                        Part = obj,
                        Position = obj.Position,
                        Number = extractNumber(obj.Name)
                    })
                end
            end
        end
    end
    
    -- Also check for checkpoint models
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and (obj.Name:lower():find("checkpoint") or obj.Name:lower():find("cp")) then
            local primary = obj:FindFirstChild("PrimaryPart") or obj:FindFirstChildWhichIsA("BasePart")
            if primary then
                table.insert(checkpoints, {
                    Part = primary,
                    Position = primary.Position,
                    Number = extractNumber(obj.Name) * 1000
                })
            end
        end
    end
    
    -- Sort checkpoints
    table.sort(checkpoints, function(a, b)
        if a.Number ~= b.Number and a.Number > 0 and b.Number > 0 then
            return a.Number < b.Number
        else
            -- Sort by Z position (assuming forward is positive Z)
            return a.Position.Z < b.Position.Z
        end
    end)
    
    -- Remove duplicates (checkpoints too close to each other)
    local filtered = {}
    local minDistance = 10
    
    for i, cp in ipairs(checkpoints) do
        local tooClose = false
        for j, other in ipairs(filtered) do
            if (cp.Position - other.Position).Magnitude < minDistance then
                tooClose = true
                break
            end
        end
        if not tooClose then
            table.insert(filtered, cp)
        end
    end
    
    return filtered
end

-- Main function
function module.start()
    if active then return end
    active = true
    
    local statusFunction = function(msg)
        -- This would update the GUI status through the main module
        print("[AutoCP]", msg)
    end
    
    coroutine.wrap(function()
        statusFunction("🔍 Finding checkpoints...")
        
        local character = waitForCharacter()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            statusFunction("❌ No HumanoidRootPart found")
            return
        end
        
        local checkpoints = getCheckpoints()
        
        if #checkpoints == 0 then
            statusFunction("❌ No checkpoints found")
            return
        end
        
        statusFunction("🎯 Found " .. #checkpoints .. " checkpoints")
        
        -- Create a loop that continues until stopped
        while active do
            for i, cp in ipairs(checkpoints) do
                if not active then break end
                
                statusFunction("📍 CP " .. i .. "/" .. #checkpoints)
                
                -- Teleport to checkpoint
                if safeTeleport(hrp, cp.Position) then
                    -- Wait a bit to ensure checkpoint registers
                    for _ = 1, 3 do
                        if not active then break end
                        RunService.Heartbeat:Wait()
                    end
                else
                    statusFunction("⚠️ Failed to teleport to CP " .. i)
                end
                
                -- Small delay between teleports
                local delay = 0.2 + math.random() * 0.1
                local elapsed = 0
                while elapsed < delay and active do
                    RunService.Heartbeat:Wait()
                    elapsed = elapsed + RunService.Heartbeat:Wait()
                end
            end
            
            -- Check if we should stop (if no progress was made)
            if active then
                statusFunction("✅ All checkpoints completed")
                
                -- Wait a bit before restarting
                task.wait(2)
                
                -- Refresh checkpoints in case new ones appeared
                checkpoints = getCheckpoints()
                if #checkpoints == 0 then
                    statusFunction("🎉 Summit reached!")
                    break
                end
            end
        end
    end)()
    
    return {
        stop = function()
            active = false
            statusFunction("⏹️ Stopped")
        end
    }
end

function module.stop(instance)
    if instance and instance.stop then
        instance.stop()
    end
    active = false
end

return module