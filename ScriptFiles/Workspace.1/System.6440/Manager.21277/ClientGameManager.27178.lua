

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
--아이템 발사 전 처리
local function BulletPreFire(playerID, index_bullet, forX, forY, forZ)
    
end
Game:ConnectEventFunction("BulletPreFire_sToc", BulletPreFire)


--GetCameraForward : 카메라가 바라보는 방향
local function BulletFire(playerID, index_bullet, forX, forY, forZ)
    
    g_Player:Fire(playerID, index_bullet, forX, forY, forZ)
end
Game:ConnectEventFunction("BulletFire_sToc", BulletFire)



-- 롤링
local function SnowBallRooling(playerID, size)
    --크기를 기우는 로직
end
Game:ConnectEventFunction("SnowBallRooling_sToc", SnowBallRooling)








