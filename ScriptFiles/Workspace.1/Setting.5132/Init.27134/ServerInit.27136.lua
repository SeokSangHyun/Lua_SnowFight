
local ThrowModule = require(Workspace.System.Class.MServerThrowWeapon)
local RollingModule = require(Workspace.System.Class.MServerRollingWeapon)





--! ------------------------------ 전역변수 ------------------------------
GameRegistChair = Workspace.World.Lobby.Trigger.RegistChair:GetChildList()
g_BulletList = Toybox.Bullet:GetChildList()


Toybox.Bullet:GetChildList()[4].HitCollider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Block)





--! ------------------------------ 상수형 ------------------------------
DEF_MAX_BulletCount = 1000






--! ------------------------------ 초기화 ------------------------------
--! PlayState .. 1=None  ,  2=WaitReady  ,  5=InGame  ,  10=Death
function InitPlayerData(player)
    EquipItem(player)
    
    local playerID = player:GetPlayerID()
    local bullets = Toybox.Bullet:GetChildList()
    
    player.SnowBall = ThrowModule.new(playerID, bullets[1])
    player.Icicle = ThrowModule.new(playerID, bullets[2])
    player.SnowBallRolling = RollingModule.new(playerID, bullets[4])
    
    player.BulletIndex = 0
    player.PlayState = 1
    
    
    player.GamePoint = 0.0
    
    player.DeathStoneIndex = 0
    player.DeathStoneCount = 5
end



