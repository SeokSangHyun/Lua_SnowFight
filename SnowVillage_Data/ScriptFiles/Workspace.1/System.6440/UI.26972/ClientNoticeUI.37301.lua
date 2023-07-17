
--local PlayerModule = require(Script.ModuleNotice)


NoticeSystem = Script
local Log_list = {}
local LogCor = nil
local noticeui = UIRoot.MainUI.F_NoticePanel


--! ------------------------------  ------------------------------
function NoticeSystem:AddNotice(strText, frame_time)
    table.insert(Log_list, {strText, frame_time})
end
Game:ConnectEventFunction("AddNotice_sToc", function(strText, frame_time)  NoticeSystem:AddNotice(strText, frame_time) end)



--! ------------------------------ 로그 시스템 동작 ------------------------------
function NoticeSystem:LogUpdate()
    local FRAME = 0.05

    if LogCor == nil then
        LogCor = coroutine.create(function()
            local list = {}
            local WaitTime = 0
            local op = 1
        
            while true do
                if #Log_list > 0 or #list > 0then
            
                if #list <= 0 then
                    WaitTime = 0
                
                    table.insert(list, Log_list[1])
                    table.remove(Log_list, 1)
                    
                    noticeui.Contents:SetText(list[1][1])
                    noticeui.Visible = true
                    noticeui.Opacity = 1
                    op = 1
                else
                    if WaitTime / list[1][2] > 0.8 then
                        op = op - FRAME
                        noticeui.Opacity = op
                    end
                
                
                
                    WaitTime = WaitTime + FRAME
                    if WaitTime > list[1][2] then
                        list = {}
                        noticeui.Visible = false
                    end
                end
                end
                
                
                wait(FRAME)
                
            end
        end)

        coroutine.resume(LogCor)
    end
end
NoticeSystem:LogUpdate()










