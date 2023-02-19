--! ------------------------------ 변수 ------------------------------
local cor = nil
local Root = Script.Parent
local toy = Root.Ball

local MIN_BallScale = Vector.new(50, 50, 50)
local MAX_BallScale = Vector.new(250, 250, 250)

local MIN_BallOffset = Vector.new(50, 0, 70)
local MAX_BallOffset = Vector.new(50, 0, 160)


local Is_RollingKey = false
local Is_RollingMoveForward = false
local Is_RollingMoveRight = false


local prev_forwardpos = Vector.new(0,0,0)
local prev_rightpos = Vector.new(0,0,0)



local WaitTime = 0
local StandardTime = time()
local cor1 = nil
local UI = Root.UI.ScreenUI



--! ------------------------------ 초기화 ------------------------------
function Init_SnowBall()
    Is_RollingKey = false
    Is_RollingMoveForward = false
    Is_RollingMoveRight = false
end




--# ===== 공격 버튼을 땟을 때 처리
function StartFire()
    b_state = 0


--[[
    toy.ClientScript:Run()
    Init_SnowBall()
]]--
end






--! ------------------------------ 판별 변수 세팅 ------------------------------
--# ===== 목적 : 직진 
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


--# ===== 목적 : 오른쪽 직진
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



--# ===== 목적 : 
function Toggle_RollingKey()
    if Is_RollingKey then
        Is_RollingKey = false
    else
        Is_RollingKey = true
    end
end





--! ------------------------------ 실행 ------------------------------
local function SnowRolling()
    if cor == nil then
        cor = coroutine.create(function()
            while true do
                
                if Is_RollingMoveForward or Is_RollingMoveRight then
                    if Is_RollingKey then
                        local size = toy.Scale
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
        end)
        coroutine.resume(cor)    
    end


end
SnowRolling()





--# ===== 공격 버튼을 눌렀을 때 처리
local BulletIndex = 1
local waitRate = 5
local b_state = 1
function CheckFire()
    if BulletIndex == 1 then
        if cor1 == nil then
            cor1 = coroutine.create(function()
                StandardTime = time()
                
                while true do
                    WaitTime = time() - StandardTime
                    print(WaitTime)
                    
                    if b_state == 2 then
                        UI.Frame.ProgressBar:SetPercent(WaitTime / waitRate)
                        if WaitTime > waitRate then
                            toy.ClientScript:Run()
                            Init_SnowBall()
                            Is_RollingKey = false
                            UI.Visible = false
                            return
                        end
                    elseif b_state == 1 then
                        if WaitTime > 1 then
                            UI.Visible = true
                            b_state = 2
                            WaitTime = 0
                            StandardTime = time()
                            Is_RollingKey = true
                            UI.Frame.ProgressBar:SetPercent(0)
                        end
                    else
                        return
                    end
                    
                    
                    wait(0.05)
                end
                
            end)
            coroutine.resume(cor1)
            
        end
    end
end





