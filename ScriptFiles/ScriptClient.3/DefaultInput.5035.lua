------------------------------------------------------------------------------------------------------------
--플레이어의 조작키를 설정하는 스크립트에요.
------------------------------------------------------------------------------------------------------------

local IsUseJump = Script.IsUseJump
local IsUseMoveControl = Script.IsUseMoveControl
local IsUseZoomInOut = Script.IsUseZoomInOut
local IsUseLookControl = Script.IsUseLookControl
local IsUseTurnControl = Script.IsUseTurnControl



------------------------------------------------------------------------------------------------------------
--터치스크린 화면인가? 터치스크린이라면 모바일
local IsMobileTouchScreen = Input:IsMobileTouchScreen()


--모바일용 버튼 표시 및 위치 설정
Input:SetJoystickControlVisibility(0, true)
Input:SetPadCenter(0, 160, -100)
Input:SetJoystickControlVisibility(1, true)
Input:SetPadCenter(1, -50, -85)



------------------------------------------------------------------------------------------------------------
--조작키 그룹을 추가해요.
Input:AddGroup("DefaultInput")



------------------------------------------------------------------------------------------------------------
--조작키 이벤트를 등록해요.

--PC 환경에서 사용할 조작키 이벤트
Input:AddAxisKeyEvent("DefaultInput", "MoveForward", Enum.Key.W, 1)
Input:AddAxisKeyEvent("DefaultInput", "MoveForward", Enum.Key.S, -1)
Input:AddAxisKeyEvent("DefaultInput", "MoveForward", Enum.Key.Up, 1)
Input:AddAxisKeyEvent("DefaultInput", "MoveForward", Enum.Key.Down, -1)
Input:AddAxisKeyEvent("DefaultInput", "MoveRight", Enum.Key.A, -1)
Input:AddAxisKeyEvent("DefaultInput", "MoveRight", Enum.Key.D, 1)
Input:AddAxisKeyEvent("DefaultInput", "MoveForward", Enum.Key.Gamepad_LeftY, 1)
Input:AddAxisKeyEvent("DefaultInput", "MoveRight", Enum.Key.Gamepad_LeftX, 1)
Input:AddAxisKeyEvent("DefaultInput", "Turn", Enum.Key.MouseX, 1)
Input:AddAxisKeyEvent("DefaultInput", "Turn", Enum.Key.Left, -0.75)
Input:AddAxisKeyEvent("DefaultInput", "Turn", Enum.Key.Right, 0.75)
Input:AddAxisKeyEvent("DefaultInput", "LookUp", Enum.Key.MouseY, -1)
Input:AddAxisKeyEvent("DefaultInput", "Turn", Enum.Key.Gamepad_RightX, 1)
Input:AddAxisKeyEvent("DefaultInput", "LookUp", Enum.Key.Gamepad_RightY, -1)
Input:AddAxisKeyEvent("DefaultInput", "FreeCamUpDown", Enum.Key.E, 1)
Input:AddAxisKeyEvent("DefaultInput", "FreeCamUpDown", Enum.Key.Q, -1)
Input:AddAxisKeyEvent("DefaultInput", "ZoomInOut", Enum.Key.MouseWheelAxis, -50)
Input:AddActionKeyEvent("DefaultInput", "Jump", Enum.Key.SpaceBar)


--모바일 환경에서 사용할 조작키 이벤트
Input:AddAxisKeyEvent("DefaultInput", "MoveForward_M", Enum.Key.Touch_DpadY, 1)
Input:AddAxisKeyEvent("DefaultInput", "MoveRight_M", Enum.Key.Touch_DpadX, 1)
Input:AddAxisKeyEvent("DefaultInput", "Touch_ScreenX_M", Enum.Key.Touch_ScreenX, 1)
Input:AddAxisKeyEvent("DefaultInput", "Touch_ScreenY_M", Enum.Key.Touch_ScreenY, 1)
Input:AddAxisKeyEvent("DefaultInput", "ZoomInOut_M", Enum.Key.Screen_Pinch, 1)
Input:AddActionKeyEvent("DefaultInput", "Jump", Enum.Key.GamePad_Button1)



------------------------------------------------------------------------------------------------------------
 --조작키를 활성화해요.
Input:ActiveGroup("DefaultInput")



------------------------------------------------------------------------------------------------------------
--조작이 발생했을때 실행할 동작을 처리해요.

--이동 조작키 사용시
if IsUseMoveControl then
    --PC이면
    if IsMobileTouchScreen == false then 
        LocalPlayer:ProcessInputAxisEvent("MoveForward", function(value) 
           LocalPlayer:MoveForward(value)
        end)
    
        LocalPlayer:ProcessInputAxisEvent("MoveRight", function(value) 
           LocalPlayer:MoveRight(value)
        end)
    
    --모바일이면
    else
        --조이스틱 이동
        LocalPlayer:ProcessInputAxisEvent("MoveForward_M", function(value) 
           local moveSpeed = 2.0
           LocalPlayer:MoveForward(value * moveSpeed)
        end)
        
        LocalPlayer:ProcessInputAxisEvent("MoveRight_M", function(value) 
           local moveSpeed = 2.0
           LocalPlayer:MoveRight(value * moveSpeed)       
        end)
    end
end


--카메라 좌우 조작키 사용시
if IsUseTurnControl then
    --PC이면
    if IsMobileTouchScreen == false then 
        LocalPlayer:ProcessInputAxisEvent("Turn", function(value) 
           LocalPlayer:Turn(value)
        end)
        
    --모바일이면
    else 
        --화면 터치시 카메라 회전(X축)
        LocalPlayer:ProcessTouchAxisEvent("Touch_ScreenX_M", function(value)
           local rotspeed = 4.0
           LocalPlayer:Turn(value * rotspeed)     
        end)
    end
end


--카메라 상하 조작키 사용시
if IsUseLookControl then
    --PC이면
    if IsMobileTouchScreen == false then 
        LocalPlayer:ProcessInputAxisEvent("LookUp", function(value) 
           LocalPlayer:LookUp(value)
        end)
    
    --모바일이면
    else
        --화면 터치시 카메라 회전(Y축)
        LocalPlayer:ProcessTouchAxisEvent("Touch_ScreenY_M", function(value)
           local rotspeed = 4.0
           LocalPlayer:LookUp(value * rotspeed)       
        end)
    end
end


--점프 조작키 사용시
if IsUseJump then
    LocalPlayer:ProcessInputActionEvent("Jump", Enum.KeyInputType.Pressed, function()
        LocalPlayer:Jump()
    end)    
end


--프리캠 조작키
LocalPlayer:ProcessInputAxisEvent("FreeCamUpDown", function(value) 
    LocalPlayer:FreeCamMoveUpDown(value)
end)


--카메라 확대&축소 조작키 사용시
if IsUseZoomInOut then
    --PC이면
    if IsMobileTouchScreen == false then 
        LocalPlayer:ProcessInputAxisEvent("ZoomInOut", function(value)
            LocalPlayer:ZoomInOut(value)
        end)
    
    --모바일이면
    else
        LocalPlayer:ProcessTouchAxisEvent("ZoomInOut_M", function(value)     
            local axisSpeed = 3200.0
            LocalPlayer:ZoomInOut(value * axisSpeed)      
        end)    
    end
end