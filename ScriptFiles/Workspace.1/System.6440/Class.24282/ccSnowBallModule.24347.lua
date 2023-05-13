
cc_SnowBall = {}
cc_SnowBall.__index = cc_SnowBall

--!---------------------------- 초기화 ------------------------------
--# 목적 : 생성시 정보 초기화
function cc_SnowBall.new(object)
    local t = setmetatable({}, cc_SnowBall)
    
    t.WeaponObjects = Game:CreateObject(object, Vector.new(0,0,-5000))
    t.WeaponThrowObject = nil

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


--!---------------------------- Getter/Setter ------------------------------


--# 목적 : 아이템 획득
function cc_SnowBall:GetBulletCount()
    return 
end



--!---------------------------- 발사 로직 ------------------------------
--# 아이템 발사 전 처리
function cc_SnowBall:PreFireObject(playerID, forX, forY, forZ)
end

--# 목적 : 아이템 발사
function cc_SnowBall:FireObject(playerID, forX, forY, forZ)
    --(toy, stPos, endPos, speed, force)
    local character = Game:GetRemotePlayerCharacter(playerID)
    local player = character:GetPlayer()
    
    local target = Vector.new(0, 0, 0)
    local targetItem = player:GetEquipItem("Gloves_slot")
    
    local stPos = targetItem.Location + Vector.new(forX, forY*40, forZ*50)
    local endPos = stPos + Vector.new(self.Distance * forX, self.Distance * forY-40, self.Distance * forZ-50)
    local target = endPos
    local speed = 10
    local force = Vector.new(self.Force * forX, self.Force * forY, forZ * 6000)
    
    self.WeaponObjects:BulletObjectFire(playerID, self.WeaponObjects, target, stPos, endPos, speed, force)
end



--!---------------------------- 데미지 로직 ------------------------------
function cc_SnowBall:GetDamage(); return self.Damage; end;



return cc_SnowBall;

