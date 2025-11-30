-- Vulkan Hub - Mobile Delta Auto Joiner (SAFE VERSION)

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer

-- UI
local gui = Instance.new("ScreenGui", CoreGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 180)
frame.Position = UDim2.new(0.5, -160, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "VULKAN HUB - AUTO JOIN"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(1, -20, 0, 40)
box.Position = UDim2.new(0, 10, 0, 50)
box.PlaceholderText = "Colle ton Job ID ici"
box.Text = ""
box.ClearTextOnFocus = false
box.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
box.TextColor3 = Color3.fromRGB(255, 255, 255)

local joinBtn = Instance.new("TextButton", frame)
joinBtn.Size = UDim2.new(0.48, -10, 0, 40)
joinBtn.Position = UDim2.new(0, 10, 0, 100)
joinBtn.Text = "JOIN"
joinBtn.BackgroundColor3 = Color3.fromRGB(120, 90, 255)
joinBtn.TextColor3 = Color3.fromRGB(0, 0, 0)

local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(0.48, -10, 0, 40)
autoBtn.Position = UDim2.new(0.52, 0, 0, 100)
autoBtn.Text = "AUTO JOIN"
autoBtn.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
autoBtn.TextColor3 = Color3.fromRGB(0, 0, 0)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -20, 0, 25)
status.Position = UDim2.new(0, 10, 0, 145)
status.BackgroundTransparency = 1
status.Text = "État : prêt"
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.Font = Enum.Font.Gotham

-- Nettoyage Job ID
local function cleanJobId(txt)
    if not txt then return "" end
    txt = txt:gsub("%s+", "")
    txt = txt:gsub("[^0-9A-Fa-f]", "")
    return txt
end

-- Join simple
joinBtn.MouseButton1Click:Connect(function()
    local jobId = cleanJobId(box.Text)
    if jobId == "" then
        status.Text = "État : Job ID invalide"
        return
    end

    status.Text = "État : tentative..."
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, Player)
    end)
end)

-- Auto Join
local auto = false

autoBtn.MouseButton1Click:Connect(function()
    auto = not auto

    if auto then
        autoBtn.Text = "STOP"
        status.Text = "État : auto join actif"

        task.spawn(function()
            while auto do
                local jobId = cleanJobId(box.Text)
                if jobId ~= "" then
                    pcall(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, Player)
                    end)
                end
                task.wait(2.5)
            end
        end)
    else
        autoBtn.Text = "AUTO JOIN"
        status.Text = "État : arrêté"
    end
end)
