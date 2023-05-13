--# 모듈 임포트
local PlayerModule = require(Workspace.System.Class.ccPlayer)

--# 전역 및 대표 참조
g_Player = {}                   -- 클라이언트 클래스 객체


--# Rolling 관련 변수
--* 
local toy_Rolling = Toybox.Bullet.SnowBallRolling



--* 변화량 관련 변수
local prev_forwardpos = Vector.new(0,0,0)
local prev_rightpos = Vector.new(0,0,0)

--* 상태 확인 변수
local Is_RollingKey = false
local Is_RollingMoveForward = false
local Is_RollingMoveRight = false

local MIN_BallScale = Vector.new(50, 50, 50)
local MAX_BallScale = Vector.new(250, 250, 250)
local MIN_BallOffset = Vector.new(50, 0, 70)
local MAX_BallOffset = Vector.new(50, 0, 160)


--* 시간 관련 변수
local WaitTime = 0
local StandardTime = time()


--# ===== 공격 버튼을 눌렀을 때 처리
local cor1 = nil
local MAX_INPUTTIME = 0.4
local MAX_ROLLINGTIME = 5
local SnowBallState = 1     -- (1:던지는지 확인 , 2:눈덩이 굴리기 확인)




--! ------------------------------  ------------------------------
local function InitPlayer(playerID)

    local info = PlayerModule.new(playerID, Toybox.Bullet:GetChildList())
    --table.insert(g_PlayerList, info)
    
    g_Player = info
end
Game:ConnectEventFunction("InitPlayer_sToc", InitPlayer)







local function HitProcess(playerID)
    
end
Game:ConnectEventFunction("HitProcess_sToc", HitProcess)




--! ------------------------------ 눈 굴리기 로직 ------------------------------
--# 변수 초기화
function Init_SnowBallRolling()
    Is_RollingKey = false
    Is_RollingMoveForward = false
    Is_RollingMoveRight = false
    SnowBallState = 1
    RollingUI.ProgressBar:SetPercent(0 / MAX_ROLLINGTIME)
end





--! ------------------------------ 판별 변수 세팅 ------------------------------
--# ===== 목적 : 롤링 시스템 시 직진 변화량이 있을 때만 다음 동작이 작동하도록함
function CheckRollingForwardState()
    local nowpos = LocalPlayer:GetRemotePlayer():GetCharacter().Location
    local vec = Vector.new(prev_forwardpos.X - nowpos.X , prev_forwardpos.Y - nowpos.Y , prev_forwardpos.Z - nowpos.Z)
    prev_forwardpos = nowpos

    if vec.Size <= 0 then
        Is_RollingMoveForward = false
    else
        Is_RollingMoveForward = true
    end
end


--# ===== 목적 : 롤링 시스템 시 오른쪽 변화량이 있을 때만 다음 동작이 작동하도록함
function CheckRollingRightState()
    local nowpos = LocalPlayer:GetRemotePlayer():GetCharacter().Location
    local vec = Vector.new(prev_rightpos.X - nowpos.X , prev_rightpos.Y - nowpos.Y , prev_rightpos.Z - nowpos.Z)
    prev_rightpos = nowpos

    if vec.Size <= 0 then
        Is_RollingMoveRight = false
    else
        Is_RollingMoveRight = true
    end
end



--# ===== 목적 : 눈덩이 공격을 입력 했는지 체크
function Toggle_RollingKey(state)
    Is_RollingKey = state
end





--! ------------------------------ 실행 ------------------------------
--# 1번 눈덩이 이외의 던지기
function BulletThrow(BulletNum)
    g_Player:ActionInput(BulletNum)

    local character = LocalPlayer:GetRemotePlayer():GetCharacter()
    character:ChangeAnimState("Throw")
end



function BulletFire(num)
    SnowBall_UIUpdate(num)
end
Game:ConnectEventFunction("BulletFire_sToc", BulletFire)


--# 롤링 시스템이 커지는 시스템
local function RollingSystem(waittime)
    if Is_RollingMoveForward or Is_RollingMoveRight then
        if Is_RollingKey then
            local forward = LocalPlayer:GetCameraForward()
            Game:SendEventToServer("RollingScallingUp_cTos", waittime, forward.X, forward.Y)
            RollingUI.ProgressBar:SetPercent(WaitTime / MAX_ROLLINGTIME)

        end    
    end
end



--# 롤링 대기 
function CheckRollingStart()
    if g_Player:GetWeaponIndex() == 1 then
        if cor1 == nil then
            cor1 = coroutine.create(function()
                StandardTime = time()
                while true do
                    WaitTime = time() - StandardTime
--* 눈덩이 커지는 로직
                    if SnowBallState == 2 then
                        if WaitTime > MAX_ROLLINGTIME then
                            RollingUI.Visible = false
                            local forward = LocalPlayer:GetCameraForward()
                            Game:SendEventToServer("RollingThrow_cTos", forward.X, forward.Y, forward.Z)
                            break;
                        else
                            
                            RollingSystem(WaitTime)
                            if not Is_RollingKey then
                                local forward = LocalPlayer:GetCameraForward()
                                Game:SendEventToServer("RollingThrow_cTos", forward.X, forward.Y, forward.Z)
                                break;
                            end
                        end

--* 굴리기인지 던지기인지 판별
                    elseif SnowBallState == 1 then
                        if WaitTime > MAX_INPUTTIME then
                            RollingUI.ProgressBar:SetPercent(0)
                            RollingUI.Visible = true
                            WaitTime = 0
                            StandardTime = time()
                            SnowBallState = 2
                            --g_Player:PreFire()
                            Game:SendEventToServer("RollingSystemStart_cTos")
                        else
                            if not Is_RollingKey then
                                local character = LocalPlayer:GetRemotePlayer():GetCharacter()
                                character:ChangeAnimState("Throw")
                                break;
                            end
                        end

                    else;   return; end;
                    wait(0.05)
                end
                --::Continue::
                Init_SnowBallRolling()
                cor1 = nil
            end)

            coroutine.resume(cor1)
        end
    end

end




