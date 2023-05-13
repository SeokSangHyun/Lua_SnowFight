    ------------------------------------------------------------------------------------------------------------
--트리 패턴 적용을 처리하는 스크립트에요.
------------------------------------------------------------------------------------------------------------

local Light = Script.Parent
local Point = Light.PointLight
local LightLineList = Light.LightList:GetChildList()
local BeltList = Script.Parent.Belt_Light:GetChildList()
local Line = Script.Parent.Parent.Switch.Line:GetChildList()
local Switch = Script.Parent.Parent.Switch
local Switch_Line = Script.Parent.Parent.Switch.Line:GetChildList()

local LightOn = false

--------------------------------------------------------------------------------------
local ColorList = {
                    Color.new(225,0,0,225), -- Red
                    Color.new(150,0,150,225), -- Pink
                    Color.new(150,150,0,225), -- Yellow
                    Color.new(0,150,0,225), -- Green
                    Color.new(0,0,150,225), -- Blue
                    Color.new(150,150,150,225) -- White
                    }
                    
local White = Color.new(255,255,255,255)
--------------------------------------------------------------------------------------

local function Tree_control1()    --휘리릭 패턴
    for i = 1, #ColorList do -- 색상 수 만큼 반복
        if not LightOn then break end    --스위치를 껐을 때 코드 종료
        for j = 1, #LightLineList do -- 라인 수 만큼 반복
            if not LightOn then return end
        
            local lightBallList = LightLineList[j]:GetChildList()
            
            for k = 1, #lightBallList  do -- 라인의 자식 라이트들 색 변경
                if not LightOn then return end
                lightBallList[k]:SetColor(ColorList[i])
                wait(0.02)
            end
            
            if j%2 == 1 then -- 벨트 색 변경
                if not LightOn then return end
                BeltList[j//2 + 1]:SetColor(ColorList[i])
                wait(0.02)
            end
        end
        wait(5)    --시간 간격 (5초에 한번씩 색상 변경)
    end
end

--------------------------------------------------------------------------------------

local function Tree_control2()    --전체 패턴
    for i = 1, #ColorList do -- 색상 수 만큼 반복
        if not LightOn then break end
        for j = 1, #LightLineList do -- 라인 수 만큼 반복
            if not LightOn then return end
        
            local lightBallList = LightLineList[j]:GetChildList()
            
            for k = 1, #lightBallList  do -- 라인의 자식 라이트들 색 변경
                if not LightOn then return end
                lightBallList[k]:SetColor(ColorList[i])
            end
            
            if j%2 == 1 then -- 벨트 색 변경
                if not LightOn then return end
                BeltList[j//2 + 1]:SetColor(ColorList[i])
            end
        end
        wait(10)    --시간 간격 (10초에 한번씩 색상 변경)
    end
end

--------------------------------------------------------------------------------------

local function Tree_control3()    --홀짝 반짝 패턴
    for i = 1, #ColorList do -- 색상 수 만큼 반복
        if not LightOn then break end
        for j = 1, #LightLineList do -- 라인 수 만큼 반복
            if not LightOn then return end
        
            local lightBallList = LightLineList[j]:GetChildList()
            
            for k = 1, #lightBallList  do -- 라인의 자식 라이트들 색 변경
                if not LightOn then return end
                if k%2 == 0 then
                    if not LightOn then return end
                    lightBallList[k]:SetColor(ColorList[i])
                else
                    if i + 1 > #ColorList then
                        if not LightOn then return end
                        lightBallList[k]:SetColor(ColorList[1])
                    else
                        if not LightOn then return end
                        lightBallList[k]:SetColor(ColorList[i + 1])
                    end
                end
            end
            
            if j%2 == 1 then -- 벨트 색 변경
                if not LightOn then return end
                BeltList[j//2 + 1]:SetColor(ColorList[i])
            end
        end
        wait(2)        --시간 간격 (2초에 한번씩 색상 변경)
    end
end

--------------------------------------------------------------------------------------

local function Tree_control_off()    --Off

    for j = 1, #LightLineList do -- 라인 수 만큼 반복
    
        local lightBallList = LightLineList[j]:GetChildList()
        
        for k = 1, #lightBallList  do -- 라인의 자식 라이트들 색 변경
            lightBallList[k]:SetColor(ColorList[6])
        end
        
        if j%2 == 1 then -- 벨트 색 변경
            BeltList[j//2 + 1]:SetColor(ColorList[6])
        end        
    end

end

--------------------------------------------------------------------------------------

Point.Enable = false

local function Tree_pattern1()
    if not LightOn then
        return
    end
    
    Point.Enable = true
    
    while LightOn do
        if not LightOn then return end
        Tree_control1()
        if not LightOn then return end
        Tree_control3()
        if not LightOn then return end
        Tree_control2()
        if not LightOn then return end
        Tree_control3()
        if not LightOn then return end
        -- 새로운 패턴이 있으면 이곳에 추가 가능
    end
end

--------------------------------------------------------------------------------------
-- 스위치 충돌 처리 : Server에서 전달 받은 스위치 조건을 Client에 적용

local function LightToggle(on)
    if on then    --스위치 켰을 때
        LightOn = true
        Switch:SetColor(ColorList[1])    --스위치 색상
        
        for k = 1, #Switch_Line  do     -- 스위치 라이트 색상
            Switch_Line[k]:SetColor(ColorList[6])
        end
        
        Tree_pattern1()
    else    --스위치 껐을 때
        Switch:SetColor(ColorList[6])    --스위치 색상
        
        for k = 1, #Switch_Line  do     -- 스위치 라이트 색상
            Switch_Line[k]:SetColor(White)
        end
        
        Point.Enable = false
        LightOn = false
        Tree_control_off()

    end
end
Game:ConnectEventFunction("LightToggle", LightToggle)

--------------------------------------------------------------------------------------
-- 새로 들어온 클라이언트와 현재 트리의 라이트 OnOff 상태 동기화 시키기 위한 처리

local function UpdateLightStats(lightStatus)
    LightOn = lightStatus
end
Game:ConnectEventFunction("UpdateLightStats", UpdateLightStats)


Game:SendEventToServer("ReturnSwitchStatus")
wait(1)
Tree_pattern1()

--------------------------------------------------------------------------------------