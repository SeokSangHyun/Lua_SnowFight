--! 해당 클래스는 모든 객체에 공통으로 사용되는 클래스입니다.
--# 안에 있는 프로퍼티들은 

sStormModule = {}
sStormModule.__index = sStormModule



--!---------------------------- 초기화 ------------------------------
--# 목적 : 생성시 정보 초기화
function sStormModule.new(playerID, object)
    local t = setmetatable({}, sStormModule)
    
    t.WeaponObject = object
    t.playerID = playerID

    t.IsGain = false
    
    --t.WeaponObject.HitCollider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Ignore)
    return t
end





--!---------------------------- Getter/Setter ------------------------------
--# 목적 : 
function sStormModule:GetBulletCount()
    return self.BulletCount
end

function sStormModule:AddBullet()
    self.IsGain = true
end




--!---------------------------- 발사 시스템 ------------------------------
--# 목적 : 총알 발사 시스템
function sStormModule:BulletMove(dir)
    self.WeaponObject:TornadoMove(dir)
end







--!---------------------------- 무기 시스템 처리 ------------------------------
--# 목적 : 기본 세팅 값
function sStormModule:Initialize()
    local player = Game:GetPlayer(self.playerID)
    local pos = player:GetCharacter().Location+ Vector.new(0,0,50)

    self.WeaponObject.Location = pos
    self.WeaponObject.HitCollider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)
end



return sStormModule;

