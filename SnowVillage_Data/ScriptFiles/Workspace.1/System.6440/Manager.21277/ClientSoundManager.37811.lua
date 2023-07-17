
SoundManager = Script
local SoundList = Workspace.Sound--:GetChildList()



--! ------------------------------ <> ------------------------------
--# -----요약 : 
function SoundManager:InitSound(phase)

    if phase == "Lobby" then
        SoundList.RewardBGM:Stop()
        SoundList.LobbyBGM:Play()
    elseif phase == "Ready" then
        ;
    elseif phase == "InGame" then
        SoundList.LobbyBGM:Stop()
        SoundList.InGameBGM:Play()
    elseif phase == "Result" then
        SoundList.InGameBGM:Stop()
        SoundList.RewardBGM:Play()
    end

end




