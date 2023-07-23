

--* UI 관련 변수
local RollingUI = UIRoot.MainUI.F_RollingGuage




--!---------------------------- Widget 변경 ------------------------------
--# 목적 : 
function BulletCountUpdate(index, count)
    local ch = BulletButtonList:GetChildList()
    local cnt_text = ch[#ch + 1 - index].Img_TextBackground.T_Count
    cnt_text:SetText("x" .. math.floor(count))
end
Game:ConnectEventFunction("BulletCountUpdate_sToc", BulletCountUpdate)






--!---------------------------- a ------------------------------
local WaitTime = 0.1
local MAX_ROLLINGTIME = 5
function GuageUIUpdate()
    if not GetIsRolling() then;    return;    end;

    local offset =  WaitTime / MAX_ROLLINGTIME
    local Percent = RollingUI.ProgressBar:GetPercent()
    
    
    Percent = Percent + offset


    if Percent >= 1 then
        RollingThrow()
        RollingUI.ProgressBar:SetPercent(1)
        return
    end
    RollingUI.ProgressBar:SetPercent(Percent)
    RollingScallingUp(WaitTime)

    Game:AddTimeEvent("cGuageUIUpdate", WaitTime, GuageUIUpdate)
end



function Toggle_RollingGuage(state)
    if state then
        RollingUI.ProgressBar:SetPercent(0)
        Game:AddTimeEvent("cGuageUIUpdate", WaitTime, GuageUIUpdate)
    end

    RollingUI.Visible = state
end
Game:ConnectEventFunction("Toggle_RollingGuage_sToc", Toggle_RollingGuage)








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








