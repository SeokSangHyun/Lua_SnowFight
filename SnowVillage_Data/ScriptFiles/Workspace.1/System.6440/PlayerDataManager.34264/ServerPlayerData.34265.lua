
PlayerData = Script

--! ------------------------------ <> ------------------------------
g_ReadyPlayerList = {}            -- 준비하고 있는 플레이어 리스트
g_InGamePlayList = {}             -- 게임을 진입하고 플레이하는 플레이어 리스트





--! ------------------------------ <Player State> ------------------------------
--# -----목적 : 플레이어의 상태
--! (1 None = 기본 상태. 로비)
--! (2 WaitReady = 참가 등록은 완료. 게임 시작 전)
--! (5 InGame = 게임 시작. 플레이중)
--! (10 Death = 사망 처리)
function CheckPlayerState(playerID, strState)
    local player = Game:GetPlayer(playerID)

    if player.PlayState == 2 or strState == "WaitReady" then
        return true
    else
        return false
    end
end



function PlayerData:SetPlayerState(player, strState)
    local playerID = player:GetPlayerID()

    if strState == "WaitReady" then
        player.PlayState = 2
    elseif strState == "InGame" then
        player.PlayState = 5
    elseif strState == "Death" then
        player.PlayState = 10
    else
        player.PlayState = 1
    end
    
    
    Game:SendEventToClient(playerID, "SetPlayerState", strState)
end
Game:ConnectEventFunction("SetPlayerState", function(player, strState)   PlayerData:SetPlayerState(player, strState)    end)



function StateAction(playerID)
    local player = Game:GetPlayer(playerID)
    local character= Game:GetPlayerCharacter(playerID)
    PlayerControl:CharacterStateChange( player, "Stand" )
    

    if player.PlayState == 2 then
        while player.PlayState == 2 do
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










--! ------------------------------ ReadyList ------------------------------
--# ----- 목적 : ReadyList 초기화
function ResetReadyPlayerList()
    g_ReadyPlayerList = {}
end


function AddReadyPlayerList(player)
    table.insert(g_ReadyPlayerList, player)
end


--# ----- 목적 : 로비 -> 레디 상태로 변할 때 아직 
function DeleteReadyPlayer()
    for i = 1, #g_ReadyPlayerList do
        table.insert(g_InGamePlayList, g_ReadyPlayerList[i])
        --RegistSpawnList(g_ReadyPlayerList[i]:GetPlayerID())
    end
    
    g_ReadyPlayerList = {}
end






--! ------------------------------ GameList ------------------------------
function ResetInGamePlayerList()
    g_InGamePlayList = {}
    
    local allPlayer = Game:GetAllPlayer()
    for i = 1, #allPlayer do
        PlayerData:SetPlayerState(allPlayer[i], "None")
    end
end



function AddInGamePlayerList(player)
    PlayerData:SetPlayerState(player, "InGame")
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





--! ------------------------------ List 공통 기능 ------------------------------
--# ----- 목적 :게임 시작할 때 준비된 플레이어(g_ReadyPlayerList)를 플레이 리스트(g_InGamePlayList)로 옮기는 로직
function GameStartPlayerList()
    for i = 1, #g_ReadyPlayerList do
       AddDeathStone(g_ReadyPlayerList[i])
       AddInGamePlayerList(g_ReadyPlayerList[i])
       local character = g_ReadyPlayerList[i]:GetCharacter()
       character:SetMaxSpeed(DEF_DEFAULT_SPEED)
       --AddDeathStone(g_ReadyPlayerList[i])
    end
    
    ResetReadyPlayerList()
end









