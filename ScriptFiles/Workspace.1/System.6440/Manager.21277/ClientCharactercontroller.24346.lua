
local PlayerModule = require(Workspace.System.Class.ccPlayer)
local WeaponList = {Script.SnowBall , Script.Icicle , Script.SnowCrystal}



g_Player = {}





--! ------------------------------  ------------------------------
local function InitPlayer(playerID)

    local info = PlayerModule.new(playerID, Toybox.Bullet:GetChildList())
    --table.insert(g_PlayerList, info)
    
    g_Player = info
end
Game:ConnectEventFunction("InitPlayer_sToc", InitPlayer)







local function HitProcess(playerID)
    
end
Game:ConnectEventFunction("HitProcess_sToc", HitProcess)


