-- PAKAI INI SEBAGAI GANTINYA (JAUH LEBIH AMAN BUAT LOADSTRING):
if not game:IsLoaded() then 
    repeat task.wait(1) until game:IsLoaded() 
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local MainAccount = "mainuhuy" -- Target akun utama lu

-- Jalur Remote dari SimpleSpy lu kemarin
local RequestRemote = ReplicatedStorage:WaitForChild("\228\186\139\228\187\182"):WaitForChild("\229\133\172\231\148\168"):WaitForChild("\228\186\164\230\152\147"):WaitForChild("\231\148\179\232\175\183\228\186\164\230\152\147")
local AddItemRemote = ReplicatedStorage:WaitForChild("\228\186\139\228\187\182"):WaitForChild("\229\133\172\231\148\168"):WaitForChild("\228\186\164\230\152\147"):WaitForChild("\230\150\176\229\162\158\228\186\164\230\152\147\231\137\169\229\147\129")
local LockRemote    = ReplicatedStorage:WaitForChild("\228\186\139\228\187\182"):WaitForChild("\229\133\172\231\148\168"):WaitForChild("\228\186\164\230\152\147"):WaitForChild("\230\148\190\229\174\154\228\186\164\230\152\147")

-- Fungsi menguras semua item di Tab Nomor 2
local function KurasTabDanyao()
    print("Bot: Trade dibuka! Mencari folder Inventory...")
    
    local PlayerData = LocalPlayer:FindFirstChild("PlayerData") or ReplicatedStorage:FindFirstChild("PlayerData")
    local Inventory = PlayerData and (PlayerData:FindFirstChild("Inventory") or PlayerData:FindFirstChild("\225\140\133"))
    
    if not Inventory then
        for _, v in pairs(ReplicatedStorage:GetChildren()) do
            if v.Name == "PlayerData" and v:FindFirstChild(LocalPlayer.Name) then
                Inventory = v[LocalPlayer.Name]:FindFirstChild("Inventory")
            end
        end
    end

    if Inventory then
        for _, item in pairs(Inventory:GetChildren()) do
            local itemGuid = item:FindFirstChild("GUID") or item:FindFirstChild("Id") or item.Name
            local itemCount = item:FindFirstChild("Count") or item:FindFirstChild("Amount") or item:FindFirstChild("Value")
            
            if itemGuid and itemCount then
                local currentCount = itemCount.Value
                
                -- Format argument sesuai yang diminta game lu (Kategori, GUID, Jumlah Maksimal)
                local args = {
                    [1] = "\228\184\185\232\141\175", -- Khusus Tab nomor 2 ("Dan Yao")
                    [2] = tostring(itemGuid.Value or itemGuid),
                    [3] = tonumber(currentCount) -- Langsung bypass jumlah maksimal!
                }
                
                AddItemRemote:FireServer(unpack(args))
                print("Bot: Memasukkan GUID ("..tostring(args[2])..") sebanyak: "..currentCount)
                task.wait(0.15) -- Jeda aman anti-kick
            end
        end
        print("Bot: Semua Orb di Tab 2 selesai dimasukkan!")
    else
        print("Bot: Gagal akses data Inventory, mencoba jalur alternatif UI...")
        -- Jalur cadangan lewat UI jika folder disembunyikan server
        pcall(function()
            local ChoiceFrame = LocalPlayer.PlayerGui:WaitForChild("TradeGui").MainFrame.Tab2.Grid
            for _, slot in pairs(ChoiceFrame:GetChildren()) do
                if slot:IsA("ImageButton") and slot:GetAttribute("GUID") then
                    local args = {
                        [1] = "\228\184\185\232\141\175",
                        [2] = slot:GetAttribute("GUID"),
                        [3] = slot:GetAttribute("Amount")
                    }
                    AddItemRemote:FireServer(unpack(args))
                    task.wait(0.15)
                end
            end
        end)
    end
end

-- Alur utama Bot
local Target = Players:FindFirstChild(MainAccount)

if Target then
    local TradingBerjalan = true
    local TradeSudahKebuka = false
    
    -- Sakelar otomatis matikan skrip kalau tombol Accept akhir ditekan
    local KoneksiSensor
    KoneksiSensor = LockRemote.OnClientEvent:Connect(function()
        print("Bot: Trade dikunci! Mematikan loop pengirim undangan...")
        TradingBerjalan = false
        KoneksiSensor:Disconnect()
    end)
    
    while TradingBerjalan do
        -- Deteksi otomatis jika layar trade sudah aktif di bot
        local ScreenGui = LocalPlayer.PlayerGui:FindFirstChild("TradeGui") or LocalPlayer.PlayerGui:FindFirstChild("MainGui")
        if ScreenGui and ScreenGui.Enabled == true and not TradeSudahKebuka then
            TradeSudahKebuka = true
            task.spawn(KurasTabDanyao) -- Jalankan auto-dump item
        end
        
        -- Selama menu trade belum kebuka, kirim terus undangan tiap 4 detik
        if not TradeSudahKebuka then
            RequestRemote:FireServer(Target)
            print("Bot: Mengirim ajakan trade ke mainuhuy...")
        end
        
        task.wait(4)
    end
    
    task.wait(8) -- Nunggu 7 detik hitung mundur aman bawaan game selesai
    print("Bot: Sukses total! Skrip dinonaktifkan secara permanen.")
else
    print("Bot: Akun mainuhuy tidak ada di server ini.")
end
