
g_PlayerData = {}



--! ------------------------------ 스폰 변수 ------------------------------
local function Init_PlayerData(character)
    local player = character:GetPlayer()
    local playerID = player:GetPlayerID()
    
    --InitPlayer(player)

    g_PlayerData[playerID] = {["A"] = 100, ["B"] = 4, ["C"] = 7, ["D"] = 6, ["F"] = 1}
end
--Game.OnSpawnCharacter:Connect(Init_PlayerData)



local function LeavePlayer(player)
    print("Leave " .. player.Name)
    local playerID = player:GetPlayerID()
    
    local playerdata = g_PlayerData[playerID]
    for i, v in pairs(playerdata) do
        print(i)
    end

end
--Game.OnLeavePlayer:Connect(LeavePlayer)



