
GameRegistChair = Workspace.World.Trigger.RegistChair:GetChildList()



--[[

local GameRegistChair = Workspace.World.Trigger.RegistChair:GetChildList()

for i = 1, #GameRegistChair do
    GameRegistChair[i].BoxCollider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)
end
--Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)





]]--