
local PlayerModule = require(Workspace.System.Class.ccPlayer)
local WeaponList = {Script.SnowBall , Script.Icicle , Script.SnowCrystal}

local WeaponIndex = 1


g_Player = {}



--! ------------------------------  ------------------------------
function SetWeaponIndex(index); WeaponIndex = index;    end;
function GetWeaponIndex();  return WeaponIndex;    end;




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


