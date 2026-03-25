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

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DragonControlSystem"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
Title.Text = "Dragon Menu"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

local function createBtn(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 45)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = MainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

function toggleDragon()
    if dragon then
        dragon:Destroy()
        dragon = nil
    else
        dragon = Instance.new("Model", workspace)
        dragon.Name = "Dragon_" .. player.Name
        
        local function createPart(name, size, color)
            local p = Instance.new("Part", dragon)
            p.Name = name
            p.Size = size
            p.Material = Enum.Material.Neon
            p.BrickColor = BrickColor.new(color)
            p.CanCollide = false
            pcall(function() p:SetNetworkOwner(player) end)
            return p
        end
        
        createPart("Body", Vector3.new(16, 6, 24), "Really red")
        createPart("Head", Vector3.new(8, 6, 8), "Bright orange")
        wing1 = createPart("Wing1", Vector3.new(20, 1, 10), "Black")
        wing2 = createPart("Wing2", Vector3.new(20, 1, 10), "Black")
    end
end

function fireBreath()
    for i = 1, 10 do
        local fire = Instance.new("Part", workspace)
        fire.Size = Vector3.new(4, 4, 4)
        fire.Material = Enum.Material.Neon
        fire.BrickColor = BrickColor.new("Bright orange")
        fire.CanCollide = false
        fire.CFrame = root.CFrame * CFrame.new(0, 0, -8)
        
        local bv = Instance.new("BodyVelocity", fire)
        bv.Velocity = root.CFrame.LookVector * 120
        bv.MaxForce = Vector3.new(1, 1, 1) * 10^6
        
        Debris:AddItem(fire, 1.5)
        task.wait(0.1)
    end
end

function toggleFly()
    flying = not flying
    if flying then
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "DragonFly"
        bv.MaxForce = Vector3.new(1, 1, 1) * 10^6
    else
        if root:FindFirstChild("DragonFly") then
            root.DragonFly:Destroy()
        end
    end
end

RunService.RenderStepped:Connect(function(dt)
    if not dragon or not dragon:FindFirstChild("Body") then return end
    t = t + dt * 6
    local pos = root.Position
    dragon.Body.CFrame = CFrame.new(pos + Vector3.new(0, 8, 0)) * root.CFrame.Rotation
    dragon.Head.CFrame = dragon.Body.CFrame * CFrame.new(0, 1, -14)
    wing1.CFrame = (dragon.Body.CFrame * CFrame.new(-12, 2, 0)) * CFrame.Angles(0, 0, math.sin(t))
    wing2.CFrame = (dragon.Body.CFrame * CFrame.new(12, 2, 0)) * CFrame.Angles(0, 0, -math.sin(t))
    
    if flying and root:FindFirstChild("DragonFly") then
        root.DragonFly.Velocity = root.CFrame.LookVector * 120
    end
end)

createBtn("Spawn Dragon", UDim2.new(0.075, 0, 0.22, 0), toggleDragon)
createBtn("Fire Breath", UDim2.new(0.075, 0, 0.45, 0), fireBreath)
createBtn("Toggle Fly", UDim2.new(0.075, 0, 0.68, 0), toggleFly)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
