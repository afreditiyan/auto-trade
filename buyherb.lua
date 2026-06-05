-- =========================================================
-- CONFIG DUAL MODE + WHITELIST AKUN UTAMA (SILENT VERSION)
-- =========================================================
local TargetItemName = "Herb"
local MaksimalRefresh = 3

local WhitelistNames = {
    ["mainuhuy"] = true
}

if not game:IsLoaded() then 
    repeat task.wait(1) until game:IsLoaded() 
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local MyAccountName = LocalPlayer.Name

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local secondGUI = PlayerGui:WaitForChild("GUI"):WaitForChild("二级界面")
local GuildItemList = secondGUI:WaitForChild("公会"):WaitForChild("背景"):WaitForChild("右侧界面"):WaitForChild("商店"):WaitForChild("列表")

local RefreshRemote = ReplicatedStorage:WaitForChild("\228\186\139\228\187\182"):WaitForChild("\229\133\172\231\148\168"):WaitForChild("\229\133\172\228\188\154"):WaitForChild("\229\136\183\230\150\176\229\133\172\228\188\154\229\149\134\229\186\151")

-- =========================================================
-- FUNGSI SCAN DAN BORONG HERB (METODE FIRESIGNAL)[cite: 1]
-- =========================================================
local function ScanDanBeliHerbLive()
    local NemuHerb = false
    
    for _, item in ipairs(GuildItemList:GetChildren()) do
        if item.ClassName == "Frame" and item.Visible == true then
            local btn = item:FindFirstChild("按钮")
            if btn then
                local nameObj = btn:FindFirstChild("名称")
                local stockObj = btn:FindFirstChild("库存")
                
                if nameObj and stockObj then
                    if string.find(string.lower(nameObj.Text), string.lower(TargetItemName)) then
                        local stock = tonumber(string.match(stockObj.Text, "(%d+)%s*Left")) or 0
                        
                        if stock > 0 then
                            firesignal(btn.Activated) --[cite: 1]
                            NemuHerb = true
                            task.wait(0.4) 
                        end
                    end
                end
            end
        end
    end
    return NemuHerb
end

-- =========================================================
-- CORE SYSTEM UTAMA (SINKRONISASI AKUN)
-- =========================================================
task.spawn(function()
    local CurrentNameLower = string.lower(MyAccountName)
    task.wait(0.5)
    
    if WhitelistNames[CurrentNameLower] then
        ScanDanBeliHerbLive()
    else
        for urutan = 1, MaksimalRefresh do
            ScanDanBeliHerbLive()
            
            if urutan < MaksimalRefresh then
                RefreshRemote:FireServer()
                task.wait(1.5)
            end
        end
    end
end)
