local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local UI = {}

local player = Players.LocalPlayer

local function create(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties) do
        object[property] = value
    end

    object.Parent = parent

    return object
end

local function makeButton(parent, text, position, callback)
    local button = create("TextButton", {
        Size = UDim2.fromOffset(210, 42),
        Position = position,
        BackgroundColor3 = Color3.fromRGB(40, 40, 48),
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = Color3.fromRGB(235, 235, 235),
        TextSize = 15,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = true,
    }, parent)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    button.MouseButton1Click:Connect(callback)

    return button
end

function UI:Create(Config, Features)
    local gui = create("ScreenGui", {
        Name = "MurderSheriffHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, player:WaitForChild("PlayerGui"))

    local main = create("Frame", {
        Size = UDim2.fromOffset(Config.UI.Width, Config.UI.Height),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(24, 24, 29),
        BorderSizePixel = 0,
    }, gui)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = main

    local title = create("TextLabel", {
        Size = UDim2.new(1, -30, 0, 45),
        Position = UDim2.fromOffset(15, 10),
        BackgroundTransparency = 1,
        Text = Config.HubName,
        TextColor3 = Color3.fromRGB(245, 245, 245),
        TextSize = 21,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, main)

    local version = create("TextLabel", {
        Size = UDim2.fromOffset(100, 25),
        Position = UDim2.new(1, -115, 0, 18),
        BackgroundTransparency = 1,
        Text = Config.Version,
        TextColor3 = Color3.fromRGB(150, 150, 160),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, main)

    local status = create("TextLabel", {
        Size = UDim2.new(1, -30, 0, 30),
        Position = UDim2.fromOffset(15, 58),
        BackgroundTransparency = 1,
        Text = "Ready",
        TextColor3 = Color3.fromRGB(150, 150, 160),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, main)

    local buttons = create("Frame", {
        Size = UDim2.new(1, -30, 0, 230),
        Position = UDim2.fromOffset(15, 95),
        BackgroundTransparency = 1,
    }, main)

    local autoShootButton

    makeButton(buttons, "Start Duel", UDim2.fromOffset(0, 0), function()
        Features.Duel:Start()
        status.Text = "Duel started"
    end)

    makeButton(buttons, "End Duel", UDim2.fromOffset(240, 0), function()
        Features.Duel:Stop()
        status.Text = "Duel ended"
    end)

    autoShootButton = makeButton(
        buttons,
        "Auto Shoot: OFF",
        UDim2.fromOffset(0, 55),
        function()
            local enabled = Features.AutoShoot:Toggle()

            autoShootButton.Text =
                "Auto Shoot: " .. (enabled and "ON" or "OFF")

            status.Text = enabled
                and "Auto Shoot enabled"
                or "Auto Shoot disabled"
        end
    )

    makeButton(buttons, "Target Nearest", UDim2.fromOffset(240, 55), function()
        local target = Features.Targeting:GetNearestTarget()

        if target then
            status.Text = "Target: " .. target.Name
        else
            status.Text = "No valid target"
        end
    end)

    makeButton(buttons, "Refresh Visuals", UDim2.fromOffset(0, 110), function()
        Features.Visuals:Refresh()
        status.Text = "Visuals refreshed"
    end)

    makeButton(buttons, "Clear Target", UDim2.fromOffset(240, 110), function()
        Features.Targeting:ClearTarget()
        status.Text = "Target cleared"
    end)

    local footer = create("TextLabel", {
        Size = UDim2.new(1, -30, 0, 30),
        Position = UDim2.new(0, 15, 1, -40),
        BackgroundTransparency = 1,
        Text = "Murder vs Sheriff • V1",
        TextColor3 = Color3.fromRGB(110, 110, 120),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, main)

    -- Dragging
    local dragging = false
    local dragStart
    local startPosition

    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = main.Position
        end
    end)

    title.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then
            return
        end

        if input.KeyCode == Config.UI.ToggleKey then
            main.Visible = not main.Visible
        end
    end)

    return gui
end

return UI
