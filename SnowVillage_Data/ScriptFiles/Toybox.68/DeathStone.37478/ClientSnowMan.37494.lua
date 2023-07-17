
local toy = Script.Parent



local Spring1 = toy.LargeGear
local Spring2 = toy.SmallGear

local Tree = toy.Tree



local term = 0
local Gear_rot = {Vector.new(0,-30,0), Vector.new(0,-20,0), Vector.new(0,-10,0), Vector.new(0,0,0), Vector.new(0,10,0), Vector.new(0,20,0), Vector.new(0,30,0)}
local Tree_rot = {Vector.new(0,0,150), Vector.new(0,0,160), Vector.new(0,0,170), Vector.new(0,0,180), Vector.new(0,0,190), Vector.new(0,0,200), Vector.new(0,0,210)}


function toy:FrozenUpdate()
    Spring1.Rotation = Gear_rot[math.random(1,#Gear_rot)]
    Spring2.Rotation = Gear_rot[math.random(1,#Gear_rot)]
    Tree.Rotation = Tree_rot[math.random(1,#Tree_rot)]
end





