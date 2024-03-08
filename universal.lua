local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local SiriusSenseESP = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Sirius/request/library/sense/source.lua'))()

SiriusSenseESP.teamSettings.enemy.enabled = true

-- This script was made by @dementia enjoyer / eldmonstret
-- Fully unobfuscated, have fun skidding :D
-- Credits to shlexware for esp

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
        BoxEnabled = false,
        BoxType = "2D",
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
        if GetPlayers.Character:FindFirstChild("HumanoidRootPart") and GetPlayers.Character:FindFirstChildOfClass("Humanoid") and not (GetPlayers.Name == game.Players.LocalPlayer.Name) then
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

function SiriusSenseESP.getWeapon(player)
    local players = workspace:FindFirstChild("Players")
    if players then
        if players:FindFirstChild(player.Name) then
            local Player = players[player.Name]
            local FindTool = Player:FindFirstChildOfClass("Tool")
            if FindTool then
                return FindTool.Name
            else
                return "None"
            end
        end
    else
        local FindPlayer = workspace:FindFirstChild(player.Name)
        if FindPlayer then
            local FindTool = FindPlayer:FindFirstChildOfClass("Tool")
            if FindTool then
                return FindTool.Name
            else
                return "None"
            end
        end
    end
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
        _G.FeatureTable.Visuals.BoxEnabled = value
    end
})

VisualsSection:AddToggle('NameESP', {
    Text = 'Name',
    Default = false,
    Tooltip = 'Renders a text displaying a players name',

    Callback = function(value)
        SiriusSenseESP.teamSettings.enemy.name = value
    end
})

VisualsSection:AddToggle('DistanceESP', {
    Text = 'Distance',
    Default = false,
    Tooltip = 'Renders a text displaying the players distance in studs',

    Callback = function(value)
        SiriusSenseESP.teamSettings.enemy.distance = value
    end
})

VisualsSection:AddToggle('WeaponESP', {
    Text = 'Weapon',
    Default = false,
    Tooltip = 'Renders a text displaying a players current weapon / tool',

    Callback = function(value)
        SiriusSenseESP.teamSettings.enemy.weapon = value
    end
})

VisualsSection:AddToggle('HealthbarESP', {
    Text = 'Healthbar',
    Default = false,
    Tooltip = 'Renders a bar which displays a players health on the Y axis',

    Callback = function(value)
        SiriusSenseESP.teamSettings.enemy.healthBar = value
    end
})

VisualsSection:AddLabel('Box ESP Color'):AddColorPicker('Box Type', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Box Color',
    Transparency = 0,

    Callback = function(Value)
        SiriusSenseESP.teamSettings.enemy.boxColor[1] = Value
        SiriusSenseESP.teamSettings.enemy.box3dColor[1] = Value
    end
})

VisualsSection:AddDropdown('Box Type', {
    Values = { '2D', '3D' },
    Default = 1,
    Multi = false,

    Text = 'Box Type',
    Tooltip = 'Customizable box type & demension',

    Callback = function(value)
        _G.FeatureTable.Visuals.BoxType = value
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

    if _G.FeatureTable.Visuals.BoxEnabled then
        if _G.FeatureTable.Visuals.BoxType == "2D" then
            SiriusSenseESP.teamSettings.enemy.box = true
            SiriusSenseESP.teamSettings.enemy.box3d = false
        else
            SiriusSenseESP.teamSettings.enemy.box = false
            SiriusSenseESP.teamSettings.enemy.box3d = true
        end
    else
        SiriusSenseESP.teamSettings.enemy.box = false
        SiriusSenseESP.teamSettings.enemy.box3d = false
    end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    wait(0.5)
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

SiriusSenseESP.Load() -- load esp module, credits to shlexware
