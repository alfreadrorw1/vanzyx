-- [[ MODULE: TELEPORT PLAYERS ]]
local TPMod = {}
local Players = game:GetService("Players")

function TPMod.Teleport(targetName, mode)
    local target = Players:FindFirstChild(targetName)
    local me = Players.LocalPlayer.Character
    if not target or not target.Character or not me then return end
    
    local myRoot = me:FindFirstChild("HumanoidRootPart")
    local tarRoot = target.Character:FindFirstChild("HumanoidRootPart")
    
    if mode == "MeToPlayer" then
        myRoot.CFrame = tarRoot.CFrame
    else
        tarRoot.CFrame = myRoot.CFrame
    end
end

return TPMod
