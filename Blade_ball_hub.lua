-- JP dos ScriptsHub - Blade Ball Hub

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JPBladeBallHub"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 400, 0, 500)
Frame.Position = UDim2.new(0.5, -200, 0.5, -250)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 15)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "JP dos ScriptsHub - Blade Ball Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = Frame

local function createToggle(name, position)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 50)
    toggleFrame.Position = position
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    toggleFrame.Parent = Frame
    toggleFrame.AnchorPoint = Vector2.new(0, 0)

    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = name
    toggleLabel.Font = Enum.Font.GothamSemibold
    toggleLabel.TextSize = 20
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.25, 0, 0.6, 0)
    toggleButton.Position = UDim2.new(0.75, 0, 0.2, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggleButton.Text = "OFF"
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 18
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Parent = toggleFrame
    toggleButton.AutoButtonColor = false

    local toggled = false
    toggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            toggleButton.Text = "ON"
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        else
            toggleButton.Text = "OFF"
            toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
    end)

    return toggleButton, function() return toggled end
end

local autoRebateButton, isAutoRebateOn = createToggle("Auto Rebate", UDim2.new(0, 10, 0, 70))
local autoWinButton, isAutoWinOn = createToggle("Auto Win", UDim2.new(0, 10, 0, 130))
local fastClickButton, isFastClickOn = createToggle("Fast Click (1ms)", UDim2.new(0, 10, 0, 190))

-- Auto Rebate Functionality
local function autoRebate()
    while true do
        RunService.Heartbeat:Wait()
        if not isAutoRebateOn() then
            RunService.Heartbeat:Wait(0.1)
            continue
        end
        -- Detect ball and rebate it automatically
        local ball = workspace:FindFirstChild("Ball")
        if ball and ball:IsA("BasePart") then
            local ballPos = ball.Position
            local playerChar = player.Character
            if playerChar and playerChar:FindFirstChild("HumanoidRootPart") then
                local hrp = playerChar.HumanoidRootPart
                local dist = (hrp.Position - ballPos).Magnitude
                if dist < 20 then
                    -- Move player to ball position + offset to hit
                    hrp.CFrame = CFrame.new(ballPos + Vector3.new(0, 5, 0))
                end
            end
        end
    end
end

-- Auto Win Functionality (basic)
local function autoWin()
    while true do
        RunService.Heartbeat:Wait()
        if not isAutoWinOn() then
            RunService.Heartbeat:Wait(0.1)
            continue
        end
        -- Simple method: Always stay near ball and try to hit
        local ball = workspace:FindFirstChild("Ball")
        local playerChar = player.Character
        if ball and playerChar and playerChar:FindFirstChild("HumanoidRootPart") then
            local hrp = playerChar.HumanoidRootPart
            local ballPos = ball.Position
            local dist = (hrp.Position - ballPos).Magnitude
            if dist > 10 then
                hrp.CFrame = CFrame.new(ballPos + Vector3.new(0, 5, 0))
            end
        end
    end
end

-- Fast Click Functionality
local function fastClick()
    while true do
        RunService.Heartbeat:Wait()
        if not isFastClickOn() then
            RunService.Heartbeat:Wait(0.1)
            continue
        end
        local ball = workspace:FindFirstChild("Ball")
        if ball then
            local args = {
                [1] = ball
            }
            -- Trigger a click event on the ball
            local clickEvent = ball:FindFirstChildWhichIsA("ClickDetector")
            if clickEvent then
                clickEvent:FireClick(player)
            end
        end
        wait(0.001)
    end
end

-- Run the functions in separate threads
coroutine.wrap(autoRebate)()
coroutine.wrap(autoWin)()
coroutine.wrap(fastClick)()
