
WarLog = Script


--! ------------------------------ <> ------------------------------
function WarLog:AddWarLog(log_type, strGivceUserName, strReceiveUserName)
    Game:BroadcastEvent("AddWarLog_sToc", log_type, strGivceUserName, strReceiveUserName)
end
--WarLog:ConnectEventFunction("AddWarLog_cTos", function(log_type, strGivceUserName, strReceiveUserName) WarLog:AddWarLog(log_type, strGivceUserName, strReceiveUserName) end)

