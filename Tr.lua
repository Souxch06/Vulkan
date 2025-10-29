-- Roblox Steal a Brainrot Scanner stylé, déplaçable et animé
-- Auto-join pour Brainrots ≥ 50 000 000 m/s

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local placeId = 123456789
local refreshTime = 5
local maxDisplayed = 30
local displayThreshold = 10
local autoJoinThreshold = 50000000

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

-- Création GUI déplaçable et esthétique
local function createGui()
    local screenGui = PlayerGui:FindFirstChild("BrainrotScannerGui") or Instance.new("ScreenGui")
    screenGui.Name = "BrainrotScannerGui"
    screenGui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0.02, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "Brainrot Scanner"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.Parent = frame

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 0)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextScaled = true
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Parent = frame
    closeButton.MouseButton1Click:Connect(function()
        screenGui.Enabled = false
    end)

    -- Drag & Drop
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Name = "ScrollingFrame"
    scrollingFrame.Size = UDim2.new(1, -10, 1, -40)
    scrollingFrame.Position = UDim2.new(0, 5, 0, 35)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
    scrollingFrame.ScrollBarThickness = 8
    scrollingFrame.Parent = frame

    local uiList = Instance.new("UIListLayout")
    uiList.Padding = UDim.new(0,3)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Parent = scrollingFrame

    return scrollingFrame
end

-- Mettre à jour GUI avec animation et auto-join
local function updateGui(brainrots, scrollingFrame)
    scrollingFrame:ClearAllChildren()
    for i, br in ipairs(brainrots) do
        if i > maxDisplayed then break end
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 35)
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Text = br.name.." | "..br.score
        button.Font = Enum.Font.Gotham
        button.TextScaled = true
        button.BackgroundTransparency = 0.2
        button.Parent = scrollingFrame

        -- Animation d'apparition
        button.BackgroundTransparency = 1
        local tween = TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.2})
        tween:Play()

        button.MouseButton1Click:Connect(function()
            TeleportService:TeleportToPlaceInstance(placeId, br.serverId, LocalPlayer)
        end)

        if br.score >= autoJoinThreshold then
            TeleportService:TeleportToPlaceInstance(placeId, br.serverId, LocalPlayer)
            return
        end
    end
    scrollingFrame.CanvasSize = UDim2.new(0,0,0,math.max(#brainrots*38, scrollingFrame.AbsoluteSize.Y))
end

-- Boucle principale
spawn(function()
    local scrollingFrame = createGui()
    while true do
        local allBrainrots = getAllBrainrots()
        updateGui(allBrainrots, scrollingFrame)
        wait(refreshTime)
    end
end)
