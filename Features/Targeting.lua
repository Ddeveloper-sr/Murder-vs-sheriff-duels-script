local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Targeting = {}

Targeting.Config = nil
Targeting.CurrentTarget = nil

function Targeting:Init(Config)
    self.Config = Config
end

local function getRoot(character)
    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

function Targeting:IsValidTarget(player)
    if not player or player == LocalPlayer then
        return false
    end

    local character = player.Character
    local root = getRoot(character)

    if not root then
        return false
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not humanoid or humanoid.Health <= 0 then
        return false
    end

    if self.Config.Targeting.TeamOnly then
        if LocalPlayer.Team and player.Team == LocalPlayer.Team then
            return false
        end
    end

    local localCharacter = LocalPlayer.Character
    local localRoot = getRoot(localCharacter)

    if not localRoot then
        return false
    end

    local distance = (root.Position - localRoot.Position).Magnitude

    return distance <= self.Config.Targeting.MaxDistance
end

function Targeting:GetNearestTarget()
    local localCharacter = LocalPlayer.Character
    local localRoot = getRoot(localCharacter)

    if not localRoot then
        return nil
    end

    local nearest = nil
    local nearestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if self:IsValidTarget(player) then
            local root = getRoot(player.Character)

            if root then
                local distance =
                    (root.Position - localRoot.Position).Magnitude

                if distance < nearestDistance then
                    nearest = player
                    nearestDistance = distance
                end
            end
        end
    end

    self.CurrentTarget = nearest

    return nearest
end

function Targeting:ClearTarget()
    self.CurrentTarget = nil
end

function Targeting:GetTarget()
    if self.CurrentTarget and self:IsValidTarget(self.CurrentTarget) then
        return self.CurrentTarget
    end

    return self:GetNearestTarget()
end

return Targeting
