-- Vanzyxxx Loader
-- Minimal loader untuk menghindari deteksi

if game:GetService("RunService"):IsClient() then
    local success, err = pcall(function()
        local mainScript = game:HttpGet("https://raw.githubusercontent.com/vanzyx/main/main.lua")
        loadstring(mainScript)()
    end)
    
    if not success then
        warn("Loader Error: " .. err)
    end
else
    warn("Loader must run on client!")
end