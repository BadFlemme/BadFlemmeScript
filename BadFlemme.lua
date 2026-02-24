-- BadFlemme Script - Universal
-- Generated with PELI EDITOR v3

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end)

local CONFIG = {
    KingMode = false,
    AntiAFK = false,
    WalkSpeed = 50,
    JumpPower = 150,
    SpeedBoost = false,
    SuperJump = false,
    Fly = false,
    FlySpeed = 50,
    PlayerESP = false,
    ESPNames = false,
    ESPDistance = false,
    Tracers = false,
    FPSBoost = false,
    DisableParticles = false,
    ShowFPS = false,
    RemoveDecals = false,
    RemoveInvisibleParts = false,
    CleanParticles = false,
    AimAssist = false,
    AimTeamCheck = false,
    AimFOV = 120,
    AimSmooth = 5,
    AimKey = Enum.KeyCode.LeftAlt,
}

local playerESPCache = {}
local currentTab = "AFK"
local connections = {}

local COLORS = {
    Primary = Color3.fromRGB(140, 140, 140),
    Secondary = Color3.fromRGB(140, 140, 140),
    Accent = Color3.fromRGB(140, 140, 140),
    Background = Color3.fromRGB(15, 15, 15),
    DarkBG = Color3.fromRGB(25, 25, 25),
    Frame = Color3.fromRGB(35, 35, 35),
    White = Color3.fromRGB(255, 255, 255),
    Gray = Color3.fromRGB(60, 60, 60),
    Green = Color3.fromRGB(50, 205, 50),
    Red = Color3.fromRGB(255, 50, 50)
}

local function tween(obj, props, duration, style, direction)
    if not obj or not obj.Parent then return end
    pcall(function() TweenService:Create(obj, TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out), props):Play() end)
end

local function notifyImportant(text)
    pcall(function() game.StarterGui:SetCore("SendNotification", {Title = "BadFlemme Script", Text = text, Duration = 3}) end)
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner", parent)
    corner.CornerRadius = UDim.new(0, radius or 10)
    return corner
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke", parent)
    stroke.Color = color or COLORS.Primary
    stroke.Thickness = thickness or 2
    return stroke
end

local function createGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient", parent)
    gradient.Color = colors
    gradient.Rotation = rotation or 0
    return gradient
end

local function clearPlayerESP(plr)
    pcall(function()
        if playerESPCache[plr] then
            for _, obj in pairs(playerESPCache[plr]) do pcall(function() obj:Destroy() end) end
            playerESPCache[plr] = nil
        end
        if connections["pESP_" .. plr.Name] then
            pcall(function() connections["pESP_" .. plr.Name]:Disconnect() end)
            connections["pESP_" .. plr.Name] = nil
        end
    end)
end

local function createPlayerESP(targetPlayer)
    if targetPlayer == player or not CONFIG.PlayerESP then return end
    task.spawn(function()
        pcall(function()
            local char = targetPlayer.Character
            if not char then return end
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            local head = char:WaitForChild("Head", 5)
            if not hrp or not head then return end
            clearPlayerESP(targetPlayer)
            playerESPCache[targetPlayer] = {}
            local highlight = Instance.new("Highlight")
            highlight.FillColor = COLORS.Primary
            highlight.OutlineColor = COLORS.White
            highlight.FillTransparency = 0.5
            highlight.Parent = char
            table.insert(playerESPCache[targetPlayer], highlight)
            local billboard = Instance.new("BillboardGui")
            billboard.Adornee = head
            billboard.Size = UDim2.new(0, 200, 0, 60)
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = char
            local nameLabel = Instance.new("TextLabel", billboard)
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = targetPlayer.Name
            nameLabel.TextColor3 = COLORS.Primary
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 16
            nameLabel.TextStrokeTransparency = 0.5
            nameLabel.Visible = CONFIG.ESPNames
            local distLabel = Instance.new("TextLabel", billboard)
            distLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distLabel.BackgroundTransparency = 1
            distLabel.Text = ""
            distLabel.TextColor3 = COLORS.Green
            distLabel.Font = Enum.Font.GothamBold
            distLabel.TextSize = 14
            distLabel.TextStrokeTransparency = 0.5
            distLabel.Visible = CONFIG.ESPDistance
            table.insert(playerESPCache[targetPlayer], billboard)
            local myChar = player.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if CONFIG.Tracers and myHRP then
                local a1 = Instance.new("Attachment", hrp)
                local a2 = Instance.new("Attachment", myHRP)
                local beam = Instance.new("Beam", a1)
                beam.Attachment0 = a1
                beam.Attachment1 = a2
                beam.Color = ColorSequence.new(COLORS.Primary)
                beam.FaceCamera = true
                beam.Width0 = 0.15
                beam.Width1 = 0.15
                table.insert(playerESPCache[targetPlayer], a1)
                table.insert(playerESPCache[targetPlayer], a2)
                table.insert(playerESPCache[targetPlayer], beam)
            end
            connections["pESP_" .. targetPlayer.Name] = RunService.Heartbeat:Connect(function()
                pcall(function()
                    if not billboard.Parent or not CONFIG.PlayerESP then
                        clearPlayerESP(targetPlayer)
                        return
                    end
                    nameLabel.Visible = CONFIG.ESPNames
                    distLabel.Visible = CONFIG.ESPDistance
                    if CONFIG.ESPDistance and player.Character then
                        local myHRP2 = player.Character:FindFirstChild("HumanoidRootPart")
                        local theirHRP = char:FindFirstChild("HumanoidRootPart")
                        if myHRP2 and theirHRP then
                            distLabel.Text = "[" .. math.floor((myHRP2.Position - theirHRP.Position).Magnitude) .. "]"
                        end
                    end
                end)
            end)
        end)
    end)
end

local function updateAllPlayerESP()
    for plr, _ in pairs(playerESPCache) do clearPlayerESP(plr) end
    if CONFIG.PlayerESP then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character then createPlayerESP(plr) end
        end
    end
end

-- =============================================
-- SYSTÈME RÉVERSIBLE FPS
-- =============================================
local fpsCache = { decals = {}, invisible = {}, particles = {} }

local function applyRemoveDecals(enabled)
    if enabled then
        fpsCache.decals = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("Decal") or obj:IsA("Texture") then
                    table.insert(fpsCache.decals, {obj = obj, transparency = obj.Transparency})
                    obj.Transparency = 1
                end
            end)
        end
    else
        for _, entry in pairs(fpsCache.decals) do
            pcall(function() if entry.obj and entry.obj.Parent then entry.obj.Transparency = entry.transparency end end)
        end
        fpsCache.decals = {}
    end
end

local function applyRemoveInvisibleParts(enabled)
    if enabled then
        fpsCache.invisible = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("BasePart") and obj.Transparency == 1 and not obj.CanCollide then
                    table.insert(fpsCache.invisible, {obj = obj, castShadow = obj.CastShadow})
                    obj.CastShadow = false
                    obj.LocalTransparencyModifier = 1
                end
            end)
        end
    else
        for _, entry in pairs(fpsCache.invisible) do
            pcall(function()
                if entry.obj and entry.obj.Parent then
                    entry.obj.CastShadow = entry.castShadow
                    entry.obj.LocalTransparencyModifier = 0
                end
            end)
        end
        fpsCache.invisible = {}
    end
end

local function applyCleanParticles(enabled)
    if enabled then
        fpsCache.particles = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
                    table.insert(fpsCache.particles, {obj = obj, enabled = obj.Enabled})
                    obj.Enabled = false
                end
            end)
        end
    else
        for _, entry in pairs(fpsCache.particles) do
            pcall(function() if entry.obj and entry.obj.Parent then entry.obj.Enabled = entry.enabled end end)
        end
        fpsCache.particles = {}
    end
end

-- =============================================
-- FLY SYSTEM
-- =============================================
local flyParts = {}

local function stopFly()
    CONFIG.Fly = false
    for _, p in pairs(flyParts) do pcall(function() p:Destroy() end) end
    flyParts = {}
    if connections.fly then connections.fly:Disconnect() connections.fly = nil end
    pcall(function()
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hum then hum.PlatformStand = false end
    end)
end

local function startFly()
    stopFly()
    CONFIG.Fly = true

    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hrp or not hum then return end

    hum.PlatformStand = true

    -- BodyVelocity pour le mouvement
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bv.P = 1e4
    bv.Parent = hrp
    table.insert(flyParts, bv)

    -- BodyGyro pour garder l'orientation
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    bg.P = 1e4
    bg.D = 100
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp
    table.insert(flyParts, bg)

    connections.fly = RunService.RenderStepped:Connect(function()
        if not CONFIG.Fly then stopFly() return end
        pcall(function()
            local c = player.Character
            if not c then return end
            local h = c:FindFirstChild("HumanoidRootPart")
            if not h then return end

            local cam = workspace.CurrentCamera
            local speed = CONFIG.FlySpeed

            -- Direction basée sur la caméra
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + cam.CFrame.RightVector
            end
            -- Montée / descente avec espace et shift
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end

            if moveDir.Magnitude > 0 then
                bv.Velocity = moveDir.Unit * speed
            else
                bv.Velocity = Vector3.new(0, 0, 0)
            end

            -- Oriente vers la direction de la caméra
            bg.CFrame = CFrame.new(h.Position, h.Position + cam.CFrame.LookVector)
        end)
    end)
end

-- Toggle fly avec la touche E
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.E then
        if CONFIG.Fly then
            stopFly()
            notifyImportant("Fly désactivé")
        else
            startFly()
            notifyImportant("Fly activé ! (E = toggle, Shift = descendre)")
        end
    end
end)

-- Recrée le fly après respawn
player.CharacterAdded:Connect(function()
    if CONFIG.Fly then
        task.wait(1)
        startFly()
    end
end)

-- =============================================
-- AIM ASSIST
-- =============================================
local Camera = workspace.CurrentCamera

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Radius = 120
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 1.5
fovCircle.Filled = false
fovCircle.Transparency = 0.8

local function updateFovCircle()
    local vp = Camera.ViewportSize
    fovCircle.Position = Vector2.new(vp.X / 2, vp.Y / 2)
    fovCircle.Radius = CONFIG.AimFOV
end

local function getBestTarget()
    local bestPlayer = nil
    local bestDist = math.huge
    local vp = Camera.ViewportSize
    local screenCenter = Vector2.new(vp.X / 2, vp.Y / 2)
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr == player then continue end
        if CONFIG.AimTeamCheck and plr.Team == player.Team then continue end
        local char = plr.Character
        if not char then continue end
        local head = char:FindFirstChild("Head")
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if not head or not hum or hum.Health <= 0 then continue end
        local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
        if not onScreen then continue end
        local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
        if dist2D < CONFIG.AimFOV and dist2D < bestDist then
            bestDist = dist2D
            bestPlayer = plr
        end
    end
    return bestPlayer
end

local aimRightClickHeld = false
local originalCameraType = Camera.CameraType

local function saveOriginalCamType()
    if not aimRightClickHeld then
        local ct = Camera.CameraType
        if ct ~= Enum.CameraType.Scriptable then originalCameraType = ct end
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then aimRightClickHeld = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimRightClickHeld = false
        pcall(function() Camera.CameraType = originalCameraType end)
    end
end)

connections.aimAssist = RunService.RenderStepped:Connect(function()
    pcall(function()
        if CONFIG.AimAssist then
            fovCircle.Visible = true
            updateFovCircle()
        else
            fovCircle.Visible = false
            pcall(function() Camera.CameraType = originalCameraType end)
            return
        end
        saveOriginalCamType()
        if not aimRightClickHeld then return end
        local target = getBestTarget()
        if not target then pcall(function() Camera.CameraType = originalCameraType end) return end
        local char = target.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end
        local savedCF = Camera.CFrame
        local mouseDelta = UserInputService:GetMouseDelta()
        local sensitivity = 0.002
        local currentPitch = select(1, savedCF:ToEulerAnglesYXZ())
        local currentYaw   = select(2, savedCF:ToEulerAnglesYXZ())
        local newYaw   = currentYaw - mouseDelta.X * sensitivity
        local newPitch = math.clamp(currentPitch - mouseDelta.Y * sensitivity, math.rad(-80), math.rad(80))
        local mouseInfluencedCF = CFrame.new(savedCF.Position)
            * CFrame.Angles(0, newYaw, 0)
            * CFrame.Angles(newPitch, 0, 0)
        Camera.CameraType = Enum.CameraType.Scriptable
        local smooth = math.clamp(CONFIG.AimSmooth, 1, 20)
        local direction = (head.Position - mouseInfluencedCF.Position).Unit
        local newLook = mouseInfluencedCF.LookVector:Lerp(direction, 1 / smooth)
        Camera.CFrame = CFrame.new(mouseInfluencedCF.Position, mouseInfluencedCF.Position + newLook)
    end)
end)

-- =============================================
-- GUI
-- =============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BadFlemme_Script"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 260, 0, 240)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -120)
mainFrame.BackgroundColor3 = COLORS.Background
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
createCorner(mainFrame, 15)
createStroke(mainFrame, COLORS.Primary, 3)

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.BackgroundColor3 = COLORS.Primary
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame
createCorner(topBar, 15)
createGradient(topBar, ColorSequence.new{ColorSequenceKeypoint.new(0, COLORS.Accent), ColorSequenceKeypoint.new(1, COLORS.Secondary)}, 90)

local topCover = Instance.new("Frame")
topCover.Size = UDim2.new(1, 0, 0, 15)
topCover.Position = UDim2.new(0, 0, 1, -15)
topCover.BackgroundColor3 = COLORS.Primary
topCover.BorderSizePixel = 0
topCover.Parent = topBar
createGradient(topCover, ColorSequence.new{ColorSequenceKeypoint.new(0, COLORS.Accent), ColorSequenceKeypoint.new(1, COLORS.Secondary)}, 90)

local topIcon = Instance.new("TextLabel")
topIcon.Size = UDim2.new(0, 35, 0, 35)
topIcon.Position = UDim2.new(0, 8, 0.5, -17.5)
topIcon.BackgroundColor3 = COLORS.Background
topIcon.Text = "B"
topIcon.TextColor3 = Color3.fromRGB(180, 70, 255)
topIcon.Font = Enum.Font.GothamBlack
topIcon.TextSize = 18
topIcon.BorderSizePixel = 0
topIcon.Parent = topBar
createCorner(topIcon, 8)

local iconBtn = Instance.new("TextButton")
iconBtn.Name = "Icon"
iconBtn.Size = UDim2.new(0, 70, 0, 70)
iconBtn.Position = UDim2.new(0, 20, 0, 20)
iconBtn.BackgroundColor3 = COLORS.Background
iconBtn.BorderSizePixel = 0
iconBtn.Text = "B"
iconBtn.TextColor3 = Color3.fromRGB(180, 70, 255)
iconBtn.Font = Enum.Font.GothamBlack
iconBtn.TextSize = 32
iconBtn.Active = true
iconBtn.Draggable = true
iconBtn.Parent = screenGui
createCorner(iconBtn, 14)
createStroke(iconBtn, COLORS.Primary, 3)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 150, 0, 20)
titleLabel.Position = UDim2.new(0, 50, 0, 8)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "BadFlemme Script"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextColor3 = COLORS.White
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(0, 150, 0, 16)
subtitleLabel.Position = UDim2.new(0, 50, 0, 28)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Universal"
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextSize = 9
subtitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subtitleLabel.Parent = topBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
minimizeBtn.Text = "—"
minimizeBtn.BackgroundColor3 = COLORS.Background
minimizeBtn.TextColor3 = COLORS.White
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = topBar
createCorner(minimizeBtn, 6)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0.5, -12.5)
closeBtn.Text = "×"
closeBtn.BackgroundColor3 = COLORS.Background
closeBtn.TextColor3 = COLORS.White
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.BorderSizePixel = 0
closeBtn.Parent = topBar
createCorner(closeBtn, 6)

local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -16, 0, 30)
tabContainer.Position = UDim2.new(0, 8, 0, 58)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

local tabButtons = {}
local tabs = {"AFK", "MAIN", "ESP", "FPS", "AIM"}
local tabWidth = (260 - 24) / #tabs

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = tabName
    btn.Size = UDim2.new(0, tabWidth - 4, 0, 30)
    btn.Position = UDim2.new(0, (i - 1) * tabWidth + 2, 0, 0)
    btn.Text = tabName
    btn.BackgroundColor3 = (i == 1) and COLORS.Primary or COLORS.DarkBG
    btn.TextColor3 = COLORS.White
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.BorderSizePixel = 0
    btn.Parent = tabContainer
    createCorner(btn, 8)
    tabButtons[tabName] = btn
end

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -16, 1, -100)
contentFrame.Position = UDim2.new(0, 8, 0, 92)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local contentContainers = {}
for i, tabName in ipairs(tabs) do
    local container = Instance.new("ScrollingFrame")
    container.Name = tabName
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollBarThickness = 4
    container.ScrollBarImageColor3 = COLORS.Primary
    container.Visible = (i == 1)
    container.CanvasSize = UDim2.new(0, 0, 0, 500)
    container.Parent = contentFrame
    contentContainers[tabName] = container
end

local function createToggle(parent, text, key, posY, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -8, 0, 28)
    container.Position = UDim2.new(0, 4, 0, posY)
    container.BackgroundColor3 = COLORS.Frame
    container.BorderSizePixel = 0
    container.Parent = parent
    createCorner(container, 8)
    createStroke(container, COLORS.Primary, 1)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 10
    label.TextColor3 = COLORS.White
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    local toggleBtn = Instance.new("Frame")
    toggleBtn.Size = UDim2.new(0, 40, 0, 20)
    toggleBtn.Position = UDim2.new(1, -44, 0.5, -10)
    toggleBtn.BackgroundColor3 = COLORS.Gray
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = container
    createCorner(toggleBtn, 10)
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(0, 2, 0.5, -8)
    indicator.BackgroundColor3 = COLORS.White
    indicator.BorderSizePixel = 0
    indicator.Parent = toggleBtn
    createCorner(indicator, 8)
    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.Parent = container
    clickBtn.MouseButton1Click:Connect(function()
        CONFIG[key] = not CONFIG[key]
        if CONFIG[key] then
            tween(indicator, {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = COLORS.Primary}, 0.2)
            tween(toggleBtn, {BackgroundColor3 = COLORS.Primary}, 0.2)
        else
            tween(indicator, {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = COLORS.White}, 0.2)
            tween(toggleBtn, {BackgroundColor3 = COLORS.Gray}, 0.2)
        end
        if callback then task.spawn(function() pcall(callback, CONFIG[key]) end) end
    end)
    return container
end

local function createSlider(parent, text, key, min, max, posY, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -8, 0, 50)
    container.Position = UDim2.new(0, 4, 0, posY)
    container.BackgroundColor3 = COLORS.Frame
    container.BorderSizePixel = 0
    container.Parent = parent
    createCorner(container, 8)
    createStroke(container, COLORS.Primary, 1)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -12, 0, 20)
    label.Position = UDim2.new(0, 8, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. CONFIG[key]
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    label.TextColor3 = COLORS.White
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -16, 0, 10)
    sliderBg.Position = UDim2.new(0, 8, 0, 32)
    sliderBg.BackgroundColor3 = COLORS.Gray
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    createCorner(sliderBg, 5)
    local sliderFill = Instance.new("Frame")
    local percentage = (CONFIG[key] - min) / (max - min)
    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    sliderFill.BackgroundColor3 = COLORS.Primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    createCorner(sliderFill, 5)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(percentage, -8, 0.5, -8)
    knob.BackgroundColor3 = COLORS.White
    knob.BorderSizePixel = 0
    knob.Parent = sliderBg
    createCorner(knob, 8)
    createStroke(knob, COLORS.Primary, 2)
    local dragging = false
    local function update(input)
        pcall(function()
            local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            CONFIG[key] = value
            label.Text = text .. ": " .. value
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            knob.Position = UDim2.new(pos, -8, 0.5, -8)
            if callback then task.spawn(function() pcall(callback, value) end) end
        end)
    end
    sliderBg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true update(input) end end)
    sliderBg.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end end)
    return container
end

-- FPS Counter
local fpsCounter = Instance.new("Frame")
fpsCounter.Size = UDim2.new(0, 80, 0, 30)
fpsCounter.Position = UDim2.new(1, -90, 0, 10)
fpsCounter.BackgroundColor3 = COLORS.Background
fpsCounter.BorderSizePixel = 0
fpsCounter.Visible = false
fpsCounter.Active = true
fpsCounter.Draggable = true
fpsCounter.Parent = screenGui
createCorner(fpsCounter, 8)
createStroke(fpsCounter, COLORS.Primary, 2)

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, 0, 1, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 0"
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 12
fpsLabel.TextColor3 = COLORS.Primary
fpsLabel.Parent = fpsCounter

-- =============================================
-- Contenu des onglets
-- =============================================
local afkContent = contentContainers["AFK"]
createToggle(afkContent, "King Mode", "KingMode", 6)
createToggle(afkContent, "Anti AFK", "AntiAFK", 40)

local mainContent = contentContainers["MAIN"]
createToggle(mainContent, "Speed Boost", "SpeedBoost", 6)
createToggle(mainContent, "Super Jump", "SuperJump", 40)
createToggle(mainContent, "Fly  [E]", "Fly", 74, function(on)
    if on then
        startFly()
        notifyImportant("Fly activé ! (E = toggle, Shift = descendre)")
    else
        stopFly()
        notifyImportant("Fly désactivé")
    end
end)
createSlider(mainContent, "Fly Speed", "FlySpeed", 10, 200, 108)
createSlider(mainContent, "Walk Speed", "WalkSpeed", 16, 200, 164)
createSlider(mainContent, "Jump Power", "JumpPower", 50, 300, 220)

local espContent = contentContainers["ESP"]
createToggle(espContent, "Player ESP", "PlayerESP", 6, function(enabled)
    if enabled then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character then createPlayerESP(plr) end
        end
    else
        for plr, _ in pairs(playerESPCache) do clearPlayerESP(plr) end
    end
end)
createToggle(espContent, "Show Names", "ESPNames", 40, function() if CONFIG.PlayerESP then updateAllPlayerESP() end end)
createToggle(espContent, "Show Distance", "ESPDistance", 74, function() if CONFIG.PlayerESP then updateAllPlayerESP() end end)
createToggle(espContent, "Tracers", "Tracers", 108, function() if CONFIG.PlayerESP then updateAllPlayerESP() end end)

local fpsContent = contentContainers["FPS"]
createToggle(fpsContent, "FPS Boost", "FPSBoost", 6, function(enabled)
    local lighting = game:GetService("Lighting")
    if enabled then
        lighting.GlobalShadows = false
        lighting.Technology = Enum.Technology.Compatibility
        for _, e in pairs(lighting:GetChildren()) do if e:IsA("PostEffect") then e.Enabled = false end end
    else
        lighting.GlobalShadows = true
        lighting.Technology = Enum.Technology.ShadowMap
        for _, e in pairs(lighting:GetChildren()) do if e:IsA("PostEffect") then e.Enabled = true end end
    end
end)
createToggle(fpsContent, "Disable Particles", "DisableParticles", 40, function(enabled)
    for _, obj in pairs(workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
                obj.Enabled = not enabled
            end
        end)
    end
end)
createToggle(fpsContent, "Clean Particles (réversible)", "CleanParticles", 74, function(enabled) applyCleanParticles(enabled) end)
createToggle(fpsContent, "Remove Decals/Textures", "RemoveDecals", 108, function(enabled) applyRemoveDecals(enabled) end)
createToggle(fpsContent, "Hide Parts Invisibles", "RemoveInvisibleParts", 142, function(enabled) applyRemoveInvisibleParts(enabled) end)
createToggle(fpsContent, "Show FPS", "ShowFPS", 176, function(enabled) fpsCounter.Visible = enabled end)

local aimContent = contentContainers["AIM"]
createToggle(aimContent, "Aim Assist", "AimAssist", 6, function(enabled) fovCircle.Visible = enabled end)
createToggle(aimContent, "Team Check", "AimTeamCheck", 40)
createSlider(aimContent, "FOV", "AimFOV", 30, 400, 74, function(val) fovCircle.Radius = val end)
createSlider(aimContent, "Smooth", "AimSmooth", 1, 20, 130)

local keyInfoFrame = Instance.new("Frame")
keyInfoFrame.Size = UDim2.new(1, -8, 0, 28)
keyInfoFrame.Position = UDim2.new(0, 4, 0, 190)
keyInfoFrame.BackgroundColor3 = COLORS.Frame
keyInfoFrame.BorderSizePixel = 0
keyInfoFrame.Parent = aimContent
createCorner(keyInfoFrame, 8)
createStroke(keyInfoFrame, COLORS.Primary, 1)

local keyInfoLabel = Instance.new("TextLabel")
keyInfoLabel.Size = UDim2.new(1, -12, 1, 0)
keyInfoLabel.Position = UDim2.new(0, 8, 0, 0)
keyInfoLabel.BackgroundTransparency = 1
keyInfoLabel.Text = "🖱️ Maintenir Clic Droit pour viser"
keyInfoLabel.Font = Enum.Font.GothamSemibold
keyInfoLabel.TextSize = 10
keyInfoLabel.TextColor3 = COLORS.Green
keyInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
keyInfoLabel.Parent = keyInfoFrame

for tabName, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        currentTab = tabName
        for name, button in pairs(tabButtons) do button.BackgroundColor3 = (name == tabName) and COLORS.Primary or COLORS.DarkBG end
        for name, container in pairs(contentContainers) do container.Visible = (name == tabName) end
    end)
end

local menuOpen = false
iconBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    if menuOpen then
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        mainFrame.Visible = true
        tween(mainFrame, {Size = UDim2.new(0, 260, 0, 240), Position = UDim2.new(0.5, -130, 0.5, -120)}, 0.4, Enum.EasingStyle.Back)
        notifyImportant("Menu Opened!")
    else
        tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
        task.wait(0.3)
        mainFrame.Visible = false
    end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    menuOpen = false
    tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
    task.wait(0.3)
    mainFrame.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
    notifyImportant("Closed!")
    stopFly()
    tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
    if fpsCounter.Visible then tween(fpsCounter, {Size = UDim2.new(0, 0, 0, 0)}, 0.3) end
    tween(iconBtn, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
    task.wait(0.4)
    for _, conn in pairs(connections) do if conn then pcall(function() conn:Disconnect() end) end end
    pcall(function() Camera.CameraType = originalCameraType end)
    pcall(function() fovCircle:Remove() end)
    pcall(function() screenGui:Destroy() end)
end)

connections.main = RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if not hum then return end
        if CONFIG.KingMode then hum.Health = hum.MaxHealth hum.MaxHealth = 999999 end
        if CONFIG.SpeedBoost then hum.WalkSpeed = CONFIG.WalkSpeed end
    end)
end)

connections.superJump = UserInputService.JumpRequest:Connect(function()
    if not CONFIG.SuperJump then return end
    pcall(function()
        local char = player.Character
        if char then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum and hrp then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(0.05)
                hrp.Velocity = Vector3.new(hrp.Velocity.X, CONFIG.JumpPower, hrp.Velocity.Z)
            end
        end
    end)
end)

local lastUpdate, frames = tick(), 0
connections.fps = RunService.RenderStepped:Connect(function()
    frames = frames + 1
    if tick() - lastUpdate >= 1 then
        fpsLabel.Text = "FPS: " .. frames
        fpsLabel.TextColor3 = frames >= 60 and COLORS.Green or (frames >= 30 and COLORS.Primary or COLORS.Red)
        frames = 0
        lastUpdate = tick()
    end
end)

local function setupPlayerESPListeners(plr)
    if plr == player then return end
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if CONFIG.PlayerESP then createPlayerESP(plr) end
    end)
    if plr.Character and CONFIG.PlayerESP then createPlayerESP(plr) end
end

for _, plr in pairs(game.Players:GetPlayers()) do setupPlayerESPListeners(plr) end
game.Players.PlayerAdded:Connect(function(plr) setupPlayerESPListeners(plr) end)
game.Players.PlayerRemoving:Connect(function(plr) clearPlayerESP(plr) end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    if CONFIG.PlayerESP then
        for plr, _ in pairs(playerESPCache) do clearPlayerESP(plr) end
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character then createPlayerESP(plr) end
        end
    end
end)

print("BadFlemme Script Loaded!")
notifyImportant("Loaded!")
