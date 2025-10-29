-- Roblox Steal a Brainrot Scanner avec envoi automatique pour Brainrots ≥ 50 000 000 m/s

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local placeId = 123456789 -- ID réel du jeu
local refreshTime = 5 -- secondes entre chaque scan
local maxDisplayed = 50
local displayThreshold = 10            -- m/s minimum pour affichage GUI
local autoJoinThreshold = 50000000     -- m/s minimum pour auto-join

-- Récupération serveurs publics
local function getServers(cursor)
    local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=100"
    if cursor then url = url.."&cursor="..cursor end
    local response = HttpService:GetAsync(url)
    return HttpService:JSONDecode(response)
end

-- Scanner un serveur pour récupérer Brainrots
local function scanServer(server)
    local brainrots = {}
    local success, result = pcall(function()
        if ReplicatedStorage:FindFirstChild("GetServerBrainrots") then
            return ReplicatedStorage.GetServerBrainrots:InvokeServer(server.id)
        end
        return {}
    end)

    if success then
        for _, br in ipairs(result) do
            local score = br.RarityScore or 0
            if score >= displayThreshold then
                table.insert(brainrots, {name = br.Name, score = score, serverId = server.id})
            end
        end
    end
    return brainrots
end

-- Récupérer tous les Brainrots filtrés
local function getAllBrainrots()
    local allBrainrots = {}
    local cursor
    repeat
        local data = getServers(cursor)
        for _, server in ipairs(data.data) do
            local brs = scanServer(server)
            for _, br in ipairs(brs) do
                table.insert(allBrainrots, br)
            end
        end
        cursor = data.nextPageCursor
    until not cursor
    table.sort(allBrainrots, function(a,b) return a.score > b.score end)
    return allBrainrots
end

-- Création GUI scrollable
local function createGui()
    local screenGui = PlayerGui:FindFirstChild("BrainrotScannerGui") or Instance.new("ScreenGui")
    screenGui.Name = "BrainrotScannerGui"
    screenGui.Parent = PlayerGui

    local frame = screenGui:FindFirstChild("MainFrame") or Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 400, 0, 600)
    frame.Position = UDim2.new(0.5, -200, 0.5, -300)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Parent = screenGui

    local scrollingFrame = screenGui:FindFirstChild("ScrollingFrame") or Instance.new("ScrollingFrame")
    scrollingFrame.Name = "ScrollingFrame"
    scrollingFrame.Size = UDim2.new(1, -20, 1, -20)
    scrollingFrame.Position = UDim2.new(0, 10, 0, 10)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
    scrollingFrame.ScrollBarThickness = 10
    scrollingFrame.Parent = frame

    local uiList = scrollingFrame:FindFirstChild("UIListLayout") or Instance.new("UIListLayout")
    uiList.Padding = UDim.new(0,5)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Parent = scrollingFrame

    return scrollingFrame
end

-- Mettre à jour le GUI et auto-join pour Brainrots ultra rapides
local function updateGui(brainrots, scrollingFrame)
    scrollingFrame:ClearAllChildren()
    for i, br in ipairs(brainrots) do
        if i > maxDisplayed then break end
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 40)
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Text = br.name.." | Score: "..br.score
        button.Parent = scrollingFrame
        button.MouseButton1Click:Connect(function()
            print("Rejoindre "..br.name.." sur serveur "..br.serverId)
            TeleportService:TeleportToPlaceInstance(placeId, br.serverId, LocalPlayer)
        end)
        -- Auto-join si score ≥ autoJoinThreshold
        if br.score >= autoJoinThreshold then
            print("Brainrot ultra rapide détecté ! Auto-join : "..br.name)
            TeleportService:TeleportToPlaceInstance(placeId, br.serverId, LocalPlayer)
            return -- quitte la boucle pour ne pas lancer plusieurs Teleports
        end
    end
    scrollingFrame.CanvasSize = UDim2.new(0,0,0,math.max(#brainrots*45, scrollingFrame.AbsoluteSize.Y))
end

-- Boucle principale toutes les 5 secondes
spawn(function()
    local scrollingFrame = createGui()
    while true do
        local allBrainrots = getAllBrainrots()
        if #allBrainrots > 0 then
            print("Top Brainrot détecté : "..allBrainrots[1].name.." | Score: "..allBrainrots[1].score)
        end
        updateGui(allBrainrots, scrollingFrame)
        wait(refreshTime)
    end
end)
