local PhaseModule = require(Script.Parent.ModulePhase)
g_sPhase = PhaseModule.new()

--#목적 : 동기화 되는 변수
Game:AddReplicateValue("GameState", "Lobby", Enum.ReplicateType.Changed, 0) --서버와 클라이언트간 동기화되는 값을 등록하고 초기값을 설정한뒤, 값이 변경될때마다 호출되게 해요.
Game:AddReplicateValue("GameTime", 0, Enum.ReplicateType.Changed, 0)
--Game:AddReplicateValue("GameState", "Lobby", Enum.ReplicateType.Changed, 0)


--! ------------------------------ LobbyPhase ------------------------------
--# 아무것도 아닌 기본 상태
local function EnterLobbyState()
    InitTime("Lobby")
    ResetDeathStone()
    LocatePlayer_StartPoint()
    ResetInGamePlayerList()
    
    --개발 상태 처리
    Init_ReadyChairState()
end
g_sPhase.LobbyPhase.EnterEvent:Connect(EnterLobbyState) --해당 Phase로 변경됐을때 호출되는 이벤트를 연결해요.

local function UpdateLobbyState(UpdateTime)
    ClockPhaseState()
    ClockTime()
end
g_sPhase.LobbyPhase.UpdateEvent:Connect(UpdateLobbyState)  --해당 Phase일때 매프레임마다 호출되는 이벤트를 연결해요.





--! ------------------------------ Ready ------------------------------
--# 게임 중인 상태
local function EnterReadyState()
    InitTime("Ready")
end
g_sPhase.ReadyPhase.EnterEvent:Connect(EnterReadyState)

local function UpdateReadyState(UpdateTime)
    ClockPhaseState()
    ClockTime()
end
g_sPhase.ReadyPhase.UpdateEvent:Connect(UpdateReadyState)






--! ------------------------------ InGame ------------------------------
--# 게임 중인 상태
local function EnterInGameState()
    InitTime("InGame")
    
    GameStartPlayerList()
    
    --개발 상태 처리
    Init_InGameChairState()
end
g_sPhase.InGamePhase.EnterEvent:Connect(EnterInGameState)

local function UpdateInGameState(UpdateTime)
    ClockPhaseState()
    ClockTime()
end
g_sPhase.InGamePhase.UpdateEvent:Connect(UpdateInGameState)






--! ------------------------------ Reward ------------------------------
--# 결과 상태
local function EnterRewardState()
    InitTime("Result")
    LocatePlayer_Reward()
end
g_sPhase.ResultPhase.EnterEvent:Connect(EnterRewardState)

local function UpdateRewardState(UpdateTime)
    ClockPhaseState()
    ClockTime()
end
g_sPhase.ResultPhase.UpdateEvent:Connect(UpdateRewardState)





--[[
local function ExitLobbyState()
    print("End Lobby State")
end
LobbyState.ExitEvent:Connect(ExitLobbyState) --해당 Phase가 끝날때 호출되는 이벤트를 연결해요.
]]--
