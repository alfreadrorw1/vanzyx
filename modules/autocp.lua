-- Auto Checkpoint Completer
-- Automatically finds and teleports to all checkpoints

local module = {}
local running = false
local currentCheckpoint = 1
local totalCheckpoints = 0

module.name = "autocp"
module.description = "Auto-complete all checkpoints in the game"

function module.toggle(state)
    if state then
        module.start()
    else
        module.stop()
    end
end

function module.start()
    if running then return end
    running = true
    
    module.Logger.log("Starting auto checkpoint...", "INFO")
    
    task.spawn(function()
        local checkpoints = module.findCheckpoints()
        totalCheckpoints = #checkpoints
        
        if totalCheckpoints == 0 then
            module.Logger.notify("Auto CP", "No checkpoints found!", 3)
            running = false
            return
        end
        
        module.Logger.notify("Auto CP", "Found " .. totalCheckpoints .. " checkpoints!", 3)
        
        -- Disable fly during checkpoint run
        if module.Modules.autofly then
            module.Modules.autofly.toggle(false)
        end
        
        for i, cp in ipairs(checkpoints) do
            if not running then break end
            
            currentCheckpoint = i
            module.Logger.log("Teleporting to checkpoint " .. i .. "/" .. totalCheckpoints, "INFO")
            
            -- Use teleport module if available
            if module.Modules.autoteleport then
                module.Modules.autoteleport.teleport(cp.Position)
            else
                -- Fallback teleport
                if module.Character and module.HumanoidRootPart then
                    module.HumanoidRootPart.CFrame = CFrame.new(cp.Position + Vector3.new(0, 5, 0))
                end
            end
            
            task.wait(0.5) -- Delay between checkpoints
        end
        
        if running then
            module.Logger.notify("Auto CP", "Completed all checkpoints!", 5)
        end
        
        running = false
    end)
end

function module.stop()
    running = false
    module.Logger.log("Auto checkpoint stopped", "INFO")
end

function module.findCheckpoints()
    local checkpoints = {}
    
    -- Search strategies
    local searchPatterns = {
        "Checkpoint", "CP", "CheckPoint", "Stage", "Level", "Point"
    }
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            
            for _, pattern in ipairs(searchPatterns) do
                if name:find(pattern:lower()) then
                    table.insert(checkpoints, {
                        Part = obj,
                        Position = obj.Position,
                        Name = obj.Name
                    })
                    break
                end
            end
        elseif obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("checkpoint") or name:find("cp") then
                local primary = obj:FindFirstChildWhichIsA("BasePart")
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
    
    -- Sort by position (Z-axis typically)
    table.sort(checkpoints, function(a, b)
        return a.Position.Z < b.Position.Z
    end)
    
    return checkpoints
end

function module.getProgress()
    if totalCheckpoints == 0 then return 0 end
    return math.floor((currentCheckpoint / totalCheckpoints) * 100)
end

return module