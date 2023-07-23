
GameManager = Script.Parent

local DamageModule = require(ScriptModule.DefaultModules.DamageManager)
local Utility = require(ScriptModule.DefaultModules.Utility)

--전역
local DEF_READY_PLAYER = Script.ReadyPlayerCnt

local RewardGroup = Workspace.World.Reward




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
function GameManager:HitCharacter(player, targetID, damage)
    local playerID = player:GetPlayerID()
    local hitCharacter = Game:GetPlayerCharacter(targetID)
    
    Game:SendEventToClient(targetID, "HitCharacterCamera_sToc", damage)
    
    
    --캐릭터 체력 처리
    local IsAlive = DamageModule:ApplyDamage(hitCharacter, damage)--g_BulletList[bullet_index].BulletDamage)
    Game:BroadcastEvent("SetHitCharacterHP_cTos",playerID, targetID, IsAlive, hitCharacter.HP)
end
Game:ConnectEventFunction("HitCharacter_cTos", function(player, targetID, damage) GameManager:HitCharacter(player, targetID, damage) end)



function GameManager:HitCharacter_Rolling(playerID, obj)
    local player = Game:GetPlayer(playerID)
    local pos = obj.Location
    
    for i = 1 , #g_InGamePlayList do
        local temp_pos = g_InGamePlayList[i]:GetCharacter().Location
        --local dist = pos:Distance(temp_pos)
        local dist = Utility:VecDistance(pos, temp_pos)
        if dist <= g_BulletList[3].HitScale then
            local targetID = g_InGamePlayList[i]:GetPlayerID()
            local hitCharacter = g_InGamePlayList[i]:GetCharacter()
            Game:SendEventToClient(targetID, "HitCharacterCamera_sToc", 3)
            
            --캐릭터 체력 처리
            local IsAlive = DamageModule:ApplyDamage(hitCharacter, g_BulletList[3].BulletDamage)
            Game:BroadcastEvent("SetHitCharacterHP_cTos",playerID, targetID, IsAlive, hitCharacter.HP)
        end
    end
    
    player.SnowBallRolling:DisActive()

end






--!---------------------------- 리워드 상태 ------------------------------
local temp_kill = 1
local temp_freeze = 1
local temp_tornado = 1

function LocatePlayer_Reward(index)
    local place = RewardGroup.PlayerPlace:GetChildList()
    local pos = place[4].Location
    
    if g_InGamePlayList[index] >= temp_kill then
        pos = place[1].Location
    elseif g_InGamePlayList[index] >= temp_freeze then
        pos = place[2].Location
    elseif g_InGamePlayList[index] >= temp_tornado then
        pos = place[3].Location
    end
    
    
    g_InGamePlayList[index] = pos
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












