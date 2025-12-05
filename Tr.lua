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
--  INFINITE JUMP BUTTON (fixé safe)
-- =========================================
local infiniteBtn = Instance.new("TextButton", mainPanel)
infiniteBtn.Size = UDim2.new(0.85,0,0,36*scale)
infiniteBtn.Position = UDim2.new(0.075,0,0,50)
infiniteBtn.Text = "INFINITE JUMP"
infiniteBtn.TextScaled = true
infiniteBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
infiniteBtn.TextColor3 = Color3.new(1,1,1)
infiniteBtn.Font = Enum.Font.GothamBold
infiniteBtn.BorderSizePixel = 0
Instance.new("UICorner", infiniteBtn)
local infiniteJump = false

local ON_COLOR  = Color3.fromRGB(160, 0, 220)
local OFF_COLOR = Color3.fromRGB(60, 60, 60)

infiniteBtn.MouseButton1Click:Connect(function()
	infiniteJump = not infiniteJump
	infiniteBtn.BackgroundColor3 = infiniteJump and ON_COLOR or OFF_COLOR
end)

-- Infinite jump safe version:
UIS.JumpRequest:Connect(function()
	if not infiniteJump then return end
	if not player or not player.Character then return end
	local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid:GetState() == Enum.HumanoidStateType.Dead then return end
	-- Only jump when on ground: Running, Landed, Climbing
	local state = humanoid:GetState()
	if state ~= Enum.HumanoidStateType.Running and state ~= Enum.HumanoidStateType.Landed and state ~= Enum.HumanoidStateType.Climbing then
		return
	end
	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)

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

-- =========================================
--  ESP BEST BUTTON
-- =========================================
local espBtn = createToggle(espPanel, "ESP BEST", 50)

local espEnabled = false
local currentGui
local espOriginals = {}

local function getValueFromText(text)
	local num = text:match("%$([%d%.]+)")
	return tonumber(num)
end

local function resetESP()
	if currentGui and currentGui.Parent and espOriginals[currentGui] then
		currentGui.Size = espOriginals[currentGui].Size
		if espOriginals[currentGui].MaxDistance ~= nil then
        	currentGui.MaxDistance = espOriginals[currentGui].MaxDistance
    	end
		if espOriginals[currentGui].StudsOffset ~= nil then
			currentGui.StudsOffset = espOriginals[currentGui].StudsOffset
		end
		if espOriginals[currentGui].AlwaysOnTop ~= nil then
			currentGui.AlwaysOnTop = espOriginals[currentGui].AlwaysOnTop
		end
		if espOriginals[currentGui].ZIndexBehavior ~= nil then
			currentGui.ZIndexBehavior = espOriginals[currentGui].ZIndexBehavior
		end
		for _,v in pairs(currentGui:GetDescendants()) do
			if v:IsA("TextLabel") and espOriginals[v] then
				v.TextStrokeTransparency = espOriginals[v].TextStrokeTransparency
				v.TextStrokeColor3 = espOriginals[v].TextStrokeColor3
				v.TextColor3 = espOriginals[v].TextColor3
				v.TextSize = espOriginals[v].TextSize
				v.Font = espOriginals[v].Font
				v.BackgroundColor3 = espOriginals[v].BackgroundColor3
				v.BackgroundTransparency = espOriginals[v].BackgroundTransparency
				v.Visible = espOriginals[v].Visible
			end
		end
	end
	currentGui = nil
	espOriginals = {}
end

local function isBrainrotBillboard(billboardGui)
	for _, lbl in pairs(billboardGui:GetDescendants()) do
		if lbl:IsA("TextLabel") and lbl.Text and string.lower(lbl.Text):find("brainrot") then
			return true
		end
	end
	return false
end

local function findBestBillboard()
	local brainrotGui = nil

	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("BillboardGui") then
			for _, lbl in pairs(obj:GetDescendants()) do
				if lbl:IsA("TextLabel") and lbl.Text and string.lower(lbl.Text):find("brainrot") then
					brainrotGui = obj
					break
				end
			end
			if brainrotGui then break end
		end
	end
	return brainrotGui
end

local function cleanBillboardLabels(gui)
	for _, v in pairs(gui:GetDescendants()) do
		if v:IsA("TextLabel") and v.Text then
			-- On masque les labels de rareté, valeur achat, etc.
			local txt = v.Text:lower()
			if txt:find("rarete") or txt:find("rarity") or txt:find("rareté") or txt:find("achat") then
				v.Visible = false
			elseif txt:find("%$") and not txt:find("/s") then
				v.Visible = false
			else
				v.Visible = true
			end
		end
	end
end

local function applyESP(gui)
	resetESP()
	currentGui = gui

	-- Save original states
	espOriginals[gui] = {
		Size = gui.Size,
		MaxDistance = gui.MaxDistance or nil,
		StudsOffset = gui.StudsOffset or nil,
		AlwaysOnTop = gui.AlwaysOnTop or nil,
		ZIndexBehavior = gui.ZIndexBehavior or nil
	}
	for _,v in pairs(gui:GetDescendants()) do
		if v:IsA("TextLabel") then
			espOriginals[v] = {
				TextStrokeTransparency = v.TextStrokeTransparency,
				TextStrokeColor3 = v.TextStrokeColor3,
				TextColor3 = v.TextColor3,
				TextSize = v.TextSize,
				Font = v.Font,
				BackgroundColor3 = v.BackgroundColor3,
				BackgroundTransparency = v.BackgroundTransparency,
				Visible = v.Visible
			}
		end
	end

	gui.Size = UDim2.new(0, 300, 0, 120)
	gui.MaxDistance = 1000
	gui.StudsOffset = Vector3.new(0, 4, 0)
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.AlwaysOnTop = true

	for _, v in pairs(gui:GetDescendants()) do
		if v:IsA("TextLabel") then
			v.TextStrokeTransparency = 0
			v.TextStrokeColor3 = Color3.fromRGB(255, 0, 255)
			v.TextColor3 = Color3.fromRGB(255, 255, 0)
			v.TextSize = 50
			v.Font = Enum.Font.GothamBlack
			v.BackgroundTransparency = 1
		end
	end
	cleanBillboardLabels(gui)
end

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.BackgroundColor3 = espEnabled and ON_COLOR or OFF_COLOR
	if not espEnabled then
		resetESP()
	end
end)

task.spawn(function()
	while true do
		task.wait(1)
		if espEnabled then
			local guiFound = findBestBillboard()
			if guiFound and guiFound ~= currentGui then
				applyESP(guiFound)
			elseif not guiFound and currentGui then
				resetESP()
			end
		else
			if currentGui then
				resetESP()
			end
		end
	end
end)
