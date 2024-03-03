local EclipseLoader = Instance.new("ScreenGui")
local Loader = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local Icon = Instance.new("ImageLabel")
local TextButton = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")

EclipseLoader.Name = "EclipseLoader"
EclipseLoader.Parent = game.CoreGui

Loader.Name = "Loader"
Loader.Parent = EclipseLoader
Loader.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
Loader.BorderColor3 = Color3.fromRGB(159, 88, 252)
Loader.Position = UDim2.new(0.411265165, 0, 0.361042172, 0)
Loader.Size = UDim2.new(0.176672012, 0, 0.276674926, 0)

UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = Loader

Title.Name = "Title"
Title.Parent = Loader
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title.BorderSizePixel = 0
Title.Position = UDim2.new(8.27981467e-07, 0, 0.0269058309, 0)
Title.Size = UDim2.new(1.00000072, 0, 0.0710033476, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "ECLIPSE.LOL"
Title.TextColor3 = Color3.fromRGB(159, 88, 252)
Title.TextSize = 14.000
Title.TextWrapped = true

Icon.Name = "Icon"
Icon.Parent = Loader
Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Icon.BackgroundTransparency = 1.000
Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
Icon.BorderSizePixel = 0
Icon.Position = UDim2.new(0.204713166, 0, 0.150094211, 0)
Icon.Size = UDim2.new(0.587233484, 0, 0.570441484, 0)
Icon.Image = "rbxassetid://16591520014"
Icon.ScaleType = Enum.ScaleType.Fit

TextButton.Parent = Loader
TextButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.0588240735, 0, 0.843049407, 0)
TextButton.Size = UDim2.new(0.880605102, 0, 0.111362115, 0)
TextButton.Font = Enum.Font.GothamBold
TextButton.Text = "LOAD ECLIPSE.LOL"
TextButton.TextColor3 = Color3.fromRGB(159, 88, 252)
TextButton.TextSize = 14.000
TextButton.TextWrapped = true
TextButton.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/dementiaenjoyer/eclipse.lol/main/universal.lua"))()
	EclipseLoader:Destroy()
end)

UICorner_2.CornerRadius = UDim.new(0, 3)
UICorner_2.Parent = TextButton
