local StylishUI = {}
StylishUI.__index = StylishUI

function StylishUI:CreateLib(title, theme)
    local self = setmetatable({}, StylishUI)

    self.theme = theme or "Dark"
    self.title = title or "StylishUI"
    self.windows = {}

    self:init()
    return self
end

function StylishUI:init()
    self.container = Instance.new("ScreenGui")
    self.container.Name = "StylishUI"
    self.container.ResetOnSpawn = false
    self.container.ZIndexBehavior = Enum.ZIndexBehavior.Global

    self.frame = Instance.new("Frame")
    self.frame.Size = UDim2.new(0.5, 0, 0.8, 0)
    self.frame.Position = UDim2.new(0.25, 0, 0.1, 0)
    self.frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    self.frame.BorderSizePixel = 0
    self.frame.Parent = self.container

    self.topBar = Instance.new("Frame")
    self.topBar.Size = UDim2.new(1, 0, 0.1, 0)
    self.topBar.Position = UDim2.new(0, 0, 0, 0)
    self.topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.topBar.BorderSizePixel = 0
    self.topBar.Parent = self.frame

    self.titleLabel = Instance.new("TextLabel")
    self.titleLabel.Text = self.title
    self.titleLabel.Font = Enum.Font.SourceSansBold
    self.titleLabel.TextSize = 18
    self.titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.titleLabel.BackgroundTransparency = 1
    self.titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.titleLabel.Parent = self.topBar

    self.closeButton = Instance.new("TextButton")
    self.closeButton.Text = "X"
    self.closeButton.Font = Enum.Font.SourceSansBold
    self.closeButton.TextSize = 18
    self.closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.closeButton.BackgroundTransparency = 1
    self.closeButton.Size = UDim2.new(0.1, 0, 1, 0)
    self.closeButton.Position = UDim2.new(0.9, 0, 0, 0)
    self.closeButton.MouseButton1Click:Connect(function()
        self.container:Destroy()
    end)
    self.closeButton.Parent = self.topBar

    self.content = Instance.new("ScrollingFrame")
    self.content.Size = UDim2.new(1, 0, 0.9, 0)
    self.content.Position = UDim2.new(0, 0, 0.1, 0)
    self.content.BackgroundTransparency = 1
    self.content.BorderSizePixel = 0
    self.content.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.content.Parent = self.frame

    self.container.Parent = game.CoreGui
end

function StylishUI:CreateWindow(name)
    local window = {
        name = name,
        sections = {},
        parent = self
    }
    table.insert(self.windows, window)
    self:updateCanvas()

    return window
end

function StylishUI:updateCanvas()
    local totalHeight = 0
    for _, win in ipairs(self.windows) do
        for _, section in ipairs(win.sections) do
            totalHeight += section.height
        end
    end
    self.content.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 50)
end

function StylishUI:AddButton(window, text, callback)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.BorderSizePixel = 0
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Position = UDim2.new(0, 0, 0, 0)
    button.MouseButton1Click:Connect(callback)
    button.Parent = self.content

    return button
end

function StylishUI:AddToggle(window, text, callback)
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(1, 0, 0, 30)
    toggle.Position = UDim2.new(0, 0, 0, 0)
    toggle.BackgroundTransparency = 1
    toggle.Parent = self.content

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Parent = toggle

    local switch = Instance.new("TextButton")
    switch.Text = ""
    switch.Size = UDim2.new(0, 30, 1, 0)
    switch.Position = UDim2.new(1, -35, 0, 0)
    switch.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    switch.BorderSizePixel = 0
    switch.MouseButton1Click:Connect(function()
        local on = not switch.BackgroundColor3 == Color3.fromRGB(0, 255, 0)
        switch.BackgroundColor3 = on and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(40, 40, 40)
        callback(on)
    end)
    switch.Parent = toggle

    return toggle
end

function StylishUI:AddSlider(window, text, min, max, callback)
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 30)
    slider.Position = UDim2.new(0, 0, 0, 0)
    slider.BackgroundTransparency = 1
    slider.Parent = self.content

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Parent = slider

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 10)
    bar.Position = UDim2.new(0, 0, 0, 10)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    bar.BorderSizePixel = 0
    bar.Parent = slider

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local dragging = false
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    bar.InputChanged:Connect(function(input)
        if dragging then
            local normX = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(normX, 0, 1, 0)
            local value = math.floor(min + (max - min) * normX)
            callback(value)
        end
    end)

    return slider
end

function StylishUI:AddDropdown(window, text, options, callback)
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(1, 0, 0, 30)
    dropdown.Position = UDim2.new(0, 0, 0, 0)
    dropdown.BackgroundTransparency = 1
    dropdown.Parent = self.content

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Parent = dropdown

    local currentOption = Instance.new("TextLabel")
    currentOption.Text = options[1]
    currentOption.Font = Enum.Font.SourceSansBold
    currentOption.TextSize = 16
    currentOption.TextColor3 = Color3.fromRGB(255, 255, 255)
    currentOption.BackgroundTransparency = 1
    currentOption.Position = UDim2.new(0, 150, 0, 0)
    currentOption.Parent = dropdown

    local arrow = Instance.new("ImageLabel")
    arrow.Image = "rbxassetid://2841762979"
    arrow.Size = UDim2.new(0, 16, 0, 16)
    arrow.Position = UDim2.new(1, -20, 0, 7)
    arrow.BackgroundTransparency = 1
    arrow.Parent = dropdown

    local menu = Instance.new("Frame")
    menu.Size = UDim2.new(1, 0, 0, 0)
    menu.Position = UDim2.new(0, 0, 1, 0)
    menu.BackgroundTransparency = 1
    menu.BorderSizePixel = 0
    menu.Parent = dropdown

    for i, option in ipairs(options) do
        local item = Instance.new("TextButton")
        item.Text = option
        item.Font = Enum.Font.SourceSansBold
        item.TextSize = 16
        item.TextColor3 = Color3.fromRGB(255, 255, 255)
        item.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        item.BorderSizePixel = 0
        item.Size = UDim2.new(1, 0, 0, 30)
        item.Position = UDim2.new(0, 0, (i - 1) * 30, 0)
        item.MouseButton1Click:Connect(function()
            currentOption.Text = option
            menu:TweenSizeAndPosition(UDim2.new(1, 0, 0, 0), UDim2.new(0, 0, 1, 0), "Out", 0.2, true)
            callback(option)
        end)
        item.Parent = menu
    end

    dropdown.MouseButton1Click:Connect(function()
        if menu.Size.Y.Offset == 0 then
            menu:TweenSizeAndPosition(UDim2.new(1, 0, #options * 30, 0), UDim2.new(0, 0, 1, 0), "In", 0.2, true)
        else
            menu:TweenSizeAndPosition(UDim2.new(1, 0, 0, 0), UDim2.new(0, 0, 1, 0), "Out", 0.2, true)
        end
    end)

    return dropdown
end

function StylishUI:AddNotification(text)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0.3, 0, 0.1, 0)
    notification.Position = UDim2.new(0.35, 0, 0.45, 0)
    notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    notification.BorderSizePixel = 0
    notification.Parent = game.CoreGui

    local message = Instance.new("TextLabel")
    message.Text = text
    message.Font = Enum.Font.SourceSansBold
    message.TextSize = 16
    message.TextColor3 = Color3.fromRGB(255, 255, 255)
    message.BackgroundTransparency = 1
    message.Position = UDim2.new(0.1, 0, 0.2, 0)
    message.Parent = notification

    local closeButton = Instance.new("TextButton")
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextSize = 16
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundTransparency = 1
    closeButton.Size = UDim2.new(0.1, 0, 0.3, 0)
    closeButton.Position = UDim2.new(0.8, 0, 0.35, 0)
    closeButton.MouseButton1Click:Connect(function()
        notification:Destroy()
    end)
    closeButton.Parent = notification

    notification:TweenPosition(UDim2.new(0.35, 0, 0.45, 0), "Out", 0.5, 0, true)
end

-- Ejemplo de uso
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ELPAPIMC/StylishUI/refs/heads/main/SimpleUtilityLib"))()

local Main = Library:CreateLib("StylishUI", "Dark")

Library:AddButton(Main, "Haz clic aquí", function()
    print("Botón presionado")
end)

Library:AddToggle(Main, "Activar algo", function(state)
    print("Estado del toggle:", state)
end)

Library:AddSlider(Main, "Rango de 0 a 100", 0, 100, function(value)
    print("Valor del slider:", value)
end)

Library:AddDropdown(Main, "Selecciona algo", {"Opción 1", "Opción 2", "Opción 3"}, function(selected)
    print("Opción seleccionada:", selected)
end)

Library:AddNotification("¡Bienvenido a StylishUI!")
