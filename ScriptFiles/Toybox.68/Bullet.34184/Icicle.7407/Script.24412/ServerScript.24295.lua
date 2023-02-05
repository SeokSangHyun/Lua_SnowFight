
local Item = Script.Parent.Parent
Item.HitCollider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)






--! ------------------------------ 변수 선언 ------------------------------

local function CharacterHit(player, targetID, hitPosition)
    if player:GetPlayerID() ~= EquipPlayerID then
        return
    end
 
    local targetCharacter = Game:GetPlayer(targetID):GetCharacter()
    
    if targetCharacter:IsValidValue("ForceBuff") and targetCharacter.ForceBuff ~= nil then
        return
    end
    
    Item:SendEventToClient(EquipPlayerID, "HitAim")
    Item:CharacterHit(targetCharacter, hitPosition)
 end
 Item:ConnectEventFunction("CharacterHit", CharacterHit)
 
 
 local function NPCHit(player, targetName, hitPosition, targetKey)
    if player:GetPlayerID() ~= EquipPlayerID then
        return  
    end
    
    Item:SendEventToClient(EquipPlayerID, "HitAim")
    Item:NPCHit(targetName, hitPosition, targetKey)
 end
 Item:ConnectEventFunction("NPCHit", NPCHit)
 
 
 local function StaticMeshHit(player, targetName, hitPosition, targetKey)
    if player:GetPlayerID() ~= EquipPlayerID then
        return  
    end
    
    Item:StaticMeshHit(targetName, hitPosition, targetKey)
 end
 Item:ConnectEventFunction("StaticMeshHit", StaticMeshHit)
 


--! ------------------------------ 총알 생성 및 발사 함수 ------------------------------
 function Item:FireBullet(player , selfLoction , selfDir)
--* 여기부터
    local hitList = player:LineTraceList(selfLoction + selfDir * 50, selfDir, 100)
    local hitResult = hitList[1]
    
        if hitResult.HitObject ~= nil then
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





--! ------------------------------ a ------------------------------
local function Update(updateTime)
    if EquipPlayerID ~= nil and IsFire then
        Item:SendEventToClient(EquipPlayerID, "PreFire", true)
        
        if Delay then
            DelayCheck = DelayCheck + updateTime
            if DelayCheck >= InputDelay then
                Delay = false
                FirstDelay = false
                Body.InitBullet = Body.InitBullet - 1
                if EquipPlayerID ~= nil then
                    Item:SendEventToClient(EquipPlayerID, "SetBulletUI", Body.InitBullet)
                    local player = Game:GetPlayer(EquipPlayerID)
                    Item:FireBullet(player, FireLocation, FireDir)
                    Count = Count + 1
                    IsFire = false
                    DelayCheck = 0
                end
            end
        else
            if EquipPlayerID ~= nil then
                Body.InitBullet = Body.InitBullet - 1
                Item:SendEventToClient(EquipPlayerID, "SetBulletUI", Body.InitBullet)
                local player = Game:GetPlayer(EquipPlayerID)
                Item:FireBullet(player, FireLocation, FireDir)
                Count = Count + 1
                IsFire = false
            end
        end
    end
end
Item.OnUpdateEvent:Connect(Update)






