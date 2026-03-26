-- Dragon V2 Full System (Integrated from Pastebin)
-- No Arabic Words / Ready for Loadstring

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

local isTransformed = false
local dragonSegments = {}
local t = 0

-- [[ GUI Setup ]]
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0.5, -100, 0.8, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Text = "DRAGON V2 READY"
Status.TextColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.GothamBold

local ActionBtn = Instance.new("TextButton", MainFrame)
ActionBtn.Size = UDim2.new(0.9, 0, 0, 40)
ActionBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
ActionBtn.Text = "OBTAIN POWER"
ActionBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
ActionBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", ActionBtn)

-- [[ Dragon Logic ]]
function createDragonBody()
    for _, v in pairs(dragonSegments) do v:Destroy() end
    dragonSegments = {}
    
    local count = 16 -- Long Serpent Body
    for i = 1, count do
        local seg = Instance.new("Part", workspace)
        seg.Size = (i == 1) and Vector3.new(12, 10, 14) or Vector3.new(10-i*0.5, 8-i*0.4, 10)
        seg.Color = (i % 2 == 0) and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(0, 100, 60)
        seg.Material = Enum.Material.Neon
        seg.CanCollide = false
        seg.Anchored = true
        Instance.new("SpecialMesh", seg).MeshType = Enum.MeshType.Sphere
        table.insert(dragonSegments, seg)
    end
end

function toggleTransform()
    isTransformed = not isTransformed
    if isTransformed then
        createDragonBody()
        hum.HipHeight = 25
        hum.WalkSpeed = 100
    else
        for _, v in pairs(dragonSegments) do v:Destroy() end
        dragonSegments = {}
        hum.HipHeight = 0
        hum.WalkSpeed = 16
    end
end

function dragonBeam()
    if not dragonSegments[1] then return end
    for i = 1, 20 do
        local p = Instance.new("Part", workspace)
        p.Size = Vector3.new(6,6,6)
        p.Color = Color3.fromRGB(0, 255, 255)
        p.Material = Enum.Material.Neon
        p.CFrame = dragonSegments[1].CFrame * CFrame.new(0, 0, -8)
        p.CanCollide = false
        local bv = Instance.new("BodyVelocity", p)
        bv.Velocity = dragonSegments[1].CFrame.LookVector * 200
        bv.MaxForce = Vector3.new(1,1,1)*1e7
        Debris:AddItem(p, 1)
        task.wait(0.05)
    end
end

-- [[ Input & Tools ]]
ActionBtn.MouseButton1Click:Connect(function()
    ActionBtn.Visible = false
    Status.Text = "DRAGON UNLOCKED"
    
    local z = Instance.new("Tool", player.Backpack)
    z.Name = "Dragon Beam [Z]"
    z.RequiresHandle = false
    z.Activated:Connect(dragonBeam)
    
    local x = Instance.new("Tool", player.Backpack)
    x.Name = "Transform [X]"
    x.RequiresHandle = false
    x.Activated:Connect(toggleTransform)
end)

-- [[ Serpentine Movement ]]
RunService.RenderStepped:Connect(function(dt)
    if not isTransformed or #dragonSegments == 0 then return end
    t = t + dt
    local headCF = root.CFrame * CFrame.new(0, 25, 0)
    
    for i, seg in ipairs(dragonSegments) do
        if i == 1 then
            seg.CFrame = seg.CFrame:Lerp(headCF, 0.2)
        else
            local prev = dragonSegments[i-1]
            local wave = math.sin(t * 5 + i * 0.5) * 3
            local follow = prev.CFrame * CFrame.new(wave, wave/2, 7)
            seg.CFrame = seg.CFrame:Lerp(follow, 0.15)
        end
    end
end)
