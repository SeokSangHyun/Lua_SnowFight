
local DamageModule = require(ScriptModule.DefaultModules.DamageManager)
local Utility = require(ScriptModule.DefaultModules.Utility)

--전역
local DEF_READY_PLAYER = Script.ReadyPlayerCnt




--!---------------------------- 게임 준비 전 함수 ------------------------------
--# 목적 : 게임 시작 조건을 검사하는 부분
function CheckGameStart()
    local ready_player_cnt = 0
    for i = 1 , #g_ConnectGate do 
        if g_ConnectGate[i] > 0 then
            ready_player_cnt = ready_player_cnt + 1
        end
    end

    if ready_player_cnt >= DEF_READY_PLAYER then
        return true
    end

    return false
end






--!---------------------------- 피격 처리 ------------------------------
local function HitCharacter(player, targetID, bullet_index)
    local playerID = player:GetPlayerID()
    local hitCharacter = Game:GetPlayerCharacter(targetID)
    
    Game:SendEventToClient(targetID, "HitCharacterCamera_sToc", bullet_index)
    
    
    --캐릭터 체력 처리
    DamageModule:ApplyDamage(hitCharacter, g_BulletList[bullet_index].BulletDamage)
    Game:BroadcastEvent("SetCharacterHP_cTos",targetID, hitCharacter.HP)
end
Game:ConnectEventFunction("HitCharacter_cTos", HitCharacter)



function HitCharacter_Rolling(obj)
    local pos = obj.Location
    print("충돌은함")
    
    for i = 1 , #g_InGamePlayList do
        local temp_pos = g_InGamePlayList[i]:GetCharacter().Location
        --local dist = pos:Distance(temp_pos)
        local dist = Utility:VecDistance(pos, temp_pos)
        if dist <= g_BulletList[4].HitScale then
            local targetID = g_InGamePlayList[i]:GetPlayerID()
            local hitCharacter = g_InGamePlayList[i]:GetCharacter()
            Game:SendEventToClient(targetID, "HitCharacterCamera_sToc", 4)
            
            --캐릭터 체력 처리
            DamageModule:ApplyDamage(hitCharacter, g_BulletList[4].BulletDamage)
            Game:BroadcastEvent("SetCharacterHP_cTos",targetID, hitCharacter.HP)
        end
    end
end




















