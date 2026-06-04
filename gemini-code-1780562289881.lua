-- RUN DI AKUN UTAMA (mainuhuy) --
if not game:IsLoaded() then game.Loaded:Wait() end

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Jalur Remote Event trading lu
local TradeRemote = ReplicatedStorage:WaitForChild("\228\186\139\228\187\182")
                                     :WaitForChild("\229\133\172\231\148\168")
                                     :WaitForChild("\228\186\164\230\152\147")
                                     :WaitForChild("\231\148\179\232\175\183\228\186\164\230\152\147")

_G.MainAutoAccept = true

task.spawn(function()
    print("Automa Utama (mainuhuy): Mode Auto-Accept Aktif!")
    
    while _G.MainAutoAccept do
        -- Nembak kosong murni mumpung jeda jendela pop-up lu aktif
        TradeRemote:FireServer()
        
        -- Jeda waktu cek 1.5 detik (aman dari lag dan pas buat nerima instan)
        task.wait(1.5) 
    end
end)