-- JAMINAN AKUN LU SUDAH MASUK GAME
if not game:IsLoaded() then 
    repeat task.wait(1) until game:IsLoaded() 
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local MainAccount = "mainuhuy" -- Target akun utama lu

-- Pipa Remote Event Hasil Sniffing (Bahasa Mandarin)
local RequestRemote = ReplicatedStorage:WaitForChild("\228\186\139\228\187\182"):WaitForChild("\229\133\172\231\148\168"):WaitForChild("\228\186\164\230\152\147"):WaitForChild("\231\148\179\232\175\183\228\186\164\230\152\147")
local AddItemRemote = ReplicatedStorage:WaitForChild("\228\186\139\228\187\182"):WaitForChild("\229\133\172\231\148\168"):WaitForChild("\228\186\164\230\152\147"):WaitForChild("\230\150\176\229\162\158\228\186\164\230\152\147\231\137\169\229\147\129")
local LockRemote    = ReplicatedStorage:WaitForChild("\228\186\139\228\187\182"):WaitForChild("\229\133\172\231\148\168"):WaitForChild("\228\186\164\230\152\147"):WaitForChild("\230\148\190\229\174\154\228\186\164\230\152\147")

-- FUNGSI UTAMA: NGURAS ISI TAS TAB 2 (DAN YAO)
local function KurasTabDanyao()
    print("Bot: Menu Trade Kebuka! Mulai ngelas data tas...")
    
    local Inventory = nil
    
    -- Perbaikan Logic Pencarian Folder Inventory (Lebih Akurat)
    local PlayerData = LocalPlayer:FindFirstChild("PlayerData") or ReplicatedStorage:FindFirstChild("PlayerData")
    if PlayerData then
        Inventory = PlayerData:FindFirstChild("Inventory") or PlayerData:FindFirstChild("\225\140\133")
    end
    
    -- Jalur Alternatif 2 (Cari berdasarkan nama Player di ReplicatedStorage)
    if not Inventory then
        for _, folder dalam pairs(ReplicatedStorage:GetChildren()) do
            if folder.Name == "PlayerData" and folder:FindFirstChild(LocalPlayer.Name) then
                Inventory = folder[LocalPlayer.Name]:FindFirstChild("Inventory")
            end
        end
    end

    -- PROSES PEMINDAHAN BARANG VIA EVENT
    if Inventory then
        for _, item dalam pairs(Inventory:GetChildren()) do
            local itemGuid = item:FindFirstChild("GUID") or item:FindFirstChild("Id") or item
            local itemCount = item:FindFirstChild("Count") or item:FindFirstChild("Amount") or item:FindFirstChild("Value")
            
            if itemGuid and itemCount then
                local nilaiGUID = (type(itemGuid) == "userdata" and itemGuid.Value) or itemGuid.Name or tostring(itemGuid)
                local nilaiJumlah = itemCount.Value or 1
                
                local args = {
                    [1] = "\228\184\185\232\141\175", -- Kategori: Dan Yao
                    [2] = tostring(nilaiGUID),     -- GUID Dinamis
                    [3] = tonumber(nilaiJumlah)    -- Jumlah Maksimal (Bypass)
                }
                
                AddItemRemote:FireServer(unpack(args))
                print("Bot: Sukses mindahin GUID [" .. tostring(args[2]) .. "] sebanyak: " .. nilaiJumlah)
                task.wait(0.2) -- Jeda dinaikin dikit ke 0.2 biar gak kena auto-kick anti-cheat
            end
        end
        print("Bot: Tab 2 lunas dikuras!")
    else
        print("Bot: Folder Tas gak ketemu, pake jurus cadangan lewat UI...")
        -- JURUS CADANGAN: Ekstrak GUID langsung dari element GUI layar HP
        pcall(function()
            local TradeGui = LocalPlayer.PlayerGui:FindFirstChild("TradeGui")
            if TradeGui then
                local Grid = TradeGui.MainFrame.Tab2.Grid
                for _, slot dalam pairs(Grid:GetChildren()) do
                    if slot:IsA("ImageButton") then
                        -- Ambil atribut GUID dari UI
                        local guiGUID = slot:GetAttribute("GUID") or slot.Name
                        local guiAmount = slot:GetAttribute("Amount") or slot:GetAttribute("Count") or 1
                        
                        if guiGUID then
                            local args = {
                                [1] = "\228\184\185\232\141\175",
                                [2] = tostring(guiGUID),
                                [3] = tonumber(guiAmount)
                            }
                            AddItemRemote:FireServer(unpack(args))
                            task.wait(0.2)
                        end
                    end
                end
            end
        end)
    end
end

-- =========================================================
-- ALUR EKSEKUSI BOT
-- =========================================================
local Target = Players:FindFirstChild(MainAccount)

if Target then
    local TradingBerjalan = true
    local TradeSudahKebuka = false
    
    -- Sensor otomatis pemutus putaran (Loop breaker)
    local KoneksiSensor
    KoneksiSensor = LockRemote.OnClientEvent:Connect(function()
        print("Bot: Transaksi dikunci oleh Main Account! Loop dimatikan.")
        TradingBerjalan = false
        if KoneksiSensor then KoneksiSensor:Disconnect() end
    end)
    
    -- Loop ngirim ajakan trade tiap 4 detik sampai direspon
    task.spawn(function()
        while TradingBerjalan do
            local TradeGui = LocalPlayer.PlayerGui:FindFirstChild("TradeGui")
            
            -- Cek apakah menu trade di layar lu beneran udah nongol?
            if TradeGui and (TradeGui.Enabled == true or TradeGui.MainFrame.Visible == true) then
                if not TradeSudahKebuka then
                    TradeSudahKebuka = true
                    task.wait(1) -- Jeda biar UI stabil
                    KurasTabDanyao() -- Sikat isi tas!
                end
            else
                -- Kalau belum kebuka, kirim terus surat cinta ajakan trade
                RequestRemote:FireServer(Target)
                print("Bot: Ngirim undangan trade ke " .. MainAccount .. "...")
            end
            task.wait(4)
        end
    end)
else
    print("Bot: ERROR! Akun utama lu (" .. MainAccount .. ") gak ada di server ini!")
end
