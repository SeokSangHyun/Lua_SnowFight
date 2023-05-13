
local ProjectileModule = require(ScriptModule.DefaultModules.Projectile)

local Item = Script.Parent.Parent
local model = Item.Model
local FX = Toybox.FX.HitFX
local PID = 0




function Item:PreFire(playerID, bullet, targetPos, stPos, endPos, speed, force)
    -- toy.Track:PlayTransformTrack("FireAction", 0, 1)
    -- Firecheck = false
    
    -- Launcher(발사할 발사체, 시작지점, 끝지점, 발사체 속도, 곡사방향으로 줄 힘)
    --ProjectileModule:Launcher(bullet, stPos, endPos, speed, force)
    --bullet:LookAt(targetPos)
    --PID = playerID
end
-- local function FireBullet(playerLocation , speed)
--     if Equip == false then
--         return
--     end
    
--     IsFire = true
    
--     local player = LocalPlayer:GetRemotePlayer()
    
--     local bulletObject = ProjectileModule:Launcher(Projectile, Muzzle.Location + Muzzle.Transform:GetForward() * 5, 
--                                                    playerLocation, speed, Vector.new(0, 0, LaunchAngle))
 
--     bulletObject:LookAt(playerLocation)
--     bulletObject.PlayerID = player:GetPlayerID()
    
--     local bulletTrail = bulletObject.Trail:GetChildList()
 
--     if bulletTrail ~= nil then
--         for i = 1, #bulletTrail do
--             if bulletTrail[i]:IsFX() or bulletTrail[i]:IsSound() then
--                 bulletTrail[i]:Play()
--             end
--         end
--     end
     
--     bulletObject.Collision.OnCollisionEvent:Connect(BulletCollision)
 
--     if FireFX ~= nil then
--         for i = 1, #FireFX do
--             if FireFX[i]:IsFX() or FireFX[i]:IsSound() then
--                 FireFX[i]:Play()
--             end
--         end
--     end
 
--      if player:IsMyPlayer() then
--          Camera:PlayCameraShake(ShakeTime, ShakeScale)    
--      end
   
--     if CartridgeFX ~= nil then
--         wait(0.1)
--         for i = 1, #CartridgeFX do
--             if CartridgeFX[i]:IsFX() or CartridgeFX[i]:IsSound() then
--                 CartridgeFX[i]:Play()
--             end
--         end
--     end
--  end
--  Item:ConnectEventFunction("FireBullet", FireBullet)







local function CollisionEvent(self, target)
    if target == nil or not target:IsCharacter() then;    return;    end;

    if PID == 0 then;
        PID = target:GetPlayerID()
        return;
    end
    if PID ~= target:GetPlayerID() then
        if target:IsMyCharacter() then
            g_Player:HitMyPlayer(target, Object.ItemNum)
        end
    end
    
    local fx = Game:CreateFX(FX, self.Location)
    fx:Play()
    
    
    Game:DeleteObject(self)
end
model.HitCollider.Collision.OnBeginOverlapEvent:Connect(CollisionEvent)


-- local function BulletCollision(self, object)

--     if nil == self or self == object then
--         return
--     end

--    if HitFX ~= nil then
--        for i = 1, #HitFX do
--            if HitFX[i]:IsFX() then
--                Game:CreateFX(HitFX[i], self.Location)
--            elseif HitFX[i]:IsSound() then
--                Game:PlaySound(HitFX[i], self.Location)
--            end
--        end
--    end   
   
--    if object:IsCharacter() then
--        Item:SendEventToServer("CharacterHit", object:GetPlayerID(), self.Location)
       
--    elseif object:IsNPC() then       
--        Item:SendEventToServer("NPCHit", object.Name, self.Location, object:GetKey())       
       
--    elseif object:IsStaticMesh() then       
--        Item:SendEventToServer("StaticMeshHit", object.Name, self.Location, object:GetKey())
--    end

--    Game:DeleteObject(self)
-- end

