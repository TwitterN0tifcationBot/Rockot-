local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local ESPEnabled = true
local ESPVisible = true

local function createESP(player)
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.fromRGB(173, 127, 168) -- Light purple
    box.Visible = ESPVisible

    local function updateESP()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
            if onScreen then
                box.Size = Vector2.new(2000 / vector.Z, 2000 / vector.Z)
                box.Position = Vector2.new(vector.X - box.Size.X / 2, vector.Y - box.Size.Y / 2)
                box.Visible = ESPVisible
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end

    RunService.RenderStepped:Connect(function()
        if ESPEnabled then
            updateESP()
        end
    end)

    player.CharacterAdded:Connect(function()
        updateESP()
    end)

    return box
end

local function createButtonGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 50)
    frame.Position = UDim2.new(0.5, -100, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.Parent = screenGui

    local buttons = {
        "Aimbot",
        "ESP",
        "Client Btools",
        "Spam",
        "Flight",
        "Give All Tools",
        "Explorer",
        "Download",
        "Fling",
        "Spin"
    }

    for i, buttonName in ipairs(buttons) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -10, 0, 30)
        button.Position = UDim2.new(0, 0, 0, (i-1) * 30)
        button.Text = buttonName
        button.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        button.Parent = frame
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
            screenGui.Enabled = not screenGui.Enabled
        end
    end)

    return screenGui
end

local function initializeESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            local box = createESP(player)
            table.insert(espBoxes, box)
        end
    end

    Players.PlayerAdded:Connect(function(player)
        if player ~= Players.LocalPlayer then
            local box = createESP(player)
            table.insert(espBoxes, box)
        end
    end)
end

local espBoxes = {}
initializeESP()
createButtonGui()
