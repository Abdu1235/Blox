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
ScreenGui.Name = "DragonSystemGui"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 180, 0, 220)
Frame.Position = UDim2.new(0.05, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Dragon Menu"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = Frame
Instance.new("UICorner", Title)

local function createButton(name, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = Frame
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Dragon Functions
function spawnDragon()
    if dragon then
        dragon:Destroy()
        dragon = nil
        return
    end

    dragon = Instance.new("Model", workspace)
    dragon.Name = "Dragon"

    local function createPart(size, color)
        local p = Instance.new("Part", dragon)
        p.Size = size
        p.Material = Enum.Material.Neon
        p.BrickColor = BrickColor.new(color)
        p.Anchored = true
        p.CanCollide = false
        pcall(function() p:SetNetworkOwner(player) end)
        return p
    end

    local body = createPart(Vector3.new(16,6,24), "Really red")
    local head = createPart(Vector3.new(8,6,8), "Bright orange")
    wing1 = createPart(Vector3.new(20,1,10), "Black")
    wing2 = createPart(Vector3.new(20,1,10), "Black")
end

RunService.RenderStepped:Connect(function(dt)
    if not dragon then return end
    t = t + dt * 6
    local pos = root.Position
    dragon:GetChildren()[1].CFrame = CFrame.new(pos + Vector3.new(0,3,0)) * root.CFrame.Rotation
    dragon:GetChildren()[2].CFrame = CFrame.new(pos + Vector3.new(0,4,-12)) * root.CFrame.Rotation
    wing1.CFrame = (dragon:GetChildren()[1].CFrame * CFrame.new(-12, 2, 0)) * CFrame.Angles(0,0,math.sin(t))
    wing2.CFrame = (dragon:GetChildren()[1].CFrame * CFrame.new(12, 2, 0)) * CFrame.Angles(0,0,-math.sin(t))
end)

function fireBreath()
    for i = 1,15 do
        local fire = Instance.new("Part", workspace)
        fire.Size = Vector3.new(6,6,12)
        fire.Material = Enum.Material.Neon
        fire.BrickColor = BrickColor.new("Bright orange")
        fire.CanCollide = false
        fire.CFrame = root.CFrame * CFrame.new(0,0,-8)
        local vel = Instance.new("BodyVelocity", fire)
        vel.Velocity = root.CFrame.LookVector * 150
        vel.MaxForce = Vector3.new(999999,999999,999999)
        Debris:AddItem(fire,2)
        task.wait(0.05)
    end
end

function toggleFly()
    flying = not flying
    if flying then
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "DragonFly"
        bv.MaxForce = Vector3.new(999999,999999,999999)
        bv.Velocity = root.CFrame.LookVector * 120
    else
        if root:FindFirstChild
        
