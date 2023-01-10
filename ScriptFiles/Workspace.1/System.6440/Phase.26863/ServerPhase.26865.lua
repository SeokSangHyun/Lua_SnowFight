local PhaseModule = require(Script.Parent.ModulePhase)
local module = PhaseModule.new()
Game:AddReplicateValue("GameState", "Lobby", Enum.ReplicateType.Changed, 0) --서버와 클라이언트간 동기화되는 값을 등록하고 초기값을 설정한뒤, 값이 변경될때마다 호출되게 해요.



--! ------------------------------ LobbyPhase ------------------------------
--# 아무것도 아닌 기본 상태
local function EnterLobbyState()
    Game.GameState = "Lobby"
    --print("Enter Lobby State")
end
module.LobbyPhase.EnterEvent:Connect(EnterLobbyState) --해당 Phase로 변경됐을때 호출되는 이벤트를 연결해요.

local function UpdateLobbyState(UpdateTime)
    --print("Update Lobby State")
end
module.LobbyPhase.UpdateEvent:Connect(UpdateLobbyState)  --해당 Phase일때 매프레임마다 호출되는 이벤트를 연결해요.



--! ------------------------------ InGame ------------------------------
--# 게임 중인 상태
local function EnterInGameState()
    Game.GameState = "Play"
    --print("Enter Play State")
end
module.InGamePhase.EnterEvent:Connect(EnterInGameState)

local function UpdateInGameState(UpdateTime)
    --print("Update Lobby State")
end
module.InGamePhase.UpdateEvent:Connect(UpdateInGameState)



--! ------------------------------ Reward ------------------------------
--# 결과 상태
local function EnterRewardState()
    Game.GameState = "Play"
    --print("Enter Play State")
end
module.ResultPhase.EnterEvent:Connect(EnterRewardState)

local function UpdateRewardState(UpdateTime)
    --print("Update Lobby State")
end
module.ResultPhase.UpdateEvent:Connect(UpdateRewardState)




--! ------------------------------ Phase 변경 ------------------------------
--# 상태 변경
wait(2)
module:ChangePhase("Lobby")




--[[
local function ExitLobbyState()
    print("End Lobby State")
end
LobbyState.ExitEvent:Connect(ExitLobbyState) --해당 Phase가 끝날때 호출되는 이벤트를 연결해요.
]]--
