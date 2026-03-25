-- Dragon Fruit System (No Arabic)
-- Replicated to all players
-- Use [Insert] to toggle menu

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

local dragonVisual = nil
local wing1, wing2
local t = 0

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DragonFruitGui"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Dragon Fruit v2"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame
Instance.new("UICorner", Title)

-- Functions
function fireBreathEffect()
    local spawnCF = root.CFrame
    if dragonVisual and dragonVisual:FindFirstChild("Head") then
        spawnCF = dragonVisual.Head.CFrame
    end
    
    for i = 1, 12 do
        local fire = Instance.new("Part", workspace)
        fire.Size = Vector3.new(5, 5, 5)
        fire.Material = Enum.Material.Neon
        fire.BrickColor = BrickColor.new("Bright orange")
        fire.CanCollide = false
        fire.CFrame = spawnCF * CFrame.new(0, 0, -6)
        
        local bv = Instance.new("BodyVelocity", fire)
        bv.Velocity = spawnCF.LookVector * 120
        bv.MaxForce = Vector3.new(1, 1, 1) * 10^6
        
        Debris:AddItem(fire, 1.5)
        task.wait(0.1)
    end
end

function toggleDragonForm()
    if dragonVisual then
        dragonVisual:Destroy()
        dragonVisual = nil
        hum.HipHeight = 0
    else
        dragonVisual = Instance.new("Model", workspace)
        dragonVisual.Name = "DragonForm_" .. player.Name
        
        local function createPart(name, size, color)
            local p = Instance.new("Part", dragonVisual)
            p.Name = name; p.Size = size; p.Material = Enum.Material.Neon
            p.BrickColor = BrickColor.new(color); p.CanCollide = false
            pcall(function() p:SetNetworkOwner(player) end)
            return p
        end
        
        createPart("Body", Vector3.new(16, 6, 24), "Really red")
        createPart("Head", Vector3.new(8, 6, 8), "Bright orange")
        wing1 = createPart("Wing1", Vector3.new(20, 1, 10), "Black")
        wing2 = createPart("Wing2", Vector3.new(20, 1, 10), "Black")
        
        hum.HipHeight = 10
    end
end

function eatFruit()
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end

    local zSkill = Instance.new("Tool")
    zSkill.Name = "Dragon Breath [Z]"
    zSkill.RequiresHandle = false
    zSkill.Parent = backpack
    zSkill.Activated:Connect(fireBreathEffect)

    local xSkill = Instance.new("Tool")
    xSkill.Name = "Dragon Form [X]"
    xSkill.RequiresHandle = false
    xSkill.Parent = backpack
    xSkill.Activated:Connect(toggleDragonForm)
    
    MainFrame.Visible = false
end

-- Render Loop
RunService.RenderStepped:Connect(function(dt)
    if not dragonVisual or not dragonVisual:FindFirstChild("Body") then return end
    t = t + dt * 6
    local pos = root.Position
    local rot = root.CFrame.Rotation
    
    dragonVisual.Body.CFrame = CFrame.new(pos + Vector3.new(0, 12, 0)) * rot
    dragonVisual.Head.CFrame = dragonVisual.Body.CFrame * CFrame.new(0, 1, -14)
    
    wing1.CFrame = (dragonVisual.Body.CFrame * CFrame.new(-12, 2, 0)) * CFrame.Angles(0, 0, math.sin(t))
    wing2.CFrame = (dragonVisual.Body.CFrame * CFrame.new(12, 2, 0)) * CFrame.Angles(0, 0, -math.sin(t))
end)

-- UI Button
local eatBtn = Instance.new("TextButton")
eatBtn.Size = UDim2.new(0.8, 0, 0, 50)
eatBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
eatBtn.Text = "EAT FRUIT"
eatBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
eatBtn.TextColor3 = Color3.new(1, 1, 1)
eatBtn.Font = Enum.Font.SourceSansBold
eatBtn.TextSize = 16
eatBtn.Parent = MainFrame
Instance.new("UICorner", eatBtn)

eatBtn.MouseButton1Click:Connect(eatFruit)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
