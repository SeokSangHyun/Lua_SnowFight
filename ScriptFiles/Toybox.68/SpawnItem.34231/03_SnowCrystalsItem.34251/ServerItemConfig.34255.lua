------------------------------------------------------------------------------------------------------------
local Item = Script.Parent
local Collisier = Item.GetCollider

Collisier.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)


local function CollisionEvent(self, target)
    if target == nil or not target:IsCharacter() then
       return
   end
   
   Game:DeleteObject(self.Parent)
   --Item:BroadcastEvent("GetFX", target:GetPlayerID())
end
Collisier.Collision.OnBeginOverlapEvent:Connect(CollisionEvent)

