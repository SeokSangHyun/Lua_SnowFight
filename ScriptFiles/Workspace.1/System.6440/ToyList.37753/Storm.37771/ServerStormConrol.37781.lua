







--! ------------------------------ 스톰 기능처리 ------------------------------
local function TornadoMove(player, dir)
    player.Crystal:BulletMove(dir)
end
Game:ConnectEventFunction("TornadoMove_cTos", TornadoMove)



