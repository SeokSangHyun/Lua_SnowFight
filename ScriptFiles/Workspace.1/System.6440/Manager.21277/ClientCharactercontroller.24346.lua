
--# 전역 및 대표 참조
g_Player = {}                   -- 클라이언트 클래스 객체


--# Rolling 관련 변수
--* 변화량 관련 변수
local prev_forwardpos = Vector.new(0,0,0)
local prev_rightpos = Vector.new(0,0,0)

--* 상태 확인 변수
local IsRolling = false
local IsSnowBall = false


--* 시간 관련 변수
local RollingStartTime = time()



--# ===== 공격 버튼을 눌렀을 때 처리
local MAX_INPUTTIME = 0.4
local MAX_ROLLINGTIME = 5
local SnowBallState = 1     -- (1:던지는지 확인 , 2:눈덩이 굴리기 확인)




--! ------------------------------  ------------------------------
local function HitProcess(playerID)
    
end
Game:ConnectEventFunction("HitProcess_sToc", HitProcess)









--!---------------------------- 총알 시스템 ------------------------------
--# ----- 목적 : 총알 생성
function RequestFire()
    local player = LocalPlayer:GetRemotePlayer()
    
    local inven = player:GetEquipItem("Gloves_slot")
    local StartPos = inven.Location
    local lookfor = LocalPlayer:GetCameraForward()

    --Game:SendEventToServer( "RequestFire_cTos", player.BulletIndex, StartPos.X, StartPos.Y, StartPos.Z ,lookfor.X, lookfor.Y, lookfor.Z)
    Game:SendEventToServer( "RequestFire_cTos", player.BulletIndex, StartPos, lookfor)
end



--# ----- 목적 : 총알발사
function BulletFire(playerID, num, st, forward)--posX, posY, posZ, forX, forY)
    local player = LocalPlayer:GetRemotePlayer()


    if num == 1 then
        player.SnowBall:FireObject(playerID, st.X, st.Y, st.Z, forward.X, forward.Y)
    elseif num == 2 then
        player.Icicle:FireObject(playerID, st.X, st.Y, st.Z, forward.X, forward.Y)
    elseif num == 3 then
        print(1)
    elseif num == 4 then
        --player.SnowBallRolling
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
local function CheckRolling()
    local DeltaTime = time() - RollingStartTime
    
    if IsSnowBall then;    return;    end;
    

    if DeltaTime > MAX_INPUTTIME then
        IsRolling = true
        
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

    if BulletNum == 1 then
        IsSnowBall = false
        IsRolling = false
        RollingStartTime = time()
        Game:AddTimeEvent("CheckRolling", 0.1, CheckRolling)
    end
end




function BulletThrowEnd(BulletNum)
    local player = LocalPlayer:GetRemotePlayer()
    player.BulletIndex = BulletNum

    if BulletNum == 1 then
        if not IsRolling then
            IsSnowBall = true
            local character = LocalPlayer:GetRemotePlayer():GetCharacter()
            character:ChangeAnimState("Throw")
        end
    elseif BulletNum == 2 then

        local character = LocalPlayer:GetRemotePlayer():GetCharacter()
        character:ChangeAnimState("Throw")
    elseif BulletNum == 3 then

        local character = LocalPlayer:GetRemotePlayer():GetCharacter()
        character:ChangeAnimState("Throw")
    end

end









function BulletUIUpdate(num)
    SnowBall_UIUpdate(num)
end
Game:ConnectEventFunction("BulletUIUpdate_sToc", BulletUIUpdate)






