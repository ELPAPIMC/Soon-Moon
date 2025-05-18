-- UI Library para Roblox
local Library = {}

-- Colores y configuración
local Config = {
    Background = Color3.fromRGB(120, 190, 200),
    AccentColor = Color3.fromRGB(100, 160, 170),
    TextColor = Color3.fromRGB(255, 255, 255),
    ToggleOnColor = Color3.fromRGB(80, 140, 150),
    BorderSize = 1,
    BorderColor = Color3.fromRGB(90, 150, 160),
    AnimationSpeed = 0.3
}

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = title
    ScreenGui.Parent = game.CoreGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    MainFrame.BackgroundColor3 = Config.Background
    MainFrame.BorderSizePixel = Config.BorderSize
    MainFrame.BorderColor3 = Config.BorderColor
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- Encabezado con el icono de estrella
    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Size = UDim2.new(1, 0, 0, 40)
    HeaderFrame.BackgroundColor3 = Config.AccentColor
    HeaderFrame.BorderSizePixel = 0
    HeaderFrame.Parent = MainFrame
    
    local StarIcon = Instance.new("ImageLabel")
    StarIcon.Size = UDim2.new(0, 25, 0, 25)
    StarIcon.Position = UDim2.new(0, 10, 0, 7)
    StarIcon.BackgroundTransparency = 1
    StarIcon.Image = "rbxassetid://6031075938" -- ID de imagen de estrella
    StarIcon.Parent = HeaderFrame
    
    -- Efecto de brillo para la estrella (animación)
    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local tween = TweenService:Create(StarIcon, tweenInfo, {ImageTransparency = 0.3})
    tween:Play()
    
    local TitleBar = Instance.new("TextLabel")
    TitleBar.Text = title
    TitleBar.Size = UDim2.new(1, -50, 1, 0)
    TitleBar.Position = UDim2.new(0, 45, 0, 0)
    TitleBar.BackgroundTransparency = 1
    TitleBar.TextColor3 = Config.TextColor
    TitleBar.TextXAlignment = Enum.TextXAlignment.Left
    TitleBar.Font = Enum.Font.GothamSemibold
    TitleBar.TextSize = 16
    TitleBar.Parent = HeaderFrame
    
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, -40)
    ContentFrame.Position = UDim2.new(0, 0, 0, 40)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame
    
    -- Divisiones izquierda y derecha
    local LeftGroup = Instance.new("ScrollingFrame")
    LeftGroup.Size = UDim2.new(0.25, 0, 1, 0)
    LeftGroup.BackgroundTransparency = 0.5
    LeftGroup.BackgroundColor3 = Config.Background
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
    
    local Window = {}
    
    function Window:AddTab(name)
        -- Botón del tab
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -10, 0, 40)
        TabButton.Position = UDim2.new(0, 5, 0, 5 + (#TabButtons * 45))
        TabButton.BackgroundColor3 = Config.AccentColor
        TabButton.TextColor3 = Config.TextColor
        TabButton.Text = name
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextSize = 14
        TabButton.Parent = LeftGroup
        TabButton.BorderSizePixel = 0
        TabButton.AutoButtonColor = false
        
        -- Contenido del tab
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, -10, 1, -10)
        TabContent.Position = UDim2.new(0, 5, 0, 5)
        TabContent.BackgroundColor3 = Config.AccentColor
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
        
        -- Animación al hacer clic
        TabButton.MouseButton1Click:Connect(function()
            -- Deseleccionar el tab actual
            if SelectedTab then
                TweenService:Create(TabButtons[SelectedTab], TweenInfo.new(Config.AnimationSpeed), {
                    BackgroundColor3 = Config.AccentColor
                }):Play()
                Tabs[SelectedTab].Visible = false
            end
            
            -- Seleccionar el nuevo tab
            for i, button in pairs(TabButtons) do
                if button == TabButton then
                    SelectedTab = i
                    TweenService:Create(button, TweenInfo.new(Config.AnimationSpeed), {
                        BackgroundColor3 = Config.ToggleOnColor
                    }):Play()
                    Tabs[i].Visible = true
                end
            end
        end)
        
        -- Efectos de hover
        TabButton.MouseEnter:Connect(function()
            if TabButton ~= TabButtons[SelectedTab] then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(
                        Config.AccentColor.R * 255 - 20,
                        Config.AccentColor.G * 255 - 20,
                        Config.AccentColor.B * 255 - 20
                    )
                }):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if TabButton ~= TabButtons[SelectedTab] then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Config.AccentColor
                }):Play()
            end
        end)
        
        table.insert(Tabs, TabContent)
        
        if #Tabs == 1 then
            SelectedTab = 1
            TabButton.BackgroundColor3 = Config.ToggleOnColor
            TabContent.Visible = true
        end
        
        local Tab = {}
        
        function Tab:AddToggle(name, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -20, 0, 60)
            ToggleFrame.BackgroundColor3 = Config.Background
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Text = name
            ToggleLabel.Size = UDim2.new(1, -80, 0, 30)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 5)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.TextColor3 = Config.TextColor
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.TextSize = 14
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("Frame")
            ToggleButton.Size = UDim2.new(0, 50, 0, 24)
            ToggleButton.Position = UDim2.new(1, -60, 0, 8)
            ToggleButton.BackgroundColor3 = Config.AccentColor
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Parent = ToggleFrame
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
            ToggleCircle.Position = UDim2.new(0, 2, 0, 2)
            ToggleCircle.BackgroundColor3 = Config.TextColor
            ToggleCircle.BorderSizePixel = 0
            
            -- Redondeamos el círculo
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = ToggleCircle
            
            ToggleCircle.Parent = ToggleButton
            
            local UICornerToggle = Instance.new("UICorner")
            UICornerToggle.CornerRadius = UDim.new(0, 12)
            UICornerToggle.Parent = ToggleButton
            
            -- Estado del toggle
            local Enabled = default or false
            
            local function UpdateToggle()
                if Enabled then
                    TweenService:Create(ToggleButton, TweenInfo.new(Config.AnimationSpeed), {
                        BackgroundColor3 = Config.ToggleOnColor
                    }):Play()
                    TweenService:Create(ToggleCircle, TweenInfo.new(Config.AnimationSpeed), {
                        Position = UDim2.new(0, 28, 0, 2)
                    }):Play()
                else
                    TweenService:Create(ToggleButton, TweenInfo.new(Config.AnimationSpeed), {
                        BackgroundColor3 = Config.AccentColor
                    }):Play()
                    TweenService:Create(ToggleCircle, TweenInfo.new(Config.AnimationSpeed), {
                        Position = UDim2.new(0, 2, 0, 2)
                    }):Play()
                end
                
                if callback then
                    callback(Enabled)
                end
            end
            
            -- Hacer clic en el toggle
            ToggleButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Enabled = not Enabled
                    UpdateToggle()
                end
            end)
            
            -- Agregar el mismo efecto al hacer clic en el círculo
            ToggleCircle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Enabled = not Enabled
                    UpdateToggle()
                end
            end)
            
            -- Configuración inicial
            UpdateToggle()
            
            -- Modo y valor (como en la imagen)
            local ModeLabel = Instance.new("TextLabel")
            ModeLabel.Text = "Mode:"
            ModeLabel.Size = UDim2.new(0, 50, 0, 20)
            ModeLabel.Position = UDim2.new(0, 10, 0, 35)
            ModeLabel.BackgroundTransparency = 1
            ModeLabel.TextColor3 = Config.TextColor
            ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
            ModeLabel.Font = Enum.Font.Gotham
            ModeLabel.TextSize = 12
            ModeLabel.Parent = ToggleFrame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Text = "eaa"
            ValueLabel.Size = UDim2.new(0, 50, 0, 20)
            ValueLabel.Position = UDim2.new(1, -60, 0, 35)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.TextColor3 = Config.TextColor
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Font = Enum.Font.Gotham
            ValueLabel.TextSize = 12
            ValueLabel.Parent = ToggleFrame
            
            local Toggle = {
                Instance = ToggleFrame,
                SetValue = function(self, value)
                    Enabled = value
                    UpdateToggle()
                end,
                GetValue = function(self)
                    return Enabled
                end,
                SetMode = function(self, text)
                    ValueLabel.Text = text
                end
            }
            
            return Toggle
        end
        
        function Tab:AddSlider(name, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -20, 0, 70)
            SliderFrame.BackgroundColor3 = Config.Background
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Text = name
            SliderLabel.Size = UDim2.new(1, -20, 0, 30)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.TextColor3 = Config.TextColor
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Font = Enum.Font.GothamSemibold
            SliderLabel.TextSize = 14
            SliderLabel.Parent = SliderFrame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 40, 0, 30)
            ValueLabel.Position = UDim2.new(1, -50, 0, 5)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.TextColor3 = Config.TextColor
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Font = Enum.Font.GothamSemibold
            ValueLabel.TextSize = 14
            ValueLabel.Text = tostring(default)
            ValueLabel.Parent = SliderFrame
            
            local SliderBG = Instance.new("Frame")
            SliderBG.Size = UDim2.new(1, -20, 0, 10)
            SliderBG.Position = UDim2.new(0, 10, 0, 45)
            SliderBG.BackgroundColor3 = Config.AccentColor
            SliderBG.BorderSizePixel = 0
            SliderBG.Parent = SliderFrame
            
            local UICornerSlider = Instance.new("UICorner")
            UICornerSlider.CornerRadius = UDim.new(0, 5)
            UICornerSlider.Parent = SliderBG
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Config.ToggleOnColor
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
                    connection = game:GetService("UserInputService").InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            UpdateSlider(input)
                        end
                    end)
                    
                    game:GetService("UserInputService").InputEnded:Connect(function(input)
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
        
        function Tab:AddButton(name, callback)
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Size = UDim2.new(1, -20, 0, 40)
            ButtonFrame.BackgroundTransparency = 1
            ButtonFrame.Parent = TabContent
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.BackgroundColor3 = Config.AccentColor
            Button.BorderSizePixel = 0
            Button.Text = name
            Button.TextColor3 = Config.TextColor
            Button.Font = Enum.Font.GothamSemibold
            Button.TextSize = 14
            Button.Parent = ButtonFrame
            Button.AutoButtonColor = false
            
            local UICornerButton = Instance.new("UICorner")
            UICornerButton.CornerRadius = UDim.new(0, 4)
            UICornerButton.Parent = Button
            
            -- Efectos del botón
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Config.ToggleOnColor
                }):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Config.AccentColor
                }):Play()
            end)
            
            Button.MouseButton1Down:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    Size = UDim2.new(0.98, 0, 0.95, 0),
                    Position = UDim2.new(0.01, 0, 0.025, 0)
                }):Play()
            end)
            
            Button.MouseButton1Up:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0)
                }):Play()
                
                if callback then
                    callback()
                end
            end)
            
            return Button
        end
        
        return Tab
    end
    
    function Window:AddLeftGroup(name)
        local GroupButton = Instance.new("TextButton")
        GroupButton.Size = UDim2.new(1, -10, 0, 40)
        GroupButton.BackgroundColor3 = Config.AccentColor
        GroupButton.TextColor3 = Config.TextColor
        GroupButton.Text = name
        GroupButton.Font = Enum.Font.GothamSemibold
        GroupButton.TextSize = 14
        GroupButton.Parent = LeftGroup
        GroupButton.BorderSizePixel = 0
        
        -- Efectos de hover para el grupo
        GroupButton.MouseEnter:Connect(function()
            TweenService:Create(GroupButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Config.ToggleOnColor
            }):Play()
        end)
        
        GroupButton.MouseLeave:Connect(function()
            TweenService:Create(GroupButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Config.AccentColor
            }):Play()
        end)
        
        return GroupButton
    end
    
    function Window:AddRightGroup(name)
        local GroupFrame = Instance.new("Frame")
        GroupFrame.Size = UDim2.new(1, -10, 0, 100)
        GroupFrame.BackgroundColor3 = Config.AccentColor
        GroupFrame.BorderSizePixel = 0
        GroupFrame.Parent = RightGroup
        
        local GroupTitle = Instance.new("TextLabel")
        GroupTitle.Text = name
        GroupTitle.Size = UDim2.new(1, 0, 0, 30)
        GroupTitle.BackgroundColor3 = Config.Background
        GroupTitle.BorderSizePixel = 0
        GroupTitle.TextColor3 = Config.TextColor
        GroupTitle.Font = Enum.Font.GothamSemibold
        GroupTitle.TextSize = 14
        GroupTitle.Parent = GroupFrame
        
        local GroupContent = Instance.new("Frame")
        GroupContent.Size = UDim2.new(1, 0, 1, -30)
        GroupContent.Position = UDim2.new(0, 0, 0, 30)
        GroupContent.BackgroundTransparency = 1
        GroupContent.Parent = GroupFrame
        
        local Group = {
            Instance = GroupFrame,
            Content = GroupContent,
            AddButton = function(self, name, callback)
                -- Código para agregar botón dentro del grupo
            end,
            AddToggle = function(self, name, default, callback)
                -- Código para agregar toggle dentro del grupo
            end
        }
        
        return Group
    end
    
    if #Tabs > 0 then
        TabButtons[1].BackgroundColor3 = Config.ToggleOnColor
        Tabs[1].Visible = true
        SelectedTab = 1
    end
    
    return Window
end

return Library
