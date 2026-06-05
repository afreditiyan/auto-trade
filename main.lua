-- JAMINAN GAME SUDAH LOADING SEMPURNA
if not game:IsLoaded() then 
    repeat task.wait(1) until game:IsLoaded() 
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Remote Event Hasil Sniffing (Bahasa Mandarin)
local TradeRemote = ReplicatedStorage:WaitForChild("\228\186\139\228\187\182")
                                     :WaitForChild("\229\133\172\231\148\168")
                                     :WaitForChild("\228\186\164\230\152\147")
                                     :WaitForChild("\231\148\179\232\175\183\228\186\164\230\152\147")

_G.MainAccept = true -- Ubah jadi false jika mau dimatikan

-- =========================================================
-- LOGIC AUTO-ACCEPT PINTAR (ANTI-SPAM KOSONG)
-- =========================================================
task.spawn(function()
    print("Mainuhuy: Mode Auto-Accept Aktif & Standby Menunggu Tuyul...")
    
    -- Menguping sinyal masuk dari server ketika ada player lain yang ngajak trade
    TradeRemote.OnClientEvent:Connect(function(PengirimRequest)
        if _G.MainAccept and PengirimRequest and PengirimRequest:IsA("Player") then
            
            -- Kasih jeda 0.5 detik biar sinkronisasi server stabil
            task.wait(0.5)
            
            -- NEMBAK SERVER DENGAN ARGUMEN YANG BENAR (Memasukkan Object Player Pengirim)
            TradeRemote:FireServer(PengirimRequest)
            print("Mainuhuy: Berhasil otomatis nerima ajakan trade dari: " .. tostring(PengirimRequest.Name))
        end
    end)
    
    -- JALUR CADANGAN: Jika game lu tipe lama yang gak ngirim OnClientEvent tapi lari ke UI Pop-up
    while _G.MainAccept do
        pcall(function()
            local TradeGui = LocalPlayer.PlayerGui:FindFirstChild("TradeGui") or LocalPlayer.PlayerGui:FindFirstChild("MainGui")
            if TradeGui and TradeGui:FindFirstChild("RequestFrame") and TradeGui.RequestFrame.Visible == true then
                -- Cari tahu nama pengirim dari teks UI
                local NamaPlayer = TradeGui.RequestFrame.PlayerName.Text
                local TargetPlayer = Players:FindFirstChild(NamaPlayer)
                
                if TargetPlayer then
                    TradeRemote:FireServer(TargetPlayer)
                    print("Mainuhuy (Jalur UI): Menerima trade dari " .. NamaPlayer)
                end
            end
        end)
        task.wait(1.5) -- Loop pengecekan cadangan aman
    end
end)
