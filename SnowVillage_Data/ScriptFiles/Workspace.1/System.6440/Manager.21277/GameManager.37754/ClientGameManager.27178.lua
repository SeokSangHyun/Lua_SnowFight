
local IsActionKey = false



--!---------------------------- Setter/Getter ------------------------------
function SetActionKey(act)    IsActionKey = act;    end;
function GetActionKey()    return IsActionKey;    end;





--!---------------------------- <페이즈 별 처리> ------------------------------




--!----------------------------  ------------------------------
---# 시스템 콜백 함수 처리
--? 유저 스폰되었을 때 처리
local function SpawnCharacter(character)
    local HPBar = HUD.MainUI_Surface
    local ui = character:AddPlayerHUD("HPBar", HPBar, Enum.UIDisplayType.Billboard) --캐릭터에 HUD를 추가하고 이름으로 등록해요.
    ui.Visible = true
end
Game.OnSpawnCharacter:Connect(SpawnCharacter)



--!----------------------------  ------------------------------
--아이템 발사 전 처리
local function BulletPreFire(playerID, index_bullet, forX, forY, forZ)
    
end
Game:ConnectEventFunction("BulletPreFire_sToc", BulletPreFire)


--GetCameraForward : 카메라가 바라보는 방향
-- 롤링
local function SnowBallRooling(playerID, size)
    --크기를 기우는 로직
end
Game:ConnectEventFunction("SnowBallRooling_sToc", SnowBallRooling)











--!---------------------------- 카메라 효과 ------------------------------
local function HitCharacterCamera(shake_time, shake_scale)
    Camera:PlayCameraShake(shake_time, shake_scale)
end
Game:ConnectEventFunction("HitCharacterCamera_sToc", HitCharacterCamera)






--!---------------------------- 리워드 상태 ------------------------------
local ReturnGroup = Workspace.SpawnPoint
function LocatePlayer_StartPoint()
        g_InGamePlayList[i]:GetCharacter().Location = ReturnGroup.Location
end

Game:ConnectEventFunction("LocatePlayer_StartPoint", LocatePlayer_StartPoint)








--!---------------------------- 사망처리 ------------------------------
function FrozingCharacter(playerID)
--[[
    local target_character = Game:GetRemotePlayerCharacter(playerID)
    local target_player = target_character:GetPlayer()
    local pos = target_character.Location

    local froz = Toybox.DeathStone
    local obj = Game:CreateObject(froz, pos)
    target_player.DeathObj = obj
    
    
    if target_character:IsMyCharacter() then
]]--
        LocalPlayer:SetEnableMovementControl(false)
        --ChangeCamera(obj.Camera , obj)
        
        
        UIRoot.MainUI.F_Death.Visible = true
        
--    end
end
Game:ConnectEventFunction("FrozingCharacter_sToc", FrozingCharacter)





function FrozingBroken(playerID)
        LocalPlayer:SetEnableMovementControl(true)
        UIRoot.MainUI.F_Death.Visible = false
end
Game:ConnectEventFunction("FrozingBroken_sToc", FrozingBroken)






