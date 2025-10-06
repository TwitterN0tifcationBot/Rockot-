local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local webhookUrl = 'https://discord.com/api/webhooks/1424874312531316736/HIJuglwwcK-nQNIVQyfWeRcw2XMzBXwufEDneZKU6_UB4QghjnVajH64p068YlTP4uud' -- Replace with your actual webhook URL

local function sendWebhookMessage(errorMessage)
    local data = {
        ["content"] = "Script Error: " .. errorMessage
    }
    local jsonData = HttpService:JSONEncode(data)

    local success, postError = pcall(function()
        HttpService:PostAsync(webhookUrl, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if not success then
        warn("Failed to send webhook: " .. tostring(postError))
    end
end

local function addHighlightToCharacter(character)
    if character:FindFirstChild("PlayerESPHighlight") then
        return
    end
    local ESP = Instance.new("Highlight")
    ESP.Name = "PlayerESPHighlight"
    ESP.FillColor = Color3.new(0.843137, 0.627451, 1)
    ESP.OutlineColor = Color3.new(0, 0, 0)
    ESP.Parent = character
end

local function onCharacterAdded(character)
    local success, err = pcall(function()
        addHighlightToCharacter(character)
    end)
    if not success then
        sendWebhookMessage(tostring(err))
    end
end

local function setupPlayer(player)
    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end

local function main()
    for _, player in Players:GetPlayers() do
        setupPlayer(player)
    end
    Players.PlayerAdded:Connect(setupPlayer)
end

local success, err = pcall(main)
if not success then
    print("Error: " .. tostring(err))
    sendWebhookMessage(tostring(err))
end

-- Flight Script
local flying = false
local flightSpeed = 50

local function startFlying()
    flying = true
    while flying do
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local rootPart = character:WaitForChild("HumanoidRootPart")

        if not humanoid or not rootPart then return end

        local moveVector = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector = moveVector + (workspace.CurrentCamera.CoordinateFrame.lookVector * flightSpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector = moveVector - (workspace.CurrentCamera.CoordinateFrame.lookVector * flightSpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector = moveVector - (workspace.CurrentCamera.CoordinateFrame.rightVector * flightSpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector = moveVector + (workspace.CurrentCamera.CoordinateFrame.rightVector * flightSpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVector = moveVector + (Vector3.new(0, flightSpeed, 0))
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveVector = moveVector - (Vector3.new(0, flightSpeed, 0))
        end

        humanoid:Move(moveVector, true)
        humanoid.PlatformStand = true

        wait()
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Semicolon then
        if flying then
            flying = false
        else
            startFlying()
        end
    end
end)
