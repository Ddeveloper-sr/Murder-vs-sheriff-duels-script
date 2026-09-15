Murder Sheriff Hub

A modular Roblox hub designed for a Murder vs Sheriff duel experience.

Features

- Modern draggable interface
- Duel controls
- Target selection
- Configurable targeting distance
- Auto-shoot request system
- Player highlighting
- Modular Lua architecture
- Phone-friendly GitHub workflow

Structure

MurderSheriffHub/
├── Main.lua
├── Config.lua
├── UI.lua
└── Features/
    ├── Duel.lua
    ├── AutoShoot.lua
    ├── Targeting.lua
    └── Visuals.lua

Important

The shooting system is intentionally server-authoritative.

The client only sends a "RequestShot" request. The game's server must validate:

1. Whether the player is currently the Sheriff.
2. Whether the duel is active.
3. Whether the target is a valid opponent.
4. Whether the target is within the allowed range.
5. Whether the player can currently shoot.
6. Whether the requested shot is valid.

Never trust the client to determine damage or eliminate another player.

Version

V1.0.0
