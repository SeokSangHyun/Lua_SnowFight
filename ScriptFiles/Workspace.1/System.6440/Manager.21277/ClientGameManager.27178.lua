

g_ConnectGate = nil
Root_Infomation = Workspace.System.InformSystem


local IsActionKey = false

function SetActionKey(act)    IsActionKey = act;    end;
function GetActionKey()    return IsActionKey;    end;




--!----------------------------  ------------------------------
---# 시스템 콜백 함수 처리
--? 유저 스폰되었을 때 처리
local function SpawnCharacter(character)
    local HPBar = HUD.MainUI_Surface
    local ui = character:AddPlayerHUD("HPBar", HPBar, Enum.UIDisplayType.Billboard) --캐릭터에 HUD를 추가하고 이름으로 등록해요.
    ui.Visible = true
end
Game.OnSpawnCharacter:Connect(SpawnCharacter)


local function ChangeReplicateValue(self, value) -- value : 변화한 값
    wait(1)
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
--[[
local function BulletFire(playerID, index_bullet, forX, forY, forZ)
    
    g_Player:Fire(playerID, index_bullet, forX, forY, forZ)
end
Game:ConnectEventFunction("BulletFire_sToc", BulletFire)
]]--



-- 롤링
local function SnowBallRooling(playerID, size)
    --크기를 기우는 로직
end
Game:ConnectEventFunction("SnowBallRooling_sToc", SnowBallRooling)











--!---------------------------- 카메라 효과 ------------------------------
local function HitCharacterCamera(bullet_index)
    local index = math.floor(bullet_index)
    Camera:PlayCameraShake(g_BulletList[index].ShakeTime, g_BulletList[index].ShakeScale)
    
    print(index)
end
Game:ConnectEventFunction("HitCharacterCamera_sToc", HitCharacterCamera)




--!---------------------------- Update Event ------------------------------
--[[
local function MainUpdate(updateTime)
    if GetIsRolling() then
        
    end
end
Game.OnUpdateEvent:Connect(MainUpdate)
]]--






