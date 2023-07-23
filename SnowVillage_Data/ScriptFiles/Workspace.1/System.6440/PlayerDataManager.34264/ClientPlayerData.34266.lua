
--! ------------------------------ <> ------------------------------
g_ReadyPlayerCount = 0            -- 준비하고 있는 플레이어 리스트
g_InGamePlayCount = 0             -- 게임을 진입하고 플레이하는 플레이어 리스트



function SetReadyPlayerCount(playerCnt)
    g_ReadyPlayerCount = playerCnt
end
Game:ConnectEventFunction("SetReadyPlayerCount", SetReadyPlayerCount)



function SetInGamePlayerCount(playerCnt)
    g_InGamePlayCount = playerCnt
end
Game:ConnectEventFunction("SetInGamePlayerCount", SetInGamePlayerCount)


