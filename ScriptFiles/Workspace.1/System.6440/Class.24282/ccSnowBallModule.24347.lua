
cc_SnowBall = {}
cc_SnowBall.__index = cc_SnowBall

--!---------------------------- 초기화 ------------------------------
--# 목적 : 생성시 정보 초기화
function cc_SnowBall.new(object)
    local t = setmetatable({}, cc_SnowBall)
    
    t.WeaponObjects = Game:CreateObject(object, Vector.new(0,0,-5000))
    
-- 기본 공격    
    t.Damage = 8.5
    t.ColdState = 5
    t.Distance = 500
    t.Force = 80000
    
-- 뭉쳐 굴리기
    t.OffsetScale = 1        -- 초당 크기 증가량
    t.OffsetDamage = 0.5     -- 초당 공격력 증가량
    t.MaxTime = 15           -- 게이지 모으는 최대 시간
        
    return t
end



--!---------------------------- 발사 로직 ------------------------------
function cc_SnowBall:FireObject(playerID, forX, forY, forZ)
    --(toy, stPos, endPos, speed, force)
    local character = Game:GetRemotePlayerCharacter(playerID)
    local target = Vector.new(0, 0, 0)
    local stPos = character.Location + Vector.new(forX, forY*40, forZ*50)
    local endPos = stPos + Vector.new(self.Distance * forX, self.Distance * forY-40, self.Distance * forZ-50)
    local target = endPos
    local speed = 10
    local force = Vector.new(self.Force * forX, self.Force * forY, forZ * 6000)
    
    self.WeaponObjects.Mesh.Item.Script.ClientScript:PreFire(playerID, self.WeaponObjects.Mesh.Item, target, stPos, endPos, speed, force)
end



--!---------------------------- 데미지 로직 ------------------------------


return cc_SnowBall;

