


--UI
local AskPopup = Workspace.UI.Popup.F_AskPopupPanel
local ListPopup = Workspace.UI.Popup.F_ListPopupPanel





--!---------------------------- 상태 별 UI 처리 ------------------------------
--# 목적 : 로비 (처음 진입 시 UI 세팅)
function Init_LobbyUI()
    UIRoot.LobbyUI.Visible = true
    UIRoot.MainUI.Visible = false

    local ui = UIRoot.LobbyUI
    ui.F_AskPopupPanel.Visible = false
    ui.F_ListPopupPanel.Visible = false
    ui.F_NoticePanel.Visible = true
end


--# 목적 : 게임 진입시 (처음 진입 시 UI 세팅)
function Init_GameUI()
    UIRoot.LobbyUI.Visible = false
    UIRoot.MainUI.Visible = true

    local ui = UIRoot.MainUI
end


--# 목적 : 리워드 상태 진입시 (처음 진입 시 UI 세팅)
function Init_RewardUI()
    UIRoot.LobbyUI.Visible = false
    UIRoot.MainUI.Visible = false
end






--!---------------------------- 상태 별 UI 처리 ------------------------------
--# 목적 : ㅁㄴㅇㄻㄴ
function Update_InformUI()
    local toy = Root_Infomation.Model.BellGroup
    local clock = math.floor(Game.GameTime * 10) /10
    toy.SurfaceUI_Condition.Text:SetText(clock)
end



--# 목적 : 공격 버튼 UI
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




--!---------------------------- 공통 처리 ------------------------------
--# 게임 준비 등록
--? 
function Toggle_StardardPopup(state)
    AskPopup.Visible = state
end



local function ButtonEvent_StardardPopup(self)
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

    Input:SetJoystickControlVisibility(0, true)
    LocalPlayer:SetEnableMovementControl(true)
    
    g_ConnectGate = nil
end
AskPopup.NoButton.OnUpEvent:Connect(ButtonEvent_StardardPopupNo)




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
end
buttonlist[1].OnUpEvent:Connect(ButtonEvent_ReadyPopup)


local function ButtonEvent_ReadyPopup(self)
    Toggle_ListPopup(false)
    
    Game:SendEventToServer("ReadySleighAction")
    ReadySleighMoveLoop()
end
buttonlist[2].OnUpEvent:Connect(ButtonEvent_ReadyPopup)




--!---------------------------- 캐릭터 관련 UI 처리 ------------------------------
function SetCharacterHP(playerID, nowHP)
    local TargetCharacter = Game:GetRemotePlayerCharacter(playerID)
    local characterHUD = TargetCharacter:GetPlayerHUD("HPBar")
    local hpHUD = characterHUD.HPBar
    
    hpHUD:SetPercent(nowHP/100)
end
Game:ConnectEventFunction("SetCharacterHP_cTos", SetCharacterHP)




