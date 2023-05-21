

local IsRollingAct = false  --롤링 시스템이 완성 됬는지 확인
--* 상태 확인 변수
local IsRolling = false                     -- 굴리기 중인지 확인
local IsSnowBall = false                    -- 던지기 했는지 확인

g_PlayerList = {}

--# 초기화
--! ------------------------------ Getter/Setter ------------------------------
local function RplicateMoveForward(player, state)
    Game.CtrlMoveForward = state
end
Game:ConnectEventFunction("RplicateMoveForward", RplicateMoveForward)



local function RplicateMoveRight(player, state)
    Game.CtrlMoveRight = state
end
Game:ConnectEventFunction("RplicateMoveRight", RplicateMoveRight)



local function SetIsRollingAct(player, state)
    IsRollingAct = state
end
Game:ConnectEventFunction("SetIsRollingAct", SetIsRollingAct)




function GetIsRolling()
    return IsRolling
end

function SetIsRolling(state)
    IsRolling = state
end










--!---------------------------- 총알 시스템 ------------------------------
--# ----- 목적 : 총알 생성
local function RequestFire(player, num, st, forward)
    
    --발사 전 처리
    local playerID = player:GetPlayerID()
    Game:BroadcastEvent("BulletFire_sToc", playerID, num, st, forward)
end
Game:ConnectEventFunction("RequestFire_cTos", RequestFire)







local function HitProcess(player)
    
end
Game:ConnectEventFunction("HitProcess_cTos", HitProcess)









--# 목적 : 총알 발사
local function BulletThrow(player, num, stX, stY, stZ, forX, forY, forZ)
    print(1)
    --:FireObject(playerID, posX, posY, posZ, forX, forY)
end



local function BulletRolling(player, num, stX, stY, stZ, forX, forY, forZ)
    print(2)
end











--!---------------------------- 롤링 시스템 ------------------------------
local function RollingSystemStart(player)
    local playerID = player:GetPlayerID()
    player.SnowBallRolling:Initialize()
    
    IsRolling = true 
    --Game:SendEventToClient(playerID, "Toggle_RollingGuage_sToc", true)
end
Game:ConnectEventFunction("RollingSystemStart_cTos", RollingSystemStart)


local function RollingScallingUp(player, waittime, forX, forY)
    player.SnowBallRolling:RollingScaleUp(waittime, forX, forY)
end
Game:ConnectEventFunction("RollingScallingUp_cTos", RollingScallingUp)


local function RollingThrow(player, forX, forY, forZ)
    local playerID = player:GetPlayerID()
    player.SnowBallRolling:RollingThrow(forX, forY, forZ)

    IsRolling = false 
    Game:SendEventToClient(playerID, "Toggle_RollingGuage_sToc", false)
end
Game:ConnectEventFunction("RollingThrow_cTos", RollingThrow)



