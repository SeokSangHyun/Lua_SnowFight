
PlayerControl = Script.Parent

--! ------------------------------ <> ------------------------------
function PlayerControl:SetMoveControl(player, state)
    local playerID = player:GetPlayerID()
    PlayerControl:SendEventToClient(playerID, "SetMoveControl", state)
end










