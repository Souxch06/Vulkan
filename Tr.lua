-- Tr.lua - Vulkan Hub (Delta Android) - Steal a Brainrot
-- UI moderne violet/neon, copy/paste JobID, nettoyage hex, Join / AutoJoin
-- Auteur : Vulkan Hub (pour Souxch06)

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- helpers
local function cleanHex(str)
    if not str then return "" end
    local cleaned = str:gsub("%s+", ""):gsub("0x",""):gsub("[^0-9A-Fa-f]","")
    return cleaned
end

local function tryGetClipboard()
    -- Delta/Android often expose getclipboard() or read_clipboard()
    if type(getclipboard) == "function" then
        local ok, v = pcall(getclipboard)
        if ok and v then return tostring(v) end
    end
    if type(read_clipboard) == "function" then
        local ok, v = pcall(read_clipboard)
        if ok and v then return tostring(v) end
    end
    -- some exploits expose syn.request/read_clipboard differently; best-effort
    return nil
end

local function notify(title, text, duration)
    duration = duration or 4
    pcall(function()
        if game:GetService("StarterGui") and game:GetService("StarterGui").SetCore then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = title;
                Text = text;
                Duration = duration;
            })
            return
        end
    end)
    -- fallback: simple GUI label if notifications blocked
    local tg = Instance.new("ScreenGui")
    tg.Name = "VulkanHubNotify"
    tg.ResetOnSpawn = false
    tg.Parent = CoreGui
    local lbl = Instance.new("TextLabel", tg)
    lbl.Size = UDim2.new(0, 350, 0, 50)
    lbl.Position = UDim2.new(0.5, -175, 0.05, 0)
    lbl.TextScaled = true
    lbl.BackgroundTransparency = 0.2
    lbl.BackgroundColor3 = Color3.fromRGB(40, 8, 60)
    lbl.TextColor3 = Color3.fromRGB(235,235,255)
    lbl.Text = title.." • "..text
    task.delay(duration, function() pcall(function() tg:Destroy() end) end)
end

-- create UI
local gui = Instance.new("ScreenGui")
gui.Name = "VulkanHubGui"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 360, 0, 220)
frame.Position = UDim2.new(0.5, -180, 0.35, -110)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundTransparency = 0
frame.BackgroundColor3 = Color3.fromRGB(24, 8, 36)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true

-- neon border
local border = Instance.new("Frame", frame)
border.Size = UDim2.new(1, 6, 1, 6)
border.Position = UDim2.new(0, -3, 0, -3)
border.BackgroundColor3 = Color3.fromRGB(132, 52, 255)
border.ZIndex = 0
border.BorderSizePixel = 0
border.ClipsDescendants = true

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 36)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "VULKAN HUB"
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(240,240,255)

-- JobID TextBox
local jobBox = Instance.new("TextBox", frame)
jobBox.Size = UDim2.new(1, -20, 0, 46)
jobBox.Position = UDim2.new(0, 10, 0, 56)
jobBox.PlaceholderText = "Colle ton Job ID Mobile ici (ou clipboard)"
jobBox.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
jobBox.TextColor3 = Color3.fromRGB(250,250,250)
jobBox.TextWrapped = false
jobBox.ClearTextOnFocus = false
jobBox.TextXAlignment = Enum.TextXAlignment.Left
jobBox.Text = ""

-- Buttons row
local btnJoin = Instance.new("TextButton", frame)
btnJoin.Size = UDim2.new(0.48, -10, 0, 40)
btnJoin.Position = UDim2.new(0, 10, 0, 110)
btnJoin.Text = "Join maintenant"
btnJoin.Font = Enum.Font.Gotham
btnJoin.TextScaled = true
btnJoin.TextColor3 = Color3.fromRGB(12,12,12)
btnJoin.BackgroundColor3 = Color3.fromRGB(154, 60, 255)
btnJoin.AutoButtonColor = true

local btnAuto = Instance.new("TextButton", frame)
btnAuto.Size = UDim2.new(0.48, -10, 0, 40)
btnAuto.Position = UDim2.new(0.52, 0, 0, 110)
btnAuto.Text = "Auto Join"
btnAuto.Font = Enum.Font.Gotham
btnAuto.TextScaled = true
btnAuto.TextColor3 = Color3.fromRGB(12,12,12)
btnAuto.BackgroundColor3 = Color3.fromRGB(98, 160, 255)
btnAuto.AutoButtonColor = true

local btnClipboard = Instance.new("TextButton", frame)
btnClipboard.Size = UDim2.new(0.48, -10, 0, 34)
btnClipboard.Position = UDim2.new(0, 10, 0, 160)
btnClipboard.Text = "Coller depuis clipboard"
btnClipboard.TextScaled = true
btnClipboard.Font = Enum.Font.Gotham
btnClipboard.TextColor3 = Color3.fromRGB(12,12,12)
btnClipboard.BackgroundColor3 = Color3.fromRGB(220,220,220)

local btnClean = Instance.new("TextButton", frame)
btnClean.Size = UDim2.new(0.48, -10, 0, 34)
btnClean.Position = UDim2.new(0.52, 0, 0, 160)
btnClean.Text = "Nettoyer & Copier"
btnClean.TextScaled = true
btnClean.Font = Enum.Font.Gotham
btnClean.TextColor3 = Color3.fromRGB(12,12,12)
btnClean.BackgroundColor3 = Color3.fromRGB(200,180,255)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 8)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.Gotham
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BackgroundTransparency = 0.25
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 10, 60)

-- small helper text
local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 200)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "État : prêt"
statusLabel.TextColor3 = Color3.fromRGB(220,220,255)
statusLabel.TextScaled = false
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- functions
local autoJoining = false
local autoThread = nil

local function setStatus(t)
    statusLabel.Text = "État : "..t
end

local function cleanAndReturn(s)
    local c = cleanHex(s)
    if #c == 0 then return nil end
    return c
end

local function attemptTeleport(hex)
    if not hex or #hex < 8 then
        setStatus("Job ID invalide")
        notify("Vulkan Hub", "Job ID invalide", 3)
        return false
    end
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, hex, Player)
    end)
    return true
end

-- button behaviors
btnJoin.MouseButton1Click:Connect(function()
    local raw = jobBox.Text or ""
    local hex = cleanAndReturn(raw)
    if not hex then
        setStatus("Aucun Job ID")
        notify("Vulkan Hub", "Aucun Job ID détecté", 3)
        return
    end
    setStatus("Join lancé...")
    attemptTeleport(hex)
end)

btnAuto.MouseButton1Click:Connect(function()
    if autoJoining then
        autoJoining = false
        setStatus("Auto-join arrêté")
        notify("Vulkan Hub", "Auto-join arrêté", 2)
        return
    end
    local raw = jobBox.Text or ""
    local hex = cleanAndReturn(raw)
    if not hex then
        setStatus("Aucun Job ID")
        notify("Vulkan Hub", "Aucun Job ID détecté", 3)
        return
    end
    autoJoining = true
    setStatus("Auto-join actif")
    notify("Vulkan Hub", "Auto join activé", 2)
    autoThread = spawn(function()
        while autoJoining and gui.Parent do
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, hex, Player) end)
            task.wait(2.5)
        end
    end)
end)

btnClipboard.MouseButton1Click:Connect(function()
    local pasted = tryGetClipboard()
    if pasted and #pasted > 0 then
        jobBox.Text = pasted
        setStatus("Collé depuis clipboard")
        notify("Vulkan Hub", "Collé depuis clipboard", 2)
    else
        setStatus("Clipboard non accessible")
        notify("Vulkan Hub", "Clipboard non accessible — colle manuellement", 3)
    end
end)

btnClean.MouseButton1Click:Connect(function()
    local raw = jobBox.Text or ""
    local hex = cleanAndReturn(raw)
    if not hex then
        setStatus("Aucun Job ID")
        notify("Vulkan Hub", "Aucun Job ID détecté", 3)
        return
    end
    -- copy to clipboard if exploit provides it
    if type(setclipboard) == "function" then
        pcall(function() setclipboard(hex) end)
    elseif type(write_clipboard) == "function" then
        pcall(function() write_clipboard(hex) end)
    end
    jobBox.Text = hex
    setStatus("Nettoyé ✓ (copié si possible)")
    notify("Vulkan Hub", "Nettoyé et copié", 2)
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- small entrance animation (fade in)
frame.Position = UDim2.new(0.5, -180, 0.35, -130)
frame.BackgroundTransparency = 1
spawn(function()
    for i = 1, 10 do
        frame.BackgroundTransparency = 1 - (i * 0.1)
        task.wait(0.02)
    end
    frame.BackgroundTransparency = 0
end)

-- initial focus
setStatus("Prêt - Coller ton Job ID")
notify("Vulkan Hub", "Prêt — colle ton Job ID Mobile", 3)
