-- =========================================
--  Floating Hub Bubble UI - Violet & Responsive
-- =========================================

if getgenv().HubUI then return end
getgenv().HubUI = true

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
repeat task.wait() until player

-- ===== SCALE =====
local screenSize = workspace.CurrentCamera.ViewportSize
local scale = math.clamp(math.min(screenSize.X / 1920, screenSize.Y / 1080), 0.6, 1)

-- ===== REMOVE OLD GUI =====
pcall(function()
	if CoreGui:FindFirstChild("HubBubbleUI") then
		CoreGui.HubBubbleUI:Destroy()
	end
end)

-- ===== SCREEN GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "HubBubbleUI"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

-- =========================================
-- DRAG SYSTEM (PROPRE & STABLE)
-- =========================================
local function makeDraggable(handle, frame)
	local dragging = false
	local dragStart, startPos

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)

	handle.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- =========================================
-- PANEL PRINCIPAL (INFINITE JUMP)
-- =========================================
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 300*scale, 0, 400*scale)
panel.Position = UDim2.new(0.5, -150*scale, 0.5, -200*scale)
panel.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
panel.Visible = true
panel.BorderSizePixel = 0
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 15)

-- Barre de déplacement
local topBar = Instance.new("Frame", panel)
topBar.Size = UDim2.new(1,0,0,40)
topBar.BackgroundColor3 = Color3.fromRGB(110, 0, 160)
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "MY HUB"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- Button Infinite Jump
local infJumpBtn = Instance.new("TextButton", panel)
infJumpBtn.Size = UDim2.new(0.8, 0, 0, 50)
infJumpBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
infJumpBtn.Text = "Infinite Jump"
infJumpBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 180)
infJumpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", infJumpBtn)

-- =========================================
-- PANEL PARAMÈTRES
-- =========================================
local settingsPanel = Instance.new("Frame", gui)
settingsPanel.Size = UDim2.new(0, 300*scale, 0, 400*scale)
settingsPanel.Position = UDim2.new(0.45, 0, 0.45, 0)
settingsPanel.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
settingsPanel.Visible = false
settingsPanel.BorderSizePixel = 0
Instance.new("UICorner", settingsPanel).CornerRadius = UDim.new(0, 15)

local settingsTop = Instance.new("Frame", settingsPanel)
settingsTop.Size = UDim2.new(1,0,0,40)
settingsTop.BackgroundColor3 = Color3.fromRGB(90, 0, 150)
settingsTop.BorderSizePixel = 0
Instance.new("UICorner", settingsTop)

local settingsTitle = Instance.new("TextLabel", settingsTop)
settingsTitle.Size = UDim2.new(1,0,1,0)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "SETTINGS"
settingsTitle.TextColor3 = Color3.fromRGB(255,255,255)
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextScaled = true

-- =========================================
-- BUBBLE
-- =========================================
local bubble = Instance.new("ImageButton", gui)
bubble.Size = UDim2.new(0, 50*scale, 0, 50*scale)
bubble.Position = UDim2.new(0.02, 0, 0.8, 0)
bubble.BackgroundColor3 = Color3.fromRGB(130,0,180)
bubble.Image = ""
bubble.BorderSizePixel = 0
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1,0)

bubble.MouseButton1Click:Connect(function()
	settingsPanel.Visible = not settingsPanel.Visible
end)

-- =========================================
-- INFINITE JUMP
-- =========================================
local infJumpEnabled = false
local lastJump = 0

infJumpBtn.MouseButton1Click:Connect(function()
	infJumpEnabled = not infJumpEnabled
	infJumpBtn.BackgroundColor3 = infJumpEnabled 
		and Color3.fromRGB(190, 80, 255)
		or Color3.fromRGB(130, 0, 180)
end)

UIS.JumpRequest:Connect(function()
	if not infJumpEnabled then return end
	if tick() - lastJump < 0.2 then return end
	lastJump = tick()

	local char = player.Character
	if char then
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			root.Velocity = Vector3.new(root.Velocity.X, 65, root.Velocity.Z)
		end
	end
end)

-- =========================================
-- ACTIVER LE DRAG
-- =========================================
makeDraggable(topBar, panel)
makeDraggable(settingsTop, settingsPanel)
makeDraggable(bubble, bubble)
