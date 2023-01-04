------------------------------------------------------------------------------------------------------------
-- 총알 같은 투사체 오브젝트를 직사나 곡사로 이동시킬 때 사용할 수 있는 모듈 스크립트에요.
-- ClientScript에서 사용할 수 있어요.
------------------------------------------------------------------------------------------------------------



local Projectile = {}



-- 직선방향으로 발사체를 발사하는 함수입니다.
-- Rifle(발사할 발사체, 시작지점, 끝지점, 발사체 속도)
function Projectile:Rifle(bullet, startPos, endPos, bulletSpeed)
    local bulletObject = Game:CreateObject(bullet, startPos)
    
    bulletObject.Track:AddWorldMove("Fire", endPos, bulletSpeed, true)
    bulletObject.Track:PlayTransformTrack("Fire", 0, 1)
    
    local deletebullet = coroutine.create(function(bullet)
        wait(bulletSpeed + 0.2)
        if bullet:IsValid() then
            Game:DeleteObject(bullet)
        end
    end)
    coroutine.resume(deletebullet, bulletObject)
    
    return bulletObject
end



-- 곡사방향으로 발사체를 발사하는 함수입니다.
-- Launcher(발사할 발사체, 시작지점, 끝지점, 발사체 속도, 곡사방향으로 줄 힘)
function Projectile:Launcher(bullet, startPos, endPos, bulletSpeed, force)
    local bulletObject = Game:CreateObject(bullet, startPos)
    
    bulletObject.Physics:SetSimulatePhysics(true)
    bulletObject.Track:AddWorldMove("Fire", endPos, bulletSpeed, true)
    bulletObject.Track:PlayTransformTrack("Fire", 0, 1)
    bulletObject.Physics:AddForce(force)
    
    local deletebullet = coroutine.create(function (bullet)
        wait(bulletSpeed + 0.2)
        if bullet:IsValid() then
            Game:DeleteObject(bullet)
        end
    end)
    coroutine.resume(deletebullet, bulletObject)
    
    return bulletObject
end



-- 직선방향으로 관통하는 발사체를 발사하는 함수입니다.
-- Piercing(발사할 발사체, 시작지점, 끝지점, 발사체 속도)
function Projectile:Piercing(bullet, startPos, endPos, bulletSpeed)
    local bulletObject = Game:CreateObject(bullet, startPos)
        
    bulletObject.Track:AddWorldMove("Fire", endPos, bulletSpeed, false)
    bulletObject.Track:PlayTransformTrack("Fire", 0, 1)
        
    local deletebullet = coroutine.create(function(bullet)
        wait(bulletSpeed + 0.2)
        if bullet:IsValid() then
            Game:DeleteObject(bullet)
        end
    end)
    coroutine.resume(deletebullet, bulletObject)
        
    return bulletObject
end



-- 일정 범위로 발사체를 동시 발사할 때 발사체끼리 충돌하지 않도록 설정된 직선 발사 함수입니다.
-- Shotgun(발사할 발사체, 시작지점, 끝지점, 발사체 속도, 발사채의 고유 컬리전 이름름
function Projectile:Shotgun(bullet, startPos, endPos, bulletSpeed, bulletCollisionName)
    local bulletObject = Game:CreateObject(bullet, startPos)
    
    --bulletObject.Collision:SetCollisionType(bulletCollisionName)
    --bulletObject.Collision:SetUserCollisionTypeResponse(bulletCollisionName, Enum.CollisionResponse.Overlap)
    
    bulletObject.Track:AddWorldMove("Fire", endPos, bulletSpeed, true)
    bulletObject.Track:PlayTransformTrack("Fire", 0, 1)
    
    local deletebullet = coroutine.create(function(bullet)
        wait(bulletSpeed + 0.2)
        if bullet:IsValid() then
            Game:DeleteObject(bullet)
        end
    end)
    coroutine.resume(deletebullet, bulletObject)
    
    return bulletObject
end

return Projectile

