--# 모듈 임포트
local PlayerModule = require(Workspace.System.Class.ccPlayer)

--# 전역 및 대표 참조
g_Player = {}                   -- 클라이언트 클래스 객체


--# Rolling 관련 변수
--* 
local toy_Rolling = Toybox.Bullet.SnowBallRolling

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
local function RollingSystem()
    if Is_RollingMoveForward or Is_RollingMoveRight then
        if Is_RollingKey then
            Game:SendEventToServer("RollingScallingUp_cTos")
            -- local size = toy_Rolling.Scale
            -- size.X = size.X + 0.01
            -- size.Y = size.Y + 0.01
            -- size.Z = size.Z + 0.01
            -- toy.Scale = size
            
            -- local pos = toy.Location
            -- pos.Z = pos.Z * 1.004
            -- toy.Location = pos

            -- if size.Z > 0.9 then
            --     toy.ClientScript:Run()
            --     Init_SnowBall()
            --     return
            -- end
        end    
    end
end


-- local character = LocalPlayer:GetRemotePlayer():GetCharacter()
-- character:ChangeAnimState("Throw")
-- SetActionKey(true)


--# ===== 공격 버튼을 눌렀을 때 처리
local cor1 = nil
local MAX_INPUTTIME = 0.4
local MAX_ROLLINGTIME = 5
local SnowBallState = 1     -- (1:던지는지 확인 , 2:눈덩이 굴리기 확인)
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
                            --toy.ClientScript:Run()
                            goto Continue
                        else
                            RollingUI.ProgressBar:SetPercent(WaitTime / MAX_ROLLINGTIME)
                            RollingSystem()
                            if not Is_RollingKey then
                                goto Continue
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
                                goto Continue
                            end
                        end

                    else;   return; end;
                    wait(0.05)
                end
                ::Continue::
                Init_SnowBall()
                cor1 = nil
            end)

            coroutine.resume(cor1)
        end
    end

end




