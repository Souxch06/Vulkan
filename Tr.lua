-- =========================================
--  Floating Hub Bubble UI + ESP BEST
-- =========================================

if getgenv().HubUI then return end
getgenv().HubUI = true

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
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

-- =========================================
-- DRAG SYSTEM
-- =========================================
local function makeDraggable(handle, frame)
	local dragging = false
	local dragStart, startPos

	handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = i.Position
			startPos = frame.Position
		end
	end)

	handle.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- =========================================
-- PANEL INFINITE JUMP
-- =========================================
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0,300*scale,0,400*scale)
panel.Position = UDim2.new(0.5,-150*scale,0.5,-200*scale)
panel.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
panel.BorderSizePixel = 0
Instance.new("UICorner", panel).CornerRadius = UDim.new(0,15)

local topBar = Instance.new("Frame", panel)
topBar.Size = UDim2.new(1,0,0,40)
topBar.BackgroundColor3 = Color3.fromRGB(110, 0, 160)
topBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "MY HUB"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local infJumpBtn = Instance.new("TextButton", panel)
infJumpBtn.Size = UDim2.new(0.8,0,0,50)
infJumpBtn.Position = UDim2.new(0.1,0,0.25,0)
infJumpBtn.Text = "Infinite Jump"
infJumpBtn.BackgroundColor3 = Color3.fromRGB(130,0,180)
infJumpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", infJumpBtn)

-- =========================================
-- SETTINGS PANEL (ESP)
-- =========================================
local settingsPanel = Instance.new("Frame", gui)
settingsPanel.Size = panel.Size
settingsPanel.Position = UDim2.new(0.55,0,0.5,0)
settingsPanel.BackgroundColor3 = Color3.fromRGB(55, 0, 100)
settingsPanel.Visible = false
settingsPanel.BorderSizePixel = 0
Instance.new("UICorner", settingsPanel).CornerRadius = UDim.new(0,15)

local settingsTop = Instance.new("Frame", settingsPanel)
settingsTop.Size = topBar.Size
settingsTop.BackgroundColor3 = Color3.fromRGB(90, 0, 150)
settingsTop.BorderSizePixel = 0

local settingsTitle = Instance.new("TextLabel", settingsTop)
settingsTitle.Size = UDim2.new(1,0,1,0)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "SETTINGS / ESP"
settingsTitle.TextColor3 = Color3.new(1,1,1)
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextScaled = true

-- =========================================
-- ESP BEST TOGGLE
-- =========================================
local espBestEnabled = true

local espBestBtn = Instance.new("TextButton", settingsPanel)
espBestBtn.Size = UDim2.new(0.85,0,0,45)
espBestBtn.Position = UDim2.new(0.075,0,0.25,0)
espBestBtn.Text = "ESP BEST : ON"
espBestBtn.BackgroundColor3 = Color3.fromRGB(160,50,230)
espBestBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", espBestBtn)

espBestBtn.MouseButton1Click:Connect(function()
	espBestEnabled = not espBestEnabled
	espBestBtn.Text = "ESP BEST : "..(espBestEnabled and "ON" or "OFF")
	espBestBtn.BackgroundColor3 = espBestEnabled 
		and Color3.fromRGB(160,50,230) 
		or Color3.fromRGB(90,90,90)
end)

-- =========================================
-- ESP BEST SYSTEM (AUTO-DETECTION)
-- =========================================
local espLabel

local function clearESP()
	if espLabel then
		espLabel:Destroy()
		espLabel = nil
	end
end

local function getBestBrainrot()
	local best, bestValue = nil, 0

	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") then
			local value = v:FindFirstChild("Value") or v:FindFirstChild("Amount") or v:FindFirstChild("Money")
			if value and value:IsA("NumberValue") then
				if value.Value > bestValue then
					bestValue = value.Value
					best = v
				end
			end
		end
	end

	return best, bestValue
end

RunService.RenderStepped:Connect(function()
	if not espBestEnabled then
		clearESP()
		return
	end

	local best, value = getBestBrainrot()

	if best and best:FindFirstChild("HumanoidRootPart") then
		if not espLabel then
			espLabel = Instance.new("BillboardGui", best.HumanoidRootPart)
			espLabel.Size = UDim2.new(0,200,0,50)
			espLabel.AlwaysOnTop = true

			local txt = Instance.new("TextLabel", espLabel)
			txt.Size = UDim2.new(1,0,1,0)
			txt.BackgroundTransparency = 1
			txt.TextColor3 = Color3.fromRGB(255, 0, 255)
			txt.TextStrokeTransparency = 0
			txt.Font = Enum.Font.GothamBold
			txt.TextScaled = true
			txt.Name = "TXT"
		end

		espLabel.Parent = best.HumanoidRootPart
		espLabel.TXT.Text = best.Name.." | "..math.floor(value).."/s"
	else
		clearESP()
	end
end)

-- =========================================
-- BULLE AGRANDIE
-- =========================================
local bubble = Instance.new("ImageButton", gui)
bubble.Size = UDim2.new(0,70*scale,0,70*scale) -- AGRANDIE ✅
bubble.Position = UDim2.new(0.02,0,0.8,0)
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
		and Color3.fromRGB(190,80,255)
		or Color3.fromRGB(130,0,180)
end)

UIS.JumpRequest:Connect(function()
	if not infJumpEnabled then return end
	if tick() - lastJump < 0.2 then return end
	lastJump = tick()

	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.Velocity = Vector3.new(0,65,0)
	end
end)

-- =========================================
-- ENABLE DRAG
-- =========================================
makeDraggable(topBar, panel)
makeDraggable(settingsTop, settingsPanel)
makeDraggable(bubble, bubble)
