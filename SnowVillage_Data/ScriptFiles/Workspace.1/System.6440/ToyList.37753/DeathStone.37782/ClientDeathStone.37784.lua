
--! ------------------------------ <> ------------------------------
--g_DeathStone = {}



--! ------------------------------ <DeathStone> ------------------------------
--# -----요약 : 
--[[
function Init_DeathStone(playerID)
    local obj = Game:CreateObject(Toybox.DeathStone, Vector.new(0,0,0))
    table.insert(g_DeathStone, {playerID, obj})
end
Game:ConnectEventFunction("Init_DeathStone_sToc", Init_DeathStone)
]]--



--# -----요약 : 
--[[
function Exit_DeathStone()
    for i = 1 , #g_DeathStone do
        Game:DeleteObject(g_DeathStone[i][2])
    end
    
    g_DeathStone = {}
end
]]--


