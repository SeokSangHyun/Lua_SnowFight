
local ThrowModule = require(Workspace.System.Class.MServerThrowWeapon)
local RollingModule = require(Workspace.System.Class.MServerRollingWeapon)





--! ------------------------------ 전역변수 ------------------------------
GameRegistChair = Workspace.World.Lobby.Trigger.RegistChair:GetChildList()
g_BulletList = Toybox.Bullet:GetChildList()


Toybox.Bullet:GetChildList()[4].HitCollider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Block)

--! ------------------------------ 초기화 ------------------------------
function InitPlayerData(player)
    EquipItem(player)
    
    local playerID = player:GetPlayerID()
    local bullets = Toybox.Bullet:GetChildList()
    
    player.SnowBall = ThrowModule.new(playerID, bullets[1])
    player.Icicle = ThrowModule.new(playerID, bullets[2])
    player.SnowBallRolling = RollingModule.new(playerID, bullets[4])
    
    player.BulletIndex = 0
    player.State = 0
end



