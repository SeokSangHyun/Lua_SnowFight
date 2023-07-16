


local AskPopup = UIRoot.LobbyUI.F_AskPopupPanel
local ListPopup = UIRoot.LobbyUI.F_ListPopupPanel






--!---------------------------- 상태 별 UI 처리 ------------------------------
--# 목적 : ㅁㄴㅇㄻㄴ
function Update_InformUI()
    --SurfaceUI
    local toy = Root_Infomation
    local clock = math.floor(Game.GameTime * 10) /10
    toy.SurfaceUI_Condition.Text:SetText(clock)
end


function Update_TimerUI(state)
    
    if state == "Lobby" then
        local totla_time = g_Phase.LobbyTime
        local ui = UIRoot.LobbyUI.F_NoticePanel
        ui.Contents_Time:SetText( math.floor(totla_time - Game.GameTime) )
        
    elseif Game.GameState == "Ready" then
        local totla_time = g_Phase.ReadyTime
        local ui = UIRoot.LobbyUI.F_NoticePanel
        ui.Contents_Time:SetText( math.floor(totla_time - Game.GameTime) )
        
    elseif Game.GameState == "InGame" then
        local totla_time = g_Phase.InGameTime
        local ui1 = UIRoot.MainUI.F_NoticePanel
        local ui2 = UIRoot.MainUI.F_Timer
        ui1.Contents_Time:SetText( math.floor(totla_time - Game.GameTime) )
        ui2.Contents:SetText( math.floor(totla_time - Game.GameTime) )
        
    elseif Game.GameState == "Result" then
        local totla_time = g_Phase.RewardTime
        local ui = UIRoot.RewardUI.F_NoticePanel
        ui.Contents_Time:SetText( math.floor(totla_time - Game.GameTime) )
    end
end



--# 목적 : 공격 버튼 UI
--[[
function SnowBall_UIUpdate(num)
    local toyRoot = Toybox.Bullet:GetChildList()
    for i=#toyRoot, 3, -1 do
        if i == num then
            local remaincnt = BulletButtonList[i].Img_TextBackground.T_Count
            remaincnt:SetText("X " .. tostring(num) )
        end
    end
end
Game:ConnectEventFunction("SnowBall_UIUpdate", SnowBall_UIUpdate)
]]--







--!---------------------------- AskPopup 처리 ------------------------------
--# 게임 준비 등록
--? 
function Toggle_StardardPopup(state)
    AskPopup.Visible = state
end



local function ButtonEvent_StardardPopup(self)
    local player = LocalPlayer:GetRemotePlayer()
    player.PlayState = 2

    Toggle_StardardPopup(false)
    Toggle_ListPopup(true)
    CharacterStateChange("Sit")
    
    --CharacterMoveToLocation(GameRegistChair[2].WaitPos.Location)
    Game:SendEventToServer("CharacterMoveToLocation", g_ConnectGate.WaitPos.Location)
    
    Input:SetJoystickControlVisibility(0, true)
    LocalPlayer:SetEnableMovementControl(true)
end
AskPopup.YesButton.OnUpEvent:Connect(ButtonEvent_StardardPopup)



local function ButtonEvent_StardardPopupNo(self)
    Toggle_StardardPopup(false)
    CharacterStateChange("Stand")

    Game:SendEventToServer("ResetChair_cTos", g_ConnectGate.Index)

    Input:SetJoystickControlVisibility(0, true)
    LocalPlayer:SetEnableMovementControl(true)
    
    g_ConnectGate = nil
end
AskPopup.NoButton.OnUpEvent:Connect(ButtonEvent_StardardPopupNo)





--!---------------------------- 공격 버튼 ------------------------------
--# 게임 준비 등록 후 팝업
--? 
local buttonlist = ListPopup.ButtonList:GetChildList()
for i = 3 , #buttonlist do
    buttonlist[i].Visible = false
end

function Toggle_ListPopup(state)
    ListPopup.Visible = state
end


local function ButtonEvent_ReadyPopup(self)
    Game:SendEventToServer("CharacterOutToLocation")
    CharacterStateChange("Stand")
    
    
    Toggle_ListPopup(false)
    Game:SendEventToServer("ResetChair_cTos", g_ConnectGate.Index)
end
buttonlist[1].OnUpEvent:Connect(ButtonEvent_ReadyPopup)


local function ButtonEvent_ReadyPopup(self)
    Toggle_ListPopup(false)
    
    Game:SendEventToServer("ReadySleighAction")
    Game:SendEventToServer("ResetChair_cTos", g_ConnectGate.Index)
    
    ReadySleighMoveLoop()
end
buttonlist[2].OnUpEvent:Connect(ButtonEvent_ReadyPopup)





--# ----- 요약 : 토네이도 버튼 처리
-- 토네이도 버튼 토글
function Toggle_StormButton(state)
    UIRoot.MainUI.F_CrystalButton.Visible = state
end
Game:ConnectEventFunction("Toggle_StormButton_sToc", Toggle_StormButton)



-- 토네이도 버튼 토글
UIRoot.MainUI.F_CrystalButton.Btn_SnowCrystal.OnUpEvent:Connect(function(self)
    local player = LocalPlayer:GetRemotePlayer()
    if not player.Crystal:CheckStormMode() then
        player.Crystal:ActiveStormMode(true)
        Toggle_UI(true)
    else
        player.Crystal:ActiveStormMode(false)
        Toggle_UI(false)
    end
    
end)






--!---------------------------- 캐릭터 관련 UI 처리 ------------------------------
function SetCharacterHP(playerID, targetID, IsAlive, nowHP)
    local ShotCharacter = Game:GetRemotePlayerCharacter(playerID)
    local TargetCharacter = Game:GetRemotePlayerCharacter(targetID)
    local characterHUD = TargetCharacter:GetPlayerHUD("HPBar")
    local hpHUD = characterHUD.HPBar
    
    hpHUD:SetPercent(nowHP/100)
    if not IsAlive then
        AddWarLog("kill", ShotCharacter:GetPlayerNickName(), TargetCharacter:GetPlayerNickName())
    end
    
end
Game:ConnectEventFunction("SetCharacterHP_cTos", SetCharacterHP)




--# -----목적 : 사망시 UI 이벤트
UIRoot.MainUI.F_Death.Button.OnUpEvent:Connect(function(self)
    Game:SendEventToServer("FrozingBroken_cTos")
end)












