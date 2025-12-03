local Players = game:GetService("Players")
local player = Players.LocalPlayer

local NORMAL_SPEED = 16
local BOOST_SPEED = 45
local NORMAL_JUMP = 50
local BOOST_JUMP = 100

local speedEnabled = false
local jumpEnabled = false

local function getHumanoid()
    if player.Character then
        return player.Character:FindFirstChild("Humanoid")
    end
end

local function applyStats()
    local hum = getHumanoid()
    if not hum then return end

    hum.WalkSpeed = speedEnabled and BOOST_SPEED or NORMAL_SPEED
    hum.JumpPower = jumpEnabled and BOOST_JUMP or NORMAL_JUMP
end

player.CharacterAdded:Connect(function()
    task.wait(0.2)
    applyStats()
end)

-- ===== UI =====

local gui = Instance.new("ScreenGui")
gui.Name = "SpeedJumpPanel"
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0.05, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Speed & Jump Panel"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

local speedBtn = Instance.new("TextButton")
speedBtn.Parent = frame
speedBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
speedBtn.Size = UDim2.new(0.8, 0, 0, 40)
speedBtn.Text = "Speed : OFF"
speedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBtn.TextColor3 = Color3.new(1,1,1)

local jumpBtn = Instance.new("TextButton")
jumpBtn.Parent = frame
jumpBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
jumpBtn.Size = UDim2.new(0.8, 0, 0, 40)
jumpBtn.Text = "Jump : OFF"
jumpBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
jumpBtn.TextColor3 = Color3.new(1,1,1)

speedBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedBtn.Text = speedEnabled and "Speed : ON" or "Speed : OFF"
    applyStats()
end)

jumpBtn.MouseButton1Click:Connect(function()
    jumpEnabled = not jumpEnabled
    jumpBtn.Text = jumpEnabled and "Jump : ON" or "Jump : OFF"
    applyStats()
end)
