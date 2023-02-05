
--! 해당 클래스는 모든 객체에 공통으로 사용되는 클래스입니다.
--# 안에 있는 프로퍼티들은 
--? 내용
--    오브젝트래퍼런스, 타입을 설정함


cc_SnowCrystal = {}
cc_SnowCrystal.__index = cc_SnowCrystal



--!---------------------------- 초기화 ------------------------------
--# 목적 : 생성시 정보 초기화
function cc_SnowCrystal.new(object)
    local t = setmetatable({}, cc_SnowCrystal)
    
    t.WeaponObjects = Game:CreateObject(object, Vector.new(0,0,-5000))
    
-- 기본 공격    
    t.Damage = 1
    t.ColdState = 100
    t.Distance = 500
    t.Force = 80000
        
    return t
end



--!---------------------------- 발사 로직 ------------------------------
function cc_SnowCrystal:FireObject(playerID, forX, forY, forZ)
    --(toy, stPos, endPos, speed, force)
    local character = Game:GetRemotePlayerCharacter(playerID)
    local target = Vector.new(0, 0, 0)
    local stPos = character.Location + Vector.new(forX, forY*40, forZ*50)
    local endPos = stPos + Vector.new(self.Distance * forX, self.Distance * forY-40, self.Distance * forZ-50)
    local target = endPos
    local speed = 10
    local force = Vector.new(self.Force * forX, self.Force * forY, forZ * 5000)
    
    self.WeaponObjects:PreFire(playerID, self.WeaponObjects, target, stPos, endPos, speed, force)
end



--!---------------------------- 데미지 로직 ------------------------------
function cc_SnowCrystal:GetDamage(); return self.Damage; end;




return cc_SnowCrystal;

