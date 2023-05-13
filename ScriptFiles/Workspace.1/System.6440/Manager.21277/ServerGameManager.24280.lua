
--전역
local DEF_READY_PLAYER = Script.ReadyPlayerCnt


g_listAllPlayer = {}


-- 대기 열
g_ConnectGate = {}
for i = 1 , #GameRegistChair do
    table.insert(g_ConnectGate, {})
end



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

    Game:SendEventToClient(targetID, "HitCharacterCamera_sToc", bullet_index)
end
Game:ConnectEventFunction("HitCharacter_cTos", HitCharacter)










