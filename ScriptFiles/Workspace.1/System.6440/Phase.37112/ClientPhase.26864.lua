local PhaseModule = require(Script.Parent.ModulePhase)
local module = PhaseModule.new()

--! ------------------------------ LobbyPhase ------------------------------
--# 아무것도 아닌 기본 상태
local function EnterLobbyState()
    repeat wait(0.2) until LocalPlayer:GetRemotePlayer()

    print("Lobby")
    Init_LobbyUI()
    
    --개발 상태 처리
    Init_LobbyState(LocalPlayer:GetRemotePlayer())
end
module.LobbyPhase.EnterEvent:Connect(EnterLobbyState) --해당 Phase로 변경됐을때 호출되는 이벤트를 연결해요.



--! ------------------------------ Ready ------------------------------
--# 게임 중인 상태
local function EnterReadyState()
    print("Ready")
    --Init_GameUI()
end
module.ReadyPhase.EnterEvent:Connect(EnterReadyState)




--! ------------------------------ InGame ------------------------------
--# 게임 중인 상태
local function EnterInGameState()
    print("Game")
    Init_GameState(LocalPlayer:GetRemotePlayer())
    Init_GameUI()
end
module.InGamePhase.EnterEvent:Connect(EnterInGameState)



--! ------------------------------ Reward ------------------------------
--# 결과 상태
local function EnterRewardState()
    print("Reward")
    Init_RewardUI()
    Init_RewardState(LocalPlayer:GetRemotePlayer())
    
end
module.ResultPhase.EnterEvent:Connect(EnterRewardState)





--! ------------------------------ Phase Change------------------------------
--# 스크립트 제일 아래에 상태가 바뀔때마다 관련된 Phase 함수가 호출될 수 있도록 연결해요.
local function ChangedPhase(self, value)
    module:ChangePhase(Game.GameState)
end
Game:ConnectChangeEventFunction("GameState", ChangedPhase)











