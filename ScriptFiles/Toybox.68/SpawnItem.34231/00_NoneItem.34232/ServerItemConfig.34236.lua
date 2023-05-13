------------------------------------------------------------------------------------------------------------
local Item = Script.Parent
local Collisier = Item.GetCollider

Collisier.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)


local function CollisionEvent(self, target)
    if target == nil or not target:IsCharacter() then;    return;    end;
   
   --Game:DeleteObject(self.Parent)
   --Item:BroadcastEvent("GetFX", target:GetPlayerID())
end
Collisier.Collision.OnBeginOverlapEvent:Connect(CollisionEvent)


--* 00번 인덱스 아이템은 바로 삭제 처리
wait(0.5)
Game:DeleteObject(Item)

