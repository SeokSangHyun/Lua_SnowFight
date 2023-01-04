------------------------------------------------------------------------------------------------------------
--플레이어의 SelfCamera를 설정하는 스크립트에요.
------------------------------------------------------------------------------------------------------------

local StateCheck = false
local PreRotation = nil
local PreOffset = nil
local PreFieldOfView = nil
local PreZoom = nil
local PreZoomMin = nil
local PreZoomMax = nil


------------------------------------------------------------------------------------------------------------
--터치스크린 화면인가? 터치스크린이라면 모바일
local IsMobileTouchScreen = Input:IsMobileTouchScreen()



------------------------------------------------------------------------------------------------------------
--셀프카메라 전용 조작키 그룹을 추가해요.
SelfCamInput = Input:AddGroup("SelfCamInput")



------------------------------------------------------------------------------------------------------------
--조작키 이벤트를 등록해요.
if not Script.IsCanMove then 
    --PC 환경에서 사용할 조작키 이벤트
    SelfCamInput:AddAxisKeyEvent("SelfCamTurn", Enum.Key.MouseX, 1)
    SelfCamInput:AddAxisKeyEvent("SelfCamLookUp", Enum.Key.MouseY, -1)
    SelfCamInput:AddAxisKeyEvent("SelfCamZoomInOut", Enum.Key.MouseWheelAxis, -50)
    SelfCamInput:AddActionKeyEvent("SelfCamShoot", Enum.Key.SpaceBar)
    
    --모바일 환경에서 사용할 조작키 이벤트
    SelfCamInput:AddAxisKeyEvent("SelfCamTurn_M", Enum.Key.Touch_ScreenX, 1)
    SelfCamInput:AddAxisKeyEvent("SelfCamLookUp_M", Enum.Key.Touch_ScreenY, 1)
    SelfCamInput:AddAxisKeyEvent("SelfCamZoomInOut_M", Enum.Key.Screen_Pinch, 1)
end

--PC 환경에서 사용할 조작키 이벤트
SelfCamInput:AddActionKeyEvent("SelfCamShoot", Enum.Key.LeftShift)
SelfCamInput:AddActionKeyEvent("SelfCamShoot", Enum.Key.Enter)
SelfCamInput:AddActionKeyEvent("SelfCamExit", Enum.Key.Escape)



------------------------------------------------------------------------------------------------------------
 --조작키를 비활성화해요.
Input:DeactiveGroup("SelfCamInput")



------------------------------------------------------------------------------------------------------------
--조작키 이벤트를 등록해요.

--PC이면
if IsMobileTouchScreen == false then 
    SelfCamInput:ProcessInputAxisEvent("SelfCamTurn", function(value) 
        LocalPlayer:Turn(value)
        CameraUpdater:UpdateInheritYaw(value, "SelfCamInput")
    end)
    
    SelfCamInput:ProcessInputAxisEvent("SelfCamLookUp", function(value)
        LocalPlayer:LookUp(value)
        CameraUpdater:UpdateInheritPitch(value, "SelfCamInput")
    end)
    
    SelfCamInput:ProcessInputAxisEvent("SelfCamZoomInOut", function(value)
        LocalPlayer:ZoomInOut(value)
    end)
    
    SelfCamInput:ProcessInputActionEvent("SelfCamShoot", Enum.KeyInputType.Pressed, function()
        LocalPlayer:TakeSelfCamera()
    end)
        
    SelfCamInput:ProcessInputActionEvent("SelfCamExit", Enum.KeyInputType.Pressed, function()
        LocalPlayer:ExitSelfCamera()
    end) 
    
--모바일이면
else
    SelfCamInput:ProcessTouchAxisEvent("SelfCamTurn_M", function(value)
       local rotspeed = 4.0
       LocalPlayer:Turn(value * rotspeed)   
       CameraUpdater:UpdateInheritYaw(value, "SelfCamInput")  
    end)
    
    SelfCamInput:ProcessTouchAxisEvent("SelfCamLookUp_M", function(value)
       local rotspeed = 4.0
       LocalPlayer:LookUp(value * rotspeed)       
       CameraUpdater:UpdateInheritPitch(value, "SelfCamInput")
    end)
    
    SelfCamInput:ProcessTouchAxisEvent("SelfCamZoomInOut_M", function(value)     
        local axisSpeed = 3200.0
        LocalPlayer:ZoomInOut(value * axisSpeed)      
    end)    
end


------------------------------------------------------------------------------------------------------------
--셀프카메라 상태가 되었을 때 카메라를 설정하고 조작을 변경해요
local function EnterSelfCam()
    
    if StateCheck then
        return
    end
    
    StateCheck = true
    
  --캐릭터의 카메라 위치를 변경해요.
    local Camera = LocalPlayer:GetCurrentCamera() --캐릭터의 카메라를 얻어요.

    if Camera == nil or Camera.Name ~= "MainCamera" then --카메라가 없으면
        print("ScriptClient.DefaultSelfCam 스크립트의 카메라 설정을 확인하세요.")
        return --아래의 로직을 처리하지 않도록 중단해요.
    end 
    
    if Script.UseSelfiePosition then    
        --캐릭터의 이전 카메라 설정 값을 저장해요        
        PreOffset = Camera.SocketOffset
        PreFieldOfView = Camera.FieldOfView
        PreZoom = Camera.Zoom
        PreZoomMin = Camera.ZoomMin
        PreZoomMax = Camera.ZoomMax  
    
        --셀프카메라 설정 값을 사용해요
        Camera.SocketOffset = Script.SelfieOffset
        Camera.FieldOfView = Script.SelfieFOV
        Camera.Zoom = Script.SelfieZoom
        Camera.ZoomMin = Script.SelfieZoom - 50
        Camera.ZoomMax = Script.SelfieZoom + 50
    end    
    
    if Script.UsePlayerView then
        PreRotation = LocalPlayer:GetControlRotation() -- 카메라의 현재 포지션를 저장해요.     
        local Character = LocalPlayer:GetRemotePlayer():GetCharacter() --자신의 캐릭터를 변수에 할당해요.
        local CharacterRotation = Character.Rotation --자신의 캐릭터의 회전값을 얻어요.    
    
        --카메라가 플레이어를 바라보게 변경해요 
        LocalPlayer:SetControlRotation(Vector.new(CharacterRotation.X, CharacterRotation.Z + 180, CharacterRotation.Y))    
        LocalPlayer:ResetIgnoreLookInput() --카메라 조작을 초기화해요
    end
    
    --조작그룹을 변경해요
    if not Script.IsCanMove then
        Input:DeactiveGroup("DefaultInput")
    end
    
    Input:ActiveGroup("SelfCamInput")
    CameraUpdater:SetActiveGroup("SelfCamInput")
    
    
    --모바일이면
    if IsMobileTouchScreen then 
        Input:SetJoystickControlVisibility(0, false)
        Input:SetJoystickControlVisibility(1, false)
    end
end
Game.EnterSelfCamera:Connect(EnterSelfCam)



------------------------------------------------------------------------------------------------------------
--셀프카메라 상태가 끝났을 때 원래대로 되돌려요
local function LeaveSelfCam()

    if not StateCheck then
        return
    end

    --캐릭터의 카메라 위치를 변경해요
    local Camera = LocalPlayer:GetCurrentCamera() --캐릭터의 카메라를 얻어요.
      
    if Camera == nil then --카메라가 없으면
        return --아래의 로직을 처리하지 않도록 중단해요.
    end  
      
    if Script.UseSelfiePosition then    
        --카메라의 설정을 이전값으로 복구해요.      
        Camera.SocketOffset = PreOffset
        Camera.FieldOfView = PreFieldOfView
        Camera.Zoom = PreZoom
        Camera.ZoomMin = PreZoomMin
        Camera.ZoomMax = PreZoomMax
    end
    
    if Script.UsePlayerView then
        LocalPlayer:SetControlRotation(PreRotation) -- 카메라의 포지션을 이전값으로 복구해요.
        LocalPlayer:ResetIgnoreLookInput() --카메라 조작을 초기화해요.
    end
    
    --조작그룹을 변경해요
    Input:DeactiveGroup("SelfCamInput")

    if not Script.IsCanMove then
        Input:ActiveGroup("DefaultInput") 
        CameraUpdater:SetActiveGroup("DefaultInput")
    end

    StateCheck = false
    
    
    --모바일이면
    if IsMobileTouchScreen then 
        Input:SetJoystickControlVisibility(0, true)
        Input:SetJoystickControlVisibility(1, true)
    end
end
Game.LeaveSelfCamera:Connect(LeaveSelfCam)



------------------------------------------------------------------------------------------------------------
--캐릭터가 스폰될 때 예외처리를 설정해요
local function CharacterSpawn(character)    
   LocalPlayer:SetEnableSelfCamera(true) --셀프카메라 버튼을 활성화해요.   

   --셀프카메라 상태이면 셀프카메라를 취소해요
   if LocalPlayer:IsSelfCamera() then
       LocalPlayer:ExitSelfCamera()
       StateCheck = false
   end   
end
Game.OnSpawnCharacter:Connect(CharacterSpawn)



------------------------------------------------------------------------------------------------------------
--캐릭터가 사망했을 떄 예외처리를 설정해요
local function CharacterDeath(character)    
    LocalPlayer:SetEnableSelfCamera(false) --셀프카메라 버튼을 비활성화해요.
    
    --셀프카메라 상태이면 셀프카메라를 취소해요
    if LocalPlayer:IsSelfCamera() then
        LocalPlayer:ExitSelfCamera()
        StateCheck = false
    end   
end
Game.OnDeathCharacter:Connect(CharacterDeath)
