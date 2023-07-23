
PlayerData = Script

--! ------------------------------ <> ------------------------------
g_ReadyPlayerCount = 0            -- 준비하고 있는 플레이어 리스트
g_InGamePlayCount = 0             -- 게임을 진입하고 플레이하는 플레이어 리스트



function PlayerData:SetReadyPlayerCount(playerCnt)
    g_ReadyPlayerCount = playerCnt
end
Game:ConnectEventFunction("SetReadyPlayerCount", function(playerCnt)    PlayerData:SetReadyPlayerCount(playerCnt)    end)



function PlayerData:SetInGamePlayerCount(playerCnt)
    g_InGamePlayCount = playerCnt
end
Game:ConnectEventFunction("SetInGamePlayerCount", function(playerCnt)    PlayerData:SetInGamePlayerCount(playerCnt)    end)




function PlayerData:SetPlayerState(strState)
    local player = LocalPlayer:GetRemotePlayer()

    if strState == "WaitReady" then
        player.PlayState = 2
    elseif strState == "InGame" then
        player.PlayState = 5
    elseif strState == "Death" then
        player.PlayState = 10
    else
        player.PlayState = 1
    end
end
Game:ConnectEventFunction("SetPlayerState", function(strState)    PlayerData:SetPlayerState(strState)    end)

