
local PlayerModule = require(Workspace.System.Class.scPlayer)
local WeaponList = {Script.SnowBall , Script.Icicle , Script.SnowCrystal}


g_PlayerList = {}




function InitPlayer(player)
    local playerID = player:GetPlayerID()
    local info = PlayerModule.new(player, Toybox.SnowFight, Toybox.Bullet:GetChildList())
    
    g_PlayerList[ tostring(playerID) ] = info
    Game:SendEventToClient(playerID, "InitPlayer_sToc", playerID)
    
    --UI
    local remaincnt = info:GetAllBulletCount()
    Game:SendEventToClient(playerID, "SnowBall_UIUpdate", remaincnt[1])


    g_PlayerList[ tostring(playerID) ]:EquipItem(player)
end



--!---------------------------- 총알 발사 로직 ------------------------------
--# 목적 : 총알 생성
local function RequestFire(player, num, forX, forY, forZ)    
    local playerID = player:GetPlayerID()


    g_PlayerList[ tostring(playerID) ]:Fire(player, num, forX, forY, forZ)
    
    local remaincnt = g_PlayerList[ tostring(playerID) ]:GetAllBulletCount()
    Game:SendEventToClient(playerID, "SnowBall_UIUpdate", remaincnt[num])
end
Game:ConnectEventFunction("RequestFire_cTos", RequestFire)




local function HitProcess(player)
    
end
Game:ConnectEventFunction("HitProcess_cTos", HitProcess)
