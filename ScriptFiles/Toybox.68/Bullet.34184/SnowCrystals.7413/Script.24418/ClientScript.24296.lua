
local ProjectileModule = require(ScriptModule.DefaultModules.Projectile)

local Item = Script.Parent.Parent
local FX = Toybox.FX.HitFX


--발사한 유저의 정보
local PID = 0
local bulletIndex = 0


function Item:Initialize(playerID, bIndex)
    PID = playerID
    bulletIndex = bIndex
end


function Item:BulletObjectFire(playerID, bullet, targetPos, stPos, endPos, speed, force)
    -- toy.Track:PlayTransformTrack("FireAction", 0, 1)
    -- Firecheck = false
    
    -- Launcher(발사할 발사체, 시작지점, 끝지점, 발사체 속도, 곡사방향으로 줄 힘)
    local mybullet = ProjectileModule:Launcher(bullet, stPos, endPos, speed, force)
    mybullet:LookAt(targetPos)
    mybullet:Initialize()
end





local function CollisionEvent(self, target)
    if target == nil or not target:IsCharacter() then;    return;    end;

    local targetID = target:GetPlayerID()
    local myID = LocalPlayer:GetRemotePlayer()


    if PID == 0 or targetID == myID or target:IsMyCharacter() then;
        PID = targetID
        return;
    end
    
    g_Player:HitMyPlayer(target, bulletIndex)
    local fx = Game:CreateFX(FX, self.Location)
    fx:Play()
    
    Game:DeleteObject(self)
end
Item.HitCollider.Collision.OnBeginOverlapEvent:Connect(CollisionEvent)

-- local function CollisionEvent(self, target)
--     if target == nil or not target:IsCharacter() then;    return;    end;

--     if PID == 0 then;
--         PID = target:GetPlayerID()
--         return;
--     end
--     if PID ~= target:GetPlayerID() then
--         -- if target:IsMyCharacter() then
--         --     g_Player:HitMyPlayer(target, Object.ItemNum)
--         -- end
--     end
    
--     local fx = Game:CreateFX(FX, self.Location)
--     fx:Play()

--     Game:DeleteObject(self)
-- end
-- Item.HitCollider.Collision.OnBeginOverlapEvent:Connect(CollisionEvent)


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

