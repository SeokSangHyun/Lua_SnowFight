
local ThrowModule = require(Workspace.System.Class.MClientThrowWeapon)
local RollingModule = require(Workspace.System.Class.MClientRollingWeapon)
local StormModule = require(Workspace.System.Class.MClientStormWeapon)



DEF_MAP_CENTER = Vector.new(Script.MapSize.Location.X, Script.MapSize.Location.Y, 0)
DEF_MAP_SIZE = Vector.new(Script.MapSize.Scale.X*100, Script.MapSize.Scale.Y*100, 0)




--! ------------------------------ 전역변수 ------------------------------
GameRegistChair = Workspace.World.Lobby.Trigger.RegistChair:GetChildList()
g_BulletList = Toybox.Bullet:GetChildList()
g_Phase = Workspace.System.Phase


--* UI 컴포넌트
UIRoot = Workspace.UI
RollingUI = UIRoot.MainUI.F_RollingGuage
BulletButtonList = UIRoot.MainUI.BulletHUD


--* Toy Object 변수
local toylist = Workspace.System.ToyList
Root_Infomation = toylist.BellGroup






--! ------------------------------ 상수형 ------------------------------
DEF_MAX_BulletCount = 1000






--! ------------------------------ 초기화 ------------------------------
--! PlayState .. 1=None  ,  2=WaitReady  ,  5=InGame  ,  10=Death
function InitPlayerData(player)
    player.PlayState = 0

    local bullets = Toybox.Bullet:GetChildList()
    local ToyList = Workspace.System.ToyList
    
    player.SnowBall = ThrowModule.new(bullets[1])
    player.Icicle = ThrowModule.new(bullets[2])
    player.Crystal = StormModule.new(ToyList.Storm.SnowStorm)
    player.SnowBallRolling = RollingModule.new(bullets[3])
    
    player.BulletIndex = 0
    
    
end
InitPlayerData( LocalPlayer:GetRemotePlayer() )

