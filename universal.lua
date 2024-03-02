local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

-- This script was made by @dementia enjoyer / eldmonstret
-- Fully unobfuscated, have fun skidding :D

local UserInputService = game:GetService("UserInputService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

local StorageFolder = Instance.new("Folder", game.CoreGui)
StorageFolder.Name = "EclipseStorage"

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'eclipse.lol',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

setfpscap(math.huge) -- uncap fps if executor supports

_G.FeatureTable = { -- table for our variables
    Combat = {
        AimbotEnabled = false,
        HealthCheck = false,

        FOVCircle = false,
        FOVCircleColor = Color3.fromRGB(255,255,255),
        FOVCircleRadius = 30,

        Togglelock = false,

        UseSmoothness = false,
        SmoothnessValue = 1,

        CurrentHitbox = "Head",

        AimbotInputType = "KeyCode",
        AimbotBind = Enum.KeyCode.Q,
    },
    Visuals = {
        BoxESP = false,
        CornerESP = false,
        FilledESP = false,
        FilledColor = Color3.fromRGB(255,255,255),
        BoxThickness = 1,
        BoxColor = Color3.fromRGB(255,255,255),
        CornerColor = Color3.fromRGB(255,255,255),
    },
    Other = {
        AimbotHold = false,

        CurrentAnimation = nil,
        CurrentTween = nil,
        Target = nil,
    },
}

local FOVCircle = Drawing.new("Circle") -- render fov circle, hopefully your exploit supports drawing lib :D
FOVCircle.Thickness = 0.5

function GetClosestPlayer()
    local ClosestPlayer

    for i, GetPlayers in pairs(game.Players:GetPlayers()) do
        if GetPlayers.Character and GetPlayers.Character:FindFirstChildOfClass("Humanoid") and not (GetPlayers.Name == game.Players.LocalPlayer.Name) then
            local ScreenPoint = workspace.CurrentCamera:WorldToScreenPoint(GetPlayers.Character[_G.FeatureTable.Combat.CurrentHitbox].Position)
            local Dist = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
            if Dist < _G.FeatureTable.Combat.FOVCircleRadius * 2 then
                ClosestPlayer = GetPlayers
                if _G.FeatureTable.Combat.Notifications then
                    Library:Notify("New Target: ".. GetPlayers.Name.. ".")
                end
            end
        end
    end
    return ClosestPlayer
end

function CreateBox(part)
    local BillboardGui = Instance.new("BillboardGui", StorageFolder)
    BillboardGui.Name = "FpsBooster"
    local Frame = Instance.new("Frame")

    BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BillboardGui.Enabled = _G.FeatureTable.Visuals.BoxESP
    BillboardGui.Active = true
    BillboardGui.AlwaysOnTop = true
    BillboardGui.LightInfluence = 1.000
    BillboardGui.Size = UDim2.new(4, 0, 7, 0)
    BillboardGui.Adornee = part

    Frame.Parent = BillboardGui
    Frame.BackgroundColor3 = _G.FeatureTable.Visuals.FilledColor
    Frame.BackgroundTransparency = 1.000
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.150000006, 0, 0.0700000003, 0)
    Frame.Size = UDim2.new(0.699999988, 0, 0.800000012, 0)

    if _G.FeatureTable.Visuals.FilledESP then
        Frame.BackgroundTransparency = 0.5
    else
        Frame.BackgroundTransparency = 1
    end

    local UIStroke = Instance.new("UIStroke", Frame)
    UIStroke.LineJoinMode = "Miter"
    UIStroke.Color = _G.FeatureTable.Visuals.BoxColor
    UIStroke.Thickness = _G.FeatureTable.Visuals.BoxThickness
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
end

function CreateCornerBox(part)

    local BillboardGui = Instance.new("BillboardGui", StorageFolder)
    local Left = Instance.new("Frame")
    local TopLeft = Instance.new("Frame")
    local TopRight = Instance.new("Frame")
    local Right = Instance.new("Frame")
    local BottomLeft = Instance.new("Frame")
    local BottomBottomRight = Instance.new("Frame")
    local BottomBottomLeft = Instance.new("Frame")
    local BottomRight = Instance.new("Frame")

    BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BillboardGui.Active = true
    BillboardGui.Adornee = part
    BillboardGui.AlwaysOnTop = true
    BillboardGui.LightInfluence = 1.000
    BillboardGui.Size = UDim2.new(4, 0, 7, 0)
    BillboardGui.Enabled = _G.FeatureTable.Visuals.CornerESP
    BillboardGui.Name = "FpsBooster2"

    Left.Name = "Left"
    Left.Parent = BillboardGui
    Left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Left.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Left.BorderSizePixel = 0
    Left.Position = UDim2.new(0.150000006, 0, 0.0700000003, 0)
    Left.Size = UDim2.new(0.0199999996, 0, 0.150000006, 0)

    TopLeft.Name = "TopLeft"
    TopLeft.Parent = BillboardGui
    TopLeft.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TopLeft.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TopLeft.BorderSizePixel = 0
    TopLeft.Position = UDim2.new(0.150000006, 0, 0.0700000003, 0)
    TopLeft.Size = UDim2.new(0.200000003, 0, 0.00999999978, 0)

    TopRight.Name = "TopRight"
    TopRight.Parent = BillboardGui
    TopRight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TopRight.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TopRight.BorderSizePixel = 0
    TopRight.Position = UDim2.new(0.600000024, 0, 0.0700000003, 0)
    TopRight.Size = UDim2.new(0.200000003, 0, 0.00999999978, 0)

    Right.Name = "Right"
    Right.Parent = BillboardGui
    Right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Right.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Right.BorderSizePixel = 0
    Right.Position = UDim2.new(0.800000012, 0, 0.0700000003, 0)
    Right.Size = UDim2.new(0.0199999996, 0, 0.150000006, 0)

    BottomLeft.Name = "BottomLeft"
    BottomLeft.Parent = BillboardGui
    BottomLeft.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BottomLeft.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BottomLeft.BorderSizePixel = 0
    BottomLeft.Position = UDim2.new(0.200000003, 0, 0.699999988, 0)
    BottomLeft.Size = UDim2.new(0.0199999996, 0, 0.150000006, 0)

    BottomBottomRight.Name = "BottomBottomRight"
    BottomBottomRight.Parent = BillboardGui
    BottomBottomRight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BottomBottomRight.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BottomBottomRight.BorderSizePixel = 0
    BottomBottomRight.Position = UDim2.new(0.620000005, 0, 0.850000024, 0)
    BottomBottomRight.Size = UDim2.new(0.200000003, 0, 0.00999999978, 0)

    BottomBottomLeft.Name = "BottomBottomLeft"
    BottomBottomLeft.Parent = BillboardGui
    BottomBottomLeft.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BottomBottomLeft.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BottomBottomLeft.BorderSizePixel = 0
    BottomBottomLeft.Position = UDim2.new(0.200000003, 0, 0.850000024, 0)
    BottomBottomLeft.Size = UDim2.new(0.200000003, 0, 0.00999999978, 0)

    BottomRight.Name = "BottomRight"
    BottomRight.Parent = BillboardGui
    BottomRight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BottomRight.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BottomRight.BorderSizePixel = 0
    BottomRight.Position = UDim2.new(0.800000012, 0, 0.699999988, 0)
    BottomRight.Size = UDim2.new(0.0199999996, 0, 0.150000006, 0)

end

local Tabs = {
    AimbotTab = Window:AddTab('Aimbot'),
    VisualsTab = Window:AddTab('Visuals'),
    MiscTab = Window:AddTab('Misc'),
    ['UI Settings'] = Window:AddTab('Settings'),
}

local AimbotSection = Tabs.AimbotTab:AddLeftGroupbox('Aimbot')
local VisualsSection = Tabs.VisualsTab:AddLeftGroupbox('Visuals')
local MiscSection = Tabs.MiscTab:AddLeftGroupbox('Misc')

AimbotSection:AddToggle('Aimbot', {
    Text = 'Aimbot',
    Default = false,
    Tooltip = 'Simple aim modification',

    Callback = function(Value)
        _G.FeatureTable.Combat.AimbotEnabled = Value
    end
})

AimbotSection:AddToggle('HealthCheck', {
    Text = 'Healthcheck',
    Default = false,
    Tooltip = 'Constantly checks if the enemies health is above > 1, then locks',

    Callback = function(Value)
        _G.FeatureTable.Combat.HealthCheck = Value
    end
})

AimbotSection:AddToggle('Notifications', {
    Text = 'Notifications',
    Default = false,
    Tooltip = 'Notifies you whenever you lock onto a new target.',

    Callback = function(Value)
        _G.FeatureTable.Combat.Notifications = Value
    end
})

AimbotSection:AddToggle('FOVCircle', {
    Text = 'FOV Circle',
    Default = false,
    Tooltip = 'Renders a circle on your cursor to visualise the range of your aimbot in 2d.',

    Callback = function(Value)
        _G.FeatureTable.Combat.FOVCircle = Value
        FOVCircle.Visible = _G.FeatureTable.Combat.FOVCircle
    end
})

AimbotSection:AddToggle('UseSmoothness', {
    Text = 'Use Smoothness',
    Default = false,
    Tooltip = 'Makes the aimbot slower making it look more legit',

    Callback = function(Value)
        _G.FeatureTable.Combat.UseSmoothness = Value
    end
})

AimbotSection:AddToggle('Toggle', {
    Text = 'Toggle',
    Default = false,
    Tooltip = 'Press aimbot bind once = lock (default is hold)',
    
    Callback = function(Value)
        _G.FeatureTable.Combat.Togglelock = Value
    end
})

AimbotSection:AddLabel('FOV Circle Color'):AddColorPicker('FOVCircleColor', {
    Default = Color3.fromRGB(255,255,255),
    Title = 'FOV Color',
    Transparency = 0,

    Callback = function(Value)
        _G.FeatureTable.Combat.FOVCircleColor = Value
    end
})

AimbotSection:AddSlider('FOVCircleRadius', {
    Text = 'FOV Radius',
    Default = 30,
    Min = 1,
    Max = 150,
    Rounding = 1,
    Compact = false,
    Callback = function(value)
        _G.FeatureTable.Combat.FOVCircleRadius = value
    end
})

AimbotSection:AddDropdown('AimbotHitpart', {
    Values = { 'Head', 'UpperTorso', 'LowerTorso', 'HumanoidRootPart' },
    Default = 1,
    Multi = false,

    Text = 'Aimbot Hitpart',
    Tooltip = 'Customizable hitpart for the aim modification.',

    Callback = function(value)
        _G.FeatureTable.Combat.CurrentHitbox = value
    end
})

AimbotSection:AddDropdown('AimbotBind', {
    Values = { 'Q', 'C', 'MouseButton1', 'MouseButton2' },
    Default = 1,
    Multi = false,

    Text = 'Aimbot Bind',
    Tooltip = 'Customizable bind which is used for toggling the aimbot',

    Callback = function(value)
        if value == "MouseButton1" then
            _G.FeatureTable.Combat.AimbotInputType = "UserInputType"
            _G.FeatureTable.Combat.AimbotBind = Enum.UserInputType.MouseButton1
        elseif value == "MouseButton2" then
            _G.FeatureTable.Combat.AimbotInputType = "UserInputType"
            _G.FeatureTable.Combat.AimbotBind = Enum.UserInputType.MouseButton2
        else
            _G.FeatureTable.Combat.AimbotInputType = "KeyCode"
            _G.FeatureTable.Combat.AimbotBind = Enum.KeyCode[value]
        end
    end
})

AimbotSection:AddSlider('SmoothnessValue', {
    Text = 'Aimbot Smoothness',
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Compact = false,

    Callback = function(value)
        _G.FeatureTable.Combat.SmoothnessValue = value
    end
})

-- visuals tab

VisualsSection:AddToggle('BoxESP', {
    Text = 'Box',
    Default = false,
    Tooltip = 'Renders a box on all the players which is layered above all objects so you can see people through walls',

    Callback = function(value)
        _G.FeatureTable.Visuals.BoxESP = value
        for i,GetESP in pairs(StorageFolder:GetChildren()) do
            if GetESP:IsA("BillboardGui") and GetESP.Name == "FpsBooster" then
                GetESP.Enabled = _G.FeatureTable.Visuals.BoxESP
            end
        end
    end
})

VisualsSection:AddToggle('CornerBoxESP', {
    Text = 'Corner',
    Default = false,
    Tooltip = 'Renders a box which only shows the corners',

    Callback = function(value)
        _G.FeatureTable.Visuals.CornerESP = value

        for i,GetESP in pairs(StorageFolder:GetChildren()) do
            if GetESP:IsA("BillboardGui") and GetESP.Name == "FpsBooster2" then
                GetESP.Enabled = _G.FeatureTable.Visuals.CornerESP
            end
        end
    end
})

VisualsSection:AddToggle('FilledESP', {
    Text = 'Filled Box',
    Default = false,
    Tooltip = 'Fills the box esp',

    Callback = function(value)
        _G.FeatureTable.Visuals.FilledESP = value
        for i,GetESP in pairs(StorageFolder:GetChildren()) do
            if GetESP:IsA("BillboardGui") and GetESP.Name == "FpsBooster" then
                local FindFrame = GetESP:FindFirstChildOfClass("Frame")
                if FindFrame then
                    if value then
                        FindFrame.BackgroundTransparency = 0.5
                    else
                        FindFrame.BackgroundTransparency = 1
                    end
                end
            end
        end
    end
})

VisualsSection:AddLabel('Box Color'):AddColorPicker('BoxESPColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Box Color',
    Transparency = 0,

    Callback = function(Value)
        _G.FeatureTable.Visuals.BoxColor = Value

        for i,GetESP in pairs(StorageFolder:GetChildren()) do
            if GetESP:IsA("BillboardGui") and GetESP.Name == "FpsBooster" then
                local FindMainFrame = GetESP:FindFirstChildOfClass("Frame")
                if FindMainFrame then
                    FindMainFrame:FindFirstChildOfClass("UIStroke").Color = _G.FeatureTable.Visuals.BoxColor
                end
            end
        end 
    end
})

VisualsSection:AddLabel('Corner Box Color'):AddColorPicker('CornerESPColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Corner Box Color',
    Transparency = 0,

    Callback = function(Value)
        _G.FeatureTable.Visuals.CornerColor = Value

        for i,GetESP in pairs(StorageFolder:GetChildren()) do
            if GetESP:IsA("BillboardGui") and GetESP.Name == "FpsBooster2" then
                local FindMainFrame = GetESP:FindFirstChildOfClass("Frame")
                if FindMainFrame then
                    for i,GetAllFrames in pairs(GetESP:GetChildren()) do
                        if GetAllFrames:IsA("Frame") then
                            GetAllFrames.BackgroundColor3 = _G.FeatureTable.Visuals.CornerColor
                        end
                    end
                end
            end
        end 
    end
})

VisualsSection:AddLabel('Fill Color'):AddColorPicker('FillESPColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Fill Color',
    Transparency = 0,

    Callback = function(Value)
        _G.FeatureTable.Visuals.FilledColor = Value

        for i,GetESP in pairs(StorageFolder:GetChildren()) do
            if GetESP:IsA("BillboardGui") and GetESP.Name == "FpsBooster" then
                local FindFrame = GetESP:FindFirstChildOfClass("Frame")
                if FindFrame then
                    FindFrame.BackgroundColor3 = Value
                end
            end
        end
    end
})

VisualsSection:AddSlider('BoxThicknessSlider', {
    Text = 'Box Thickness',
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Compact = false,

    Callback = function(value)
        _G.FeatureTable.Visuals.BoxThickness = value

        for i,GetESP in pairs(StorageFolder:GetChildren()) do
            if GetESP:IsA("BillboardGui") and GetESP.Name == "FpsBooster" then
                local FindMainFrame = GetESP:FindFirstChildOfClass("Frame")
                if FindMainFrame then
                    FindMainFrame:FindFirstChildOfClass("UIStroke").Thickness = _G.FeatureTable.Visuals.BoxThickness
                end
            end
        end 
    end
})

-- misc tab

MiscSection:AddLabel('Fog Color'):AddColorPicker('FogColor', {
    Default = game:GetService("Lighting").FogColor,
    Title = 'Fog Color',
    Transparency = 0,

    Callback = function(Value)
        game:GetService("Lighting").FogColor = Value
    end
})

MiscSection:AddSlider('FogEnd', {
    Text = 'Fog Start',
    Default = game:GetService("Lighting").FogStart,
    Min = 0,
    Max = 10000,
    Rounding = 1,
    Compact = false,

    Callback = function(value)
        game:GetService("Lighting").FogStart = value
    end
})

MiscSection:AddSlider('FogEnd', {
    Text = 'Fog End',
    Default = game:GetService("Lighting").FogEnd,
    Min = 0,
    Max = 10000,
    Rounding = 1,
    Compact = false,

    Callback = function(value)
        game:GetService("Lighting").FogEnd = value
    end
})

MiscSection:AddLabel('Ambient Color'):AddColorPicker('AmbientColor', {
    Default = game:GetService("Lighting").Ambient,
    Title = 'Ambient Color',
    Transparency = 0,

    Callback = function(Value)
        game:GetService("Lighting").Ambient = Value
    end
})

MiscSection:AddLabel('Outdoor Ambient Color'):AddColorPicker('OutdoorAmbientColor', {
    Default = game:GetService("Lighting").OutdoorAmbient,
    Title = 'OutdoorAmbient Color',
    Transparency = 0,

    Callback = function(Value)
        game:GetService("Lighting").OutdoorAmbient = Value
    end
})

MiscSection:AddSlider('ClockTime', {
    Text = 'Time',
    Default = game:GetService("Lighting").ClockTime,
    Min = 0,
    Max = 20,
    Rounding = 1,
    Compact = false,

    Callback = function(value)
        game:GetService("Lighting").ClockTime = value
    end
})

UserInputService.InputBegan:Connect(function(Key) -- start detecting input for our aimbot
    if Key[_G.FeatureTable.Combat.AimbotInputType] == _G.FeatureTable.Combat.AimbotBind then
        if _G.FeatureTable.Combat.AimbotEnabled then
            if _G.FeatureTable.Combat.Togglelock then

                local ClosestPlayer = GetClosestPlayer()
                _G.FeatureTable.Other.Target = ClosestPlayer
                _G.FeatureTable.Other.AimbotHold = not _G.FeatureTable.Other.AimbotHold

            else

                local ClosestPlayer = GetClosestPlayer()
                _G.FeatureTable.Other.Target = ClosestPlayer
                _G.FeatureTable.Other.AimbotHold = true

            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input[_G.FeatureTable.Combat.AimbotInputType] == _G.FeatureTable.Combat.AimbotBind and not _G.FeatureTable.Combat.Togglelock then
        _G.FeatureTable.Other.AimbotHold = false
        _G.FeatureTable.Other.Target = nil
        if _G.FeatureTable.Combat.Notifications then 
            Library:Notify("Unlocked.")
        end
    end
end)

for i,GetAllPlayers in pairs(game.Players:GetPlayers()) do
    if not (GetAllPlayers == game.Players.LocalPlayer) then
        if GetAllPlayers.Character then
            CreateBox(GetAllPlayers.Character.HumanoidRootPart)
            CreateCornerBox(GetAllPlayers.Character.HumanoidRootPart)
        end
    
        GetAllPlayers.CharacterAdded:Connect(function(character)
            wait(2)
            CreateBox(character.HumanoidRootPart)
            CreateCornerBox(character.HumanoidRootPart)
        end)
    end
end

game.Players.PlayerAdded:Connect(function(player)
    wait(2)
    CreateBox(player.Character.HumanoidRootPart)
    CreateCornerBox(player.Character.HumanoidRootPart)

    player.CharacterAdded:Connect(function(character)
        wait(2)
        CreateBox(character.HumanoidRootPart)
        CreateCornerBox(character.HumanoidRootPart)
    end)
end)

RunService.RenderStepped:Connect(function()
    if _G.FeatureTable.Combat.HealthCheck then
        if _G.FeatureTable.Other.Target ~= nil then
            if not (_G.FeatureTable.Other.Target.Character:FindFirstChildOfClass("Humanoid").Health > 0) then
                _G.FeatureTable.Other.AimbotHold = false
                _G.FeatureTable.Other.Target = nil
                print("Resetting")
            end
        end
    end
    if _G.FeatureTable.Other.AimbotHold and _G.FeatureTable.Combat.AimbotEnabled then
        if _G.FeatureTable.Other.Target then
            local aimpos = nil
            local char = _G.FeatureTable.Other.Target.Character
            
            if char and char[_G.FeatureTable.Combat.CurrentHitbox] and char.HumanoidRootPart then
                aimpos = char[_G.FeatureTable.Combat.CurrentHitbox].Position
            end
    
            if aimpos then
                local camera = workspace.CurrentCamera
                if _G.FeatureTable.Combat.UseSmoothness then
                    _G.FeatureTable.Other.CurrentTween = game:GetService("TweenService"):Create(camera, TweenInfo.new(_G.FeatureTable.Combat.SmoothnessValue / 10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {CFrame = CFrame.new(camera.CFrame.Position, aimpos)})
                    _G.FeatureTable.Other.CurrentTween:Play()
                else
                    camera.CFrame = CFrame.new(camera.CFrame.Position, aimpos)
                end
            end
        end
    else
        if _G.FeatureTable.Other.CurrentTween then
            _G.FeatureTable.Other.CurrentTween:Cancel()
        end
    end

    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    FOVCircle.Radius = _G.FeatureTable.Combat.FOVCircleRadius * 2.2
    FOVCircle.Color = _G.FeatureTable.Combat.FOVCircleColor
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    wait(2)
    _G.FeatureTable.Other.CurrentAnimation = nil
end)

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('eclipse')
SaveManager:SetFolder('eclipse/dahood')

SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
