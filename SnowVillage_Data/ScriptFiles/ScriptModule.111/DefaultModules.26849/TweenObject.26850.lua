------------------------------------------------------------------------------------------------------------
-- 오브젝트의 위치나 회전, 크기를 움직일 때 사용할 수 있는 모듈 스크립트에요.
------------------------------------------------------------------------------------------------------------



local TweenObject = {}
TweenObject.__index = TweenObject

local Tween = require(ScriptModule.DefaultModules.Tween)



-- TweenObject를 생성합니다.
-- ex ) local Tween = TweenObject.new(오브젝트)
-- 이후 Tween 을 통하여 여러 함수들을 이용가능 (즉 new는 필수요소)
function TweenObject.new(object)
   local self = setmetatable({}, TweenObject)
   self._Object = object
   self._TweenMove = nil
   self._TweenRotation = nil
   self._TweenScale = nil
   return self
end



-- Tween의 타입에는 "Linear", "In", "Out", "InOut", "OutIn" 이 존재합니다.
-- 타입의 차이는 선형, 가속->감속, 감속->가속, 가속->감속->가속 등의 효과입니다.



-- 시작지점과 끝지점을 통하여 원하는 방향으로 오브젝트를 움직입니다.
-- StartMove(이동하는데 걸리는 시간, 시작지점, 끝지점, 타입)
function TweenObject:StartMove(duration, startPos, endPos, typeName)
   self._TweenMove = Tween.new()
   self._TweenMove:Start(duration, startPos, endPos, typeName)
end



-- 현재 지점에서 +Vector만큼 오브젝트를 움직입니다.
-- StartMoveLocal(이동하는데 걸리는 시간, 움직일 위치, 타입)
function TweenObject:StartMoveLocal(duration, offsetPos, typeName)
   local t = self._Object.Transform
   local startPos = t.Location
   local endPos = startPos + offsetPos

   self._TweenMove = Tween.new()
   self._TweenMove:Start(duration, startPos, endPos, typeName)
end



-- 시작 각도와 원하는 각도로 오브젝트를 회전시킵니다.
-- StartRotation(회전하는데 걸리는 시간, 시작 각도, 끝 각도, 타입)
function TweenObject:StartRotation(duration, startDegree, endDegree, typeName)
   self._TweenRotation = Tween.new()
   self._TweenRotation:Start(duration, startDegree, endDegree, typeName)
end



-- 현재 각도에서 +Vector 만큼 오브젝트를 회전시킵니다.
-- StartRotationLocal(회전하는데 걸리는 시간, +로 회전할 각도, 타입)
function TweenObject:StartRotationLocal(duration, offsetDegree, typeName)
   local t = self._Object.Transform
   local startDegree = t.Rotation
   local endDegree = startDegree + offsetDegree
       
   self._TweenRotation = Tween.new()
   self._TweenRotation:Start(duration, startDegree, endDegree, typeName)
end



-- 시작 크기와 끝 크기 만큼 오브젝트의 스케일을 조정합니다.
-- StartScale(스케일조정에 걸리는 시간, 시작 크기, 끝 크기, 타입)
function TweenObject:StartScale(duration, startScale, endScale, typeName)
   self._TweenScale = Tween.new()
   self._TweenScale:Start(duration, startScale, endScale, typeName)
end



-- 현재 크기에서 +Vector 만큼 오브젝트의 스케일을 조정합니다.
-- StartScaleLocal(스케일조정에 걸리는 시간, +로 스케일할 값, 타입)
function TweenObject:StartScaleLocal(duration, offsetScale, typeName)
   local t = self._Object.Transform
   local startScale = t.ScaleXYZ
   local endScale = startScale + offsetScale
   
   self._TweenScale = Tween.new()
   self._TweenScale:Start(duration, startScale, endScale, typeName)
end



-- 현재 Tween 이 플레이중인지 확인할 수 있습니다.
-- 이동, 회전, 스케일조정 중 어느하라도 진행중이면 true 반환
function TweenObject:IsPlaying()
   if self._TweenMove ~= nil and self._TweenMove:IsPlaying() then
       return true
   elseif self._TweenRotation ~= nil and self._TweenRotation:IsPlaying() then
       return true
   elseif self._TweenScale ~= nil and self._TweenScale:IsPlaying() then
       return true
   else
       return false
   end
end



-- Tween 함수의 계산식의 n승을 조정합니다.
-- strength 에 따라 타입의 효과에 따른 속도의 변화가 가능합니다.
-- ex ) 가속 (3초) -> 감속 (3초) 에서 가속 (4초) -> 감속 (2초) 등으로 변화
-- Default는 4
function TweenObject:SetStrength(strength)
   if self._TweenMove ~= nil then
       self._TweenMove:SetStrength(strength)
   end
   
   if self._TweenRotation ~= nil then
       self._TweenRotation:SetStrength(strength)
   end
   
   if self._TweenScale ~= nil then
       self._TweenScale:SetStrength(strength)
   end
end



-- 위에서 지정한 Move, Rotation, Scale 함수를 Update를 통하여 실행하여 줍니다.
-- UpdateEvent 함수에 넣어서 호출해줘야합니다. (호출안하면 진행안됨)
-- Update(Update시간)
function TweenObject:Update(elapsedTime)
   
   if self._TweenMove ~= nil then
       self._TweenMove:Update(elapsedTime)
       
       if self._Object ~= nil then
           local transform = self._Object.Transform
           local value = self._TweenMove:GetValue()
           transform.Location = Vector.new(value.X, value.Y, value.Z)
           self._Object.Transform = transform
       end
       
       if self._TweenMove:IsPlaying() == false then
           self._TweenMove = nil
       end
   end
   
   
   if self._TweenRotation ~= nil then
       self._TweenRotation:Update(elapsedTime)
       
       if self._Object ~= nil then
           local transform = self._Object.Transform
           local rotation = self._TweenRotation:GetValue()
           transform.Rotation = Vector.new(rotation.X, rotation.Y, rotation.Z)
           self._Object.Transform = transform
       end
       
       if self._TweenRotation:IsPlaying() == false then
           self._TweenRotation = nil
       end
   end

   if self._TweenScale ~= nil then
       self._TweenScale:Update(elapsedTime)
       
       if self._Object ~= nil then
           local transform = self._Object.Transform
           local scale = self._TweenScale:GetValue()
           transform.ScaleXYZ = Vector.new(scale.X, scale.Y, scale.Z)
           self._Object.Transform = transform
       end
       
       if self._TweenScale:IsPlaying() == false then
           self._TweenScale = nil
       end
   end

end

return TweenObject



