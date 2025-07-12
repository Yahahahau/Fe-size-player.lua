--[[
========= SERVER SCRIPT =========
วางใน ServerScriptService
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Remote = Instance.new("RemoteEvent")
Remote.Name = "SizeChangeEvent"
Remote.Parent = ReplicatedStorage

local function scaleCharacter(pchar, size)
	if not pchar then return end
	for _, part in pairs(pchar:GetChildren()) do
		if part:IsA("BasePart") then
			part.Size = Vector3.new(2, 2, 1) * size
		end
	end
end

Remote.OnServerEvent:Connect(function(player, size)
	local char = player.Character
	if char then
		scaleCharacter(char, size)
	end
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		wait(0.5)
		scaleCharacter(char, 1)
	end)
end)

--[[
========= CLIENT SCRIPT =========
วางใน StarterPlayerScripts
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Remote = ReplicatedStorage:WaitForChild("SizeChangeEvent")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local size = 1

local gui = Instance.new("ScreenGui", player.PlayerGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 130)
frame.Position = UDim2.new(0.5, -100, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 0, 30)
label.Text = "Size: " .. size
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundTransparency = 1
label.Font = Enum.Font.SourceSansBold
label.TextScaled = true

local plus = Instance.new("TextButton", frame)
plus.Size = UDim2.new(0.5, -5, 0, 50)
plus.Position = UDim2.new(0, 5, 0, 35)
plus.Text = "+.1"
plus.Font = Enum.Font.SourceSansBold
plus.TextScaled = true
plus.BackgroundColor3 = Color3.fromRGB(0, 180, 0)

local minus = Instance.new("TextButton", frame)
minus.Size = UDim2.new(0.5, -5, 0, 50)
minus.Position = UDim2.new(0.5, 0, 0, 35)
minus.Text = "-.1"
minus.Font = Enum.Font.SourceSansBold
minus.TextScaled = true
minus.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

plus.MouseButton1Click:Connect(function()
	size = size + 0.1
	label.Text = "Size: " .. string.format("%.1f", size)
	Remote:FireServer(size)
end)

minus.MouseButton1Click:Connect(function()
	size = size - 0.1
	if size < 0.5 then size = 0.5 end
	label.Text = "Size: " .. string.format("%.1f", size)
	Remote:FireServer(size)
end)

player.CharacterAdded:Connect(function(newChar)
	char = newChar
	wait(0.5)
	Remote:FireServer(size)
end)
