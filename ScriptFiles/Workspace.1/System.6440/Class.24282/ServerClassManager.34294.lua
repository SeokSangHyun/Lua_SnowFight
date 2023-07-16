
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
    local bulletcnt = 0
    
    if index == 1 then
        player.SnowBall:AddBullet(1)
        bulletcnt = player.SnowBall:GetBulletCount()
        Game:SendEventToClient(playerID, "BulletCountUpdate_sToc", index, bulletcnt)
    elseif index == 2 then
        player.Icicle:AddBullet(1)
        bulletcnt = player.Icicle:GetBulletCount()
        Game:SendEventToClient(playerID, "BulletCountUpdate_sToc", index, bulletcnt)
--[[
    elseif index == 3 then
        player.Crystal:AddBullet()
        player.Crystal:Initialize()
        Game:SendEventToClient(playerID, "Toggle_StormButton_sToc", true)
]]--
    else
    end
    
    
end
Game:ConnectEventFunction("GetBulletItem_cTos", GetBulletItem)













