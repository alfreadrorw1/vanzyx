-- [[ MODULE: FLY MOBILE ]]
local FlyMod = {}
local plr = game.Players.LocalPlayer
local flying = false
local speed = 50

function FlyMod.Toggle(state)
    flying = state
    local char = plr.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if flying then
        local bg = Instance.new("BodyGyro", root)
        bg.P = 9e4; bg.maxTorque = Vector3.new(9e9, 9e9, 9e9); bg.cframe = root.CFrame
        local bv = Instance.new("BodyVelocity", root)
        bv.velocity = Vector3.new(0,0.1,0); bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        task.spawn(function()
            while flying do
                root.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed
                bg.cframe = workspace.CurrentCamera.CFrame
                task.wait()
            end
            bg:Destroy(); bv:Destroy()
        end)
    end
end

-- Implementasi UI di main.lua akan memanggil FlyMod.Toggle
return FlyMod
