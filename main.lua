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

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DragonFruitGui"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.05, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Dragon Fruit Creator"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = Frame
Instance.new("UICorner", Title)

-- Function to give the Dragon Fruit Tool
function giveDragonFruit()
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end
    
    -- Check if already has the fruit
    if backpack:FindFirstChild("Dragon Fruit") or char:FindFirstChild("Dragon Fruit") then
        return 
    end

    local tool = Instance.new("Tool")
    tool.Name = "Dragon Fruit"
    tool.RequiresHandle = true
    tool.Parent = backpack

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1.5, 1.5, 1.5)
    handle.BrickColor = BrickColor.new("Really red")
    handle.Material = Enum.Material.Neon
    handle.Parent = tool
    
    -- Add visual effect to the fruit
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Sphere
    mesh.Parent = handle

    -- Skills when using the fruit
    tool.Activated:Connect(function()
        spawnDragon() -- Call the dragon visual
        fireBreath()  -- Call the fire breath
    end)
end

-- Dragon Functions (Visuals)
function spawnDragon()
    if dragon then dragon:Destroy() dragon = nil return end
    dragon = Instance.new("Model", workspace)
    dragon.Name = "Dragon_Power"
    local function createPart(size, color)
        local p = Instance.new("Part", dragon)
        p.Size = size; p.Material = Enum.Material.Neon; p.BrickColor = BrickColor.new(color)
        p.Anchored = true; p.CanCollide = false
        return p
    end
    local body = createPart(Vector3.new(16,6,24), "Really red")
    local head = createPart(Vector3.new(8,6,8), "Bright orange")
    wing1 = createPart(Vector3.new(20,1,10), "Black")
    wing2 = createPart(Vector3.new(20,1,10), "Black")
end

function fireBreath()
    for i = 1,15 do
        local fire = Instance.new("Part", workspace)
        fire.Size = Vector3.new(4,4,4); fire.Material = Enum.Material.Neon; fire.BrickColor = BrickColor.new("Bright orange")
        fire.CanCollide = false; fire.CFrame = root.CFrame * CFrame.new(0,0,-8)
        local vel = Instance.new("BodyVelocity", fire)
        vel.Velocity = root.CFrame.LookVector * 150; vel.MaxForce = Vector3.new(999999,999999,999999)
        Debris:AddItem(fire,2)
        task.wait(0.05)
    end
end

-- Animation Loop
RunService.RenderStepped:Connect(function(dt)
    if not dragon then return end
    t = t + dt * 6
    local pos = root.Position
    dragon:GetChildren()[1].CFrame = CFrame.new(pos + Vector3.new(0,5,0)) * root.CFrame.Rotation
    dragon:GetChildren()[2].CFrame = dragon:GetChildren()[1].CFrame * CFrame.new(0,0,-12)
    wing1.CFrame = (dragon:GetChildren()[1].CFrame * CFrame.new(-12, 2, 0)) * CFrame.Angles(0,0,math.sin(t))
    wing2.CFrame = (dragon:GetChildren()[1].CFrame * CFrame.new(12, 2, 0)) * CFrame.Angles(0,0,-math.sin(t))
end)

-- UI Button
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.8, 0, 0, 50)
btn.Position = UDim2.new(0.1, 0, 0.45, 0)
btn.Text = "Get Dragon Fruit"
btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.SourceSansBold
btn.Parent = Frame
Instance.new("UICorner", btn)

btn.MouseButton1Click:Connect(giveDragonFruit)

-- Toggle Menu
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        Frame.Visible = not Frame.Visible
    end
end)
