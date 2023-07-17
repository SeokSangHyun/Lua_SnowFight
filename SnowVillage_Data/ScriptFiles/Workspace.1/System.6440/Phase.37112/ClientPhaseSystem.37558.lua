




--!---------------------------- 상태 별 상태 처리 ------------------------------
--# 목적 : 로비 (처음 진입 시 상태 세팅)
function Init_LobbyState(player)
    player.PlayState = 1

    Init_ReadyChairState()
end


--# 목적 : 게임 진입시 (처음 진입 시 상태 세팅)
function Init_GameState(player)
    Init_InGameChairState()
end


--# 목적 : 리워드 상태 진입시 (처음 진입 시 상태 세팅)
function Init_RewardState(player)
    CharacterUtil:MontionChange("Normal")
    --Exit_DeathStone()
end





--!---------------------------- Time ------------------------------
local function ChangeReplicateValue(self, value) -- value : 변화한 값
    Update_InformUI()
    
    Update_TimerUI(Game.GameState)
end
Game:ConnectChangeEventFunction("GameTime", ChangeReplicateValue)

