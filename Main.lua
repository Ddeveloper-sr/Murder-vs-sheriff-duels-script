local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local Config = require(script.Parent.Config)
local UI = require(script.Parent.UI)

local Features = {
    Duel = require(script.Parent.Features.Duel),
    AutoShoot = require(script.Parent.Features.AutoShoot),
    Targeting = require(script.Parent.Features.Targeting),
    Visuals = require(script.Parent.Features.Visuals),
}

local Hub = {}

function Hub:Start()
    print(("[Hub] %s %s started"):format(
        Config.HubName,
        Config.Version
    ))

    for name, feature in pairs(Features) do
        if feature.Init then
            feature:Init(Config)
        end
    end

    UI:Create(Config, Features)

    if Config.Visuals.Enabled then
        Features.Visuals:Enable()
    end
end

Hub:Start()

return Hub
