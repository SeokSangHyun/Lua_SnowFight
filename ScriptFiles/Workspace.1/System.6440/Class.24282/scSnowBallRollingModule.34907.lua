
--! 해당 클래스는 모든 객체에 공통으로 사용되는 클래스입니다.
--# 안에 있는 프로퍼티들은 
--? 내용
--    오브젝트래퍼런스, 타입을 설정함


sc_SnowBallRolling = {}
sc_SnowBallRolling.__index = sc_SnowBallRolling

--!---------------------------- 초기화 ------------------------------
--# 목적 : 생성시 정보 초기화
function sc_SnowBallRolling.new(object)
    local t = setmetatable({}, sc_SnowBallRolling)
    
    
    t.WeaponObject = Game:CreateSyncObject(Toybox.Bullet.SnowBallRolling, Vector.new(0,0,-1000))
    t.InvenIndex = 4
    
    t.OneTurnBulletCount = 1
    t.NowBulletCount = 0
    
    return t
end


--!---------------------------- Getter/Setter ------------------------------
--# 목적 : 
function sc_SnowBallRolling:GetBulletCount(player)
    return self.NowBulletCount
end




--!---------------------------- 아이템 획득/사용 처리 ------------------------------
--# 목적 : 아이템을 획득하면 인벤토리에 추가하는처리
--? 내용 : 아이템을 획득하는 처리
function sc_SnowBallRolling:GetItem()
    -- self.NowBulletCount = self.NowBulletCount + self.OneTurnBulletCount
    -- return self.NowBulletCount
end



--# 목적 : 아이템을 사용하는 처리
function sc_SnowBallRolling:UseItem(player)
    -- if (self.NowBulletCount) >= 1 then
    --     self.NowBulletCount = self.NowBulletCount - 1
    --     return true
    -- else
    --     self.NowBulletCount = 0
    --     player:GetCharacter():DetachObject(self.WeaponObject)
    -- end
end

--!---------------------------- 무기 시스템 처리 ------------------------------
--# 목적 : 기본 세팅 값
function sc_SnowBallRolling:Initialize(playerID)
    local player = Game:GetPlayer(playerID)
    local pos = player:GetCharacter().Location

    self.WeaponObject.Visible = false
    self.WeaponObject.Location = pos
end


--# 목적 : 초기화 검사
function sc_SnowBallRolling:CheckInitialize()
end


--# 목적 : 종료 시 처리
function sc_SnowBallRolling:FinishSystem()
end

return sc_SnowBallRolling;

