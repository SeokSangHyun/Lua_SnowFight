
g_PlayerData = {}

g_ReadyPlayerList = {}            -- 준비하고 있는 플레이어 리스트
g_InGamePlayList = {}             -- 게임을 진입하고 플레이하는 플레이어 리스트




--! ------------------------------ Player State ------------------------------
function CheckPlayerState(playerID, strState)
    local player = Game:GetPlayer(playerID)

    if player.State == 2 and strState == "WaitReady" then
        return true
    else
        return false
    end
end

function SetPlayerState(playerID, strState)
    local player = Game:GetPlayer(playerID)
    
    if strState == "WaitReady" then
        player.State = 2
    elseif strState == "Dead" then
        player.State = 10
    else
        player.State = 0
    end
end




function StateAction(playerID)
    local player = Game:GetPlayer(playerID)
    local character= Game:GetPlayerCharacter(playerID)
    Game:SendEventToClient(playerID, "CharacterStateChange_sToc", "Stand")
    

    if player.State == 2 then
        while player.State == 2 do
            character:AddForce( Vector.new(0, 0, 5*5000) )
            wait(1.5)
        end
    end
end





--! ------------------------------ 시스템 처리 ------------------------------
local function LeavePlayer(player)
    print("Leave " .. player.Name)
    local playerID = player:GetPlayerID()
    
    local playerdata = g_PlayerData[playerID]
    for i, v in pairs(playerdata) do
        print(i)
    end

end
--Game.OnLeavePlayer:Connect(LeavePlayer)












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







