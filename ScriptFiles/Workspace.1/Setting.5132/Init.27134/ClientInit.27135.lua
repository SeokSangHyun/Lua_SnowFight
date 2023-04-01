
GameRegistChair = Workspace.World.Lobby.Trigger.RegistChair:GetChildList()



UIRoot = Workspace.UI.MainUI
--버튼
BulletButtonList = UIRoot.BulletHUD

--[[
for i = 1, #GameRegistChair do
    GameRegistChair[i].BoxCollider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)
end
]]--
--Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)




