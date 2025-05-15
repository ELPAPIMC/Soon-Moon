-- // Library // --
local UILibrary = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- // Configuración // --
local config = {
    TweenSpeed = 0.3,
    MainColor = Color3.fromRGB(30, 30, 30),
    AccentColor = Color3.fromRGB(100, 100, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    ToggleOnColor = Color3.fromRGB(0, 170, 255),
    ToggleOffColor = Color3.fromRGB(100, 100, 100),
    CornerRadius = UDim.new(0, 8),
    SliderColor = Color3.fromRGB(0, 170, 255)
}

-- // Iniciar la GUI // --
function UILibrary:Create(title)
    local GuiName = title or "UI Library"
    
    -- Crear ScreenGui principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = GuiName
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game.CoreGui
    
    -- Frame principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.BackgroundColor3 = config.MainColor
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
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
    
    -- Título texto
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "Title"
    TitleText.Size = UDim2.new(1, -40, 1, 0)
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = GuiName
    TitleText.TextColor3 = config.TextColor
    TitleText.TextSize = 18
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
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
        ScreenGui:Destroy()
    end)
    
    -- Panel de contenido con pestañas
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -20, 1, -60)
    ContentFrame.Position = UDim2.new(0, 10, 0, 50)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
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
    
    -- Rango del jugador
    local UserRank = Instance.new("TextLabel")
    UserRank.Name = "UserRank"
    UserRank.Size = UDim2.new(1, -10, 0, 15)
    UserRank.Position = UDim2.new(0, 5, 1, -20)
    UserRank.BackgroundTransparency = 1
    UserRank.Text = "VIP"
    UserRank.TextColor3 = Color3.fromRGB(255, 215, 0) -- Dorado para VIP
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
    
    -- Agregar animación de apertura
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    local openTween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 400)})
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
        
        -- Evento para cambiar de pestaña
        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Indicator.Visible = false
                CurrentTab.Container.Visible = false
                TweenService:Create(CurrentTab.Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            end
            
            Tab.Indicator.Visible = true
            Tab.Container.Visible = true
            TweenService:Create(Tab.Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            CurrentTab = Tab
        end)
        
        -- Animaciones hover
        TabButton.MouseEnter:Connect(function()
            if CurrentTab ~= Tab then
                TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if CurrentTab ~= Tab then
                TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            end
        end)
        
        -- Si es la primera pestaña, seleccionarla por defecto
        if not CurrentTab then
            Tab.Indicator.Visible = true
            Tab.Container.Visible = true
            TweenService:Create(Tab.Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            CurrentTab = Tab
        end
        
        -- Objetos para los elementos de la pestaña
        local TabElements = {}
        
        -- Función para añadir un título o separador
        function TabElements:AddLabel(text)
            local Label = Instance.new("Frame")
            Label.Name = "Label"
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
            
            return Label
        end
        
        -- Función para añadir un botón
        function TabElements:AddButton(text, callback)
            callback = callback or function() end
            
            local Button = Instance.new("Frame")
            Button.Name = "Button"
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Button.BorderSizePixel = 0
            Button.Parent = TabContainer
            
            -- Redondear botón
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button
            
            local ButtonBtn = Instance.new("TextButton")
            ButtonBtn.Name = "ButtonElement"
            ButtonBtn.Size = UDim2.new(1, 0, 1, 0)
            ButtonBtn.BackgroundTransparency = 1
            ButtonBtn.Text = text
            ButtonBtn.TextColor3 = config.TextColor
            ButtonBtn.TextSize = 14
            ButtonBtn.Font = Enum.Font.GothamSemibold
            ButtonBtn.Parent = Button
            
            -- Animación de pulsación
            ButtonBtn.MouseButton1Down:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = config.AccentColor}):Play()
            end)
            
            ButtonBtn.MouseButton1Up:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            end)
            
            -- Evento para ejecutar callback
            ButtonBtn.MouseButton1Click:Connect(function()
                callback()
            end)
            
            -- Animaciones hover
            ButtonBtn.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
            end)
            
            ButtonBtn.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            end)
            
            return Button
        end
        
        -- Función para añadir un toggle (interruptor)
        function TabElements:AddToggle(text, default, callback)
            default = default or false
            callback = callback or function() end
            
            local Toggle = Instance.new("Frame")
            Toggle.Name = "Toggle"
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
                TweenService:Create(Switch, TweenInfo.new(0.3), {
                    BackgroundColor3 = Toggled and config.ToggleOnColor or config.ToggleOffColor
                }):Play()
                
                TweenService:Create(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
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
                TweenService:Create(Toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
            end)
            
            ToggleButton.MouseLeave:Connect(function()
                TweenService:Create(Toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            end)
            
            return Toggle
        end
        
        -- Función para añadir un slider
        function TabElements:AddSlider(text, min, max, default, callback)
            min = min or 0
            max = max or 100
            default = default or min
            callback = callback or function() end
            
            local Slider = Instance.new("Frame")
            Slider.Name = "Slider"
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
            
            -- Función para actualizar el valor del slider
            local function UpdateSlider(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1), -8, 0.5, -8)
                local value = math.floor(min + ((max - min) * math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)))
                
                TweenService:Create(SliderCircle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = pos
                }):Play()
                
                TweenService:Create(SliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1), 0, 1, 0)
                }):Play()
                
                SliderValue.Text = tostring(value)
                Value = value
                callback(value)
            end
            
            -- Eventos para el deslizamiento
            SliderButton.MouseButton1Down:Connect(function(input)
                Dragging = true
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
                TweenService:Create(Slider, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
            end)
            
            SliderButton.MouseLeave:Connect(function()
                TweenService:Create(Slider, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            end)
            
            return Slider
        end
        
        -- Función para añadir un campo de texto
        function TabElements:AddTextbox(text, placeholder, callback)
            placeholder = placeholder or "Texto aquí..."
            callback = callback or function() end
            
            local Textbox = Instance.new("Frame")
            Textbox.Name = "Textbox"
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
            
            -- Animaciones hover
            InputField.Focused:Connect(function()
                TweenService:Create(InputBox, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            end)
            
            InputField.FocusLost:Connect(function()
                TweenService:Create(InputBox, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
            end)
            
            return Textbox
        end
        
        -- Función para crear un dropdown
        function TabElements:AddDropdown(text, options, callback)
            options = options or {}
            callback = callback or function() end
            
            local Dropdown = Instance.new("Frame")
            Dropdown.Name = "Dropdown"
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
            
            -- Inicializar opciones
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
                    
                    -- Cerrar el dropdown
                    TweenService:Create(Dropdown, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                    TweenService:Create(ArrowButton, TweenInfo.new(0.3), {Rotation = 0}):Play()
                    task.delay(0.3, function()
                        OptionsFrame.Visible = false
                    end)
                    IsOpen = false
                end)
                
                -- Animaciones hover
                OptionButton.MouseEnter:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                end)
            end
            
            -- Evento para abrir/cerrar el dropdown
            ArrowButton.MouseButton1Click:Connect(function()
                IsOpen = not IsOpen
                
                if IsOpen then
                    OptionsFrame.Visible = true
                    TweenService:Create(Dropdown, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 45 + (#options * 30))}):Play()
                    TweenService:Create(ArrowButton, TweenInfo.new(0.3), {Rotation = 180}):Play()
                else
                    TweenService:Create(Dropdown, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                    TweenService:Create(ArrowButton, TweenInfo.new(0.3), {Rotation = 0}):Play()
                    task.delay(0.3, function()
                        OptionsFrame.Visible = false
                    end)
                end
            end)
            
            -- Área clickable completa
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Size = UDim2.new(1, 0, 0, 40)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = ""
            DropdownButton.Parent = Dropdown
            
            -- Conectar evento al botón completo
            DropdownButton.MouseButton1Click:Connect(function()
                IsOpen = not IsOpen
                
                if IsOpen then
                    OptionsFrame.Visible = true
                    TweenService:Create(Dropdown, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 45 + (#options * 30))}):Play()
                    TweenService:Create(ArrowButton, TweenInfo.new(0.3), {Rotation = 180}):Play()
                else
                    TweenService:Create(Dropdown, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                    TweenService:Create(ArrowButton, TweenInfo.new(0.3), {Rotation = 0}):Play()
                    task.delay(0.3, function()
                        OptionsFrame.Visible = false
                    end)
                end
            end)
            
            -- Animaciones hover
            DropdownButton.MouseEnter:Connect(function()
                TweenService:Create(Dropdown, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
            end)
            
            DropdownButton.MouseLeave:Connect(function()
                TweenService:Create(Dropdown, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            end)
            
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
            Line.Size = UDim2.new(1, 0, 0, 1)
            Line.Position = UDim2.new(0, 0, 0.5, 0)
            Line.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            Line.BorderSizePixel = 0
            Line.Parent = Divider
            
            return Divider
        end
        
        return TabElements
    end
    
    -- Función para establecer el rango del usuario (VIP, Admin, etc.)
    function UILibrary:SetRank(rank, color)
        if UserRank then
            UserRank.Text = rank or "Usuario"
            UserRank.TextColor3 = color or Color3.fromRGB(255, 215, 0)
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
    
    -- Retornar el objeto de la pestaña
    return UILibrary
end

-- Retornar la librería completa
return UILibrary
