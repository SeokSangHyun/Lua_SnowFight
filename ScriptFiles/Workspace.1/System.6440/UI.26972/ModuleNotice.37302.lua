

--! 게임 플레이 시 LogSystem
--# 안에 있는 프로퍼티들은 
--? 내용
--    오브젝트래퍼런스, 타입을 설정함


c_Log = {}
c_Log.__index = c_Log


function c_Log.new(frame, slot)
    local t = setmetatable({}, c_Log)
    
    t.TargetUI = frame
    t.Slot = Game:CreateUIWidget(slot)
    t.Slot.Visible = false

    t.StartTime = 0
    t.PlayTime = 0
    
    return t
end

--!---------------------------- 설정 ------------------------------
--# 목적 : 
function c_Log:RegisterLog(log_type, strGivceUserName, strReceiveUserName )
    local newwidget = self.Slot
    newwidget.Left.strName:SetText(strGivceUserName)
    newwidget.Right.strName:SetText(strReceiveUserName)
    newwidget.Visible = true

    self.TargetUI:AddChildUIWidget(newwidget)
    self.Slot = newwidget

--#region
    self.StartTime = time()

end



function c_Log:UpdateLog()
    self.PlayTime = time() - self.StartTime
end


function c_Log:CloseLog()
    self.Slot.Opacity = 0.05
    

    local ui = self.Slot.Size
    ui.Y= ui.Y- 5
    self.Slot.Size = ui

    if ui.Y <= 0 then
        return true
    end

    return false
end


function c_Log:DeleteLog()
    self.Slot:Delete()
end





return c_Log;






