local Config = {
    HubName = "Murder Sheriff Hub",
    Version = "V1.0.0",

    UI = {
        Width = 520,
        Height = 360,
        ToggleKey = Enum.KeyCode.RightShift,
    },

    Targeting = {
        MaxDistance = 150,
        TeamOnly = true,
    },

    AutoShoot = {
        Enabled = false,
        FireCooldown = 0.25,
    },

    Visuals = {
        Enabled = true,
        ShowRoles = true,
    },
}

return Config
