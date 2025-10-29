-- Tr.lua - Vulkan Hub v2 (Auto-Joiner uniquement) - Steal a Brainrot
-- Style: Hub Pro + Pop Neon
-- Auteur: Vulkan Hub (pour Souxch06)
-- NOTE: Colle ce fichier dans ton repo puis lance via:
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Souxch06/Vulkan/main/Tr.lua?v="..tostring(os.time())))()

-- Services
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Utilitaires
local function cleanHex(str)
    if not str or type(str) ~= "string" then return "" end
    -- extrait les caractères hex et retire les préfixes/paramètres d'URL
    -- gère des cas comme: ?privateServerLinkCode=ABC123 ou 0xABC ou des urls complètes
    -- cherche la première séquence hex plausible (>=6 chars)
    local s = str
    -- si c'est une url, tente d'extraire le code après '=' ou dernier segment
    local u = s:match("[?&]privateServerLinkCode=([^&]+)")
    if u and #u > 0 then s = u end
    -- si c'est une url Roblox avec code à la fin
    if s:match("/([^/]+)$") then
        local last = s:match("/([^/]+)$")
        if last and #last > 0 then s = last end
    end
    -- supprime les espaces et 0x
    s = s:gsub("%s+", ""):gsub("^0x","")
    -- ne garde que hex
    local cleaned = s:gsub("[^0-9A-Fa-f]","")
    -- si cleaned trop court, retourne empty
    if #cleaned < 6 then return "" end
    return cleaned
end

local function tryGetClipboard()
    -- Several exploits expose different functions; try all known variants
    local ok, val
    if type(getclipboard) == "function" then
        ok, val = pcall(getclipboard)
        if ok and val and #tostring(val) > 0 then return tostring(val) end
    end
    if type(read_clipboard) == "function" then
        ok, val = pcall(read_clipboard)
        if ok and val and #tostring(val) > 0 then return tostring(val) end
    end
    if type(syn) == "table" and type(syn.get_clipboard) == "function" then
        ok, val = pcall(syn.get_clipboard)
        if ok and val and #tostring(val) > 0 then return tostring(val) end
    end
    -- last resort: try to use 'clipboard' field in environment (rare)
    if _G and _G.__clipboard and type(_G.__clipboard) == "string" then
        return _G.__clipboard
    end
    return nil
end

local function notify(title, text, dur)
    dur = dur or 3
    pcall(function()
        local sg = game:GetService("StarterGui")
        if sg and sg.SetCore then
            sg:SetCore("SendNotification", {Title = title; Text = text; Duration = dur})
            return
        end
    end)
    -- fallback: temporary UI label
    pcall(function()
        local g = Instance.new("ScreenGui")
        g.Name = "VulkanHub_NotifyFallback"
        g.ResetOnSpawn = false
        g.Parent = CoreGui
        local lbl = Instance.new("TextLabel", g)
        lbl.Size = UDim2.new(0, 380, 0, 48)
        lbl.Position = UDim2.new(0.5, -190, 0.06, 0)
        lbl.TextScaled = true
        lbl.BackgroundTransparency = 0.15
        lbl.BackgroundColor3 = Color3.fromRGB(28,8,40)
        lbl.TextColor3 = Color3.fromRGB(245,245,255)
        lbl.Text = title.." • "..text
        task.delay(dur, function() pcall(function() g:Destroy() end) end)
    end)
end

-- UI Build (Hub Pro)
local gui = Instance.new("ScreenGui")
gui.Name = "VulkanHubGui_v2"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local root = Instance.new("Frame", gui)
root.Size = UDim2.new(0, 360, 0, 220)
root.Position = UDim2.new(0.5, -180, 0.45, -110)
root.AnchorPoint = Vector2.new(0.5, 0.5)
root.BackgroundTransparency = 1
root.BorderSizePixel = 0
root.Active = true
root.Draggable = true

-- pop neon container (shadow + panel)
local shadow = Instance.new("Frame", root)
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(12,6,20)
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
shadow.BackgroundTransparency = 0.15
shadow.ClipsDescendants = true
shadow.Rotation = 0

local panel = Instance.new("Frame", root)
panel.Size = UDim2.new(1, 0, 1, 0)
panel.Position = UDim2.new(0, 0, 0, 0)
panel.BackgroundColor3 = Color3.fromRGB(28,8,44)
panel.BorderSizePixel = 0
panel.ZIndex = 1
panel.BackgroundTransparency = 0

local glow = Instance.new("UIGradient", panel)
glow.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 40, 230)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 80, 255))
}
glow.Rotation = 45

-- rounded corners
local uc = Instance.new("UICorner", panel)
uc.CornerRadius = UDim.new(0, 14)

-- Title
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, -24, 0, 44)
title.Position = UDim2.new(0, 12, 0, 8)
title.BackgroundTransparency = 1
title.Text = "VULKAN HUB"
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(245,245,255)
title.Font = Enum.Font.GothamBold
title.TextYAlignment = Enum.TextYAlignment.Center

-- JobID box
local jobBox = Instance.new("TextBox", panel)
jobBox.Size = UDim2.new(1, -24, 0, 48)
jobBox.Position = UDim2.new(0, 12, 0, 60)
jobBox.BackgroundColor3 = Color3.fromRGB(36, 14, 60)
jobBox.TextColor3 = Color3.fromRGB(235,235,255)
jobBox.PlaceholderText = "Colle ton Job ID Mobile ou URL ici"
jobBox.ClearTextOnFocus = false
jobBox.Text = ""
jobBox.Font = Enum.Font.Gotham

local boxCorner = Instance.new("UICorner", jobBox)
boxCorner.CornerRadius = UDim.new(0, 10)

-- Buttons
local btnJoin = Instance.new("TextButton", panel)
btnJoin.Size = UDim2.new(0.48, -10, 0, 40)
btnJoin.Position = UDim2.new(0, 12, 0, 116)
btnJoin.Text = "Join maintenant"
btnJoin.Font = Enum.Font.GothamBold
btnJoin.TextScaled = true
btnJoin.BackgroundColor3 = Color3.fromRGB(155, 64, 255)
btnJoin.TextColor3 = Color3.fromRGB(16,16,16)
local btnJoinCorner = Instance.new("UICorner", btnJoin)
btnJoinCorner.CornerRadius = UDim.new(0, 8)

local btnAuto = Instance.new("TextButton", panel)
btnAuto.Size = UDim2.new(0.48, -10, 0, 40)
btnAuto.Position = UDim2.new(0.52, 0, 0, 116)
btnAuto.Text = "Auto Join"
btnAuto.Font = Enum.Font.GothamBold
btnAuto.TextScaled = true
btnAuto.BackgroundColor3 = Color3.fromRGB(96, 160, 255)
btnAuto.TextColor3 = Color3.fromRGB(16,16,16)
local btnAutoCorner = Instance.new("UICorner", btnAuto)
btnAutoCorner.CornerRadius = UDim.new(0, 8)

local btnClipboard = Instance.new("TextButton", panel)
btnClipboard.Size = UDim2.new(0.48, -10, 0, 32)
btnClipboard.Position = UDim2.new(0, 12, 0, 164)
btnClipboard.Text = "Coller depuis clipboard"
btnClipboard.Font = Enum.Font.Gotham
btnClipboard.TextScaled = true
btnClipboard.BackgroundColor3 = Color3.fromRGB(240,240,240)
btnClipboard.TextColor3 = Color3.fromRGB(12,12,12)
local btnCbCorner = Instance.new("UICorner", btnClipboard)
btnCbCorner.CornerRadius = UDim.new(0, 8)

local btnClose = Instance.new("TextButton", panel)
btnClose.Size = UDim2.new(0, 30, 0, 30)
btnClose.Position = UDim2.new(1, -42, 0, 10)
btnClose.Text = "✕"
btnClose.Font = Enum.Font.Gotham
btnClose.TextScaled = true
btnClose.BackgroundTransparency = 0.25
btnClose.BackgroundColor3 = Color3.fromRGB(60, 12, 80)
btnClose.TextColor3 = Color3.fromRGB(255,255,255)
local btnCloseCorner = Instance.new("UICorner", btnClose)
btnCloseCorner.CornerRadius = UDim.new(0, 6)

local statusLabel = Instance.new("TextLabel", panel)
statusLabel.Size = UDim2.new(1, -24, 0, 18)
statusLabel.Position = UDim2.new(0, 12, 0, 204)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "État : prêt"
statusLabel.TextColor3 = Color3.fromRGB(210,210,255)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Font = Enum.Font.Gotham

-- Pop neon entrance (scale + glow pulse)
panel.Size = UDim2.new(0, 360, 0, 220)
panel.AnchorPoint = Vector2.new(0.5,0.5)
panel.Position = UDim2.new(0.5, 0, 0.45, 0)
panel.Rotation = 0
panel.BackgroundTransparency = 1
spawn(function()
    for i = 1, 8 do
        panel.BackgroundTransparency = 1 - (i * 0.12)
        panel.Position = UDim2.new(0.5, 0, 0.45, -8 + i*1.5)
        task.wait(0.02)
    end
    panel.BackgroundTransparency = 0
    -- small neon pulse
    for j = 1, 2 do
        panel.BackgroundColor3 = Color3.fromRGB(36,14,60)
        task.wait(0.04)
        panel.BackgroundColor3 = Color3.fromRGB(44,18,68)
        task.wait(0.04)
    end
end)

-- Logic
local autoJoining = false
local autoThread

local function setStatus(text)
    pcall(function() statusLabel.Text = "État : "..tostring(text) end)
end

local function attemptTeleport(hex)
    if not hex or #hex < 6 then
        setStatus("Job ID invalide")
        notify("Vulkan Hub", "Job ID invalide", 2)
        return false
    end
    setStatus("Tentative de join...")
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, hex, Player)
    end)
    return true
end

btnJoin.MouseButton1Click:Connect(function()
    local raw = jobBox.Text or ""
    local hex = cleanHex(raw)
    if hex == "" then
        setStatus("Aucun Job ID")
        notify("Vulkan Hub", "Aucun Job ID détecté", 2)
        return
    end
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
    local hex = cleanHex(raw)
    if hex == "" then
        setStatus("Aucun Job ID")
        notify("Vulkan Hub", "Aucun Job ID détecté", 2)
        return
    end
    autoJoining = true
    setStatus("Auto-join actif")
    notify("Vulkan Hub", "Auto-join activé", 2)
    autoThread = spawn(function()
        while autoJoining and gui.Parent do
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, hex, Player) end)
            task.wait(2.5)
        end
    end)
end)

btnClipboard.MouseButton1Click:Connect(function()
    local clip = tryGetClipboard()
    if not clip or #tostring(clip) == 0 then
        setStatus("Clipboard non accessible")
        notify("Vulkan Hub", "Clipboard non accessible — colle manuellement", 3)
        return
    end
    -- nettoie et affiche
    local extracted = cleanHex(tostring(clip))
    if extracted == "" then
        -- maybe the clipboard contains an URL style with params; try to extract last alnum segment
        local last = tostring(clip):match("([^%/?&=#]+)$") or tostring(clip)
        extracted = cleanHex(last)
    end
    if extracted == "" then
        jobBox.Text = tostring(clip)
        setStatus("Collé (non reconnu)")
        notify("Vulkan Hub", "Contenu collé mais non reconnu", 3)
    else
        jobBox.Text = extracted
        setStatus("Collé & nettoyé")
        notify("Vulkan Hub", "Collé et nettoyé", 2)
    end
end)

btnClose.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- final hint
setStatus("Prêt - colle ton Job ID")
notify("Vulkan Hub", "Prêt — utilise Coller ou saisis ton Job ID", 3)
