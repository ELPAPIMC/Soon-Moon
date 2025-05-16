-- // Library Mejorada // --
local UILibrary = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")

-- // Configuración // --
local config = {
    TweenSpeed = 0.3,
    MainColor = Color3.fromRGB(30, 30, 30),
    AccentColor = Color3.fromRGB(100, 100, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    ToggleOnColor = Color3.fromRGB(0, 170, 255),
    ToggleOffColor = Color3.fromRGB(100, 100, 100),
    CornerRadius = UDim.new(0, 8),
    SliderColor = Color3.fromRGB(0, 170, 255),
    NotificationBG = Color3.fromRGB(35, 35, 35),
    NotificationSuccess = Color3.fromRGB(50, 205, 50),
    NotificationError = Color3.fromRGB(255, 70, 70),
    NotificationInfo = Color3.fromRGB(0, 170, 255),
    NotificationWarning = Color3.fromRGB(255, 165, 0)
}

-- // Ranks con sus respectivos IDs y colores // --
local Ranks = {
    OWNER = {
        Color = Color3.fromRGB(255, 0, 0),
        ID = {123456789} -- IDs de propietarios (ejemplo)
    },
    ADMIN = {
        Color = Color3.fromRGB(255, 80, 80),
        ID = {987654321, 123123123} -- IDs de admins (ejemplo)
    },
    MOD = {
        Color = Color3.fromRGB(0, 255, 127),
        ID = {456456456} -- IDs de moderadores (ejemplo)
    },
    VIP = {
        Color = Color3.fromRGB(255, 215, 0),
        ID = {789789789} -- IDs de VIPs (ejemplo)
    },
    USER = {
        Color = Color3.fromRGB(180, 180, 180),
        ID = {} -- Todos los demás
    }
}

-- // Sistema de Notificaciones // --
local NotificationSystem = {}

function NotificationSystem:Notify(title, message, icon, duration, notifType)
    duration = duration or 3
    notifType = notifType or "info"
    
    -- Colores según tipo de notificación
    local notifColors = {
        success = config.NotificationSuccess,
        error = config.NotificationError,
        info = config.NotificationInfo,
        warning = config.NotificationWarning
    }
    
    -- Obtener color del tipo de notificación
    local notifColor = notifColors[notifType] or config.NotificationInfo
    
    -- Crear ScreenGui para la notificación
    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "Notification"
    NotifGui.ResetOnSpawn = false
    NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Intentar poner la notificación en CoreGui
    pcall(function()
        NotifGui.Parent = game.CoreGui
    end)
    
    -- Si falla, ponerla en PlayerGui
    if NotifGui.Parent == nil then
        NotifGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Frame principal
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "NotificationFrame"
    NotifFrame.Size = UDim2.new(0, 280, 0, 80)
    NotifFrame.Position = UDim2.new(1, 300, 0.9, -85)
    NotifFrame.BackgroundColor3 = config.NotificationBG
    NotifFrame.BorderSizePixel = 0
    NotifFrame.AnchorPoint = Vector2.new(1, 1)
    NotifFrame.Parent = NotifGui
    
    -- Redondear el frame
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = NotifFrame
    
    -- Barra de color según tipo
    local ColorBar = Instance.new("Frame")
    ColorBar.Name = "ColorBar"
    ColorBar.Size = UDim2.new(0, 4, 1, 0)
    ColorBar.BackgroundColor3 = notifColor
    ColorBar.BorderSizePixel = 0
    ColorBar.Parent = NotifFrame
    
    -- Redondear la barra de color (sólo esquinas izquierdas)
    local ColorBarCorner = Instance.new("UICorner")
    ColorBarCorner.CornerRadius = UDim.new(0, 8)
    ColorBarCorner.Parent = ColorBar
    
    -- Arreglar las esquinas derechas de la barra
    local ColorBarFix = Instance.new("Frame")
    ColorBarFix.Name = "Fix"
    ColorBarFix.Size = UDim2.new(0.5, 0, 1, 0)
    ColorBarFix.Position = UDim2.new(0.5, 0, 0, 0)
    ColorBarFix.BackgroundColor3 = notifColor
    ColorBarFix.BorderSizePixel = 0
    ColorBarFix.Parent = ColorBar
    
    -- Icono de la notificación
    local NotifIcon = Instance.new("ImageLabel")
    NotifIcon.Name = "Icon"
    NotifIcon.Size = UDim2.new(0, 30, 0, 30)
    NotifIcon.Position = UDim2.new(0, 15, 0, 25)
    NotifIcon.BackgroundTransparency = 1
    
    -- Establecer icono según tipo si no se proporciona uno
    if not icon or icon == "" then
        if notifType == "success" then
            NotifIcon.Image = "rbxassetid://6031094667" -- Ícono de verificación
        elseif notifType == "error" then
            NotifIcon.Image = "rbxassetid://6031094678" -- Ícono de error
        elseif notifType == "warning" then
            NotifIcon.Image = "rbxassetid://6031071057" -- Ícono de advertencia  
        else -- info por defecto
            NotifIcon.Image = "rbxassetid://6031068420" -- Ícono de información
        end
    else
        NotifIcon.Image = icon
    end
    
    NotifIcon.ImageColor3 = notifColor
    NotifIcon.Parent = NotifFrame
    
    -- Título de la notificación
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -65, 0, 25)
    TitleLabel.Position = UDim2.new(0, 55, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = config.TextColor
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextWrapped = true
    TitleLabel.Parent = NotifFrame
    
    -- Mensaje de la notificación
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Name = "Message"
    MessageLabel.Size = UDim2.new(1, -65, 0, 40)
    MessageLabel.Position = UDim2.new(0, 55, 0, 35)
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Text = message
    MessageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    MessageLabel.TextSize = 14
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.TextWrapped = true
    MessageLabel.Parent = NotifFrame
    
    -- Barra de progreso
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Name = "ProgressBar"
    ProgressBar.Size = UDim2.new(1, 0, 0, 3)
    ProgressBar.Position = UDim2.new(0, 0, 1, -3)
    ProgressBar.BackgroundColor3 = notifColor
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = NotifFrame
    
    -- Redondear barra de progreso
    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(0, 8)
    ProgressCorner.Parent = ProgressBar
    
    -- Animación de entrada
    NotifFrame:TweenPosition(UDim2.new(1, -20, 0.9, -85), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
    
    -- Animación de la barra de progreso
    TweenService:Create(ProgressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 3)}):Play()
    
    -- Eliminar la notificación después del tiempo
    task.delay(duration, function()
        -- Animación de salida
        local outTween = TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 0.9, -85)})
        outTween:Play()
        outTween.Completed:Connect(function()
            NotifGui:Destroy()
        end)
    end)
end

-- // Iniciar la GUI // --
function UILibrary:Create(title, draggable)
    local GuiName = title or "UI Library"
    draggable = draggable ~= nil and draggable or true
    
    -- Crear ScreenGui principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = GuiName
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Intentar poner la UI en CoreGui
    pcall(function()
        ScreenGui.Parent = game.CoreGui
    end)
    
    -- Si falla, ponerla en PlayerGui
    if ScreenGui.Parent == nil then
        ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Frame principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.BackgroundColor3 = config.MainColor
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui
    
    -- Efecto de sombra
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = 0
    Shadow.Parent = MainFrame
    
    -- Redondear bordes del MainFrame
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = config.CornerRadius
    Corner.Parent = MainFrame
    
    -- Título
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = config.AccentColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    -- Redondear bordes de TitleBar
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = config.CornerRadius
    TitleCorner.Parent = TitleBar
    
    -- Arreglar la esquina inferior
    local FixTitleBar = Instance.new("Frame")
    FixTitleBar.Name = "FixTitleBar"
    FixTitleBar.Size = UDim2.new(1, 0, 0, 10)
    FixTitleBar.Position = UDim2.new(0, 0, 1, -10)
    FixTitleBar.BackgroundColor3 = config.AccentColor
    FixTitleBar.BorderSizePixel = 0
    FixTitleBar.ZIndex = 0
    FixTitleBar.Parent = TitleBar
    
    -- Ícono de la UI (opcional)
    local TitleIcon = Instance.new("ImageLabel")
    TitleIcon.Name = "Icon"
    TitleIcon.Size = UDim2.new(0, 25, 0, 25)
    TitleIcon.Position = UDim2.new(0, 10, 0, 7)
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Image = "rbxassetid://6031094678" -- Ícono por defecto, puedes cambiarlo
    TitleIcon.ImageColor3 = config.TextColor
    TitleIcon.Parent = TitleBar
    
    -- Título texto
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "Title"
    TitleText.Size = UDim2.new(1, -120, 1, 0)
    TitleText.Position = UDim2.new(0, 45, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = GuiName
    TitleText.TextColor3 = config.TextColor
    TitleText.TextSize = 18
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Minimizar botón
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -75, 0, 5)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = config.TextColor
    MinimizeButton.TextSize = 20
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = TitleBar
    
    -- Redondear el botón de minimizar
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = MinimizeButton
    
    -- Botón de cierre
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = config.TextColor
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    -- Redondear el botón de cierre
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    -- Evento para cerrar la GUI
    CloseButton.MouseButton1Click:Connect(function()
        -- Animación de cierre
        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        closeTween:Play()
        closeTween.Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end)
    
    -- Variable para controlar minimizado
    local Minimized = false
    local OriginalSize = MainFrame.Size
    
    -- Evento para minimizar/maximizar la GUI
    MinimizeButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        
        if Minimized then
            local minimizeTween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 600, 0, 40)
            })
            minimizeTween:Play()
        else
            local maximizeTween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = OriginalSize
            })
            maximizeTween:Play()
        end
    end)
    
    -- Panel de contenido con pestañas
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -20, 1, -60)
    ContentFrame.Position = UDim2.new(0, 10, 0, 50)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ClipsDescendants = true
    ContentFrame.Parent = MainFrame
    
    -- Divisor para Tabs y Contenido
    local TabsFrame = Instance.new("Frame")
    TabsFrame.Name = "TabsFrame"
    TabsFrame.Size = UDim2.new(0, 150, 1, 0)
    TabsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabsFrame.BorderSizePixel = 0
    TabsFrame.Parent = ContentFrame
    
    -- Redondear TabsFrame
    local TabsCorner = Instance.new("UICorner")
    TabsCorner.CornerRadius = config.CornerRadius
    TabsCorner.Parent = TabsFrame
    
    -- Panel donde se muestran las tabs
    local TabsList = Instance.new("ScrollingFrame")
    TabsList.Name = "TabsList"
    TabsList.Size = UDim2.new(1, -10, 1, -120) -- Dejamos espacio para el perfil
    TabsList.Position = UDim2.new(0, 5, 0, 5)
    TabsList.BackgroundTransparency = 1
    TabsList.BorderSizePixel = 0
    TabsList.ScrollBarThickness = 2
    TabsList.ScrollingDirection = Enum.ScrollingDirection.Y
    TabsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabsList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabsList.Parent = TabsFrame
    
    -- Layout para las pestañas
    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.Padding = UDim.new(0, 5)
    TabsLayout.Parent = TabsList
    
    -- Panel para el perfil de usuario
    local UserProfileFrame = Instance.new("Frame")
    UserProfileFrame.Name = "UserProfile"
    UserProfileFrame.Size = UDim2.new(1, -10, 0, 100)
    UserProfileFrame.Position = UDim2.new(0, 5, 1, -110)
    UserProfileFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    UserProfileFrame.BorderSizePixel = 0
    UserProfileFrame.Parent = TabsFrame
    
    -- Redondear UserProfileFrame
    local ProfileCorner = Instance.new("UICorner")
    ProfileCorner.CornerRadius = config.CornerRadius
    ProfileCorner.Parent = UserProfileFrame
    
    -- Avatar del jugador
    local Avatar = Instance.new("ImageLabel")
    Avatar.Name = "Avatar"
    Avatar.Size = UDim2.new(0, 60, 0, 60)
    Avatar.Position = UDim2.new(0.5, -30, 0, 10)
    Avatar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Avatar.BorderSizePixel = 0
    
    -- Intentar obtener avatar del jugador
    local player = Players.LocalPlayer
    local userId = player and player.UserId
    if userId then
        Avatar.Image = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end
    Avatar.Parent = UserProfileFrame
    
    -- Redondear Avatar
    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0) -- Perfecto círculo
    AvatarCorner.Parent = Avatar
    
    -- Nombre del jugador
    local UserName = Instance.new("TextLabel")
    UserName.Name = "UserName"
    UserName.Size = UDim2.new(1, -10, 0, 20)
    UserName.Position = UDim2.new(0, 5, 0, 75)
    UserName.BackgroundTransparency = 1
    UserName.Text = player and player.Name or "Usuario"
    UserName.TextColor3 = config.TextColor
    UserName.TextSize = 14
    UserName.Font = Enum.Font.GothamSemibold
    UserName.Parent = UserProfileFrame
    
    -- Determinar el rango del jugador según su ID
    local userRank = "USER"  -- Rango predeterminado
    local userRankColor = Ranks.USER.Color
    
    if userId then
        -- Verificar si el ID está en alguno de los rangos
        for rank, data in pairs(Ranks) do
            for _, id in ipairs(data.ID) do
                if id == userId then
                    userRank = rank
                    userRankColor = data.Color
                    break
                end
            end
        end
    end
    
    -- Rango del jugador
    local UserRank = Instance.new("TextLabel")
    UserRank.Name = "UserRank"
    UserRank.Size = UDim2.new(1, -10, 0, 15)
    UserRank.Position = UDim2.new(0, 5, 1, -20)
    UserRank.BackgroundTransparency = 1
    UserRank.Text = userRank
    UserRank.TextColor3 = userRankColor
    UserRank.TextSize = 12
    UserRank.Font = Enum.Font.GothamBold
    UserRank.Parent = UserProfileFrame
    
    -- Marco de contenido para las pestañas
    local TabContent = Instance.new("Frame")
    TabContent.Name = "TabContent"
    TabContent.Size = UDim2.new(1, -160, 1, 0)
    TabContent.Position = UDim2.new(0, 160, 0, 0)
    TabContent.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabContent.BorderSizePixel = 0
    TabContent.Parent = ContentFrame
    
    -- Redondear TabContent
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = config.CornerRadius
    ContentCorner.Parent = TabContent
    
    -- Padding para el contenido
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingLeft = UDim.new(0, 10)
    ContentPadding.PaddingRight = UDim.new(0, 10)
    ContentPadding.PaddingTop = UDim.new(0, 10)
    ContentPadding.PaddingBottom = UDim.new(0, 10)
    ContentPadding.Parent = TabContent
    
    -- Objetos para las pestañas
    local Tabs = {}
    local CurrentTab = nil
    
    -- Hacer la ventana arrastrables
    if draggable then
        local isDragging = false
        local dragInput
        local dragStart
        local startPos
        
        local function updateDrag(input)
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
        
        TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        isDragging = false
                    end
                end)
            end
        end)
        
        TitleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and isDragging then
                updateDrag(input)
            end
        end)
    end
    
    -- Agregar animación de apertura
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    local openTween = TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 400)})
    openTween:Play()
    
    -- Función para crear una pestaña
    function UILibrary:AddTab(tabName, iconId)
        -- Botón de la pestaña
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabsList
        
        -- Redondear TabButton
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = TabButton
        
        -- Icono (opcional)
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.Size = UDim2.new(0, 24, 0, 24)
        TabIcon.Position = UDim2.new(0, 8, 0.5, -12)
        TabIcon.BackgroundTransparency = 1
        TabIcon.ImageTransparency = 0.1
        if iconId and iconId ~= "" then
            TabIcon.Image = iconId
        else
            TabIcon.Image = "rbxassetid://3926305904" -- Icono por defecto
            TabIcon.ImageRectOffset = Vector2.new(964, 204)
            TabIcon.ImageRectSize = Vector2.new(36, 36)
        end
        TabIcon.Parent = TabButton
        
        -- Texto de la pestaña
        local TabText = Instance.new("TextLabel")
        TabText.Name = "Title"
        TabText.Size = UDim2.new(1, -40, 1, 0)
        TabText.Position = UDim2.new(0, 40, 0, 0)
        TabText.BackgroundTransparency = 1
        TabText.Text = tabName
        TabText.TextColor3 = config.TextColor
        TabText.TextSize = 14
        TabText.Font = Enum.Font.GothamSemibold
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.Parent = TabButton
        
        -- Indicador de selección
        local SelectIndicator = Instance.new("Frame")
        SelectIndicator.Name = "SelectIndicator"
        SelectIndicator.Size = UDim2.new(0, 4, 0.7, 0)
        SelectIndicator.Position = UDim2.new(0, 0, 0.15, 0)
        SelectIndicator.BackgroundColor3 = config.AccentColor
        SelectIndicator.BorderSizePixel = 0
        SelectIndicator.Visible = false
        SelectIndicator.Parent = TabButton
        
        -- Redondear indicador
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(0, 2)
        IndicatorCorner.Parent = SelectIndicator
        
        -- Contenedor para los elementos de esta pestaña
        local TabContainer = Instance.new("ScrollingFrame")
        TabContainer.Name = tabName .. "Container"
        TabContainer.Size = UDim2.new(1, 0, 1, 0)
        TabContainer.BackgroundTransparency = 1
        TabContainer.BorderSizePixel = 0
        TabContainer.ScrollBarThickness = 2
        TabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
        TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContainer.Visible = false
        TabContainer.Parent = TabContent
        
        -- Layout para los elementos
        local ItemsLayout = Instance.new("UIListLayout")
        ItemsLayout.Padding = UDim.new(0, 8)
        ItemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ItemsLayout.Parent = TabContainer
        
        -- Crear objeto para la pestaña
        local Tab = {
            Button = TabButton,
            Container = TabContainer,
            Indicator = SelectIndicator
        }
        
        -- Evento para cambiar de pestaña con animaciones mejoradas
        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab and CurrentTab ~= Tab then
                -- Ocultar pestaña anterior con animación
                TweenService:Create(CurrentTab.Indicator, TweenInfo.new(0.3), {
                    Size = UDim2.new(0, 0, 0.7, 0)
                }):Play()
                
                local fadeOut = TweenService:Create(CurrentTab.Container, TweenInfo.new(0.3), {
                    Position = UDim2.new(0.1, 0, 0, 0),
                    Transparency = 1
                })
                
                fadeOut:Play()
                fadeOut.Completed:Connect(function()
                    CurrentTab.Container.Visible = false
                    CurrentTab.Container.Position = UDim2.new(0, 0, 0, 0)
                end)
                
                TweenService:Create(CurrentTab.Button, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                }):Play()
            end
            
            -- Mostrar nueva pestaña
            Tab.Container.Transparency = 1
            Tab.Container.Position = UDim2.new(-0.1, 0, 0, 0)
            Tab.Container.Visible = true
            
            -- Animaciones para mostrar la pestaña
            TweenService:Create(Tab.Indicator, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 4, 0.7, 0)
            }):Play()
            
            TweenService:Create(Tab.Container, TweenInfo.new(0.3), {
                Position = UDim2.new(0, 0, 0, 0),
                Transparency = 0
            }):Play()
            
            TweenService:Create(Tab.Button, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            }):Play()
            
            Tab.Indicator.Visible = true
            CurrentTab = Tab
        end)
        
        -- Animaciones hover
        TabButton.MouseEnter:Connect(function()
            if CurrentTab ~= Tab then
                TweenService:Create(TabButton, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                }):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if CurrentTab ~= Tab then
                TweenService:Create(TabButton, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                }):Play()
            end
        end)
        
        -- Si es la primera pestaña, seleccionarla por defecto
        if not CurrentTab then
            Tab.Indicator.Size = UDim2.new(0, 0, 0.7, 0)
            Tab.Indicator.Visible = true
            Tab.Container.Visible = true
            
            -- Animaciones iniciales
            TweenService:Create(Tab.Indicator, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 4, 0.7, 0)
            }):Play()
            
            TweenService:Create(Tab.Button, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            }):Play()
            
            CurrentTab = Tab
        end
        
        -- Objetos para los elementos de la pestaña
        local TabElements = {}
        
        -- Función para añadir un título o separador
        function TabElements:AddLabel(text)
            local Label = Instance.new("Frame")
            Label.Name = "Label_" .. text
            Label.Size = UDim2.new(1, 0, 0, 30)
            Label.BackgroundTransparency = 1
            Label.Parent = TabContainer
            
            local LabelText = Instance.new("TextLabel")
            LabelText.Name = "Text"
            LabelText.Size = UDim2.new(1, 0, 1, 0)
            LabelText.BackgroundTransparency = 1
            LabelText.Text = text
            LabelText.TextColor3 = config.TextColor
            LabelText.TextSize = 15
            LabelText.Font = Enum.Font.GothamBold
            LabelText.Parent = Label
            
            -- Agregar línea decorativa
            local Line = Instance.new("Frame")
            Line.Name = "Line"
            Line.Size = UDim2.new(1, 0, 0, 1)
            Line.Position = UDim2.new(0, 0, 1, -1)
            Line.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Line.BorderSizePixel = 0
            Line.Parent = Label
            
            -- Animación al aparecer
            Label.BackgroundTransparency = 1
            Line.Size = UDim2.new(0, 0, 0, 1)
            
            TweenService:Create(Line, TweenInfo.new(0.5), {
                Size = UDim2.new(1, 0, 0, 1)
            }):Play()
            
            -- Método para actualizar el texto
            function Label:UpdateText(newText)
                LabelText.Text = newText
            end
            
            return Label
        end
        
        -- Función para añadir un botón
        function TabElements:AddButton(text, callback)
            callback = callback or function() end
            
            local Button = Instance.new("Frame")
            Button.Name = "Button_" .. text
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Button.BorderSizePixel = 0
            Button.Parent = TabContainer
            
            -- Redondear botón
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button
            
            -- Efecto de brillo
            local ButtonStroke = Instance.new("UIStroke")
            ButtonStroke.Color = Color3.fromRGB(60, 60, 60)
            ButtonStroke.Thickness = 1
            ButtonStroke.Parent = Button
            
            local ButtonBtn = Instance.new("TextButton")
            ButtonBtn.Name = "ButtonElement"
            ButtonBtn.Size = UDim2.new(1, 0, 1, 0)
            ButtonBtn.BackgroundTransparency = 1
            ButtonBtn.Text = text
            ButtonBtn.TextColor3 = config.TextColor
            ButtonBtn.TextSize = 14
            ButtonBtn.Font = Enum.Font.GothamSemibold
            ButtonBtn.Parent = Button
            
            -- Efecto de ripple (ondas al hacer clic)
            local function createRipple(x, y)
                local Ripple = Instance.new("Frame")
                Ripple.Name = "Ripple"
                Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Ripple.BackgroundTransparency = 0.7
                Ripple.BorderSizePixel = 0
                Ripple.ZIndex = 2
                Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
                Ripple.Position = UDim2.new(0, x, 0, y)
                Ripple.Size = UDim2.new(0, 0, 0, 0)
                
                local RippleCorner = Instance.new("UICorner")
                RippleCorner.CornerRadius = UDim.new(1, 0)
                RippleCorner.Parent = Ripple
                
                Ripple.Parent = Button
                
                local targetSize = UDim2.new(0, 250, 0, 250)
                
                TweenService:Create(Ripple, TweenInfo.new(0.5), {
                    Size = targetSize,
                    BackgroundTransparency = 1
                }):Play()
                
                task.delay(0.5, function()
                    Ripple:Destroy()
                end)
            end
            
            -- Animación de pulsación con efecto ripple
            ButtonBtn.MouseButton1Down:Connect(function(x, y)
                createRipple(x - Button.AbsolutePosition.X, y - Button.AbsolutePosition.Y)
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    BackgroundColor3 = config.AccentColor
                }):Play()
            end)
            
            ButtonBtn.MouseButton1Up:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                }):Play()
            end)
            
            -- Evento para ejecutar callback
            ButtonBtn.MouseButton1Click:Connect(function()
                callback()
            end)
            
            -- Animaciones hover
            ButtonBtn.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                }):Play()
                
                TweenService:Create(ButtonStroke, TweenInfo.new(0.3), {
                    Color = config.AccentColor
                }):Play()
            end)
            
            ButtonBtn.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                }):Play()
                
                TweenService:Create(ButtonStroke, TweenInfo.new(0.3), {
                    Color = Color3.fromRGB(60, 60, 60)
                }):Play()
            end)
            
            -- Método para actualizar el texto
            function Button:UpdateText(newText)
                ButtonBtn.Text = newText
            end
            
            return Button
        end
        
        -- Función para añadir un toggle (interruptor)
        function TabElements:AddToggle(text, default, callback)
            default = default or false
            callback = callback or function() end
            
            local Toggle = Instance.new("Frame")
            Toggle.Name = "Toggle_" .. text
            Toggle.Size = UDim2.new(1, 0, 0, 40)
            Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Toggle.BorderSizePixel = 0
            Toggle.Parent = TabContainer
            
            -- Redondear toggle
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = Toggle
            
            -- Texto del toggle
            local ToggleText = Instance.new("TextLabel")
            ToggleText.Name = "Title"
            ToggleText.Size = UDim2.new(1, -60, 1, 0)
            ToggleText.Position = UDim2.new(0, 10, 0, 0)
            ToggleText.BackgroundTransparency = 1
            ToggleText.Text = text
            ToggleText.TextColor3 = config.TextColor
            ToggleText.TextSize = 14
            ToggleText.Font = Enum.Font.GothamSemibold
            ToggleText.TextXAlignment = Enum.TextXAlignment.Left
            ToggleText.Parent = Toggle
            
            -- El switch
            local Switch = Instance.new("Frame")
            Switch.Name = "Switch"
            Switch.Size = UDim2.new(0, 40, 0, 20)
            Switch.Position = UDim2.new(1, -50, 0.5, -10)
            Switch.BackgroundColor3 = default and config.ToggleOnColor or config.ToggleOffColor
            Switch.BorderSizePixel = 0
            Switch.Parent = Toggle
            
            -- Redondear switch
            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = Switch
            
            -- El círculo indicador
            local Circle = Instance.new("Frame")
            Circle.Name = "Circle"
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Position = UDim2.new(default and 1 or 0, default and -18 or 2, 0.5, -8)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.BorderSizePixel = 0
            Circle.Parent = Switch
            
            -- Redondear círculo
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = Circle
            
            -- Área de hitbox
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Size = UDim2.new(1, 0, 1, 0)
            ToggleButton.BackgroundTransparency = 1
            ToggleButton.Text = ""
            ToggleButton.Parent = Toggle
            
            -- Estado del toggle
            local Toggled = default
            
            -- Función para actualizar visualmente el toggle
            local function UpdateToggle()
                TweenService:Create(Switch, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                    BackgroundColor3 = Toggled and config.ToggleOnColor or config.ToggleOffColor
                }):Play()
                
                TweenService:Create(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = UDim2.new(Toggled and 1 or 0, Toggled and -18 or 2, 0.5, -8)
                }):Play()
            end
            
            -- Evento para cambiar el toggle
            ToggleButton.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                UpdateToggle()
                callback(Toggled)
            end)
            
            -- Animaciones hover
            ToggleButton.MouseEnter:Connect(function()
                TweenService:Create(Toggle, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                }):Play()
            end)
            
            ToggleButton.MouseLeave:Connect(function()
                TweenService:Create(Toggle, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                }):Play()
            end)
            
            -- Método para actualizar el estado del toggle
            function Toggle:UpdateState(state)
                Toggled = state
                UpdateToggle()
            end
            
            -- Método para obtener el estado actual
            function Toggle:GetState()
                return Toggled
            end
            
            return Toggle
        end
        
        -- Función para añadir un slider
        function TabElements:AddSlider(text, min, max, default, callback)
            min = min or 0
            max = max or 100
            default = default or min
            callback = callback or function() end
            
            local Slider = Instance.new("Frame")
            Slider.Name = "Slider_" .. text
            Slider.Size = UDim2.new(1, 0, 0, 60)
            Slider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Slider.BorderSizePixel = 0
            Slider.Parent = TabContainer
            
            -- Redondear slider
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = Slider
            
            -- Texto del slider
            local SliderText = Instance.new("TextLabel")
            SliderText.Name = "Title"
            SliderText.Size = UDim2.new(1, -70, 0, 20)
            SliderText.Position = UDim2.new(0, 10, 0, 5)
            SliderText.BackgroundTransparency = 1
            SliderText.Text = text
            SliderText.TextColor3 = config.TextColor
            SliderText.TextSize = 14
            SliderText.Font = Enum.Font.GothamSemibold
            SliderText.TextXAlignment = Enum.TextXAlignment.Left
            SliderText.Parent = Slider
            
            -- Valor del slider
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Name = "Value"
            SliderValue.Size = UDim2.new(0, 60, 0, 20)
            SliderValue.Position = UDim2.new(1, -70, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = config.TextColor
            SliderValue.TextSize = 14
            SliderValue.Font = Enum.Font.GothamSemibold
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = Slider
            
            -- Barra de fondo
            local SliderBack = Instance.new("Frame")
            SliderBack.Name = "SliderBack"
            SliderBack.Size = UDim2.new(1, -20, 0, 8)
            SliderBack.Position = UDim2.new(0, 10, 0, 35)
            SliderBack.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            SliderBack.BorderSizePixel = 0
            SliderBack.Parent = Slider
            
            -- Redondear barra de fondo
            local SliderBackCorner = Instance.new("UICorner")
            SliderBackCorner.CornerRadius = UDim.new(1, 0)
            SliderBackCorner.Parent = SliderBack
            
            -- Barra de progreso
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = config.SliderColor
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBack
            
            -- Redondear barra de progreso
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            -- El círculo deslizante
            local SliderCircle = Instance.new("Frame")
            SliderCircle.Name = "SliderCircle"
            SliderCircle.Size = UDim2.new(0, 16, 0, 16)
            SliderCircle.Position = UDim2.new((default - min)/(max - min), -8, 0.5, -8)
            SliderCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderCircle.BorderSizePixel = 0
            SliderCircle.ZIndex = 2
            SliderCircle.Parent = SliderBack
            
            -- Redondear círculo deslizante
            local SliderCircleCorner = Instance.new("UICorner")
            SliderCircleCorner.CornerRadius = UDim.new(1, 0)
            SliderCircleCorner.Parent = SliderCircle
            
            -- Área de hitbox
            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "SliderButton"
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Text = ""
            SliderButton.Parent = Slider
            
            -- Variables de estado
            local Dragging = false
            local Value = default
            
            -- Función para actualizar el valor del slider de manera suave
            local function UpdateSlider(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1), -8, 0.5, -8)
                local value = math.floor(min + ((max - min) * math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)))
                
                TweenService:Create(SliderCircle, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = pos
                }):Play()
                
                TweenService:Create(SliderFill, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1), 0, 1, 0)
                }):Play()
                
                SliderValue.Text = tostring(value)
                Value = value
                callback(value)
            end
            
            -- Eventos para el deslizamiento
            SliderButton.MouseButton1Down:Connect(function(input)
                Dragging = true
                UpdateSlider(input)
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)
            
            -- Animaciones hover
            SliderButton.MouseEnter:Connect(function()
                TweenService:Create(Slider, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                }):Play()
                
                TweenService:Create(SliderCircle, TweenInfo.new(0.3), {
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new(SliderCircle.Position.X.Scale, -9, 0.5, -9)
                }):Play()
            end)
            
            SliderButton.MouseLeave:Connect(function()
                TweenService:Create(Slider, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                }):Play()
                
                TweenService:Create(SliderCircle, TweenInfo.new(0.3), {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(SliderCircle.Position.X.Scale, -8, 0.5, -8)
                }):Play()
            end)
            
            -- Método para actualizar el valor del slider
            function Slider:SetValue(value)
                value = math.clamp(value, min, max)
                Value = value
                SliderValue.Text = tostring(value)
                
                local scale = (value - min) / (max - min)
                
                TweenService:Create(SliderFill, TweenInfo.new(0.3), {
                    Size = UDim2.new(scale, 0, 1, 0)
                }):Play()
                
                TweenService:Create(SliderCircle, TweenInfo.new(0.3), {
                    Position = UDim2.new(scale, -8, 0.5, -8)
                }):Play()
                
                callback(value)
            end
            
            -- Método para obtener el valor actual
            function Slider:GetValue()
                return Value
            end
            
            return Slider
        end
        
        -- Función para añadir un campo de texto
        function TabElements:AddTextbox(text, placeholder, callback)
            placeholder = placeholder or "Texto aquí..."
            callback = callback or function() end
            
            local Textbox = Instance.new("Frame")
            Textbox.Name = "Textbox_" .. text
            Textbox.Size = UDim2.new(1, 0, 0, 40)
            Textbox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Textbox.BorderSizePixel = 0
            Textbox.Parent = TabContainer
            
            -- Redondear textbox
            local TextboxCorner = Instance.new("UICorner")
            TextboxCorner.CornerRadius = UDim.new(0, 6)
            TextboxCorner.Parent = Textbox
            
            -- Texto del campo
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Name = "Title"
            TextboxLabel.Size = UDim2.new(0, 120, 1, 0)
            TextboxLabel.Position = UDim2.new(0, 10, 0, 0)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = text
            TextboxLabel.TextColor3 = config.TextColor
            TextboxLabel.TextSize = 14
            TextboxLabel.Font = Enum.Font.GothamSemibold
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = Textbox
            
            -- Campo de entrada
            local InputBox = Instance.new("Frame")
            InputBox.Name = "InputBox"
            InputBox.Size = UDim2.new(1, -140, 0, 30)
            InputBox.Position = UDim2.new(0, 130, 0.5, -15)
            InputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            InputBox.BorderSizePixel = 0
            InputBox.Parent = Textbox
            
            -- Redondear campo de entrada
            local InputBoxCorner = Instance.new("UICorner")
            InputBoxCorner.CornerRadius = UDim.new(0, 6)
            InputBoxCorner.Parent = InputBox
            
            -- Borde del campo cuando está seleccionado
            local InputBoxStroke = Instance.new("UIStroke")
            InputBoxStroke.Color = Color3.fromRGB(60, 60, 60)
            InputBoxStroke.Thickness = 1
            InputBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            InputBoxStroke.Parent = InputBox
            
            -- El campo de texto real
            local InputField = Instance.new("TextBox")
            InputField.Name = "Input"
            InputField.Size = UDim2.new(1, -14, 1, 0)
            InputField.Position = UDim2.new(0, 7, 0, 0)
            InputField.BackgroundTransparency = 1
            InputField.Text = ""
            InputField.PlaceholderText = placeholder
            InputField.TextColor3 = config.TextColor
            InputField.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
            InputField.TextSize = 14
            InputField.Font = Enum.Font.Gotham
            InputField.TextXAlignment = Enum.TextXAlignment.Left
            InputField.TextTruncate = Enum.TextTruncate.AtEnd
            InputField.ClearTextOnFocus = false
            InputField.Parent = InputBox
            
            -- Eventos para el campo de texto
            InputField.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    callback(InputField.Text)
                end
            end)
            
            -- Animaciones focus
            InputField.Focused:Connect(function()
                TweenService:Create(InputBox, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                }):Play()
                
                TweenService:Create(InputBoxStroke, TweenInfo.new(0.3), {
                    Color = config.AccentColor,
                    Thickness = 2
                }):Play()
            end)
            
            InputField.FocusLost:Connect(function()
                TweenService:Create(InputBox, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                }):Play()
                
                TweenService:Create(InputBoxStroke, TweenInfo.new(0.3), {
                    Color = Color3.fromRGB(60, 60, 60),
                    Thickness = 1
                }):Play()
            end)
            
            -- Animaciones hover
            InputField.MouseEnter:Connect(function()
                if not InputField:IsFocused() then
                    TweenService:Create(InputBox, TweenInfo.new(0.3), {
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    }):Play()
                end
            end)
            
            InputField.MouseLeave:Connect(function()
                if not InputField:IsFocused() then
                    TweenService:Create(InputBox, TweenInfo.new(0.3), {
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                    }):Play()
                end
            end)
            
            -- Método para establecer el texto
            function Textbox:SetText(value)
                InputField.Text = value
            end
            
            -- Método para obtener el texto actual
            function Textbox:GetText()
                return InputField.Text
            end
            
            return Textbox
        end
        
        -- Función para crear un dropdown
        function TabElements:AddDropdown(text, options, callback)
            options = options or {}
            callback = callback or function() end
            
            local Dropdown = Instance.new("Frame")
            Dropdown.Name = "Dropdown_" .. text
            Dropdown.Size = UDim2.new(1, 0, 0, 40)
            Dropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Dropdown.BorderSizePixel = 0
            Dropdown.ClipsDescendants = true -- Para la animación de apertura/cierre
            Dropdown.Parent = TabContainer
            
            -- Redondear dropdown
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Parent = Dropdown
            
            -- Texto del dropdown
            local DropdownTitle = Instance.new("TextLabel")
            DropdownTitle.Name = "Title"
            DropdownTitle.Size = UDim2.new(1, -40, 0, 40)
            DropdownTitle.Position = UDim2.new(0, 10, 0, 0)
            DropdownTitle.BackgroundTransparency = 1
            DropdownTitle.Text = text
            DropdownTitle.TextColor3 = config.TextColor
            DropdownTitle.TextSize = 14
            DropdownTitle.Font = Enum.Font.GothamSemibold
            DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
            DropdownTitle.Parent = Dropdown
            
            -- Botón de flecha
            local ArrowButton = Instance.new("ImageButton")
            ArrowButton.Name = "Arrow"
            ArrowButton.Size = UDim2.new(0, 20, 0, 20)
            ArrowButton.Position = UDim2.new(1, -30, 0, 10)
            ArrowButton.BackgroundTransparency = 1
            ArrowButton.Image = "rbxassetid://6031091004" -- Icono de flecha hacia abajo
            ArrowButton.ImageColor3 = config.TextColor
            ArrowButton.Parent = Dropdown
            
            -- Contenedor para los elementos de dropdown
            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.Name = "Options"
            OptionsFrame.Size = UDim2.new(1, -20, 0, #options * 30) -- 30 píxeles por opción
            OptionsFrame.Position = UDim2.new(0, 10, 0, 45)
            OptionsFrame.BackgroundTransparency = 1
            OptionsFrame.BorderSizePixel = 0
            OptionsFrame.Visible = false
            OptionsFrame.Parent = Dropdown
            
            -- Estado del dropdown
            local IsOpen = false
            local SelectedOption = ""
            
            -- El valor seleccionado
            local SelectedText = Instance.new("TextLabel")
            SelectedText.Name = "Selected"
            SelectedText.Size = UDim2.new(0, 200, 0, 40)
            SelectedText.Position = UDim2.new(1, -220, 0, 0)
            SelectedText.BackgroundTransparency = 1
            SelectedText.Text = ""
            SelectedText.TextColor3 = Color3.fromRGB(180, 180, 180)
            SelectedText.TextSize = 14
            SelectedText.Font = Enum.Font.Gotham
            SelectedText.TextXAlignment = Enum.TextXAlignment.Right
            SelectedText.Parent = Dropdown
            
            -- Inicializar opciones con animaciones hover
            for i, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
                OptionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = option
                OptionButton.TextColor3 = config.TextColor
                OptionButton.TextSize = 14
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Parent = OptionsFrame
                
                -- Redondear botón
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 4)
                OptionCorner.Parent = OptionButton
                
                -- Eventos para la opción
                OptionButton.MouseButton1Click:Connect(function()
                    SelectedOption = option
                    SelectedText.Text = option
                    callback(option)
                    
                    -- Cerrar el dropdown con animación
                    TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 40)
                    }):Play()
                    
                    TweenService:Create(ArrowButton, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Rotation = 0
                    }):Play()
                    
                    task.delay(0.3, function()
                        OptionsFrame.Visible = false
                    end)
                    
                    IsOpen = false
                end)
                
                -- Animaciones hover
                OptionButton.MouseEnter:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    }):Play()
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    }):Play()
                end)
            end
            
            -- Función para abrir/cerrar el dropdown con animaciones mejoradas
            local function ToggleDropdown()
                IsOpen = not IsOpen
                
                if IsOpen then
                    OptionsFrame.Visible = true
                    
                    TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 45 + (#options * 30))
                    }):Play()
                    
                    TweenService:Create(ArrowButton, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Rotation = 180
                    }):Play()
                else
                    TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 40)
                    }):Play()
                    
                    TweenService:Create(ArrowButton, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Rotation = 0
                    }):Play()
                    
                    task.delay(0.3, function()
                        OptionsFrame.Visible = false
                    end)
                end
            end
            
            -- Evento para abrir/cerrar el dropdown
            ArrowButton.MouseButton1Click:Connect(ToggleDropdown)
            
            -- Área clickable completa
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Size = UDim2.new(1, 0, 0, 40)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = ""
            DropdownButton.Parent = Dropdown
            
            -- Conectar evento al botón completo
            DropdownButton.MouseButton1Click:Connect(ToggleDropdown)
            
            -- Animaciones hover
            DropdownButton.MouseEnter:Connect(function()
                TweenService:Create(Dropdown, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                }):Play()
            end)
            
            DropdownButton.MouseLeave:Connect(function()
                TweenService:Create(Dropdown, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                }):Play()
            end)
            
            -- Método para actualizar las opciones
            function Dropdown:SetOptions(newOptions)
                -- Limpiar opciones anteriores
                for _, child in pairs(OptionsFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                -- Actualizar tamaño del contenedor
                OptionsFrame.Size = UDim2.new(1, -20, 0, #newOptions * 30)
                
                -- Agregar nuevas opciones
                for i, option in ipairs(newOptions) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = option
                    OptionButton.Size = UDim2.new(1, 0, 0, 30)
                    OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
                    OptionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Text = option
                    OptionButton.TextColor3 = config.TextColor
                    OptionButton.TextSize = 14
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Parent = OptionsFrame
                    
                    -- Redondear botón
                    local OptionCorner = Instance.new("UICorner")
                    OptionCorner.CornerRadius = UDim.new(0, 4)
                    OptionCorner.Parent = OptionButton
                    
                    -- Eventos para la opción
                    OptionButton.MouseButton1Click:Connect(function()
                        SelectedOption = option
                        SelectedText.Text = option
                        callback(option)
                        
                        -- Cerrar el dropdown
                        TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Size = UDim2.new(1, 0, 0, 40)
                        }):Play()
                        
                        TweenService:Create(ArrowButton, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Rotation = 0
                        }):Play()
                        
                        task.delay(0.3, function()
                            OptionsFrame.Visible = false
                        end)
                        
                        IsOpen = false
                    end)
                    
                    -- Animaciones hover
                    OptionButton.MouseEnter:Connect(function()
                        TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                        }):Play()
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                        }):Play()
                    end)
                end
                
                -- Actualizar el tamaño si está abierto
                if IsOpen then
                    TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 45 + (#newOptions * 30))
                    }):Play()
                end
            end
            
            -- Método para seleccionar una opción
            function Dropdown:Select(option)
                SelectedOption = option
                SelectedText.Text = option
                callback(option)
            end
            
            -- Método para obtener la opción seleccionada
            function Dropdown:GetSelected()
                return SelectedOption
            end
            
            return Dropdown
        end
        
        -- Función para añadir separador
        function TabElements:AddDivider()
            local Divider = Instance.new("Frame")
            Divider.Name = "Divider"
            Divider.Size = UDim2.new(1, 0, 0, 8)
            Divider.BackgroundTransparency = 1
            Divider.Parent = TabContainer
            
            local Line = Instance.new("Frame")
            Line.Name = "Line"
            Line.Size = UDim2.new(0, 0, 0, 1)
            Line.Position = UDim2.new(0, 0, 0.5, 0)
            Line.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            Line.BorderSizePixel = 0
            Line.Parent = Divider
            
            -- Animación de aparición
            TweenService:Create(Line, TweenInfo.new(0.5), {
                Size = UDim2.new(1, 0, 0, 1)
            }):Play()
            
            return Divider
        end
        
        -- Función para añadir un colorpicker
        function TabElements:AddColorPicker(text, default, callback)
            default = default or Color3.fromRGB(255, 255, 255)
            callback = callback or function() end
            
            local ColorPicker = Instance.new("Frame")
            ColorPicker.Name = "ColorPicker_" .. text
            ColorPicker.Size = UDim2.new(1, 0, 0, 40)
            ColorPicker.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            ColorPicker.BorderSizePixel = 0
            ColorPicker.Parent = TabContainer
            
            -- Redondear colorpicker
            local ColorPickerCorner = Instance.new("UICorner")
            ColorPickerCorner.CornerRadius = UDim.new(0, 6)
            ColorPickerCorner.Parent = ColorPicker
            
            -- Texto del colorpicker
            local ColorPickerText = Instance.new("TextLabel")
            ColorPickerText.Name = "Title"
            ColorPickerText.Size = UDim2.new(1, -60, 1, 0)
            ColorPickerText.Position = UDim2.new(0, 10, 0, 0)
            ColorPickerText.BackgroundTransparency = 1
            ColorPickerText.Text = text
            ColorPickerText.TextColor3 = config.TextColor
            ColorPickerText.TextSize = 14
            ColorPickerText.Font = Enum.Font.GothamSemibold
            ColorPickerText.TextXAlignment = Enum.TextXAlignment.Left
            ColorPickerText.Parent = ColorPicker
            
            -- Cuadrado de color
            local ColorBox = Instance.new("Frame")
            ColorBox.Name = "ColorBox"
            ColorBox.Size = UDim2.new(0, 30, 0, 30)
            ColorBox.Position = UDim2.new(1, -40, 0.5, -15)
            ColorBox.BackgroundColor3 = default
            ColorBox.BorderSizePixel = 0
            ColorBox.Parent = ColorPicker
            
            -- Redondear cuadrado de color
            local ColorBoxCorner = Instance.new("UICorner")
            ColorBoxCorner.CornerRadius = UDim.new(0, 6)
            ColorBoxCorner.Parent = ColorBox
            
            -- Área clickable
            local ColorButton = Instance.new("TextButton")
            ColorButton.Name = "ColorButton"
            ColorButton.Size = UDim2.new(1, 0, 1, 0)
            ColorButton.BackgroundTransparency = 1
            ColorButton.Text = ""
            ColorButton.Parent = ColorPicker
            
            -- Estado del colorpicker
            local SelectedColor = default
            
            -- Método para actualizar el color mostrado
            local function UpdateColor(color)
                SelectedColor = color
                ColorBox.BackgroundColor3 = color
                callback(color)
            end
            
            -- Botón para seleccionar el color (simplificado)
            ColorButton.MouseButton1Click:Connect(function()
                -- Aquí podrías implementar una interfaz completa de selector de color
                -- Para este ejemplo, solo cambiaremos entre algunos colores predefinidos
                local colors = {
                    Color3.fromRGB(255, 0, 0),   -- Rojo
                    Color3.fromRGB(0, 255, 0),   -- Verde
                    Color3.fromRGB(0, 0, 255),   -- Azul
                    Color3.fromRGB(255, 255, 0), -- Amarillo
                    Color3.fromRGB(255, 0, 255), -- Magenta
                    Color3.fromRGB(0, 255, 255)  -- Cian
                }
                
                -- Encontrar el índice del color actual
                local currentIndex = 1
                for i, color in ipairs(colors) do
                    if color == SelectedColor then
                        currentIndex = i
                        break
                    end
                end
                
                -- Pasar al siguiente color
                local nextIndex = currentIndex % #colors + 1
                UpdateColor(colors[nextIndex])
            end)
            
            -- Animaciones hover
            ColorButton.MouseEnter:Connect(function()
                TweenService:Create(ColorPicker, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                }):Play()
            end)
            
            ColorButton.MouseLeave:Connect(function()
                TweenService:Create(ColorPicker, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                }):Play()
            end)
            
            -- Métodos
            function ColorPicker:SetColor(color)
                UpdateColor(color)
            end
            
            function ColorPicker:GetColor()
                return SelectedColor
            end
            
            return ColorPicker
        end
        
        return TabElements
    end
    
    -- Función para establecer el rango del usuario (VIP, Admin, etc.)
    function UILibrary:SetRank(rank, color)
        if UserRank then
            UserRank.Text = rank or "USER"
            UserRank.TextColor3 = color or Ranks.USER.Color
        end
    end
    
    -- Función para establecer el avatar de usuario (opcional)
    function UILibrary:SetAvatar(imageId)
        if Avatar and imageId then
            Avatar.Image = imageId
        end
    end
    
    -- Función para personalizar los colores de la GUI
    function UILibrary:SetTheme(theme)
        for key, value in pairs(theme) do
            if config[key] then
                config[key] = value
            end
        end
    end
    
    -- Función para mostrar notificaciones
    function UILibrary:Notify(title, message, notifType, duration, icon)
        NotificationSystem:Notify(title, message, icon, duration, notifType)
    end
    
    -- Función para modificar los IDs de rangos de usuario
    function UILibrary:SetRankIDs(rankName, ids)
        if Ranks[rankName] then
            Ranks[rankName].ID = ids
        end
    end
    
    -- Retornar el objeto de la pestaña
    return UILibrary
end

-- Retornar la librería completa
return UILibrary
