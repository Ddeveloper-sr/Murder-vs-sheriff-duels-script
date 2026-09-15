local Players = game:GetService("Players")

local Visuals = {}

Visuals.Config = nil
Visuals.Enabled = false
Visuals.Highlights = {}

function Visuals:Init(Config)
    self.Config = Config
end

function Visuals:AddHighlight(player)
    if player == Players.LocalPlayer then
        return
    end

    local character = player.Character

    if not character then
        return
    end

    if self.Highlights[player] then
        return
    end

    local highlight = Instance.new("Highlight")

    highlight.Name = "DuelHighlight"
    highlight.FillTransparency = 0.75
    highlight.OutlineTransparency = 0
    highlight.Parent = character

    self.Highlights[player] = highlight
end

function Visuals:RemoveHighlight(player)
    local highlight = self.Highlights[player]

    if highlight then
        highlight:Destroy()
        self.Highlights[player] = nil
    end
end

function Visuals:Refresh()
    if not self.Enabled then
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        self:AddHighlight(player)
    end
end

function Visuals:Enable()
    self.Enabled = true

    self:Refresh()
end

function Visuals:Disable()
    self.Enabled = false

    for player, highlight in pairs(self.Highlights) do
        if highlight then
            highlight:Destroy()
        end

        self.Highlights[player] = nil
    end
end

return Visuals
