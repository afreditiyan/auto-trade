-- PAKAI INI SEBAGAI GANTINYA (JAUH LEBIH AMAN BUAT LOADSTRING):
if not game:IsLoaded() then 
    repeat task.wait(1) until game:IsLoaded() 
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Remote untuk auto-accept (nembak kosong)
local TradeRemote = ReplicatedStorage:WaitForChild("\228\186\139\228\187\182")
                                     :WaitForChild("\229\133\172\231\148\168")
                                     :WaitForChild("\228\186\164\230\152\147")
                                     :WaitForChild("\231\148\179\232\175\183\228\186\164\230\152\147")

_G.MainAccept = true

task.spawn(function()
    print("Mainuhuy: Mode Auto-Accept Aktif & Standby...")
    while _G.MainAccept do
        -- Nembak remote kosong tanpa argumen untuk langsung konfirmasi terima ajakan
        TradeRemote:FireServer()
        task.wait(1.5) -- Jeda nge-cek biar aman dari lag
    end
end)
