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
-- ESP BEST (BILLBOARD "BEST")
-- =========================================
local espEnabled = false
local highlight, espBillboard

local function clearESP()
	if highlight then pcall(function() highlight:Destroy() end) end
	if espBillboard then pcall(function() espBillboard:Destroy() end) end
	highlight = nil
	espBillboard = nil
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
end

local function attachESP(part, text)
	clearESP()

	highlight = Instance.new("Highlight")
	highlight.FillColor = ON_COLOR
	highlight.OutlineColor = Color3.new(1,1,1)
	highlight.Adornee = part
	highlight.Parent = gui   -- ✅ IMPORTANT : plus dans CoreGui direct

	espBillboard = Instance.new("BillboardGui")
	espBillboard.Adornee = part
	espBillboard.Size = UDim2.new(0, 200, 0, 60)
	espBillboard.AlwaysOnTop = true
	espBillboard.Parent = gui  -- ✅ IMPORTANT

	local lbl = Instance.new("TextLabel")
	lbl.Parent = espBillboard
	lbl.Size = UDim2.new(1,0,1,0)
	lbl.BackgroundColor3 = Color3.fromRGB(85,0,127)
	lbl.BackgroundTransparency = 0.2
	lbl.TextColor3 = Color3.new(1,1,1)
	lbl.TextScaled = true
	lbl.Font = Enum.Font.GothamBold
	lbl.Text = text or "BEST"
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
	local part, text = findBestBase()
	if part then
		if not highlight or highlight.Adornee ~= part then
			attachESP(part, text)
		end
	end
end)

print("✅ HUB + ESP BEST MOBILE — SCRIPT LOADED SANS ERREUR")
