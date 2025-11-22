-- Servicios de Roblox
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Variables del jugador
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Variables del script
local pos = nil
local invincible = false
local healthConnection = nil

-- =============================================
-- FUNCIONES PRINCIPALES (sin texto externo)
-- =============================================

-- Guardar Posición
local function savePos()
    pos = HumanoidRootPart.Position
end

-- Teletransportarse
local function tp()
    if pos then
        HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- Invencibilidad
local function toggleInvincibility()
    invincible = not invincible
    if invincible then
        if healthConnection then healthConnection:Disconnect() end
        healthConnection = RunService.Heartbeat:Connect(function()
            if Humanoid and Humanoid.Health > 0 then
                Humanoid.Health = Humanoid.MaxHealth
            end
        end)
    else
        if healthConnection then
            healthConnection:Disconnect()
            healthConnection = nil
        end
    end
end

-- Robar Brainrot
local function stealBrainrot()
    local closestDist = math.huge
    local targetBrain = nil

    for _, v in ipairs(Workspace:GetDescendants()) do
        if v.Name:lower():find("brainrot") and v:IsA("Model") and v.PrimaryPart then
            local valueObj = v:FindFirstChild("Value")
            if valueObj and valueObj.Value and valueObj.Value > 15000000 then
                local dist = (HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    targetBrain = v
                end
            end
        end
    end

    if targetBrain and targetBrain.PrimaryPart then
        HumanoidRootPart.CFrame = CFrame.new(targetBrain.PrimaryPart.Position + Vector3.new(0, 2, 0))
        task.wait(0.2)
        toggleInvincibility()
        local touchPart = targetBrain:FindFirstChildWhichIsA("Part", true)
        if touchPart then
            firetouchinterest(HumanoidRootPart, touchPart, 0)
            firetouchinterest(HumanoidRootPart, touchPart, 1)
        end
    end
end

-- =============================================
-- CREACIÓN DE LA GUI SIGILOSA
-- =============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UI" -- Nombre genérico
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Marco principal
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 50, 0, 220) -- Tamaño reducido
Main.Position = UDim2.new(1, -60, 0, 10) -- Esquina superior derecha
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true -- Permitir arrastrar la GUI

-- Hacer la GUI semi-transparente y con bordes redondeados
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 6)
Corner.Parent = Main

-- Estilo de botones
local function createButton(parent, text, position)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(0, 40, 0, 40)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 18
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    -- Efecto hover
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)
    
    return btn
end

-- Crear los botones con texto simple/simbólico
local btnSave = createButton(Main, "S", UDim2.new(0, 5, 0, 5)) -- S de Save
local btnTp = createButton(Main, "T", UDim2.new(0, 5, 0, 55)) -- T de Teleport
local btnInv = createButton(Main, "I", UDim2.new(0, 5, 0, 105)) -- I de Invincible
local btnSteal = createButton(Main, "R", UDim2.new(0, 5, 0, 155)) -- R de Rob

-- =============================================
-- CONECTAR BOTONES A FUNCIONES
-- =============================================

btnSave.MouseButton1Click:Connect(savePos)
btnTp.MouseButton1Click:Connect(tp)
btnInv.MouseButton1Click:Connect(toggleInvincibility)
btnSteal.MouseButton1Click:Connect(stealBrainrot)

-- =============================================
-- TOGGLE DE LA GUI CON UNA TECLA (Keybind: H)
-- =============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H then
        Main.Enabled = not Main.Enabled
    end
end)
