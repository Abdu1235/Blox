local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local dragon = nil
local wing1, wing2
local flying = false
local t = 0

-- === [ GUI SETUP ] ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DragonFruitSystem"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 200)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Title.Text = "Dragon Fruit Menu"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame
Instance.new("UICorner", Title)

-- === [ FUNCTIONS ] ===

-- Function to create the Tool (The Fruit)
function giveFruit()
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end

    local fruitTool = Instance.new("Tool")
    fruitTool.Name = "Dragon Fruit"
    fruitTool.RequiresHandle = true
    fruitTool.Parent = backpack

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1.2, 1.2, 1.2)
    handle.BrickColor = BrickColor.new("Really red")
    handle.Material = Enum.Material.Neon
    handle.Parent = fruitTool
    
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Sphere
    mesh.Parent = handle

    -- When you click with the fruit
    fruitTool.Activated:Connect(function()
        fireBreath()
    end)
end

function spawnDragon()
    if dragon then dragon:Destroy() dragon = nil return end
    dragon = Instance.new("Model", workspace)
    dragon.Name = "DragonVisual"
    
    local function createPart(size, color)
        local p = Instance.new("Part", dragon)
        p.Size = size; p.Material = Enum.Material.Neon; p.BrickColor = BrickColor.new(color)
        p.Anchored = true; p.CanCollide = false
        pcall(function() p:SetNetworkOwner(player) end)
        return p
    end
    
    local body = createPart(Vector3.new(16,6,24), "Really red")
    local head = createPart(Vector3.new(8,6,8), "Bright orange")
    wing1 = createPart(Vector3.new(20,1,10), "Black")
    wing2 = createPart(Vector3.new(20,1,10), "Black")
end

function fireBreath()
    for i = 1,10 do
        local fire = Instance.new("Part", workspace)
        fire.Size = Vector3.new(4,4,4); fire.Material = Enum.Material.Neon; fire.BrickColor = BrickColor.new("Bright orange")
        fire.CanCollide = false; fire.CFrame = root.CFrame * CFrame.new(0,0,-6)
        local vel = Instance.new("BodyVelocity", fire)
        vel.Velocity = root.CFrame.LookVector * 100; vel.MaxForce = Vector3.new(1,1,1)*10^6
        Debris:AddItem(fire, 1.5); task.wait(0.1)
    end
end

-- === [ UI BUTTONS ] ===

local function createBtn(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = MainFrame
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

createBtn("Give Dragon Fruit", UDim2.new(0.1, 0, 0.25, 0), giveFruit)
createBtn("Toggle Dragon Visual", UDim2.new(0.1, 0, 0.50, 0), spawnDragon)
createBtn("Fire Breath", UDim2.new(0.1, 0, 0.75, 0), fireBreath)

-- Render Loop for Wings
RunService.RenderStepped:Connect(function(dt)
    if not dragon then return end
    t = t + dt * 6
    local pos = root.Position
    dragon:GetChildren()[1].CFrame = CFrame.new(pos + Vector3.new(0,8,0)) * root.CFrame.Rotation
    dragon:GetChildren()[2].CFrame = dragon:GetChildren()[1].CFrame * CFrame.new(0,0,-12)
    wing1.CFrame = (dragon:GetChildren()[1].CFrame * CFrame.new(-12, 2, 0)) * CFrame.Angles(0,0,math.sin(t))
    wing2.CFrame = (dragon:GetChildren()[1].CFrame * CFrame.new(12, 2, 0)) * CFrame.Angles(0,0,-math.sin(t))
end)

-- Toggle Menu with Insert
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
