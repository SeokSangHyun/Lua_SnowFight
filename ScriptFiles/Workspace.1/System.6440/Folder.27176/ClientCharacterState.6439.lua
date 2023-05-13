
local CharacterSetting = Toybox.CharacterSetting





function CharacterStateChange( anim )
    local character = LocalPlayer:GetRemotePlayer():GetCharacter()
    character:ChangeAnimState(anim, 0.0001)
end




--[[
function CharacterMoveToLocation(targetPos)
    local character = LocalPlayer:GetRemotePlayer():GetCharacter()
    character.Location = targetPos
end
]]--


