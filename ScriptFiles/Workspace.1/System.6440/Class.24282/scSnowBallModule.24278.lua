
sc_SnowBall = {}
sc_SnowBall.__index = sc_SnowBall

--!---------------------------- 초기화 ------------------------------
--# 목적 : 생성시 정보 초기화
function sc_SnowBall.new(object)
    local t = setmetatable({}, sc_SnowBall)
    
    t.WeaponObject = object
    t.InvenIndex = 1
    
    t.OneTurnBulletCount = 30
    t.NowBulletCount = 0
    
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
function sc_SnowBall:UseItem(player)
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


--!---------------------------- 무기 시스템 처리 ------------------------------
--# 목적 : 기본 세팅 값
function sc_SnowBall:Initialize()
end


--# 목적 : 초기화 검사
function sc_SnowBall:CheckInitialize()
end


--# 목적 : 종료 시 처리
function sc_SnowBall:FinishSystem()
end

return sc_SnowBall;

