








function CharacterMoveToLocation(player, targetPos)
    local playerID = player:GetPlayerID()
    local character = player:GetCharacter()
    character.Location = targetPos
    
    
    --
    local readysit = nil
    for i = 1 , #g_ConnectGate do
        if g_ConnectGate[i] == playerID then
            readysit = GameRegistChair[i]
            break
        end
    end
    
    readysit.WaitPos:AttachCharacter(character, Enum.AttachPoint.Top)
end
Game:ConnectEventFunction("CharacterMoveToLocation", CharacterMoveToLocation)


--Game:SendEventToServer("CharacterMoveToLocation")

function CharacterOutToLocation(player)
    local playerID = player:GetPlayerID()
    local character = player:GetCharacter()
    local outPos = Vector.new(0,0,0)

    local readysit = nil
    for i = 1 , #g_ConnectGate do
        if g_ConnectGate[i] == playerID then
            g_ConnectGate[i] = 0
            readysit = GameRegistChair[i]
            break
        end
    end
    
    --outPos = readysit.WaitPos.Location + Vector.new(-150, 0, 200)
    readysit.WaitPos:DetachAllCharacter(Vector.new(-300, 0, 50))
end
Game:ConnectEventFunction("CharacterOutToLocation", CharacterOutToLocation)



