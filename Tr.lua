-- =========================================
--  ULTIMATE SPEED + SAFE INFINITE JUMP UI
-- =========================================

if getgenv().MovementPanelLoaded then return end
getgenv().MovementPanelLoaded = true

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
repeat task.wait() until player

-- ===== SETTINGS =====
local NORMAL_SPEED = 16
local BOOST_SPEED = 75      -- BOOST clair
local JUMP_FORCE = 65       -- Force du saut infini

local speedEnabled = false
local infJumpEnabled = false

-- ===== HUMANOID / ROOT =====
local function getHumanoid()
	if player.Character then
		return player.Character:FindFirstChildOfClass("Humanoid")
	end
end

local function getRoot()
	if player.Character then
		return player.Character:FindFirstChild("HumanoidRootPart")
	end
end

-- ===== APPLY SPEED (force chaque frame) =====
RunService.RenderStepped:Connect(function()
	local hum = getHumanoid()
	if hum and speedEnabled then
		hum.WalkSpeed = BOOST_SPEED
	elseif hum then
		hum.WalkSpeed = NORMAL_SPEED
	end
end)

-- ===== UI =====
pcall(function()
	if CoreGui:FindFirstChild("UltimateMovementUI") then
		CoreGui.UltimateMovementUI:Destroy()
	end
end)

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "UltimateMovementUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 270, 0, 200)
frame.Position = UDim2.new(0.05, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0, 170, 255)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Movement Panel"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

-- SPEED BUTTON
local speedBtn = Instance.new("TextButton", frame)
speedBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
speedBtn.Size = UDim2.new(0.8, 0, 0, 50)
speedBtn.Text = "Speed : OFF"
speedBtn.TextScaled = true
speedBtn.Font = Enum.Font.GothamSemibold
speedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", speedBtn)

-- INFINITE JUMP BUTTON
local jumpBtn = Instance.new("TextButton", frame)
jumpBtn.Position = UDim2.new(0.1, 0, 0.62, 0)
jumpBtn.Size = UDim2.new(0.8, 0, 0, 50)
jumpBtn.Text = "Infinite Jump : OFF"
jumpBtn.TextScaled = true
jumpBtn.Font = Enum.Font.GothamSemibold
jumpBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
jumpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", jumpBtn)

-- ===== BUTTON LOGIC =====
speedBtn.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	speedBtn.Text = speedEnabled and "Speed : ON" or "Speed : OFF"
	speedBtn.BackgroundColor3 = speedEnabled
		and Color3.fromRGB(0, 170, 0)
		or Color3.fromRGB(60, 60, 60)
end)

jumpBtn.MouseButton1Click:Connect(function()
	infJumpEnabled = not infJumpEnabled
	jumpBtn.Text = infJumpEnabled and "Infinite Jump : ON" or "Infinite Jump : OFF"
	jumpBtn.BackgroundColor3 = infJumpEnabled
		and Color3.fromRGB(0, 170, 0)
		or Color3.fromRGB(60, 60, 60)
end)

-- ===== SAFE INFINITE JUMP =====
local lastJump = 0
UIS.JumpRequest:Connect(function()
	if not infJumpEnabled then return end
	if tick() - lastJump < 0.2 then return end
	lastJump = tick()

	local root = getRoot()
	if root then
		root.Velocity = Vector3.new(
			root.Velocity.X,
			JUMP_FORCE,
			root.Velocity.Z
		)
	end
end)
