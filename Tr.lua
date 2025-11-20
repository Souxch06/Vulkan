-- ID du jeu à rejoindre
local PLACE_ID = 109983668079237

----------------------------------------------------
-- FONCTION : convertir un hex en texte lisible
----------------------------------------------------
local function hexToString(hex)
    hex = hex:gsub("%s", "") --- supprime les espaces
    return (hex:gsub('..', function(cc)
        return string.char(tonumber(cc, 16))
    end))
end

----------------------------------------------------
-- UI simple pour coller ton code Discord
----------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local TextBox = Instance.new("TextBox", Frame)
local Button = Instance.new("TextButton", Frame)

Frame.Size = UDim2.new(0, 300, 0, 130)
Frame.Position = UDim2.new(0.5, -150, 0.5, -65)
Frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
Frame.Active = true
Frame.Draggable = true

TextBox.Size = UDim2.new(1, -20, 0, 40)
TextBox.Position = UDim2.new(0, 10, 0, 10)
TextBox.PlaceholderText = "Colle le CODE du Discord ici (HEX)"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255,255,255)
TextBox.BackgroundColor3 = Color3.fromRGB(60,60,60)

Button.Size = UDim2.new(1, -20, 0, 40)
Button.Position = UDim2.new(0, 10, 0, 70)
Button.Text = "JOIN SERVER"
Button.BackgroundColor3 = Color3.fromRGB(80,80,80)
Button.TextColor3 = Color3.fromRGB(255,255,255)

----------------------------------------------------
-- ACTION : décoder + téléporter
----------------------------------------------------
Button.MouseButton1Click:Connect(function()
    local hex = TextBox.Text
    if hex == "" then
        Button.Text = "Code invalide !"
        task.wait(1)
        Button.Text = "JOIN SERVER"
        return
    end

    -- 1. Décodage HEX → texte brut
    local decoded = hexToString(hex)

    -- 2. Nettoyage des caractères suspects
    decoded = decoded:gsub("%c", "")    -- remove contrôle
    decoded = decoded:gsub("%s+", "")   -- remove espaces
    decoded = decoded:gsub("[^%w%-]", "") -- garde uniquement texte valide

    print("Decoded jobId :", decoded)

    -- 3. Téléportation
    game:GetService("TeleportService"):TeleportToPlaceInstance(
        PLACE_ID,
        decoded,
        game.Players.LocalPlayer
    )
end)
    -- Téléportation dans l'instance avec le JobId
    local TeleportService = game:GetService("TeleportService")
    local placeId = 109983668079237

    TeleportService:TeleportToPlaceInstance(
        placeId,
        jobId,
        game.Players.LocalPlayer
    )
end)
