
CharacterUtil = Script.Parent




--! ------------------------------ 조작 키 변경 ------------------------------
function CharacterUtil:MontionChange(player, strChangeInput)
    local playerID = player:GetPlayerID()
    CharacterUtil:SendEventToClient(playerID, "MontionChange", strChangeInput)
end










