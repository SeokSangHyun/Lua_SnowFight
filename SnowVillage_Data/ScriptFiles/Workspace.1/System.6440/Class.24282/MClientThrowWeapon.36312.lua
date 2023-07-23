--! 해당 클래스는 모든 객체에 공통으로 사용되는 클래스입니다.
--# 안에 있는 프로퍼티들은 

cTrowModule = {}
cTrowModule.__index = cTrowModule

local ProjectileModule = require(ScriptModule.DefaultModules.Projectile)



--!---------------------------- 초기화 ------------------------------
--# 목적 : 생성시 정보 초기화
function cTrowModule.new(object)
    local t = setmetatable({}, cTrowModule)
    
    t.WeaponObject = object

    t.Damage = object.BulletDamage
    t.Distance = object.BulletDistance
    t.Speed = object.BulletSpeed
    t.Angle = object.Angle

    t.BulletCount = 10
    t.BulletMaxCount = DEF_MAX_BulletCount

    return t
end





--!---------------------------- 무기 시스템 처리 ------------------------------
--# 목적 : 기본 세팅 값
function cTrowModule:Initialize()
    self.BulletCount = 10
end






--!---------------------------- Getter/Setter ------------------------------
--# 목적 : 
function cTrowModule:AddBullet(num)
    if self.BulletCount >= self.BulletMaxCount then;    return; end;
    self.BulletCount = self.BulletCount + num
end

function cTrowModule:GetBulletCount()
    return self.BulletCount
end

function cTrowModule:CheckFire()
    if self.BulletCount <= 0 then;  return false;
    else;   return true;    end;
end






--!---------------------------- 발사 시스템 ------------------------------
--# ----- 목적 : 총알 발사 시스템
function cTrowModule:FireObject(playerID, pos, forward)
    local character = Game:GetRemotePlayerCharacter(playerID)
    local player = character:GetPlayer()

    local stPos = pos
    local endPos = Vector.new( pos.X + forward.X * self.Distance
    , pos.Y + forward.Y * self.Distance
    , pos.Z - 100)

-- 총알 발사 로직
    local mybullet = ProjectileModule:Launcher(self.WeaponObject, stPos, endPos, self.Speed, Vector.new(0,0,self.Angle))
    mybullet:LookAt(endPos)
    
    
    local myID = LocalPlayer:GetRemotePlayer():GetPlayerID()
    if playerID == myID then
        mybullet.HitCollider.Collision.OnBeginOverlapEvent:Connect(function(self, target)
            if target == nil or not target:IsCharacter() or target:IsMyCharacter() then;  return;        end;
                print(target)
            
                local targetID = target:GetPlayerID()
                local bulletIndex = self.Parent.BulletIndex
                
                Game:SendEventToServer("HitCharacter_cTos", targetID, g_BulletList[bulletIndex].BulletDamage)
                Game:DeleteObject(self)
        end)

-- 총알 감소
        self.BulletCount = self.BulletCount - 1
        BulletCountUpdate(player.BulletIndex, self.BulletCount)
    end
end







return cTrowModule;





