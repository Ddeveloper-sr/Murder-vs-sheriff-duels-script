local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local Duel = {}

Duel.Active = false
Duel.Config = nil

function Duel:Init(Config)
    self.Config = Config
end

function Duel:Start()
    self.Active = true

    print("[Duel] Duel mode enabled")
end

function Duel:Stop()
    self.Active = false

    print("[Duel] Duel mode disabled")
end

function Duel:IsActive()
    return self.Active
end

return Duel
