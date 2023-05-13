

--* UI 관련 변수
local RollingUI = UIRoot.MainUI.F_RollingGuage



--UI
local AskPopup = Workspace.UI.Popup.F_AskPopupPanel
local ListPopup = Workspace.UI.Popup.F_ListPopupPanel




--!---------------------------- Widget 변경 ------------------------------
--# 목적 : 
local function BulletCountUpdate(index, count)
    local cnt_text = BulletButtonList[index].Img_TextBackground.T_Count
    cnt_text:SetText("x" .. count)
end
Game:ConnectEventFunction("BulletCountUpdate_sToc", BulletCountUpdate)






--!---------------------------- a ------------------------------
local WaitTime = 0.1
local MAX_ROLLINGTIME = 5
function GuageUIUpdate()
    local offset = MAX_ROLLINGTIME / WaitTime
    local Percent = RollingUI.ProgressBar:GetPercent()
    Percent = Percent + offset

    if Percent >= 1 then
        RollingUI.ProgressBar:SetPercent(1)
        return
    end
    RollingUI.ProgressBar:SetPercent(Percent)

    Game:AddTimeEvent("cGuageUIUpdate", WaitTime, GuageUIUpdate)
end


function Toggle_RollingGuage(state)
    if state then
        RollingUI.ProgressBar:SetPercent(0)
        Game:AddTimeEvent("cGuageUIUpdate", WaitTime, GuageUIUpdate)
    end

    RollingUI.Visible = state
end





--!---------------------------- 공격 버튼 처리 ------------------------------
--# 목적 : 눈덩이 굴리기
local function SnowBallButtonDownEvent(self)
    BulletThrowStart(1)
end
BulletButtonList.Btn_Snowball.OnPressEvent:Connect(SnowBallButtonDownEvent)

--# 눈덩이 
local function SnowBallButtonUpEvent(self)
    BulletThrowEnd(1)
end
BulletButtonList.Btn_Snowball.OnUpEvent:Connect(SnowBallButtonUpEvent)


--# 목적 : 
local function IcicleButtonEvent(self)
    BulletThrowEnd(2)
end
BulletButtonList.Btn_Icicle.OnUpEvent:Connect(IcicleButtonEvent)


--# 목적 : 
local function SnowCrystalButtonEvent(self)
    BulletThrowEnd(3)
end
BulletButtonList.Btn_SnowCrystal.OnUpEvent:Connect(SnowCrystalButtonEvent)




--Game:ConnectEventFunction("Toggle_RollingGuage_sToc", Toggle_RollingGuage)




