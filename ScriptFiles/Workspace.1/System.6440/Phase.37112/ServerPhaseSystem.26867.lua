
--! ------------------------------ 변수 선언 ------------------------------
--# 로비->인게임 상태로 전이될 때
local ReadyMaxCount = #GameRegistChair
local ReadySitMinCount= 5

local ReadySitCount = 0
local ReadySpawnCount = 0

--# 시간 관련 변수
local limittime = 0
local startTime = 0



--
g_ReadyPlayerList = {}            -- 준비하고 있는 플레이어 리스트
g_InGamePlayList = {}             -- 게임을 진입하고 플레이하는 플레이어 리스트




--! ------------------------------ Phase 공통 기능 ------------------------------
--# 페이즈 별 시간 초기화
function InitTime(phase)
    if phase == "Lobby" then
        limittime = Script.LobbyTime
    elseif phase == "Ready" then
        limittime = Script.ReadyTime
    elseif phase == "InGame" then
        limittime = Script.InGameTime
    elseif phase == "Reward" then
        limittime = Script.RewardTime
    end

    Game.GameState = phase
    startTime = time()
    Game.GameTime = 0
end


--# 페이즈 변경 확인
function ClockPhaseState()
    if Game.GameTime > limittime then
        g_sPhase:NextPhase()
    end
end


--# 시간 계산
function ClockTime()
    Game.GameTime = time() - startTime
end




--! ------------------------------ 로비 준비 확인 ------------------------------
--# 목적 : 썰매 준비가 되었는지 확인
function CheckSitState()
    local time = 0

end


--# 목적 : 스폰 포인트로 옮겨 갔느지 확인
function CheckSpawnState()
    local time = 0

end





function GameStartPlayerList()
    for i = 1, #g_ReadyPlayerList do
        if g_ReadyPlayerList[i]:GetPlayerID() == playerID then
           table.remove(g_ReadyPlayerList, i)
           return true
       end
    end
end




--! ------------------------------ ReadyList ------------------------------
--# ----- 목적 : ReadyList 초기화
function ResetReadyPlayerList()
    g_ReadyPlayerList {}
end



function AddReadyPlayerList(player)
    table.insert(g_ReadyPlayerList, player)
end



function DeleteReadyPlayer()
    for i = 1, #g_ReadyPlayerList do
        table.insert(g_InGamePlayList, g_ReadyPlayerList[i])
    end
    
    g_ReadyPlayerList = {}
end






--! ------------------------------ ReadyList ------------------------------
function ResetInGamePlayerList()
    g_InGamePlayList = {}
end



function AddInGamePlayerList(player)
    table.insert(g_InGamePlayList, player)
end



function DeleteInGamePlayer(player)
    local playerID = player:GetPlayerID()

    for i = 1, #g_InGamePlayList do
        if g_InGamePlayList[i]:GetPlayerID() == playerID then
           table.remove(g_InGamePlayList, i)
           return true
       end
    end
    
    return false
end

































