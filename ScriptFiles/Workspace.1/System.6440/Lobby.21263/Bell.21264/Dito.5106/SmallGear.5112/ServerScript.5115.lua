
local Base = Script.Parent
local RotTime = Script.RotTime

function AnimSmallGear(player)
    Base:AddLocalRot("RotHammer", Vector.new(0, -360, 0), RotTime)
    Base:PlayTransformTrack("RotHammer", Enum.TransformPlayType.Repeat, InfinityPlay)
end
Game:ConnectEventFunction("AnimSmallGear", AnimSmallGear)



