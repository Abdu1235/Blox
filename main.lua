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
local dragonParts = {}
local t = 0

-- [[ UI SYSTEM ]]
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "DragonV2Final"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 90)
MainFrame.Position = UDim2.new(0.5, -110, 0.85, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 15, 10)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

local Btn = Instance.new("TextButton", MainFrame)
Btn.Size = UDim2.new(0.9, 0, 0, 50)
Btn.Position = UDim2.new(0.05, 0, 0.2, 0)
Btn.Text = "ACTIVATE DRAGON V2"
Btn.TextColor3 = Color3.fromRGB(0, 255, 150)
Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Btn.Font = Enum.Font.GothamBold
Btn.TextSize = 14
Instance.new("UICorner", Btn)

-- [[ DRAGON VISUALS ]]
function createDragonV2()
    for _, v in pairs(dragonParts) do v:Destroy() end
    dragonParts = {}
    
    local segmentCount = 15 -- Longest body for 100% match
    for i = 1, segmentCount do
        local seg = Instance.new("Part", workspace)
        seg.Name = "DragonPart_" .. i
        -- Head is larger, body tapers down
        local sizeScale = (i == 1) and 12 or (10 - (i * 0.4))
        seg.Size = Vector3.new(sizeScale, sizeScale * 0.8, sizeScale * 1.2)
        seg.Color = (i % 2 == 0) and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(0, 80, 50)
        seg.Material = Enum.Material.Neon
        seg.CanCollide = false
        seg.Anchored = true
        
        local mesh = Instance.new("SpecialMesh", seg)
        mesh.MeshType = Enum.MeshType.Sphere
        
        -- Add Horns only to Head (Segment 1)
        if i == 1 then
            for side = -1, 1, 2 do
                local horn = Instance.new("Part", seg)
                horn.Size = Vector3.new(1, 5, 1)
                horn.Color = Color3.fromRGB(150, 120, 80)
                horn.CanCollide = false
                local w = Instance.new("Weld", horn)
                w.Part0 = seg; w.Part1 = horn; w.C0 = CFrame.new(side * 3, 4, 2) * CFrame.Angles(0.5, 0, 0)
            end
        end
        table.insert(dragonParts, seg)
    end
end

function fireSkill()
    local head = dragonParts[1]
    if not head then return end
    
    -- Visual Flash
    local light = Instance.new("PointLight", head)
    light.Color = Color3.fromRGB(0, 255, 255)
    light.Range = 30
    Debris:AddItem(light, 1)

    for i = 1, 30 do
        local orb = Instance.new("Part", workspace)
        orb.Size = Vector3.new(4, 4, 4)
        orb.Color = Color3.fromRGB(0, 255, 200)
        orb.Material = Enum.Material.Neon
        orb.Shape = Enum.PartType.Ball
        orb.CanCollide = false
        orb.CFrame = head.CFrame * CFrame.new(0, 0, -8)
        
        local bv = Instance.new("BodyVelocity", orb)
        bv.Velocity = head.CFrame.LookVector * 250
        bv.MaxForce = Vector3.new(1,1,1) * 1e7
        
        Debris:AddItem(orb, 1)
        task.wait(0.03)
    end
end

function toggleTransform()
    isTransformed = not isTransformed
    if isTransformed then
        createDragonV2()
        hum.HipHeight = 25
        hum.WalkSpeed = 120 -- High speed like V2
        char.Archivable = true
        local ghost = char:Clone() -- Visual effect
        ghost.Parent = workspace
        Debris:AddItem(ghost, 0.5)
    else
        for _, v in pairs(dragon
