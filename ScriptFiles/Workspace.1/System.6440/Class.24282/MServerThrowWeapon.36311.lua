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

    
    return t
end





--!---------------------------- Getter/Setter ------------------------------
--# 목적 : 
function sTrowModule:GetBulletCount(player)
    return self.NowBulletCount
end





--!---------------------------- 무기 시스템 처리 ------------------------------
--# 목적 : 기본 세팅 값
function sTrowModule:Initialize()
end


return sTrowModule;

