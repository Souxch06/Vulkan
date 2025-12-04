-- =========================================
-- HUB UI COMPLET - ESP BEST + INF JUMP
-- =========================================

if getgenv().HubUI then return end
getgenv().HubUI = true

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
repeat task.wait() until player

pcall(function()
	if CoreGui:FindFirstChild("HubBubbleUI") then
		CoreGui.HubBubbleUI:Destroy()
	end
end)

-- === SCALE ===
local screenSize = workspace.CurrentCamera.ViewportSize
local scale = math.clamp(math.min(screenSize.X / 1920, screenSize.Y / 1080), 0.6, 0.9)

local ON_COLOR = Color3.fromRGB(180, 80, 255)
local OFF_COLOR = Color3.fromRGB(90, 0, 130)

-- === GUI ROOT ===
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "HubBubbleUI"
gui.ResetOnSpawn = false

-- === DRAG FUNCTION PRO (NE BLOQUE JAMAIS) ===
local function makeDraggable(frame)
	local dragging, dragInput, startPos, startInput

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			startInput = input.Position
			startPos = frame.Position
		end
	end)

	frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - startInput
			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- =========================================
-- === PANEL PRINCIPAL (INF JUMP) ==========
-- =========================================

local mainPanel = Instance.new("Frame", gui)
mainPanel.Size = UDim2.new(0, 240*scale, 0, 150*scale)
mainPanel.Position = UDim2.new(1, -260*scale, 0, 20)
mainPanel.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
mainPanel.BorderSizePixel = 0
Instance.new("UICorner", mainPanel).CornerRadius = UDim.new(0, 12)
makeDraggable(mainPanel)

local title1 = Instance.new("TextLabel", mainPanel)
title1.Size = UDim2.new(1,0,0,30)
title1.BackgroundTransparency = 1
title1.Text = "MAIN"
title1.TextColor3 = Color3.new(1,1,1)
title1.TextScaled = true
title1.Font = Enum.Font.GothamBold

local infJumpBtn = Instance.new("TextButton", mainPanel)
infJumpBtn.Size = UDim2.new(0.8,0,0,35)
infJumpBtn.Position = UDim2.new(0.1,0,0.4,0)
infJumpBtn.Text = "Infinite Jump"
infJumpBtn.BackgroundColor3 = OFF_COLOR
infJumpBtn.TextColor3 = Color3.new(1,1,1)
infJumpBtn.TextScaled = true
Instance.new("UICorner", infJumpBtn)

-- =========================================
-- === PANEL ESP ==========================
-- =========================================

local espPanel = Instance.new("Frame", gui)
espPanel.Size = UDim2.new(0, 240*scale, 0, 150*scale)
espPanel.Position = UDim2.new(0.5, -120*scale, 0.5, -75*scale)
espPanel.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
espPanel.Visible = false
espPanel.BorderSizePixel = 0
Instance.new("UICorner", espPanel).CornerRadius = UDim.new(0, 12)
makeDraggable(espPanel)

local title2 = Instance.new("TextLabel", espPanel)
title2.Size = UDim2.new(1,0,0,30)
title2.BackgroundTransparency = 1
title2.Text = "ESP"
title2.TextColor3 = Color3.new(1,1,1)
title2.TextScaled = true
title2.Font = Enum.Font.GothamBold

local espBestBtn = Instance.new("TextButton", espPanel)
espBestBtn.Size = UDim2.new(0.8,0,0,35)
espBestBtn.Position = UDim2.new(0.1,0,0.4,0)
espBestBtn.Text = "ESP BEST"
espBestBtn.BackgroundColor3 = OFF_COLOR
espBestBtn.TextColor3 = Color3.new(1,1,1)
espBestBtn.TextScaled = true
Instance.new("UICorner", espBestBtn)

-- =========================================
-- === BULLE VIOLETTE =====================
-- =========================================

local bubble = Instance.new("ImageButton", gui)
bubble.Size = UDim2.new(0, 42*scale, 0, 42*scale)
bubble.Position = UDim2.new(0.02, 0, 0.5, 0)
bubble.BackgroundColor3 = Color3.fromRGB(130, 0, 180)
bubble.Image = ""
bubble.BorderSizePixel = 0
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1,0)
makeDraggable(bubble)

bubble.MouseButton1Click:Connect(function()
	espPanel.Visible = not espPanel.Visible
end)

-- =========================================
-- === INFINITE JUMP ======================
-- =========================================

local infJumpEnabled = false
local lastJump = 0

infJumpBtn.MouseButton1Click:Connect(function()
	infJumpEnabled = not infJumpEnabled
	infJumpBtn.BackgroundColor3 = infJumpEnabled and ON_COLOR or OFF_COLOR
end)

UIS.JumpRequest:Connect(function()
	if not infJumpEnabled then return end
	if tick() - lastJump < 0.2 then return end
	lastJump = tick()

	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if root then
		root.Velocity = Vector3.new(root.Velocity.X, 60, root.Velocity.Z)
	end
-- ===== ESP BEST MOBILE - BASE / STRUCTURE =====

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

local espEnabled = true
local highlight, billboard

local function clearESP()
	if highlight then pcall(function() highlight:Destroy() end) end
	if billboard then pcall(function() billboard:Destroy() end) end
	highlight = nil
	billboard = nil
end

local function findBestBase()
	for _,obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("BillboardGui") then
			local txt = obj:FindFirstChildWhichIsA("TextLabel", true)
			if txt and txt.Text and txt.Text:lower():find("best") then
				if obj.Adornee then
					return obj.Adornee, txt.Text
				end
			end
		end
	end
	return nil
end

local function attachESP(part, text)
	clearESP()

	-- Highlight
	highlight = Instance.new("Highlight")
	highlight.Adornee = part
	highlight.FillColor = Color3.fromRGB(180,80,255)
	highlight.OutlineColor = Color3.new(1,1,1)
	highlight.Parent = CoreGui

	-- Billboard perso
	billboard = Instance.new("BillboardGui")
	billboard.Adornee = part
	billboard.Size = UDim2.new(0, 220, 0, 70)
	billboard.AlwaysOnTop = true
	billboard.Parent = CoreGui

	local lbl = Instance.new("TextLabel", billboard)
	lbl.Size = UDim2.new(1,0,1,0)
	lbl.BackgroundColor3 = Color3.fromRGB(85,0,127)
	lbl.BackgroundTransparency = 0.15
	lbl.TextColor3 = Color3.new(1,1,1)
	lbl.TextScaled = true
	lbl.Font = Enum.Font.GothamBold
	lbl.Text = text or "BEST"
	Instance.new("UICorner", lbl)
end

-- Scan en continu (mobile safe)
RunService.Heartbeat:Connect(function()
	if not espEnabled then return end
	local part, text = findBestBase()
	if part then
		if not highlight or highlight.Adornee ~= part then
			attachESP(part, text)
		end
	end
end)
