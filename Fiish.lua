-- Fiish.lua (script para Fiish)
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
    Name = "Soon - Moon: Fiish",
    LoadingTitle = "Cargando Fiish...",
    LoadingSubtitle = "by Wikindley",
})

local Tab = Window:CreateTab("Principal", nil)
Tab:CreateButton({
    Name = "Activar Función Principal",
    Callback = function()
        print("Función principal para Fiish activada")
        -- Lógica específica para Fiish (necesito detalles)
    end,
})
