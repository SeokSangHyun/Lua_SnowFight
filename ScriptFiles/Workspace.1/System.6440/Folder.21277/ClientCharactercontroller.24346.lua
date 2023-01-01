
local PlayerModule = require(Workspace.System.Class.ccPlayer)
local WeaponList = {Script.SnowBall , Script.Icicle , Script.SnowCrystal}


g_Player = {}




local function InitPlayer(playerID)

    local info = PlayerModule.new(playerID, Toybox.SpawnItem:GetChildList())
    --table.insert(g_PlayerList, info)
    
    g_Player = info
end
Game:ConnectEventFunction("InitPlayer_sToc", InitPlayer)



--GetCameraForward : 카메라가 바라보는 방향
local function BulletFire(playerID, num, forX, forY, forZ)
    
    g_Player:Fire(playerID, num, forX, forY, forZ)
end
Game:ConnectEventFunction("BulletFire", BulletFire)


