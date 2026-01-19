-- Anti-AFK System
-- Prevent getting kicked for inactivity

local module = {}
local antiafkEnabled = false
local connection = nil

module.name = "antiafk"
module.description = "Prevent AFK kick"

function module.toggle(state)
    antiafkEnabled = state
    
    if antiafkEnabled then
        module.enableAntiAFK()
    else
        module.disableAntiAFK()
    end
end

function module.enableAntiAFK()
    module.disableAntiAFK() -- Cleanup first
    
    connection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
        local VirtualInputManager = game:GetService("VirtualInputManager")
        
        -- Simulate key presses
        VirtualInputManager:SendKeyEvent(true, "W", false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "W", false, game)
        
        VirtualInputManager:SendKeyEvent(true, "S", false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "S", false, game)
        
        -- Rotate camera slightly
        local cam = workspace.CurrentCamera
        if cam then
            cam.CFrame = cam.CFrame * CFrame.Angles(0, math.rad(5), 0)
        end
    end)
    
    module.Logger.log("Anti-AFK enabled", "SUCCESS")
end

function module.disableAntiAFK()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    module.Logger.log("Anti-AFK disabled", "INFO")
end

return module