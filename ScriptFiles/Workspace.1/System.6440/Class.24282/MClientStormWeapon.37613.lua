--! 해당 클래스는 모든 객체에 공통으로 사용되는 클래스입니다.
--# 안에 있는 프로퍼티들은 

cStormModule = {}
cStormModule.__index = cStormModule



--!---------------------------- 초기화 ------------------------------
--# 목적 : 생성시 정보 초기화
function cStormModule.new(object)
    local t = setmetatable({}, cStormModule)
    
    t.WeaponObject = object

    t.Damage = object.BulletDamage
    t.ColdOffset = object.ColdOffset
    t.Speed = object.BulletSpeed
    t.Angle = object.Angle

    t.IsGain = false
    t.IsMode = false


    return t
end





--!---------------------------- 무기 시스템 처리 ------------------------------
--# 목적 : 기본 세팅 값
function cStormModule:Initialize()
end






--!---------------------------- Getter/Setter ------------------------------
--# 목적 : 
function cStormModule:AddBullet(num)
    self.IsGain = true
end


function cStormModule:GetBulletCount()
end


function cStormModule:CheckStormMode()
    return self.IsMode
end


function cStormModule:ActiveStormMode(state)
    if state then
        ChangeCamera(self.WeaponObject.Camera, nil)
    else
        ChangeCamera(Workspace.MainCamera, nil)
    end

    self.IsMode = state
end






--!---------------------------- 발사 시스템 ------------------------------
--# ----- 목적 : 총알 발사 시스템
function cStormModule:FireObject(playerID, posX, posY, posZ, forX, forY)

end







return cStormModule;





