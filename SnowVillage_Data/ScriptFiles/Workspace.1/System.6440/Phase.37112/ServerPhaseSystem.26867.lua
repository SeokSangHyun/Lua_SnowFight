
--! ------------------------------ 변수 선언 ------------------------------
--# 로비->인게임 상태로 전이될 때
local ReadyMaxCount = #GameRegistChair
local ReadySitMinCount= 5

local ReadySitCount = 0
local ReadySpawnCount = 0

--# 시간 관련 변수
local limittime = 0
local startTime = 0


--!---------------------------- 상태 별 상태 처리 ------------------------------
--# 목적 : 로비 (처음 진입 시 상태 세팅)
function Init_LobbyState()
    ResetDeathStone()
    LocatePlayer_StartPoint()
    ResetInGamePlayerList()
    
    --개발 상태 처리
    Init_ReadyChairState()
end


--# 목적 : 게임 진입시 (처음 진입 시 상태 세팅)
function Init_GameState()
    GameStartPlayerList()
    
    --개발 상태 처리
    Init_InGameChairState()
    Game:AddTimeEvent("StormItemSpawn", 10, function() StormItemSpawner:Spawn() end)
end


--# 목적 : 리워드 상태 진입시 (처음 진입 시 상태 세팅)
function Init_RewardState()
    LocatePlayer_Reward()
end





--! ------------------------------ Phase 공통 기능 ------------------------------
--# 페이즈 별 시간 초기화
function InitTime(phase)
    if phase == "Lobby" then
        limittime = Script.Parent.LobbyTime
    elseif phase == "Ready" then
        limittime = Script.Parent.ReadyTime
    elseif phase == "InGame" then
        limittime = Script.Parent.InGameTime
    elseif phase == "Result" then
        limittime = Script.Parent.RewardTime
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











































