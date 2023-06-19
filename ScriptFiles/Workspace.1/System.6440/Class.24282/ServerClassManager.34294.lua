
local WaitTime = 0.1
local FrameTime = 0.0



--!---------------------------- 데이터 세팅 ------------------------------
Game:AddReplicateValue("CtrlMoveForward", false, Enum.ReplicateType.Changed, 0)
Game:AddReplicateValue("CtrlMoveRight", false, Enum.ReplicateType.Changed, 0)





function EquipItem(player)
    player:GiveItem(Toybox.SnowFight)
    player:EquipInventoryItem(1)
end







--!---------------------------- 처리 ------------------------------
function GetBulletItem(player, index)
    local playerID = player:GetPlayerID()
    local cnt = 0
    
    if index == 1 or index == 4 then
        cnt = player.SnowBall:AddBullet(1)
    elseif index == 2 then
        cnt = player.Icicle:AddBullet(1)
    elseif index == 3 then
        --player.Crystal = ThrowModule.new(bullets[2])
    end
    
    Game:SendEventToClient(playerID, "BulletCountUpdate_sToc", index, cnt)
end
Game:ConnectEventFunction("GetBulletItem_cTos", GetBulletItem)













