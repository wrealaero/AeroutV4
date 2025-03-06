-- Wait for the game to load
repeat task.wait() until game:IsLoaded()

-- Key validation and GUI creation
local validKey = "test1234" -- Change this to your daily key

local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "KeyInputGUI"
screenGui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 350, 0, 180)
frame.Position = UDim2.new(0.5, -175, 0.4, -90)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 3
frame.BorderColor3 = Color3.fromRGB(255, 165, 0) -- Orange border
frame.Visible = true
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Active = true -- Enable dragging
frame.Draggable = true -- Make GUI draggable

-- Title Label
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🔑 ENTER THE KEY"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 22

-- Input TextBox
local textBox = Instance.new("TextBox", frame)
textBox.Size = UDim2.new(0.8, 0, 0, 40)
textBox.Position = UDim2.new(0.1, 0, 0.35, 0)
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.PlaceholderText = "Enter Key..."
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 18
textBox.ClearTextOnFocus = true

-- Submit Button
local submitButton = Instance.new("TextButton", frame)
submitButton.Size = UDim2.new(0.6, 0, 0, 40)
submitButton.Position = UDim2.new(0.2, 0, 0.65, 0)
submitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
submitButton.Text = "Submit"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.Font = Enum.Font.GothamBold
submitButton.TextSize = 20

local function checkKey()
    if textBox.Text == validKey then
        -- Key accepted, load Vape
        if shared.vape then
            shared.vape:CreateNotification("✅ Access Granted", "Key Accepted!", 5, "success")
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "✅ Access Granted";
                Text = "Key Accepted!";
                Duration = 5;
            })
        end

        frame:Destroy() -- Remove the key GUI after successful input
        
        -- Ensure Vape initializes only after key is verified
        vape = loadstring(downloadFile('newvape/guis/'..gui..'.lua'), 'gui')()
        shared.vape = vape
        finishLoading() -- Now it's safe to load Vape
    else
        -- Key denied
        if shared.vape then
            shared.vape:CreateNotification("❌ Access Denied", "Incorrect key! Join .gg/icicle for the key!", 5, "alert")
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "❌ Access Denied";
                Text = "Incorrect key! Join .gg/icicle for the key!";
                Duration = 5;
            })
        end
        textBox.Text = "" -- Clear the text box for retry
    end
end

-- Click submit button
submitButton.MouseButton1Click:Connect(checkKey)

-- Allow Enter key to submit
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Return then
        checkKey()
    end
end)

-- GUI Dragging functionality
local dragging
local dragInput
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

userInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Send the initial notification to join Discord for the key
task.spawn(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🔑 Key Required";
        Text = "Join .gg/icicle for the key!";
        Duration = 8;
    })
end)

-- Animation for GUI
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local goal = {Size = UDim2.new(0, 350, 0, 180), Position = UDim2.new(0.5, -175, 0.4, -90)}
local tween = tweenService:Create(frame, tweenInfo, goal)
tween:Play()

-- Ensure Vape only loads after key is verified
shared.vape = nil
local vape
local loadstring = function(...)
    local res, err = loadstring(...)
    if err and vape then
        vape:CreateNotification('Vape', 'Failed to load : '..err, 30, 'alert')
    end
    return res
end

-- Finish Vape loading after key validation
local function finishLoading()
    vape.Init = nil
    vape:Load()
    task.spawn(function()
        repeat
            vape:Save()
            task.wait(10)
        until not vape.Loaded
    end)

    -- Handle teleport logic
    local teleportedServers
    vape:Clean(playersService.LocalPlayer.OnTeleport:Connect(function()
        if (not teleportedServers) and (not shared.VapeIndependent) then
            teleportedServers = true
            local teleportScript = [[

                repeat task.wait() until game.HttpGet ~= nil

                shared.vapereload = true
                if shared.VapeDeveloper then
                    loadstring(readfile('newvape/loader.lua'), 'loader')()
                else
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/ImDamc/VapeV4Reborn/refs/heads/main/main.lua", true))()
                end
            ]]
            vape:Save()
            queue_on_teleport(teleportScript)
        end
    end))
end
