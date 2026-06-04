-- RUN DI SEMUA AKUN BOT/TUMBAL LU --
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MainAccount = "mainuhuy" -- Target akun utama lu

local TradeRemote = ReplicatedStorage:WaitForChild("\228\186\139\228\187\182")
                                     :WaitForChild("\229\133\172\231\148\168")
                                     :WaitForChild("\228\186\164\230\152\147")
                                     :WaitForChild("\231\148\179\232\175\183\228\186\164\230\152\147")

_G.BotMultiLoop = true

task.spawn(function()
    while _G.BotMultiLoop do
        local Target = Players:FindFirstChild(MainAccount)
        if Target then
            local args = {
                [1] = Target
            }
            -- Bot ngajak trade dengan membawa target objek mainuhuy
            TradeRemote:FireServer(unpack(args))
        end
        task.wait(4) -- Bot ngajak trade setiap 4 detik
    end
end)
