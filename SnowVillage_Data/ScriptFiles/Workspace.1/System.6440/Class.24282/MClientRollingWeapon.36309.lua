--! 해당 클래스는 모든 객체에 공통으로 사용되는 클래스입니다.
--# 안에 있는 프로퍼티들은 

cRollingModule = {}
cRollingModule.__index = cRollingModule



--!---------------------------- 초기화 ------------------------------
--# 목적 : 생성시 정보 초기화
function cRollingModule.new(object)
    local t = setmetatable({}, cRollingModule)

    t.WeaponObject = object
    t.RollingStartTime = 0

    return t
end





--!---------------------------- Getter/Setter ------------------------------
--# 목적 : 
function cRollingModule:GetBulletCount(player)
    return self.NowBulletCount
end


function cRollingModule:TimeDelta()
    return time() - self.RollingStartTime
end






--!---------------------------- 무기 시스템 처리 ------------------------------
--# 목적 : 기본 세팅 값
function cRollingModule:Initialize()
    self.RollingStartTime = time()
    
end





return cRollingModule;






