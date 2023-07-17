------------------------------------------------------------------------------------------------------------
--캐릭터 스폰시 카메라를 설정하는 스크립트에요.
------------------------------------------------------------------------------------------------------------

local InputMode = Script.InputMode
local IsSetCamRotation = Script.IsSetCamRotation

------------------------------------------------------------------------------------------------------------
--캐릭터 스폰시 카메라를 설정하는 함수에요.
local function Spawn(character) --OnSpawnCharacter로 연결된 함수는 character 인자가 고정적으로 들어가요.

  local remoteCharacter = LocalPlayer:GetRemotePlayer():GetCharacter() --자신의 캐릭터를 변수에 할당해요.
  if character == nil or remoteCharacter == nil or character ~= remoteCharacter then  --캐릭터가 없거나, 자신의 캐릭터가 아니면
    return --아래의 로직을 처리하지 않도록 중단해요.
  end
  
  --캐릭터의 기본 카메라를 설정해요.
  local sourceCamera = Workspace.MainCamera
  local newCamera = LocalPlayer:SetCurrentCamera(sourceCamera) --캐릭터에 카메라를 설정해요.

  if newCamera == nil then --카메라가 없으면
    return --아래의 로직을 처리하지 않도록 중단해요.
  end

  LocalPlayer:ResetIgnoreLookInput() --카메라 조작을 초기화해요.
  newCamera.Parent = remoteCharacter --카메라의 부모 오브젝트를 캐릭터로 설정해요.
  newCamera:SetLookAtTarget(nil) --카메라가 바라보는 대상을 설정해요.

  --카메라의 회전값을 설정해요.
  if IsSetCamRotation then
      local CameraRotation = sourceCamera.Rotation
      local CharacterRotation = remoteCharacter.Rotation
      LocalPlayer:SetControlRotation(Vector.new(0, CameraRotation.Z + CharacterRotation.Z, 0))
   end
end
Game.OnSpawnCharacter:Connect(Spawn) --Game에 캐릭터가 생성되면 호출되는 함수를 연결해요.



------------------------------------------------------------------------------------------------------------
--플레이어의 마우스 처리를 설정해요.
if InputMode == 1 then
    LocalPlayer:SetInputMode(Enum.InputMode.Game)
elseif InputMode == 2 then 
    LocalPlayer:SetInputMode(Enum.InputMode.UI)
elseif InputMode == 3 then 
    LocalPlayer:SetInputMode(Enum.InputMode.GameAndUI)
else                      
    LocalPlayer:SetInputMode(Enum.InputMode.Game)
end
    