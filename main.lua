local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local isTransformed = false
local dragonModel = nil
local wing1, wing2
local rotTick = 0

-- [[ UI DESIGN ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DragonSim_v3"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 100)
MainFrame.Position = UDim2.new(0.5, -110, 0.8, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "DRAGON FRUIT SYSTEM"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- [[ CORE FUNCTIONS ]]

function createDragonModel()
    if dragonModel then dragonModel:Destroy() end
    
    dragonModel = Instance.new("Model", workspace)
    dragonModel.Name = "DragonEntity_" .. player.Name
    
    local function makePart(name, size, color, offset)
        local p = Instance.new("Part", dragonModel)
        p.Name = name
        p.Size = size
        p.Material = Enum.Material.Neon
        p.BrickColor = BrickColor.new(color)
        p.CanCollide = false
        p.Anchored = true
        return p
    end
    
    local body = makePart("Body", Vector3.new(18, 7, 26), "Really red")
    local head = makePart("Head", Vector3.new(10, 7, 10), "Bright orange")
    wing1 = makePart("Wing1", Vector3.new(25, 1, 12), "Black")
    wing2 = makePart("Wing2", Vector3.new(25, 1, 12), "Black")
end

function fireSkill()
    local origin = isTransformed and dragonModel.Head.CFrame or root.CFrame
    for i = 1, 15 do
        local p = Instance.new("Part", workspace)
        p.Size = Vector3.new(5, 5, 5)
        p.Color = Color3.fromRGB(255, 100, 0)
        p.Material = Enum.Material.Neon
        p.CFrame = origin * CFrame.new(0, 0, -5)
        p.CanCollide = false
        
        local bv = Instance.new("BodyVelocity", p)
        bv.MaxForce = Vector3.new(1,1,1) * 1e6
        bv.Velocity = origin.LookVector * 130
        
        Debris:AddItem(p, 1.2)
        task.wait(0.08)
    end
end

function transformSkill()
    isTransformed = not isTransformed
    if isTransformed then
        createDragonModel()
        hum.HipHeight = 12
    else
        if dragonModel then dragonModel:Destroy() dragonModel = nil end
        hum.HipHeight = 0
    end
end

-- [[ THE FAKE FRUIT ITEM ]]
function spawnFakeFruit()
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end
    
    local tool = Instance.new("Tool")
    tool.Name = "Dragon Fruit (Eat Me)"
    tool.RequiresHandle = true
    tool.Parent = backpack
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1.5, 1.5, 1.5)
    handle.Color = Color3.fromRGB(0, 200, 150) -- Greenish like your photo
    handle.Material = Enum.Material.Neon
    handle.Parent = tool
    
    local mesh = Instance.new("SpecialMesh", handle)
    mesh.MeshType = Enum.MeshType.Sphere
    
    -- Decorative horns for the fruit
    local h1 = Instance.new("Part", tool)
    h1.Size = Vector3.new(0.5, 1, 0.5)
    h1.Color = Color3.fromRGB(100, 50, 0)
    local w = Instance.new("Weld", h1)
    w.Part0 = handle; w.Part1 = h1; w.C0 = CFrame.new(0.5, 0.8, 0)
    
    tool.Activated:Connect(function()
        -- Eat Sequence
        Title.Text = "EATING..."
        task.wait(0.5)
        tool:Destroy() -- Fruit is gone
        Title.Text = "DRAGON POWER UNLOCKED"
        
        -- Give Skills
        local s1 = Instance.new("Tool", backpack)
        s1.Name = "Heat Beam [Z]"
        s1.RequiresHandle = false
        s1.Activated:Connect(fireSkill)
        
        local s2 = Instance.new("Tool", backpack)
        s2.Name = "Dragon Form [X]"
        s2.RequiresHandle = false
        s2.Activated:Connect(transformSkill)
        
        MainFrame:Destroy()
    end)
end

-- [[ ANIMATION LOOP ]]
RunService.RenderStepped:Connect(function(dt)
    if not isTransformed or not dragonModel then return end
    rotTick = rotTick + dt * 6
    
    local targetCF = root.CFrame
    dragonModel.Body.CFrame = targetCF * CFrame.new(0, 15, 0)
    dragonModel.Head.CFrame = dragonModel.Body.CFrame * CFrame.new(0, 2, -15)
    
    wing1.CFrame = (dragonModel.Body.CFrame * CFrame.new(-15, 3, 0)) * CFrame.Angles(0, 0, math.sin(rotTick))
    wing2.CFrame = (dragonModel.Body.CFrame * CFrame.new(15, 3, 0)) * CFrame.Angles(0, 0, -math.sin(rotTick))
end)

-- [[ START BUTTON ]]
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.9, 0, 0, 40)
btn.Position = UDim2.new(0.05, 0, 0.45, 0)
btn.Text = "SPAWN FRUIT"
btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
btn.Parent = MainFrame
Instance.new("UICorner", btn)

btn.MouseButton1Click:Connect(function()
    spawnFakeFruit()
    btn.Visible = false
    Title.Text = "CHECK BACKPACK"
end)
