local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MIN_PLAYERS = 2
local ROUND_TIME = 120

local remotes = ReplicatedStorage:FindFirstChild("DuelRemotes")

if not remotes then
    remotes = Instance.new("Folder")
    remotes.Name = "DuelRemotes"
    remotes.Parent = ReplicatedStorage
end

local requestShot = remotes:FindFirstChild("RequestShot")

if not requestShot then
    requestShot = Instance.new("RemoteEvent")
    requestShot.Name = "RequestShot"
    requestShot.Parent = remotes
end

local currentRound = false
local roles = {}

local function setRole(player, role)
    roles[player] = role

    player:SetAttribute("Role", role)

    print(("[Roles] %s -> %s"):format(player.Name, role))
end

local function clearRoles()
    for player in pairs(roles) do
        if player.Parent then
            player:SetAttribute("Role", "Spectator")
        end
    end

    table.clear(roles)
end

local function getPlayers()
    local result = {}

    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(result, player)
    end

    return result
end

local function chooseRandom(list)
    if #list == 0 then
        return nil
    end

    return list[math.random(1, #list)]
end

local function assignRoles()
    local players = getPlayers()

    if #players < MIN_PLAYERS then
        return false
    end

    clearRoles()

    local murderer = chooseRandom(players)

    local remaining = {}

    for _, player in ipairs(players) do
        if player ~= murderer then
            table.insert(remaining, player)
        end
    end

    local sheriff = chooseRandom(remaining)

    if not murderer or not sheriff then
        return false
    end

    for _, player in ipairs(players) do
        if player == murderer then
            setRole(player, "Murderer")
        elseif player == sheriff then
            setRole(player, "Sheriff")
        else
            setRole(player, "Spectator")
        end
    end

    return true
end

local function startRound()
    if currentRound then
        return
    end

    if not assignRoles() then
        print("[Round] Not enough players.")
        return
    end

    currentRound = true

    print("[Round] Started")

    task.delay(ROUND_TIME, function()
        if currentRound then
            currentRound = false
            clearRoles()

            print("[Round] Time expired")
        end
    end)
end

local function endRound()
    currentRound = false
    clearRoles()

    print("[Round] Ended")
end

requestShot.OnServerEvent:Connect(function(player, targetPosition)
    -- Never trust the client.

    if not currentRound then
        return
    end

    if roles[player] ~= "Sheriff" then
        return
    end

    if typeof(targetPosition) ~= "Vector3" then
        return
    end

    local character = player.Character

    if not character then
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart")

    if not root then
        return
    end

    -- Find the Murderer.
    local murderer

    for targetPlayer, role in pairs(roles) do
        if role == "Murderer" then
            murderer = targetPlayer
            break
        end
    end

    if not murderer or not murderer.Character then
        return
    end

    local targetRoot =
        murderer.Character:FindFirstChild("HumanoidRootPart")

    local humanoid =
        murderer.Character:FindFirstChildOfClass("Humanoid")

    if not targetRoot or not humanoid then
        return
    end

    -- Basic server-side distance validation.
    local distance =
        (targetRoot.Position - root.Position).Magnitude

    if distance > 150 then
        return
    end

    -- Validate that the requested position is close to the
    -- actual target rather than accepting arbitrary damage claims.
    if (targetPosition - targetRoot.Position).Magnitude > 12 then
        return
    end

    humanoid:TakeDamage(100)

    print(
        ("[Shot] %s hit the Murderer"):format(player.Name)
    )

    endRound()
end)

Players.PlayerAdded:Connect(function(player)
    player:SetAttribute("Role", "Spectator")
end)

Players.PlayerRemoving:Connect(function(player)
    roles[player] = nil

    if currentRound then
        local remainingPlayers = getPlayers()

        if #remainingPlayers < MIN_PLAYERS then
            endRound()
        end
    end
end)

-- Automatically start a round whenever enough players are present.
task.spawn(function()
    while true do
        task.wait(5)

        if not currentRound and #Players:GetPlayers() >= MIN_PLAYERS then
            startRound()
        end
    end
end)
