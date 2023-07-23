
PlayerControl = Script.Parent






--! ------------------------------ <> ------------------------------
function PlayerControl:SetMoveControl(player, state)
    local playerID = player:GetPlayerID()
    PlayerControl:SendEventToClient(playerID, "SetMoveControl", state)
end




--! ------------------------------ <캐릭터 애니메이션> ------------------------------
function PlayerControl:CharacterStateChange( player, anim )
    local playerID = player:GetPlayerID()
    Game:SendEventToClient(playerID, "CharacterStateChange", anim)
end





