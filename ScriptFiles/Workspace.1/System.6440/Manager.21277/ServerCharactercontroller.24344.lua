
local PlayerModule = require(Workspace.System.Class.scPlayer)
local WeaponList = {Script.SnowBall , Script.Icicle , Script.SnowCrystal , Script.SnowBallRolling}


g_PlayerList = {}

--# 초기화
function InitPlayer(player)
    local playerID = player:GetPlayerID()
    local info = PlayerModule.new(player, Toybox.SnowFight, Toybox.Bullet:GetChildList())
    
    g_PlayerList[ tostring(playerID) ] = info
    g_PlayerList[ tostring(playerID) ]:EquipItem(player)

    Game:SendEventToClient(playerID, "InitPlayer_sToc", playerID)
    
    --UI
    local remaincnt = info:GetAllBulletCount()
    Game:SendEventToClient(playerID, "SnowBall_UIUpdate", remaincnt[1])
end



--!---------------------------- 총알 발사 로직 ------------------------------
--# 목적 : 총알 생성
local function RequestFire(player, num, stX, stY, stZ, forX, forY, forZ)

    --발사 전 처리
    local playerID = player:GetPlayerID()
    g_PlayerList[ tostring(playerID) ]:PreFire(num, stX, stY, stZ, forX, forY, forZ)
    
    local remaincnt = g_PlayerList[ tostring(playerID) ]:GetAllBulletCount()
    Game:SendEventToClient(playerID, "SnowBall_UIUpdate", remaincnt[num])


    --실제 발사 처리
    g_PlayerList[ tostring(playerID) ]:Fire()
end
Game:ConnectEventFunction("RequestFire_cTos", RequestFire)




local function HitProcess(player)
    
end
Game:ConnectEventFunction("HitProcess_cTos", HitProcess)





--!---------------------------- 롤링 시스템 ------------------------------
local function RollingSystemStart(player)
    local playerID = player:GetPlayerID()
    g_PlayerList[ tostring(playerID) ]:RollingStart()
end
Game:ConnectEventFunction("RollingSystemStart_cTos", RollingSystemStart)


local function RollingScallingUp(player, waittime, forX, forY)
    local playerID = player:GetPlayerID()
    g_PlayerList[ tostring(playerID) ]:Rolling(waittime, forX, forY)
end
Game:ConnectEventFunction("RollingScallingUp_cTos", RollingScallingUp)


local function RollingThrow(player, forX, forY, forZ)
    local playerID = player:GetPlayerID()
    g_PlayerList[ tostring(playerID) ]:RollingThrow(forX, forY, forZ)

    Game:SendEventToClient(playerID, "Toggle_RollingGuage_sToc", false)
end
Game:ConnectEventFunction("RollingThrow_cTos", RollingThrow)



