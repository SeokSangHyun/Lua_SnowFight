
g_PlayerData = {}



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

    if player.State == 2 then
        while player.State == 2 do
            character:AddForce( Vector.new(0, 0, 5*5000) )
            wait(2)
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



