--// UI simple pour coller le JobId
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local TextBox = Instance.new("TextBox", Frame)
local Button = Instance.new("TextButton", Frame)

Frame.Size = UDim2.new(0, 300, 0, 120)
Frame.Position = UDim2.new(0.5, -150, 0.5, -60)
Frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
Frame.Active = true
Frame.Draggable = true

TextBox.Size = UDim2.new(1, -20, 0, 40)
TextBox.Position = UDim2.new(0, 10, 0, 10)
TextBox.PlaceholderText = "Colle le Job ID ici"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255,255,255)
TextBox.BackgroundColor3 = Color3.fromRGB(60,60,60)

Button.Size = UDim2.new(1, -20, 0, 40)
Button.Position = UDim2.new(0, 10, 0, 60)
Button.Text = "JOIN SERVER"
Button.BackgroundColor3 = Color3.fromRGB(80,80,80)
Button.TextColor3 = Color3.fromRGB(255,255,255)


--// Action quand tu appuies sur le bouton
Button.MouseButton1Click:Connect(function()
    local jobId = TextBox.Text

    if jobId == "" or jobId == nil then
        Button.Text = "JobId invalide !"
        task.wait(1)
        Button.Text = "JOIN SERVER"
        return
    end

    -- Téléportation dans l'instance avec le JobId
    local TeleportService = game:GetService("TeleportService")
    local placeId = 109983668079237

    TeleportService:TeleportToPlaceInstance(
        placeId,
        jobId,
        game.Players.LocalPlayer
    )
end)
