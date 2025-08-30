-- HuntyZombie Hub com GUI Seguro
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Workspace = game:GetService("Workspace")

-- Configurações iniciais
local KillAuraRange = 20
local AutoPhaseDelay = 1
local SkillDelay = 0.5

local HubSettings = {
    KillAura = false,
    AutoPhase = false,
    UseSkills = false
}

-- Criando GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HuntyZombieHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0, 10, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local function CreateToggle(name, settingKey, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = name.." [OFF]"
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = Frame
    btn.MouseButton1Click:Connect(function()
        HubSettings[settingKey] = not HubSettings[settingKey]
        btn.Text = name.." ["..(HubSettings[settingKey] and "ON" or "OFF").."]"
    end)
end

CreateToggle("Kill Aura", "KillAura", 10)
CreateToggle("Auto Phase", "AutoPhase", 50)
CreateToggle("Use Skills", "UseSkills", 90)

-- Funções
local function KillAura()
    for _, npc in pairs(Workspace.NPCs:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and (npc.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude <= KillAuraRange then
            if LocalPlayer:FindFirstChild("RemoteEvent") then
                LocalPlayer.RemoteEvent:FireServer(npc)
            end
        end
    end
end

local function AutoPhase()
    local phaseEnd = Workspace:FindFirstChild("PhaseEnd")
    if phaseEnd and (phaseEnd.Position - HumanoidRootPart.Position).Magnitude <= 5 then
        HumanoidRootPart.CFrame = phaseEnd.CFrame + Vector3.new(0,5,0)
    end
end

local function UseSkills()
    if LocalPlayer:FindFirstChild("SkillEvent") then
        LocalPlayer.SkillEvent:FireServer()
    end
end

-- Loop principal
RunService.Heartbeat:Connect(function()
    if HubSettings.KillAura then KillAura() end
    if HubSettings.AutoPhase then AutoPhase() end
    if HubSettings.UseSkills then UseSkills() end
end)
