

g_ConnectGate = nil
Root_Infomation = Workspace.System.InformSystem


local IsActionKey = false

function SetActionKey(act)    IsActionKey = act;    end;
function GetActionKey()    return IsActionKey;    end;




wait(3)
local function ChangeReplicateValue(self, value) -- value : 변화한 값
    Update_InformUI()


end
Game:ConnectChangeEventFunction("GameTime", ChangeReplicateValue)

-- Input:DeactiveGroup("DefaultInput")
-- InputSetting()

--!----------------------------  ------------------------------





--GetCameraForward : 카메라가 바라보는 방향
local function BulletFire(playerID, num, forX, forY, forZ)
    
    g_Player:Fire(playerID, num, forX, forY, forZ)
end
Game:ConnectEventFunction("BulletFire_sToc", BulletFire)


