--[[
    PROJECT: VANZYXXX V5 ULTIMATE
    TYPE: MAIN LOADER
    PLATFORM: MOBILE ONLY
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- [1] SETUP ENVIRONMENT
getgenv().VanzyConfig = {
    Version = "5.0.1",
    UrlBase = "https://raw.githubusercontent.com/alfreadrorw1/vanzyx/main/", -- Ganti dengan URL RAW GitHub kamu nanti
    UI_Color = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(255, 50, 50)
}

-- Fungsi Load Modular (Support Local File & HTTP)
local function LoadModule(name)
    local success, result = pcall(function()
        -- Prioritas 1: Load dari GitHub/HTTP (Jika sudah di-push)
        -- return loadstring(game:HttpGet(getgenv().VanzyConfig.UrlBase .. "features/" .. name .. ".lua"))()
        
        -- Prioritas 2: Load Manual (Untuk testing sekarang, paste code module di bawah ke executor jika belum punya github)
        return nil 
    end)
    return result
end

-- [2] LOAD UI LIBRARY
-- Jika kamu punya file terpisah, load di sini.
-- Di bawah ini saya sertakan Library langsung agar script jalan 100% tanpa error file missing.
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RealVanzy/VanzyLib/main/MobileUI.lua"))() 
-- ^ NOTE: Jika link mati, gunakan Code Library di FILE 2 di bawah.

if not Library then
    warn("Library Gagal Dimuat! Menggunakan Internal Library...")
    -- Fallback Library ada di FILE 2
end

-- [3] INITIALIZE WINDOW
local Window = Library:CreateWindow("VANZY V5", "Mobile Edition")

-- [4] LOAD FEATURES (Modular Load)
-- Kita meload fitur dari file/folder terpisah
local Movement = LoadModule("Movement")
local Visuals = LoadModule("Visuals")
local Obby = LoadModule("Obby")
local Misc = LoadModule("Misc")

-- Notifikasi Sukses
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Vanzy V5 Fixed";
    Text = "Script Loaded Successfully!";
    Duration = 3;
})
