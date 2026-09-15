local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Duel = {}

Duel.Active = false
Duel.Role = "Spectator"
Duel.Config = nil

function Duel:Init(Config)
    self.Config = Config

    self:UpdateRole()

    LocalPlayer:GetAttributeChangedSignal("Role"):Connect(function()
        self:UpdateRole()
    end)
end

function Duel:UpdateRole()
    self.Role = LocalPlayer:GetAttribute("Role") or "Spectator"

    self.Active = self.Role == "Murderer"
        or self.Role == "Sheriff"

    print("[Duel] Your role:", self.Role)
end

function Duel:Start()
    print("[Duel] Client cannot assign its own role.")
    print("[Duel] Waiting for server assignment.")
end

function Duel:Stop()
    self.Active = false
end

function Duel:IsActive()
    return self.Active
end

function Duel:GetRole()
    return self.Role
end

return Duel
