-- Soon - Moon Script Hub
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- IDs de los juegos soportados (necesito los reales)
local Games = {
    BladeBall = 13772394625, -- Ejemplo, confirmar ID real
    Fiish = 16732694052,       -- Placeholder, necesito el ID real
}

-- Función para cargar scripts desde una URL
function loadingame(url)
    local success, script = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        loadstring(script)()
        print("Soon - Moon: Script cargado desde " .. url)
    else
        warn("Soon - Moon: Error al cargar el script desde " .. url)
    end
end

-- Detectar el juego actual
local currentGameId = game.PlaceId
if currentGameId == Games.BladeBall then
    loadingame("https://raw.githubusercontent.com/WIKINDLEY/Soon-Moon/main/BladeBall.lua")
elseif currentGameId == Games.Fiish then
    loadingame("https://raw.githubusercontent.com/WIKINDLEY/Soon-Moon/main/Fiish.lua")
else
    loadingame("https://raw.githubusercontent.com/WIKINDLEY/Soon-Moon/main/Universal.lua")
end

-- Interfaz con Rayfield
local Window = Rayfield:CreateWindow({
    Name = "Soon - Moon",
    LoadingTitle = "Soon - Moon Script Hub",
    LoadingSubtitle = "by Wikindley",
})

local Tab = Window:CreateTab("Inicio", nil)
Tab:CreateLabel("¡Bienvenido a Soon - Moon!")
Tab:CreateLabel("Soportamos Blade Ball, Fiish y más.")
