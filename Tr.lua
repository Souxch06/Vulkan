-- =========================================
--  Floating Hub Bubble UI - Violet & Responsive
-- =========================================

if getgenv().HubUI then return end
getgenv().HubUI = true

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
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
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "HubBubbleUI"
gui.ResetOnSpawn = false

-- ===== PANEL PRINCIPAL (Infinite Jump) =====
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 300*scale, 0, 400*scale)
panel.Position = UDim2.new(0.5, -150*scale, 0.5, -200*scale)
panel.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
panel.Visible = true -- déjà ouvert
panel.BorderSizePixel = 0
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 15)

local stroke = Instance.new("UIStroke", panel)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(200, 150, 255)

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1,0,0,40*scale)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "MY HUB"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- Bouton Infinite Jump
local infJumpBtn = Instance.new("TextButton", panel)
infJumpBtn.Size = UDim2.new(0.8, 0, 0, 50*scale)
infJumpBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
infJumpBtn.Text = "Infinite Jump"
infJumpBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 180)
infJumpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", infJumpBtn)

-- ===== PANEL PARAMETRES (vide pour l'instant) =====
local settingsPanel = Instance.new("Frame", gui)
settingsPanel.Size = UDim2.new(0, 300*scale, 0, 400*scale)
settingsPanel.Position = UDim2.new(0.5, -150*scale, 0.5, -200*scale)
settingsPanel.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
settingsPanel.Visible = false
settingsPanel.BorderSizePixel = 0
Instance.new("UICorner", settingsPanel).CornerRadius = UDim.new(0, 15)

-- ===== BUBBLE =====
local bubble = Instance.new("ImageButton", gui)
bubble.Size = UDim2.new(0, 50*scale, 0, 50*scale)
bubble.Position = UDim2.new(0.02, 0, 0.8, 0)
bubble.BackgroundColor3 = Color3.fromRGB(130,0,180)
bubble.Image = "" -- mets ton logo ici en URL si tu veux
bubble.BorderSizePixel = 0
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1,0)

-- ===== CLICK BUBBLE =====
bubble.MouseButton1Click:Connect(function()
	settingsPanel.Visible = not settingsPanel.Visible
end)

-- ===== LOGIQUE INFINITE JUMP =====
local UIS = game:GetService("UserInputService")
local infJumpEnabled = false
local lastJump = 0
local JUMP_FORCE = 65

infJumpBtn.MouseButton1Click:Connect(function()
	infJumpEnabled = not infJumpEnabled
	infJumpBtn.BackgroundColor3 = infJumpEnabled 
		and Color3.fromRGB(180,50,220) 
		or Color3.fromRGB(130,0,180)
end)

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

-- ===== DRAG PERSONNALISE =====
local function makeDraggable(frame)
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

	UIS.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- Appliquer aux panels et à la bulle
makeDraggable(panel)
makeDraggable(settingsPanel)
makeDraggable(bubble)
