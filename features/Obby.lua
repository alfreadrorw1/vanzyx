local Tab = Window:Tab("Obby")
local HttpService = game:GetService("HttpService")
local LocalPlayer = game.Players.LocalPlayer

Tab:Button("Save Checkpoint (Local)", function()
    local pos = LocalPlayer.Character.HumanoidRootPart.Position
    local data = {
        x = pos.X, y = pos.Y, z = pos.Z,
        place = game.PlaceId
    }
    
    if writefile then
        writefile("VanzyCP_"..game.PlaceId..".json", HttpService:JSONEncode(data))
    else
        warn("Executor tidak support writefile")
    end
end)

Tab:Button("Load Checkpoint", function()
    if isfile and isfile("VanzyCP_"..game.PlaceId..".json") then
        local content = readfile("VanzyCP_"..game.PlaceId..".json")
        local data = HttpService:JSONDecode(content)
        
        if data.place == game.PlaceId then
            LocalPlayer.Character:MoveTo(Vector3.new(data.x, data.y, data.z))
        end
    end
end)

Tab:Button("Click TP (Tool)", function()
    local tool = Instance.new("Tool")
    tool.Name = "Teleport Tool"
    tool.RequiresHandle = false
    tool.Parent = LocalPlayer.Backpack
    
    tool.Activated:Connect(function()
        local mouse = LocalPlayer:GetMouse()
        LocalPlayer.Character:MoveTo(mouse.Hit.Position)
    end)
end)
