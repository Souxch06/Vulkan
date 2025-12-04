-- =========================================
-- HUB UI MOBILE + ESP BEST (VERSION STABLE)
-- =========================================

pcall(function()
	if getgenv().__HUB_LOADED then return end
	getgenv().__HUB_LOADED = true
end)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- Sécurité suppression ancienne UI
pcall(function()
	if CoreGui:FindFirstChild("FinalHubUI") then
		CoreGui.FinalHubUI:Destroy()
	end
end)

-- ===== SCALE =====
local cam = workspace.CurrentCamera
local screenSize = cam.ViewportSize
local scale = math.clamp(math.min(screenSize.X / 1920, screenSize.Y / 1080), 0.6, 0.85)

-- ===== GUI ROOT =====
local gui = Instance.new("ScreenGui")
gui.Name = "FinalHubUI"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local ON_COLOR  = Color3.fromRGB(170, 90, 255)
local OFF_COLOR = Color3.fromRGB(80, 80, 80)

-- =========================================
-- DRAG MOBILE (STABLE)
-- =========================================
local function makeDraggable(frame)
	local dragging = false
	local dragInput, dragStart, startPos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
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
		if input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
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
-- MAIN PANEL
-- =========================================
local mainPanel = Instance.new("Frame")
mainPanel.Parent = gui
mainPanel.Size = UDim2.new(0, 220 * scale, 0, 230 * scale)
mainPanel.Position = UDim2.new(1, -240 * scale, 0.08, 0)
mainPanel.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
mainPanel.BorderSizePixel = 0
Instance.new("UICorner", mainPanel)

makeDraggable(mainPanel)

local mainTitle = Instance.new("TextLabel")
mainTitle.Parent = mainPanel
mainTitle.Size = UDim2.new(1, 0, 0, 32 * scale)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "MAIN"
mainTitle.TextColor3 = Color3.new(1,1,1)
mainTitle.Font = Enum.Font.GothamBold
mainTitle.TextScaled = true

-- ===== Infinite Jump Button =====
local infJumpBtn = Instance.new("TextButton")
infJumpBtn.Parent = mainPanel
infJumpBtn.Size = UDim2.new(0.85, 0, 0, 42 * scale)
infJumpBtn.Position = UDim2.new(0.075, 0, 0.25, 0)
infJumpBtn.Text = "Infinite Jump"
infJumpBtn.BackgroundColor3 = OFF_COLOR
infJumpBtn.TextColor3 = Color3.new(1,1,1)
infJumpBtn.Font = Enum.Font.GothamBold
infJumpBtn.TextScaled = true
Instance.new("UICorner", infJumpBtn)

-- =========================================
-- SETTINGS PANEL
-- =========================================
local settingsPanel = Instance.new("Frame")
settingsPanel.Parent = gui
settingsPanel.Size = UDim2.new(0, 220 * scale, 0, 200 * scale)
settingsPanel.Position = UDim2.new(0.5, -110 * scale, 0.5, -100 * scale)
settingsPanel.BackgroundColor3 = Color3.fromRGB(60, 0, 100)
settingsPanel.Visible = false
settingsPanel.BorderSizePixel = 0
Instance.new("UICorner", settingsPanel)

makeDraggable(settingsPanel)

local setTitle = Instance.new("TextLabel")
setTitle.Parent = settingsPanel
setTitle.Size = UDim2.new(1, 0, 0, 30 * scale)
setTitle.BackgroundTransparency = 1
setTitle.Text = "SETTINGS"
setTitle.TextColor3 = Color3.new(1,1,1)
setTitle.Font = Enum.Font.GothamBold
setTitle.TextScaled = true

-- ===== ESP BEST Button =====
local espBtn = Instance.new("TextButton")
espBtn.Parent = settingsPanel
espBtn.Size = UDim2.new(0.85, 0, 0, 42 * scale)
espBtn.Position = UDim2.new(0.075, 0, 0.25, 0)
espBtn.Text = "ESP BEST"
espBtn.BackgroundColor3 = OFF_COLOR
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.Font = Enum.Font.GothamBold
espBtn.TextScaled = true
Instance.new("UICorner", espBtn)

-- =========================================
-- BUBBLE
-- =========================================
local bubble = Instance.new("ImageButton")
bubble.Parent = gui
bubble.Size = UDim2.new(0, 48 * scale, 0, 48 * scale)
bubble.Position = UDim2.new(0.03, 0, 0.7, 0)
bubble.BackgroundColor3 = Color3.fromRGB(140, 0, 200)
bubble.Image = ""
bubble.BorderSizePixel = 0
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1,0)

makeDraggable(bubble)

bubble.MouseButton1Click:Connect(function()
	settingsPanel.Visible = not settingsPanel.Visible
end)

-- =========================================
-- INFINITE JUMP (OFF BY DEFAULT)
-- =========================================
local infJump = false
local lastJump = 0
local JUMP_FORCE = 65

infJumpBtn.MouseButton1Click:Connect(function()
	infJump = not infJump
	infJumpBtn.BackgroundColor3 = infJump and ON_COLOR or OFF_COLOR
end)

UIS.JumpRequest:Connect(function()
	if not infJump then return end
	if tick() - lastJump < 0.2 then return end
	lastJump = tick()

	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if root then
		root.Velocity = Vector3.new(root.Velocity.X, JUMP_FORCE, root.Velocity.Z)
	end
end)

-- =========================================
-- ✅ ESP BEST (SCAN UNIVERSEL RÉEL)
-- =========================================

local espEnabled = false
local highlight, espBillboard
local currentTarget

local function clearESP()
	if highlight then highlight:Destroy() end
	if espBillboard then espBillboard:Destroy() end
	highlight = nil
	espBillboard = nil
	currentTarget = nil
end

-- 🔍 SCAN DU MEILLEUR OBJET
local function findBestBrainrot()
	local bestPart = nil
	local bestValue = -math.huge

	for _, obj in pairs(workspace:GetDescendants()) do
		-- 1️⃣ PRIORITÉ : OBJET AVEC VALEUR
		if obj:IsA("Model") then
			for _, v in pairs(obj:GetDescendants()) do
				if v:IsA("IntValue") or v:IsA("NumberValue") then
					if v.Value > bestValue then
						local main = obj:FindFirstChild("HumanoidRootPart") 
							or obj:FindFirstChildWhichIsA("BasePart")
						if main then
							bestValue = v.Value
							bestPart = main
						end
					end
				end
			end
		end
	end

	-- 2️⃣ FALLBACK : PLUS GROS MODÈLE SI AUCUNE VALEUR
	if not bestPart then
		for _, obj in pairs(workspace:GetChildren()) do
			if obj:IsA("Model") then
				local size = 0
				for _, p in pairs(obj:GetDescendants()) do
					if p:IsA("BasePart") then
						size += p.Size.Magnitude
					end
				end
				if size > bestValue then
					local main = obj:FindFirstChildWhichIsA("BasePart")
					if main then
						bestValue = size
						bestPart = main
					end
				end
			end
		end
	end

	return bestPart, bestValue
end

local function attachESP(part, value)
	clearESP()

	highlight = Instance.new("Highlight")
	highlight.FillColor = Color3.fromRGB(170, 90, 255)
	highlight.OutlineColor = Color3.new(1,1,1)
	highlight.Adornee = part
	highlight.Parent = game.CoreGui

	espBillboard = Instance.new("BillboardGui")
	espBillboard.Adornee = part
	espBillboard.Size = UDim2.new(0, 180, 0, 50)
	espBillboard.AlwaysOnTop = true
	espBillboard.Parent = game.CoreGui

	local lbl = Instance.new("TextLabel")
	lbl.Parent = espBillboard
	lbl.Size = UDim2.new(1,0,1,0)
	lbl.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
	lbl.TextColor3 = Color3.new(1,1,1)
	lbl.TextScaled = true
	lbl.Font = Enum.Font.GothamBold
	lbl.Text = "BEST\n" .. math.floor(value)
	Instance.new("UICorner", lbl)
end

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.BackgroundColor3 = espEnabled and ON_COLOR or OFF_COLOR
	if not espEnabled then
		clearESP()
	end
end)

RunService.Heartbeat:Connect(function()
	if not espEnabled then return end

	local part, value = findBestBrainrot()
	if part and part ~= currentTarget then
		currentTarget = part
		attachESP(part, value)
	end
end)
