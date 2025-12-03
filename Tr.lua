-- ================================
--  Pretty Speed + Infinite Jump UI
-- ================================

if getgenv().PrettyPanelLoaded then return end
getgenv().PrettyPanelLoaded = true

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
repeat task.wait() until player

-- ===== SETTINGS =====
local NORMAL_SPEED = 16
local BOOST_SPEED = 45

local speedEnabled = false
local infJumpEnabled = false

-- ===== FUNCTIONS =====
local function getHumanoid()
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		return player.Character.Humanoid
	end
end

local function applySpeed()
	local hum = getHumanoid()
	if not hum then return end
	hum.WalkSpeed = speedEnabled and BOOST_SPEED or NORMAL_SPEED
end

player.CharacterAdded:Connect(function()
	task.wait(0.3)
	applySpeed()
end)

task.wait(0.3)
applySpeed()

-- ===== UI CLEAN =====

pcall(function()
	if CoreGui:FindFirstChild("PrettySpeedJump") then
		CoreGui.PrettySpeedJump:Destroy()
	end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "PrettySpeedJump"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 260, 0, 190)
frame.Position = UDim2.new(0.05, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(90, 90, 90)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "Movement Panel"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

-- SPEED BUTTON
local speedBtn = Instance.new("TextButton", frame)
speedBtn.Position = UDim2.new(0.1, 0, 0.28, 0)
speedBtn.Size = UDim2.new(0.8, 0, 0, 45)
speedBtn.Text = "Speed : OFF"
speedBtn.TextScaled = true
speedBtn.Font = Enum.Font.GothamSemibold
speedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", speedBtn).CornerRadius = UDim.new(0, 10)

-- INFINITE JUMP BUTTON
local jumpBtn = Instance.new("TextButton", frame)
jumpBtn.Position = UDim2.new(0.1, 0, 0.58, 0)
jumpBtn.Size = UDim2.new(0.8, 0, 0, 45)
jumpBtn.Text = "Infinite Jump : OFF"
jumpBtn.TextScaled = true
jumpBtn.Font = Enum.Font.GothamSemibold
jumpBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
jumpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", jumpBtn).CornerRadius = UDim.new(0, 10)

-- ===== BUTTON LOGIC =====

speedBtn.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	speedBtn.Text = speedEnabled and "Speed : ON" or "Speed : OFF"
	speedBtn.BackgroundColor3 = speedEnabled 
		and Color3.fromRGB(0, 170, 0) 
		or Color3.fromRGB(60, 60, 60)
	applySpeed()
end)

jumpBtn.MouseButton1Click:Connect(function()
	infJumpEnabled = not infJumpEnabled
	jumpBtn.Text = infJumpEnabled and "Infinite Jump : ON" or "Infinite Jump : OFF"
	jumpBtn.BackgroundColor3 = infJumpEnabled
		and Color3.fromRGB(0, 170, 0)
		or Color3.fromRGB(60, 60, 60)
end)

-- ===== INFINITE JUMP SYSTEM =====

UIS.JumpRequest:Connect(function()
	if not infJumpEnabled then return end
	local hum = getHumanoid()
	if hum then
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)
