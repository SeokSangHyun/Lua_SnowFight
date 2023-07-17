------------------------------------------------------------------------------------------------------------
-- 오브젝트의 위치나 회전, 크기를 움직일 때 사용할 수 있는 모듈 스크립트에요.
-- 실제로 사용하는건 TweenObject 모듈입니다.
-- Tween 모듈은 TweenObject에서 호출해서 사용하기 위한 모듈입니다.
-- Tween 기능을 원하신다면 TweenObject 모듈을 사용해주세요.
------------------------------------------------------------------------------------------------------------



local Tween = {}
Tween.__index = Tween



local function Linear(time, startV, endV, duration, strength)
   local result = (endV - startV) * (time / duration) + startV
   
   return result
end



local function In(time, startV, endV, duration, strength)
   local result = (endV - startV) * ((time/duration) ^ strength) + startV
   
   return result
end
   
   
   
local function Out(time, startV, endV, duration, strength)
   local result =  Vector.new(-1, -1, -1) * (endV - startV) * (((time/duration - 1) ^ strength) - 1) + startV
   
   return result
end



local function InOut(time, startV, endV, duration, strength)
   time = time / duration * 2
   local result = nil

   if time < 1 then
       result = ((endV - startV) * Vector.new(0.5, 0.5, 0.5)) * (time ^ strength) + startV
   else
       result = (Vector.new(-1, -1, -1) * (endV - startV)) * Vector.new(0.5, 0.5, 0.5) * (((time - 2) ^ strength) - 2) + startV
   end
   
   return result
   
end



local function OutIn(time, startV, endV, duration, strength)
   local result = nil
   if time < duration / 2 then
       result = Out(time * 2, startV, startV + ((endV - startV) * Vector.new(0.5, 0.5, 0.5)), duration, strength)
   else
       result = In((time * 2) - duration, startV + ((endV - startV) * Vector.new(0.5, 0.5, 0.5)), endV, duration, strength)
   end
   
   return result
end



local function Test()
   return Vector.new(0, 0, 0)
end



function Tween.new()
   local self = setmetatable({}, Tween)
   self._Strength = 4
   self._Duration = 0
   self._Playing = false
   self._Time = 0
   self._Duration = 0
   self._Object = nil

   return self
end



function Tween:Start(duration, startPos, endPos, typeName)
   self._Duration = duration
   self._StartPos = startPos
   self._EndPos = endPos
   
   if typeName == "Linear" then
       self._Func = Linear
   elseif typeName == "In" then
       self._Func = In
   elseif typeName == "Out" then
       self._Func = Out
   elseif typeName == "InOut" then
       self._Func = InOut
   elseif typeName == "OutIn" then
       self._Func = OutIn
   else
       self._Func = Linear
   end
   
   self._Time = 0
   
   self._Playing = true

end



function Tween:IsPlaying()
   return self._Playing
end



function Tween:SetStrength(strength)
   self._Strength = strength
end



function Tween:Update(elapsedTime)

   if self._Playing == false then
       return
   end
   
   self._Time = self._Time + elapsedTime
   
   if self._Duration < self._Time then
       self._Playing = false
   end 
   
   if self._Object ~= nil then
       local transform = self._Object.Transform
       local value = self:GetValue()
       transform.Location = Vector.new(value.X, value.Y, value.Z)
       self._Object.Transform = transform
   end
   
end



function Tween:GetValue()

   if self._Time > self._Duration then
       self._Time = self._Duration
   end 
   
   return self._Func(self._Time, self._StartPos, self._EndPos, self._Duration, self._Strength)
end

return Tween



