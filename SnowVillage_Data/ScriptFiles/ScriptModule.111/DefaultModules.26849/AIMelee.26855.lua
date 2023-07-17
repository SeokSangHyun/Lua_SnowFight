------------------------------------------------------------------------------------------------------------
-- 오브젝트에게 AI를 부여하고 탐색과 이동, 공격을 수행할 수 있게 하는 모듈 스크립트에요.
------------------------------------------------------------------------------------------------------------



local AIMelee = {}
AIMelee.__index = AIMelee



local Utility = require(ScriptModule.DefaultModules.Utility)



local StateDef = 
{
   NON = 0,
   SEARCH = 1,
   MOVE = 2,
   MELEE_ATTACK = 4
}



-- new를 통하여 AIMelee 객체를 생성합니다.
-- ex ) local AI = AIMelee.new()
-- AI를 통하여 모듈함수들을 사용합니다.
function AIMelee.new()
   local self = setmetatable({}, AIMelee)
   
   return self
end



-- AIMelee의 속성들을 초기화하여 줍니다.
-- Initialize(조종할 AI, 감지 거리, 공격 거리, 움직임 속도, 회전 속도, 공격간 딜레이, 공격함수)
function AIMelee:Initialize(owner, checkRange, attackRange, moveSpeed, rotationSpeed, attackDelay, attackFunc)
    self._Owner = owner
    self._Target = nil
    self._State = StateDef.SEARCH
    self._CheckRange = checkRange
    self._AttackRange = attackRange
    self._MoveSpeed = moveSpeed
    self._RotationSpeed = rotationSpeed
    self._AttackDelay = attackDelay
    self._CurrentAttackDelay = 0
    self._MoveDir = Vector.new(1, 0, 0)
    self._DelayTime = 0
    self._AttackFunc = attackFunc
end



-- 해당 AI를 타겟 방향으로 일정 각도만큼 회전시킵니다.
-- RotateXY(해당 AI, 타겟, 원하는 각도)
local function RotateXY(owner, target, degrees)
   if target == nil then
       return
   end
   
   local ownerTransform = owner.Transform
   local targetTransform = target.Transform
   
   local ownerDir = ownerTransform:GetForward()
   ownerDir.Z = 0
   ownerDir:Normalize()
   
   local targetDir = targetTransform.Location - ownerTransform.Location
   targetDir.Z = 0
   targetDir:Normalize()
   
   local rightDir = Vector.new(targetDir.Y, -targetDir.X, 0)
   
   local dot = Utility:DotProduct(rightDir, ownerDir)
   
   if dot > 0 then
       degrees = -degrees
   end
   
   ownerTransform:AddRotation(0, 0, degrees)  
           
   owner.Transform = ownerTransform
end



-- 설정된 AI 세팅을 Update를 통하여 실행시켜줍니다.
-- UpdateEvent함수에서 호출해주는게 좋습니다.
-- Update(Update시간)
function AIMelee:Update(ElapsedTime)

   if self._Owner == nil then
       print("Error. Owner nil!")
   end     

   if self._Owner.HP <= 0 then
       return
   end
   
   if self._State == StateDef.SEARCH then
   
       if self._DelayTime <= 0 then
           self._Target = Utility:ScanPlayerCharacter(self._Owner.Location, self._CheckRange)
           if self._Target == nil then
               -- search every 1 second
               self._DelayTime = 1 
           else
               self._State = StateDef.MOVE
           end
       end
       
       self._DelayTime = self._DelayTime - ElapsedTime
       
   elseif self._State == StateDef.MOVE then
       -- Need Rotation       
       RotateXY(self._Owner, self._Target, self._RotationSpeed * ElapsedTime)
   
       if self._Target == nil then
           self._State = StateDef.SEARCH
       else
           local t = self._Owner.Transform
           local targetPos = self._Target.Location
           local ownerPos = t.Location
           
           if Utility:VecDistance(ownerPos, targetPos) < self._AttackRange then
               self._State = StateDef.MELEE_ATTACK
               self._CurrentAttackDelay = self._AttackDelay
           else        
               local dir = targetPos - ownerPos
               dir:Normalize()
           
               local newPos = ownerPos + dir * ElapsedTime * self._MoveSpeed
               
               t.Location = Vector.new(newPos.X, newPos.Y, newPos.Z) 
           
               self._Owner.Transform = t
           end             
       end

   elseif self._State == StateDef.MELEE_ATTACK then
   
       RotateXY(self._Owner, self._Target, self._RotationSpeed * ElapsedTime)
       
       if self._CurrentAttackDelay <= 0 then
           if self._AttackFunc ~= nil then
               self._AttackFunc(self._Owner, self._Target)
           end            
            
            self._CurrentAttackDelay = self._AttackDelay
       end
       
       self._CurrentAttackDelay = self._CurrentAttackDelay - ElapsedTime
       
       if self._Target == nil then
           self._State = StateDef.SEARCH
       else            
           local ownerPos = self._Owner.Location
           local targetPos = self._Target.Location
           
           if Utility:VecDistance(ownerPos, targetPos) > self._AttackRange then    
               self._State = StateDef.MOVE 
           end 
       end
   end
end

return AIMelee
