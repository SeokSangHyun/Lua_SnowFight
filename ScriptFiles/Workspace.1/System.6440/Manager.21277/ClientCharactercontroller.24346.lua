--# 모듈 임포트
local PlayerModule = require(Workspace.System.Class.ccPlayer)
local WeaponList = {Script.SnowBall , Script.Icicle , Script.SnowCrystal}

--# 전역 및 대표 참조
g_Player = {}                   -- 클라이언트 클래스 객체


--# Rolling 관련 변수
--* 
local toy_Rolling = Toybox.Bullet.SnowBallRollimg

--* UI 관련 변수
local RollingUI = UIRoot.F_RollingGuage

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
function Init_SnowBall()
    Is_RollingKey = false
    Is_RollingMoveForward = false
    Is_RollingMoveRight = false
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
local cor = nil
local function SnowRolling()
    if cor == nil then
        cor = coroutine.create(function()
            while true do
                if Is_RollingMoveForward or Is_RollingMoveRight then
                    if Is_RollingKey then
                        local size = toy_Rolling.Scale
                        size.X = size.X + 0.01
                        size.Y = size.Y + 0.01
                        size.Z = size.Z + 0.01
                        toy.Scale = size
                        
                        local pos = toy.Location
                        pos.Z = pos.Z * 1.004
                        toy.Location = pos

                        if size.Z > 0.9 then
                            toy.ClientScript:Run()
                            Init_SnowBall()
                            return
                        end
                    end    
                end

                wait(0.05)
            end

            cor = nil
        end)
        coroutine.resume(cor)    
    end


end
SnowRolling()





--# ===== 공격 버튼을 눌렀을 때 처리
local cor1 = nil
local BulletIndex = 1
local MAX_WAITTIME = 5
local SnowBallState = 1     -- (1:던지는지 확인 , 2:눈덩이 굴리기 확인)
function CheckRollingStart()
    if BulletIndex == 1 then
        if cor1 == nil then
            cor1 = coroutine.create(function()
                StandardTime = time()
                
                while true do
                    WaitTime = time() - StandardTime
                    print(WaitTime)
                    
                    if SnowBallState == 2 then
                        RollingUI.ProgressBar:SetPercent(WaitTime / MAX_WAITTIME)
                        if WaitTime > MAX_WAITTIME then
                            RollingUI.Visible = false

                            --toy.ClientScript:Run()
                            Init_SnowBall()
                            return
                        end
                    elseif SnowBallState == 1 then
                        if WaitTime > 1 then
                            RollingUI.ProgressBar:SetPercent(0)
                            RollingUI.Visible = true

                            Is_RollingKey = true
                            WaitTime = 0
                            StandardTime = time()

                            SnowBallState = 2
                        end
                    else
                        return
                    end
                    wait(0.05)
                end
                cor1 = nil
            end)

            coroutine.resume(cor1)
        end
    end

end




