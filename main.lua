-- Ensure the game is loaded
repeat task.wait() until game:IsLoaded()

if shared.vape then
    shared.vape:Uninject()
end

getgenv().getcustomasset = nil

if identifyexecutor then
    if table.find({'Argon', 'Wave'}, ({identifyexecutor()})[1]) then
        getgenv().setthreadidentity = nil
    end
end

local function downloadFile(path, func)
    if not isfile(path) then
        local suc, res = pcall(function()
            return game:HttpGet('https://raw.githubusercontent.com/wrealaero/AeroutV4/main/'..path:gsub('newvape/', ''), true)
        end)
        if not suc or res == '404: Not Found' then
            error(res)
        end
        if path:find('.lua') then
            res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
        end
        writefile(path, res)
    end
    return (func or readfile)(path)
end

-- Set your key here
local validKey = "MySecretKey123" -- Change this daily if needed

-- Key Input UI Logic
local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

-- Create GUI components
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "KeyInputGUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 400, 0, 200)
frame.Position = UDim2.new(0.5, -200, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 6
frame.BorderColor3 = Color3.fromRGB(255, 165, 0)
frame.Visible = true
frame.AnchorPoint = Vector2.new(0.5, 0.5)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ENTER THE KEY"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 24

local textBox = Instance.new("TextBox", frame)
textBox.Size = UDim2.new(0.8, 0, 0, 40)
textBox.Position = UDim2.new(0.1, 0, 0.3, 0)
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.PlaceholderText = "Enter Key..."
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 18
textBox.ClearTextOnFocus = true

local submitButton = Instance.new("TextButton", frame)
submitButton.Size = UDim2.new(0.6, 0, 0, 40)
submitButton.Position = UDim2.new(0.2, 0, 0.7, 0)
submitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
submitButton.Text = "Submit"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.Font = Enum.Font.GothamBold
submitButton.TextSize = 20

local feedbackLabel = Instance.new("TextLabel", frame)
feedbackLabel.Size = UDim2.new(1, 0, 0, 30)
feedbackLabel.Position = UDim2.new(0, 0, 0.85, 0)
feedbackLabel.Text = ""
feedbackLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
feedbackLabel.BackgroundTransparency = 1
feedbackLabel.Font = Enum.Font.Gotham
feedbackLabel.TextSize = 16

-- Animate the GUI
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local goal = {Size = UDim2.new(0, 400, 0, 200), Position = UDim2.new(0.5, -200, 0.5, -100)}
local tween = tweenService:Create(frame, tweenInfo, goal)
tween:Play()

-- Submit Button Logic
submitButton.MouseButton1Click:Connect(function()
    if textBox.Text == validKey then
        feedbackLabel.Text = "Access Granted! Key Accepted!"
        feedbackLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        frame.BorderColor3 = Color3.fromRGB(0, 255, 0)

        task.wait(1)
        frame:Destroy()

        -- Continue script execution
        loadstring(downloadFile('newvape/games/universal.lua'), 'universal')()
        if isfile('newvape/games/'..game.PlaceId..'.lua') then
            loadstring(readfile('newvape/games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(...)
        else
            warn("Game-specific script not found, running universal script.")
        end
    else
        feedbackLabel.Text = "Invalid Key! Try again."
        feedbackLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        frame.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
        frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Notify user about key
task.spawn(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Key Required";
        Text = "Enter the correct key to continue.";
        Duration = 8;
    })
end)

while frame.Parent do
    task.wait()
end
