
local StonrParent = Script.Parent.StoneParent



--! ------------------------------ <DeathStone> ------------------------------
--# -----요약 : 게임 중 캐릭터 사망시
function CreateDeathStone(StoneIndex)
    local stone = StonrParent:GetChildList()
    ChangeCamera(stone[StoneIndex].Camera, stone[StoneIndex])
end
Game:ConnectEventFunction("CreateDeathStone", CreateDeathStone)





--# -----요약 : 사망한 캐릭터 부활 시
function RemoveDeathStone(StoneIndex)
    local player = LocalPlayer:GetRemotePlayer()
    ChangeCamera(Workspace.MainCamera, player:GetCharacter())
end
Game:ConnectEventFunction("RemoveDeathStone", RemoveDeathStone)







