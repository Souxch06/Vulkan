local JobIDGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Barrier = Instance.new("TextLabel")
local Label = Instance.new("TextLabel")
local PasteJobID = Instance.new("TextBox")
local JoinGame = Instance.new("TextButton")
local CopyJobID = Instance.new("TextButton")
local Close = Instance.new("TextButton")
local GuiService = game:GetService("StarterGui")
local TeleService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

JobIDGui.Name = "JobIDGui"
JobIDGui.Parent = CoreGui
JobIDGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = JobIDGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
MainFrame.BorderColor3 = Color3.new(1, 0.666667, 0)
MainFrame.BorderSizePixel = 3
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 307, 0, 137)
MainFrame.Active = true
MainFrame.Draggable = true

Barrier.Name = "Barrier"
Barrier.Parent = MainFrame
Barrier.BackgroundColor3 = Color3.new(1, 0.666667, 0)
Barrier.BorderSizePixel = 0
Barrier.Position = UDim2.new(0, 0, 0.186000004, 0)
Barrier.Size = UDim2.new(1, 0, 0, 3)
Barrier.Font = Enum.Font.SourceSans
Barrier.Text = ""
Barrier.TextColor3 = Color3.new(0, 0, 0)
Barrier.TextSize = 14

Label.Name = "Label"
Label.Parent = MainFrame
Label.AnchorPoint = Vector2.new(0.5, 0)
Label.BackgroundColor3 = Color3.new(1, 1, 1)
Label.BackgroundTransparency = 1
Label.Position = UDim2.new(0.5, 0, 0, 0)
Label.Size = UDim2.new(0, 200, 0, 28)
Label.Font = Enum.Font.Nunito
Label.Text = "夜明けのゲームに参加"
Label.TextColor3 = Color3.new(1, 0.666667, 0)
Label.TextSize = 28

PasteJobID.Name = "PasteJobID"
PasteJobID.Parent = MainFrame
PasteJobID.AnchorPoint = Vector2.new(0.5, 0)
PasteJobID.BackgroundColor3 = Color3.new(1, 1, 1)
PasteJobID.Position = UDim2.new(0.5, 0, 0.275999993, 0)
PasteJobID.Size = UDim2.new(0, 283, 0, 27)
PasteJobID.Font = Enum.Font.SourceSans
PasteJobID.PlaceholderColor3 = Color3.new(0, 0, 0)
PasteJobID.PlaceholderText = "Paste Job ID in here."
PasteJobID.Text = ""
PasteJobID.TextColor3 = Color3.new(0, 0, 0)
PasteJobID.TextSize = 20

JoinGame.Name = "JoinGame"
JoinGame.Parent = MainFrame
JoinGame.AnchorPoint = Vector2.new(0.5, 0)
JoinGame.BackgroundColor3 = Color3.new(1, 0.666667, 0)
JoinGame.Position = UDim2.new(0.5, 0, 0.73299998, 0)
JoinGame.Size = UDim2.new(0, 229, 0, 26)
JoinGame.Font = Enum.Font.SourceSans
JoinGame.Text = "  Join Game"
JoinGame.TextColor3 = Color3.new(0, 0, 0)
JoinGame.TextSize = 25
JoinGame.TextXAlignment = Enum.TextXAlignment.Left
JoinGame.MouseButton1Down:connect(function()
   if CoreGui.RobloxPromptGui:FindFirstChild("promptOverlay") then
       CoreGui.RobloxPromptGui.promptOverlay.Visible = false
   end
TeleService:TeleportToPlaceInstance(game.PlaceId,PasteJobID.Text,Players.LocalPlayer)
if CoreGui.RobloxPromptGui.promptOverlay:WaitForChild("ErrorPrompt") then
       if CoreGui.RobloxPromptGui.promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ButtonArea:FindFirstChild("OkButton") then
           game:GetService("GuiService"):ClearError()
           GuiService:SetCore("SendNotification", {Title = "夜明けのゲームに参加",Text = "Error, Invalid Job ID";})
       else
           GuiService:SetCore("SendNotification", {Title = "夜明けのゲームに参加",Text = "Successful, Joining Server";})  
       end
end
end)

CopyJobID.Name = "CopyJobID"
CopyJobID.Parent = MainFrame
CopyJobID.AnchorPoint = Vector2.new(0.5, 0)
CopyJobID.BackgroundColor3 = Color3.new(1, 0.666667, 0)
CopyJobID.Position = UDim2.new(0.5, 0, 0.542999983, 0)
CopyJobID.Size = UDim2.new(0, 229, 0, 26)
CopyJobID.Font = Enum.Font.SourceSans
CopyJobID.Text = "Copy Job ID  "
CopyJobID.TextColor3 = Color3.new(0, 0, 0)
CopyJobID.TextSize = 25
CopyJobID.TextXAlignment = Enum.TextXAlignment.Right
CopyJobID.MouseButton1Down:connect(function()
GuiService:SetCore("SendNotification", {Title = "夜明けのゲームに参加",Text = "Copied Job ID to Your Clipboard";})
setclipboard(game.JobId)
end)

Close.Name = "Close"
Close.Parent = MainFrame
Close.BackgroundColor3 = Color3.new(1, 1, 1)
Close.BackgroundTransparency = 1
Close.Position = UDim2.new(0.917502344, 0, 0.0291970801, 0)
Close.Size = UDim2.new(0, 25, 0, 13)
Close.Font = Enum.Font.SourceSans
Close.Text = "x"
Close.TextColor3 = Color3.new(1, 0.666667, 0)
Close.TextSize = 30
Close.MouseButton1Down:connect(function()
GuiService:SetCore("SendNotification", {Title = "夜明けのゲームに参加",Text = "Closing Gui";})
JobIDGui:Destroy()
end)box.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
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
