if getgenv().HubUI then return end
getgenv().HubUI = true

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

pcall(function()
	if CoreGui:FindFirstChild("HubBubbleUI") then
		CoreGui.HubBubbleUI:Destroy()
	end
end)

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "HubBubbleUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

local OFF_COLOR = Color3.fromRGB(120,120,120)
local ON_COLOR = Color3.fromRGB(180,50,220)

-- ========= DRAG =========
local function MakeDraggable(frame)
	frame.Active = true
	local dragging = false
	local dragStart, startPos

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
		if dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- ========= PANEL INFINITE JUMP =========
local infPanel = Instance.new("Frame", gui)
infPanel.Size = UDim2.new(0, 160, 0, 100)
infPanel.Position = UDim2.new(1, -180, 0, 15)
infPanel.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
infPanel.BorderSizePixel = 0
Instance.new("UICorner", infPanel)
MakeDraggable(infPanel)

local infTitle = Instance.new("TextLabel", infPanel)
infTitle.Size = UDim2.new(1,0,0,22)
infTitle.BackgroundTransparency = 1
infTitle.Text = "INFINITE JUMP"
infTitle.TextColor3 = Color3.new(1,1,1)
infTitle.Font = Enum.Font.GothamBold
infTitle.TextScaled = true

local infBtn = Instance.new("TextButton", infPanel)
infBtn.Size = UDim2.new(0.9,0,0,28)
infBtn.Position = UDim2.new(0.05,0,0.6,0)
infBtn.Text = "Infinite Jump"
infBtn.BackgroundColor3 = OFF_COLOR
infBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", infBtn)

local infJumpEnabled = false
local lastJump = 0

infBtn.MouseButton1Click:Connect(function()
	infJumpEnabled = not infJumpEnabled
	infBtn.BackgroundColor3 = infJumpEnabled and ON_COLOR or OFF_COLOR
end)

UIS.JumpRequest:Connect(function()
	if not infJumpEnabled then return end
	if tick() - lastJump < 0.25 then return end
	lastJump = tick()

	local char = player.Character
	if char then
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			root.Velocity = Vector3.new(root.Velocity.X, 65, root.Velocity.Z)
		end
	end
end)

-- ========= PANEL PARAMÈTRES =========
local paramPanel = Instance.new("Frame", gui)
paramPanel.Size = UDim2.new(0, 170, 0, 140)
paramPanel.Position = UDim2.new(0.5, -85, 0.5, -70)
paramPanel.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
paramPanel.BorderSizePixel = 0
paramPanel.Visible = false
Instance.new("UICorner", paramPanel)
MakeDraggable(paramPanel)

local paramTitle = Instance.new("TextLabel", paramPanel)
paramTitle.Size = UDim2.new(1,0,0,22)
paramTitle.BackgroundTransparency = 1
paramTitle.Text = "PARAMÈTRES"
paramTitle.TextColor3 = Color3.new(1,1,1)
paramTitle.Font = Enum.Font.GothamBold
paramTitle.TextScaled = true

-- ========= BOUTON ESP BEST =========
local espBestBtn = Instance.new("TextButton", paramPanel)
espBestBtn.Size = UDim2.new(0.9,0,0,28)
espBestBtn.Position = UDim2.new(0.05,0,0.45,0)
espBestBtn.Text = "ESP Best"
espBestBtn.BackgroundColor3 = OFF_COLOR
espBestBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", espBestBtn)

local espBestEnabled = false
local espHighlight
local espBillboard
local espLoop

local function clearESP()
	if espHighlight then espHighlight:Destroy() espHighlight = nil end
	if espBillboard then espBillboard:Destroy() espBillboard = nil end
	if espLoop then espLoop:Disconnect() espLoop = nil end
end

local function enableESPBest()
	clearESP()
	espLoop = RunService.Heartbeat:Connect(function()
		local best, bestValue
		best = nil
		bestValue = -math.huge

		-- SCAN DU SERVEUR
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("Model") then
				for _, v in pairs(obj:GetDescendants()) do
					if v:IsA("NumberValue") and (v.Name:lower():find("value") or v.Name:lower():find("money") or v.Name:lower():find("amount")) then
						if v.Value > bestValue then
							bestValue = v.Value
							best = obj
						end
					end
				end
			end
		end

		if not best then return end

		if espHighlight and espHighlight.Adornee ~= best then
			clearESP()
		end

		if not espHighlight then
			espHighlight = Instance.new("Highlight", gui)
			espHighlight.Adornee = best
			espHighlight.FillColor = Color3.fromRGB(170,60,255)
			espHighlight.OutlineColor = Color3.new(1,1,1)

			espBillboard = Instance.new("BillboardGui", gui)
			espBillboard.Adornee = best.PrimaryPart or best:FindFirstChildWhichIsA("BasePart")
			espBillboard.Size = UDim2.new(0,200,0,50)
			espBillboard.AlwaysOnTop = true

			local txt = Instance.new("TextLabel", espBillboard)
			txt.Size = UDim2.new(1,0,1,0)
			txt.BackgroundTransparency = 1
			txt.Text = best.Name .. " : " .. tostring(bestValue) .. "/s"
			txt.TextColor3 = Color3.new(1,1,1)
			txt.TextStrokeTransparency = 0
			txt.TextScaled = true
			txt.Font = Enum.Font.GothamBold
		end
	end)
end

espBestBtn.MouseButton1Click:Connect(function()
	espBestEnabled = not espBestEnabled
	espBestBtn.BackgroundColor3 = espBestEnabled and ON_COLOR or OFF_COLOR
	if espBestEnabled then
		enableESPBest()
	else
		clearESP()
	end
end)

-- ========= BULLE =========
local bubble = Instance.new("ImageButton", gui)
bubble.Size = UDim2.new(0, 42, 0, 42)
bubble.Position = UDim2.new(0, 12, 0.8, 0)
bubble.BackgroundColor3 = Color3.fromRGB(140,0,200)
bubble.BorderSizePixel = 0
bubble.Image = ""
bubble.ZIndex = 50
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1,0)
MakeDraggable(bubble)

bubble.MouseButton1Click:Connect(function()
	paramPanel.Visible = not paramPanel.Visible
end)
