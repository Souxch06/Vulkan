-- ====================================== --
--               VulkanHub                --
-- ====================================== --

if getgenv().VulkanHub then return end
getgenv().VulkanHub = true

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
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
gui.Name = "VulkanHub"
gui.ResetOnSpawn = false

-- =========================================
--  DRAG FUNCTION 
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
--  MAIN PANEL 
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
mainTitle.Text = "VulkanHUB"
mainTitle.TextColor3 = Color3.new(1,1,1)
mainTitle.TextScaled = true
mainTitle.Font = Enum.Font.GothamBold

-- =========================================
--  INFINITE JUMP BUTTON 
-- =========================================
local infiniteBtn = Instance.new("TextButton", mainPanel)
infiniteBtn.Size = UDim2.new(0.65,0,0,36*scale)
infiniteBtn.Position = UDim2.new(0.075,0,0,50)
infiniteBtn.Text = "INFINITE JUMP"
infiniteBtn.TextScaled = true
infiniteBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
infiniteBtn.TextColor3 = Color3.new(1,1,1)
infiniteBtn.Font = Enum.Font.GothamBold
infiniteBtn.BorderSizePixel = 0
Instance.new("UICorner", infiniteBtn)
local infiniteJump = false
local canJump = true
local debounceTime = 0.1

local ON_COLOR  = Color3.fromRGB(160, 0, 220)
local OFF_COLOR = Color3.fromRGB(60, 60, 60)

infiniteBtn.MouseButton1Click:Connect(function()
	infiniteJump = not infiniteJump
	infiniteBtn.BackgroundColor3 = infiniteJump and ON_COLOR or OFF_COLOR
end)

UIS.JumpRequest:Connect(function()
	if not infiniteJump or not canJump then return end
	if not player or not player.Character then return end
	local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid:GetState() == Enum.HumanoidStateType.Dead then return end
	
	-- Apply debounce
	canJump = false
	-- FIX: Use Freefall state instead of Jumping to allow continuous flying
	humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
	-- Also apply upward velocity for better flying effect
	local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
	if rootPart then
		rootPart.Velocity = Vector3.new(rootPart.Velocity.X, 50, rootPart.Velocity.Z)
	end
	task.wait(debounceTime)
	canJump = true
end)

-- =========================================
--  BUBBLE
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
--  ESP BEST BUTTON ("FIXED")
-- =========================================
local espBtn = createToggle(espPanel, "ESP BEST")

local espEnabled = false
local currentGui
local espOriginals = {}

local function getValueFromText(text)
	if not text then return nil end

	-- Remplace les virgules et espaces
	text = text:gsub(",", ""):gsub(" ", "")

	-- Détection format $12.5M/s ou $500K/s
	local num, suffix = text:match("%$([%d%.]+)([MK]?)")

	if not num then return nil end
	num = tonumber(num)
	if not num then return nil end

	if suffix == "K" then
		num = num * 1_000
	elseif suffix == "M" then
		num = num * 1_000_000
	end

	return num
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
		if lbl:IsA("TextLabel") and lbl.Text then
			local t = string.lower(lbl.Text)
			if t:find("brainrot") or t:find("steal") or t:find("secret") or t:find("god") then
				return true
			end
		end
	end
	return false
end

-- CRITICAL FIX: Improved base detection with raycast
local function isInBase(billboardGui)
	if not billboardGui or not billboardGui.Adornee then return false end
	
	local adornee = billboardGui.Adornee
	local position = adornee.Position
	
	-- FIX: More lenient height check and better ground detection
	if position.Y > 5 then
		-- Check if there's ground below using raycast
		local raycastResult = Workspace:Raycast(position, Vector3.new(0, -10, 0))
		if raycastResult and raycastResult.Distance < 8 then
			return true
		end
	end
	
	-- FIX: Check parent hierarchy for base-related names
	local parent = adornee.Parent
	while parent and parent ~= workspace do
		local parentName = string.lower(parent.Name)
		if parentName:find("base") or parentName:find("house") or parentName:find("building") or parentName:find("steal") then
			return true
		end
		parent = parent.Parent
	end
	
	-- If it has brainrot text, show it (less restrictive filtering)
	return isBrainrotBillboard(billboardGui)
end

local function getBrainrotTier(gui)
	for _, lbl in pairs(gui:GetDescendants()) do
		if lbl:IsA("TextLabel") and lbl.Text then
			local t = string.lower(lbl.Text)

			if t:find("secret") then
				return 3 -- priorité MAX
			end
			if t:find("god") then
				return 2
			end
		end
	end
	return 1 -- normal
end

-- CRITICAL FIX: Improved BillboardGui detection
local function findBestBillboard()
	local bestGui = nil
	local bestTier = 0
	local bestValue = 0

	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("BillboardGui") and obj.Enabled and isBrainrotBillboard(obj) then

			local tier = getBrainrotTier(obj)
			local value = 0

			for _, lbl in pairs(obj:GetDescendants()) do
				if lbl:IsA("TextLabel") and lbl.Text then
					local v = getValueFromText(lbl.Text)
					if v and v > value then
						value = v
					end
				end
			end

			-- ✅ PRIORITÉ : SECRET > GOD > VALEUR $
			if tier > bestTier or (tier == bestTier and value > bestValue) then
				bestTier = tier
				bestValue = value
				bestGui = obj
			end
		end
	end

	return bestGui
end

-- CRITICAL FIX: Enhanced text filtering to remove gold/variant text
local function cleanBillboardLabels(gui)
	for _, v in pairs(gui:GetDescendants()) do
		if v:IsA("TextLabel") and v.Text then
			local txt = string.lower(v.Text)
			-- Hide rarity, value achat, gold, and variant text
			if txt:find("rarete") or txt:find("rarity") or txt:find("rareté") or txt:find("achat") or
			   txt:find("gold") or txt:find("variant") or txt:find("varriant") or txt:find("variente") then
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

	-- FIX: Enhanced ESP settings for better visibility with transparent background
	gui.Size = UDim2.new(0, 400, 0, 150)
	gui.MaxDistance = 2000
	gui.StudsOffset = Vector3.new(0, 5, 0)
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.AlwaysOnTop = true
	gui.Enabled = true
	-- CRITICAL FIX: Make background transparent and remove border
	gui.BackgroundTransparency = 1
	gui.BorderSizePixel = 0

	for _, v in pairs(gui:GetDescendants()) do
		if v:IsA("TextLabel") then
			v.TextStrokeTransparency = 0
			v.TextStrokeColor3 = Color3.fromRGB(255, 0, 255)
			v.TextColor3 = Color3.fromRGB(255, 255, 0)
			v.TextSize = 60
			v.Font = Enum.Font.GothamBlack
			-- CRITICAL FIX: Make text backgrounds transparent
			v.BackgroundTransparency = 1
			v.BorderSizePixel = 0
			v.Visible = true
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

-- CRITICAL FIX: More frequent ESP updates and better detection
task.spawn(function()
	while true do
		task.wait(0.5) -- More frequent updates
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

