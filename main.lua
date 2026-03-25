-- Dragon System (visual demo)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local dragon = nil
local wing1, wing2
local flying = false
local t = 0

-- 🐉 DRAGON MODEL
function spawnDragon()

    if dragon then
        dragon:Destroy()
        dragon = nil
        return
    end

    dragon = Instance.new("Model")
    dragon.Name = "Dragon"

    local body = Instance.new("Part")
    body.Size = Vector3.new(16,6,24)
    body.Material = Enum.Material.Neon
    body.BrickColor = BrickColor.new("Really red")
    body.Anchored = true
    body.Parent = dragon

    local head = Instance.new("Part")
    head.Size = Vector3.new(8,6,8)
    head.Material = Enum.Material.Neon
    head.BrickColor = BrickColor.new("Bright orange")
    head.Anchored = true
    head.Parent = dragon

    wing1 = Instance.new("Part")
    wing1.Size = Vector3.new(20,1,10)
    wing1.BrickColor = BrickColor.new("Black")
    wing1.Anchored = true
    wing1.Parent = dragon

    wing2 = wing1:Clone()
    wing2.Parent = dragon

    dragon.Parent = workspace

end

-- 🪽 WING ANIMATION
RunService.RenderStepped:Connect(function(dt)

    if not dragon then return end

    t = t + dt * 6

    local pos = root.Position

    dragon:GetChildren()[1].CFrame =
        CFrame.new(pos + Vector3.new(0,3,0))

    dragon:GetChildren()[2].CFrame =
        CFrame.new(pos + Vector3.new(0,4,-12))

    wing1.CFrame =
        CFrame.new(pos + Vector3.new(-10,4,0))
        * CFrame.Angles(0,0,math.sin(t))

    wing2.CFrame =
        CFrame.new(pos + Vector3.new(10,4,0))
        * CFrame.Angles(0,0,-math.sin(t))

end)

-- 🔥 FIRE BREATH EFFECT
function fireBreath()

    for i = 1,15 do

        local fire = Instance.new("Part")
        fire.Size = Vector3.new(6,6,12)
        fire.Material = Enum.Material.Neon
        fire.BrickColor = BrickColor.new("Bright orange")
        fire.CanCollide = false
        fire.CFrame = root.CFrame * CFrame.new(0,0,-8)
        fire.Parent = workspace

        local vel = Instance.new("BodyVelocity")
        vel.Velocity = root.CFrame.LookVector * 150
        vel.MaxForce = Vector3.new(999999,999999,999999)
        vel.Parent = fire

        game.Debris:AddItem(fire,2)

        task.wait(0.05)

    end

end

-- 💨 FLY SYSTEM
function toggleFly()

    flying = not flying

    if flying then

        local bv = Instance.new("BodyVelocity")
        bv.Name = "DragonFly"
        bv.MaxForce = Vector3.new(999999,999999,999999)
        bv.Parent = root

        RunService.RenderStepped:Connect(function()

            if root:FindFirstChild("DragonFly") then
                root.DragonFly.Velocity =
                    root.CFrame.LookVector * 120
            end

        end)

    else

        if root:FindFirstChild("DragonFly") then
            root.DragonFly:Destroy()
        end

    end

end

-- 🎮 TUGMALAR
UIS.InputBegan:Connect(function(input)

    if input.KeyCode == Enum.KeyCode.T then
        spawnDragon()
    end

    if input.KeyCode == Enum.KeyCode.F then
        fireBreath()
    end

    if input.KeyCode == Enum.KeyCode.G then
        toggleFly()
    end

end)
