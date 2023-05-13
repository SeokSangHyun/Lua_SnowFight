

function GetBulletItem(player, index)
    local playerID = player:GetPlayerID()
    local bulletcnt = g_PlayerList[ tostring(playerID) ]:GetItem(player, index)
    
    Game:SendEventToClient(playerID, "BulletCountUpdate_sToc", index, bulletcnt)
end
Game:ConnectEventFunction("GetBulletItem_cTos", GetBulletItem)

