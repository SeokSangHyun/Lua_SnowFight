--! 해당 클래스는 모든 객체에 공통으로 사용되는 클래스입니다.
--# 안에 있는 프로퍼티들은 

sTrowModule = {}
sTrowModule.__index = sTrowModule



--!---------------------------- 초기화 ------------------------------
--# 목적 : 생성시 정보 초기화
function sTrowModule.new(playerID, object)
    local t = setmetatable({}, sTrowModule)
    
    
    t.WeaponObject = object
    t.playerID = playerID
    
    t.BulletCount = 0
    t.BulletMaxCount = 1000

    
    return t
end





--!---------------------------- Getter/Setter ------------------------------
--# 목적 : 
function sTrowModule:AddBullet(num)
    if self.BulletCount >= self.BulletMaxCount then;    return; end;
    self.BulletCount = self.BulletCount + num
    
    return self.BulletCount
end

function sTrowModule:GetBullet()
    return self.BulletCount
end

function sTrowModule:CheckFire()
    if self.BulletCount <= 0 then;  return false;
    else;   return true;    end;
end






--!---------------------------- 무기 시스템 처리 ------------------------------
--# 목적 : 기본 세팅 값
function sTrowModule:Initialize()
    self.BulletCount = 0
end


return sTrowModule;

