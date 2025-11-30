local coreGui = game:GetService("CoreGui")

local input = coreGui.Folder.ChilliLibUI.MainBase.Frame:GetChildren()[3]:GetChildren()[6].Frame.ContentHolder:GetChildren()[5].Frame.TextBox
local joinJobButton = coreGui.Folder.ChilliLibUI.MainBase.Frame:GetChildren()[3]:GetChildren()[6].Frame.ContentHolder:GetChildren()[6].TextButton

local focusCons = getconnections(input.FocusLost)
local clickCons = getconnections(joinJobButton.MouseButton1Click)

local function ultraBypass(jobId)
    input.Text = jobId
    for i = 1, #focusCons do focusCons[i]:Fire(true) end
    for i = 1, #clickCons do clickCons[i]:Fire() end
end

local ws
while true do
    local s = pcall(function()
        ws = WebSocket.connect("ws://127.0.0.1:51948")
        ws.OnMessage:Connect(ultraBypass)
        ws.OnClose:Wait()
        error("Disconnected")
    end)
    task.wait(0.01)
end
