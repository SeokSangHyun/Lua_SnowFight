------------------------------------------------------------------------------------------------------------
local Item = Script.Parent
local Collisier = Item.GetCollider
local obj = Item.Mesh

------------------------------------------------------------------------------------------------------------
--회전을 설정해요
if Item.IsTurn then
    obj.Track:AddLocalRot("Rot", Vector.new(180, 0, 0), Item.TurnSpeed)
    obj.Track:PlayTransformTrack("Rot", 0, InfinityPlay) 
end

------------------------------------------------------------------------------------------------------------
--캐릭터가 닿았을때 이펙트와 소리를 재생해요.
local function GetFX(playerID)
--[[
   local target = Game:GetRemotePlayerCharacter(playerID)
   local location = target.Location
   target:CreateFX(FX, Enum.Bone.Body)
   Game:PlaySound(GetSound, location)
]]--
end
Item:ConnectEventFunction("GetFX", GetFX)














