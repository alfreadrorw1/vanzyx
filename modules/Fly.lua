-- Jump Module
-- Membuat player jump 100 kali secara otomatis

local module = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Player
local plr = Players.LocalPlayer

-- Module state
local active = false
local jumpInstance = nil
local connections = {}

-- Configuration
local JUMP_COUNT = 100
local JUMP_DELAY = 0.1 -- Delay antara jump (detik)
local JUMP_POWER = 50 -- Kekuatan jump

local function createJumpController(character)
    if not character then return nil end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not hrp or not humanoid then return nil end
    
    -- Function untuk melakukan jump
    local function performJump()
        if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
            -- Activate jump state
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            
            -- Add upward velocity untuk jump lebih tinggi
            if hrp then
                local velocity = hrp:FindFirstChild("BodyVelocity")
                if not velocity then
                    velocity = Instance.new("BodyVelocity")
                    velocity.Velocity = Vector3.new(0, JUMP_POWER, 0)
                    velocity.MaxForce = Vector3.new(0, 100000, 0)
                    velocity.P = 10000
                    velocity.Name = "JumpBoost"
                    velocity.Parent = hrp
                else
                    velocity.Velocity = Vector3.new(0, JUMP_POWER, 0)
                end
            end
        end
    end
    
    -- Function untuk melakukan 100 jump
    local function startJumpSequence()
        coroutine.wrap(function()
            local jumpCount = 0
            
            while jumpCount < JUMP_COUNT and humanoid and humanoid.Health > 0 do
                jumpCount += 1
                
                -- Print status jump
                warn("Jump " .. jumpCount .. "/" .. JUMP_COUNT)
                
                -- Lakukan jump
                performJump()
                
                -- Tunggu sebelum jump berikutnya
                task.wait(JUMP_DELAY)
                
                -- Hapus velocity setelah delay kecil
                if hrp then
                    local velocity = hrp:FindFirstChild("JumpBoost")
                    if velocity then
                        velocity.Velocity = Vector3.new(0, 0, 0)
                    end
                end
                
                -- Tunggu sampai mendarat (atau timeout)
                local landed = false
                local waitTime = 0
                while not landed and waitTime < 1 and humanoid.Health > 0 do
                    if humanoid:GetState() == Enum.HumanoidStateType.Running or 
                       humanoid:GetState() == Enum.HumanoidStateType.RunningNoPhysics or
                       humanoid:GetState() == Enum.HumanoidStateType.Landed then
                        landed = true
                    end
                    task.wait(0.1)
                    waitTime += 0.1
                end
            end
            
            -- Bersihkan velocity setelah selesai
            if hrp then
                local velocity = hrp:FindFirstChild("JumpBoost")
                if velocity then
                    velocity:Destroy()
                end
            end
            
            warn("JUMP COMPLETED: " .. JUMP_COUNT .. " jumps!")
        end)()
    end
    
    -- Cegah humanoid mati karena fall damage
    if humanoid then
        local function noFallDamage()
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end
        end
        
        noFallDamage()
        
        -- Update setiap kali humanoid direset
        local stateChangedConn
        stateChangedConn = humanoid.StateChanged:Connect(function(oldState, newState)
            if newState == Enum.HumanoidStateType.FallingDown then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
        
        table.insert(connections, stateChangedConn)
    end
    
    -- Mulai jump sequence
    task.wait(0.5) -- Tunggu character stabil
    startJumpSequence()
    
    return {
        destroy = function()
            -- Bersihkan velocity
            if hrp then
                local velocity = hrp:FindFirstChild("JumpBoost")
                if velocity then
                    velocity:Destroy()
                end
            end
            
            -- Reset humanoid states
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            end
            
            for _, conn in ipairs(connections) do
                conn:Disconnect()
            end
            connections = {}
        end
    }
end

function module.start()
    if active then 
        warn("Jump module already active!")
        return jumpInstance 
    end
    
    active = true
    warn("STARTING 100 JUMPS...")
    
    -- Wait for character
    local character = plr.Character
    if not character then
        character = plr.CharacterAdded:Wait()
    end
    
    repeat task.wait() until character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid")
    
    -- Create jump controller
    jumpInstance = createJumpController(character)
    
    -- Handle respawn
    local charAddedConn
    charAddedConn = plr.CharacterAdded:Connect(function(newChar)
        task.wait(1) -- Wait for character to load
        
        if jumpInstance then
            jumpInstance.destroy()
        end
        
        repeat task.wait() until newChar:FindFirstChild("HumanoidRootPart") and newChar:FindFirstChild("Humanoid")
        
        warn("Character respawned, restarting jumps...")
        jumpInstance = createJumpController(newChar)
    end)
    
    table.insert(connections, charAddedConn)
    
    return jumpInstance
end

function module.stop()
    active = false
    
    if jumpInstance then
        jumpInstance.destroy()
    end
    
    for _, conn in ipairs(connections) do
        conn:Disconnect()
    end
    connections = {}
    
    jumpInstance = nil
    warn("Jump module stopped")
end

-- Function untuk konfigurasi
function module.configure(options)
    if options.jumpCount then
        JUMP_COUNT = options.jumpCount
    end
    if options.jumpDelay then
        JUMP_DELAY = options.jumpDelay
    end
    if options.jumpPower then
        JUMP_POWER = options.jumpPower
    end
end

-- Function untuk get status
function module.getStatus()
    return {
        active = active,
        jumpCount = JUMP_COUNT,
        jumpDelay = JUMP_DELAY,
        jumpPower = JUMP_POWER
    }
end

return module