-- =========================================
--  HUB UI VIOLET - DRAG RAPIDE + ESP BEST
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
local cam = workspace.CurrentCamera
local screenSize = cam.ViewportSize
local scale = math.clamp(math.min(screenSize.X / 1920, screenSize.Y / 1080), 0.65, 1)

-- ===== CLEAN OLD =====
pcall(function()
	if CoreGui:FindFirstChild("HubBubbleUI") then
		CoreGui.HubBubbleUI:Destroy()
	end
end)

-- ===== GUI =====
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "HubBubbleUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- =========================================
-- 🔹 DRAG FUNCTION (RAPIDE)
-- =========================================

local function MakeDraggable(frame)
	frame.Active = true

	local dragging = false
	local dragStart, startPos
	local SPEED = 1.4 -- 🔥 VITESSE AUGMENTÉE

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)

	frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = (input.Position - dragStart) * SPEED
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- =========================================
-- 🔹 PANEL INFINITE JUMP (OUVERT)
-- =========================================

local infPanel = Instance.new("Frame", gui)
infPanel.Size = UDim2.new(0, 300*scale, 0, 200*scale)
infPanel.Position = UDim2.new(0.05, 0, 0.3, 0)
infPanel.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
infPanel.BorderSizePixel = 0
MakeDraggable(infPanel)
Instance.new("UICorner", infPanel)

local infTitle = Instance.new("TextLabel", infPanel)
infTitle.Size = UDim2.new(1,0,0,40)
infTitle.BackgroundTransparency = 1
infTitle.Text = "INFINITE JUMP"
infTitle.TextColor3 = Color3.new(1,1,1)
infTitle.Font = Enum.Font.GothamBold
infTitle.TextScaled = true

local infBtn = Instance.new("TextButton", infPanel)
infBtn.Size = UDim2.new(0.8,0,0,45)
infBtn.Position = UDim2.new(0.1,0,0.45,0)
infBtn.Text = "OFF"
infBtn.BackgroundColor3 = Color3.fromRGB(130,0,180)
infBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", infBtn)

local infJumpEnabled = false -- ✅ OFF AU DÉPART
local lastJump = 0
local JUMP_FORCE = 65

infBtn.MouseButton1Click:Connect(function()
	infJumpEnabled = not infJumpEnabled
	infBtn.Text = infJumpEnabled and "ON" or "OFF"
	infBtn.BackgroundColor3 = infJumpEnabled and Color3.fromRGB(180,50,220) or Color3.fromRGB(130,0,180)
end)

UIS.JumpRequest:Connect(function()
	if not infJumpEnabled then return end
	if tick() - lastJump < 0.2 then return end
	lastJump = tick()

	local char = player.Character
	if char then
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			root.Velocity = Vector3.new(root.Velocity.X, JUMP_FORCE, root.Velocity.Z)
		end
	end
end)

-- =========================================
-- 🔹 PARAMETER PANEL (BULLE)
-- =========================================

local paramPanel = Instance.new("Frame", gui)
paramPanel.Size = UDim2.new(0, 320*scale, 0, 260*scale)
paramPanel.Position = UDim2.new(0.55, 0, 0.3, 0)
paramPanel.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
paramPanel.BorderSizePixel = 0
paramPanel.Visible = false
MakeDraggable(paramPanel)
Instance.new("UICorner", paramPanel)

local paramTitle = Instance.new("TextLabel", paramPanel)
paramTitle.Size = UDim2.new(1,0,0,40)
paramTitle.BackgroundTransparency = 1
paramTitle.Text = "PARAMÈTRES"
paramTitle.TextColor3 = Color3.new(1,1,1)
paramTitle.Font = Enum.Font.GothamBold
paramTitle.TextScaled = true

-- =========================================
-- 🔹 ESP BEST BUTTON
-- =========================================

local espBtn = Instance.new("TextButton", paramPanel)
espBtn.Size = UDim2.new(0.8,0,0,45)
espBtn.Position = UDim2.new(0.1,0,0.35,0)
espBtn.Text = "ESP BEST : OFF"
espBtn.BackgroundColor3 = Color3.fromRGB(130,0,180)
espBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", espBtn)

local espBestEnabled = false -- ✅ OFF PAR DÉFAUT
local espBillboard

local function ClearESP()
	if espBillboard then
		espBillboard:Destroy()
		espBillboard = nil
	end
end

local function FindBestObject()
	local bestValue = -math.huge
	local bestObj = nil

	for _,obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("NumberValue") then
			if obj.Value > bestValue then
				bestValue = obj.Value
				bestObj = obj.Parent
			end
		end
	end

	return bestObj, bestValue
end

local function CreateESP(target, value)
	if not target or not target:IsA("BasePart") then return end

	espBillboard = Instance.new("BillboardGui", target)
	espBillboard.Size = UDim2.new(0,250,0,60)
	espBillboard.AlwaysOnTop = true

	local label = Instance.new("TextLabel", espBillboard)
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundColor3 = Color3.fromRGB(90,0,130)
	label.TextColor3 = Color3.new(1,1,1)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Text = "BEST:\n"..target.Name.."\n"..math.floor(value).."/s"
	Instance.new("UICorner", label)
end

espBtn.MouseButton1Click:Connect(function()
	espBestEnabled = not espBestEnabled
	espBtn.Text = espBestEnabled and "ESP BEST : ON" or "ESP BEST : OFF"
	espBtn.BackgroundColor3 = espBestEnabled and Color3.fromRGB(180,50,220) or Color3.fromRGB(130,0,180)

	ClearESP()

	if espBestEnabled then
		local obj, val = FindBestObject()
		if obj and obj:IsA("BasePart") then
			CreateESP(obj, val)
		end
	end
end)

-- =========================================
-- 🔹 BULLE HUB (PLUS GRANDE)
-- =========================================

local bubble = Instance.new("ImageButton", gui)
bubble.Size = UDim2.new(0, 65*scale, 0, 65*scale) -- ✅ AGRANDIE
bubble.Position = UDim2.new(0.02, 0, 0.8, 0)
bubble.BackgroundColor3 = Color3.fromRGB(140,0,200)
bubble.BorderSizePixel = 0
bubble.Image = ""
MakeDraggable(bubble)
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1,0)

bubble.MouseButton1Click:Connect(function()
	paramPanel.Visible = not paramPanel.Visible
end)
