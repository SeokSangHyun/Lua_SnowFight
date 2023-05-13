
--! 해당 클래스는 모든 객체에 공통으로 사용되는 클래스입니다.
--# 안에 있는 프로퍼티들은 
--? 내용
--    오브젝트래퍼런스, 타입을 설정함


sc_Icicle = {}
sc_Icicle.__index = sc_Icicle

--!---------------------------- 초기화 ------------------------------
--# 목적 : 생성시 정보 초기화
function sc_Icicle.new(object)
    local t = setmetatable({}, sc_Icicle)
    
    
    t.WeaponObject = object
    t.InvenIndex = 2
    
    t.OneTurnBulletCount = 30
    t.NowBulletCount = 0
    
    return t
end


--!---------------------------- Getter/Setter ------------------------------
--# 목적 : 
function sc_Icicle:GetBulletCount(player)
    return self.NowBulletCount
end




--!---------------------------- 아이템 획득/사용 처리 ------------------------------
--# 목적 : 아이템을 획득하면 인벤토리에 추가하는처리
--? 내용 : 아이템을 획득하는 처리
function sc_Icicle:GetItem()
    self.NowBulletCount = self.NowBulletCount + self.OneTurnBulletCount
    return self.NowBulletCount
end



--# 목적 : 아이템을 사용하는 처리
function sc_Icicle:UseItem(num)
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



local BulletDistance = 7000

--# 목적 : 서버 용 가상의 오브젝트 발사
function sc_Icicle:BulletSystem(player , playerLocation , playerDir)
    local IsStraitght = false
    local playerCharacter = player:GetCharacter()

    local hitList = player:LineTraceList(playerLocation + playerDir * 50, playerDir, 100)
    
    if #hitList >= 1 then
        local hitResult = hitList[1]
        local dis = nil
        if IsStraight then
            dis = Utility:VecDistance(playerCharacter.Location + playerCharacter.Transform:GetForward() * BulletDistance, hitResult.HitLocation)
        else
            dis = Utility:VecDistance(playerLocation + playerDir * BulletDistance, hitResult.HitLocation)
        end
        location = hitResult.HitLocation
        speed = (BulletDistance - dis) * (BulletSpeed / BulletDistance)
    
        local setHit = coroutine.create(function(player, object, locataion, waitTime)
            wait(waitTime)
            if not player:IsValid() or not object:IsValid() then
                return
            end
            
            if object:IsCharacter() then
                CharacterHit(player, object:GetPlayerID(), locataion)
            elseif object:IsNPC() then
                NPCHit(player, object.Name, locataion, object:GetKey())
            else
                StaticMeshHit(player, object.Name, locataion, object:GetKey())
            end
        end)
        
        coroutine.resume(setHit, player, hitResult.HitObject, hitResult.HitLocation, speed)
    end
end


--!---------------------------- 무기 시스템 처리 ------------------------------
--# 목적 : 기본 세팅 값
function sc_Icicle:Initialize()
end


--# 목적 : 초기화 검사
function sc_Icicle:CheckInitialize()
end


--# 목적 : 종료 시 처리
function sc_Icicle:FinishSystem()
end

return sc_Icicle;

