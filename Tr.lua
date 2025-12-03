local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local NORMAL_SPEED = 16
local BOOST_SPEED = 40
local JUMP_POWER = 90
local enabled = false

local function getHumanoid()
    if player.Character then
        return player.Character:FindFirstChild("Humanoid")
    end
end

local function update()
    local hum = getHumanoid()
    if not hum then return end

    if enabled then
        hum.WalkSpeed = BOOST_SPEED
        hum.JumpPower = JUMP_POWER
    else
        hum.WalkSpeed = NORMAL_SPEED
        hum.JumpPower = 50
    end
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        enabled = not enabled
        update()
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(0.2)
    update()
end)
