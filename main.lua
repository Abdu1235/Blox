local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local dragonParts = {}
local isTransformed = false

function createDragon()
    for _, v in pairs(dragonParts) do v:Destroy() end
    dragonParts = {}
    for i = 1, 15 do
        local p = Instance.new("Part", workspace)
        p.Size = (i == 1) and Vector3.new(12, 10, 15) or Vector3.new(10-i*0.5, 8-i*0.4, 10)
        p.Color = (i % 2 == 0) and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(0, 80, 50)
        p.Material = Enum.Material.Neon
        p.CanCollide = false
        p.Anchored = true
        Instance.new("SpecialMesh", p).MeshType = Enum.MeshType.Sphere
        table.insert(dragonParts, p)
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    if #dragonParts == 0 then return end
    local targetHead = root.CFrame * CFrame.new(0, 25, 0)
    for i, seg in ipairs(dragonParts) do
        if i == 1 then
            seg.CFrame = seg.CFrame:Lerp(targetHead, 0.2)
        else
            local prev = dragonParts[i-1]
            seg.CFrame = seg.CFrame:Lerp(prev.CFrame * CFrame.new(math.sin(tick()*5+i)*2, 0, 7), 0.15)
        end
    end
end)

createDragon()
hum.HipHeight = 25
