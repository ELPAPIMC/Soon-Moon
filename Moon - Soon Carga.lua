-- Custom UI Library for Game Menus
local Library = {}
Library.Tabs = {}
Library.Toggles = {}
Library.Sliders = {}
Library.Dropdowns = {}

-- Colors and Configuration
local Colors = {
    Background = Color3.fromRGB(20, 20, 20),
    TabBackground = Color3.fromRGB(30, 30, 30),
    Selected = Color3.fromRGB(60, 60, 255),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(200, 200, 200),
    Border = Color3.fromRGB(60, 60, 60),
    ToggleOn = Color3.fromRGB(60, 60, 255),
    ToggleOff = Color3.fromRGB(50, 50, 50),
    SliderBackground = Color3.fromRGB(30, 30, 30),
    SliderFill = Color3.fromRGB(60, 60, 255),
    NotificationBackground = Color3.fromRGB(30, 30, 30),
    NotificationBorder = Color3.fromRGB(60, 60, 255)
}

-- Notification stack management
local NotificationStack = {}
local NOTIFICATION_OFFSET = 100
local NOTIFICATION_SPACING = 10

-- Helper function for animations
local function createTween(instance, properties, duration, easingStyle, easingDirection)
    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(duration, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Main GUI creation
function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = title.."GUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 700, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -200)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundTransparency = 1
    
    -- Fade-in animation
    createTween(MainFrame, {BackgroundTransparency = 0}, 0.5)
    
    -- Make draggable
    local UserInputService = game:GetService("UserInputService")
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)
    
    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Colors.TabBackground
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "Title"
    TitleText.Size = UDim2.new(1, -10, 1, 0)
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = title
    TitleText.TextColor3 = Colors.Text
    TitleText.TextSize = 16
    TitleText.Font = Enum.Font.SourceSansBold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 24, 0, 24)
    CloseButton.Position = UDim2.new(1, -27, 0, 3)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.Parent = TitleBar
    
    CloseButton.MouseButton1Click:Connect(function()
        createTween(MainFrame, {BackgroundTransparency = 1}, 0.5).Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end)
    
    -- Tab container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 120, 1, -30)
    TabContainer.Position = UDim2.new(0, 0, 0, 30)
    TabContainer.BackgroundColor3 = Colors.TabBackground
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Vertical
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 1)
    TabLayout.Parent = TabContainer
    
    -- Content frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -120, 1, -30)
    ContentFrame.Position = UDim2.new(0, 120, 0, 30)
    ContentFrame.BackgroundColor3 = Colors.Background
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame
    
    local window = {}
    window.ContentFrame = ContentFrame
    window.TabContainer = TabContainer
    window.MainFrame = MainFrame
    window.ScreenGui = ScreenGui
    
    return window
end

-- Add tab function
function Library:AddTab(window, tabName, icon)
    -- Tab button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName.."Tab"
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.BackgroundColor3 = Colors.TabBackground
    TabButton.BorderSizePixel = 0
    TabButton.Text = ""
    TabButton.Parent = window.TabContainer
    TabButton.BackgroundTransparency = 0.5
    
    -- Fade-in animation
    createTween(TabButton, {BackgroundTransparency = 0}, 0.3)
    
    local TabLabel = Instance.new("TextLabel")
    TabLabel.Name = "Label"
    TabLabel.Size = UDim2.new(1, -10, 1, 0)
    TabLabel.Position = UDim2.new(0, 40, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = tabName
    TabLabel.TextColor3 = Colors.Text
    TabLabel.TextSize = 14
    TabLabel.Font = Enum.Font.SourceSansBold
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Parent = TabButton
    
    -- Icon if provided
    if icon then
        local IconImage = Instance.new("ImageLabel")
        IconImage.Name = "Icon"
        IconImage.Size = UDim2.new(0, 20, 0, 20)
        IconImage.Position = UDim2.new(0, 10, 0.5, -10)
        IconImage.BackgroundTransparency = 1
        IconImage.Image = icon
        IconImage.Parent = TabButton
    end
    
    -- Create content page
    local ContentPage = Instance.new("ScrollingFrame")
    ContentPage.Name = tabName.."Page"
    ContentPage.Size = UDim2.new(1, -20, 1, -20)
    ContentPage.Position = UDim2.new(0, 10, 0, 10)
    ContentPage.BackgroundTransparency = 1
    ContentPage.BorderSizePixel = 0
    ContentPage.ScrollBarThickness = 4
    ContentPage.Visible = false
    ContentPage.ScrollingDirection = Enum.ScrollingDirection.Y
    ContentPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentPage.Parent = window.ContentFrame
    
    local ElementLayout = Instance.new("UIListLayout")
    ElementLayout.FillDirection = Enum.FillDirection.Vertical
    ElementLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ElementLayout.Padding = UDim.new(0, 8)
    ElementLayout.Parent = ContentPage
    
    ElementLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentPage.CanvasSize = UDim2.new(0, 0, 0, ElementLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Add tab to table
    table.insert(self.Tabs, {
        Button = TabButton,
        Page = ContentPage
    })
    
    -- Tab selection logic
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab.Button.BackgroundColor3 = Colors.TabBackground
            tab.Page.Visible = false
        end
        
        createTween(TabButton, {BackgroundColor3 = Colors.Selected}, 0.3)
        ContentPage.Visible = true
        createTween(ContentPage, {ScrollBarImageTransparency = 0}, 0.3)
    end)
    
    -- Select first tab by default
    if #self.Tabs == 1 then
        TabButton.BackgroundColor3 = Colors.Selected
        ContentPage.Visible = true
    end
    
    local tab = {}
    tab.Page = ContentPage
    
    return tab
end

-- Add label function
function Library:AddLabel(tab, text)
    local LabelContainer = Instance.new("Frame")
    LabelContainer.Name = "LabelContainer"
    LabelContainer.Size = UDim2.new(1, 0, 0, 30)
    LabelContainer.BackgroundTransparency = 1
    LabelContainer.Parent = tab.Page
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -10, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Colors.Text
    Label.TextSize = 14
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextTransparency = 1
    Label.Parent = LabelContainer
    
    -- Fade-in animation
    createTween(Label, {TextTransparency = 0}, 0.5)
    
    local label = {}
    label.Container = LabelContainer
    label.Label = Label
    
    return label
end

-- Add toggle function
function Library:AddToggle(tab, name, default, callback)
    local default = default or false
    local callback = callback or function() end
    
    local ToggleContainer = Instance.new("Frame")
    ToggleContainer.Name = name.."Toggle"
    ToggleContainer.Size = UDim2.new(1, 0, 0, 30)
    ToggleContainer.BackgroundTransparency = 1
    ToggleContainer.Parent = tab.Page
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Colors.Text
    ToggleLabel.TextSize = 14
    ToggleLabel.Font = Enum.Font.SourceSans
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.TextTransparency = 1
    ToggleLabel.Parent = ToggleContainer
    
    local ToggleButton = Instance.new("Frame")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
    ToggleButton.BackgroundColor3 = default and Colors.ToggleOn or Colors.ToggleOff
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = ToggleContainer
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Name = "Circle"
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    ToggleCircle.BackgroundColor3 = Colors.Text
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Parent = ToggleButton
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = ToggleButton
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(1, 0)
    UICorner2.Parent = ToggleCircle
    
    local Toggle = {}
    Toggle.Value = default
    Toggle.Container = ToggleContainer
    Toggle.Button = ToggleButton
    Toggle.Circle = ToggleCircle
    
    -- For clicking anywhere on the toggle container
    local ToggleClickArea = Instance.new("TextButton")
    ToggleClickArea.Name = "ClickArea"
    ToggleClickArea.Size = UDim2.new(1, 0, 1, 0)
    ToggleClickArea.BackgroundTransparency = 1
    ToggleClickArea.Text = ""
    ToggleClickArea.Parent = ToggleContainer
    
    local function updateToggle()
        Toggle.Value = not Toggle.Value
        
        createTween(ToggleButton, {BackgroundColor3 = Toggle.Value and Colors.ToggleOn or Colors.ToggleOff}, 0.2)
        createTween(ToggleCircle, {Position = Toggle.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
        callback(Toggle.Value)
    end
    
    ToggleClickArea.MouseButton1Click:Connect(updateToggle)
    
    -- Fade-in animation
    createTween(ToggleLabel, {TextTransparency = 0}, 0.5)
    
    -- Add to toggles table
    table.insert(self.Toggles, Toggle)
    
    return Toggle
end

-- Add slider function
function Library:AddSlider(tab, name, options, callback)
    options = options or {}
    local min = options.min or 0
    local max = options.max or 100
    local default = options.default or min
    local precise = options.precise or false
    local suffix = options.suffix or ""
    local callback = callback or function() end
    
    local SliderContainer = Instance.new("Frame")
    SliderContainer.Name = name.."Slider"
    SliderContainer.Size = UDim2.new(1, 0, 0, 50)
    SliderContainer.BackgroundTransparency = 1
    SliderContainer.Parent = tab.Page
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Name = "Label"
    SliderLabel.Size = UDim2.new(1, -10, 0, 20)
    SliderLabel.Position = UDim2.new(0, 10, 0, 0)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = name
    SliderLabel.TextColor3 = Colors.Text
    SliderLabel.TextSize = 14
    SliderLabel.Font = Enum.Font.SourceSans
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.TextTransparency = 1
    SliderLabel.Parent = SliderContainer
    
    local SliderBackground = Instance.new("Frame")
    SliderBackground.Name = "Background"
    SliderBackground.Size = UDim2.new(1, -20, 0, 6)
    SliderBackground.Position = UDim2.new(0, 10, 0, 30)
    SliderBackground.BackgroundColor3 = Colors.SliderBackground
    SliderBackground.BorderSizePixel = 0
    SliderBackground.Parent = SliderContainer
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 3)
    UICorner.Parent = SliderBackground
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "Fill"
    SliderFill.BackgroundColor3 = Colors.SliderFill
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBackground
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 3)
    UICorner2.Parent = SliderFill
    
    local SliderValue = Instance.new("TextLabel")
    SliderValue.Name = "Value"
    SliderValue.Size = UDim2.new(0, 50, 0, 20)
    SliderValue.Position = UDim2.new(1, -60, 0, 0)
    SliderValue.BackgroundTransparency = 1
    SliderValue.TextColor3 = Colors.Text
    SliderValue.TextSize = 14
    SliderValue.Font = Enum.Font.SourceSans
    SliderValue.TextXAlignment = Enum.TextXAlignment.Right
    SliderValue.TextTransparency = 1
    SliderValue.Parent = SliderContainer
    
    local SliderThumb = Instance.new("Frame")
    SliderThumb.Name = "Thumb"
    SliderThumb.Size = UDim2.new(0, 12, 0, 12)
    SliderThumb.Position = UDim2.new(0, 0, 0.5, -6)
    SliderThumb.BackgroundColor3 = Colors.Text
    SliderThumb.BorderSizePixel = 0
    SliderThumb.ZIndex = 2
    SliderThumb.Parent = SliderFill
    
    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(1, 0)
    UICorner3.Parent = SliderThumb
    
    -- For clicking/dragging functionality
    local SliderClickArea = Instance.new("TextButton")
    SliderClickArea.Name = "ClickArea"
    SliderClickArea.Size = UDim2.new(1, 0, 3, 0)
    SliderClickArea.Position = UDim2.new(0, 0, -1, 0)
    SliderClickArea.BackgroundTransparency = 1
    SliderClickArea.Text = ""
    SliderClickArea.Parent = SliderBackground
    
    local Slider = {}
    Slider.Value = default
    Slider.Container = SliderContainer
    Slider.Background = SliderBackground
    Slider.Fill = SliderFill
    
    local function updateSlider(input)
        local posX = input.Position.X
        local absPos = SliderBackground.AbsolutePosition.X
        local absSize = SliderBackground.AbsoluteSize.X
        
        local relPos = math.clamp((posX - absPos) / absSize, 0, 1)
        local value = min + (max - min) * relPos
        
        if not precise then
            value = math.floor(value)
        else
            value = math.floor(value * 100) / 100
        end
        
        Slider.Value = value
        
        -- Update UI
        local displayValue = precise and string.format("%.2f", value) or tostring(value)
        SliderValue.Text = displayValue .. suffix
        
        local fillWidth = relPos * SliderBackground.AbsoluteSize.X
        createTween(SliderFill, {Size = UDim2.new(0, fillWidth, 1, 0)}, 0.2)
        createTween(SliderThumb, {Position = UDim2.new(0, fillWidth - 6, 0.5, -6)}, 0.2)
        
        callback(value)
    end
    
    -- Set initial value
    local initialRelPos = (default - min) / (max - min)
    local initialDisplayValue = precise and string.format("%.2f", default) or tostring(default)
    SliderValue.Text = initialDisplayValue .. suffix
    
    local initialFillWidth = initialRelPos * SliderBackground.AbsoluteSize.X
    SliderFill.Size = UDim2.new(initialRelPos, 0, 1, 0)
    SliderThumb.Position = UDim2.new(1, -6, 0.5, -6)
    
    -- Handle dragging
    local dragging = false
    SliderClickArea.MouseButton1Down:Connect(function(input)
        dragging = true
        updateSlider({Position = input})
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    -- Fade-in animation
    createTween(SliderLabel, {TextTransparency = 0}, 0.5)
    createTween(SliderValue, {TextTransparency = 0}, 0.5)
    
    -- Add to sliders table
    table.insert(self.Sliders, Slider)
    
    return Slider
end

-- Add dropdown function
function Library:AddDropdown(tab, name, options, callback)
    local options = options or {}
    local callback = callback or function() end
    
    local DropdownContainer = Instance.new("Frame")
    DropdownContainer.Name = name.."Dropdown"
    DropdownContainer.Size = UDim2.new(1, 0, 0, 60)
    DropdownContainer.BackgroundTransparency = 1
    DropdownContainer.Parent = tab.Page
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Name = "Label"
    DropdownLabel.Size = UDim2.new(1, -10, 0, 20)
    DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Text = name
    DropdownLabel.TextColor3 = Colors.Text
    DropdownLabel.TextSize = 14
    DropdownLabel.Font = Enum.Font.SourceSans
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.TextTransparency = 1
    DropdownLabel.Parent = DropdownContainer
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Name = "Button"
    DropdownButton.Size = UDim2.new(1, -20, 0, 30)
    DropdownButton.Position = UDim2.new(0, 10, 0, 25)
    DropdownButton.BackgroundColor3 = Colors.SliderBackground
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Text = options[1] or "Select"
    DropdownButton.TextColor3 = Colors.Text
    DropdownButton.TextSize = 14
    DropdownButton.Font = Enum.Font.SourceSans
    DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    DropdownButton.TextTruncate = Enum.TextTruncate.AtEnd
    DropdownButton.ClipsDescendants = true
    DropdownButton.ZIndex = 10
    DropdownButton.Parent = DropdownContainer
    
    local DropdownPadding = Instance.new("UIPadding")
    DropdownPadding.PaddingLeft = UDim.new(0, 10)
    DropdownPadding.Parent = DropdownButton
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = DropdownButton
    
    local DropdownArrow = Instance.new("TextLabel")
    DropdownArrow.Name = "Arrow"
    DropdownArrow.Size = UDim2.new(0, 20, 0, 20)
    DropdownArrow.Position = UDim2.new(1, -25, 0.5, -10)
    DropdownArrow.BackgroundTransparency = 1
    DropdownArrow.Text = "▼"
    DropdownArrow.TextColor3 = Colors.Text
    DropdownArrow.TextSize = 12
    DropdownArrow.Font = Enum.Font.SourceSans
    DropdownArrow.ZIndex = 11
    DropdownArrow.Parent = DropdownButton
    
    local DropdownMenu = Instance.new("Frame")
    DropdownMenu.Name = "Menu"
    DropdownMenu.Size = UDim2.new(1, 0, 0, #options * 25)
    DropdownMenu.Position = UDim2.new(0, 0, 1, 5)
    DropdownMenu.BackgroundColor3 = Colors.TabBackground
    DropdownMenu.BorderSizePixel = 0
    DropdownMenu.Visible = false
    DropdownMenu.ZIndex = 15
    DropdownMenu.Parent = DropdownButton
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 4)
    UICorner2.Parent = DropdownMenu
    
    local OptionLayout = Instance.new("UIListLayout")
    OptionLayout.FillDirection = Enum.FillDirection.Vertical
    OptionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    OptionLayout.Padding = UDim.new(0, 0)
    OptionLayout.Parent = DropdownMenu
    
    local Dropdown = {}
    Dropdown.Container = DropdownContainer
    Dropdown.Button = DropdownButton
    Dropdown.Menu = DropdownMenu
    Dropdown.Value = options[1] or ""
    Dropdown.Options = options
    
    -- Create option buttons
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Name = "Option_"..option
        OptionButton.Size = UDim2.new(1, 0, 0, 25)
        OptionButton.BackgroundTransparency = 1
        OptionButton.Text = option
        OptionButton.TextColor3 = Colors.Text
        OptionButton.TextSize = 14
        OptionButton.Font = Enum.Font.SourceSans
        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
        OptionButton.ZIndex = 16
        OptionButton.Parent = DropdownMenu
        
        local OptionPadding = Instance.new("UIPadding")
        OptionPadding.PaddingLeft = UDim.new(0, 10)
        OptionPadding.Parent = OptionButton
        
        OptionButton.MouseButton1Click:Connect(function()
            Dropdown.Value = option
            DropdownButton.Text = option
            DropdownMenu.Visible = false
            DropdownArrow.Text = "▼"
            callback(option)
        end)
        
        -- Hover effect
        OptionButton.MouseEnter:Connect(function()
            createTween(OptionButton, {BackgroundTransparency = 0.9}, 0.2)
        end)
        
        OptionButton.MouseLeave:Connect(function()
            createTween(OptionButton, {BackgroundTransparency = 1}, 0.2)
        end)
    end
    
    -- Toggle menu visibility
    DropdownButton.MouseButton1Click:Connect(function()
        DropdownMenu.Visible = not DropdownMenu.Visible
        DropdownArrow.Text = DropdownMenu.Visible and "▲" or "▼"
        createTween(DropdownMenu, {BackgroundTransparency = DropdownMenu.Visible and 0 or 1}, 0.3)
    end)
    
    -- Close menu when clicking elsewhere
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local buttonPos = DropdownButton.AbsolutePosition
            local buttonSize = DropdownButton.AbsoluteSize
            
            if mousePos.X < buttonPos.X or mousePos.X > buttonPos.X + buttonSize.X or
               mousePos.Y < buttonPos.Y or mousePos.Y > buttonPos.Y + buttonSize.Y + DropdownMenu.AbsoluteSize.Y then
                DropdownMenu.Visible = false
                DropdownArrow.Text = "▼"
            end
        end
    end)
    
    -- Fade-in animation
    createTween(DropdownLabel, {TextTransparency = 0}, 0.5)
    
    -- Add to dropdowns table
    table.insert(self.Dropdowns, Dropdown)
    
    return Dropdown
end

-- Notification function
function Library:Notify(title, text, duration, notificationType)
    local duration = duration or 5
    local notificationType = notificationType or "Info"
    
    local NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Name = "NotificationGui"
    NotificationGui.Parent = game.CoreGui
    
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Name = "NotificationFrame"
    NotificationFrame.Size = UDim2.new(0, 280, 0, 80)
    NotificationFrame.Position = UDim2.new(1, 20, 0, NOTIFICATION_OFFSET)
    NotificationFrame.BackgroundColor3 = Colors.NotificationBackground
    NotificationFrame.BorderColor3 = Colors.NotificationBorder
    NotificationFrame.BorderSizePixel = 1
    NotificationFrame.BackgroundTransparency = 1
    NotificationFrame.Parent = NotificationGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = NotificationFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -20, 0, 24)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextTransparency = 1
    TitleLabel.Parent = NotificationFrame
    
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Name = "Message"
    MessageLabel.Size = UDim2.new(1, -20, 1, -34)
    MessageLabel.Position = UDim2.new(0, 10, 0, 29)
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Text = text
    MessageLabel.TextColor3 = Colors.SubText
    MessageLabel.TextSize = 14
    MessageLabel.Font = Enum.Font.SourceSans
    MessageLabel.TextWrapped = true
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.TextYAlignment = Enum.TextYAlignment.Top
    MessageLabel.TextTransparency = 1
    MessageLabel.Parent = NotificationFrame
    
    -- Type icon
    local IconTypes = {
        Info = "ℹ️",
        Warning = "⚠️",
        Error = "❌",
        Success = "✅"
    }
    
    local TypeIcon = Instance.new("TextLabel")
    TypeIcon.Name = "TypeIcon"
    TypeIcon.Size = UDim2.new(0, 24, 0, 24)
    TypeIcon.Position = UDim2.new(1, -30, 0, 5)
    TypeIcon.BackgroundTransparency = 1
    TypeIcon.Text = IconTypes[notificationType] or IconTypes.Info
    TypeIcon.TextColor3 = Colors.Text
    TypeIcon.TextSize = 18
    TypeIcon.Font = Enum.Font.SourceSansBold
    TypeIcon.TextTransparency = 1
    TypeIcon.Parent = NotificationFrame
    
    -- Stack notifications
    table.insert(NotificationStack, NotificationFrame)
    
    local function updateNotificationPositions()
        for i, frame in ipairs(NotificationStack) do
            createTween(frame, {Position = UDim2.new(1, -300, 0, NOTIFICATION_OFFSET + (i - 1) * (80 + NOTIFICATION_SPACING))}, 0.3)
        end
    end
    
    -- Animation in
    createTween(NotificationFrame, {BackgroundTransparency = 0, Position = UDim2.new(1, -300, 0, NOTIFICATION_OFFSET)}, 0.5)
    createTween(TitleLabel, {TextTransparency = 0}, 0.5)
    createTween(MessageLabel, {TextTransparency = 0}, 0.5)
    createTween(TypeIcon, {TextTransparency = 0}, 0.5)
    updateNotificationPositions()
    
    -- Wait and animate out
    task.spawn(function()
        task.wait(duration)
        if NotificationFrame and NotificationFrame.Parent then
            createTween(NotificationFrame, {BackgroundTransparency = 1, Position = UDim2.new(1, 20, 0, NotificationFrame.Position.Y.Offset)}, 0.5)
            createTween(TitleLabel, {TextTransparency = 1}, 0.5)
            createTween(MessageLabel, {TextTransparency = 1}, 0.5)
            createTween(TypeIcon, {TextTransparency = 1}, 0.5).Completed:Connect(function()
                if NotificationGui and NotificationGui.Parent then
                    NotificationGui:Destroy()
                    table.remove(NotificationStack, table.find(NotificationStack, NotificationFrame))
                    updateNotificationPositions()
                end
            end)
        end
    end)
end

-- Return the library
return Library
