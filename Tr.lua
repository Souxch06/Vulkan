-- SAFE SPEED & JUMP PANEL (DELTA FIXED)

if getgenv().SpeedJumpLoaded then return end
getgenv().SpeedJumpLoaded = true

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- Attendre le joueur
repeat task.wait() until player

local NORMAL_SPEED = 16
local BOOST_SPEED = 45
local NORMAL_JUMP = 50
local BOOST_JUMP = 100

local speedEnabled = false
local jumpEnabled = false

local function getHumanoid()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        return player.Character.Humanoid
    end
end

local function applyStats()
    local hum = getHumanoid()
    if not hum then return end

    hum.WalkSpeed = speedEnabled and BOOST_SPEED or NORMAL_SPEED
    hum.JumpPower = jumpEnabled and BOOST_JUMP or NORMAL_JUMP
end

-- Reapply au respawn
player.CharacterAdded:Connect(function()
    task.wait(0.3)
    applyStats()
end)

task.wait(0.3)
applyStats()

-- ===== UI CREATION (SAFE) =====

pcall(function()
    if CoreGui:FindFirstChild("SpeedJumpPanel") then
        CoreGui.SpeedJumpPanel:Destroy()
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "SpeedJumpPanel"
gui.ResetOnSpawn = false

pcall(function()
    gui.Parent = CoreGui
end)

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 240, 0, 180)
frame.Position = UDim2.new(0.05, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local uiCorner = Instance.new("UICorner", frame)

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Speed / Jump"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

local speedBtn = Instance.new("TextButton")
speedBtn.Parent = frame
speedBtn.Position = UDim2.new(0.1, 0, 0.32, 0)
speedBtn.Size = UDim2.new(0.8, 0, 0, 40)
speedBtn.Text = "Speed : OFF"
speedBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
speedBtn.TextColor3 = Color3.new(1,1,1)

local jumpBtn = Instance.new("TextButton")
jumpBtn.Parent = frame
jumpBtn.Position = UDim2.new(0.1, 0, 0.62, 0)
jumpBtn.Size = UDim2.new(0.8, 0, 0, 40)
jumpBtn.Text = "Jump : OFF"
jumpBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
jumpBtn.TextColor3 = Color3.new(1,1,1)

-- ===== BUTTONS =====

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
