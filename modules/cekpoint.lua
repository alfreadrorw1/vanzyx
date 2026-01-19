-- [[ MODULE: CHECKPOINT ]]
local CPMod = {}

function CPMod.GetAll()
    local found = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("SpawnLocation") then
            local name = v.Name:lower()
            if name:find("checkpoint") or name:find("stage") or name:find("cp") then
                local num = tonumber(name:match("%d+")) or #found + 1
                table.insert(found, {part = v, id = num})
            end
        end
    end
    table.sort(found, function(a,b) return a.id < b.id end)
    return found
end

function CPMod.Teleport(part)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
    end
end

return CPMod
