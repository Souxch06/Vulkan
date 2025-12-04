-- =========================================
-- Floating Hub Bubble UI - FINAL FIX
-- =========================================

if getgenv().HubUI then return end
getgenv().HubUI = true

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
repeat task.wait() until player

-- ================= SCALE =================
local cam = workspace.CurrentCamera
local screenSize = cam.ViewportSize
local scale = math.clamp(math.min(screenSize.X / 1920, screenSize.Y / 1080), 0.7, 1)

-- ============ REMOVE OLD GUI ============
pcall(function()
	if CoreGui:FindFirstChild("HubBubbleUI") then
		CoreGui.HubBubbleUI:Destroy()
	end
end)

-- ================ GUI ===================
local gui = Instance.new("ScreenGui")
gui.Name = "HubBubbleUI"
gui.Parent = CoreGui
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- ============ DRAG SYSTEM (STABLE) ============
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
-- PANEL INFINITE JUMP
-- =========================================
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 320*scale, 0, 420*scale)
panel.Position = UDim2.new(0.45, 0, 0.3, 0)
panel.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
panel.BorderSizePixel = 0
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 16)

local topBar = Instance.new("Frame", panel)
topBar.Size = UDim2.new(1,0,0,42)
topBar.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
topBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "MY HUB"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local infJumpBtn = Instance.new("TextButton", panel)
infJumpBtn.Size = UDim2.new(0.85,0,0,50)
infJumpBtn.Position = UDim2.new(0.075,0,0.25,0)
infJumpBtn.Text = "Infinite Jump : OFF"
infJumpBtn.BackgroundColor3 = Color3.fromRGB(120,120,120) -- OFF par défaut
infJumpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", infJumpBtn)

-- =========================================
-- SETTINGS PANEL
-- =========================================
local settingsPanel = Instance.new("Frame", gui)
settingsPanel.Size = panel.Size
settingsPanel.Position = UDim2.new(0.55, 0, 0.32, 0)
settingsPanel.BackgroundColor3 = Color3.fromRGB(55, 0, 105)
settingsPanel.BorderSizePixel = 0
settingsPanel.Visible = false
Instance.new("UICorner", settingsPanel).CornerRadius = UDim.new(0, 16)

local settingsTop = Instance.new("Frame", settingsPanel)
settingsTop.Size = topBar.Size
settingsTop.BackgroundColor3 = Color3.fromRGB(95, 0, 150)
settingsTop.BorderSizePixel = 0

local settingsTitle = Instance.new("TextLabel", settingsTop)
settingsTitle.Size = UDim2.new(1,0,1,0)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "SETTINGS / ESP"
settingsTitle.TextColor3 = Color3.new(1,1,1)
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextScaled = true

-- ============ ESP BEST TOGGLE (OFF DEFAULT) ============
local espBestEnabled = false

local espBestBtn = Instance.new("TextButton", settingsPanel)
espBestBtn.Size = UDim2.new(0.85,0,0,46)
espBestBtn.Position = UDim2.new(0.075,0,0.25,0)
espBestBtn.Text = "ESP BEST : OFF"
espBestBtn.BackgroundColor3 = Color3.fromRGB(120,120,120)
espBestBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", espBestBtn)

espBestBtn.MouseButton1Click:Connect(function()
	espBestEnabled = not espBestEnabled
	espBestBtn.Text = "ESP BEST : "..(espBestEnabled and "ON" or "OFF")
	espBestBtn.BackgroundColor3 = espBestEnabled 
		and Color3.fromRGB(170,70,255)
		or Color3.fromRGB(120,120,120)
end)

-- =========================================
-- ESP BEST SYSTEM (CORRIGÉ)
-- =========================================
local currentESP

local function clearESP()
	if currentESP then
		currentESP:Destroy()
		currentESP = nil
	end
end

local function getBestBrainrot()
	local best, bestValue = nil, 0

	for _,obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") then
			for _,v in ipairs(obj:GetChildren()) do
				if v:IsA("NumberValue") and (string.find(v.Name:lower(), "sec") or string.find(v.Name:lower(), "rate") or string.find(v.Name:lower(), "s")) then
					if v.Value > bestValue then
						bestValue = v.Value
						best = obj
					end
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
	if not best then
		clearESP()
		return
	end

	local root = best:FindFirstChild("HumanoidRootPart") or best:FindFirstChildWhichIsA("BasePart")
	if not root then
		clearESP()
		return
	end

	if not currentESP then
		currentESP = Instance.new("BillboardGui")
		currentESP.Size = UDim2.new(0, 220, 0, 45)
		currentESP.AlwaysOnTop = true
		currentESP.Parent = root

		local txt = Instance.new("TextLabel", currentESP)
		txt.Size = UDim2.new(1,0,1,0)
		txt.BackgroundTransparency = 1
		txt.TextColor3 = Color3.fromRGB(255, 0, 255)
		txt.TextStrokeTransparency = 0
		txt.Font = Enum.Font.GothamBold
		txt.TextScaled = true
		txt.Name = "TXT"
	end

	currentESP.Parent = root
	currentESP.TXT.Text = best.Name.." | "..math.floor(value).."/s"
end)

-- =========================================
-- BULLE AGRANDIE
-- =========================================
local bubble = Instance.new("ImageButton", gui)
bubble.Size = UDim2.new(0, 80*scale, 0, 80*scale) -- AGRANDIE ✅
bubble.Position = UDim2.new(0.02, 0, 0.8, 0)
bubble.BackgroundColor3 = Color3.fromRGB(140, 0, 200)
bubble.Image = ""
bubble.BorderSizePixel = 0
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1,0)

bubble.MouseButton1Click:Connect(function()
	settingsPanel.Visible = not settingsPanel.Visible
end)

-- =========================================
-- INFINITE JUMP (OFF PAR DÉFAUT)
-- =========================================
local infJumpEnabled = false
local lastJump = 0

infJumpBtn.MouseButton1Click:Connect(function()
	infJumpEnabled = not infJumpEnabled
	infJumpBtn.Text = "Infinite Jump : "..(infJumpEnabled and "ON" or "OFF")
	infJumpBtn.BackgroundColor3 = infJumpEnabled 
		and Color3.fromRGB(190,80,255)
		or Color3.fromRGB(120,120,120)
end)

UIS.JumpRequest:Connect(function()
	if not infJumpEnabled then return end
	if tick() - lastJump < 0.25 then return end
	lastJump = tick()

	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.Velocity = Vector3.new(0, 70, 0)
	end
end)

-- =========================================
-- ACTIVER LE DRAG (RÉEL)
-- =========================================
makeDraggable(topBar, panel)
makeDraggable(settingsTop, settingsPanel)
makeDraggable(bubble, bubble)
