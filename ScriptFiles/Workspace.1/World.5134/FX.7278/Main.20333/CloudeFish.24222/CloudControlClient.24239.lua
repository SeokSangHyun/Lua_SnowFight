local toy = Script.Parent


local dir = Vector.new(0,0,0)
local upForce = 1000
local physics = Vector.new(0,0,0)
local force = Vector.new(0,0,0)

local stPos= Vector.new(0,0,0)

local StartTime = time()
local WaitTime = 0

local function init()
    WaitTime = 0
    StartTime = time()

    dir = Vector.new( (math.random(1,201)-101)*0.01, (math.random(1,201)-101)*0.01, 0)
    physics = math.random(10, 20)
    
    force = Vector.new(dir.X * physics, dir.Y * physics, upForce)
    
    local orginRot = toy.Rotation
    toy.Rotation = Vector.new(orginRot.X, orginRot.Y, math.atan(dir.X*dir.Y) * 180 / math.pi  )
    --print(dir)
end
init()


while true do
    WaitTime = time() - StartTime
    stPos=  toy.Location
    force = Vector.new(dir.X * physics, dir.Y * physics, upForce)
    
    
    toy.Location = Vector.new(stPos.X + force.X, stPos.Y + force.Y, 4000)
    
    if WaitTime >= 5 then
        init()
    end
    
    wait(0.05)
end
