-- Noclip System
-- Walk through walls

local module = {}
local noclipEnabled = false
local connections = {}

module.name = "noclip"
module.description = "Walk through walls and objects"

function module.toggle(state)
    noclipEnabled = state
    
    if noclipEnabled then
        module.enableNoclip()
    else
        module.disableNoclip()
    end
end

function module.enableNoclip()
    module.disableNoclip() -- Cleanup first
    
    local character = module.Character
    if not character then return end
    
    -- Make all parts non-collidable
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    -- Monitor for new parts
    local connection = character.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end)
    
    table.insert(connections, connection)
    
    module.Logger.log("Noclip enabled", "SUCCESS")
end

function module.disableNoclip()
    -- Disconnect all connections
    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end
    connections = {}
    
    -- Restore collision
    local character = module.Character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    module.Logger.log("Noclip disabled", "INFO")
end

return module