-- Simple loader that works
local success, err = pcall(function()
    -- Try to load from GitHub
    local url = "https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/main.lua"
    local scriptSource = game:HttpGet(url)
    
    if scriptSource then
        loadstring(scriptSource)()
        print("Vanzyxxx loaded from GitHub!")
    else
        error("Failed to get script from GitHub")
    end
end)

if not success then
    warn("GitHub load failed: " .. err)
    
    -- Fallback: Use direct script
    print("Using fallback script...")
    
    -- Paste the ULTRA SIMPLE VERSION code here directly
    -- (Copy everything from above starting from '-- Vanzyxxx Auto Script...')
end