-- Auto Complete Checkpoints Module (Fixed)
local module = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local plr = Players.LocalPlayer
local active = false
local currentTask = nil

local function waitForCharacter()
    local character = plr.Character
    if not character then
        character = plr.CharacterAdded:Wait()
    end
    repeat task.wait(0.1) until character:FindFirstChild("HumanoidRootPart")
    return character
end

local function safeTeleport(hrp, position)
    if not hrp or not hrp.Parent then 
        return false, "No HRP"
    end
    
    local success, err = pcall(function()
        local humanoid = hrp.Parent:FindFirstChild("Humanoid")
        local originalCollision = hrp.CanCollide
        
        -- Disable collision
        hrp.CanCollide = false
        
        -- Save original properties
        local originalWalkSpeed, originalJumpPower
        if humanoid then
            originalWalkSpeed = humanoid.WalkSpeed
            originalJumpPower = humanoid.JumpPower
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
        end
        
        -- Teleport ke posisi
        hrp.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
        
        -- Tunggu physics update
        for _ = 1, 3 do
            RunService.Heartbeat:Wait()
        end
        
        -- Restore properties
        hrp.CanCollide = originalCollision
        if humanoid then
            humanoid.WalkSpeed = originalWalkSpeed or 16
            humanoid.JumpPower = originalJumpPower or 50
        end
        
        return true
    end)
    
    return success, err
end

local function findCheckpoints()
    local checkpoints = {}
    
    -- Cari semua BasePart dengan nama checkpoint
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            local name = obj.Name:lower()
            if name:find("checkpoint") or name:find("cp") or 
               name:find("flag") or name:find("point") or
               name:find("stage") or name:find("level") or
               name:find("finish") or name:find("end") then
                
                table.insert(checkpoints, {
                    Part = obj,
                    Position = obj.Position,
                    Name = obj.Name
                })
            end
        elseif obj:IsA("Model") then
            local modelName = obj.Name:lower()
            if modelName:find("checkpoint") or modelName:find("cp") then
                local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if primary then
                    table.insert(checkpoints, {
                        Part = primary,
                        Position = primary.Position,
                        Name = obj.Name
                    })
                end
            end
        end
    end
    
    -- Sort berdasarkan Z position (game progression)
    table.sort(checkpoints, function(a, b)
        return a.Position.Z < b.Position.Z
    end)
    
    -- Remove duplicates (posisi terlalu dekat)
    local filtered = {}
    local minDistance = 15
    
    for _, cp in ipairs(checkpoints) do
        local isDuplicate = false
        for _, existing in ipairs(filtered) do
            if (cp.Position - existing.Position).Magnitude < minDistance then
                isDuplicate = true
                break
            end
        end
        if not isDuplicate then
            table.insert(filtered, cp)
        end
    end
    
    return filtered
end

function module.start()
    if active then 
        print("[AutoCP] Already running")
        return nil 
    end
    
    active = true
    
    local statusUpdate = function(msg)
        print("[AutoCP]", msg)
    end
    
    currentTask = task.spawn(function()
        statusUpdate("🔍 Mencari checkpoint...")
        
        local character = waitForCharacter()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        
        if not hrp then
            statusUpdate("❌ Tidak ada HumanoidRootPart")
            active = false
            return
        end
        
        while active do
            local checkpoints = findCheckpoints()
            
            if #checkpoints == 0 then
                statusUpdate("❌ Tidak ada checkpoint ditemukan")
                
                -- Coba lagi dalam 2 detik
                for _ = 1, 20 do
                    if not active then break end
                    RunService.Heartbeat:Wait()
                end
            else
                statusUpdate("🎯 Ditemukan " .. #checkpoints .. " checkpoint")
                
                for i, cp in ipairs(checkpoints) do
                    if not active then break end
                    
                    statusUpdate("📍 Checkpoint " .. i .. "/" .. #checkpoints .. " - " .. cp.Name)
                    
                    -- Teleport
                    local success, err = safeTeleport(hrp, cp.Position)
                    
                    if success then
                        -- Tunggu sebentar
                        for _ = 1, 5 do
                            if not active then break end
                            RunService.Heartbeat:Wait()
                        end
                    else
                        statusUpdate("⚠️ Gagal teleport: " .. tostring(err))
                    end
                    
                    -- Delay antar checkpoint
                    local delay = 0.25
                    local elapsed = 0
                    while elapsed < delay and active do
                        RunService.Heartbeat:Wait()
                        elapsed = elapsed + RunService.Heartbeat:Wait()
                    end
                end
                
                if active then
                    statusUpdate("✅ Semua checkpoint selesai!")
                    
                    -- Tunggu sebelum scan ulang
                    task.wait(3)
                end
            end
        end
    end)
    
    return {
        stop = function()
            active = false
            if currentTask then
                task.cancel(currentTask)
                currentTask = nil
            end
            statusUpdate("⏹️ Berhenti")
        end
    }
end

function module.stop(instance)
    active = false
    if currentTask then
        task.cancel(currentTask)
        currentTask = nil
    end
    if instance and instance.stop then
        instance.stop()
    end
end

return module