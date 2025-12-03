-- =========================================
--  Infinite Jump UI - Violet & Responsive
-- =========================================

if getgenv().InfiniteJumpUI then return end
getgenv().InfiniteJumpUI = true

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
repeat task.wait() until player

-- ===== SETTINGS =====
local infJumpEnabled = false
local JUMP_FORCE = 65

-- ===== UI SCALE =====
local screenSize = workspace.CurrentCamera.ViewportSize
local scale = math.clamp(math.min(screenSize.X / 1920, screenSize.Y / 1080), 0.6, 1)

-- ===== UI =====
pcall(function()
	if CoreGui:FindFirstChild("InfiniteJumpUI") then
		CoreGui.InfiniteJumpUI:Destroy()
	end
end)

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "InfiniteJumpUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250*scale, 0, 100*scale)
frame.Position = UDim2.new(0.02, 0, 0.8, 0)
frame.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(200, 150, 255)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 25*scale)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "Infinite Jump"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local jumpBtn = Instance.new("TextButton", frame)
jumpBtn.Size = UDim2.new(0.8, 0, 0, 40*scale)
jumpBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
jumpBtn.Text = "OFF"
jumpBtn.TextScaled = true
jumpBtn.Font = Enum.Font.GothamSemibold
jumpBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 180)
jumpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", jumpBtn)

-- ===== BUTTON LOGIC =====
jumpBtn.MouseButton1Click:Connect(function()
	infJumpEnabled = not infJumpEnabled
	jumpBtn.Text = infJumpEnabled and "ON" or "OFF"
	jumpBtn.BackgroundColor3 = infJumpEnabled 
		and Color3.fromRGB(180, 50, 220) 
		or Color3.fromRGB(130, 0, 180)
end)

-- ===== SAFE INFINITE JUMP =====
local lastJump = 0
UIS.JumpRequest:Connect(function()
	if not infJumpEnabled then return end
	if tick() - lastJump < 0.2 then return end
	lastJump = tick()

	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hum and root then
		root.Velocity = Vector3.new(root.Velocity.X, JUMP_FORCE, root.Velocity.Z)
	end
end)
