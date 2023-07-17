




--! ------------------------------ 카메라 ------------------------------
--# -----목적 : targetCam으로 변환하는 함수
function ChangeCamera(targetCam, targetObj)
    local remoteCharacter = LocalPlayer:GetRemotePlayer():GetCharacter()
    local newCamera = LocalPlayer:SetCurrentCamera(targetCam)
    
    newCamera.Parent = targetObj
    newCamera:SetLookAtTarget(nil)        --카메라가 바라보는 대상을 설정해요.
end





--# -----목적 : 다시 MainCamera로 변경하는 함수
--                캐릭터의 기본 카메라를 설정해요.
function InitCamera()
    local remoteCharacter = LocalPlayer:GetRemotePlayer():GetCharacter()
    local sourceCamera = Workspace.MainCamera
    local newCamera = LocalPlayer:SetCurrentCamera(sourceCamera)
    
    if newCamera == nil then;    return;    end;
    
    newCamera.Parent = remoteCharacter    --카메라의 부모 오브젝트를 캐릭터로 설정해요.
    newCamera:SetLookAtTarget(nil)        --카메라가 바라보는 대상을 설정해요.
    
--[[
    --카메라의 회전값을 설정해요.
    if IsSetCamRotation then
      local CameraRotation = sourceCamera.Rotation
      local CharacterRotation = remoteCharacter.Rotation
      LocalPlayer:SetControlRotation(Vector.new(0, CameraRotation.Z + CharacterRotation.Z, 0))
    end
]]--
end






