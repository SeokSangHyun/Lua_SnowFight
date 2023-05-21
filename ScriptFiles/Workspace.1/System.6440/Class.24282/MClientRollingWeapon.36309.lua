--! 해당 클래스는 모든 객체에 공통으로 사용되는 클래스입니다.
--# 안에 있는 프로퍼티들은 

cRollingModule = {}
cRollingModule.__index = cRollingModule



--!---------------------------- 초기화 ------------------------------
--# 목적 : 생성시 정보 초기화
function cRollingModule.new(object)
    local t = setmetatable({}, cRollingModule)
    
    
    t.WeaponObject = object

    
    return t
end





--!---------------------------- Getter/Setter ------------------------------
--# 목적 : 
function cRollingModule:GetBulletCount(player)
    return self.NowBulletCount
end





--!---------------------------- 무기 시스템 처리 ------------------------------
--# 목적 : 기본 세팅 값
function cRollingModule:Initialize()
end





return cRollingModule;

--[[

sc_SnowBall = {}
sc_SnowBall.__index = sc_SnowBall

local Utility = require(ScriptModule.DefaultModules.Utility)

--!---------------------------- 초기화 ------------------------------
--# 목적 : 생성시 정보 초기화
function sc_SnowBall.new(object)
    local t = setmetatable({}, sc_SnowBall)
    
    t.WeaponObject = object
    t.BulletSpeed = object.BulletSpeed
    t.BulletDistance = object.BulletDistance
    t.InvenIndex = 1
    
    t.OneTurnBulletCount = 30
    t.NowBulletCount = 30
    
    return t
end


--!---------------------------- Getter/Setter ------------------------------
--# 목적 : 
function sc_SnowBall:GetBulletCount(player)
    return self.NowBulletCount
end






--!---------------------------- 아이템 획득/사용 처리 ------------------------------
--# 목적 : 아이템을 획득하면 인벤토리에 추가하는처리
--? 내용 : 아이템을 획득하는 처리
function sc_SnowBall:GetItem(player)
    self.NowBulletCount = self.NowBulletCount + self.OneTurnBulletCount
    return self.NowBulletCount
end



--# 목적 : 아이템을 사용하는 처리
function sc_SnowBall:UseItem(num)
    if (self.NowBulletCount) >= 1 then
        self.NowBulletCount = self.NowBulletCount - 1
        --Game:SendEventToClient(player:GetPlayerID(), "BulletFire", player, self.InvenIndex)
        return true
    else
        self.NowBulletCount = 0
        --player:GetCharacter():DetachObject(self.WeaponObject)
        return false
    end
end



    



--# 목적 : 종료 시 처리
function sc_SnowBall:FinishSystem()
end

return sc_SnowBall;
]]--

