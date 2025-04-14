-- BladeBall.lua (script para Blade Ball)
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "Soon - Moon: Blade Ball",
    LoadingTitle = "Cargando Blade Ball...",
    LoadingSubtitle = "by Wikindley",
})

local Tab = Window:CreateTab("Principal", nil)
Tab:CreateButton({
    Name = "Activar Auto-Parry",
    Callback = function()
        print("Auto-Parry activado (prueba)")
        -- Lógica de auto-parry (necesita más detalles del juego)
    end,
})
