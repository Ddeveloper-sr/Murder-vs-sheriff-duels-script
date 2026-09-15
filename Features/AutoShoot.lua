local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local AutoShoot = {}

AutoShoot.Enabled = false
AutoShoot.Config = nil
AutoShoot.Targeting = nil
AutoShoot.Connection = nil
AutoShoot.LastShot = 0

function AutoShoot:Init(Config)
    self.Config = Config

    self.Targeting = require(
        script.Parent.Targeting
    )
end

function AutoShoot:Fire(target)
    if not target then
        return
    end

    local now = os.clock()

    if now - self.LastShot < self.Config.AutoShoot.FireCooldown then
        return
    end

    self.LastShot = now

    local remotes = ReplicatedStorage:FindFirstChild("DuelRemotes")

    if not remotes then
        return
    end

    local fireEvent = remotes:FindFirstChild("RequestShot")

    if not fireEvent then
        return
    end

    local character = target.Character

    if not character then
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart")

    if not root then
        return
    end

    fireEvent:FireServer(root.Position)
end

function AutoShoot:Start()
    if self.Connection then
        return
    end

    self.Connection = RunService.Heartbeat:Connect(function()
        if not self.Enabled then
            return
        end

        local target = self.Targeting:GetTarget()

        if target then
            self:Fire(target)
        end
    end)
end

function AutoShoot:Stop()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
end

function AutoShoot:Toggle()
    self.Enabled = not self.Enabled

    if self.Enabled then
        self:Start()
    end

    return self.Enabled
end

return AutoShoot
