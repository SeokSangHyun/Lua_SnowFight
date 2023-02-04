
--! ------------------------------ 변수 ------------------------------
KeyInput_Action = nil
local IsMobileTouchScreen = Input:IsMobileTouchScreen()



--! ------------------------------ 조작 키 이벤트 ------------------------------
local function AddKeyEvent()
    --PC 환경에서 사용할 조작키 이벤트
    KeyInput_Action:AddAxisKeyEvent("MoveForward", Enum.Key.W, 1)
    KeyInput_Action:AddAxisKeyEvent("MoveForward", Enum.Key.S, -1)
    KeyInput_Action:AddAxisKeyEvent("MoveRight", Enum.Key.A, -1)
    KeyInput_Action:AddAxisKeyEvent("MoveRight", Enum.Key.D, 1)

    KeyInput_Action:AddAxisKeyEvent("Turn", Enum.Key.MouseX, 1)
    KeyInput_Action:AddAxisKeyEvent("LookUp", Enum.Key.MouseY, -1)

    KeyInput_Action:AddActionKeyEvent("Jump", Enum.Key.SpaceBar)


    --모바일 환경에서 사용할 조작키 이벤트
    KeyInput_Action:AddAxisKeyEvent("MoveForward_M", Enum.Key.Touch_DpadY, 1)
    KeyInput_Action:AddAxisKeyEvent("MoveRight_M", Enum.Key.Touch_DpadX, 1)

    KeyInput_Action:AddAxisKeyEvent("Touch_ScreenX_M", Enum.Key.Touch_ScreenX, 1)
    KeyInput_Action:AddAxisKeyEvent("Touch_ScreenY_M", Enum.Key.Touch_ScreenY, 1)

    KeyInput_Action:AddActionKeyEvent("Jump", Enum.Key.GamePad_Button1)
end



--! ------------------------------ 키 프로세스 세팅 ------------------------------
local function KeyProcessEvent()
--* 이동 처리
    if IsMobileTouchScreen == false then 
        KeyInput_Action:ProcessInputAxisEvent("MoveForward", function(value) 
           LocalPlayer:MoveForward(value)
        end)
        KeyInput_Action:ProcessInputAxisEvent("MoveRight", function(value) 
           LocalPlayer:MoveRight(value)
        end)
    else
        KeyInput_Action:ProcessInputAxisEvent("MoveForward_M", function(value) 
           local moveSpeed = 2.0
           LocalPlayer:MoveForward(value * moveSpeed)
        end)
        KeyInput_Action:ProcessInputAxisEvent("MoveRight_M", function(value) 
           local moveSpeed = 2.0
           LocalPlayer:MoveRight(value * moveSpeed)       
        end)
    end

--* 좌우 회전(X축)
    if IsMobileTouchScreen == false then 
        KeyInput_Action:ProcessInputAxisEvent("Turn", function(value) 
           LocalPlayer:Turn(value)
           CameraUpdater:UpdateInheritYaw(value, "SnowFight")
        end)
    else 
        KeyInput_Action:ProcessTouchAxisEvent("Touch_ScreenX_M", function(value)
           local rotspeed = 4.0
           LocalPlayer:Turn(value * rotspeed)     
           CameraUpdater:UpdateInheritYaw(value, "SnowFight")
        end)
    end


--* 상하 회전(Y축)
    if IsMobileTouchScreen == false then 
        KeyInput_Action:ProcessInputAxisEvent("LookUp", function(value) 
           LocalPlayer:LookUp(value)
           CameraUpdater:UpdateInheritPitch(value, "SnowFight")
        end)
    else
        KeyInput_Action:ProcessTouchAxisEvent("Touch_ScreenY_M", function(value)
           local rotspeed = 4.0
           LocalPlayer:LookUp(value * rotspeed)       
           CameraUpdater:UpdateInheritPitch(value, "SnowFight")
        end)
    end

    KeyInput_Action:ProcessInputActionEvent("Jump", Enum.KeyInputType.Pressed, function()
        LocalPlayer:Jump()
    end)   



end



--! ------------------------------ 인풋 그룹 세팅 ------------------------------
function InputSetting()
    KeyInput_Action = Input:AddGroup("SnowFight")

    AddKeyEvent()

    Input:ActiveGroup("SnowFight")

    KeyProcessEvent()
end











