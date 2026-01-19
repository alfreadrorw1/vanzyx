-- Vanzyxxx Loader
-- Simple HttpGet to load main script

if game:GetService("RunService"):IsClient() then
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/main.lua", true))()
    end)
    
    if not success then
        warn("Loader Error:", err)
    end
else
    warn("Loader must run on client!")
end