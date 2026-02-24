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
    WalkSpeed = 16,
    JumpPower = 150,
    SpeedBoost = false,
    SuperJump = false,
    CameraFOV = 70,
    Fly = false,
    FlySpeed = 50,
    PlayerESP = false,
    ESPNames = false,
    ESPDistance = false,
    Tracers = false,
    SkeletonESP = false,
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
    SilentAim = false,
    Reach = false,
    ReachDistance = 20,
    AntiAim = false,
    SpinBot = false,
    SpinSpeed = 10,
    FakeLag = false,
    FakeLagPing = 200,
    ChatSpam = false,
    ChatMessage = "BadFlemme Script",
    PositionDesync = false,
    GhostDesync = false,
    Invisible = false,
    CustomAnim = false,
    SelectedAnim = "Zombie",
    MM2ESP = false,
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
-- AIM ASSIST - VERSION CORRIGÉE
-- La caméra suit maintenant le joueur correctement
-- On n'utilise plus Scriptable → la caméra reste
-- attachée au perso, on simule juste un micro-move
-- =============================================
local Camera = workspace.CurrentCamera

-- Drawing compatible tous executors
local function newDrawing(type)
    local ok, obj = pcall(function() return Drawing.new(type) end)
    if ok and obj then return obj end
    -- fallback vide si Drawing pas dispo
    return setmetatable({}, {__index = function() return function() end end, __newindex = function() end})
end

local fovCircle = newDrawing("Circle")
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
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then aimRightClickHeld = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then aimRightClickHeld = false end
end)

-- FIX AIM : compatible Xenos - utilise VirtualInputManager
connections.aimAssist = RunService.Heartbeat:Connect(function()
    pcall(function()
        if CONFIG.AimAssist then
            fovCircle.Visible = true
            updateFovCircle()
        else
            fovCircle.Visible = false
            return
        end
        if not aimRightClickHeld then return end
        local target = getBestTarget()
        if not target then return end
        local char = target.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end

        local smooth = math.clamp(CONFIG.AimSmooth, 1, 20)
        local vp = Camera.ViewportSize
        local screenCenter = Vector2.new(vp.X / 2, vp.Y / 2)
        local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
        if not onScreen then return end

        local targetScreen = Vector2.new(screenPos.X, screenPos.Y)
        local delta = (targetScreen - screenCenter) / smooth

        -- Compatible tous executors
        pcall(function()
            local VIM = game:GetService("VirtualInputManager")
            VIM:SendMouseMoveEvent(delta.X, delta.Y, game)
        end)
    end)
end)

-- =============================================
-- SILENT AIM
-- =============================================
connections.silentAim = RunService.RenderStepped:Connect(function()
    if not CONFIG.SilentAim then return end
    pcall(function()
        local target = getBestTarget()
        if not target then return end
        local char = target.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end
        local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
        if onScreen then
            pcall(function()
                local VIM = game:GetService("VirtualInputManager")
                VIM:SendMouseMoveEvent(screenPos.X, screenPos.Y, game)
            end)
        end
    end)
end)

-- =============================================
-- SKELETON ESP
-- =============================================
local skeletonCache = {}
local SKELETON_JOINTS = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}

local function clearSkeleton(plr)
    if skeletonCache[plr] then
        for _, line in pairs(skeletonCache[plr]) do pcall(function() line:Remove() end) end
        skeletonCache[plr] = nil
    end
end

connections.skeleton = RunService.RenderStepped:Connect(function()
    if not CONFIG.SkeletonESP then
        for plr, _ in pairs(skeletonCache) do clearSkeleton(plr) end
        return
    end
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr == player then continue end
        local char = plr.Character
        if not char then clearSkeleton(plr) continue end

        if not skeletonCache[plr] then
            skeletonCache[plr] = {}
            for _ = 1, #SKELETON_JOINTS do
                local line = newDrawing("Line")
                line.Visible = false
                line.Color = Color3.fromRGB(255, 50, 50)
                line.Thickness = 1.5
                line.Transparency = 1
                table.insert(skeletonCache[plr], line)
            end
        end

        for i, joint in ipairs(SKELETON_JOINTS) do
            local line = skeletonCache[plr][i]
            if not line then continue end
            pcall(function()
                local p1 = char:FindFirstChild(joint[1])
                local p2 = char:FindFirstChild(joint[2])
                if p1 and p2 then
                    local s1, v1 = Camera:WorldToViewportPoint(p1.Position)
                    local s2, v2 = Camera:WorldToViewportPoint(p2.Position)
                    if v1 and v2 then
                        line.From = Vector2.new(s1.X, s1.Y)
                        line.To   = Vector2.new(s2.X, s2.Y)
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            end)
        end
    end
end)

-- =============================================
-- REACH
-- =============================================
connections.reach = RunService.Heartbeat:Connect(function()
    if not CONFIG.Reach then return end
    pcall(function()
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        -- Agrandit la hitbox pour toucher de loin
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr == player then continue end
            local tChar = plr.Character
            if not tChar then continue end
            local tHRP = tChar:FindFirstChild("HumanoidRootPart")
            if not tHRP then continue end
            local dist = (hrp.Position - tHRP.Position).Magnitude
            if dist <= CONFIG.ReachDistance then
                -- Tp la hitbox vers le joueur momentanément
                local hit = tChar:FindFirstChild("HumanoidRootPart")
                if hit then hit.Size = Vector3.new(CONFIG.ReachDistance, 5, CONFIG.ReachDistance) end
            end
        end
    end)
end)

-- =============================================
-- ANTI AIM
-- Fait pointer la tête dans une direction aléatoire
-- pour rendre la hitbox difficile à toucher
-- =============================================
local antiAimAngle = 0
connections.antiAim = RunService.Heartbeat:Connect(function()
    if not CONFIG.AntiAim then return end
    pcall(function()
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        antiAimAngle = (antiAimAngle + 15) % 360
        -- Fait jitter la tête horizontalement
        local head = char:FindFirstChild("Head")
        if head then
            head.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(antiAimAngle), math.rad(90))
        end
    end)
end)

-- =============================================
-- SPIN BOT
-- =============================================
connections.spinBot = RunService.Heartbeat:Connect(function()
    if not CONFIG.SpinBot then return end
    pcall(function()
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(CONFIG.SpinSpeed), 0)
    end)
end)

-- =============================================
-- FAKE LAG
-- Freeze le HRP temporairement par intervalles
-- =============================================
local fakeLagTimer = 0
connections.fakeLag = RunService.Heartbeat:Connect(function(dt)
    if not CONFIG.FakeLag then return end
    pcall(function()
        fakeLagTimer = fakeLagTimer + dt
        local interval = CONFIG.FakeLagPing / 1000
        if fakeLagTimer < interval then
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Freeze position
                hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
            end
        else
            fakeLagTimer = 0
        end
    end)
end)

-- =============================================
-- POSITION DESYNC
-- Envoie en boucle la même position figée
-- au serveur via les network updates, pendant
-- que le client se déplace librement.
-- Technique : on spam AssemblyLinearVelocity = 0
-- et on remet la CFrame serveur à l'ancienne pos
-- via un BodyPosition ultra rapide (1 frame)
-- =============================================
local desyncParts = {}
local frozenPos = nil
local desyncRunning = false

local function startPositionDesync()
    if desyncRunning then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    frozenPos = hrp.CFrame
    desyncRunning = true

    task.spawn(function()
        while CONFIG.PositionDesync and desyncRunning do
            pcall(function()
                local c = player.Character
                if not c then return end
                local h = c:FindFirstChild("HumanoidRootPart")
                if not h or not frozenPos then return end

                local realCF = h.CFrame -- vraie position client

                -- Flash la position figée au serveur (1 frame)
                h.CFrame = frozenPos
                task.wait() -- 1 frame = serveur reçoit la fausse pos

                -- Revient immédiatement à la vraie position client
                h.CFrame = realCF
            end)
            task.wait(0.05) -- ~20x/sec
        end
        desyncRunning = false
    end)

    notifyImportant("Position Desync actif ! Bouge librement.")
end

local function stopPositionDesync()
    desyncRunning = false
    for _, p in pairs(desyncParts) do pcall(function() p:Destroy() end) end
    desyncParts = {}
    frozenPos = nil
end

-- =============================================
-- GHOST DESYNC
-- Envoie de fausses positions au serveur
-- en téléportant brièvement le HRP à une
-- position aléatoire autour de toi puis
-- revient immédiatement côté client.
-- Les autres joueurs voient ton "fantôme"
-- bouger de façon imprévisible.
-- =============================================
local ghostRunning = false
local function startGhostDesync()
    if ghostRunning then return end
    ghostRunning = true
    task.spawn(function()
        while CONFIG.GhostDesync and ghostRunning do
            pcall(function()
                local char = player.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                local realCF = hrp.CFrame

                -- Envoie une fausse position aléatoire au serveur
                local fakeOffset = Vector3.new(
                    math.random(-15, 15),
                    math.random(0, 5),
                    math.random(-15, 15)
                )
                hrp.CFrame = CFrame.new(realCF.Position + fakeOffset)
                task.wait(0.05)

                -- Revient immédiatement à la vraie position côté client
                hrp.CFrame = realCF
            end)
            task.wait(0.15) -- envoie ~6 fausses positions/sec
        end
        ghostRunning = false
    end)
    notifyImportant("Ghost Desync actif ! Ton fantôme se balade partout.")
end

local function stopGhostDesync()
    ghostRunning = false
    CONFIG.GhostDesync = false
end

-- =============================================
-- CHAT SPAM
-- =============================================
local chatSpamRunning = false
local function startChatSpam()
    if chatSpamRunning then return end
    chatSpamRunning = true
    task.spawn(function()
        while CONFIG.ChatSpam and chatSpamRunning do
            pcall(function()
                local rs = game:GetService("ReplicatedStorage")
                local chatEvents = rs:FindFirstChild("DefaultChatSystemChatEvents")
                if chatEvents then
                    local sayMsg = chatEvents:FindFirstChild("SayMessageRequest")
                    if sayMsg then
                        sayMsg:FireServer(CONFIG.ChatMessage, "All")
                    end
                end
            end)
            task.wait(3)
        end
        chatSpamRunning = false
    end)
end

-- =============================================
-- INVISIBILITÉ
-- Rend toutes les parts du perso transparentes
-- côté LOCAL (les autres joueurs ne te voient plus
-- car le réseau ne réplique pas LocalTransparencyModifier)
-- =============================================
local invisCache = {}

local function applyInvisible(enabled)
    local char = player.Character
    if not char then return end
    if enabled then
        invisCache = {}
        for _, part in pairs(char:GetDescendants()) do
            pcall(function()
                if part:IsA("BasePart") or part:IsA("Decal") then
                    table.insert(invisCache, {obj = part, transparency = part.Transparency})
                    part.Transparency = 1
                    if part:IsA("BasePart") then
                        part.LocalTransparencyModifier = 1
                    end
                end
            end)
        end
        -- Cache aussi les accessoires
        for _, acc in pairs(char:GetChildren()) do
            pcall(function()
                if acc:IsA("Accessory") then
                    local handle = acc:FindFirstChild("Handle")
                    if handle then
                        table.insert(invisCache, {obj = handle, transparency = handle.Transparency})
                        handle.Transparency = 1
                    end
                end
            end)
        end
        notifyImportant("Invisibilité activée !")
    else
        for _, entry in pairs(invisCache) do
            pcall(function()
                if entry.obj and entry.obj.Parent then
                    entry.obj.Transparency = entry.transparency
                    if entry.obj:IsA("BasePart") then
                        entry.obj.LocalTransparencyModifier = 0
                    end
                end
            end)
        end
        invisCache = {}
        notifyImportant("Invisibilité désactivée")
    end
end

-- Réapplique l'invis après respawn
player.CharacterAdded:Connect(function(newChar)
    if CONFIG.Invisible then
        task.wait(1)
        applyInvisible(true)
    end
end)

-- =============================================
-- CUSTOM WALK ANIMATION
-- =============================================
local ANIMS = {
    ["Zombie"]    = "rbxassetid://616163682",
    ["Gangster"]  = "rbxassetid://182393015",
    ["Ninja"]     = "rbxassetid://656118852",
    ["Tpose"]     = "rbxassetid://3711928852",
    ["Moonwalk"]  = "rbxassetid://182393043",
    ["Robot"]     = "rbxassetid://182393024",
    ["Astronaut"] = "rbxassetid://182393681",
    ["Werewolf"]  = "rbxassetid://182393092",
}

local currentAnimTrack = nil

local function applyCustomAnim(animName)
    pcall(function()
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if not hum then return end
        local animator = hum:FindFirstChildWhichIsA("Animator")
        if not animator then return end

        -- Stop l'animation actuelle
        if currentAnimTrack then
            currentAnimTrack:Stop()
            currentAnimTrack = nil
        end

        if not CONFIG.CustomAnim then return end

        local animId = ANIMS[animName]
        if not animId then return end

        -- Remplace l'animation de marche
        local animFolder = char:FindFirstChild("Animate")
        if animFolder then
            local walkAnim = animFolder:FindFirstChild("walk")
            if walkAnim then
                local walkAnimAnim = walkAnim:FindFirstChildWhichIsA("Animation")
                if walkAnimAnim then
                    walkAnimAnim.AnimationId = animId
                end
            end
            local runAnim = animFolder:FindFirstChild("run")
            if runAnim then
                local runAnimAnim = runAnim:FindFirstChildWhichIsA("Animation")
                if runAnimAnim then
                    runAnimAnim.AnimationId = animId
                end
            end
        end

        -- Force le rechargement
        local anim = Instance.new("Animation")
        anim.AnimationId = animId
        currentAnimTrack = animator:LoadAnimation(anim)
        currentAnimTrack:Play()
        notifyImportant("Animation : " .. animName)
    end)
end

-- =============================================
-- MM2 ROLE DETECTOR
-- Détecte Sheriff et Murder via les tools
-- dans leur Backpack ou Character
-- Sheriff  → a un Gun (outil contenant "gun"/"sheriff")
-- Murder   → a un Knife (outil contenant "knife"/"murder")
-- =============================================
local mm2Labels = {} -- { plr = BillboardGui }

local function clearMM2Label(plr)
    if mm2Labels[plr] then
        pcall(function() mm2Labels[plr]:Destroy() end)
        mm2Labels[plr] = nil
    end
end

local function getMM2Role(plr)
    -- Cherche dans le character (tool équipé)
    local char = plr.Character
    if char then
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("knife") or n:find("murder") or n:find("blade") then
                    return "MURDER", Color3.fromRGB(255, 40, 40)
                end
                if n:find("gun") or n:find("sheriff") or n:find("revolver") then
                    return "SHERIFF", Color3.fromRGB(50, 180, 255)
                end
            end
        end
    end
    -- Cherche dans le backpack (tool non équipé)
    local bp = plr:FindFirstChild("Backpack")
    if bp then
        for _, tool in pairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("knife") or n:find("murder") or n:find("blade") then
                    return "MURDER", Color3.fromRGB(255, 40, 40)
                end
                if n:find("gun") or n:find("sheriff") or n:find("revolver") then
                    return "SHERIFF", Color3.fromRGB(50, 180, 255)
                end
            end
        end
    end
    return nil, nil
end

connections.mm2ESP = RunService.Heartbeat:Connect(function()
    if not CONFIG.MM2ESP then
        for plr, _ in pairs(mm2Labels) do clearMM2Label(plr) end
        return
    end
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr == player then continue end
        local char = plr.Character
        if not char then clearMM2Label(plr) continue end
        local head = char:FindFirstChild("Head")
        if not head then continue end

        local role, color = getMM2Role(plr)

        if role then
            -- Crée ou met à jour le label
            if not mm2Labels[plr] then
                local bb = Instance.new("BillboardGui")
                bb.Size = UDim2.new(0, 120, 0, 40)
                bb.StudsOffset = Vector3.new(0, 3.5, 0)
                bb.AlwaysOnTop = true
                bb.Adornee = head
                bb.Parent = char

                local bg = Instance.new("Frame", bb)
                bg.Size = UDim2.new(1, 0, 1, 0)
                bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                bg.BackgroundTransparency = 0.3
                bg.BorderSizePixel = 0
                local bgc = Instance.new("UICorner", bg) bgc.CornerRadius = UDim.new(0, 8)

                local lbl = Instance.new("TextLabel", bg)
                lbl.Name = "RoleLabel"
                lbl.Size = UDim2.new(1, 0, 0.5, 0)
                lbl.BackgroundTransparency = 1
                lbl.Font = Enum.Font.GothamBlack
                lbl.TextSize = 13
                lbl.TextXAlignment = Enum.TextXAlignment.Center

                local nameLbl = Instance.new("TextLabel", bg)
                nameLbl.Name = "NameLabel"
                nameLbl.Size = UDim2.new(1, 0, 0.5, 0)
                nameLbl.Position = UDim2.new(0, 0, 0.5, 0)
                nameLbl.BackgroundTransparency = 1
                nameLbl.Text = plr.Name
                nameLbl.Font = Enum.Font.GothamBold
                nameLbl.TextSize = 10
                nameLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
                nameLbl.TextXAlignment = Enum.TextXAlignment.Center

                mm2Labels[plr] = bb
            end

            -- Met à jour le rôle et la couleur
            pcall(function()
                local bb = mm2Labels[plr]
                local bg = bb:FindFirstChildWhichIsA("Frame")
                if bg then
                    local lbl = bg:FindFirstChild("RoleLabel")
                    if lbl then
                        if role == "MURDER" then
                            lbl.Text = "🔪 MURDER"
                        else
                            lbl.Text = "🔫 SHERIFF"
                        end
                        lbl.TextColor3 = color
                    end
                end
            end)
        else
            clearMM2Label(plr)
        end
    end
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
mainFrame.Size = UDim2.new(0, 260, 0, 260)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -130)
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

-- =============================================
-- TABS - 2 rangées d'icônes propres
-- =============================================
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -16, 0, 64)
tabContainer.Position = UDim2.new(0, 8, 0, 55)
tabContainer.BackgroundColor3 = COLORS.DarkBG
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame
createCorner(tabContainer, 10)
createStroke(tabContainer, COLORS.Gray, 1)

local tabButtons = {}
local tabs = {"AFK", "MAIN", "ESP", "FPS", "AIM", "MISC", "PLAYER"}

-- Icônes pour chaque onglet
local tabIcons = {
    AFK    = "💤",
    MAIN   = "⚡",
    ESP    = "👁️",
    FPS    = "🎮",
    AIM    = "🎯",
    MISC   = "🔧",
    PLAYER = "👤",
}

-- Row 1 : AFK MAIN ESP FPS  (4 tabs)
-- Row 2 : AIM MISC PLAYER   (3 tabs, centrés)
local row1 = {"AFK", "MAIN", "ESP", "FPS"}
local row2 = {"AIM", "MISC", "PLAYER"}

local btnW = 55
local btnH = 26

for i, tabName in ipairs(row1) do
    local btn = Instance.new("TextButton")
    btn.Name = tabName
    btn.Size = UDim2.new(0, btnW, 0, btnH)
    btn.Position = UDim2.new(0, (i-1) * (btnW + 3) + 4, 0, 4)
    btn.Text = tabIcons[tabName] .. " " .. tabName
    btn.BackgroundColor3 = (tabName == "AFK") and COLORS.Primary or COLORS.Frame
    btn.TextColor3 = COLORS.White
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.BorderSizePixel = 0
    btn.Parent = tabContainer
    createCorner(btn, 6)
    tabButtons[tabName] = btn
end

-- Row 2 centrée
local row2TotalW = #row2 * btnW + (#row2 - 1) * 3
local row2StartX = (240 - row2TotalW) / 2
for i, tabName in ipairs(row2) do
    local btn = Instance.new("TextButton")
    btn.Name = tabName
    btn.Size = UDim2.new(0, btnW, 0, btnH)
    btn.Position = UDim2.new(0, row2StartX + (i-1) * (btnW + 3), 0, 34)
    btn.Text = tabIcons[tabName] .. " " .. tabName
    btn.BackgroundColor3 = COLORS.Frame
    btn.TextColor3 = COLORS.White
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.BorderSizePixel = 0
    btn.Parent = tabContainer
    createCorner(btn, 6)
    tabButtons[tabName] = btn
end

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -16, 1, -130)
contentFrame.Position = UDim2.new(0, 8, 0, 125)
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
createToggle(mainContent, "Speed Boost", "SpeedBoost", 6, function(on)
    if not on then
        pcall(function()
            local char = player.Character
            if not char then return end
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end)
        notifyImportant("Speed Boost désactivé")
    end
end)
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
createSlider(mainContent, "Camera FOV", "CameraFOV", 70, 120, 276, function(val)
    pcall(function()
        workspace.CurrentCamera.FieldOfView = val
    end)
end)

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
createToggle(espContent, "Skeleton ESP", "SkeletonESP", 142, function(on)
    if not on then
        for plr, _ in pairs(skeletonCache) do clearSkeleton(plr) end
    end
end)

-- Séparateur MM2
local mm2Title = Instance.new("TextLabel")
mm2Title.Size = UDim2.new(1, -8, 0, 20)
mm2Title.Position = UDim2.new(0, 4, 0, 178)
mm2Title.BackgroundTransparency = 1
mm2Title.Text = "── Murder Mystery 2 ──"
mm2Title.Font = Enum.Font.GothamBold
mm2Title.TextSize = 9
mm2Title.TextColor3 = COLORS.Gray
mm2Title.Parent = espContent

createToggle(espContent, "🔪 MM2 Role Detector", "MM2ESP", 202, function(on)
    if not on then
        for plr, _ in pairs(mm2Labels) do clearMM2Label(plr) end
    else
        notifyImportant("MM2 ESP actif ! Cherche Sheriff et Murder...")
    end
end)

local mm2Info = Instance.new("Frame")
mm2Info.Size = UDim2.new(1, -8, 0, 36)
mm2Info.Position = UDim2.new(0, 4, 0, 236)
mm2Info.BackgroundColor3 = COLORS.Frame
mm2Info.BorderSizePixel = 0
mm2Info.Parent = espContent
createCorner(mm2Info, 8)
createStroke(mm2Info, COLORS.Primary, 1)
local mm2InfoLbl = Instance.new("TextLabel")
mm2InfoLbl.Size = UDim2.new(1, -12, 1, 0)
mm2InfoLbl.Position = UDim2.new(0, 6, 0, 0)
mm2InfoLbl.BackgroundTransparency = 1
mm2InfoLbl.Text = "🔫 Sheriff = bleu  •  🔪 Murder = rouge\nAffiché au dessus de la tête des joueurs"
mm2InfoLbl.Font = Enum.Font.Gotham
mm2InfoLbl.TextSize = 9
mm2InfoLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
mm2InfoLbl.TextXAlignment = Enum.TextXAlignment.Left
mm2InfoLbl.TextWrapped = true
mm2InfoLbl.Parent = mm2Info

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
createToggle(aimContent, "Silent Aim", "SilentAim", 74)
createSlider(aimContent, "FOV", "AimFOV", 30, 400, 108, function(val) fovCircle.Radius = val end)
createSlider(aimContent, "Smooth", "AimSmooth", 1, 20, 164)

local keyInfoFrame = Instance.new("Frame")
keyInfoFrame.Size = UDim2.new(1, -8, 0, 28)
keyInfoFrame.Position = UDim2.new(0, 4, 0, 224)
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

-- =============================================
-- MISC TAB
-- =============================================
local miscContent = contentContainers["MISC"]

createToggle(miscContent, "Reach", "Reach", 6)
createSlider(miscContent, "Reach Dist", "ReachDistance", 5, 100, 40)

createToggle(miscContent, "Anti Aim", "AntiAim", 96)
createToggle(miscContent, "Spin Bot", "SpinBot", 130)
createSlider(miscContent, "Spin Speed", "SpinSpeed", 1, 30, 164)

createToggle(miscContent, "Fake Lag", "FakeLag", 220, function(on)
    if not on then fakeLagTimer = 0 end
end)
createSlider(miscContent, "Lag (ms)", "FakeLagPing", 50, 500, 254)

createToggle(miscContent, "Chat Spam", "ChatSpam", 310, function(on)
    if on then
        startChatSpam()
        notifyImportant("Chat Spam activé !")
    else
        chatSpamRunning = false
    end
end)

-- Champ texte pour le message du chat spam
local chatMsgFrame = Instance.new("Frame")
chatMsgFrame.Size = UDim2.new(1, -8, 0, 36)
chatMsgFrame.Position = UDim2.new(0, 4, 0, 348)
chatMsgFrame.BackgroundColor3 = COLORS.Frame
chatMsgFrame.BorderSizePixel = 0
chatMsgFrame.Parent = miscContent
createCorner(chatMsgFrame, 8)
createStroke(chatMsgFrame, COLORS.Primary, 1)

local chatMsgLabel = Instance.new("TextLabel")
chatMsgLabel.Size = UDim2.new(0, 60, 0, 16)
chatMsgLabel.Position = UDim2.new(0, 8, 0, 4)
chatMsgLabel.BackgroundTransparency = 1
chatMsgLabel.Text = "Message:"
chatMsgLabel.Font = Enum.Font.GothamSemibold
chatMsgLabel.TextSize = 9
chatMsgLabel.TextColor3 = COLORS.White
chatMsgLabel.TextXAlignment = Enum.TextXAlignment.Left
chatMsgLabel.Parent = chatMsgFrame

local chatMsgBox = Instance.new("TextBox")
chatMsgBox.Size = UDim2.new(1, -16, 0, 18)
chatMsgBox.Position = UDim2.new(0, 8, 0, 16)
chatMsgBox.BackgroundColor3 = COLORS.DarkBG
chatMsgBox.Text = CONFIG.ChatMessage
chatMsgBox.Font = Enum.Font.Gotham
chatMsgBox.TextSize = 10
chatMsgBox.TextColor3 = COLORS.White
chatMsgBox.ClearTextOnFocus = false
chatMsgBox.BorderSizePixel = 0
chatMsgBox.Parent = chatMsgFrame
createCorner(chatMsgBox, 4)
chatMsgBox.FocusLost:Connect(function()
    CONFIG.ChatMessage = chatMsgBox.Text
end)

-- Desync section
createToggle(miscContent, "📡 Position Desync", "PositionDesync", 392, function(on)
    if on then
        startPositionDesync()
    else
        stopPositionDesync()
        notifyImportant("Position Desync désactivé")
    end
end)

createToggle(miscContent, "👻 Ghost Desync", "GhostDesync", 426, function(on)
    if on then
        startGhostDesync()
    else
        stopGhostDesync()
        notifyImportant("Ghost Desync désactivé")
    end
end)

local desyncInfo = Instance.new("Frame")
desyncInfo.Size = UDim2.new(1, -8, 0, 44)
desyncInfo.Position = UDim2.new(0, 4, 0, 464)
desyncInfo.BackgroundColor3 = COLORS.Frame
desyncInfo.BorderSizePixel = 0
desyncInfo.Parent = miscContent
createCorner(desyncInfo, 8)
createStroke(desyncInfo, COLORS.Primary, 1)
local desyncInfoLabel = Instance.new("TextLabel")
desyncInfoLabel.Size = UDim2.new(1, -12, 1, 0)
desyncInfoLabel.Position = UDim2.new(0, 6, 0, 0)
desyncInfoLabel.BackgroundTransparency = 1
desyncInfoLabel.Text = "📡 Pos : serveur figé, toi tu bouges\n👻 Ghost : fausse pos envoyée au serveur"
desyncInfoLabel.Font = Enum.Font.Gotham
desyncInfoLabel.TextSize = 9
desyncInfoLabel.TextColor3 = COLORS.Green
desyncInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
desyncInfoLabel.TextWrapped = true
desyncInfoLabel.Parent = desyncInfo

-- =============================================
-- PLAYER TAB
-- =============================================
local playerContent = contentContainers["PLAYER"]

createToggle(playerContent, "👻 Invisibilité", "Invisible", 6, function(on)
    applyInvisible(on)
end)

local invisInfo = Instance.new("Frame")
invisInfo.Size = UDim2.new(1, -8, 0, 28)
invisInfo.Position = UDim2.new(0, 4, 0, 40)
invisInfo.BackgroundColor3 = COLORS.Frame
invisInfo.BorderSizePixel = 0
invisInfo.Parent = playerContent
createCorner(invisInfo, 8)
createStroke(invisInfo, COLORS.Primary, 1)
local invisInfoLbl = Instance.new("TextLabel")
invisInfoLbl.Size = UDim2.new(1, -12, 1, 0)
invisInfoLbl.Position = UDim2.new(0, 6, 0, 0)
invisInfoLbl.BackgroundTransparency = 1
invisInfoLbl.Text = "⚠️ Respawn pour réinitialiser le skin"
invisInfoLbl.Font = Enum.Font.Gotham
invisInfoLbl.TextSize = 9
invisInfoLbl.TextColor3 = Color3.fromRGB(255, 200, 0)
invisInfoLbl.TextXAlignment = Enum.TextXAlignment.Left
invisInfoLbl.Parent = invisInfo

-- Separator
local sep = Instance.new("Frame")
sep.Size = UDim2.new(1, -8, 0, 1)
sep.Position = UDim2.new(0, 4, 0, 76)
sep.BackgroundColor3 = COLORS.Gray
sep.BorderSizePixel = 0
sep.Parent = playerContent

-- Custom anim toggle
createToggle(playerContent, "🕺 Custom Walk Anim", "CustomAnim", 84, function(on)
    if on then
        applyCustomAnim(CONFIG.SelectedAnim)
    else
        if currentAnimTrack then currentAnimTrack:Stop() currentAnimTrack = nil end
        notifyImportant("Animation normale restaurée")
    end
end)

-- Dropdown anim
local animNames = {}
for name, _ in pairs(ANIMS) do table.insert(animNames, name) end
table.sort(animNames)

local animDropLabel = Instance.new("TextLabel")
animDropLabel.Size = UDim2.new(1, -8, 0, 16)
animDropLabel.Position = UDim2.new(0, 8, 0, 120)
animDropLabel.BackgroundTransparency = 1
animDropLabel.Text = "Choisir une animation :"
animDropLabel.Font = Enum.Font.GothamSemibold
animDropLabel.TextSize = 9
animDropLabel.TextColor3 = COLORS.White
animDropLabel.TextXAlignment = Enum.TextXAlignment.Left
animDropLabel.Parent = playerContent

-- Boutons d'animation
local animY = 140
for _, animName in ipairs(animNames) do
    local animBtn = Instance.new("TextButton")
    animBtn.Size = UDim2.new(1, -8, 0, 26)
    animBtn.Position = UDim2.new(0, 4, 0, animY)
    animBtn.BackgroundColor3 = COLORS.Frame
    animBtn.Text = animName
    animBtn.Font = Enum.Font.GothamSemibold
    animBtn.TextSize = 10
    animBtn.TextColor3 = COLORS.White
    animBtn.BorderSizePixel = 0
    animBtn.Parent = playerContent
    createCorner(animBtn, 6)
    createStroke(animBtn, COLORS.Primary, 1)
    animBtn.MouseButton1Click:Connect(function()
        CONFIG.SelectedAnim = animName
        if CONFIG.CustomAnim then
            applyCustomAnim(animName)
        end
        -- Highlight le bouton sélectionné
        for _, child in pairs(playerContent:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = COLORS.Frame
            end
        end
        animBtn.BackgroundColor3 = COLORS.Primary
        notifyImportant("Anim sélectionnée : " .. animName)
    end)
    animY = animY + 30
end

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
        tween(mainFrame, {Size = UDim2.new(0, 260, 0, 260), Position = UDim2.new(0.5, -130, 0.5, -130)}, 0.4, Enum.EasingStyle.Back)
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
    chatSpamRunning = false
    CONFIG.SpinBot = false
    CONFIG.AntiAim = false
    CONFIG.FakeLag = false
    CONFIG.SilentAim = false
    CONFIG.SkeletonESP = false
    CONFIG.PositionDesync = false
    CONFIG.GhostDesync = false
    CONFIG.MM2ESP = false
    stopPositionDesync()
    stopGhostDesync()
    for plr, _ in pairs(skeletonCache) do clearSkeleton(plr) end
    for plr, _ in pairs(mm2Labels) do clearMM2Label(plr) end
    tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
    if fpsCounter.Visible then tween(fpsCounter, {Size = UDim2.new(0, 0, 0, 0)}, 0.3) end
    tween(iconBtn, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
    task.wait(0.4)
    for _, conn in pairs(connections) do if conn then pcall(function() conn:Disconnect() end) end end
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
        -- WalkSpeed : applique si actif, remet à 16 si désactivé
        if CONFIG.SpeedBoost then
            hum.WalkSpeed = CONFIG.WalkSpeed
        else
            if hum.WalkSpeed ~= 16 and hum.WalkSpeed == CONFIG.WalkSpeed then
                hum.WalkSpeed = 16
            end
        end
        -- FOV caméra
        local cam = workspace.CurrentCamera
        if cam then
            cam.FieldOfView = CONFIG.CameraFOV
        end
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

-- =============================================
-- SESSION INFO PANEL  [F4]
-- =============================================

-- Détection plateforme
local function getPlatform()
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        return "📱 Mobile"
    elseif UserInputService.GamepadEnabled then
        return "🎮 Console"
    else
        return "🖥️ PC"
    end
end

-- Age du compte approximatif
local function getAccountAge()
    local age = player.AccountAge
    if age < 30 then return "🆕 Nouveau (" .. age .. " jours)"
    elseif age < 365 then return "📅 " .. math.floor(age/30) .. " mois"
    else return "⭐ " .. math.floor(age/365) .. " an(s) (" .. age .. "j)"
    end
end

-- Ping approximatif via Stats
local function getPing()
    local ok, ping = pcall(function()
        return math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
    end)
    if ok then return ping .. " ms"
    else return "N/A"
    end
end

-- GUI du panel
local infoPanel = Instance.new("Frame")
infoPanel.Name = "SessionInfo"
infoPanel.Size = UDim2.new(0, 240, 0, 190)
infoPanel.Position = UDim2.new(0, 16, 1, -206)
infoPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
infoPanel.BackgroundTransparency = 0.1
infoPanel.BorderSizePixel = 0
infoPanel.Visible = false
infoPanel.Active = true
infoPanel.Draggable = true
infoPanel.Parent = screenGui
createCorner(infoPanel, 12)
createStroke(infoPanel, COLORS.Primary, 2)

-- Header
local infoPanelHeader = Instance.new("Frame")
infoPanelHeader.Size = UDim2.new(1, 0, 0, 34)
infoPanelHeader.BackgroundColor3 = COLORS.Primary
infoPanelHeader.BorderSizePixel = 0
infoPanelHeader.Parent = infoPanel
createCorner(infoPanelHeader, 12)
local infoPanelHeaderCover = Instance.new("Frame")
infoPanelHeaderCover.Size = UDim2.new(1, 0, 0, 12)
infoPanelHeaderCover.Position = UDim2.new(0, 0, 1, -12)
infoPanelHeaderCover.BackgroundColor3 = COLORS.Primary
infoPanelHeaderCover.BorderSizePixel = 0
infoPanelHeaderCover.Parent = infoPanelHeader

local infoPanelTitle = Instance.new("TextLabel")
infoPanelTitle.Size = UDim2.new(1, -10, 1, 0)
infoPanelTitle.Position = UDim2.new(0, 10, 0, 0)
infoPanelTitle.BackgroundTransparency = 1
infoPanelTitle.Text = "📋 Session Info  •  F4"
infoPanelTitle.Font = Enum.Font.GothamBold
infoPanelTitle.TextSize = 12
infoPanelTitle.TextColor3 = COLORS.White
infoPanelTitle.TextXAlignment = Enum.TextXAlignment.Left
infoPanelTitle.Parent = infoPanelHeader

-- Lignes d'infos
local infoLines = {}
local lineKeys = {
    "👤 Pseudo",
    "💬 DisplayName",
    "🆔 ID",
    "🖥️ Platform",
    "📅 Compte",
    "📡 Ping",
}

for i, key in ipairs(lineKeys) do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -16, 0, 22)
    row.Position = UDim2.new(0, 8, 0, 36 + (i-1) * 24)
    row.BackgroundColor3 = (i % 2 == 0) and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(28, 28, 28)
    row.BorderSizePixel = 0
    row.Parent = infoPanel
    createCorner(row, 6)

    local keyLbl = Instance.new("TextLabel", row)
    keyLbl.Size = UDim2.new(0, 100, 1, 0)
    keyLbl.BackgroundTransparency = 1
    keyLbl.Text = key
    keyLbl.Font = Enum.Font.GothamSemibold
    keyLbl.TextSize = 10
    keyLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
    keyLbl.TextXAlignment = Enum.TextXAlignment.Left
    keyLbl.Position = UDim2.new(0, 6, 0, 0)

    local valLbl = Instance.new("TextLabel", row)
    valLbl.Size = UDim2.new(0, 120, 1, 0)
    valLbl.Position = UDim2.new(0, 110, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = "..."
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 10
    valLbl.TextColor3 = COLORS.White
    valLbl.TextXAlignment = Enum.TextXAlignment.Left
    valLbl.TextTruncate = Enum.TextTruncate.AtEnd

    infoLines[key] = valLbl
end

-- Mise à jour des infos
local function refreshInfoPanel()
    pcall(function()
        infoLines["👤 Pseudo"].Text       = player.Name
        infoLines["💬 DisplayName"].Text  = player.DisplayName
        infoLines["🆔 ID"].Text           = tostring(player.UserId)
        infoLines["🖥️ Platform"].Text     = getPlatform()
        infoLines["📅 Compte"].Text       = getAccountAge()
        infoLines["📡 Ping"].Text         = getPing()
    end)
end

-- Mise à jour ping en live toutes les 2s
task.spawn(function()
    while true do
        if infoPanel.Visible then
            pcall(function()
                infoLines["📡 Ping"].Text = getPing()
                -- Colore le ping
                local pingVal = tonumber(infoLines["📡 Ping"].Text:match("%d+")) or 0
                infoLines["📡 Ping"].TextColor3 =
                    pingVal < 80  and COLORS.Green or
                    pingVal < 150 and Color3.fromRGB(255, 200, 0) or
                    COLORS.Red
            end)
        end
        task.wait(2)
    end
end)

-- Toggle avec F4
local infoPanelOpen = false
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F4 then
        infoPanelOpen = not infoPanelOpen
        if infoPanelOpen then
            refreshInfoPanel()
            infoPanel.Size = UDim2.new(0, 0, 0, 0)
            infoPanel.Visible = true
            tween(infoPanel, {Size = UDim2.new(0, 240, 0, 190)}, 0.3, Enum.EasingStyle.Back)
        else
            tween(infoPanel, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
            task.wait(0.2)
            infoPanel.Visible = false
        end
    end
end)
