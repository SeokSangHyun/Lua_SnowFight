
PhaseModule= {}
PhaseModule.__index = PhaseModule


function PhaseModule.new()
    local t = setmetatable({}, PhaseModule)
    
    t.LobbyPhase = Game:AddPhase("Lobby")
    t.ReadyPhase = Game:AddPhase("Ready")
    t.InGamePhase = Game:AddPhase("InGame")
    t.ResultPhase = Game:AddPhase("Result")

    return t
end


--! --------------- Client/Server 공통 스크립트에서 사용
--# Server : 인자 String
--# Client : 인자 Game.Phase 형태
function PhaseModule:ChangePhase(PhaseName)
    Game.GameState = PhaseName
    Game:ChangePhaseByName(PhaseName)
end

--! ---------- ServerPhase 스크립트에서 사용
function PhaseModule:NextPhase()
    local phase = Game:GetCurPhase()

    if phase.Name == "Result" then
        Game:ChangePhaseByName("Lobby")
    elseif phase.Name == "Lobby" and (#g_ReadyPlayerList + #g_InGamePlayList) < GameManager:GetMinPlayer() then
        Game:ChangePhaseByName("Lobby")
    else
        Game:ChangeToNextPhase()
    end
end


--! ----- ClientPhase 스크립트에서 사용






return PhaseModule


