------------------------------------------------------------------------------------------------------------
local Item = Script.Parent
local Collisier = Item.GetCollider

Collisier.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)


local function CollisionEvent(self, target)
    if target == nil or not target:IsCharacter() then
       return
   end
   local player = target:GetPlayer()
   local Item_Index = tonumber( string.sub(Item.Name, 1, 2) )
   
   GetBulletItem(player, Item_Index)

   --Item:BroadcastEvent("GetFX", target:GetPlayerID())
   Game:DeleteObject(self.Parent)
end
Collisier.Collision.OnBeginOverlapEvent:Connect(CollisionEvent)

