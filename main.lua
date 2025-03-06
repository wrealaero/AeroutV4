shared.vape = nil -- Prevent Vape from loading before key verification
repeat task.wait() until game:IsLoaded() -- Ensure the game is fully loaded

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
        -- Use Vape's notification system if available
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
        
        -- ✅ Load Vape only after key is verified
        vape = loadstring(downloadFile('newvape/guis/'..gui..'.lua'), 'gui')()
        shared.vape = vape
        finishLoading() -- Now it's safe to load Vape
    else
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

-- GUI Dragging
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

-- Animation
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local goal = {Size = UDim2.new(0, 350, 0, 180), Position = UDim2.new(0.5, -175, 0.4, -90)}
local tween = tweenService:Create(frame, tweenInfo, goal)
tween:Play()

if identifyexecutor then
	if table.find({'Argon', 'Wave'}, ({identifyexecutor()})[1]) then
		getgenv().setthreadidentity = nil
	end
end

local vape
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and vape then
		vape:CreateNotification('Vape', 'Failed to load : '..err, 30, 'alert')
	end
	return res
end
local queue_on_teleport = queue_on_teleport or function() end
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local cloneref = cloneref or function(obj)
	return obj
end
local playersService = cloneref(game:GetService('Players'))

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/ImDamc/VapeV4Reborn/refs/heads/main/'..'/'..select(1, path:gsub('newvape/', '')), true)
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

local function finishLoading()
	vape.Init = nil
	vape:Load()
	task.spawn(function()
		repeat
			vape:Save()
			task.wait(10)
		until not vape.Loaded
	end)

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
			if shared.VapeDeveloper then
				teleportScript = 'shared.VapeDeveloper = true\n'..teleportScript
			end
			if shared.VapeCustomProfile then
				teleportScript = 'shared.VapeCustomProfile = "'..shared.VapeCustomProfile..'"\n'..teleportScript
			end
			vape:Save()
			queue_on_teleport(teleportScript)
		end
	end))

	if not shared.vapereload then
		if not vape.Categories then return end
		if vape.Categories.Main.Options['GUI bind indicator'].Enabled then
			vape:CreateNotification('Finished Loading', vape.VapeButton and 'Press the button in the top right to open GUI' or 'Press '..table.concat(vape.Keybind, ' + '):upper()..' to open GUI', 5)
		end
	end
end

if not isfile('newvape/profiles/gui.txt') then
	writefile('newvape/profiles/gui.txt', 'new')
end
local gui = readfile('newvape/profiles/gui.txt')

if not isfolder('newvape/assets/'..gui) then
	makefolder('newvape/assets/'..gui)
end

if not shared.VapeIndependent then
	loadstring(downloadFile('newvape/games/universal.lua'), 'universal')()
	if isfile('newvape/games/'..game.PlaceId..'.lua') then
		loadstring(readfile('newvape/games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(...)
	else
		if not shared.VapeDeveloper then
			local suc, res = pcall(function()
				return game:HttpGet('https://raw.githubusercontent.com/ImDamc/VapeV4Reborn'..readfile('newvape/profiles/commit.txt')..'/games/'..game.PlaceId..'.lua', true)
			end)
			if suc and res ~= '404: Not Found' then
				loadstring(downloadFile('newvape/games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(...)
			end
		end
	end
	finishLoading()
else
	vape.Init = finishLoading
	return vape
end
