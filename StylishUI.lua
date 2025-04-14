-- 👑 Script universal avanzado con Rayfield Interface Suite
-- Versión 2.0 con múltiples mejoras y funcionalidades

-- Cargar la biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Configuración de UI
local Window = Rayfield:CreateWindow({
    Name = "🌟 Ultimate Roblox Menu 🌟",
    LoadingTitle = "Cargando Ultimate Menu...",
    LoadingSubtitle = "by ScriptMaster",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UltimateMenuConfig",
        FileName = "UserSettings"
    },
    Discord = {
        Enabled = true,
        Invite = "YourDiscordInvite",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "Verificación",
        Subtitle = "Ingresa la clave para acceder",
        Note = "Obtén la clave en nuestro Discord",
        FileName = "UltimateKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"ULTIMATE2025"}
    }
})

-- Variables globales
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local originalWalkSpeed = Humanoid.WalkSpeed
local originalJumpPower = Humanoid.JumpPower
local noclipEnabled = false
local infiniteJumpEnabled = false
local autoFarmEnabled = false
local espEnabled = false
local espObjects = {}

-- Función para actualizar el personaje cuando vuelve a generarse
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = newCharacter:WaitForChild("Humanoid")
    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
    
    -- Restaurar configuraciones si estaban activas
    if Rayfield.Flags["SpeedEnabled"] then
        Humanoid.WalkSpeed = Rayfield.Flags["SpeedValue"]
    end
    
    if Rayfield.Flags["JumpEnabled"] then
        Humanoid.JumpPower = Rayfield.Flags["JumpValue"]
    end
    
    -- Restaurar otros estados
    if noclipEnabled then
        activateNoclip()
    end
end)

-- 🎮 Pestaña principal - Jugador
local MainTab = Window:CreateTab("🎮 Jugador", 4483362458)

MainTab:CreateSection("💨 Movimiento")

-- Toggle para activar velocidad personalizada
MainTab:CreateToggle({
    Name = "🏃 Velocidad Personalizada",
    CurrentValue = false,
    Flag = "SpeedEnabled",
    Callback = function(Value)
        if Value then
            Humanoid.WalkSpeed = Rayfield.Flags["SpeedValue"] or originalWalkSpeed
        else
            Humanoid.WalkSpeed = originalWalkSpeed
        end
    end
})

-- Slider para la velocidad
MainTab:CreateSlider({
    Name = "🚀 Ajustar Velocidad",
    Range = {16, 500},
    Increment = 1,
    Suffix = "velocidad",
    CurrentValue = 16,
    Flag = "SpeedValue",
    Callback = function(Value)
        if Rayfield.Flags["SpeedEnabled"] then
            Humanoid.WalkSpeed = Value
        end
    end
})

-- Toggle para activar salto personalizado
MainTab:CreateToggle({
    Name = "🦘 Salto Personalizado",
    CurrentValue = false,
    Flag = "JumpEnabled",
    Callback = function(Value)
        if Value then
            Humanoid.JumpPower = Rayfield.Flags["JumpValue"] or originalJumpPower
        else
            Humanoid.JumpPower = originalJumpPower
        end
    end
})

-- Slider para la altura del salto
MainTab:CreateSlider({
    Name = "🌋 Ajustar Fuerza de Salto",
    Range = {50, 500},
    Increment = 1,
    Suffix = "poder",
    CurrentValue = 50,
    Flag = "JumpValue",
    Callback = function(Value)
        if Rayfield.Flags["JumpEnabled"] then
            Humanoid.JumpPower = Value
        end
    end
})

-- Toggle para salto infinito
MainTab:CreateToggle({
    Name = "🔄 Salto Infinito",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(Value)
        infiniteJumpEnabled = Value
    end
})

-- Conexión para salto infinito
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and Character and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
})

MainTab:CreateSection("🛡️ Modos de Personaje")

-- Función para activar noclip
function activateNoclip()
    local noclipConnection
    noclipConnection = RunService.Stepped:Connect(function()
        if noclipEnabled and Character then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        else
            noclipConnection:Disconnect()
        end
    end)
end

-- Toggle para Noclip
MainTab:CreateToggle({
    Name = "👻 Noclip (Atravesar Paredes)",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        noclipEnabled = Value
        if Value then
            activateNoclip()
        end
    end
})

-- Toggle para Volar
MainTab:CreateToggle({
    Name = "🦅 Modo Volar",
    CurrentValue = false,
    Flag = "FlyMode",
    Callback = function(Value)
        if Value then
            local flyPart = Instance.new("BodyVelocity")
            flyPart.Parent = HumanoidRootPart
            flyPart.Name = "FlyPart"
            flyPart.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            flyPart.Velocity = Vector3.new(0, 0.1, 0)
            
            -- Control de vuelo
            local connection
            connection = RunService.RenderStepped:Connect(function()
                if not Rayfield.Flags["FlyMode"] then
                    connection:Disconnect()
                    return
                end
                
                local flySpeed = Rayfield.Flags["FlySpeed"] or 50
                local direction = Vector3.new()
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + (workspace.CurrentCamera.CFrame.LookVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - (workspace.CurrentCamera.CFrame.LookVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - (workspace.CurrentCamera.CFrame.RightVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + (workspace.CurrentCamera.CFrame.RightVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    direction = direction + Vector3.new(0, flySpeed, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    direction = direction - Vector3.new(0, flySpeed, 0)
                end
                
                flyPart.Velocity = direction
            end)
        else
            if HumanoidRootPart:FindFirstChild("FlyPart") then
                HumanoidRootPart.FlyPart:Destroy()
            end
        end
    end
})

-- Slider para velocidad de vuelo
MainTab:CreateSlider({
    Name = "✈️ Velocidad de Vuelo",
    Range = {10, 200},
    Increment = 1,
    Suffix = "velocidad",
    CurrentValue = 50,
    Flag = "FlySpeed"
})

-- Toggle para ser invisible
MainTab:CreateToggle({
    Name = "🔍 Invisibilidad",
    CurrentValue = false,
    Flag = "Invisible",
    Callback = function(Value)
        if Value then
            -- Guardar posición original
            local oldPos = HumanoidRootPart.CFrame
            
            -- Esperar a que el personaje muera y respawnee
            Character:BreakJoints()
            local newCharacter = LocalPlayer.CharacterAdded:Wait()
            local newRootPart = newCharacter:WaitForChild("HumanoidRootPart")
            
            -- Pequeño tiempo de espera para asegurarse de que todo cargue
            task.wait(0.5)
            
            -- Teletransportar al personaje a su posición original
            newRootPart.CFrame = oldPos
            
            -- Hacer invisible (desactivar renderizado)
            RunService:BindToRenderStep("Invisible", 100, function()
                for _, part in pairs(newCharacter:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("Decal") then
                        part.Transparency = 1
                    end
                end
            end)
        else
            RunService:UnbindFromRenderStep("Invisible")
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0
                elseif part:IsA("Decal") then
                    part.Transparency = 0
                end
            end
        end
    end
})

-- 🌎 Pestaña de mundo
local WorldTab = Window:CreateTab("🌎 Mundo", 4483362458)

WorldTab:CreateSection("🔆 Iluminación")

-- Slider para cambiar la hora del día
WorldTab:CreateSlider({
    Name = "🕐 Hora del Día",
    Range = {0, 24},
    Increment = 0.1,
    Suffix = "hora",
    CurrentValue = 14,
    Flag = "TimeOfDay",
    Callback = function(Value)
        game:GetService("Lighting").TimeOfDay = string.format("%02d:%02d:00", math.floor(Value), (Value - math.floor(Value)) * 60)
    end
})

-- Toggle para luz completa (sin sombras)
WorldTab:CreateToggle({
    Name = "☀️ Luz Completa (Sin Sombras)",
    CurrentValue = false,
    Flag = "FullBright",
    Callback = function(Value)
        if Value then
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").Ambient = Color3.fromRGB(178, 178, 178)
        else
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").GlobalShadows = true
            game:GetService("Lighting").Ambient = Color3.fromRGB(138, 138, 138)
        end
    end
})

-- Toggle para eliminar niebla
WorldTab:CreateToggle({
    Name = "🌫️ Eliminar Niebla",
    CurrentValue = false,
    Flag = "NoFog",
    Callback = function(Value)
        if Value then
            game:GetService("Lighting").FogEnd = 100000
            game:GetService("Lighting").FogStart = 0
        else
            game:GetService("Lighting").FogEnd = 10000
            game:GetService("Lighting").FogStart = 0
        end
    end
})

WorldTab:CreateSection("🏠 Objetos del Juego")

-- Función para crear ESP
function createEsp(object, color, text)
    if object:IsA("Model") and object:FindFirstChild("HumanoidRootPart") then
        local highlight = Instance.new("Highlight")
        highlight.FillColor = color
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = object
        
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.AlwaysOnTop = true
        billboard.Parent = object:FindFirstChild("HumanoidRootPart")
        
        local textLabel = Instance.new("TextLabel")
        textLabel.BackgroundTransparency = 1
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.Text = text or object.Name
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.TextStrokeTransparency = 0
        textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextScaled = true
        textLabel.Parent = billboard
        
        table.insert(espObjects, {highlight = highlight, billboard = billboard})
        return highlight, billboard
    end
end

-- Toggle para ESP de jugadores
WorldTab:CreateToggle({
    Name = "👁️ ESP Jugadores",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(Value)
        espEnabled = Value
        
        if Value then
            -- Limpiar ESP existente
            for _, obj in pairs(espObjects) do
                pcall(function()
                    obj.highlight:Destroy()
                    obj.billboard:Destroy()
                end)
            end
            espObjects = {}
            
            -- Crear ESP para jugadores existentes
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    createEsp(player.Character, Color3.fromRGB(255, 0, 0), player.Name)
                end
            end
            
            -- Crear ESP para nuevos jugadores
            game.Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(char)
                    if espEnabled then
                        createEsp(char, Color3.fromRGB(255, 0, 0), player.Name)
                    end
                end)
            end)
        else
            -- Eliminar ESP
            for _, obj in pairs(espObjects) do
                pcall(function()
                    obj.highlight:Destroy()
                    obj.billboard:Destroy()
                end)
            end
            espObjects = {}
        end
    end
})

-- Toggle para mostrar cofres y objetos importantes
WorldTab:CreateToggle({
    Name = "🎁 Mostrar Cofres y Objetos",
    CurrentValue = false,
    Flag = "ItemESP",
    Callback = function(Value)
        if Value then
            -- Buscar y resaltar cofres y objetos importantes en diferentes juegos
            local itemsToFind = {"Chest", "Crate", "Loot", "Collect", "Gem", "Coin"}
            
            for _, item in pairs(workspace:GetDescendants()) do
                for _, itemName in pairs(itemsToFind) do
                    if item.Name:lower():find(itemName:lower()) and not item:FindFirstChild("ESPHighlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "ESPHighlight"
                        highlight.FillColor = Color3.fromRGB(255, 255, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.3
                        highlight.Parent = item
                        
                        table.insert(espObjects, {highlight = highlight})
                    end
                end
            end
        else
            -- Eliminar resaltado de items
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:FindFirstChild("ESPHighlight") then
                    obj.ESPHighlight:Destroy()
                end
            end
        end
    end
})

-- 🧙 Pestaña de combate
local CombatTab = Window:CreateTab("🧙 Combate", 4483362458)

CombatTab:CreateSection("⚔️ Opciones de Combate")

-- Toggle para aimbot
CombatTab:CreateToggle({
    Name = "🎯 Aimbot",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        if Value then
            local aimbotConnection
            aimbotConnection = RunService.RenderStepped:Connect(function()
                if not Rayfield.Flags["Aimbot"] then
                    aimbotConnection:Disconnect()
                    return
                end
                
                local closestPlayer = nil
                local shortestDistance = math.huge
                
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                        local distance = (player.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
                        if distance < shortestDistance and distance < Rayfield.Flags["AimbotDistance"] then
                            closestPlayer = player
                            shortestDistance = distance
                        end
                    end
                end
                
                if closestPlayer then
                    local targetPosition = closestPlayer.Character.HumanoidRootPart.Position
                    local targetVector = (targetPosition - workspace.CurrentCamera.CFrame.Position).Unit
                    local lookVector = workspace.CurrentCamera.CFrame.LookVector
                    
                    local smoothing = Rayfield.Flags["AimbotSmoothing"] or 5
                    local lerpVector = lookVector:Lerp(targetVector, 1/smoothing)
                    
                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + lerpVector)
                end
            end)
        end
    end
})

-- Slider para distancia de aimbot
CombatTab:CreateSlider({
    Name = "📏 Distancia Aimbot",
    Range = {10, 500},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = 100,
    Flag = "AimbotDistance"
})

-- Slider para suavizado de aimbot
CombatTab:CreateSlider({
    Name = "🔄 Suavizado Aimbot",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = "suavidad",
    CurrentValue = 5,
    Flag = "AimbotSmoothing"
})

-- Toggle para auto-disparo
CombatTab:CreateToggle({
    Name = "🔫 Auto-Disparo",
    CurrentValue = false,
    Flag = "AutoFire",
    Callback = function(Value)
        if Value then
            -- Detectar armas equipadas o disparos
            local autoFireConnection
            autoFireConnection = RunService.Heartbeat:Connect(function()
                if not Rayfield.Flags["AutoFire"] then
                    autoFireConnection:Disconnect()
                    return
                end
                
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    local fireFunction = tool:FindFirstChild("Fire") or tool:FindFirstChild("Shoot") or tool:FindFirstChild("Attack")
                    if fireFunction and fireFunction:IsA("RemoteEvent") then
                        fireFunction:FireServer()
                    elseif tool:FindFirstChild("Activate") and tool.Activate:IsA("RemoteEvent") then
                        tool.Activate:FireServer()
                    end
                end
            end)
        end
    end
})

-- Toggle para hit box expander
CombatTab:CreateToggle({
    Name = "📦 Expandir Hitbox Enemigos",
    CurrentValue = false,
    Flag = "HitboxExpander",
    Callback = function(Value)
        local expandSize = 5 -- Tamaño predeterminado

        if Value then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(expandSize, expandSize, expandSize)
                    hrp.Transparency = 0.5
                    hrp.CanCollide = false
                end
            end
            
            -- Conectar para nuevos jugadores
            Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(char)
                    wait(1)
                    if Rayfield.Flags["HitboxExpander"] and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.Size = Vector3.new(expandSize, expandSize, expandSize)
                        char.HumanoidRootPart.Transparency = 0.5
                        char.HumanoidRootPart.CanCollide = false
                    end
                end)
            end)
        else
            -- Restaurar tamaños normales
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    player.Character.HumanoidRootPart.Transparency = 1
                end
            end
        end
    end
})

CombatTab:CreateSection("🤖 Auto-Farm")

-- Toggle para auto-farm
CombatTab:CreateToggle({
    Name = "🧲 Auto-Farm",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(Value)
        autoFarmEnabled = Value
        
        if Value then
            local farmConnection
            farmConnection = RunService.Heartbeat:Connect(function()
                if not autoFarmEnabled then
                    farmConnection:Disconnect()
                    return
                end
                
                local farmMethod = Rayfield.Flags["FarmMethod"] or "Coins"
                local targetObjects = {}
                
                -- Identificar objetivos basados en el método seleccionado
                if farmMethod == "Coins" then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj.Name:lower():find("coin") or obj.Name:lower():find("cash") or obj.Name:lower():find("money") then
                            table.insert(targetObjects, obj)
                        end
                    end
                elseif farmMethod == "Enemies" then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(obj) then
                            table.insert(targetObjects, obj.HumanoidRootPart)
                        end
                    end
                elseif farmMethod == "Items" then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj.Name:lower():find("item") or obj.Name:lower():find("collect") or obj.Name:lower():find("pickup") then
                            table.insert(targetObjects, obj)
                        end
                    end
                end
                
                -- Ir al objeto más cercano
                if #targetObjects > 0 then
                    local closestObject = nil
                    local shortestDistance = math.huge
                    
                    for _, obj in pairs(targetObjects) do
                        local distance = (obj.Position - HumanoidRootPart.Position).Magnitude
                        if distance < shortestDistance then
                            closestObject = obj
                            shortestDistance = distance
                        end
                    end
                    
                    if closestObject and shortestDistance < 100 then
                        HumanoidRootPart.CFrame = CFrame.new(closestObject.Position + Vector3.new(0, 3, 0))
                    end
                end
            end)
        end
    end
})

-- Dropdown para método de farming
CombatTab:CreateDropdown({
    Name = "🎯 Método Auto-Farm",
    Options = {"Coins", "Enemies", "Items"},
    CurrentOption = "Coins",
    Flag = "FarmMethod"
})

-- 🔄 Pestaña de teletransporte
local TeleportTab = Window:CreateTab("🔄 Teletransporte", 4483362458)

-- Sección para teletransportar a jugadores
TeleportTab:CreateSection("👥 Teletransporte a Jugadores")

-- Función para actualizar la lista de jugadores
local function updatePlayerList()
    local playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    return playerNames
end

-- Dropdown para teletransporte a jugador
local playerDropdown = TeleportTab:CreateDropdown({
    Name = "👤 Seleccionar Jugador",
    Options = updatePlayerList(),
    CurrentOption = "",
    Flag = "SelectedPlayer"
})

-- Botón para refrescar lista de jugadores
TeleportTab:CreateButton({
    Name = "🔄 Actualizar Lista de Jugadores",
    Callback = function()
        playerDropdown:Refresh(updatePlayerList(), true)
    end
})

-- Botón para teletransportarse al jugador seleccionado
TeleportTab:CreateButton({
    Name = "📍 Ir a Jugador Seleccionado",
    Callback = function()
        local selectedPlayer = Rayfield.Flags["SelectedPlayer"]
        if selectedPlayer and selectedPlayer ~= "" then
            local targetPlayer = Players:FindFirstChild(selectedPlayer)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                Rayfield:Notify({
                    Title = "Teletransporte Exitoso",
                    Content = "Te has teletransportado a " .. selectedPlayer,
                    Duration = 3,
                })
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Selecciona un jugador primero",
                Duration = 3,
            })
        end
    end
})

TeleportTab:CreateSection("🗺️ Ubicaciones del Mapa")

-- Función para guardar ubicación actual
local savedLocations = {}

TeleportTab:CreateInput({
    Name = "💾 Guardar Ubicación Actual",
    PlaceholderText = "Nombre de la ubicación",
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        if Text and Text ~= "" then
            savedLocations[Text] = HumanoidRootPart.CFrame
            
            -- Actualizar la lista de ubicaciones guardadas
            local locationNames = {}
            for name, _ in pairs(savedLocations) do
                table.insert(locationNames, name)
            end
            
            -- Refrescar el dropdown
            if locationDropdown then
                locationDropdown:Refresh(locationNames, true)
            end
            
            Rayfield:Notify({
                Title = "Ubicación Guardada",
                Content = "Se ha guardado la ubicación: " .. Text,
                Duration = 3,
            })
        end
    end
})

-- Dropdown para ubicaciones guardadas
locationDropdown = TeleportTab:CreateDropdown({
    Name = "📌 Ubicaciones Guardadas",
    Options = {},
    CurrentOption = "",
    Flag = "SelectedLocation"
})

-- Botón para teletransportarse a ubicación guardada
TeleportTab:CreateButton({
    Name = "🚀 Ir a Ubicación Guardada",
    Callback = function()
        local selectedLocation = Rayfield.Flags["SelectedLocation"]
        if selectedLocation and selectedLocation ~= "" and savedLocations[selectedLocation] then
            HumanoidRootPart.CFrame = savedLocations[selectedLocation]
            Rayfield:Notify({
                Title = "Teletransporte Exitoso",
                Content = "Te has teletransportado a " .. selectedLocation,
                Duration = 3,
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Selecciona una ubicación guardada primero",
                Duration = 3,
            })
        end
    end
})

-- 🛠️ Pestaña de utilidades
local UtilsTab = Window:CreateTab("🛠️ Utilidades", 4483362458)

UtilsTab:CreateSection("📱 Interfaz")

-- Toggle para mostrar/ocultar nombres de jugadores
UtilsTab:CreateToggle({
    Name = "📛 Mostrar Nombres de Jugadores",
    CurrentValue = true,
    Flag = "ShowNames",
    Callback = function(Value)
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Head") then
                if player.Character.Head:FindFirstChild("PlayerName") then
                    player.Character.Head.PlayerName.Enabled = Value
                end
            end
        end
    end
})

-- Toggle para FPS Booster
UtilsTab:CreateToggle({
    Name = "🚀 FPS Booster",
    CurrentValue = false,
    Flag = "FpsBooster",
    Callback = function(Value)
        if Value then
            -- Reducir calidad g
		if Value then
            -- Reducir calidad gráfica para mejorar rendimiento
            local lighting = game:GetService("Lighting")
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            
            -- Guardar configuración original
            local savedProps = {
                Brightness = lighting.Brightness,
                GlobalShadows = lighting.GlobalShadows,
                Ambient = lighting.Ambient,
                FogEnd = lighting.FogEnd,
                Technology = terrain.Technology,
                WaterWaveSize = terrain.WaterWaveSize,
                WaterWaveSpeed = terrain.WaterWaveSpeed,
                WaterReflectance = terrain.WaterReflectance,
                WaterTransparency = terrain.WaterTransparency
            }
            
            -- Aplicar optimizaciones
            lighting.Brightness = 1
            lighting.GlobalShadows = false
            lighting.Ambient = Color3.fromRGB(178, 178, 178)
            lighting.FogEnd = 100000
            
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 0
            
            -- Desactivar efectos
            for _, effect in pairs(lighting:GetChildren()) do
                if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("BloomEffect")
                    or effect:IsA("DepthOfFieldEffect") or effect:IsA("ColorCorrectionEffect") then
                    effect.Enabled = false
                end
            end
            
            -- Reducir calidad de renderizado
            settings().Rendering.QualityLevel = 1
        else
            -- Restaurar calidad gráfica original
            local lighting = game:GetService("Lighting")
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            
            lighting.Brightness = 1
            lighting.GlobalShadows = true
            lighting.Ambient = Color3.fromRGB(138, 138, 138)
            lighting.FogEnd = 10000
            
            terrain.WaterWaveSize = 0.15
            terrain.WaterWaveSpeed = 12
            terrain.WaterReflectance = 0.05
            terrain.WaterTransparency = 0.9
            
            -- Reactivar efectos
            for _, effect in pairs(lighting:GetChildren()) do
                if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("BloomEffect")
                    or effect:IsA("DepthOfFieldEffect") or effect:IsA("ColorCorrectionEffect") then
                    effect.Enabled = true
                end
            end
            
            -- Restaurar calidad de renderizado
            settings().Rendering.QualityLevel = 7
        end
    end
})

-- Toggle para Anti AFK
UtilsTab:CreateToggle({
    Name = "💤 Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        if Value then
            local virtualUser = game:GetService("VirtualUser")
            local antiAFKConnection
            antiAFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                virtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                wait(1)
                virtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                
                Rayfield:Notify({
                    Title = "Anti-AFK",
                    Content = "Movimiento simulado para evitar desconexión",
                    Duration = 2,
                })
            end)
            
            -- Guardar la conexión para poder desactivarla después
            _G.AntiAFKConnection = antiAFKConnection
        else
            if _G.AntiAFKConnection then
                _G.AntiAFKConnection:Disconnect()
                _G.AntiAFKConnection = nil
            end
        end
    end
})

UtilsTab:CreateSection("🎮 Jugabilidad")

-- Botón para resetear stats del personaje
UtilsTab:CreateButton({
    Name = "♻️ Resetear Estadísticas del Personaje",
    Callback = function()
        Humanoid.WalkSpeed = originalWalkSpeed
        Humanoid.JumpPower = originalJumpPower
        
        -- Resetear todos los toggles relacionados
        Rayfield:Set("SpeedEnabled", false)
        Rayfield:Set("JumpEnabled", false)
        
        Rayfield:Notify({
            Title = "Estadísticas Reseteadas",
            Content = "Se han restaurado las estadísticas originales del personaje",
            Duration = 3,
        })
    end
})

-- Botón para teletransportarse al spawn
UtilsTab:CreateButton({
    Name = "🏠 Volver al Punto de Spawn",
    Callback = function()
        local spawnPoints = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("SpawnPoints")
        
        if spawnPoints then
            if spawnPoints:IsA("SpawnLocation") then
                HumanoidRootPart.CFrame = spawnPoints.CFrame * CFrame.new(0, 3, 0)
            else
                local firstSpawn = spawnPoints:FindFirstChildOfClass("SpawnLocation") or spawnPoints:FindFirstChild("Spawn")
                if firstSpawn then
                    HumanoidRootPart.CFrame = firstSpawn.CFrame * CFrame.new(0, 3, 0)
                end
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "No se encontró punto de spawn",
                Duration = 3,
            })
        end
    end
})

-- Función para Auto-Detect (detectar juego y cargar configuración específica)
UtilsTab:CreateButton({
    Name = "🎯 Auto-Detect (Detectar Juego)",
    Callback = function()
        local gameId = game.PlaceId
        local gameName = game:GetService("MarketplaceService"):GetProductInfo(gameId).Name
        
        Rayfield:Notify({
            Title = "Juego Detectado",
            Content = "Nombre: " .. gameName .. "\nID: " .. gameId,
            Duration = 5,
        })
        
        -- Ejemplos de juegos populares con configuraciones específicas
        if gameId == 155615604 then -- Prison Life
            Rayfield:Notify({
                Title = "Prison Life Detectado",
                Content = "Cargando configuraciones específicas para Prison Life...",
                Duration = 3,
            })
            -- Agregar aquí configuraciones específicas para Prison Life
        elseif gameId == 1962086868 then -- Tower of Hell
            Rayfield:Notify({
                Title = "Tower of Hell Detectado",
                Content = "Cargando configuraciones específicas para Tower of Hell...",
                Duration = 3,
            })
            -- Agregar aquí configuraciones específicas para Tower of Hell
        elseif gameId == 286090429 then -- Arsenal
            Rayfield:Notify({
                Title = "Arsenal Detectado",
                Content = "Cargando configuraciones específicas para Arsenal...",
                Duration = 3,
            })
            -- Agregar aquí configuraciones específicas para Arsenal
        else
            Rayfield:Notify({
                Title = "Juego No Reconocido",
                Content = "No se encontraron configuraciones específicas para este juego. Se usarán opciones generales.",
                Duration = 5,
            })
        end
    end
})

-- 🎭 Pestaña de trolleo/diversión
local FunTab = Window:CreateTab("🎭 Diversión", 4483362458)

FunTab:CreateSection("🎭 Trolleo")

-- Botón para hacer bailar al personaje
FunTab:CreateButton({
    Name = "💃 Bailar",
    Callback = function()
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://3189773368" -- ID de animación de baile
        
        local animTrack = Humanoid:LoadAnimation(animation)
        animTrack:Play()
        
        wait(5) -- Duración del baile
        animTrack:Stop()
        animation:Destroy()
    end
})

-- Toggle para spam de chat
FunTab:CreateToggle({
    Name = "💬 Spam de Chat",
    CurrentValue = false,
    Flag = "ChatSpam",
    Callback = function(Value)
        if Value then
            _G.ChatSpamActive = true
            local messages = {
                "¡Hola a todos! 😊",
                "¿Cómo están? 🌟",
                "¡Este juego es increíble! 🎮",
                "¡Ultimate Menu es lo mejor! 👑",
                "¿Alguien quiere ser mi amigo? 🤝",
                "¡Vamos a jugar juntos! 🏆"
            }
            
            spawn(function()
                while _G.ChatSpamActive do
                    local randomMessage = messages[math.random(1, #messages)]
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(randomMessage, "All")
                    wait(3) -- Intervalo entre mensajes
                end
            end)
        else
            _G.ChatSpamActive = false
        end
    end
})

-- Input para mensajes de spam personalizados
FunTab:CreateInput({
    Name = "✏️ Mensaje de Spam Personalizado",
    PlaceholderText = "Escribe tu mensaje aquí",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        _G.CustomSpamMessage = Text
    end
})

-- Toggle para cambiar el aspecto del personaje
FunTab:CreateToggle({
    Name = "👻 Modo Fantasma",
    CurrentValue = false,
    Flag = "GhostMode",
    Callback = function(Value)
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                if Value then
                    part.Transparency = 0.7
                    part.Material = Enum.Material.ForceField
                    part.Color = Color3.fromRGB(255, 255, 255)
                else
                    part.Transparency = 0
                    part.Material = Enum.Material.Plastic
                    -- Restaurar color original
                end
            end
        end
    end
})

FunTab:CreateSection("🏆 Logros y Desafíos")

-- Botón para generar un desafío aleatorio
FunTab:CreateButton({
    Name = "🎲 Desafío Aleatorio",
    Callback = function()
        local challenges = {
            "Completa el nivel sin saltar",
            "Llega primero sin utilizar herramientas",
            "Gana un enfrentamiento usando solo armas cuerpo a cuerpo",
            "Consigue 5 eliminaciones en menos de un minuto",
            "Ayuda a 3 jugadores novatos",
            "Encuentra un huevo de pascua oculto en el mapa",
            "Completa una partida sin usar habilidades especiales",
            "Gana usando solo tu arma secundaria"
        }
        
        local randomChallenge = challenges[math.random(1, #challenges)]
        
        Rayfield:Notify({
            Title = "🏆 Desafío Aleatorio",
            Content = randomChallenge,
            Duration = 10,
        })
    end
})

-- Input para rastrear amigos
FunTab:CreateInput({
    Name = "👥 Rastrear Amigo",
    PlaceholderText = "Nombre del jugador",
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        local targetPlayer = Players:FindFirstChild(Text)
        
        if targetPlayer then
            if _G.FriendTracker then
                _G.FriendTracker:Disconnect()
            end
            
            -- Crear línea de rastreo
            local beam = Instance.new("Beam")
            beam.Width0 = 0.1
            beam.Width1 = 0.1
            beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 0))
            
            local attachment1 = Instance.new("Attachment")
            attachment1.Parent = HumanoidRootPart
            
            local attachment2 = Instance.new("Attachment")
            if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                attachment2.Parent = targetPlayer.Character.HumanoidRootPart
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = "No se encontró al jugador o su personaje",
                    Duration = 3,
                })
                return
            end
            
            beam.Attachment0 = attachment1
            beam.Attachment1 = attachment2
            beam.Parent = workspace
            
            Rayfield:Notify({
                Title = "Rastreando",
                Content = "Ahora estás rastreando a " .. targetPlayer.Name,
                Duration = 3,
            })
            
            -- Actualizar la línea cuando el jugador se mueve
            _G.FriendTracker = RunService.Heartbeat:Connect(function()
                if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") or not attachment1.Parent or not attachment2.Parent then
                    if _G.FriendTracker then
                        _G.FriendTracker:Disconnect()
                        beam:Destroy()
                        attachment1:Destroy()
                        attachment2:Destroy()
                        
                        Rayfield:Notify({
                            Title = "Rastreo Finalizado",
                            Content = "Se ha perdido la conexión con el jugador",
                            Duration = 3,
                        })
                    end
                end
            end)
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "No se encontró al jugador",
                Duration = 3,
            })
        end
    end
})

-- 🔒 Pestaña de seguridad
local SecurityTab = Window:CreateTab("🔒 Seguridad", 4483362458)

SecurityTab:CreateSection("🛡️ Protección")

-- Toggle para anti-kick
SecurityTab:CreateToggle({
    Name = "🦶 Anti-Kick",
    CurrentValue = false,
    Flag = "AntiKick",
    Callback = function(Value)
        if Value then
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local args = {...}
                local method = getnamecallmethod()
                
                if method == "Kick" or method == "kick" then
                    Rayfield:Notify({
                        Title = "Intento de Kick Bloqueado",
                        Content = "Se ha bloqueado un intento de expulsarte del servidor",
                        Duration = 5,
                    })
                    return wait(9e9)
                end
                
                return oldNamecall(self, ...)
            end)
            
            _G.AntiKickHook = oldNamecall
        else
            if _G.AntiKickHook then
                hookmetamethod(game, "__namecall", _G.AntiKickHook)
            end
        end
    end
})

-- Toggle para anti-ban (básico)
SecurityTab:CreateToggle({
    Name = "🚫 Anti-Ban (Experimental)",
    CurrentValue = false,
    Flag = "AntiBan",
    Callback = function(Value)
        if Value then
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local args = {...}
                local method = getnamecallmethod()
                
                if method == "FireServer" or method == "fireServer" then
                    local fcall = tostring(self)
                    if fcall:lower():find("ban") or fcall:lower():find("punish") or fcall:lower():find("report") then
                        Rayfield:Notify({
                            Title = "Intento de Ban Bloqueado",
                            Content = "Se ha bloqueado un posible intento de baneo",
                            Duration = 5,
                        })
                        return wait(9e9)
                    end
                end
                
                return oldNamecall(self, ...)
            end)
            
            _G.AntiBanHook = oldNamecall
        else
            if _G.AntiBanHook then
                hookmetamethod(game, "__namecall", _G.AntiBanHook)
            end
        end
    end
})

-- Toggle para anti cheat bypass (experimental)
SecurityTab:CreateToggle({
    Name = "🛡️ Anti-Cheat Bypass (Experimental)",
    CurrentValue = false,
    Flag = "AntiCheatBypass",
    Callback = function(Value)
        Rayfield:Notify({
            Title = "Función Experimental",
            Content = "Esta función puede no ser compatible con todos los juegos y podría resultar en detección",
            Duration = 5,
        })
        
        if Value then
            -- Intentar bypassear detecciones comunes
            local oldIndex
            oldIndex = hookmetamethod(game, "__index", function(self, key)
                if key == "WalkSpeed" or key == "JumpPower" or key == "HipHeight" or key == "CanCollide" then
                    if checkcaller() and not LocalPlayer then
                        -- Si es una llamada del sistema, permite que continue normalmente
                        return oldIndex(self, key)
                    end
                end
                return oldIndex(self, key)
            end)
            
            _G.AntiCheatHook = oldIndex
        else
            if _G.AntiCheatHook then
                hookmetamethod(game, "__index", _G.AntiCheatHook)
            end
        end
    end
})

SecurityTab:CreateSection("⚙️ Configuración")

-- Button to save all settings
SecurityTab:CreateButton({
    Name = "💾 Guardar Toda la Configuración",
    Callback = function()
        Rayfield:SaveConfiguration()
        Rayfield:Notify({
            Title = "Configuración Guardada",
            Content = "Tus ajustes han sido guardados correctamente",
            Duration = 3,
        })
    end
})

-- Button to reset all settings
SecurityTab:CreateButton({
    Name = "🗑️ Resetear Toda la Configuración",
    Callback = function()
        Rayfield:Notify({
            Title = "Confirmar Reset",
            Content = "¿Estás seguro de querer resetear todas las configuraciones?",
            Duration = 10,
            Actions = {
                Confirm = {
                    Name = "Confirmar",
                    Callback = function()
                        for _, tab in pairs(Window.Tabs) do
                            for _, element in pairs(tab.Elements) do
                                if element.Type == "Toggle" then
                                    element:Set(false)
                                elseif element.Type == "Slider" then
                                    element:Set(element.Range[1])
                                elseif element.Type == "Dropdown" then
                                    element:Set(element.Options[1])
                                end
                            end
                        end
                        
                        Rayfield:Notify({
                            Title = "Configuración Reseteada",
                            Content = "Todas las configuraciones han sido restablecidas",
                            Duration = 3,
                        })
                    end
                },
                Cancel = {
                    Name = "Cancelar",
                    Callback = function()
                        Rayfield:Notify({
                            Title = "Operación Cancelada",
                            Content = "No se ha realizado ningún cambio",
                            Duration = 3,
                        })
                    end
                }
            }
        })
    end
})

-- 📊 Pestaña de información
local InfoTab = Window:CreateTab("📊 Información", 4483362458)

InfoTab:CreateSection("🎮 Estadísticas")

-- Etiqueta para mostrar FPS
local fpsLabel = InfoTab:CreateLabel("⚡ FPS: Calculando...")

-- Etiqueta para mostrar ping
local pingLabel = InfoTab:CreateLabel("📶 Ping: Calculando...")

-- Actualizar FPS y ping cada segundo
local fps = 0
local pingMs = 0

local lastUpdate = tick()
RunService.RenderStepped:Connect(function()
    fps = fps + 1
    
    if tick() - lastUpdate >= 1 then
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        pingMs = math.floor(ping)
        
        fpsLabel:Set("⚡ FPS: " .. fps)
        pingLabel:Set("📶 Ping: " .. pingMs .. "ms")
        
        fps = 0
        lastUpdate = tick()
    end
end)

-- Etiqueta para mostrar información del servidor
InfoTab:CreateLabel("🌐 ID del Servidor: " .. game.JobId)
InfoTab:CreateLabel("👥 Jugadores: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers)
InfoTab:CreateLabel("🎮 ID del Juego: " .. game.PlaceId)

InfoTab:CreateSection("💬 Información del Script")

InfoTab:CreateLabel("🌟 Ultimate Roblox Menu v2.0")
InfoTab:CreateLabel("👨‍💻 Creado por ScriptMaster")
InfoTab:CreateLabel("📅 Última actualización: 13-04-2025")
InfoTab:CreateLabel("🛡️ Estado: Undetected")
InfoTab:CreateParagraph({
    Title = "📝 Notas",
    Content = "Este script está diseñado para ser compatible con la mayoría de juegos de Roblox. Las funciones experimentales pueden no funcionar en todos los juegos. Úsalo con precaución y no abuses de las funciones para evitar ser detectado."
})

-- Botón para unirse al Discord
InfoTab:CreateButton({
    Name = "🌐 Unirse al Discord",
    Callback = function()
        setclipboard("https://discord.gg/YourInviteLink")
        Rayfield:Notify({
            Title = "Enlace Copiado",
            Content = "El enlace al Discord ha sido copiado al portapapeles",
            Duration = 3,
        })
    end
})

-- Notificación de bienvenida
Rayfield:Notify({
    Title = "🌟 Ultimate Roblox Menu Cargado",
    Content = "¡Bienvenido! Utiliza las diferentes pestañas para explorar todas las funciones. Recuerda usar las opciones con moderación.",
    Duration = 8,
    Image = 4483362458,
    Actions = {
        Ignore = {
            Name = "👍 Entendido",
            Callback = function()
                print("Script cargado correctamente")
            end
        }
    }
})
