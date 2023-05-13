local Item = Script.Parent.Parent.Parent
local Object = Script.Parent.bolt
local ActTime = 0.06
local Firecheck = false

-----------------------------------연출 셋팅--------------------------------
Object.Track:AddLocalMove("FireAction", Vector.new(0, 0, 2), ActTime, false)


-----------------------------------공격 시 연출--------------------------------
local function PreFire(startfire)        
    if startfire then
        if not Firecheck then
            Firecheck = true    
            wait(0.1)
            Object.Track:PlayTransformTrack("FireAction", 1, 1)
            wait(ActTime)
            Firecheck = false
        end
    end
end
Item:ConnectEventFunction("PreFire", PreFire)





























