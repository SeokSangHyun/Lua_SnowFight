
--! ------------------------------  ------------------------------
local PlayerModule = require(Workspace.System.KillLog.ModuleLogs)

g_WarLog = {}


local LogCor = nil


--! ------------------------------  ------------------------------
function AddWarLog(log_type, strGivceUserName, strReceiveUserName )
    local parent = Workspace.UI.MainUI.F_WarLog.LogBox
    local widget = Workspace.UI.MainUI.F_WarLog.LogBox.F_OneAction
    local prep = PlayerModule.new(parent, widget)
    prep:RegisterLog(log_type, strGivceUserName, strReceiveUserName )

    table.insert( g_WarLog, prep )
end




--! ------------------------------ 로그 시스템 동작 ------------------------------
function LogUpdate()
    local StartTime = time()
    local SlotMaxTime = 5
    local WaitTime = 0
    
    local delete = {}

    if LogCor == nil then
        LogCor = coroutine.create(function()
            while true do
                delete = {}

                for i = 1 , #g_WarLog do
                    --삭제 처리
                    if g_WarLog[i].PlayTime >= SlotMaxTime then
                        if g_WarLog[i]:CloseLog() then
                            g_WarLog[i]:DeleteLog()
                            table.insert(delete, 1, i)
                        end
                    else
                        g_WarLog[i]:UpdateLog()
                    end
                end
                
                
                for j=1 , #delete do
                    table.remove(g_WarLog, delete[j])
                end
                

                wait(0.05)
            end
        end)

        coroutine.resume(LogCor)
    end
end
LogUpdate()




--! ------------------------------  ------------------------------


local cnt = 1
while true do
    AddWarLog("kill", "나", "너"..cnt)    cnt = cnt + 1
    wait(0.5)
    
    AddWarLog("kill", "나", "너"..cnt)    cnt = cnt + 1
    wait(0.5)
    
    
    wait(2)
end



