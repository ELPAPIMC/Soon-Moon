-- Custom UI Library for Game Menus
local Library = {}
Library.Tabs = {}
Library.Toggles = {}
Library.Sliders = {}
Library.Dropdowns = {}
Library.ActiveNotifications = {} -- For tracking active notifications
Library.NotificationStackBasePixelY = 200 -- Base pixel position from top for notifications
Library.NotificationPadding = 10 -- Padding between stacked notifications

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
    
    -- Add initial scale animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame:TweenSizeAndPosition(
        UDim2.new(0, 700, 0, 400),
        UDim2.new(0.5, -350, 0.5, -200),
        "Out", "Quad", 0.5, true
    )
    
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
        -- Only drag if clicking on the MainFrame itself or TitleBar
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if input.Target == MainFrame or input.Target.Parent == MainFrame:FindFirstChild("TitleBar") then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
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
    
    -- Make TitleBar also draggable (redundant due to MainFrame check, but harmless)
    TitleBar.InputBegan:Connect(function(input)
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
        -- Add a fade/scale out animation
        MainFrame:TweenSizeAndPosition(
            UDim2.new(0, 0, 0, 0),
            UDim2.new(0.5, 0, 0.5, 0),
            "In", "Quad", 0.3, true,
            function()
                ScreenGui:Destroy()
            end
        )
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
    local originalColor = Colors.TabBackground
    local hoverColor = originalColor:lerp(Color3.new(1,1,1), 0.1) -- Slightly lighter on hover
    TabButton.BackgroundColor3 = originalColor
    TabButton.BorderSizePixel = 0
    TabButton.Text = ""
    TabButton.Parent = window.TabContainer
    
    -- Add hover animation
    TabButton.MouseEnter:Connect(function()
        if TabButton.BackgroundColor3 ~= Colors.Selected then
            TabButton:TweenBackgroundColor3(hoverColor, "Out", "Quad", 0.1, true)
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if TabButton.BackgroundColor3 ~= Colors.Selected then
            TabButton:TweenBackgroundColor3(originalColor, "Out", "Quad", 0.1, true)
        end
    end)
    
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
            tab.Button.BackgroundColor3 = originalColor -- Reset to original color
            tab.Page.Visible = false
        end
        
        TabButton.BackgroundColor3 = Colors.Selected -- Set to selected color
        ContentPage.Visible = true
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
function Library:AddLabel(tab, text, options)
    options = options or {}
    local textColor = options.TextColor or Colors.Text
    local textSize = options.TextSize or 14
    local font = options.Font or Enum.Font.SourceSans
    local wrap = options.TextWrapped or false
    
    local LabelFrame = Instance.new("Frame")
    LabelFrame.Name = "LabelFrame"
    LabelFrame.Size = UDim2.new(1, 0, 0, 20) -- Default height, can be adjusted by layout or text wrap
    LabelFrame.BackgroundTransparency = 1
    LabelFrame.Parent = tab.Page
    
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Label"
    TextLabel.Size = UDim2.new(1, -20, 1, 0)
    TextLabel.Position = UDim2.new(0, 10, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = text
    TextLabel.TextColor3 = textColor
    TextLabel.TextSize = textSize
    TextLabel.Font = font
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center
    TextLabel.TextWrapped = wrap
    TextLabel.Parent = LabelFrame
    
    -- Adjust frame size if text wraps
    if wrap then
        TextLabel.Changed:Connect(function(property)
            if property == "AbsoluteContentSize" then
                -- Add padding to the content size
                local newHeight = TextLabel.AbsoluteContentSize.Y + 10 -- Add some vertical padding
                LabelFrame.Size = UDim2.new(1, 0, 0, newHeight)
            end
        end)
        -- Initial size adjustment
        task.wait() -- Wait a frame for AbsoluteContentSize to update
        local newHeight = TextLabel.AbsoluteContentSize.Y + 10
        LabelFrame.Size = UDim2.new(1, 0, 0, newHeight)
    end
    
    return TextLabel
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
        
        if Toggle.Value then
            ToggleButton:TweenBackgroundColor3(Colors.ToggleOn, "Out", "Quad", 0.2, true)
            ToggleCircle:TweenPosition(UDim2.new(1, -18, 0.5, -8), "Out", "Quad", 0.2, true)
        else
            ToggleButton:TweenBackgroundColor3(Colors.ToggleOff, "Out", "Quad", 0.2, true)
            ToggleCircle:TweenPosition(UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.2, true)
        end
        
        callback(Toggle.Value)
    end
    
    ToggleClickArea.MouseButton1Click:Connect(updateToggle)
    
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
    SliderValue.Parent = SliderContainer
    
    local SliderThumb = Instance.new("Frame")
    SliderThumb.Name = "Thumb"
    SliderThumb.Size = UDim2.new(0, 12, 0, 12)
    -- Initial position is calculated based on default value
    local initialRelPos = (default - min) / (max - min)
    -- Position by scale, offset to center thumb
    SliderThumb.Position = UDim2.new(initialRelPos, -6, 0.5, -6)
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
    
    local function updateSliderUI(value)
        local relPos = (value - min) / (max - min)
        local displayValue = precise and string.format("%.2f", value) or tostring(math.floor(value))
        SliderValue.Text = displayValue .. suffix
        
        SliderFill.Size = UDim2.new(relPos, 0, 1, 0)
        -- Position thumb relative to the background using scale, offset to center
        SliderThumb.Position = UDim2.new(relPos, -6, 0.5, -6)
    end
    
    local function updateSliderValue(input)
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
        updateSliderUI(value)
        callback(value)
    end
    
    -- Set initial value and UI
    updateSliderUI(default)
    
    -- Handle dragging
    local dragging = false
    SliderClickArea.MouseButton1Down:Connect(function(input)
        dragging = true
        updateSliderValue({Position = input.Position}) -- Pass the mouse position
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSliderValue(input)
        end
    end)
    
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
    -- DropdownButton.ClipsDescendants = true -- Remove this to prevent clipping the menu
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
    DropdownArrow.Parent = DropdownButton
    
    local DropdownMenu = Instance.new("Frame")
    DropdownMenu.Name = "Menu"
    -- Size will be adjusted dynamically based on options
    DropdownMenu.Size = UDim2.new(1, 0, 0, 0)
    -- Position will be set dynamically
    DropdownMenu.BackgroundColor3 = Colors.TabBackground
    DropdownMenu.BorderSizePixel = 0
    DropdownMenu.Visible = false
    DropdownMenu.ZIndex = 10 -- Ensure it's above the main window
    -- DropdownMenu.Parent = DropdownButton -- Change parent
    -- Parent to the ScreenGui to avoid clipping issues
    DropdownMenu.Parent = game.CoreGui:FindFirstChild(window.ScreenGui.Name) or game.CoreGui
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 4)
    UICorner2.Parent = DropdownMenu
    
    local OptionLayout = Instance.new("UIListLayout")
    OptionLayout.FillDirection = Enum.FillDirection.Vertical
    OptionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    OptionLayout.Padding = UDim.new(0, 0)
    OptionLayout.Parent = DropdownMenu
    
    -- Adjust menu size based on content
    OptionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        DropdownMenu.Size = UDim2.new(1, 0, 0, OptionLayout.AbsoluteContentSize.Y)
    end)
    
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
        local originalOptionColor = Colors.TabBackground -- Use tab background for option hover base
        local hoverOptionColor = originalOptionColor:lerp(Color3.new(1,1,1), 0.1)
        OptionButton.BackgroundColor3 = originalOptionColor -- Start transparent, tween on hover
        OptionButton.BackgroundTransparency = 1
        OptionButton.Text = option
        OptionButton.TextColor3 = Colors.Text
        OptionButton.TextSize = 14
        OptionButton.Font = Enum.Font.SourceSans
        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
        OptionButton.ZIndex = 6
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
            OptionButton:TweenBackgroundColor3(hoverOptionColor, "Out", "Quad", 0.1, true)
            OptionButton.BackgroundTransparency = 0.9 -- Ensure transparency is low enough to see color
        end)
        
        OptionButton.MouseLeave:Connect(function()
            OptionButton:TweenBackgroundColor3(originalOptionColor, "Out", "Quad", 0.2, true)
            task.wait(0.2) -- Wait for tween
            if OptionButton.BackgroundColor3 == originalOptionColor then -- Only set transparent if not currently tweening to hover
                OptionButton.BackgroundTransparency = 1
            end
        end)
    end
    
    -- Toggle menu visibility
    DropdownButton.MouseButton1Click:Connect(function()
        if not DropdownMenu.Visible then -- Opening the menu
            -- Calculate absolute position of the button's bottom-left corner + padding
            local buttonAbsBottomLeft = DropdownButton.AbsolutePosition + Vector2.new(0, DropdownButton.AbsoluteSize.Y + 5)
            
            -- Calculate the desired pixel width of the dropdown menu (same as the button)
            local menuTargetWidth = DropdownButton.AbsoluteSize.X
            
            -- Set the position and pixel size relative to ScreenGui (ScreenGui AbsolutePosition is usually 0,0)
            DropdownMenu.Position = UDim2.new(0, buttonAbsBottomLeft.X, 0, buttonAbsBottomLeft.Y)
            -- Set the pixel width and calculate pixel height based on number of options
            DropdownMenu.Size = UDim2.new(0, menuTargetWidth, 0, #options * 25)
            
            -- Make visible
            DropdownMenu.Visible = true
            DropdownArrow.Text = "▲"
        else -- Closing the menu
            DropdownMenu.Visible = false
            DropdownArrow.Text = "▼"
        end
    end)
    
    -- Close menu when clicking elsewhere
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and DropdownMenu.Visible then
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local menuAbsPos = DropdownMenu.AbsolutePosition
            local menuAbsSize = DropdownMenu.AbsoluteSize
            local buttonAbsPos = DropdownButton.AbsolutePosition
            local buttonAbsSize = DropdownButton.AbsoluteSize
            
            -- Check if click is outside the menu AND outside the button
            local clickedOutsideMenu = mousePos.X < menuAbsPos.X or mousePos.X > menuAbsPos.X + menuAbsSize.X or
                                       mousePos.Y < menuAbsPos.Y or mousePos.Y > menuAbsPos.Y + menuAbsSize.Y
            
            local clickedOnButton = mousePos.X >= buttonAbsPos.X and mousePos.X <= buttonAbsPos.X + buttonAbsSize.X and
                                    mousePos.Y >= buttonAbsPos.Y and mousePos.Y <= buttonAbsPos.Y + buttonAbsSize.Y
            
            if clickedOutsideMenu and not clickedOnButton then
                DropdownMenu.Visible = false
                DropdownArrow.Text = "▼"
            end
        end
    end)
    
    -- Add to dropdowns table
    table.insert(self.Dropdowns, Dropdown)
    
    return Dropdown
end

-- Notification function
function Library:Notify(title, text, duration, notificationType)
    local duration = duration or 5
    local notificationType = notificationType or "Info"
    
    local NotificationContainer = game.CoreGui:FindFirstChild("NotificationContainer")
    if not NotificationContainer then
        NotificationContainer = Instance.new("Frame")
        NotificationContainer.Name = "NotificationContainer"
        NotificationContainer.Size = UDim2.new(0, 300, 1, 0) -- Fixed width, full height
        NotificationContainer.Position = UDim2.new(1, -310, 0, 0) -- Position on the right side
        NotificationContainer.BackgroundTransparency = 1
        NotificationContainer.BorderSizePixel = 0
        NotificationContainer.ClipsDescendants = true -- Clip notifications outside the container
        NotificationContainer.Parent = game.CoreGui
        
        -- Add a UIListLayout to manage stacking
        local NotificationLayout = Instance.new("UIListLayout")
        NotificationLayout.Name = "NotificationLayout"
        NotificationLayout.FillDirection = Enum.FillDirection.Vertical
        NotificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
        NotificationLayout.Padding = UDim.new(0, Library.NotificationPadding)
        NotificationLayout.Parent = NotificationContainer
        
        -- Add padding to the container's top to make notifications appear lower
        local ContainerPadding = Instance.new("UIPadding")
        ContainerPadding.Name = "ContainerPadding"
        -- Calculate the top padding based on the desired starting pixel height
        -- We want the FIRST notification to start at Library.NotificationStackBasePixelY from the top of the ScreenGui
        -- The container's position is UDim2.new(1, -310, 0, 0) meaning its top is at Y=0.
        -- So the top padding should be Library.NotificationStackBasePixelY.
        ContainerPadding.PaddingTop = UDim.new(0, Library.NotificationStackBasePixelY)
        ContainerPadding.PaddingRight = UDim.new(0, 10) -- Padding from the right edge inside the container
        ContainerPadding.Parent = NotificationContainer
    end
    
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Name = "NotificationFrame"
    NotificationFrame.Size = UDim2.new(1, -10, 0, 80) -- Adjust size to fit container width minus padding
    NotificationFrame.BackgroundColor3 = Colors.NotificationBackground
    NotificationFrame.BorderColor3 = Colors.NotificationBorder
    NotificationFrame.BorderSizePixel = 1
    NotificationFrame.Parent = NotificationContainer -- Parent to the container
    
    -- Ensure ZIndex is above the main window
    NotificationFrame.ZIndex = 10
    
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
    MessageLabel.Parent = NotificationFrame
    
    -- Type icon (can customize based on notification type)
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
    TypeIcon.Parent = NotificationFrame
    
    -- Add notification to the tracking list and assign layout order
    table.insert(Library.ActiveNotifications, NotificationFrame)
    NotificationFrame.LayoutOrder = #Library.ActiveNotifications
    
    -- Animate in
    -- Set initial position off-screen right relative to the container
    -- The UIListLayout will handle the correct vertical position.
    local initialXOffset = NotificationContainer.AbsoluteSize.X -- Start right outside the container
    NotificationFrame.Position = UDim2.new(0, initialXOffset, NotificationFrame.Position.Y.Scale, NotificationFrame.Position.Y.Offset)
    
    -- Tween to its position managed by the UIListLayout (which has 0 scale X offset)
    -- We need to wait for the layout to apply the initial position before tweening
    task.wait() -- Wait a frame for layout to apply
    
    NotificationFrame:TweenPosition(
        UDim2.new(0, 0, NotificationFrame.Position.Y.Scale, NotificationFrame.Position.Y.Offset),
        "Out", "Quad", 0.5, true
    )
    
    -- Wait and animate out
    task.spawn(function()
        task.wait(duration)
        if NotificationFrame and NotificationFrame.Parent then
            -- Animate out to the right
            local endXOut = NotificationContainer.AbsoluteSize.X -- Tween back outside the container
            NotificationFrame:TweenPosition(
                UDim2.new(0, endXOut, NotificationFrame.Position.Y.Scale, NotificationFrame.Position.Y.Offset),
                "In", "Quad", 0.5, true,
                function()
                    -- Remove from tracking list and destroy
                    local index = table.find(Library.ActiveNotifications, NotificationFrame)
                    if index then
                        table.remove(Library.ActiveNotifications, index)
                        -- Update LayoutOrder for remaining notifications
                        for i, frame in ipairs(Library.ActiveNotifications) do
                            frame.LayoutOrder = i
                        end
                    end
                    NotificationFrame:Destroy()
                    
                    -- If no notifications left, destroy the container
                    if #Library.ActiveNotifications == 0 and NotificationContainer and NotificationContainer.Parent then
                        NotificationContainer:Destroy()
                    end
                end
            )
        else
            -- If already destroyed, remove from list just in case
            local index = table.find(Library.ActiveNotifications, NotificationFrame)
            if index then
                table.remove(Library.ActiveNotifications, index)
                -- Update LayoutOrder for remaining notifications
                for i, frame in ipairs(Library.ActiveNotifications) do
                    frame.LayoutOrder = i
                end
            end
            if #Library.ActiveNotifications == 0 and NotificationContainer and NotificationContainer.Parent then
                NotificationContainer:Destroy()
            end
        end
    end)
    
    return NotificationFrame
end

-- Return the library
return Library
