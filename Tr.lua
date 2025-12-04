-- =========================================
--   VIOLET HUB + ESP BEST (BILLBOARD SAFE)
-- =========================================

if getgenv().VioletHub then return end
getgenv().VioletHub = true

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
repeat task.wait() until player

-- ===== SCALE MOBILE SAFE =====
local cam = workspace.CurrentCamera
local scale = math.clamp(math.min(cam.ViewportSize.X / 1920, cam.ViewportSize.Y / 1080), 0.55, 0.85)

pcall(function()
	if CoreGui:FindFirstChild("VioletHubUI") then
		CoreGui.VioletHubUI:Destroy()
	end
end)

-- ===== GUI =====
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "VioletHubUI"
gui.ResetOnSpawn = false

-- =========================================
--  DRAG FUNCTION (MOBILE SAFE)
-- =========================================
local function makeDraggable(frame)
	local dragging, dragInput, startPos, startUIPos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			startPos = input.Position
			startUIPos = frame.Position
		end
	end)

	frame.InputEnded:Connect(function()
		dragging = false
	end)

	frame.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
			local delta = input.Position - startPos
			frame.Position = UDim2.new(
				startUIPos.X.Scale,
				startUIPos.X.Offset + delta.X,
				startUIPos.Y.Scale,
				startUIPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- =========================================
--  MAIN PANEL (OPEN AT START)
-- =========================================
local mainPanel = Instance.new("Frame", gui)
mainPanel.Size = UDim2.new(0, 230*scale, 0, 270*scale)
mainPanel.Position = UDim2.new(1, -250*scale, 0, 40)
mainPanel.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
mainPanel.BorderSizePixel = 0
Instance.new("UICorner", mainPanel).CornerRadius = UDim.new(0, 14)
makeDraggable(mainPanel)

local mainTitle = Instance.new("TextLabel", mainPanel)
mainTitle.Size = UDim2.new(1,0,0,30*scale)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "VIOLET HUB"
mainTitle.TextColor3 = Color3.new(1,1,1)
mainTitle.TextScaled = true
mainTitle.Font = Enum.Font.GothamBold

-- =========================================
--  SECOND PANEL (BUBBLE)
-- =========================================
local espPanel = Instance.new("Frame", gui)
espPanel.Size = UDim2.new(0, 230*scale, 0, 220*scale)
espPanel.Position = UDim2.new(0.5, -115*scale, 0.5, -110*scale)
espPanel.BackgroundColor3 = Color3.fromRGB(70, 0, 110)
espPanel.Visible = false
espPanel.BorderSizePixel = 0
Instance.new("UICorner", espPanel).CornerRadius = UDim.new(0, 14)
makeDraggable(espPanel)

local espTitle = Instance.new("TextLabel", espPanel)
espTitle.Size = UDim2.new(1,0,0,30*scale)
espTitle.BackgroundTransparency = 1
espTitle.Text = "ESP SETTINGS"
espTitle.TextScaled = true
espTitle.TextColor3 = Color3.new(1,1,1)
espTitle.Font = Enum.Font.GothamBold

-- =========================================
--  BUBBLE
-- =========================================
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0, 42*scale, 0, 42*scale)
bubble.Position = UDim2.new(0.02, 0, 0.5, 0)
bubble.Text = "◎"
bubble.TextColor3 = Color3.new(1,1,1)
bubble.Font = Enum.Font.GothamBold
bubble.TextScaled = true
bubble.BackgroundColor3 = Color3.fromRGB(130,0,180)
bubble.BorderSizePixel = 0
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1,0)
makeDraggable(bubble)

bubble.MouseButton1Click:Connect(function()
	espPanel.Visible = not espPanel.Visible
	espPanel.Position = UDim2.new(0.5, -115*scale, 0.5, -110*scale)
end)

-- =========================================
--  BUTTON CREATOR
-- =========================================
local function createToggle(parent, text, yPos)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0.85,0,0,36*scale)
	btn.Position = UDim2.new(0.075,0,0,yPos)
	btn.Text = text
	btn.TextScaled = true
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn)
	return btn
end

local ON_COLOR  = Color3.fromRGB(160, 0, 220)
local OFF_COLOR = Color3.fromRGB(60, 60, 60)

-- =========================================
-- ✅ ESP BEST ULTRA COMPATIBLE (SCAN TEXTE ÉCRAN)
-- =========================================

local espEnabled = false
local ESPBox
local RunService = game:GetService("RunService")

-- bouton déjà existant dans ton script
espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.BackgroundColor3 = espEnabled and ON_COLOR or OFF_COLOR

	if not espEnabled and ESPBox then
		ESPBox:Destroy()
		ESPBox = nil
	end
end)

local function getValue(text)
	local n = text:match("%$([%d%.]+)")
	return tonumber(n)
end

local function findBestFromScreen()
	local bestLabel = nil
	local bestValue = -math.huge

	for _, v in pairs(game:GetDescendants()) do
		if v:IsA("TextLabel") and v.Visible and v.Text:find("/s") then
			local val = getValue(v.Text)
			if val and val > bestValue then
				bestValue = val
				bestLabel = v
			end
		end
	end

	return bestLabel
end

local function createESP(part)
	if ESPBox then ESPBox:Destroy() end
	if not part then return end

	ESPBox = Instance.new("BoxHandleAdornment")
	ESPBox.Adornee = part
	ESPBox.AlwaysOnTop = true
	ESPBox.ZIndex = 10
	ESPBox.Size = part.Size + Vector3.new(2,2,2)
	ESPBox.Transparency = 0.3
	ESPBox.Color3 = Color3.fromRGB(170, 0, 255)
	ESPBox.Parent = part
end

RunService.RenderStepped:Connect(function()
	if not espEnabled then return end

	local bestLabel = findBestFromScreen()
	if bestLabel and bestLabel.Parent then
		local model = bestLabel:FindFirstAncestorOfClass("Model")
		if model and model:FindFirstChildWhichIsA("BasePart") then
			createESP(model:FindFirstChildWhichIsA("BasePart"))
		end
	end
end)
