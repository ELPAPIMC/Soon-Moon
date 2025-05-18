-- UI Library mejorada para Roblox
local TweenService = game:GetService("UserInputService")
local UserInputService = game:GetService("UserInputService")
local Library = {}

-- Temas personalizables
local Themes = {
    Default = {
        Background = Color3.fromRGB(120, 190, 200),
        AccentColor = Color3.fromRGB(100, 160, 170),
        TextColor = Color3.fromRGB(255, 255, 255),
        ToggleOnColor = Color3.fromRGB(80, 140, 150),
        BorderColor = Color3.fromRGB(90, 150, 160),
        DropdownColor = Color3.fromRGB(110, 170, 180),
        NotificationColor = Color3.fromRGB(80, 140, 150),
    },
    Dark = {
        Background = Color3.fromRGB(40, 40, 40),
        AccentColor = Color3.fromRGB(60, 60, 60),
        TextColor = Color3.fromRGB(200, 200, 200),
        ToggleOnColor = Color3.fromRGB(100, 100, 100),
        BorderColor = Color3.fromRGB(50, 50, 50),
        DropdownColor = Color3.fromRGB(70, 70, 70),
        NotificationColor = Color3.fromRGB(90, 90, 90),
    }
}

-- Configuración actual (tema por defecto)
local CurrentTheme = Themes.Default
local Config = {
    AnimationSpeed = 0.3,
    BorderSize = 1
}

-- Sistema de notificaciones
local NotificationSystem = {}
function NotificationSystem:CreateNotification(message, duration)
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Size = UDim2.new(0, 200, 0, 50)
    NotificationFrame.Position = UDim2.new(1, -210, 1, -60 - (#game.CoreGui:GetDescendants() * 55))
    NotificationFrame.BackgroundColor3 = CurrentTheme.NotificationColor
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.Parent = game.CoreGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = NotificationFrame
    
    local NotificationLabel = Instance.new("TextLabel")
    NotificationLabel.Size = UDim2.new(1, -10, 1, 0)
    NotificationLabel.Position = UDim2.new(0, 5, 0, 0)
    NotificationLabel.BackgroundTransparency = 1
    NotificationLabel.TextColor3 = CurrentTheme.TextColor
    NotificationLabel.Text = message
    NotificationLabel.Font = Enum.Font.Gotham
    NotificationLabel.TextSize = 12
    NotificationLabel.TextWrapped = true
    NotificationLabel.Parent = NotificationFrame
    
    -- Animación de entrada
    NotificationFrame.Position = UDim2.new(1, 0, 1, -60 - (#game.CoreGui:GetDescendants() * 55))
    TweenService:Create(NotificationFrame, TweenInfo.new(0.5), {
        Position = UDim2.new(1, -210, 1, -60 - (#game.CoreGui:GetDescendants() * 55))
    }):Play()
    
    -- Desvanecer después de la duración
    wait(duration or 3)
    TweenService:Create(NotificationFrame, TweenInfo.new(0.5), {
        Position = UDim2.new(1, 0, 1, -60 - (#game.CoreGui:GetDescendants() * 55))
    }):Play()
    wait(0.5)
    NotificationFrame:Destroy()
end

function Library:SetTheme(themeName)
    if Themes[themeName] then
        CurrentTheme = Themes[themeName]
        NotificationSystem:CreateNotification("Tema cambiado a " .. themeName, 2)
    else
        NotificationSystem:CreateNotification("Tema no encontrado: " .. themeName, 2)
    end
end

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = title
    ScreenGui.Parent = game.CoreGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    MainFrame.BackgroundColor3 = CurrentTheme.Background
    MainFrame.BorderSizePixel = Config.BorderSize
    MainFrame.BorderColor3 = CurrentTheme.BorderColor
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- Encabezado
    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Size = UDim2.new(1, 0, 0, 40)
    HeaderFrame.BackgroundColor3 = CurrentTheme.AccentColor
    HeaderFrame.BorderSizePixel = 0
    HeaderFrame.Parent = MainFrame
    
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 25, 0, 25)
    Icon.Position = UDim2.new(0, 10, 0, 7)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://6035047409" -- Icono de gota (como en la imagen)
    Icon.Parent = HeaderFrame
    
    -- Animación del icono
    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local tween = TweenService:Create(Icon, tweenInfo, {ImageTransparency = 0.3})
    tween:Play()
    
    local TitleBar = Instance.new("TextLabel")
    TitleBar.Text = title
    TitleBar.Size = UDim2.new(1, -80, 1, 0)
    TitleBar.Position = UDim2.new(0, 45, 0, 0)
    TitleBar.BackgroundTransparency = 1
    TitleBar.TextColor3 = CurrentTheme.TextColor
    TitleBar.TextXAlignment = Enum.TextXAlignment.Left
    TitleBar.Font = Enum.Font.GothamSemibold
    TitleBar.TextSize = 16
    TitleBar.Parent = HeaderFrame
    
    -- Botón de minimizar
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
    MinimizeButton.BackgroundColor3 = CurrentTheme.AccentColor
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = CurrentTheme.TextColor
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextSize = 14
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Parent = HeaderFrame
    
    local UICornerMinimize = Instance.new("UICorner")
    UICornerMinimize.CornerRadius = UDim.new(0, 5)
    UICornerMinimize.Parent = MinimizeButton
    
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, -40)
    ContentFrame.Position = UDim2.new(0, 0, 0, 40)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame
    
    -- Divisiones izquierda y derecha
    local LeftGroup = Instance.new("ScrollingFrame")
    LeftGroup.Size = UDim2.new(0.25, 0, 1, 0)
    LeftGroup.BackgroundTransparency = 0.5
    LeftGroup.BackgroundColor3 = CurrentTheme.Background
    LeftGroup.BorderSizePixel = 0
    LeftGroup.ScrollBarThickness = 0
    LeftGroup.CanvasSize = UDim2.new(0, 0, 0, 0)
    LeftGroup.AutomaticCanvasSize = Enum.AutomaticSize.Y
    LeftGroup.Parent = ContentFrame
    
    local LeftLayout = Instance.new("UIListLayout")
    LeftLayout.Padding = UDim.new(0, 5)
    LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LeftLayout.Parent = LeftGroup
    
    local RightGroup = Instance.new("Frame")
    RightGroup.Size = UDim2.new(0.75, 0, 1, 0)
    RightGroup.Position = UDim2.new(0.25, 0, 0, 0)
    RightGroup.BackgroundTransparency = 1
    RightGroup.Parent = ContentFrame
    
    local TabButtons = {}
    local Tabs = {}
    local SelectedTab = nil
    
    local isMinimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            MainFrame:TweenSize(UDim2.new(0, 450, 0, 40), "Out", "Quad", 0.3, true)
            ContentFrame.Visible = false
            MinimizeButton.Text = "+"
        else
            MainFrame:TweenSize(UDim2.new(0, 450, 0, 350), "Out", "Quad", 0.3, true)
            ContentFrame.Visible = true
            MinimizeButton.Text = "-"
        end
    end)
    
    local Window = {}
    
    function Window:AddTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -10, 0, 40)
        TabButton.Position = UDim2.new(0, 5, 0, 5 + (#TabButtons * 45))
        TabButton.BackgroundColor3 = CurrentTheme.AccentColor
        TabButton.TextColor3 = CurrentTheme.TextColor
        TabButton.Text = name
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextSize = 14
        TabButton.Parent = LeftGroup
        TabButton.BorderSizePixel = 0
        TabButton.AutoButtonColor = false
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, -10, 1, -10)
        TabContent.Position = UDim2.new(0, 5, 0, 5)
        TabContent.BackgroundColor3 = CurrentTheme.AccentColor
        TabContent.BackgroundTransparency = 0.2
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Parent = RightGroup
        
        local TabLayout = Instance.new("UIListLayout")
        TabLayout.Padding = UDim.new(0, 10)
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Parent = TabContent
        TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        table.insert(TabButtons, TabButton)
        table.insert(Tabs, TabContent)
        
        TabButton.MouseButton1Click:Connect(function()
            if SelectedTab then
                TweenService:Create(TabButtons[SelectedTab], TweenInfo.new(Config.AnimationSpeed), {
                    BackgroundColor3 = CurrentTheme.AccentColor
                }):Play()
                Tabs[SelectedTab].Visible = false
            end
            
            for i, button in pairs(TabButtons) do
                if button == TabButton then
                    SelectedTab = i
                    TweenService:Create(button, TweenInfo.new(Config.AnimationSpeed), {
                        BackgroundColor3 = CurrentTheme.ToggleOnColor
                    }):Play()
                    Tabs[i].Visible = true
                end
            end
        end)
        
        TabButton.MouseEnter:Connect(function()
            if TabButton ~= TabButtons[SelectedTab] then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(
                        CurrentTheme.AccentColor.R * 255 - 20,
                        CurrentTheme.AccentColor.G * 255 - 20,
                        CurrentTheme.AccentColor.B * 255 - 20
                    )
                }):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if TabButton ~= TabButtons[SelectedTab] then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = CurrentTheme.AccentColor
                }):Play()
            end
        end)
        
        if #Tabs == 1 then
            SelectedTab = 1
            TabButton.BackgroundColor3 = CurrentTheme.ToggleOnColor
            TabContent.Visible = true
        end
        
        local Tab = {}
        
        function Tab:AddToggle(name, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -20, 0, 60)
            ToggleFrame.BackgroundColor3 = CurrentTheme.Background
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Text = name
            ToggleLabel.Size = UDim2.new(1, -80, 0, 30)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 5)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.TextColor3 = CurrentTheme.TextColor
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.TextSize = 14
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("Frame")
            ToggleButton.Size = UDim2.new(0, 50, 0, 24)
            ToggleButton.Position = UDim2.new(1, -60, 0, 8)
            ToggleButton.BackgroundColor3 = CurrentTheme.AccentColor
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Parent = ToggleFrame
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
            ToggleCircle.Position = UDim2.new(0, 2, 0, 2)
            ToggleCircle.BackgroundColor3 = CurrentTheme.TextColor
            ToggleCircle.BorderSizePixel = 0
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = ToggleCircle
            ToggleCircle.Parent = ToggleButton
            
            local UICornerToggle = Instance.new("UICorner")
            UICornerToggle.CornerRadius = UDim.new(0, 12)
            UICornerToggle.Parent = ToggleButton
            
            local Enabled = default or false
            
            local function UpdateToggle()
                if Enabled then
                    TweenService:Create(ToggleButton, TweenInfo.new(Config.AnimationSpeed), {
                        BackgroundColor3 = CurrentTheme.ToggleOnColor
                    }):Play()
                    TweenService:Create(ToggleCircle, TweenInfo.new(Config.AnimationSpeed), {
                        Position = UDim2.new(0, 28, 0, 2)
                    }):Play()
                else
                    TweenService:Create(ToggleButton, TweenInfo.new(Config.AnimationSpeed), {
                        BackgroundColor3 = CurrentTheme.AccentColor
                    }):Play()
                    TweenService:Create(ToggleCircle, TweenInfo.new(Config.AnimationSpeed), {
                        Position = UDim2.new(0, 2, 0, 2)
                    }):Play()
                end
                if callback then
                    callback(Enabled)
                end
            end
            
            ToggleButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Enabled = not Enabled
                    UpdateToggle()
                end
            end)
            
            ToggleCircle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Enabled = not Enabled
                    UpdateToggle()
                end
            end)
            
            UpdateToggle()
            
            -- Dropdown para "Mode" (como en la imagen)
            local ModeLabel = Instance.new("TextLabel")
            ModeLabel.Text = "Mode:"
            ModeLabel.Size = UDim2.new(0, 50, 0, 20)
            ModeLabel.Position = UDim2.new(0, 10, 0, 35)
            ModeLabel.BackgroundTransparency = 1
            ModeLabel.TextColor3 = CurrentTheme.TextColor
            ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
            ModeLabel.Font = Enum.Font.Gotham
            ModeLabel.TextSize = 12
            ModeLabel.Parent = ToggleFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(0, 80, 0, 20)
            DropdownButton.Position = UDim2.new(1, -90, 0, 35)
            DropdownButton.BackgroundColor3 = CurrentTheme.DropdownColor
            DropdownButton.TextColor3 = CurrentTheme.TextColor
            DropdownButton.Text = "eaa"
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.TextSize = 12
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Parent = ToggleFrame
            
            local UICornerDropdown = Instance.new("UICorner")
            UICornerDropdown.CornerRadius = UDim.new(0, 5)
            UICornerDropdown.Parent = DropdownButton
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(0, 80, 0, 0)
            DropdownFrame.Position = UDim2.new(1, -90, 0, 55)
            DropdownFrame.BackgroundColor3 = CurrentTheme.DropdownColor
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Visible = false
            DropdownFrame.Parent = ToggleFrame
            
            local DropdownLayout = Instance.new("UIListLayout")
            DropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownLayout.Parent = DropdownFrame
            
            local Options = {"eaa", "eeo", "papa frita", "carne"}
            local SelectedOption = "eaa"
            
            local function PopulateDropdown()
                for _, option in pairs(Options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Size = UDim2.new(1, 0, 0, 20)
                    OptionButton.BackgroundColor3 = CurrentTheme.DropdownColor
                    OptionButton.TextColor3 = CurrentTheme.TextColor
                    OptionButton.Text = option
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.TextSize = 12
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Parent = DropdownFrame
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        SelectedOption = option
                        DropdownButton.Text = option
                        DropdownFrame.Visible = false
                        DropdownFrame:TweenSize(UDim2.new(0, 80, 0, 0), "Out", "Quad", 0.3, true)
                    end)
                end
            end
            
            PopulateDropdown()
            
            DropdownButton.MouseButton1Click:Connect(function()
                DropdownFrame.Visible = not DropdownFrame.Visible
                if DropdownFrame.Visible then
                    DropdownFrame:TweenSize(UDim2.new(0, 80, 0, #Options * 20), "Out", "Quad", 0.3, true)
                else
                    DropdownFrame:TweenSize(UDim2.new(0, 80, 0, 0), "Out", "Quad", 0.3, true)
                end
            end)
            
            local Toggle = {
                Instance = ToggleFrame,
                SetValue = function(self, value)
                    Enabled = value
                    UpdateToggle()
                end,
                GetValue = function(self)
                    return Enabled
                end,
                SetMode = function(self, options)
                    Options = options
                    for _, child in pairs(DropdownFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    PopulateDropdown()
                    SelectedOption = Options[1] or "eaa"
                    DropdownButton.Text = SelectedOption
                end,
                GetMode = function(self)
                    return SelectedOption
                end
            }
            
            return Toggle
        end
        
        function Tab:AddSlider(name, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -20, 0, 70)
            SliderFrame.BackgroundColor3 = CurrentTheme.Background
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Text = name
            SliderLabel.Size = UDim2.new(1, -20, 0, 30)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.TextColor3 = CurrentTheme.TextColor
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Font = Enum.Font.GothamSemibold
            SliderLabel.TextSize = 14
            SliderLabel.Parent = SliderFrame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 40, 0, 30)
            ValueLabel.Position = UDim2.new(1, -50, 0, 5)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.TextColor3 = CurrentTheme.TextColor
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Font = Enum.Font.GothamSemibold
            ValueLabel.TextSize = 14
            ValueLabel.Text = tostring(default)
            ValueLabel.Parent = SliderFrame
            
            local SliderBG = Instance.new("Frame")
            SliderBG.Size = UDim2.new(1, -20, 0, 10)
            SliderBG.Position = UDim2.new(0, 10, 0, 45)
            SliderBG.BackgroundColor3 = CurrentTheme.AccentColor
            SliderBG.BorderSizePixel = 0
            SliderBG.Parent = SliderFrame
            
            local UICornerSlider = Instance.new("UICorner")
            UICornerSlider.CornerRadius = UDim.new(0, 5)
            UICornerSlider.Parent = SliderBG
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = CurrentTheme.ToggleOnColor
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBG
            
            local UICornerFill = Instance.new("UICorner")
            UICornerFill.CornerRadius = UDim.new(0, 5)
            UICornerFill.Parent = SliderFill
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Text = ""
            SliderButton.Parent = SliderBG
            
            local Value = default
            
            local function UpdateSlider(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1), 0, 1, 0)
                SliderFill.Size = pos
                local value = math.floor(min + ((max - min) * pos.X.Scale))
                Value = value
                ValueLabel.Text = tostring(value)
                if callback then
                    callback(value)
                end
            end
            
            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    UpdateSlider(input)
                    local connection
                    connection = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            UpdateSlider(input)
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            if connection then
                                connection:Disconnect()
                            end
                        end
                    end)
                end
            end)
            
            local Slider = {
                Instance = SliderFrame,
                SetValue = function(self, value)
                    Value = math.clamp(value, min, max)
                    ValueLabel.Text = tostring(Value)
                    SliderFill.Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)
                    if callback then
                        callback(Value)
                    end
                end,
                GetValue = function(self)
                    return Value
                end
            }
            
            return Slider
        end
        
        function Tab:AddDropdown(name, options, default, callback)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, -20, 0, 50)
            DropdownFrame.BackgroundColor3 = CurrentTheme.Background
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Parent = TabContent
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Text = name
            DropdownLabel.Size = UDim2.new(1, -20, 0, 30)
            DropdownLabel.Position = UDim2.new(0, 10, 0, 5)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.TextColor3 = CurrentTheme.TextColor
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Font = Enum.Font.GothamSemibold
            DropdownLabel.TextSize = 14
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(0, 100, 0, 20)
            DropdownButton.Position = UDim2.new(1, -110, 0, 25)
            DropdownButton.BackgroundColor3 = CurrentTheme.DropdownColor
            DropdownButton.TextColor3 = CurrentTheme.TextColor
            DropdownButton.Text = default or options[1]
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.TextSize = 12
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Parent = DropdownFrame
            
            local UICornerDropdown = Instance.new("UICorner")
            UICornerDropdown.CornerRadius = UDim.new(0, 5)
            UICornerDropdown.Parent = DropdownButton
            
            local DropdownList = Instance.new("Frame")
            DropdownList.Size = UDim2.new(0, 100, 0, 0)
            DropdownList.Position = UDim2.new(1, -110, 0, 45)
            DropdownList.BackgroundColor3 = CurrentTheme.DropdownColor
            DropdownList.BorderSizePixel = 0
            DropdownList.ClipsDescendants = true
            DropdownList.Visible = false
            DropdownList.Parent = DropdownFrame
            
            local DropdownLayout = Instance.new("UIListLayout")
            DropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownLayout.Parent = DropdownList
            
            local SelectedOption = default or options[1]
            
            local function PopulateDropdown()
                for _, option in pairs(options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Size = UDim2.new(1, 0, 0, 20)
                    OptionButton.BackgroundColor3 = CurrentTheme.DropdownColor
                    OptionButton.TextColor3 = CurrentTheme.TextColor
                    OptionButton.Text = option
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.TextSize = 12
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Parent = DropdownList
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        SelectedOption = option
                        DropdownButton.Text = option
                        DropdownList.Visible = false
                        DropdownList:TweenSize(UDim2.new(0, 100, 0, 0), "Out", "Quad", 0.3, true)
                        if callback then
                            callback(option)
                        end
                    end)
                end
            end
            
            PopulateDropdown()
            
            DropdownButton.MouseButton1Click:Connect(function()
                DropdownList.Visible = not DropdownList.Visible
                if DropdownList.Visible then
                    DropdownList:TweenSize(UDim2.new(0, 100, 0, #options * 20), "Out", "Quad", 0.3, true)
                else
                    DropdownList:TweenSize(UDim2.new(0, 100, 0, 0), "Out", "Quad", 0.3, true)
                end
            end)
            
            local Dropdown = {
                Instance = DropdownFrame,
                SetValue = function(self, value)
                    SelectedOption = value
                    DropdownButton.Text = value
                    if callback then
                        callback(value)
                    end
                end,
                GetValue = function(self)
                    return SelectedOption
                end
            }
            
            return Dropdown
        end
        
        function Tab:AddButton(name, callback)
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Size = UDim2.new(1, -20, 0, 40)
            ButtonFrame.BackgroundTransparency = 1
            ButtonFrame.Parent = TabContent
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(0, 40, 0, 40)
            Button.Position = UDim2.new(1, -50, 0, 0)
            Button.BackgroundColor3 = CurrentTheme.AccentColor
            Button.BorderSizePixel = 0
            Button.Text = name
            Button.TextColor3 = CurrentTheme.TextColor
            Button.Font = Enum.Font.GothamSemibold
            Button.TextSize = 14
            Button.Parent = ButtonFrame
            Button.AutoButtonColor = false
            
            local UICornerButton = Instance.new("UICorner")
            UICornerButton.CornerRadius = UDim.new(0, 4)
            UICornerButton.Parent = Button
            
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = CurrentTheme.ToggleOnColor
                }):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = CurrentTheme.AccentColor
                }):Play()
            end)
            
            Button.MouseButton1Down:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    Size = UDim2.new(0, 38, 0, 38),
                    Position = UDim2.new(1, -49, 0, 1)
                }):Play()
            end)
            
            Button.MouseButton1Up:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    Size = UDim2.new(0, 40, 0, 40),
                    Position = UDim2.new(1, -50, 0, 0)
                }):Play()
                if callback then
                    callback()
                end
            end)
            
            return Button
        end
        
        return Tab
    end
    
    return Window
end

return Library
