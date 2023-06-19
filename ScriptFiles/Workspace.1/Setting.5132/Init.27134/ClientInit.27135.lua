
local ThrowModule = require(Workspace.System.Class.MClientThrowWeapon)
local RollingModule = require(Workspace.System.Class.MClientRollingWeapon)





--! ------------------------------ 전역변수 ------------------------------
GameRegistChair = Workspace.World.Lobby.Trigger.RegistChair:GetChildList()
g_BulletList = Toybox.Bullet:GetChildList()


--* UI 컴포넌트
UIRoot = Workspace.UI
RollingUI = UIRoot.MainUI.F_RollingGuage
BulletButtonList = UIRoot.MainUI.BulletHUD





--! ------------------------------ 상수형 ------------------------------
DEF_MAX_BulletCount = 1000






--! ------------------------------ 초기화 ------------------------------
function InitPlayerData(player)
    local bullets = Toybox.Bullet:GetChildList()
    
    player.SnowBall = ThrowModule.new(bullets[1])
    player.Icicle = ThrowModule.new(bullets[2])
    player.SnowBallRolling = RollingModule.new(bullets[4])
    
    player.BulletIndex = 0
    
    
end
InitPlayerData( LocalPlayer:GetRemotePlayer() )

