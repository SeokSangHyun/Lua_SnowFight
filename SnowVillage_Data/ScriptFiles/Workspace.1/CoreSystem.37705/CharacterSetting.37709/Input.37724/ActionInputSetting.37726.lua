--! ------------------------------ 변수 선언 ------------------------------
ActionInput = nil
local IsMobileTouchScreen = Input:IsMobileTouchScreen()



--! ------------------------------ 조작 세팅 ------------------------------
local function InputAddKeyEvent()
    
    --PC 환경에서 사용할 조작키 이벤트
    ActionInput:AddAxisKeyEvent("MoveForward", Enum.Key.W, 1)
    ActionInput:AddAxisKeyEvent("MoveForward", Enum.Key.S, -1)
    ActionInput:AddAxisKeyEvent("MoveRight", Enum.Key.A, -1)
    ActionInput:AddAxisKeyEvent("MoveRight", Enum.Key.D, 1)
--[[
    ActionInput:AddAxisKeyEvent("Turn", Enum.Key.A, -1)
    ActionInput:AddAxisKeyEvent("Turn", Enum.Key.D, 1)
]]--
    ActionInput:AddAxisKeyEvent("Turn", Enum.Key.MouseX, 1)
    ActionInput:AddAxisKeyEvent("LookUp", Enum.Key.MouseY, -1)
    ActionInput:AddActionKeyEvent("Jump", Enum.Key.SpaceBar)
    
    
    --모바일 환경에서 사용할 조작키 이벤트
    ActionInput:AddAxisKeyEvent("MoveForward_M", Enum.Key.Touch_DpadY, 1)
    ActionInput:AddAxisKeyEvent("MoveRight_M", Enum.Key.Touch_DpadX, 1)
    ActionInput:AddAxisKeyEvent("Touch_ScreenX_M", Enum.Key.Touch_ScreenX, 1)
    ActionInput:AddAxisKeyEvent("Touch_ScreenY_M", Enum.Key.Touch_ScreenY, 1)
    ActionInput:AddActionKeyEvent("Jump", Enum.Key.GamePad_Button1)
end


--! ------------------------------ 조작 세팅 ------------------------------
local function InputProcessEvent()
    --이동 조작키 사용시
    if IsMobileTouchScreen == false then 
        ActionInput:ProcessInputAxisEvent("MoveForward", function(value) 
            LocalPlayer:MoveForward(value)
        end)
        
        ActionInput:ProcessInputAxisEvent("MoveRight", function(value) 
           LocalPlayer:MoveRight(value)
        end)
    else
        ActionInput:ProcessInputAxisEvent("MoveForward_M", function(value) 
            local moveSpeed = 2.0
            LocalPlayer:MoveForward(value * moveSpeed)
        end)
        
        ActionInput:ProcessInputAxisEvent("MoveRight_M", function(value) 
            local moveSpeed = 2.0
            LocalPlayer:MoveRight(value * moveSpeed)       
        end)
    end
    
    
    --카메라 좌우 조작키 사용시
    if IsMobileTouchScreen == false then 
        ActionInput:ProcessInputAxisEvent("Turn", function(value) 
           LocalPlayer:Turn(value)
           CameraUpdater:UpdateInheritYaw(value, "ActionInput")
        end)
    else 
        ActionInput:ProcessTouchAxisEvent("Touch_ScreenX_M", function(value)
            local rotspeed = 4.0
            LocalPlayer:Turn(value * rotspeed)     
           CameraUpdater:UpdateInheritYaw(value, "ActionInput")
        end)
    end

    
    --카메라 상하 조작키 사용시
    if IsMobileTouchScreen == false then 
        ActionInput:ProcessInputAxisEvent("LookUp", function(value) 
            LocalPlayer:LookUp(value)
            CameraUpdater:UpdateInheritPitch(value, "ActionInput")
        end)
    else
        ActionInput:ProcessTouchAxisEvent("Touch_ScreenY_M", function(value)
            local rotspeed = 4.0
            LocalPlayer:LookUp(value * rotspeed)       
            CameraUpdater:UpdateInheritPitch(value, "ActionInput")
        end)
    end
    

    --점프 조작키 사용시
    ActionInput:ProcessInputActionEvent("Jump", Enum.KeyInputType.Pressed, function()
        LocalPlayer:Jump()
    end)
    
    
    
--# =====  공격 키 입력
    -- 키를 눌렀을 때
    DefaultInput:ProcessInputActionEvent("Act", Enum.KeyInputType.Pressed, function()
            -- 각 공격 버튼에서 처리
            CheckFire()
            --IsOnKey = true
        end)   
    
    -- 키를 누르고 있을 때
    DefaultInput:ProcessInputActionEvent("Act", Enum.KeyInputType.Repeat, function()
            --여긴 처리하지 않음
            --IsOnKey = false
        end)  
    
    -- 키를 땠을 때
    DefaultInput:ProcessInputActionEvent("Act", Enum.KeyInputType.Released, function()
            --실제 공격 발사
            --StartFire()
        end)  
    --! ------------------------------  ------------------------------
    
    
end



--! ------------------------------ 조작 세팅 ------------------------------
local InputSetting = function()
    --조작키 그룹을 추가해요.
    ActionInput = Input:AddGroup("ActionInput")
    
    --모바일용 버튼 표시 및 위치 설정
    Input:SetJoystickControlVisibility(0, true)
    Input:SetPadCenter(0, 160, -100)
    Input:SetJoystickControlVisibility(1, true)
    Input:SetPadCenter(1, -50, -85)

    InputAddKeyEvent()
    
    

     --조작키를 활성화해요.
    --Input:ActiveGroup("ActionInput")
    
    InputProcessEvent()
end
InputSetting()


--g_InputGroup["ActionInput"] = InputSetting


