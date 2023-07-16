
local Base = Script.Parent
local RotTime = Script.RotTime

function AnimLargeGear(player)
    Base.Track:AddLocalRot("RotHammer", Vector.new(0, 360, 0), RotTime)
    Base.Track:PlayTransformTrack("RotHammer", Enum.TransformPlayType.Repeat, InfinityPlay)
end
Game:ConnectEventFunction("AnimLargeGear", AnimLargeGear)



