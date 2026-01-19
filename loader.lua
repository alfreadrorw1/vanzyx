-- Vanzyxxx Loader
-- Minimal loader that fetches and executes the main script

if _G.VanzyxxxLoaderExecuted then return end
_G.VanzyxxxLoaderExecuted = true

print("[Vanzyxxx] Loading...")

-- Load main script
local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/main.lua"))()
end)

if not success then
    warn("[Vanzyxxx] Failed to load:", err)
end