
local Tonado = Script.Parent.SnowStorm

--! ------------------------------ <Tornado Move> ------------------------------
local function TornadoMove(player, dir)
    player.Crystal:BulletMove(dir)
end
Game:ConnectEventFunction("TornadoMove_cTos", TornadoMove)





--!---------------------------- <Tonado 초기화> ------------------------------
--# -----요약 : 토네이도 초기화 (사용 안함처리)
function Init_Tonado()
    Tonado.Location = Vector.new(0,0,10000)
    Tonado.HitCollider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Ignore)
    Tonado.Enable = true
end


--# -----요약 : 토네이도 소유권 획득
function GainOwner(player)
--[[
    Tonado.Location = Vector.new(0,0,10000)
    Tonado.HitCollider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Ignore)
    Tonado.Enable = true
    
    player.Crystal.WeaponObject:SetOwnerPlayer(nil)
]]--
    local playerID = player:GetPlayerID()
    Tonado:SetOwnerPlayer(playerID)

    player.Crystal:AddBullet()
    player.Crystal:Initialize()
    WarLog:AddWarLog("StormGain", player:GetPlayerNickName(), "")
    Game:SendEventToClient(playerID, "Toggle_StormButton_sToc", true)
    
    Tonado:SetIsTornadoON(true)
end


--# -----요약 : 토네이도 소유권 박탈
function DepOwner()
    Tonado:SetOwnerPlayer(0)
    Tonado.Location = Vector.new(0,0,10000)
    Tonado.HitCollider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Ignore)
    Tonado.Enable = false
    
    Game:SendEventToClient(playerID, "Toggle_StormButton_sToc", false)
    
    Tonado:SetIsTornadoON(false)
end


