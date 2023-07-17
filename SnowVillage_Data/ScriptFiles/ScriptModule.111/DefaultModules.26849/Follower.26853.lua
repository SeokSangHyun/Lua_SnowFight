------------------------------------------------------------------------------------------------------------
-- 오브젝트가 특정 대상을 따라 움직이게 할 때  사용할 수 있는 모듈 스크립트에요.
------------------------------------------------------------------------------------------------------------



local Follower = {}
Follower.__index = Follower

local Utility = require(ScriptModule.DefaultModules.Utility)



-- Follwer의 객체를 new를 통하여 생성합니다.
-- ex) local Follow = Follower.new()
-- Follow를 통하여 함수를 사용해야합니다.
function Follower.new()
   local self = setmetatable({}, Follower)

   self._My = nil
   self._Target = nil
   self._Finish = false
   self._CurrentTime = 0
   self._CheckRange = 0
   self._CollisionRange = 0
   self._Move = false
   self._MaxSpeed = 0
   self._AccelSpeed = 0
   self._Speed = 0   
   
   --print("Follower new")
   
   return self
end



-- Follower 를 세팅하는 함수입니다. (실행은 Update를 통하여 실행)
-- Start(자기 자신, 타깃, 체크할 거리, 충돌체크 거리, 이동 속도)
function Follower:Start(my, target, checkRange, collisionRange, speed)
   --print("Follower Start")

   self._My = my
   self._Target = target
   self._CheckRange = checkRange
   self._CollisionRange = collisionRange
   self._MaxSpeed = speed
   self._AccelSpeed = speed / 10
   self._Speed = 0
   self._CurrentTime = 0
   self._Move = false
end



-- 현재 설정된 Follower의 타겟을 변경합니다.
-- SetTarget(타겟)
function Follower:SetTarget(target)
   self._Target = target
end



-- 현재 Follower가 진행중인지 종료되었는지 반환합니다.
function Follower:IsFinished()
   return self._Finish
end



-- 설정된 Follower를 Update하여 진행시킵니다.
-- UpdateEvent의 함수를 통하여 호출해줘야합니다.
-- Follower:Update()를 호출하지않으면 진행이되지않습니다.
function Follower:Update()
   if self._Finish == true then
       return
   end
   
   if self._Target == nil then
       return
   end
   
   local time = time()
   local timeElapse = time - self._CurrentTime
   
   if timeElapse < 1/30 then
       return
   end     
       
   local myPosition = self._My.Location
   local targetPosition = self._Target.Location
   
   if self._Move == true then
       self._Speed = self._Speed + self._AccelSpeed
       if self._Speed > self._MaxSpeed then
           self._Speed = self._MaxSpeed
       end
       
       local dir = targetPosition - myPosition
       dir:Normalize(0)
       
       dir = dir * self._Speed
       dir = dir * timeElapse
       
       myPosition = myPosition + dir
       
       local myTransform = self._My.Transform
       myTransform.Location = myPosition
       self._My.Transform = myTransform
       
       local distance = Utility:VecDistance(myPosition, targetPosition)
       
       if distance < 50 then
           self._Finish = true
       end

   else
       local distance = Utility:VecDistance(myPosition, targetPosition)
       
       if distance < self._CheckRange then
           self._Move = true
       end
   end


   self._CurrentTime = time
end

return Follower

