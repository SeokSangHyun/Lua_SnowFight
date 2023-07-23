




--!---------------------------- 상태 별 상태 처리 ------------------------------
--# 목적 : 로비 (처음 진입 시 상태 세팅)
function Init_LobbyState(player)
    player.PlayState = 1

    Init_ReadyChairState()
    PlayerControl:SetCharacterControl(true)
    ChangeCamera(Workspace.MainCamera, player:GetCharacter())
    SetCharacterHP(player:GetPlayerID(), 100)
end

function InitServer_LobbyState(playerCnt)
    --g_ReadyPlayerCount = playerCnt
end
Game:ConnectEventFunction("InitServer_LobbyState", InitServer_LobbyState)




--!---------------------------- 상태 별 상태 처리 ------------------------------
--# 목적 : 게임 진입시 (처음 진입 시 상태 세팅)
function Init_GameState(player)
    Init_InGameChairState()
end

function InitServer_GameState(playerCnt)
    --g_InGamePlayCount = playerCnt
end
Game:ConnectEventFunction("InitServer_GameState", InitServer_GameState)


--!---------------------------- RewardPhase ------------------------------
--# 목적 : 리워드 상태 진입시 (처음 진입 시 상태 세팅)
function Init_RewardState(player)
    
end



function InitServer_RewardState()
    local RewardPlace = Workspace.World.Reward

    CharacterUtil:MontionChange("Normal")
    ChangeCamera(RewardPlace.Camera, nil)
    PlayerControl:SetCharacterControl(false)
end
Game:ConnectEventFunction("InitServer_RewardState", InitServer_RewardState)






--!---------------------------- Time ------------------------------
local function ChangeReplicateValue(self, value) -- value : 변화한 값
    Update_InformUI()
    
    Update_TimerUI(Game.GameState)
end
Game:ConnectChangeEventFunction("GameTime", ChangeReplicateValue)

