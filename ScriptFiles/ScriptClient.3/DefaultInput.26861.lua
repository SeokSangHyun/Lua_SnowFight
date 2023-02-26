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
DefaultInput = Input:AddGroup("DefaultInput")



------------------------------------------------------------------------------------------------------------
--조작키 이벤트를 등록해요.

--PC 환경에서 사용할 조작키 이벤트
DefaultInput:AddAxisKeyEvent("MoveForward", Enum.Key.W, 1)
DefaultInput:AddAxisKeyEvent("MoveForward", Enum.Key.S, -1)
DefaultInput:AddAxisKeyEvent("MoveForward", Enum.Key.Up, 1)
DefaultInput:AddAxisKeyEvent("MoveForward", Enum.Key.Down, -1)
DefaultInput:AddAxisKeyEvent("MoveRight", Enum.Key.A, -1)
DefaultInput:AddAxisKeyEvent("MoveRight", Enum.Key.D, 1)
DefaultInput:AddAxisKeyEvent("MoveForward", Enum.Key.Gamepad_LeftY, 1)
DefaultInput:AddAxisKeyEvent("MoveRight", Enum.Key.Gamepad_LeftX, 1)
DefaultInput:AddAxisKeyEvent("Turn", Enum.Key.MouseX, 1)
DefaultInput:AddAxisKeyEvent("Turn", Enum.Key.Left, -0.75)
DefaultInput:AddAxisKeyEvent("Turn", Enum.Key.Right, 0.75)
DefaultInput:AddAxisKeyEvent("LookUp", Enum.Key.MouseY, -1)
DefaultInput:AddAxisKeyEvent("Turn", Enum.Key.Gamepad_RightX, 1)
DefaultInput:AddAxisKeyEvent("LookUp", Enum.Key.Gamepad_RightY, -1)
DefaultInput:AddAxisKeyEvent("FreeCamUpDown", Enum.Key.E, 1)
DefaultInput:AddAxisKeyEvent("FreeCamUpDown", Enum.Key.Q, -1)
DefaultInput:AddAxisKeyEvent("ZoomInOut", Enum.Key.MouseWheelAxis, -50)
DefaultInput:AddActionKeyEvent("Jump", Enum.Key.SpaceBar)

--모바일 환경에서 사용할 조작키 이벤트
DefaultInput:AddAxisKeyEvent("MoveForward_M", Enum.Key.Touch_DpadY, 1)
DefaultInput:AddAxisKeyEvent("MoveRight_M", Enum.Key.Touch_DpadX, 1)
DefaultInput:AddAxisKeyEvent("Touch_ScreenX_M", Enum.Key.Touch_ScreenX, 1)
DefaultInput:AddAxisKeyEvent("Touch_ScreenY_M", Enum.Key.Touch_ScreenY, 1)
DefaultInput:AddAxisKeyEvent("ZoomInOut_M", Enum.Key.Screen_Pinch, 1)
DefaultInput:AddActionKeyEvent("Jump", Enum.Key.GamePad_Button1)



------------------------------------------------------------------------------------------------------------
 --조작키를 활성화해요.
Input:ActiveGroup("DefaultInput")



------------------------------------------------------------------------------------------------------------
--카메라 조작이 비활성화일때 Camera의 회전 상속 무시 여부에 따라서 카메라의 회전 처리 방식을 제어해요.
local function ChangeCurrentCamera(currentCamera)
    if currentCamera == nil then
        return
    end

    if currentCamera.UsePreviousRotWhenNotUsingInheritRot == true then
        if not IsUseTurnControl then
            currentCamera.InheritYaw = false
        end
    
        if not IsUseLookUpControl then
            currentCamera.InheritPitch = false
        end
    end
end
LocalPlayer.OnChangeCurrentCamera:Connect(ChangeCurrentCamera)



------------------------------------------------------------------------------------------------------------
--Camera의 회전 상속 무시 여부에 따라 카메라의 회전 처리 방식을 제어하기 위해
--현재 활성화된 조작 그룹을 관리하는 데이터에요.
--(Turn이나 LookUp 이벤트을 사용하는 조작 그룹을 SetActiveGroup 함수로 설정해야 해요.)
CameraUpdater = {}
CameraUpdater.ActiveGroup = ""

--변경된 조작그룹이 Turn이나 LookUp 이벤트를 사용하면 이 함수가 호출되어야 해요.
CameraUpdater.SetActiveGroup = function(self, Group)
   self.ActiveGroup = Group
end

--Turn 이벤트쪽에 이 함수가 호출되어야 해요.
CameraUpdater.UpdateInheritYaw = function(self, value, Group)
    if self.ActiveGroup ~= Group then
        return
    end

    local camera = LocalPlayer:GetCurrentCamera()
    if camera == nil then 
        return 
    end
    
    if camera.UsePreviousRotWhenNotUsingInheritRot == true then
        if value ~= 0 then 
            camera.InheritYaw = true
        else 
            camera.InheritYaw = false 
        end
    else 
        camera.InheritYaw = true 
    end
end

--LookUp 이벤트쪽에 이 함수가 호출되어야 해요.
CameraUpdater.UpdateInheritPitch = function(self, value, Group)
    if self.ActiveGroup ~= Group then
        return
    end 
        
    local camera = LocalPlayer:GetCurrentCamera()
    if camera == nil then 
        return 
    end
    
    if camera.UsePreviousRotWhenNotUsingInheritRot == true then
        if value ~= 0 then 
            camera.InheritPitch = true
        else 
            camera.InheritPitch = false 
        end
    else 
        camera.InheritPitch = true 
    end
end

--카메라의 회전 처리 방식을 제어할 조작 그룹 활성화
CameraUpdater:SetActiveGroup("DefaultInput")



------------------------------------------------------------------------------------------------------------
--조작이 발생했을때 실행할 동작을 처리해요.

--이동 조작키 사용시
if IsUseMoveControl then
    --PC이면
    if IsMobileTouchScreen == false then 
        DefaultInput:ProcessInputAxisEvent("MoveForward", function(value) 
           LocalPlayer:MoveForward(value)
            if IsMobileTouchScreen == false then
                CheckRollingForwardState()
            end
        end)
    
        DefaultInput:ProcessInputAxisEvent("MoveRight", function(value) 
           LocalPlayer:MoveRight(value)
            if IsMobileTouchScreen == false then
                CheckRollingRightState()
            end
        end)
    
    --모바일이면
    else
        --조이스틱 이동
        DefaultInput:ProcessInputAxisEvent("MoveForward_M", function(value) 
           local moveSpeed = 2.0
           LocalPlayer:MoveForward(value * moveSpeed)
            if IsMobileTouchScreen == false then
                CheckRollingForwardState()
            end
        end)
        
        DefaultInput:ProcessInputAxisEvent("MoveRight_M", function(value) 
           local moveSpeed = 2.0
           LocalPlayer:MoveRight(value * moveSpeed)
            if IsMobileTouchScreen == true then
                CheckRollingRightState()
            end
        end)
    end
end


--카메라 좌우 조작키 사용시
if IsUseTurnControl then
    --PC이면
    if IsMobileTouchScreen == false then 
        DefaultInput:ProcessInputAxisEvent("Turn", function(value) 
           LocalPlayer:Turn(value)
           CameraUpdater:UpdateInheritYaw(value, "DefaultInput")
        end)
        
    --모바일이면
    else 
        --화면 터치시 카메라 회전(X축)
        DefaultInput:ProcessTouchAxisEvent("Touch_ScreenX_M", function(value)
           local rotspeed = 4.0
           LocalPlayer:Turn(value * rotspeed)     
           CameraUpdater:UpdateInheritYaw(value, "DefaultInput")
        end)
    end
end


--카메라 상하 조작키 사용시
if IsUseLookControl then
    --PC이면
    if IsMobileTouchScreen == false then 
        DefaultInput:ProcessInputAxisEvent("LookUp", function(value) 
           LocalPlayer:LookUp(value)
           CameraUpdater:UpdateInheritPitch(value, "DefaultInput")
        end)
    
    --모바일이면
    else
        --화면 터치시 카메라 회전(Y축)
        DefaultInput:ProcessTouchAxisEvent("Touch_ScreenY_M", function(value)
           local rotspeed = 4.0
           LocalPlayer:LookUp(value * rotspeed)       
           CameraUpdater:UpdateInheritPitch(value, "DefaultInput")
        end)
    end
end


--점프 조작키 사용시
if IsUseJump then
    DefaultInput:ProcessInputActionEvent("Jump", Enum.KeyInputType.Pressed, function()
        LocalPlayer:Jump()
    end)    
end


--프리캠 조작키
DefaultInput:ProcessInputAxisEvent("FreeCamUpDown", function(value) 
    LocalPlayer:FreeCamMoveUpDown(value)
end)


--카메라 확대&축소 조작키 사용시
if IsUseZoomInOut then
    --PC이면
    if IsMobileTouchScreen == false then 
        DefaultInput:ProcessInputAxisEvent("ZoomInOut", function(value)
            LocalPlayer:ZoomInOut(value)
        end)
    
    --모바일이면
    else
        DefaultInput:ProcessTouchAxisEvent("ZoomInOut_M", function(value)     
            local axisSpeed = 3200.0
            LocalPlayer:ZoomInOut(value * axisSpeed)      
        end)    
    end
end



