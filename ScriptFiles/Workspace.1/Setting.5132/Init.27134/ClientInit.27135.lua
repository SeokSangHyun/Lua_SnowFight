
local ThrowModule = require(Workspace.System.Class.MClientThrowWeapon)
local RollingModule = require(Workspace.System.Class.MClientRollingWeapon)





--! ------------------------------ 전역변수 ------------------------------
GameRegistChair = Workspace.World.Lobby.Trigger.RegistChair:GetChildList()
g_BulletList = Toybox.Bullet:GetChildList()


--* UI 컴포넌트
UIRoot = Workspace.UI
BulletButtonList = UIRoot.MainUI.BulletHUD





--! ------------------------------ 초기화 ------------------------------
function InitPlayerData(player)
    local bullets = Toybox.Bullet:GetChildList()
    
    player.SnowBall = ThrowModule.new(bullets[1])
    player.Icicle = ThrowModule.new(bullets[2])
    player.SnowBallRolling = ThrowModule.new(bullets[4])
    
    player.BulletIndex = 0
end
InitPlayerData( LocalPlayer:GetRemotePlayer() )

