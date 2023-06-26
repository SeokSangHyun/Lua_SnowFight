
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
    local IsAlive = DamageModule:ApplyDamage(hitCharacter, g_BulletList[bullet_index].BulletDamage)
    Game:BroadcastEvent("SetCharacterHP_cTos",playerID, targetID, IsAlive, hitCharacter.HP)
end
Game:ConnectEventFunction("HitCharacter_cTos", HitCharacter)



function HitCharacter_Rolling(playerID, obj)
    local pos = obj.Location
    
    for i = 1 , #g_InGamePlayList do
        local temp_pos = g_InGamePlayList[i]:GetCharacter().Location
        --local dist = pos:Distance(temp_pos)
        local dist = Utility:VecDistance(pos, temp_pos)
        if dist <= g_BulletList[4].HitScale then
            local targetID = g_InGamePlayList[i]:GetPlayerID()
            local hitCharacter = g_InGamePlayList[i]:GetCharacter()
            Game:SendEventToClient(targetID, "HitCharacterCamera_sToc", 4)
            
            --캐릭터 체력 처리
            local IsAlive = DamageModule:ApplyDamage(hitCharacter, g_BulletList[4].BulletDamage)
            Game:BroadcastEvent("SetCharacterHP_cTos",playerID, targetID, IsAlive, hitCharacter.HP)
        end
    end
end





--!---------------------------- 리워드 상태 ------------------------------
local RewardGroup = Script.reward
function LocatePlayer_Reward()
    local Score1 = 0    local list_Score1 = {}
    local Score2 = 0    local list_Score2 = {}
    local Score3 = 0    local list_Score3 = {}
    local list_other = {}
     
    local place = RewardGroup.PlayerPlace:GetChildList()
     

    for i = 1 , #g_InGamePlayList do
        if Score1 < g_InGamePlayList[i].GamePoint then
            Score3 = Score2
            Score2 = Score1
            Score1 = GamePoint
        elseif Score2 < g_InGamePlayList[i].GamePoint then
            Score3 = Score2
            Score2 = GamePoint
        elseif Score3 < g_InGamePlayList[i].GamePoint then
            Score3 = GamePoint
        end
    end
     
     
    for i = 1 , #g_InGamePlayList do
        if Score1 >= g_InGamePlayList[i].GamePoint then
            g_InGamePlayList[i]:GetCharacter().Location = place[1].Location
            table.insert(list_Score1, g_InGamePlayList[i])
        elseif Score2 >= g_InGamePlayList[i].GamePoint then
            g_InGamePlayList[i]:GetCharacter().Location = place[2].Location
            table.insert(list_Score2, g_InGamePlayList[i])
        elseif Score3 >= g_InGamePlayList[i].GamePoint then
            g_InGamePlayList[i]:GetCharacter().Location = place[3].Location
            table.insert(list_Score3, g_InGamePlayList[i])
        else
            g_InGamePlayList[i]:GetCharacter().Location = place[4].Location
            table.insert(list_other, g_InGamePlayList[i])
        end
    end
end


local ReturnGroup = Workspace.SpawnPoint
function LocatePlayer_StartPoint()
    for i = 1 , #g_InGamePlayList do
        g_InGamePlayList[i]:GetCharacter().Location = ReturnGroup.Location
    end
end



--!---------------------------- 사망처리 ------------------------------
function FrozingCharacter(player)
    CreateDeathStone(player)
    
    local playerID = player:GetPlayerID()
    Game:SendEventToClient(playerID, "FrozingCharacter_sToc")
end


function FrozingBroken(player)
    local playerID = player:GetPlayerID()
    ActDeathStone(player)
    --Game:BroadcastEvent("FrozingCharacter_sToc", playerID)
end
Game:ConnectEventFunction("FrozingBroken_cTos", FrozingBroken)












