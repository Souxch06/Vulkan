-- =========================================
--  HUB UI VIOLET - DRAG STABLE RAPIDE+FIABLE + ESP ROBUSTE
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
local gui = Instance.new("ScreenGui")
gui.Name = "HubBubbleUI"
gui.Parent = CoreGui
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- helper: clamp frame to screen (prevents "bloquage offscreen")
local function clampPosition(pos, size)
	size = size or Vector2.new(300*scale,200*scale)
	local screen = workspace.CurrentCamera.ViewportSize
	local x = math.clamp(pos.X, 0, screen.X - size.X)
	local y = math.clamp(pos.Y, 0, screen.Y - size.Y)
	return Vector2.new(x,y)
end

-- MAKE DRAGGABLE (robuste, pas de conflit entre frames, suit très vite)
local function MakeDraggable(handle, frame)
	frame.Active = true

	local dragging = false
	local dragInput = nil
	local dragOffset = Vector2.new(0,0)
	local absStart = Vector2.new(0,0) -- absolute pixel pos of frame when drag starts
	local frameSize = Vector2.new(frame.AbsoluteSize.X, frame.AbsoluteSize.Y)

	-- Update frameSize on absolute size changes
	frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		frameSize = Vector2.new(frame.AbsoluteSize.X, frame.AbsoluteSize.Y)
	end)

	local function onInputBegan(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragInput = input
			-- compute absolute pixel position of frame
			absStart = Vector2.new(
				frame.AbsolutePosition.X,
				frame.AbsolutePosition.Y
			)
			local inputPos = input.Position
			dragOffset = inputPos - absStart
			-- consume focus
		end
	end

	local function onInputEnded(input)
		if input == dragInput then
			dragging = false
			dragInput = nil
		end
	end

	-- Bind frame events (local to this frame)
	handle.InputBegan:Connect(onInputBegan)
	handle.InputEnded:Connect(onInputEnded)
	handle.InputChanged:Connect(function(input)
		-- if user changes which input is used (touch/mouse move), keep track
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragging and input ~= dragInput and input.UserInputType == dragInput.UserInputType then
				dragInput = input
			end
		end
	end)

	-- RenderStepped loop local to this draggable (fast & reliable)
	local conn
	conn = RunService.RenderStepped:Connect(function()
		if dragging and dragInput then
			local success, pos = pcall(function() return dragInput.Position end)
			if not success or not pos then return end
			-- desired absolute top-left = mousepos - offset
			local desired = Vector2.new(pos.X, pos.Y) - dragOffset
			-- clamp to screen
			desired = clampPosition(desired, frameSize)
			-- convert to UDim2 relative using screen size
			local screen = workspace.CurrentCamera.ViewportSize
			local scaleX = desired.X / screen.X
			local scaleY = desired.Y / screen.Y
			frame.Position = UDim2.new(scaleX, 0, scaleY, 0)
		end
	end)

	-- cleanup on destroy
	frame.Destroying:Connect(function()
		if conn then conn:Disconnect() end
	end)
end

-- =========================================
-- PANEL PRINCIPAL (spawn top-right)
-- =========================================
local PANEL_W = 320 * scale
local PANEL_H = 220 * scale
local margin = 10

local infPanel = Instance.new("Frame", gui)
infPanel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
-- spawn top-right (10 px from top and right)
infPanel.Position = UDim2.new(1, -PANEL_W - margin, 0, margin)
infPanel.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
infPanel.BorderSizePixel = 0
infPanel.ZIndex = 10
Instance.new("UICorner", infPanel).CornerRadius = UDim.new(0, 14)

local infTop = Instance.new("Frame", infPanel)
infTop.Size = UDim2.new(1,0,0,40)
infTop.BackgroundColor3 = Color3.fromRGB(115, 0, 170)
infTop.BorderSizePixel = 0
infTop.ZIndex = infPanel.ZIndex + 1
local infTitle = Instance.new("TextLabel", infTop)
infTitle.Size = UDim2.new(1,0,1,0)
infTitle.BackgroundTransparency = 1
infTitle.Text = "INFINITE JUMP"
infTitle.TextColor3 = Color3.new(1,1,1)
infTitle.Font = Enum.Font.GothamBold
infTitle.TextScaled = true
infTitle.ZIndex = infTop.ZIndex + 1

-- make only the top bar draggable (prevents conflicts with buttons)
MakeDraggable(infTop, infPanel)

local infBtn = Instance.new("TextButton", infPanel)
infBtn.Size = UDim2.new(0.8,0,0,46)
infBtn.Position = UDim2.new(0.1,0,0.45,0)
infBtn.Text = "Infinite Jump : OFF"
infBtn.BackgroundColor3 = Color3.fromRGB(120,120,120)
infBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", infBtn)

local infJumpEnabled = false
local lastJump = 0
local JUMP_FORCE = 65

infBtn.MouseButton1Click:Connect(function()
	infJumpEnabled = not infJumpEnabled
	infBtn.Text = "Infinite Jump : "..(infJumpEnabled and "ON" or "OFF")
	infBtn.BackgroundColor3 = infJumpEnabled and Color3.fromRGB(180,50,220) or Color3.fromRGB(120,120,120)
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
-- PANEL PARAMÈTRES (via bulle)
-- =========================================
local paramPanel = Instance.new("Frame", gui)
paramPanel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H + 40)
paramPanel.Position = UDim2.new(1, -PANEL_W - margin, 0, margin + PANEL_H + 10)
paramPanel.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
paramPanel.BorderSizePixel = 0
paramPanel.ZIndex = 10
paramPanel.Visible = false
Instance.new("UICorner", paramPanel).CornerRadius = UDim.new(0, 14)

local paramTop = Instance.new("Frame", paramPanel)
paramTop.Size = UDim2.new(1,0,0,40)
paramTop.BackgroundColor3 = Color3.fromRGB(95, 0, 150)
paramTop.BorderSizePixel = 0
local paramTitle = Instance.new("TextLabel", paramTop)
paramTitle.Size = UDim2.new(1,0,1,0)
paramTitle.BackgroundTransparency = 1
paramTitle.Text = "PARAMÈTRES / ESP"
paramTitle.TextColor3 = Color3.new(1,1,1)
paramTitle.Font = Enum.Font.GothamBold
paramTitle.TextScaled = true

-- make only the top bar draggable
MakeDraggable(paramTop, paramPanel)

-- ESP BEST toggle (OFF by default)
local espBtn = Instance.new("TextButton", paramPanel)
espBtn.Size = UDim2.new(0.86,0,0,46)
espBtn.Position = UDim2.new(0.07,0,0.28,0)
espBtn.Text = "ESP BEST : OFF"
espBtn.BackgroundColor3 = Color3.fromRGB(120,120,120)
espBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", espBtn)

local espEnabled = false
local espGui = nil

-- robust value extractor: checks NumberValue, IntValue, StringValue numeric, and Attributes on Instance
local function getNumericFromInstance(inst)
	-- check Value Instances
	for _,v in pairs(inst:GetChildren()) do
		if v:IsA("NumberValue") or v:IsA("IntValue") then
			if type(v.Value) == "number" then
				return v.Value, v.Name
			end
		elseif v:IsA("StringValue") then
			local n = tonumber(v.Value)
			if n then return n, v.Name end
		end
	end
	-- check attributes
	local attrs = inst:GetAttributes()
	for k,val in pairs(attrs) do
		if type(val) == "number" then
			return val, k
		elseif type(val) == "string" then
			local n = tonumber(val)
			if n then return n, k end
		end
	end
	return nil, nil
end

-- find best candidate: iterate through workspace children / models
local function FindBestCandidate()
	local bestVal = -math.huge
	local bestTarget = nil
	local bestLabel = nil

	-- we iterate workspace descendants but prioritize Models / Folders / Parts that have numeric children/attributes
	for _,obj in ipairs(workspace:GetDescendants()) do
		-- skip gui or terrain weird stuff
		if obj ~= nil and (obj:IsA("Model") or obj:IsA("Folder") or obj:IsA("BasePart")) then
			local val, label = getNumericFromInstance(obj)
			if val and type(val) == "number" then
				-- ensure we have a BasePart to attach billboard to
				local targetPart = nil
				if obj:IsA("BasePart") then
					targetPart = obj
				elseif obj:IsA("Model") then
					targetPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
				else
					targetPart = obj:FindFirstChildWhichIsA("BasePart")
				end

				if targetPart and val > bestVal then
					bestVal = val
					bestTarget = targetPart
					bestLabel = label or val
				end
			end
		end
	end

	-- return target part, its value and label
	if bestTarget then
		return bestTarget, bestVal, bestLabel
	end
	return nil, nil, nil
end

local function ClearESP()
	if espGui then
		espGui:Destroy()
		espGui = nil
	end
end

local function CreateESP(targetPart, value, labelName)
	if not targetPart then return end
	ClearESP()
	espGui = Instance.new("BillboardGui")
	espGui.Size = UDim2.new(0, 260, 0, 80)
	espGui.AlwaysOnTop = true
	espGui.Parent = targetPart

	local txt = Instance.new("TextLabel", espGui)
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 0.15
	txt.BackgroundColor3 = Color3.fromRGB(105,0,150)
	txt.TextColor3 = Color3.new(1,1,1)
	txt.Font = Enum.Font.GothamBold
	txt.TextScaled = true
	txt.Text = ("BEST • %s\n%s /s"):format(targetPart.Name or "obj", math.floor(value))
	Instance.new("UICorner", txt)
end

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.Text = "ESP BEST : "..(espEnabled and "ON" or "OFF")
	espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(180,50,220) or Color3.fromRGB(120,120,120)
	if not espEnabled then
		ClearESP()
	else
		-- try immediately
		local t,v = FindBestCandidate()
		if t then CreateESP(t,v) end
	end
end)

-- Re-scan continuously but not every frame (every 0.2s) to avoid heavy loops
local lastScan = 0
RunService.Heartbeat:Connect(function(dt)
	if espEnabled then
		lastScan = lastScan + dt
		if lastScan >= 0.2 then
			lastScan = 0
			local t,v = FindBestCandidate()
			if t and v then
				-- if new target or new value, recreate ESP
				local same = (espGui and espGui.Parent == t)
				if not same then
					CreateESP(t,v)
				else
					-- update text if same parent
					local lbl = espGui and espGui:FindFirstChildOfClass("TextLabel")
					if lbl then lbl.Text = ("BEST • %s\n%s /s"):format(t.Name, math.floor(v)) end
				end
			else
				ClearESP()
			end
		end
	end
end)

-- For debugging: print what numeric entries exist (only if espEnabled and nothing found)
local function DumpNumericEntries()
	for _,obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("NumberValue") or obj:IsA("IntValue") or obj:IsA("StringValue") then
			local ok, val = pcall(function() return obj.Value end)
			if ok then
				print("[NUMERIC-CANDIDATE]", obj:GetFullName(), tostring(val))
			end
		end
		-- attributes
		local attrs = obj:GetAttributes()
		for k,v in pairs(attrs) do
			if type(v) == "number" or tonumber(v) then
				print("[ATTR-CANDIDATE]", obj:GetFullName(), k, v)
			end
		end
	end
end

-- =========================================
-- BULLE HUB (ZIndex élevé pour ne pas disparaitre)
-- =========================================
local bubble = Instance.new("ImageButton", gui)
bubble.Size = UDim2.new(0, 72*scale, 0, 72*scale)
bubble.Position = UDim2.new(1, -72*scale - margin, 0.8, 0) -- on met à droite pour confort
bubble.BackgroundColor3 = Color3.fromRGB(140,0,200)
bubble.BorderSizePixel = 0
bubble.ZIndex = 50
bubble.Image = ""
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1,0)
MakeDraggable(bubble) -- draggable independently

bubble.MouseButton1Click:Connect(function()
	paramPanel.Visible = not paramPanel.Visible
	-- if enabling esp and nothing found, dump numeric entries to console to help debug
	if paramPanel.Visible and espEnabled then
		local t,v = FindBestCandidate()
		if not t then
			print("[HUBDEBUG] ESP activé mais aucune cible trouvée — dump numeric candidates ci-dessous:")
			DumpNumericEntries()
		end
	end
end)

-- ensure bubble stays on top of panels visually
bubble.Parent = gui
bubble.ZIndex = 100

-- final: ensure panels parent zindex lower than bubble
infPanel.ZIndex = 20
paramPanel.ZIndex = 20

-- End of script
