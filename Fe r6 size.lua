local Players = game:GetService("Players")

local defaultSize = Vector3.new(2, 2, 1)

local function scaleCharacter(character, scale)
	if not character then return end
	for _, part in pairs(character:GetChildren()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			part.Size = defaultSize * scale
		end
	end
end

Players.PlayerAdded:Connect(function(player)
	-- ตัวแปรขนาด
	local scale = 1

	player.CharacterAdded:Connect(function(character)
		wait(1)
		scaleCharacter(character, scale)

		-- สร้าง UI
		local gui = Instance.new("ScreenGui")
		gui.ResetOnSpawn = false
		gui.Parent = player:WaitForChild("PlayerGui")

		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(0, 220, 0, 70)
		frame.Position = UDim2.new(0.5, -110, 0.1, 0)
		frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		frame.BackgroundTransparency = 0.1
		frame.Active = true
		frame.Draggable = true
		frame.Parent = gui

		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(0, 12)
		UICorner.Parent = frame

		local minusBtn = Instance.new("TextButton")
		minusBtn.Size = UDim2.new(0, 60, 0, 60)
		minusBtn.Position = UDim2.new(0, 10, 0, 5)
		minusBtn.Text = "-"
		minusBtn.Font = Enum.Font.SourceSansBold
		minusBtn.TextSize = 50
		minusBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
		minusBtn.TextColor3 = Color3.new(1,1,1)
		minusBtn.Parent = frame
		Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 10)

		local plusBtn = Instance.new("TextButton")
		plusBtn.Size = UDim2.new(0, 60, 0, 60)
		plusBtn.Position = UDim2.new(1, -70, 0, 5)
		plusBtn.Text = "+"
		plusBtn.Font = Enum.Font.SourceSansBold
		plusBtn.TextSize = 50
		plusBtn.BackgroundColor3 = Color3.fromRGB(30, 180, 30)
		plusBtn.TextColor3 = Color3.new(1,1,1)
		plusBtn.Parent = frame
		Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 10)

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0, 80, 0, 60)
		label.Position = UDim2.new(0.5, -40, 0, 5)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.new(1,1,1)
		label.TextScaled = true
		label.Font = Enum.Font.SourceSansBold
		label.Text = tostring(scale)
		label.Parent = frame

		-- ปุ่มกดเพิ่มลดขนาด
		minusBtn.MouseButton1Click:Connect(function()
			scale = math.max(0.5, scale - 0.1)
			label.Text = string.format("%.1f", scale)
			scaleCharacter(character, scale)
		end)

		plusBtn.MouseButton1Click:Connect(function()
			scale = math.min(3, scale + 0.1)
			label.Text = string.format("%.1f", scale)
			scaleCharacter(character, scale)
		end)
	end)
end)
