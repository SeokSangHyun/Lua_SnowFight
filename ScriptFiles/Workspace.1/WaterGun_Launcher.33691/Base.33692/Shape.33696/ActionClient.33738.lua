local Item = Script.Parent.Parent.Parent
local Shape = Script.Parent
local Object = Shape.bolt
local ActTime = 0.08
local Firecheck = false

-----------------------------------연출 셋팅--------------------------------
Object.Track:AddLocalRot("FireAction", Vector.new(0, 0, -90), ActTime, false)
Shape.Track:AddLocalRot("Reaction", Vector.new(0, 10, 0), ActTime, false)


-----------------------------------공격 시 연출--------------------------------
local function PreFire(startfire)    
    if startfire then
        if not Firecheck then
            Firecheck = true      
            Object.Track:PlayTransformTrack("FireAction", 0, 1)
            Shape.Track:PlayTransformTrack("Reaction", 1, 1)
            wait(ActTime)
            Firecheck = false
        end
    end
end
Item:ConnectEventFunction("PreFire", PreFire)





















































