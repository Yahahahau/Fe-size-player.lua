-- 📌 LocalScript: ใส่ใน StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local remoteName = "ScaleCharacterEvent"

-- สร้าง RemoteEvent ฝั่งเซิร์ฟ (ถ้ายังไม่มี)
if RunService:IsClient() and not ReplicatedStorage:FindFirstChild(remoteName) then
    local remote = Instance.new("RemoteEvent")
    remote.Name = remoteName
    remote.Parent = ReplicatedStorage

    -- ฟังก์ชันฝั่งเซิร์ฟรับคำสั่ง
    remote.OnServerEvent:Connect(function(plr, scale)
        if scale < 0.5 then scale = 0.5 end
        if scale > 3 then scale = 3 end

        local character = plr.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Size = part.Size * scale
                        part.Position = part.Position + Vector3.new(0, (scale-1)*part.Size.Y/2, 0)
                    end
                end
            end
        end
    end)
end

local RemoteEvent = ReplicatedStorage:WaitForChild(remoteName)
local scale = 1

-- สร้าง UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScaleUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 150, 0, 50)
Frame.Position = UDim2.new(0.5, -75, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local MinusBtn = Instance.new("TextButton")
MinusBtn.Size = UDim2.new(0, 50, 1, 0)
MinusBtn.Position = UDim2.new(0, 0, 0, 0)
MinusBtn.Text = "-"
MinusBtn.Font = Enum.Font.SourceSansBold
MinusBtn.TextSize = 40
MinusBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
MinusBtn.TextColor3 = Color3.new(1, 1, 1)
MinusBtn.Parent = Frame

local PlusBtn = Instance.new("TextButton")
PlusBtn.Size = UDim2.new(0, 50, 1, 0)
PlusBtn.Position = UDim2.new(1, -50, 0, 0)
PlusBtn.Text = "+"
PlusBtn.Font = Enum.Font.SourceSansBold
PlusBtn.TextSize = 40
PlusBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
PlusBtn.TextColor3 = Color3.new(1, 1, 1)
PlusBtn.Parent = Frame

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(0, 50, 1, 0)
Label.Position = UDim2.new(0.5, -25, 0, 0)
Label.Text = tostring(scale)
Label.Font = Enum.Font.SourceSansBold
Label.TextSize = 30
Label.BackgroundTransparency = 1
Label.TextColor3 = Color3.new(1, 1, 1)
Label.Parent = Frame

-- ปรับขนาดตัวละคร
local function updateScale(newScale)
    if newScale < 0.5 then newScale = 0.5 end
    if newScale > 3 then newScale = 3 end

    scale = newScale
    Label.Text = string.format("%.1f", scale)
    RemoteEvent:FireServer(scale)
end

MinusBtn.MouseButton1Click:Connect(function()
    updateScale(scale - 0.1)
end)

PlusBtn.MouseButton1Click:Connect(function()
    updateScale(scale + 0.1)
end)
