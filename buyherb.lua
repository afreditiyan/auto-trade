-- =========================================================
-- SCRIPT GABUNGAN: AUTO KONTRIBUSI + BELI HERB (PREVENT RELOG + GEM CHECK)
-- =========================================================

local TargetItemName = "Herb"
local MaksimalRefresh = 4
local WhitelistNames = { ["mainuhuy"] = true }
local MinimumGem = 50000 -- Batas bawah gem

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local MyAccountName = string.lower(LocalPlayer.Name)

-- Path Event & GUI
local contriEvent = ReplicatedStorage:WaitForChild("\228\186\139\228\187\182"):WaitForChild("\229\133\172\231\148\168"):WaitForChild("\229\133\172\228\188\154"):WaitForChild("\230\141\144\231\140\174")
local secondGUI = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GUI"):WaitForChild("二级界面")
local GuildItemList = secondGUI:WaitForChild("公会"):WaitForChild("背景"):WaitForChild("右侧界面"):WaitForChild("商店"):WaitForChild("列表")
local RefreshRemote = ReplicatedStorage:WaitForChild("\228\186\139\228\187\182"):WaitForChild("\229\133\172\231\148\168"):WaitForChild("\229\133\172\228\188\154"):WaitForChild("\229\136\183\230\150\176\229\133\172\228\188\154\229\149\134\229\186\151")

-- Path Gem (SESUAIKAN DENGAN PATH DI GAME LU!)
-- Biasanya ada di LocalPlayer.leaderstats atau GUI tertentu. 
-- Contoh: local GemLabel = LocalPlayer.PlayerGui.MainGui.GemLabel
local GemLabel = LocalPlayer.PlayerGui:WaitForChild("GUI"):WaitForChild("Main"):WaitForChild("GemText") 

local function GetCurrentGem()
    -- Ambil teks, hapus koma/titik, ubah ke angka
    local text = GemLabel.Text
    local num = tonumber(text:gsub("%D", "")) or 0
    return num
end

if getgenv().SudahSelesai then return end

local function ScanDanBeliHerbLive()
    for _, item in ipairs(GuildItemList:GetChildren()) do
        if item.ClassName == "Frame" and item.Visible == true then
            local btn = item:FindFirstChild("按钮")
            if btn then
                local nameObj = btn:FindFirstChild("名称")
                if nameObj and string.lower(nameObj.Text) == string.lower(TargetItemName) then
                    firesignal(btn.Activated)
                    task.wait(0.4) 
                end
            end
        end
    end
end

-- =========================================================
-- EKSEKUSI
-- =========================================================
task.spawn(function()
    getgenv().SudahSelesai = true 
    
    if not WhitelistNames[MyAccountName] then
        for i = 1, 10 do
            contriEvent:FireServer()
            task.wait(0.6)
        end
        task.wait(1.5)
    end
    
    for urutan = 1, MaksimalRefresh do
        ScanDanBeliHerbLive()
        
        -- Cek Gem sebelum Refresh
        if urutan < MaksimalRefresh then
            local currentGem = GetCurrentGem()
            if currentGem >= MinimumGem then
                RefreshRemote:FireServer()
                task.wait(1.5)
            else
                -- Gem kurang, stop proses refresh
                break 
            end
        end
    end
end)
