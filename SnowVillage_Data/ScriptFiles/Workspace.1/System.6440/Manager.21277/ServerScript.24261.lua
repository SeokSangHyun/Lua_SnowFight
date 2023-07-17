
local vec = Vector.new(750, 230, 500)
--Game:CreateSyncObject(Toybox.SpawnItem.SnowBall, vec)






--# 목적 : 서버 용 가상의 오브젝트 발사
function BulletSystem(player , playerLocation , playerDir)
    local IsStraitght = false
    local playerCharacter = player:GetCharacter()

    local hitList = player:LineTraceList(playerLocation + playerDir * 50, playerDir, self.BulletDistance)
    if #hitList >= 1 then
        local hitResult = hitList[1]
        local dis = nil
        if IsStraight then
            dis = Utility:VecDistance(playerCharacter.Location + playerCharacter.Transform:GetForward() * self.BulletDistance, hitResult.HitLocation)
        else
            dis = Utility:VecDistance(playerLocation + playerDir * self.BulletDistance, hitResult.HitLocation)
        end
        location = hitResult.HitLocation
        speed = (self.BulletDistance - dis) * (self.BulletSpeed / self.BulletDistance)
    
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
                --여기 오류
                StaticMeshHit(player, object.Name, locataion, object:GetKey())
            end
        end)
        
        coroutine.resume(setHit, player, hitResult.HitObject, hitResult.HitLocation, speed)
    end
end



