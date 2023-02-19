local CloudeRoot = Workspace.World.FX.Sky
local list_toy = CloudeRoot:GetChildList()


local dir = Vector.new(0,0,0)
local upForce = 1000
local physics = Vector.new(0,0,0)
local force = Vector.new(0,0,0)

local stPos= Vector.new(0,0,0)

local StartTime = time()
local WaitTime = 0



local function init()
    local rotSpeed = 0
    for i = 1 , #list_toy do
        --table.insert(list_radius, math.random(10, 50))
        rotSpeed = math.random(10, 50)

        list_toy[i].Track:AddLocalRot("Rot", Vector.new(0, 0, 360), rotSpeed)
        list_toy[i].Track:PlayTransformTrack("Rot", Enum.TransformPlayType.Repeat, InfinityPlay)
    end
end
init()
