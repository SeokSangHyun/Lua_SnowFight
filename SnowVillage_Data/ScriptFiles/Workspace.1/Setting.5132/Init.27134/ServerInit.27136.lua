
local ThrowModule = require(Workspace.System.Class.MServerThrowWeapon)
local RollingModule = require(Workspace.System.Class.MServerRollingWeapon)
local StormModule = require(Workspace.System.Class.MServerStormWeapon)




DEF_MAP_CENTER = Vector.new(Script.MapSize.Location.X, Script.MapSize.Location.Y, 0)
DEF_MAP_SIZE = Vector.new(Script.MapSize.Scale.X*100, Script.MapSize.Scale.Y*100, 0)




--! ------------------------------ 전역변수 ------------------------------
GameRegistChair = Workspace.World.Lobby.Trigger.RegistChair:GetChildList()
g_BulletList = Toybox.Bullet:GetChildList()
g_Phase = Workspace.System.Phase


--Toybox.Bullet:GetChildList()[4].HitCollider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Block)





--! ------------------------------ 상수형 ------------------------------
DEF_MAX_BulletCount = 1000

DEF_SLEIGH_SPEED = 1200
DEF_DEFAULT_SPEED = 650
DEF_SLOW_SPEED = 300




--! ------------------------------ 초기화 ------------------------------
--! PlayState .. 1=None  ,  2=WaitReady  ,  5=InGame  ,  10=Death
function InitPlayerData(player)
    EquipItem(player)
    
    local playerID = player:GetPlayerID()
    local bullets = Toybox.Bullet:GetChildList()
    local ToyList = Workspace.System.ToyList
    ToyList.Storm.SnowStorm.HitCollider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Ignore)
    
    player.SnowBall = ThrowModule.new(playerID, bullets[1])
    player.Icicle = ThrowModule.new(playerID, bullets[2])
    player.Crystal = StormModule.new(playerID, ToyList.Storm.SnowStorm)
    player.SnowBallRolling = RollingModule.new(playerID, bullets[3])
    
    player.BulletIndex = 0
    player.PlayState = 1
    
    
    player.KillPoint = 0
    player.FreezingPoint = 0
    player.TornadoPoint = 0
    
    player.DeathStoneIndex = 0
    player.DeathStoneCount = 5
end



