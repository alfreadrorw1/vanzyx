-- Vanzyxxx Loader
-- Minimal loader that loads the main script

local MAIN_SCRIPT_URL = "https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/main.lua"

-- Check if already loaded
if not _G.VanzyxxxLoaded then
    _G.VanzyxxxLoaded = true
    
    -- Load main script
    local success, err = pcall(function()
        loadstring(game:HttpGet(MAIN_SCRIPT_URL))()
    end)
    
    if not success then
        warn("Vanzyxxx Loader Error:", err)
    end
end