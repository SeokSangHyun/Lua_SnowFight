

--# Rolling 관련 변수
--* 변화량 관련 변수
local prev_forwardpos = Vector.new(0,0,0)
local prev_rightpos = Vector.new(0,0,0)

--* 상태 확인 변수
local IsRolling = false                     -- 굴리기 중인지 확인
local IsSnowBall = false                    -- 던지기 했는지 확인


--* 시간 관련 변수
local RollingStartTime = time()



--# ===== 공격 버튼을 눌렀을 때 처리
local MAX_INPUTTIME = 0.4
local MAX_ROLLINGTIME = 5
local SnowBallState = 1     -- (1:던지는지 확인 , 2:눈덩이 굴리기 확인)





--! ------------------------------  ------------------------------
--# -----목적 : 이동 조작을 막을 것인지 확인
--               Ture일 때 조작 가능
function CheckMoveCtrl()
    if not Runcheck then
        return true
    else
        return false
    end
end


--# -----목적 : 총알
--                TRUE일 때, 총알 발사 가능
function CheckBulletCount(player)
    local IsFire = false
    if player.BulletIndex == 1 or player.BulletIndex == 4 then
        IsFire = player.SnowBall:CheckFire()
    elseif player.BulletIndex == 2 then
        IsFire = player.Icicle:CheckFire()
    --elseif player.BulletIndex == 3 then
    else
        IsFire = false
    end
    
    return IsFire
end






--! ------------------------------ Getter / Setter ------------------------------
local function HitProcess(playerID)
    
end
Game:ConnectEventFunction("HitProcess_sToc", HitProcess)


--# ----- 목적 : 굴리기 변수
function GetIsRolling();    return IsRolling;   end;
function SetIsRolling(state)
    IsRolling = state
end


--# ----- 목적 : 던지기 변수
function GetIsSnowBall();   return IsSnowBall;  end;
function SetIsSnowBall(state)
    IsSnowBall = state
end





--!---------------------------- 총알 시스템 ------------------------------
--# ----- 목적 : 총알 생성
function RequestFire()
    local player = LocalPlayer:GetRemotePlayer()
    local inven = player:GetEquipItem("Gloves_slot")
    local StartPos = inven.Location
    local lookfor = LocalPlayer:GetCameraForward()

    --BulletCountUpdate(player.BulletIndex , player. player.BulletIndex)
    Game:SendEventToServer( "RequestFire_cTos", player.BulletIndex, StartPos, lookfor)
end



--# ----- 목적 : 총알발사
local function BulletFire(playerID, BulletIndex, st_pos, forward)--posX, posY, posZ, forX, forY)
    local player = LocalPlayer:GetRemotePlayer()

    if BulletIndex == 1 then
        player.SnowBall:FireObject(playerID, st_pos, forward)
    elseif BulletIndex == 2 then
        player.Icicle:FireObject(playerID, st_pos, forward)
    end

end
Game:ConnectEventFunction("BulletFire_sToc", BulletFire)










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
    local character = LocalPlayer:GetRemotePlayer():GetCharacter()
    if character == nil then;   return; end;

    local nowpos = LocalPlayer:GetRemotePlayer():GetCharacter().Location
    local vec = Vector.new(prev_forwardpos.X - nowpos.X , prev_forwardpos.Y - nowpos.Y , prev_forwardpos.Z - nowpos.Z)
    prev_forwardpos = nowpos

    if vec.Size <= 0 then
        Game:SendEventToServer("RplicateMoveForward", false)
    else
        Game:SendEventToServer("RplicateMoveForward", true)
    end
end


--# ===== 목적 : 롤링 시스템 시 오른쪽 변화량이 있을 때만 다음 동작이 작동하도록함
function CheckRollingRightState()
    local character = LocalPlayer:GetRemotePlayer():GetCharacter()
    if character == nil then;   return; end;

    local nowpos = LocalPlayer:GetRemotePlayer():GetCharacter().Location
    local vec = Vector.new(prev_rightpos.X - nowpos.X , prev_rightpos.Y - nowpos.Y , prev_rightpos.Z - nowpos.Z)
    prev_rightpos = nowpos

    if vec.Size <= 0 then
        Game:SendEventToServer("RplicateMoveRight", false)
    else
        Game:SendEventToServer("RplicateMoveRight", true)
    end
end









--! ------------------------------ 실행 ------------------------------
--# -----목적 : 키를 누르고 있는지 확인
function CheckRolling()
    local player = LocalPlayer:GetRemotePlayer()
    local DeltaTime = player.SnowBallRolling:TimeDelta()
    
    if GetIsSnowBall() or GetIsRolling() then;    return;    end;

    if DeltaTime > MAX_INPUTTIME then
        SetIsRolling(true)
        
        local player = LocalPlayer:GetRemotePlayer()
        player.BulletIndex = 0
        Toggle_RollingGuage(true)
        Game:SendEventToServer("RollingSystemStart_cTos")
        return
    end

    Game:AddTimeEvent("CheckRolling", 0.1, CheckRolling)
end




--# 1번 눈덩이 이외의 던지기
function BulletThrowStart(BulletNum)
    local player = LocalPlayer:GetRemotePlayer()
    player.BulletIndex = BulletNum
    
    if not CheckBulletCount(player) then;    return;    end;

    if BulletNum == 1 then
        IsSnowBall = false
        IsRolling = false
        RollingStartTime = time()
        Game:AddTimeEvent("CheckRolling", 0.1, CheckRolling)
    end
end





function RollingScallingUp(WaitTime)
    local forward = LocalPlayer:GetRemotePlayer():GetCharacter().Transform:GetForward()
    Game:SendEventToServer("RollingScallingUp_cTos", WaitTime, forward.X, forward.Y)
end




function RollingThrow()
    SetIsRolling(false)
    SetIsSnowBall(false)

    local forward = LocalPlayer:GetRemotePlayer():GetCharacter().Transform:GetForward()
    Game:SendEventToServer("RollingThrow_cTos", forward.X, forward.Y, forward.Z)
end







--! ------------------------------ 실행 ------------------------------
function BulletUIUpdate(num)
    SnowBall_UIUpdate(num)
end
Game:ConnectEventFunction("BulletUIUpdate_sToc", BulletUIUpdate)







--! ------------------------------ 죽음 시스템 ------------------------------













