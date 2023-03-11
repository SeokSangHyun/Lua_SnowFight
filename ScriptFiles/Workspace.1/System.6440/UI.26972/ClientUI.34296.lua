
UIRoot = Workspace.UI.MainUI

--UI
local AskPopup = Workspace.UI.Popup.F_AskPopupPanel
local ListPopup = Workspace.UI.Popup.F_ListPopupPanel



--!---------------------------- 버튼 입력 처리 ------------------------------
--# 목적 : 
local function SnowBallButtonDownEvent(self)
    g_Player:ActionInput(1)
    CheckRollingStart()
    Toggle_RollingKey(true)
end
BulletButtonList[1].OnUpEvent:Connect(SnowBallButtonDownEvent)

--# 눈덩이 
local function SnowBallButtonUpEvent(self)
    --g_Player:SetWeaponIndex(1)
    Toggle_RollingKey(false)
end
BulletButtonList[1].OnUpEvent:Connect(SnowBallButtonDownEvent)


--# 목적 : 
local function IcicleButtonEvent(self)
    g_Player:ActionInput(2)
end
BulletButtonList[2].OnUpEvent:Connect(IcicleButtonEvent)


--# 목적 : 
local function SnowCrystalButtonEvent(self)
    g_Player:ActionInput(3)
end
BulletButtonList[3].OnUpEvent:Connect(SnowCrystalButtonEvent)




--!---------------------------- UI 처리 ------------------------------
--# 목적 : ㅁㄴㅇㄻㄴ
function Update_InformUI()
    local toy = Root_Infomation.Model.BellGroup
    local clock = math.floor(Game.GameTime * 10) /10
    toy.SurfaceUI_Condition.Text:SetText(clock)
end



--# 목적 : 공격 버튼 UI
local function SnowBall_UIUpdate(num)
    local toyRoot = Toybox.Bullet:GetChildList()
    for i=1, #toyRoot do
        if i == num then
            local remaincnt = SnowBallButton.Img_TextBackground.T_Count
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





