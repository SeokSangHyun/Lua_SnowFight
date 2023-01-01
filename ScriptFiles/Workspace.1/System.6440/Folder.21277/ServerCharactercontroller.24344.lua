
local PlayerModule = require(Workspace.System.Class.scPlayer)
local WeaponList = {Script.SnowBall , Script.Icicle , Script.SnowCrystal}


g_PlayerList = {}




function InitPlayer(player)
    local playerID = player:GetPlayerID()
    local info = PlayerModule.new(player, Toybox.SpawnItem:GetChildList())
    
    g_PlayerList[ tostring(playerID) ] = info
    Game:SendEventToClient(playerID, "InitPlayer_sToc", playerID)
    
    --UI
    local remaincnt = info:GetAllBulletCount()
    Game:SendEventToClient(playerID, "SnowBall_UIUpdate", remaincnt[1])
end


local function WeaponFire(player, num, forX, forY, forZ)
    local playerID = player:GetPlayerID()
    g_PlayerList[ tostring(playerID) ]:Fire(player, num, forX, forY, forZ)
    
    local remaincnt = g_PlayerList[ tostring(playerID) ]:GetAllBulletCount()
    Game:SendEventToClient(playerID, "SnowBall_UIUpdate", remaincnt[num])
end
Game:ConnectEventFunction("WeaponFire_cTos", WeaponFire)





