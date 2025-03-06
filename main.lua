repeat task.wait() until game:IsLoaded()
if shared.vape then shared.vape:Uninject() end

getgenv().getcustomasset = nil

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

if not isfile('newvape/profiles/gui.txt') then
	writefile('newvape/profiles/gui.txt', 'new')
end
local gui = readfile('newvape/profiles/gui.txt')

if not isfolder('newvape/assets/'..gui) then
	makefolder('newvape/assets/'..gui)
end
vape = loadstring(downloadFile('newvape/guis/'..gui..'.lua'), 'gui')()
shared.vape = vape

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

-- Define key variables
local validKey = "test1234"
local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

-- Create GUI components
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "KeyInputGUI"
screenGui.ResetOnSpawn = false  -- Prevent the GUI from resetting on respawn

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 400, 0, 200)
frame.Position = UDim2.new(0.5, -200, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 6
frame.BorderColor3 = Color3.fromRGB(255, 165, 0)  -- Orange border for a nice highlight effect
frame.Visible = true
frame.AnchorPoint = Vector2.new(0.5, 0.5)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ENTER THE KEY"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextStrokeTransparency = 0.6
title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

local textBox = Instance.new("TextBox", frame)
textBox.Size = UDim2.new(0.8, 0, 0, 40)
textBox.Position = UDim2.new(0.1, 0, 0.3, 0)
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.PlaceholderText = "Enter Key..."
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 18
textBox.TextStrokeTransparency = 0.6
textBox.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
textBox.ClearTextOnFocus = true

local submitButton = Instance.new("TextButton", frame)
submitButton.Size = UDim2.new(0.6, 0, 0, 40)
submitButton.Position = UDim2.new(0.2, 0, 0.7, 0)
submitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)  -- A vibrant blue color for the button
submitButton.Text = "Submit"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.Font = Enum.Font.GothamBold
submitButton.TextSize = 20
submitButton.TextStrokeTransparency = 0.5
submitButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

-- Add visual feedback for key input
local feedbackLabel = Instance.new("TextLabel", frame)
feedbackLabel.Size = UDim2.new(1, 0, 0, 30)
feedbackLabel.Position = UDim2.new(0, 0, 0.85, 0)
feedbackLabel.Text = ""
feedbackLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
feedbackLabel.BackgroundTransparency = 1
feedbackLabel.Font = Enum.Font.Gotham
feedbackLabel.TextSize = 16
feedbackLabel.TextStrokeTransparency = 0.6
feedbackLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

-- Animation to make the frame appear smoothly
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local goal = {Size = UDim2.new(0, 400, 0, 200), Position = UDim2.new(0.5, -200, 0.5, -100)}
local tween = tweenService:Create(frame, tweenInfo, goal)
tween:Play()

-- Function to check the entered key and give feedback
submitButton.MouseButton1Click:Connect(function()
    if textBox.Text == validKey then
        -- Correct key logic
        feedbackLabel.Text = "Access Granted! Key Accepted!"
        feedbackLabel.TextColor3 = Color3.fromRGB(0, 255, 0)  -- Green color for success
        feedbackLabel.TextStrokeTransparency = 0.2
        frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- Optionally change frame color on success
        frame.BorderColor3 = Color3.fromRGB(0, 255, 0)  -- Green border to indicate success

        -- Animation or actions after key validation
        task.wait(1)  -- Brief delay before finishing
        frame:Destroy()  -- Destroy frame after key is accepted
        finishLoading()  -- Call the function to load the rest of the script
    else
        -- Incorrect key logic
        feedbackLabel.Text = "Invalid Key! Try again."
        feedbackLabel.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Red color for failure
        feedbackLabel.TextStrokeTransparency = 0.2
        frame.BackgroundColor3 = Color3.fromRGB(80, 40, 40)  -- Red background on failure
        frame.BorderColor3 = Color3.fromRGB(255, 0, 0)  -- Red border to indicate failure
    end
end)

-- Notify the player with instructions when the GUI loads
task.spawn(function()
    vape:CreateNotification("Key Required", "Join .gg/icicle for the key!", 8, "warning")
end)

-- Make sure the frame stays visible until the player interacts with it
while frame.Parent do
    task.wait()
end
