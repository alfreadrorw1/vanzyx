-- Safe Teleport Module
-- Teleport bertahap untuk menghindari anti-cheat detection

local module = {}

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Teleport bertahap (anti-kick)
function module.stagedTeleport(character, hrp, targetPosition, steps)
    if not character or not hrp then
        return false
    end
    
    local currentPos = hrp.Position
    local distance = (targetPosition - currentPos).Magnitude
    
    -- Jika jarak dekat, teleport langsung
    if distance < 50 then
        hrp.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0))
        return true
    end
    
    -- Hitung jumlah step berdasarkan jarak
    steps = steps or math.min(10, math.floor(distance / 50))
    steps = math.max(2, steps)
    
    -- Nonaktifkan collision sementara
    local parts = {}
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(parts, part)
            part.CanCollide = false
        end
    end
    
    -- Lakukan teleport bertahap
    for i = 1, steps do
        local t = i / steps
        local interpPos = currentPos:Lerp(targetPosition, t)
        
        -- Tambahkan offset vertikal untuk menghindari terrain
        interpPos = interpPos + Vector3.new(0, 10, 0)
        
        hrp.CFrame = CFrame.new(interpPos)
        
        -- Delay kecil antara setiap step
        task.wait(0.05)
        
        -- Cek jika character masih valid
        if not character or not character.Parent then
            break
        end
    end
    
    -- Pastikan sampai di tujuan
    hrp.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0))
    
    -- Tunggu sedikit sebelum mengembalikan collision
    task.wait(0.2)
    
    -- Re-enable collision
    for _, part in ipairs(parts) do
        if part then
            part.CanCollide = true
        end
    end
    
    return true
end

-- Safe teleport dengan error handling
function module.safeTeleport(character, hrp, targetPosition, callback)
    local success, err = pcall(function()
        -- Validasi input
        if not character or not hrp or not targetPosition then
            return false
        end
        
        -- Nonaktifkan humanoid physics sementara
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local wasPlatformStand = false
        if humanoid then
            wasPlatformStand = humanoid.PlatformStand
            humanoid.PlatformStand = true
        end
        
        -- Teleport bertahap
        local result = module.stagedTeleport(character, hrp, targetPosition)
        
        -- Tunggu stabilisasi
        task.wait(0.3)
        
        -- Aktifkan kembali physics
        if humanoid then
            humanoid.PlatformStand = wasPlatformStand
        end
        
        return result
    end)
    
    if callback then
        callback(success)
    end
    
    return success
end

-- Teleport langsung (untuk carry)
function module.instantTeleport(character, hrp, targetPosition)
    if not character or not hrp then
        return false
    end
    
    hrp.CFrame = CFrame.new(targetPosition + Vector3.new(0, 3, 0))
    return true
end

return module