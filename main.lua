if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function klikTombol(btn)
    if btn then
        pcall(function()
            for _, conn in pairs(getconnections(btn.MouseButton1Click)) do conn:Fire() end
            for _, conn in pairs(getconnections(btn.MouseButton1Down)) do conn:Fire() end
            if firesignal then firesignal(btn.MouseButton1Click) end
        end)
    end
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

task.spawn(function()
    print("[MAIN ACCOUNT] Akun Utama (mainuhuy) Mode Sapu Jagat Aktif!")
    while true do
        pcall(function()
            -- 1. Auto terima ajakan trade dari SIAPA PUN yang ngirim di server
            local tombolTerimaInvite = cariTombolTeks({"terima", "accept", "setuju", "yes"})
            if tombolTerimaInvite then klikTombol(tombolTerimaInvite) end

            -- 2. Auto klik accept hijau di dalam trade
            local tombolAcceptTrade = cariTombolTeks({"setujui", "accept"})
            if tombolAcceptTrade then klikTombol(tombolAcceptTrade) end

            -- 3. Auto tutup pop-up sukses di akhir trade
            for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                if gui:IsA("TextLabel") and (gui.Text == "Trade Successful!" or gui.Text == "OK" or gui.Text == "CONFIRM") then
                    local btnClose = gui:FindFirstAncestorOfClass("ImageButton") or gui:FindFirstAncestorOfClass("TextButton") or gui.Parent
                    if btnClose then klikTombol(btnClose) end
                end
            end
        end)
        task.wait(1.2) -- Dibuat lebih cepat responnya
    end
end)
