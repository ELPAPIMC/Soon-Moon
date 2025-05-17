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

-- // Sistema de Ranks (Protegido) // --
local Ranks = {
    OWNER = {
        Color = Color3.fromRGB(255, 0, 0),
        ID = {8161021661} -- ID del verdadero owner
    },
    ADMIN = {
        Color = Color3.fromRGB(255, 80, 80),
        ID = {987654321, 123123123}
    },
    MOD = {
        Color = Color3.fromRGB(0, 255, 127),
        ID = {456456456}
    },
    VIP = {
        Color = Color3.fromRGB(255, 215, 0),
        ID = {789789789}
    },
    USER = {
        Color = Color3.fromRGB(180, 180, 180),
        ID = {}
    }
}

-- // Sistema de Manejo de Errores // --
local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("Error in library: " .. tostring(result))
        UILibrary:Notify("Error", "An error occurred: " .. tostring(result), "error", 5)
    end
    return success, result
end

-- // Sistema de Notificaciones // --
local NotificationSystem = {}

function NotificationSystem:Notify(title, message, icon, duration, notifType)
    duration = duration or 3
    notifType = notifType or "info"

    local notifColors = {
        success = config.NotificationSuccess,
        error = config.NotificationError,
        info = config.NotificationInfo,
        warning = config.NotificationWarning
    }

    local notifColor = notifColors[notifType] or config.NotificationInfo

    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "Notification"
    NotifGui.ResetOnSpawn = false
    NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    SafeCall(function()
        NotifGui.Parent = game.CoreGui
    end)

    if NotifGui.Parent == nil then
        NotifGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "NotificationFrame"
    NotifFrame.Size = UDim2.new(0, 280, 0, 80)
    NotifFrame.Position = UDim2.new(1, 300, 0.9, -85)
    NotifFrame.BackgroundColor3 = config.NotificationBG
    NotifFrame.BorderSizePixel = 0
    NotifFrame.AnchorPoint = Vector2.new(1, 1)
    NotifFrame.Parent = NotifGui

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = NotifFrame

    local ColorBar = Instance.new("Frame")
    ColorBar.Name = "ColorBar"
    ColorBar.Size = UDim2.new(0, 4, 1, 0)
    ColorBar.BackgroundColor3 = notifColor
    ColorBar.BorderSizePixel = 0
    ColorBar.Parent = NotifFrame

    local ColorBarCorner = Instance.new("UICorner")
    ColorBarCorner.CornerRadius = UDim.new(0, 8)
    ColorBarCorner.Parent = ColorBar

    local ColorBarFix = Instance.new("Frame")
    ColorBarFix.Name = "Fix"
    ColorBarFix.Size = UDim2.new(0.5, 0, 1, 0)
    ColorBarFix.Position = UDim2.new(0.5, 0, 0, 0)
    ColorBarFix.BackgroundColor3 = notifColor
    ColorBarFix.BorderSizePixel = 0
    ColorBarFix.Parent = ColorBar

    local NotifIcon = Instance.new("ImageLabel")
    NotifIcon.Name = "Icon"
    NotifIcon.Size = UDim2.new(0, 30, 0, 30)
    NotifIcon.Position = UDim2.new(0, 15, 0, 25)
    NotifIcon.BackgroundTransparency = 1

    if not icon or icon == "" then
        if notifType == "success" then
            NotifIcon.Image = "rbxassetid://6031094667"
        elseif notifType == "error" then
            NotifIcon.Image = "rbxassetid://6031094678"
        elseif notifType == "warning" then
            NotifIcon.Image = "rbxassetid://6031071057"
        else
            NotifIcon.Image = "rbxassetid://6031068420"
        end
    else
        NotifIcon.Image = icon
    end

    NotifIcon.ImageColor3 = notifColor
    NotifIcon.Parent = NotifFrame

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

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Name = "ProgressBar"
    ProgressBar.Size = UDim2.new(1, 0, 0, 3)
    ProgressBar.Position = UDim2.new(0, 0, 1, -3)
    ProgressBar.BackgroundColor3 = notifColor
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = NotifFrame

    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(0, 8)
    ProgressCorner.Parent = ProgressBar

    NotifFrame:TweenPosition(UDim2.new(1, -20, 0.9, -85), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)

    TweenService:Create(ProgressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 3)}):Play()

    task.delay(duration, function()
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

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = GuiName
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    SafeCall(function()
        ScreenGui.Parent = game.CoreGui
    end)

    if ScreenGui.Parent == nil then
        ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.BackgroundColor3 = config.MainColor
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui

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

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = config.CornerRadius
    Corner.Parent = MainFrame

    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = config.AccentColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = config.CornerRadius
    TitleCorner.Parent = TitleBar

    local FixTitleBar = Instance.new("Frame")
    FixTitleBar.Name = "FixTitleBar"
    FixTitleBar.Size = UDim2.new(1, 0, 0, 10)
    FixTitleBar.Position = UDim2.new(0, 0, 1, -10)
    FixTitleBar.BackgroundColor3 = config.AccentColor
    FixTitleBar.BorderSizePixel = 0
    FixTitleBar.ZIndex = 0
    FixTitleBar.Parent = TitleBar

    local TitleIcon = Instance.new("ImageLabel")
    TitleIcon.Name = "Icon"
    TitleIcon.Size = UDim2.new(0, 25, 0, 25)
    TitleIcon.Position = UDim2.new(0, 10, 0, 7)
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Image = "rbxassetid://6031094678"
    TitleIcon.ImageColor3 = config.TextColor
    TitleIcon.Parent = TitleBar

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

    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    Minimize    MinimizeCorner parent = MinimizeButton

    local CloseButton = Instance#Button
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.position = UDim2.new(1, -35, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, みたい
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = config.TextColor
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        closeTween:Play()
        closeTween.Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end)

    local Minimized = false
    local OriginalSize = MainFrame.Size

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
        end)
    end)

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -20, 1, -60)
    ContentFrame.Position = UDim2.new(0, 10, 0, 50)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ClipsDescendants = true
    ContentFrame.Parent = MainFrame

    local TabsFrame = Instance.new("Frame")
    TabsFrame.Name = "TabsFrame"
    TabsFrame.Size = UDim2.new(0, 150, 1, 0)
    TabsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabsFrame.BorderSizePixel = 0
    TabsFrame.Parent = ContentFrame

    local TabsCorner = Instance.new("UICorner")
    TabsCorner.CornerRadius = config.CornerRadius
    TabsCorner.Parent = TabsFrame

    local TabsList = Instance.new("ScrollingFrame")
    TabsList.Name = "TabsList"
    TabsList.Size = UDim2.new(1, -10, 1, -120)
    TabsList.Position = UDim2.new(0, 5, 0, 5)
    TabsList.BackgroundTransparency = 1
    TabsList.BorderSizePixel = 0
    TabsList.ScrollBarThickness = 2
    TabsList.ScrollingDirection = Enum.ScrollingDirection.Y
    TabsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabsList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabsList.Parent = TabsFrame

    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.Padding = UDim.new(0, 5)
    TabsLayout.Parent = TabsList

    local UserProfileFrame = Instance.new("Frame")
    UserProfileFrame.Name = "UserProfile"
    UserProfileFrame.Size = UDim2.new(1, -10, 0, 100)
    UserProfileFrame.Position = UDim2.new(0, 5, 1, -110)
    UserProfileFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    UserProfileFrame.BorderSizePixel = 0
    UserProfileFrame.Parent = TabsFrame

    local ProfileCorner = Instance.new("UICorner")
    ProfileCorner.CornerRadius = config.CornerRadius
    ProfileCorner.Parent = UserProfileFrame

    local Avatar = Instance.new("ImageLabel")
    Avatar.Name = "Avatar"
    Avatar.Size = UDim2.new(0, 60, 0, 60)
    Avatar.Position = UDim2.new(0.5, -30, 0, 10)
    Avatar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Avatar.BorderSizePixel = 0

    local player = Players.LocalPlayer
    local userId = player and player.UserId
    if userId then
        Avatar.Image = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end
    Avatar.Parent = UserProfileFrame

    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = Avatar

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

    local userRank = "USER"
    local userRankColor = Ranks.USER.Color

    if userId then
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

    local TabContent = Instance.new("Frame")
    TabContent.Name = "TabContent"
    TabContent.Size = UDim2.new(1, -160, 1, 0)
    TabContent.Position = UDim2.new(0, 160, 0, 0)
    TabContent.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabContent.BorderSizePixel = 0
    TabContent.Parent = ContentFrame

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = config.CornerRadius
    ContentCorner.Parent = TabContent

    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingLeft = UDim.new(0, 10)
    ContentPadding.PaddingRight = UDim.new(0, 10)
    ContentPadding.PaddingTop = UDim.new(0, 10)
    ContentPadding.PaddingBottom = UDim.new(0, 10)
    ContentPadding.Parent = TabContent

    local Tabs = {}
    local CurrentTab = nil

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

    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    local openTween = TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 400)})
    openTween:Play()

    function UILibrary:AddTab(tabName, iconId, locked, requiredRank)
        locked = locked or false
        requiredRank = requiredRank or "USER"

        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabsList

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = TabButton

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.Size = UDim2.new(0, 24, 0, 24)
        TabIcon.Position = UDim2.new(0, 8, 0.5, -12)
        TabIcon.BackgroundTransparency = 1
        TabIcon.ImageTransparency = 0.1
        if iconId and iconId ~= "" then
            TabIcon.Image = iconId
        else
            TabIcon.Image = "rbxassetid://3926305904"
            TabIcon.ImageRectOffset = Vector2.new(964, 204)
            TabIcon.ImageRectSize = Vector2.new(36, 36)
        end
        TabIcon.Parent = TabButton

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

        local LockIcon = Instance.new("ImageLabel")
        LockIcon.Name = "LockIcon"
        LockIcon.Size = UDim2.new(0, 16, 0, 16)
        LockIcon.Position = UDim2.new(1, -20, 0.5, -8)
        LockIcon.BackgroundTransparency = 1
        LockIcon.Image = "rbxassetid://3926307971"
        LockIcon.ImageRectOffset = Vector2.new(4, 836)
        LockIcon.ImageRectSize = Vector2.new(36, 36)
        LockIcon.Visible = locked and userRank ~= requiredRank
        LockIcon.Parent = TabButton

        local SelectIndicator = Instance.new("Frame")
        SelectIndicator.Name = "SelectIndicator"
        SelectIndicator.Size = UDim2.new(0, 4, 0.7, 0)
        SelectIndicator.Position = UDim2.new(0, 0, 0.15, 0)
        SelectIndicator.BackgroundColor3 = config.AccentColor
        SelectIndicator.BorderSizePixel = 0
        SelectIndicator.Visible = false
        SelectIndicator.Parent = TabButton

        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(0, 2)
        IndicatorCorner.Parent = SelectIndicator

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

        local ItemsLayout = Instance.new("UIListLayout")
        ItemsLayout.Padding = UDim.new(0, 8)
        ItemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ItemsLayout.Parent = TabContainer

        local Tab = {
            Button = TabButton,
            Container = TabContainer,
            Indicator = SelectIndicator
        }

        TabButton.MouseButton1Click:Connect(function()
            if locked and userRank ~= requiredRank then
                UILibrary:Notify("Access Denied", "You need " .. requiredRank .. " rank to access this tab!", "error", 3)
                return
            end

            if CurrentTab and CurrentTab ~= Tab then
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

            Tab.Container.Transparency = 1
            Tab.Container.Position = UDim2.new(-0.1, 0, 0, 0)
            Tab.Container.Visible = true

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

        if not CurrentTab then
            Tab.Indicator.Size = UDim2.new(0, 0, 0.7, 0)
            Tab.Indicator.Visible = true
            Tab.Container.Visible = true

            TweenService:Create(Tab.Indicator, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 4, 0.7, 0)
            }):Play()

            TweenService:Create(Tab.Button, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            }):Play()

            CurrentTab = Tab
        end

        local TabElements = {}

        function TabElements:AddLabel(text, locked, requiredRank)
            locked = locked or false
            requiredRank = requiredRank or "USER"

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

            local LockIcon = Instance.new("ImageLabel")
            LockIcon.Name = "LockIcon"
            LockIcon.Size = UDim2.new(0, 16, 0, 16)
            LockIcon.Position = UDim2.new(1, -20, 0.5, -8)
            LockIcon.BackgroundTransparency = 1
            LockIcon.Image = "rbxassetid://3926307971"
            LockIcon.ImageRectOffset = Vector2.new(4, 836)
            LockIcon.ImageRectSize = Vector2.new(36, 36)
            LockIcon.Visible = locked and userRank ~= requiredRank
            LockIcon.Parent = Label

            local Line = Instance.new("Frame")
            Line.Name = "Line"
            Line.Size = UDim2.new(1, 0, 0, 1)
            Line.Position = UDim2.new(0, 0, 1, -1)
            Line.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Line.BorderSizePixel = 0
            Line.Parent = Label

            Label.BackgroundTransparency = 1
            Line.Size = UDim2.new(0, 0, 0, 1)

            TweenService:Create(Line, TweenInfo.new(0.5), {
                Size = UDim2.new(1, 0, 0, 1)
            }):Play()

            function Label:UpdateText(newText)
                if locked and userRank ~= requiredRank then
                    UILibrary:Notify("Access Denied", "You need " .. requiredRank .. " rank to modify this!", "error", 3)
                    return
                end
                LabelText.Text = newText
            end

            return Label
        end

        function TabElements:AddButton(text, callback, locked, requiredRank)
            callback = callback or function() end
            locked = locked or false
            requiredRank = requiredRank or "USER"

            local Button = Instance.new("Frame")
            Button.Name = "Button_" .. text
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Button.BorderSizePixel = 0
            Button.Parent = TabContainer

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button

            local LockIcon = Instance.new("ImageLabel")
            LockIcon.Name = "LockIcon"
            LockIcon.Size = UDim2.new(0, 16, 0, 16)
            LockIcon.Position = UDim2.new(1, -20, 0.5, -8)
            LockIcon.BackgroundTransparency = 1
            LockIcon.Image = "rbxassetid://3926307971"
            LockIcon.ImageRectOffset = Vector2.new(4, 836)
            LockIcon.ImageRectSize = Vector2.new(36, 36)
            LockIcon.Visible = locked and userRank ~= requiredRank
            LockIcon.Parent = Button

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

            ButtonBtn.MouseButton1Down:Connect(function(x, y)
                if locked and userRank ~= requiredRank then
                    UILibrary:Notify("Access Denied", "You need " .. requiredRank .. " rank to use this!", "error", 3)
                    return
                end
                createRipple(x - Button.AbsolutePosition.X, y - Button.AbsolutePosition.Y)
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    BackgroundColor3 = config.AccentColor
                }):Play()
            end)

            ButtonBtn.MouseButton1Up:Connect(function()
                if locked and userRank ~= requiredRank then return end
                TweenService:Create(Button, TweenInfo.new(0.1), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                }):Play()
            end)

            ButtonBtn.MouseButton1Click:Connect(function()
                if locked and userRank ~= requiredRank then return end
                SafeCall(callback)
            end)

            ButtonBtn.MouseEnter:Connect(function()
                if locked and userRank ~= requiredRank then return end
                TweenService:Create(Button, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                }):Play()

                TweenService:Create(ButtonStroke, TweenInfo.new(0.3), {
                    Color = config.AccentColor
                }):Play()
            end)

            ButtonBtn.MouseLeave:Connect(function()
                if locked and userRank ~= requiredRank then return end
                TweenService:Create(Button, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                }):Play()

                TweenService:Create(ButtonStroke, TweenInfo.new(0.3), {
                    Color = Color3.fromRGB(60, 60, 60)
                }):Play()
            end)

            function Button:UpdateText(newText)
                if locked and userRank ~= requiredRank then
                    UILibrary:Notify("Access Denied", "You need " .. requiredRank .. " rank to modify this!", "error", 3)
                    return
                end
                ButtonBtn.Text = newText
            end

            return Button
        end

        function TabElements:AddToggle(text, default, callback, locked, requiredRank)
            default = default or false
            callback = callback or function() end
            locked = locked or false
            requiredRank = requiredRank or "USER"

            local Toggle = Instance.new("Frame")
            Toggle.Name = "Toggle_" .. text
            Toggle.Size = UDim2.new(1, 0, 0, 40)
            Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Toggle.BorderSizePixel = 0
            Toggle.Parent = TabContainer

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = Toggle

            local LockIcon = Instance.new("ImageLabel")
            LockIcon.Name = "LockIcon"
            LockIcon.Size = UDim2.new(0, 16, 0, 16)
            LockIcon.Position = UDim2.new(1, -20, 0.5, -8)
            LockIcon.BackgroundTransparency = 1
            LockIcon.Image = "rbxassetid://3926307971"
            LockIcon.ImageRectOffset = Vector2.new(4, 836)
            LockIcon.ImageRectSize = Vector2.new(36, 36)
            LockIcon.Visible = locked and userRank ~= requiredRank
            LockIcon.Parent = Toggle

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

            local Switch = Instance.new("Frame")
            Switch.Name = "Switch"
            Switch.Size = UDim2.new(0, 40, 0, 20)
            Switch.Position = UDim2.new(1, -50, 0.5, -10)
            Switch.BackgroundColor3 = default and config.ToggleOnColor or config.ToggleOffColor
            Switch.BorderSizePixel = 0
            Switch.Parent = Toggle

            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = Switch

            local Circle = Instance.new("Frame")
            Circle.Name = "Circle"
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Position = UDim2.new(default and 1 or 0, default and -18 or 2, 0.5, -8)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.BorderSizePixel = 0
            Circle.Parent = Switch

            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = Circle

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Size = UDim2.new(1, 0, 1, 0)
            ToggleButton.BackgroundTransparency = 1
            ToggleButton.Text = ""
            ToggleButton.Parent = Toggle

            local Toggled = default

            local function UpdateToggle()
                TweenService:Create(Switch, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                    BackgroundColor3 = Toggled and config.ToggleOnColor or config.ToggleOffColor
                }):Play()

                TweenService:Create(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = UDim2.new(Toggled and 1 or 0, Toggled and -18 or 2, 0.5, -8)
                }):Play()
            end

            ToggleButton.MouseButton1Click:Connect(function()
                if locked and userRank ~= requiredRank then
                    UILibrary:Notify("Access Denied", "You need " .. requiredRank .. " rank to use this!", "error", 3)
                    return
                end
                Toggled = not Toggled
                UpdateToggle()
                SafeCall(callback, Toggled)
            end)

            ToggleButton.MouseEnter:Connect(function()
                if locked and userRank ~= requiredRank then return end
                TweenService:Create(Toggle, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                }):Play()
            end)

            ToggleButton.MouseLeave:Connect(function()
                if locked and userRank ~= requiredRank then return end
                TweenService:Create(Toggle, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                }):Play()
            end)

            function Toggle:UpdateState(state)
                if locked and userRank ~= requiredRank then
                    UILibrary:Notify("Access Denied", "You need " .. requiredRank .. " rank to modify this!", "error", 3)
                    return
                end
                Toggled = state
                UpdateToggle()
            end

            function Toggle:GetState()
                return Toggled
            end

            return Toggle
        end

        function TabElements:AddSlider(text, min, max, default, callback, locked, requiredRank)
            min = min or 0
            max = max or 100
            default = default or min
            callback = callback or function() end
            locked = locked or false
            requiredRank = requiredRank or "USER"

            local Slider = Instance.new("Frame")
            Slider.Name = "Slider_" .. text
            Slider.Size = UDim2.new(1, 0, 0, 60)
            Slider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Slider.BorderSizePixel = 0
            Slider.Parent = TabContainer

            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = Slider

            local LockIcon = Instance.new("ImageLabel")
            LockIcon.Name = "LockIcon"
            LockIcon.Size = UDim2.new(0, 16, 0, 16)
            LockIcon.Position = UDim2.new(1, -20, 0.5, -8)
            LockIcon.BackgroundTransparency = 1
            LockIcon.Image = "rbxassetid://3926307971"
            LockIcon.ImageRectOffset = Vector2.new(4, 836)
            LockIcon.ImageRectSize = Vector2.new(36, 36)
            LockIcon.Visible = locked and userRank ~= requiredRank
            LockIcon.Parent = Slider

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

            local SliderBack = Instance.new("Frame")
            SliderBack.Name = "SliderBack"
            SliderBack.Size = UDim2.new(1, -20, 0, 8)
            SliderBack.Position = UDim2.new(0, 10, 0, 35)
            SliderBack.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            SliderBack.BorderSizePixel = 0
            SliderBack.Parent = Slider

            local SliderBackCorner = Instance.new("UICorner")
            SliderBackCorner.CornerRadius = UDim.new(1, 0)
            SliderBackCorner.Parent = SliderBack

            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = config.SliderColor
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBack

            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill

            local SliderCircle = Instance.new("Frame")
            SliderCircle.Name = "SliderCircle"
            SliderCircle.Size = UDim2.new(0, 16, 0, 16)
            SliderCircle.Position = UDim2.new((default - min)/(max - min), -8, 0.5, -8)
            SliderCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderCircle.BorderSizePixel = 0
            SliderCircle.ZIndex = 2
            SliderCircle.Parent = SliderBack

            local SliderCircleCorner = Instance.new("UICorner")
            SliderCircleCorner.CornerRadius = UDim.new(1, 0)
            SliderCircleCorner.Parent = SliderCircle

            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "SliderButton"
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Text = ""
            SliderButton.Parent = Slider

            local Dragging = false
            local Value = default

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
                SafeCall(callback, value)
            end

            SliderButton.MouseButton1Down:Connect(function(input)
                if locked and userRank ~= requiredRank then
                    UILibrary:Notify("Access Denied", "You need " .. requiredRank .. " rank to use this!", "error", 3)
                    return
                end
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

            SliderButton.MouseEnter:Connect(function()
                if locked and userRank ~= requiredRank then return end
                TweenService:Create(Slider, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                }):Play()

                TweenService:Create(SliderCircle, TweenInfo.new(0.3), {
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new(SliderCircle.Position.X.Scale, -9, 0.5, -9)
                }):Play()
            end)

            SliderButton.MouseLeave:Connect(function()
                if locked and userRank ~= requiredRank then return end
                TweenService:Create(Slider, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                }):Play()

                TweenService:Create(SliderCircle, TweenInfo.new(0.3), {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(SliderCircle.Position.X.Scale, -8, 0.5, -8)
                }):Play()
            end)

            function Slider:SetValue(value)
                if locked and userRank ~= requiredRank then
                    UILibrary:Notify("Access Denied", "You need " .. requiredRank .. " rank to modify this!", "error", 3)
                    return
                end
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

                SafeCall(callback, value)
            end

            function Slider:GetValue()
                return Value
            end

            return Slider
        end

        function TabElements:AddTextbox(text, placeholder, callback, locked, requiredRank)
            placeholder = placeholder or "Texto aquí..."
            callback = callback or function() end
            locked = locked or false
            requiredRank = requiredRank or "USER"

            local Textbox = Instance.new("Frame")
            Textbox.Name = "Textbox_" .. text
            Textbox.Size = UDim2.new(1, 0, 0, 40)
            Textbox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Textbox.BorderSizePixel = 0
            Textbox.Parent = TabContainer

            local TextboxCorner = Instance.new("UICorner")
            TextboxCorner.CornerRadius = UDim.new(0, 6)
            TextboxCorner.Parent = Textbox

            local LockIcon = Instance.new("ImageLabel")
            LockIcon.Name = "LockIcon"
            LockIcon.Size = UDim2.new(0, 16, 0, 16)
            LockIcon.Position = UDim2.new(1, -20, 0.5, -8)
            LockIcon.BackgroundTransparency = 1
            LockIcon.Image = "rbxassetid://3926307971"
            LockIcon.ImageRectOffset = Vector2.new(4, 836)
            LockIcon.ImageRectSize = Vector2.new(36, 36)
            LockIcon.Visible = locked and userRank ~= requiredRank
            LockIcon.Parent = Textbox

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

            local InputBox = Instance.new("Frame")
            InputBox.Name = "InputBox"
            InputBox.Size = UDim2.new(1, -140, 0, 30)
            InputBox.Position = UDim2.new(0, 130, 0.5, -15)
            InputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            InputBox.BorderSizePixel = 0
            InputBox.Parent = Textbox

            local InputBoxCorner = Instance.new("UICorner")
            InputBoxCorner.CornerRadius = UDim.new(0, 6)
            InputBoxCorner.Parent = InputBox

            local InputBoxStroke = Instance.new("UIStroke")
            InputBoxStroke.Color = Color3.fromRGB(60, 60, 60)
            InputBoxStroke.Thickness = 1
            InputBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            InputBoxStroke.Parent = InputBox

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

            InputField.FocusLost:Connect(function(enterPressed)
                if locked and userRank ~= requiredRank then
                    UILibrary:Notify("Access Denied", "You need " .. requiredRank .. " rank to use this!", "error", 3)
                    return
                end
                if enterPressed then
                    SafeCall(callback, InputField.Text)
                end
            end)

            InputField.Focused:Connect(function()
                if locked and userRank ~= requiredRank then return end
                TweenService:Create(InputBox, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                }):Play()

                TweenService:Create(InputBoxStroke, TweenInfo.new(0.3), {
                    Color = config.AccentColor,
                    Thickness = 2
                }):Play()
            end)

            InputField.FocusLost:Connect(function()
                if locked and userRank ~= requiredRank then return end
                TweenService:Create(InputBox, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                }):Play()

                TweenService:Create(InputBoxStroke, TweenInfo.new(0.3), {
                    Color = Color3.fromRGB(60, 60, 60),
                    Thickness = 1
                }):Play()
            end)

            InputField.MouseEnter:Connect(function()
                if not InputField:IsFocused() and not (locked and userRank ~= requiredRank) then
                    TweenService:Create(InputBox, TweenInfo.new(0.3), {
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    }):Play()
                end
            end)

            InputField.MouseLeave:Connect(function()
                if not InputField:IsFocused() and not (locked and userRank ~= requiredRank) then
                    TweenService:Create(InputBox, TweenInfo.new(0.3), {
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                    }):Play()
                end
            end)

            function Textbox:SetText(value)
                if locked and userRank ~= requiredRank then
                    UILibrary:Notify("Access Denied", "You need " .. requiredRank .. " rank to modify this!", "error", 3)
                    return
                end
                InputField.Text = value
            end

            function Textbox:GetText()
                return InputField.Text
            end

            return Textbox
        end

        function TabElements:AddDropdown(text, options, callback, locked, requiredRank)
            options = options or {}
            callback = callback or function() end
            locked = locked or false
            requiredRank = requiredRank or "USER"

            local Dropdown = Instance.new("Frame")
            Dropdown.Name = "Dropdown_" .. text
            Dropdown.Size = UDim2.new(1, 0, 0, 40)
            Dropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Dropdown.BorderSizePixel = 0
            Dropdown.ClipsDescendants = true
            Dropdown.Parent = TabContainer

            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Parent = Dropdown

            local LockIcon = Instance.new("ImageLabel")
            LockIcon.Name = "LockIcon"
            LockIcon.Size = UDim2.new(0, 16, 0, 16)
            LockIcon.Position = UDim2.new(1, -20, 0.5, -8)
            LockIcon.BackgroundTransparency = 1
            LockIcon.Image = "rbxassetid://3926307971"
            LockIcon.ImageRectOffset = Vector2.new(4, 836)
            LockIcon.ImageRectSize = Vector2.new(36, 36)
            LockIcon.Visible = locked and userRank ~= requiredRank
            LockIcon.Parent = Dropdown

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

            local ArrowButton = Instance.new("ImageButton")
            ArrowButton.Name = "Arrow"
            ArrowButton.Size = UDim2.new(0, 20, 0, 20)
            ArrowButton.Position = UDim2.new(1, -30, 0, 10)
            ArrowButton.BackgroundTransparency = 1
            ArrowButton.Image = "rbxassetid://6031091004"
            ArrowButton.ImageColor3 = config.TextColor
            ArrowButton.Parent = Dropdown

            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.Name = "Options"
            OptionsFrame.Size = UDim2.new(1, -20, 0, #options * 30)
            OptionsFrame.Position = UDim2.new(0, 10, 0, 45)
            OptionsFrame.BackgroundTransparency = 1
            OptionsFrame.BorderSizePixel = 0
            OptionsFrame.Visible = false
            OptionsFrame.Parent = Dropdown

            local IsOpen = false
            local SelectedOption = ""

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

                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 4)
                OptionCorner.Parent = OptionButton

                OptionButton.MouseButton1Click:Connect(function()
                    if locked and userRank ~= requiredRank then
                        UILibrary:Notify("Access Denied", "You need " .. requiredRank .. " rank to use this!", "error", 3)
                        return
                    end
                    SelectedOption = option
                    SelectedText.Text = option
                    SafeCall(callback, option)

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

                OptionButton.MouseEnter:Connect(function()
                    if locked and userRank ~= requiredRank then return end
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    }):Play()
                end)

                OptionButton.MouseLeave:Connect(function()
                    if locked and userRank ~= requiredRank then return end
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    }):Play()
                end)
            end

            local function ToggleDropdown()
                if locked and userRank ~= requiredRank then
                    UILibrary:Notify("Access Denied", "You need " .. requiredRank .. " rank to use this!", "error", 3)
                    return
                end
                IsOpen = not IsOpen

                if IsOpen then
                    OptionsFrame.Visible = true

                    TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 45 + (#options * 30))
                    }):Play()

                    TweenService:Create(ArrowButton, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Rotation = 180
                    }):Play()

                    -- Adjust the position of elements below the dropdown
                    for _, child in ipairs(TabContainer:GetChildren()) do
                        if child:IsA("Frame") and child.LayoutOrder > Dropdown.LayoutOrder then
                            local newPos = UDim2.new(child.Position.X.Scale, child.Position.X.Offset, child.Position.Y.Scale, child.Position.Y.Offset + (#options * 30))
                            TweenService:Create(child, TweenInfo.new(0.3), {Position = newPos}):Play()
                        end
                    end
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

                    -- Reset the position of elements below the dropdown
                    for _, child in ipairs(TabContainer:GetChildren()) do
                        if child:IsA("Frame") and child.LayoutOrder > Dropdown.LayoutOrder then
                            local newPos = UDim2.new(child.Position.X.Scale, child.Position.X.Offset, child.Position.Y.Scale, child.Position.Y.Offset - (#options * 30))
                            TweenService:Create(child, TweenInfo.new(0.3), {Position = newPos}):Play()
                        end
                    end
                end
            end

            ArrowButton.MouseButton1Click:Connect(ToggleDropdown)

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Size = UDim2.new(1, 0, 0, 40)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = ""
            DropdownButton.Parent = Dropdown

            DropdownButton.MouseButton1Click:Connect(ToggleDropdown)

            DropdownButton.MouseEnter:Connect(function()
                if locked and userRank ~= requiredRank then return end
                TweenService:Create(Dropdown, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                }):Play()
            end)

            DropdownButton.MouseLeave:Connect(function()
                if locked and userRank ~= requiredRank then return end
                TweenService:Create(Dropdown, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                }):Play()
            end)

            function Dropdown:SetOptions(newOptions)
                if locked and userRank ~= requiredRank then
                    UILibrary:Notify("Access Denied", "You need " .. requiredRank .. " rank to modify this!", "error", 3)
                    return
                end
                for _, child in pairs(OptionsFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                OptionsFrame.Size = UDim2.new(1, -20, 0, #newOptions * 30)

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

                    local OptionCorner = Instance.new("UICorner")
                    OptionCorner.CornerRadius = UDim.new(0, 4)
                    OptionCorner.Parent = OptionButton

                    OptionButton.MouseButton1Click:Connect(function()
                        if locked and userRank ~= requiredRank then return end
                        SelectedOption = option
                        SelectedText.Text = option
                        SafeCall(callback, option)

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

                    OptionButton.MouseEnter:Connect(function()
                        if locked and userRank ~= requiredRank then return end
                        TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                        }):Play()
                    end)

                    OptionButton.MouseLeave:Connect(function()
                        if locked and userRank ~= requiredRank then return end
                        TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                        }):Play()
                    end)
                end

                if IsOpen then
                    TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 45 + (#newOptions * 30))
                    }):Play()
                end
            end

            function Dropdown:Select(option)
                if locked and userRank ~= requiredRank then
                    UILibrary:Notify("Access Denied", "You need " .. requiredRank .. " rank to modify this!", "error", 3)
                    return
                end
                SelectedOption = option
                SelectedText.Text = option
                SafeCall(callback, option)
            end

            function Dropdown:GetSelected()
                return SelectedOption
            end

            return Dropdown
        end

        function TabElements:AddDivider(locked, requiredRank)
            locked = locked or false
            requiredRank = requiredRank or "USER"

            local Divider = Instance.new("Frame")
            Divider.Name = "Divider"
            Divider.Size = UDim2.new(1, 0, 0, 8)
            Divider.BackgroundTransparency = 1
            Divider.Parent = TabContainer

            local LockIcon = Instance.new("ImageLabel")
            LockIcon.Name = "LockIcon"
            LockIcon.Size = UDim2.new(0, 16,)
            LockIcon.Position = UDim2.new(1, -20, 0.5, -8)
LockIcon.BackgroundTransparency = 1
LockIcon.Image = "rbxassetid://3926307971"
LockIcon.ImageRectOffset = Vector2.new(4, 836)
LockIcon.ImageRectSize = Vector2.new(36, 36)
LockIcon.Visible = locked and userRank ~= requiredRank
LockIcon.Parent = Divider

local Line = Instance.new("Frame")
Line.Name = "Line"
Line.Size = UDim2.new(1, -20, 0, 1)
Line.Position = UDim2.new(0, 10, 0.5, -0.5)
Line.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Line.BorderSizePixel = 0
Line.Parent = Divider

return Divider
end

function TabElements:AddColorPicker(text, default, callback, locked, requiredRank)
default = default or Color3.fromRGB(100, 100, 255)
callback = callback or function() end
locked = locked or false
requiredRank = requiredRank or "USER"

local ColorPicker = Instance.new("Frame")
ColorPicker.Name = "ColorPicker_" .. text
ColorPicker.Size = UDim2.new(1, 0, 0, 40)
ColorPicker.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ColorPicker.BorderSizePixel = 0
ColorPicker.Parent = TabContainer

local ColorPickerCorner = Instance.new("UICorner")
ColorPickerCorner.CornerRadius = UDim.new(0, 6)
ColorPickerCorner.Parent = ColorPicker

local LockIcon = Instance.new("ImageLabel")
LockIcon.Name = "LockIcon"
LockIcon.Size = UDim2.new(0, 16, 0, 16)
LockIcon.Position = UDim2.new(1, -20, 0.5, -8)
LockIcon.BackgroundTransparency = 1
LockIcon.Image = "rbxassetid://3926307971"
LockIcon.ImageRectOffset = Vector2.new(4, 836)
LockIcon.ImageRectSize = Vector2.new(36, 36)
LockIcon.Visible = locked and userRank ~= requiredRank
LockIcon.Parent = ColorPicker

local ColorPickerLabel = Instance.new("TextLabel")
ColorPickerLabel.Name = "Title"
ColorPickerLabel.Size = UDim2.new(1, -70, 1, 0)
ColorPickerLabel.Position = UDim2.new(0, 10, 0, 0)
ColorPickerLabel.BackgroundTransparency = 1
ColorPickerLabel.Text = text
ColorPickerLabel.TextColor3 = config.TextColor
ColorPickerLabel.TextSize = 14
ColorPickerLabel.Font = Enum.Font.GothamSemibold
ColorPickerLabel.TextXAlignment = Enum.TextXAlignment.Left
ColorPickerLabel.Parent = ColorPicker

local ColorDisplay = Instance.new("Frame")
ColorDisplay.Name = "ColorDisplay"
ColorDisplay.Size = UDim2.new(0, 40, 0, 20)
ColorDisplay.Position = UDim2.new(1, -50, 0.5, -10)
ColorDisplay.BackgroundColor3 = default
ColorDisplay.BorderSizePixel = 0
ColorDisplay.Parent = ColorPicker

local ColorDisplayCorner = Instance.new("UICorner")
ColorDisplayCorner.CornerRadius = UDim.new(0, 4)
ColorDisplayCorner.Parent = ColorDisplay

local PickerButton = Instance.new("TextButton")
PickerButton.Name = "PickerButton"
PickerButton.Size = UDim2.new(1, 0, 1, 0)
PickerButton.BackgroundTransparency = 1
PickerButton.Text = ""
PickerButton.Parent = ColorPicker

local ColorPickerOpen = false
local Hue, Sat, Val = default:ToHSV()

local ColorPickerFrame = Instance.new("Frame")
ColorPickerFrame.Name = "ColorPickerFrame"
ColorPickerFrame.Size = UDim2.new(0, 200, 0, 200)
ColorPickerFrame.Position = UDim2.new(1, 10, 0, 0)
ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ColorPickerFrame.BorderSizePixel = 0
ColorPickerFrame.Visible = false
ColorPickerFrame.Parent = ColorPicker

local ColorPickerCorner2 = Instance.new("UICorner")
ColorPickerCorner2.CornerRadius = UDim.new(0, 6)
ColorPickerCorner2.Parent = ColorPickerFrame

local HueSatGrid = Instance.new("ImageLabel")
HueSatGrid.Name = "HueSatGrid"
HueSatGrid.Size = UDim2.new(0, 160, 0, 160)
HueSatGrid.Position = UDim2.new(0, 10, 0, 10)
HueSatGrid.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
HueSatGrid.BorderSizePixel = 0
HueSatGrid.Image = "rbxassetid://698052001" -- Gradient grid
HueSatGrid.Parent = ColorPickerFrame

local HueSatSelector = Instance.new("Frame")
HueSatSelector.Name = "Selector"
HueSatSelector.Size = UDim2.new(0, 8, 0, 8)
HueSatSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HueSatSelector.BorderSizePixel = 0
HueSatSelector.Parent = HueSatGrid

local HueSatSelectorCorner = Instance.new("UICorner")
HueSatSelectorCorner.CornerRadius = UDim.new(1, 0)
HueSatSelectorCorner.Parent = HueSatSelector

local HueSatSelectorBorder = Instance.new("UIStroke")
HueSatSelectorBorder.Color = Color3.fromRGB(0, 0, 0)
HueSatSelectorBorder.Thickness = 2
HueSatSelectorBorder.Parent = HueSatSelector

local ValueSlider = Instance.new("Frame")
ValueSlider.Name = "ValueSlider"
ValueSlider.Size = UDim2.new(0, 20, 0, 160)
ValueSlider.Position = UDim2.new(0, 180, 0, 10)
ValueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ValueSlider.BorderSizePixel = 0
ValueSlider.Parent = ColorPickerFrame

local ValueSliderCorner = Instance.new("UICorner")
ValueSliderCorner.CornerRadius = UDim.new(0, 4)
ValueSliderCorner.Parent = ValueSlider

local ValueGradient = Instance.new("UIGradient")
ValueGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
ValueGradient.Parent = ValueSlider

local ValueSelector = Instance.new("Frame")
ValueSelector.Name = "Selector"
ValueSelector.Size = UDim2.new(1, 0, 0, 4)
ValueSelector.Position = UDim2.new(0, 0, 1 - Val, -2)
ValueSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ValueSelector.BorderSizePixel = 0
ValueSelector.Parent = ValueSlider

local ValueSelectorCorner = Instance.new("UICorner")
ValueSelectorCorner.CornerRadius = UDim.new(0, 2)
ValueSelectorCorner.Parent = ValueSelector

local function UpdateColorPicker()
local hsvColor = Color3.fromHSV(Hue, Sat, Val)
ColorDisplay.BackgroundColor3 = hsvColor
SafeCall(callback, hsvColor)
end

local draggingHueSat = false
local draggingValue = false

HueSatGrid.InputBegan:Connect(function(input)
if locked and userRank ~= requiredRank then return end
if input.UserInputType == Enum.UserInputType.MouseButton1 then
draggingHueSat = true
local relX = math.clamp((input.Position.X - HueSatGrid.AbsolutePosition.X) / HueSatGrid.AbsoluteSize.X, 0, 1)
local relY = math.clamp((input.Position.Y - HueSatGrid.AbsolutePosition.Y) / HueSatGrid.AbsoluteSize.Y, 0, 1)
Sat = relX
Val = 1 - relY
HueSatSelector.Position = UDim2.new(Sat, -4, 1 - Val, -4)
UpdateColorPicker()
end
end)

ValueSlider.InputBegan:Connect(function(input)
if locked and userRank ~= requiredRank then return end
if input.UserInputType == Enum.UserInputType.MouseButton1 then
draggingValue = true
local relY = math.clamp((input.Position.Y - ValueSlider.AbsolutePosition.Y) / ValueSlider.AbsoluteSize.Y, 0, 1)
Val = 1 - relY
ValueSelector.Position = UDim2.new(0, 0, 1 - Val, -2)
UpdateColorPicker()
end
end)

UserInputService.InputChanged:Connect(function(input)
if draggingHueSat and input.UserInputType == Enum.UserInputType.MouseMovement then
local relX = math.clamp((input.Position.X - HueSatGrid.AbsolutePosition.X) / HueSatGrid.AbsoluteSize.X, 0, 1)
local relY = math.clamp((input.Position.Y - HueSatGrid.AbsolutePosition.Y) / HueSatGrid.AbsoluteSize.Y, 0, 1)
Sat = relX
Val = 1 - relY
HueSatSelector.Position = UDim2.new(Sat, -4, 1 - Val, -4)
UpdateColorPicker()
elseif draggingValue and input.UserInputType == Enum.UserInputType.MouseMovement then
local relY = math.clamp((input.Position.Y - ValueSlider.AbsolutePosition.Y) / ValueSlider.AbsoluteSize.Y, 0, 1)
Val = 1 - relY
ValueSelector.Position = UDim2.new(0, 0, 1 - Val, -2)
UpdateColorPicker()
end
end)

UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
draggingHueSat = false
draggingValue = false
end
end)

PickerButton.MouseButton1Click:Connect(function()
if locked and userRank ~= requiredRank then
UILibrary:Notify("Access Denied", "You need " .. requiredRank .. " rank to use this!", "error", 3)
return
end
ColorPickerOpen = not ColorPickerOpen
ColorPickerFrame.Visible = ColorPickerOpen

if ColorPickerOpen then
HueSatSelector.Position = UDim2.new(Sat, -4, 1 - Val, -4)
ValueSelector.Position = UDim2.new(0, 0, 1 - Val, -2)
end
end)

PickerButton.MouseEnter:Connect(function()
if locked and userRank ~= requiredRank then return end
TweenService:Create(ColorPicker, TweenInfo.new(0.3), {
BackgroundColor3 = Color3.fromRGB(55, 55, 55)
}):Play()
end)

PickerButton.MouseLeave:Connect(function()
if locked and userRank ~= requiredRank then return end
TweenService:Create(ColorPicker, TweenInfo.new(0.3), {
BackgroundColor3 = Color3.fromRGB(45, 45, 45)
}):Play()
end)

function ColorPicker:SetColor(color)
if locked and userRank ~= requiredRank then
UILibrary:Notify("Access Denied", "You need " .. requiredRank .. " rank to modify this!", "error", 3)
return
end
local h, s, v = color:ToHSV()
Hue, Sat, Val = h, s, v
ColorDisplay.BackgroundColor3 = color
HueSatSelector.Position = UDim2.new(Sat, -4, 1 - Val, -4)
ValueSelector.Position = UDim2.new(0, 0, 1 - Val, -2)
HueSatGrid.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
SafeCall(callback, color)
end

function ColorPicker:GetColor()
return ColorDisplay.BackgroundColor3
end

ColorPicker:SetColor(default)

return ColorPicker
end

return TabElements
end

function UILibrary:Notify(title, message, icon, duration, notifType)
NotificationSystem:Notify(title, message, icon, duration, notifType)
end

return UILibrary
end

return UILibrary
