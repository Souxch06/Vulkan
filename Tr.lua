if getgenv().HubUI then return end
getgenv().HubUI = true

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
repeat task.wait() until player

local cam = workspace.CurrentCamera
local screenSize = cam.ViewportSize
local scale = math.clamp(math.min(screenSize.X / 1920, screenSize.Y / 1080), 0.7, 1)

pcall(function()
	if CoreGui:FindFirstChild("HubBubbleUI") then
		CoreGui.HubBubbleUI:Destroy()
	end
end)

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "HubBubbleUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

local function MakeDraggable(frame)
	frame.Active = true

	local dragging = false
	local dragInput
	local startPos
	local startFramePos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragInput = input
			startPos = input.Position
			startFramePos = frame.Position
		end
	end)

	frame.InputEnded:Connect(function(input)
		if input == dragInput then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - startPos
			frame.Position = UDim2.new(
				startFramePos.X.Scale,
				startFramePos.X.Offset + delta.X,
				startFramePos.Y.Scale,
				startFramePos.Y.Offset + delta.Y
			)
		end
	end)
end

local infPanel = Instance.new("Frame", gui)
infPanel.Size = UDim2.new(0, 300*scale, 0, 200*scale)
infPanel.Position = UDim2.new(0.7, 0, 0.05, 0) -- ✅ Haut droite
infPanel.BackgroundColor3 = Color3.fromRGB(85,0,127)
infPanel.BorderSizePixel = 0
Instance.new("UICorner", infPanel)
MakeDraggable(infPanel)

local infTitle = Instance.new("TextLabel", infPanel)
infTitle.Size = UDim2.new(1,0,0,40)
infTitle.BackgroundTransparency = 1
infTitle.Text = "INFINITE JUMP"
infTitle.TextColor3 = Color3.new(1,1,1)
infTitle.Font = Enum.Font.GothamBold
infTitle.TextScaled = true

local infBtn = Instance.new("TextButton", infPanel)
infBtn.Size = UDim2.new(0.8,0,0,45)
infBtn.Position = UDim2.new(0.1,0,0.5,0)
infBtn.Text = "Infinite Jump : OFF"
infBtn.BackgroundColor3 = Color3.fromRGB(120,120,120)
infBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", infBtn)

local infJumpEnabled = false
local lastJump = 0

infBtn.MouseButton1Click:Connect(function()
	infJumpEnabled = not infJumpEnabled
	infBtn.Text = "Infinite Jump : "..(infJumpEnabled and "ON" or "OFF")
	infBtn.BackgroundColor3 = infJumpEnabled and Color3.fromRGB(180,50,220) or Color3.fromRGB(120,120,120)
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

local paramPanel = Instance.new("Frame", gui)
paramPanel.Size = UDim2.new(0, 320*scale, 0, 260*scale)
paramPanel.Position = UDim2.new(0.5, -160*scale, 0.5, -130*scale) -- ✅ Centre écran
paramPanel.BackgroundColor3 = Color3.fromRGB(60,0,90)
paramPanel.BorderSizePixel = 0
paramPanel.Visible = false
Instance.new("UICorner", paramPanel)
MakeDraggable(paramPanel)

local paramTitle = Instance.new("TextLabel", paramPanel)
paramTitle.Size = UDim2.new(1,0,0,40)
paramTitle.BackgroundTransparency = 1
paramTitle.Text = "PARAMÈTRES"
paramTitle.TextColor3 = Color3.new(1,1,1)
paramTitle.Font = Enum.Font.GothamBold
paramTitle.TextScaled = true

local bubble = Instance.new("ImageButton", gui)
bubble.Size = UDim2.new(0, 70*scale, 0, 70*scale)
bubble.Position = UDim2.new(0.02, 0, 0.8, 0) -- ✅ GAUCHE
bubble.BackgroundColor3 = Color3.fromRGB(140,0,200)
bubble.BorderSizePixel = 0
bubble.Image = ""
bubble.ZIndex = 50
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1,0)

bubble.MouseButton1Click:Connect(function()
	paramPanel.Visible = not paramPanel.Visible
end)
