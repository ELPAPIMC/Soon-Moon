-- MoonUI Library for Roblox
local MoonUI = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Default Configuration
local Config = {
    Background = Color3.fromRGB(50, 70, 80),
    AccentColor = Color3.fromRGB(60, 80, 90),
    TextColor = Color3.fromRGB(200, 200, 200),
    ToggleOnColor = Color3.fromRGB(80, 100, 110),
    BorderColor = Color3.fromRGB(40, 60, 70),
    AnimationSpeed = 0.2,
    Themes = {
        Default = {
            Background = Color3.fromRGB(50, 70, 80),
            AccentColor = Color3.fromRGB(60, 80, 90),
            TextColor = Color3.fromRGB(200, 200, 200),
            ToggleOnColor = Color3.fromRGB(80, 100, 110),
            BorderColor = Color3.fromRGB(40, 60, 70)
        },
        Dark = {
            Background = Color3.fromRGB(30, 30, 30),
            AccentColor = Color3.fromRGB(40, 40, 40),
            TextColor = Color3.fromRGB(180, 180, 180),
            ToggleOnColor = Color3.fromRGB(60, 60, 60),
            BorderColor = Color3.fromRGB(20, 20, 20)
        }
    }
}

-- Notification System
local NotificationSystem = {}
function NotificationSystem:Create(message, duration)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 200, 0, 50)
    NotifFrame.Position = UDim2.new(1, -210, 1, -60)
    NotifFrame.BackgroundColor3 = Config.Background
    NotifFrame.BorderSizePixel = 1
    NotifFrame.BorderColor3 = Config.BorderColor
    NotifFrame.Parent = ScreenGui
    
    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -10, 1, -10)
    NotifText.Position = UDim2.new(0, 5, 0, 5)
    NotifText.BackgroundTransparency = 1
    NotifText.TextColor3 = Config.TextColor
    NotifText.Text = message
    NotifText.Font = Enum.Font.Gotham
    NotifText.TextSize = 12
    NotifText.TextWrapped = true
    NotifText.Parent = NotifFrame
    
    local tweenIn = TweenService:Create(NotifFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, -210, 1, -60)})
    tweenIn:Play()
    
    wait(duration or 3)
    
    local tweenOut = TweenService:Create(NotifFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, 0, 1, -60)})
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end

function MoonUI:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = title
    ScreenGui.Parent = game.CoreGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 500, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
    MainFrame.BackgroundColor3 = Config.Background
    MainFrame.BorderSizePixel = 1
    MainFrame.BorderColor3 = Config.BorderColor
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- Header
    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Size = UDim2.new(1, 0, 0, 30)
    HeaderFrame.BackgroundColor3 = Config.AccentColor
    HeaderFrame.BorderSizePixel = 0
    HeaderFrame.Parent = MainFrame
    
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 20, 0, 20)
    Icon.Position = UDim2.new(0, 5, 0, 5)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://6035047409" -- Water drop icon
    Icon.Parent = HeaderFrame
    
    local TitleBar = Instance.new("TextLabel")
    TitleBar.Text = title
    TitleBar.Size = UDim2.new(1, -40, 1, 0)
    TitleBar.Position = UDim2.new(0, 30, 0, 0)
    TitleBar.BackgroundTransparency = 1
    TitleBar.TextColor3 = Config.TextColor
    TitleBar.TextXAlignment = Enum.TextXAlignment.Left
    TitleBar.Font = Enum.Font.GothamSemibold
    TitleBar.TextSize = 14
    TitleBar.Parent = HeaderFrame
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Position = UDim2.new(1, -25, 0, 5)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "-"
    CloseButton.TextColor3 = Config.TextColor
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    CloseButton.Parent = HeaderFrame
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, -30)
    ContentFrame.Position = UDim2.new(0, 0, 0, 30)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame
    
    -- Left and Right Sections
    local LeftGroup = Instance.new("ScrollingFrame")
    LeftGroup.Size = UDim2.new(0.25, 0, 1, 0)
    LeftGroup.BackgroundTransparency = 0.3
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
    
    function Window:SetTheme(themeName)
        local theme = Config.Themes[themeName] or Config.Themes.Default
        Config.Background = theme.Background
        Config.AccentColor = theme.AccentColor
        Config.TextColor = theme.TextColor
        Config.ToggleOnColor = theme.ToggleOnColor
        Config.BorderColor = theme.BorderColor
        
        MainFrame.BackgroundColor3 = Config.Background
        MainFrame.BorderColor3 = Config.BorderColor
        HeaderFrame.BackgroundColor3 = Config.AccentColor
        TitleBar.TextColor3 = Config.TextColor
        CloseButton.TextColor3 = Config.TextColor
        LeftGroup.BackgroundColor3 = Config.Background
        
        for i, tab in pairs(Tabs) do
            tab.BackgroundColor3 = Config.AccentColor
            for _, child in pairs(tab:GetChildren()) do
                if child:IsA("Frame") and child.Name ~= "UIGradient" then
                    child.BackgroundColor3 = Config.Background
                    for _, subChild in pairs(child:GetChildren()) do
                        if subChild:IsA("TextLabel") then
                            subChild.TextColor3 = Config.TextColor
                        elseif subChild:IsA("Frame") and subChild.Name == "ToggleButton" then
                            subChild.BackgroundColor3 = Config.AccentColor
                        end
                    end
                end
            end
        end
        
        for i, button in pairs(TabButtons) do
            if i == SelectedTab then
                button.BackgroundColor3 = Config.ToggleOnColor
            else
                button.BackgroundColor3 = Config.AccentColor
            end
            button.TextColor3 = Config.TextColor
        end
    end
    
    function Window:AddTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -10, 0, 30)
        TabButton.Position = UDim2.new(0, 5, 0, 5 + (#TabButtons * 35))
        TabButton.BackgroundColor3 = Config.AccentColor
        TabButton.TextColor3 = Config.TextColor
        TabButton.Text = name
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextSize = 12
        TabButton.Parent = LeftGroup
        TabButton.BorderSizePixel = 0
        TabButton.AutoButtonColor = false
        
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
        table.insert(Tabs, TabContent)
        
        TabButton.MouseButton1Click:Connect(function()
            if SelectedTab then
                TweenService:Create(TabButtons[SelectedTab], TweenInfo.new(Config.AnimationSpeed), {
                    BackgroundColor3 = Config.AccentColor
                }):Play()
                Tabs[SelectedTab].Visible = false
            end
            
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
            ToggleLabel.TextSize = 12
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("Frame")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -50, 0, 8)
            ToggleButton.BackgroundColor3 = Config.AccentColor
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Parent = ToggleFrame
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
            ToggleCircle.Position = UDim2.new(0, 2, 0, 2)
            ToggleCircle.BackgroundColor3 = Config.TextColor
            ToggleCircle.BorderSizePixel = 0
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = ToggleCircle
            
            ToggleCircle.Parent = ToggleButton
            
            local UICornerToggle = Instance.new("UICorner")
            UICornerToggle.CornerRadius = UDim.new(0, 10)
            UICornerToggle.Parent = ToggleButton
            
            local Enabled = default or false
            
            local function UpdateToggle()
                if Enabled then
                    TweenService:Create(ToggleButton, TweenInfo.new(Config.AnimationSpeed), {
                        BackgroundColor3 = Config.ToggleOnColor
                    }):Play()
                    TweenService:Create(ToggleCircle, TweenInfo.new(Config.AnimationSpeed), {
                        Position = UDim2.new(0, 22, 0, 2)
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
            
            ToggleButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Enabled = not Enabled
                    UpdateToggle()
                    NotificationSystem:Create(name .. " set to " .. tostring(Enabled), 2)
                end
            end)
            
            UpdateToggle()
            
            local ModeLabel = Instance.new("TextLabel")
            ModeLabel.Text = "Mode:"
            ModeLabel.Size = UDim2.new(0, 50, 0, 20)
            ModeLabel.Position = UDim2.new(0, 10, 0, 35)
            ModeLabel.BackgroundTransparency = 1
            ModeLabel.TextColor3 = Config.TextColor
            ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
            ModeLabel.Font = Enum.Font.Gotham
            ModeLabel.TextSize = 10
            ModeLabel.Parent = ToggleFrame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Text = "eaa"
            ValueLabel.Size = UDim2.new(0, 50, 0, 20)
            ValueLabel.Position = UDim2.new(1, -60, 0, 35)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.TextColor3 = Config.TextColor
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Font = Enum.Font.Gotham
            ValueLabel.TextSize = 10
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
            SliderFrame.Size = UDim2.new(1, -20, 0, 60)
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
            SliderLabel.TextSize = 12
            SliderLabel.Parent = SliderFrame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 40, 0, 30)
            ValueLabel.Position = UDim2.new(1, -50, 0, 5)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.TextColor3 = Config.TextColor
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Font = Enum.Font.GothamSemibold
            ValueLabel.TextSize = 12
            ValueLabel.Text = tostring(default)
            ValueLabel.Parent = SliderFrame
            
            local SliderBG = Instance.new("Frame")
            SliderBG.Size = UDim2.new(1, -20, 0, 8)
            SliderBG.Position = UDim2.new(0, 10, 0, 45)
            SliderBG.BackgroundColor3 = Config.AccentColor
            SliderBG.BorderSizePixel = 0
            SliderBG.Parent = SliderFrame
            
            local UICornerSlider = Instance.new("UICorner")
            UICornerSlider.CornerRadius = UDim.new(0, 4)
            UICornerSlider.Parent = SliderBG
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Config.ToggleOnColor
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBG
            
            local UICornerFill = Instance.new("UICorner")
            UICornerFill.CornerRadius = UDim.new(0, 4)
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
                            NotificationSystem:Create(name .. " set to " .. tostring(Value), 2)
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
            DropdownFrame.Size = UDim2.new(1, -20, 0, 40)
            DropdownFrame.BackgroundColor3 = Config.Background
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Parent = TabContent
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Text = name
            DropdownLabel.Size = UDim2.new(1, -20, 0, 20)
            DropdownLabel.Position = UDim2.new(0, 10, 0, 5)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.TextColor3 = Config.TextColor
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Font = Enum.Font.GothamSemibold
            DropdownLabel.TextSize = 12
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(0, 100, 0, 20)
            DropdownButton.Position = UDim2.new(1, -110, 0, 10)
            DropdownButton.BackgroundColor3 = Config.AccentColor
            DropdownButton.TextColor3 = Config.TextColor
            DropdownButton.Text = default or options[1]
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.TextSize = 10
            DropdownButton.Parent = DropdownFrame
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = DropdownButton
            
            local DropdownList = Instance.new("Frame")
            DropdownList.Size = UDim2.new(0, 100, 0, 0)
            DropdownList.Position = UDim2.new(1, -110, 0, 30)
            DropdownList.BackgroundColor3 = Config.Background
            DropdownList.BorderSizePixel = 1
            DropdownList.BorderColor3 = Config.BorderColor
            DropdownList.Visible = false
            DropdownList.Parent = DropdownFrame
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Parent = DropdownList
            
            local function ToggleDropdown()
                DropdownList.Visible = not DropdownList.Visible
                local height = #options * 20
                local tween = TweenService:Create(DropdownList, TweenInfo.new(0.2), {
                    Size = DropdownList.Visible and UDim2.new(0, 100, 0, height) or UDim2.new(0, 100, 0, 0)
                })
                tween:Play()
            end
            
            DropdownButton.MouseButton1Click:Connect(ToggleDropdown)
            
            for _, option in pairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 20)
                OptionButton.BackgroundColor3 = Config.AccentColor
                OptionButton.TextColor3 = Config.TextColor
                OptionButton.Text = option
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.TextSize = 10
                OptionButton.Parent = DropdownList
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropdownButton.Text = option
                    ToggleDropdown()
                    if callback then
                        callback(option)
                    end
                    NotificationSystem:Create(name .. " set to " .. option, 2)
                end)
            end
            
            local Dropdown = {
                Instance = DropdownFrame,
                SetValue = function(self, value)
                    DropdownButton.Text = value
                    if callback then
                        callback(value)
                    end
                end,
                GetValue = function(self)
                    return DropdownButton.Text
                end
            }
            
            return Dropdown
        end
        
        function Tab:AddButton(name, callback)
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Size = UDim2.new(0, 40, 0, 40)
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
            
            Button.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
                NotificationSystem:Create(name .. " clicked", 2)
            end)
            
            return Button
        end
        
        return Tab
    end
    
    return Window
end

return MoonUI
