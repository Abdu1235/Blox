-- Dragon System (Replicated Visuals)
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

function spawnDragon()
    if dragon then
        dragon:Destroy()
        dragon = nil
        return
    end

    dragon = Instance.new("Model")
    dragon.Name = "Dragon_" .. player.Name

    local function createPart(name, size, color)
        local p = Instance.new("Part")
        p.Name = name
        p.Size = size
        p.Material = Enum.Material.Neon
        p.BrickColor = BrickColor.new(color)
        p.CanCollide = false
        p.Parent = dragon
        return p
    end

    local body = createPart("Body", Vector3.new(16, 6, 24), "Really red")
    local head = createPart("Head", Vector3.new(8, 6, 8), "Bright orange")
    wing1 = createPart("Wing1", Vector3.new(20, 1, 10), "Black")
    wing2 = createPart("Wing2", Vector3.new(20, 1, 10), "Black")

    dragon.Parent = workspace
    
    for _, part in pairs(dragon:GetChildren()) do
        if part:IsA("BasePart") then
            pcall(function() part:SetNetworkOwner(player) end)
        end
    end
end

RunService.RenderStepped:Connect(function(dt)
    if not dragon or not dragon:FindFirstChild("Body") then return end

    t = t + dt * 6
    local pos = root.Position
    local rot = root.CFrame.Rotation

    dragon.Body.CFrame = CFrame.new(pos + Vector3.new(0, 8, 0)) * rot
    dragon.Head.CFrame = dragon.Body.CFrame * CFrame.new(0, 1, -14)
    
    wing1.CFrame = (dragon.Body.CFrame * CFrame.new(-12, 2, 0)) * CFrame.Angles(0, 0, math.sin(t))
    wing2.CFrame = (dragon.Body.CFrame * CFrame.new(12, 2, 0)) * CFrame.Angles(0, 0, -math.sin(t))
end)

function fireBreath()
    for i = 1, 10 do
        local fire = Instance.new("Part")
        fire.Size = Vector3.new(4, 4, 4)
        fire.Material = Enum.Material.Neon
        fire.BrickColor = BrickColor.new("Bright orange")
        fire.CanCollide = false
        fire.CFrame = root.CFrame * CFrame.new(0, 0, -8)
        fire.Parent = workspace
        
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = root.CFrame.LookVector * 100
        bv.MaxForce = Vector3.new(1, 1, 1) * 10^6
        bv.Parent = fire
        
        Debris:AddItem(fire, 1.5)
        task.wait(0.1)
    end
end

function toggleFly()
    flying = not flying
    if flying then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "DragonFly"
        bv.MaxForce = Vector3.new(1, 1, 1) * 10^6
        bv.Velocity = root.CFrame.LookVector * 100
        bv.Parent = root
    else
        if root:FindFirstChild("DragonFly") then
            root.DragonFly:Destroy()
        end
    end
end

RunService.Heartbeat:Connect(function()
    if flying and root:FindFirstChild("DragonFly") then
        root.DragonFly.Velocity = root.CFrame.LookVector * 120
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.T then spawnDragon() end
    if input.KeyCode == Enum.KeyCode.F then fireBreath() end
    if input.KeyCode == Enum.KeyCode.G then toggleFly() end
end)
