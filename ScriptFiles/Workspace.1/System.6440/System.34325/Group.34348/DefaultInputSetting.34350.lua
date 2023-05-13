--! ------------------------------ 변수 선언 ------------------------------
NormalInput = nil
local IsMobileTouchScreen = Input:IsMobileTouchScreen()



--! ------------------------------ 조작 세팅 ------------------------------
local function InputAddKeyEvent()
    
    --PC 환경에서 사용할 조작키 이벤트
    NormalInput:AddAxisKeyEvent("MoveForward", Enum.Key.W, 1)
    NormalInput:AddAxisKeyEvent("MoveForward", Enum.Key.S, -1)
    NormalInput:AddAxisKeyEvent("MoveRight", Enum.Key.A, -1)
    NormalInput:AddAxisKeyEvent("MoveRight", Enum.Key.D, 1)
    NormalInput:AddAxisKeyEvent("Turn", Enum.Key.MouseX, 1)
    NormalInput:AddAxisKeyEvent("LookUp", Enum.Key.MouseY, -1)
    NormalInput:AddActionKeyEvent("Jump", Enum.Key.SpaceBar)
    
    
    --모바일 환경에서 사용할 조작키 이벤트
    NormalInput:AddAxisKeyEvent("MoveForward_M", Enum.Key.Touch_DpadY, 1)
    NormalInput:AddAxisKeyEvent("MoveRight_M", Enum.Key.Touch_DpadX, 1)
    NormalInput:AddAxisKeyEvent("Touch_ScreenX_M", Enum.Key.Touch_ScreenX, 1)
    NormalInput:AddAxisKeyEvent("Touch_ScreenY_M", Enum.Key.Touch_ScreenY, 1)
    NormalInput:AddActionKeyEvent("Jump", Enum.Key.GamePad_Button1)
end


--! ------------------------------ 조작 세팅 ------------------------------
local function InputProcessEvent()
    --이동 조작키 사용시
    if IsMobileTouchScreen == false then 
        NormalInput:ProcessInputAxisEvent("MoveForward", function(value) 
            LocalPlayer:MoveForward(value)
        end)
        
        NormalInput:ProcessInputAxisEvent("MoveRight", function(value) 
           LocalPlayer:MoveRight(value)
        end)
    else
        NormalInput:ProcessInputAxisEvent("MoveForward_M", function(value) 
            local moveSpeed = 2.0
            LocalPlayer:MoveForward(value * moveSpeed)
        end)
        
        NormalInput:ProcessInputAxisEvent("MoveRight_M", function(value) 
            local moveSpeed = 2.0
            LocalPlayer:MoveRight(value * moveSpeed)       
        end)
    end
    
    
    --카메라 좌우 조작키 사용시
    if IsMobileTouchScreen == false then 
        NormalInput:ProcessInputAxisEvent("Turn", function(value) 
           LocalPlayer:Turn(value)
           CameraUpdater:UpdateInheritYaw(value, "NormalInput")
        end)
    else 
        NormalInput:ProcessTouchAxisEvent("Touch_ScreenX_M", function(value)
            local rotspeed = 4.0
            LocalPlayer:Turn(value * rotspeed)     
           CameraUpdater:UpdateInheritYaw(value, "NormalInput")
        end)
    end

    
    --카메라 상하 조작키 사용시
    if IsMobileTouchScreen == false then 
        NormalInput:ProcessInputAxisEvent("LookUp", function(value) 
            LocalPlayer:LookUp(value)
            CameraUpdater:UpdateInheritPitch(value, "NormalInput")
        end)
    else
        NormalInput:ProcessTouchAxisEvent("Touch_ScreenY_M", function(value)
            local rotspeed = 4.0
            LocalPlayer:LookUp(value * rotspeed)       
            CameraUpdater:UpdateInheritPitch(value, "NormalInput")
        end)
    end
    

    --점프 조작키 사용시
    NormalInput:ProcessInputActionEvent("Jump", Enum.KeyInputType.Pressed, function()
        LocalPlayer:Jump()
    end)
end



--! ------------------------------ 조작 세팅 ------------------------------
local InputSetting = function()
    --조작키 그룹을 추가해요.
    NormalInput = Input:AddGroup("NormalInput")
    
    --모바일용 버튼 표시 및 위치 설정
    Input:SetJoystickControlVisibility(0, true)
    Input:SetPadCenter(0, 160, -100)
    Input:SetJoystickControlVisibility(1, true)
    Input:SetPadCenter(1, -50, -85)

    InputAddKeyEvent()
    
    

     --조작키를 활성화해요.
    --Input:ActiveGroup("NormalInput")
    
    InputProcessEvent()
end
InputSetting()


--g_InputGroup["ActionInput"] = InputSetting


