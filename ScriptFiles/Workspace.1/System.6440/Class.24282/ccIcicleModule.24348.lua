
--! 해당 클래스는 모든 객체에 공통으로 사용되는 클래스입니다.
--# 안에 있는 프로퍼티들은 
--? 내용
--    오브젝트래퍼런스, 타입을 설정함


cc_Icicle = {}
cc_Icicle.__index = cc_Icicle



--!---------------------------- 초기화 ------------------------------
--# 목적 : 생성시 정보 초기화
function cc_Icicle.new(object)
    local t = setmetatable({}, cc_Icicle)
    
    t.WeaponObjects = Game:CreateObject(object, Vector.new(0,0,-5000))
    
-- 기본 공격    
    t.Damage = 7
    t.ColdState = 40
    t.Distance = 500
    t.Force = 90000
        
    return t
end



--!---------------------------- 발사 로직 ------------------------------
function cc_Icicle:FireObject(playerID, forX, forY, forZ)
--[[
    print(self.WeaponObjects.Mesh.Item.Rotation)
    print(Vector.new(forX, forY, forZ))
    print(Vector.new(math.deg(forX), math.deg(forY), math.deg(forZ)))
]]--
    local item = self.WeaponObjects.Mesh.Item
    local rot = item.Rotation
    rot = Vector.new(0, -90, math.deg(forX) + math.deg(forY))
    item.Rotation = rot


    local character = Game:GetRemotePlayerCharacter(playerID)
    local target = Vector.new(0, 0, 0)
    local stPos = character.Location + Vector.new(10, math.cos(forY)*60, math.sin(forZ)*80)
    local endPos = stPos + Vector.new(self.Distance * forX, self.Distance * forY-40, self.Distance * forZ-50)
    local target = endPos
    local speed = 10
    local force = Vector.new(self.Force * forX, self.Force * forY, forZ * 5000)
    
    self.WeaponObjects.Mesh.Item.Script.ClientScript:PreFire(playerID, item, target, stPos, endPos, speed, force)
end



--!---------------------------- 데미지 로직 ------------------------------
function cc_Icicle:GetDamage(); return self.Damage; end;

return cc_Icicle;

