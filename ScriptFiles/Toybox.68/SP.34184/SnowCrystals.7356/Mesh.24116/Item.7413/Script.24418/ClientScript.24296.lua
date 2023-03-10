
local ProjectileModule = require(ScriptModule.DefaultModules.Projectile)

local Object = Script.Parent.Parent
local FX = Object.FX.Guage
local PID = 0


function Script:PreFire(playerID, bullet, targetPos, stPos, endPos, speed, force)
    -- toy.Track:PlayTransformTrack("FireAction", 0, 1)
    -- Firecheck = false
    
    -- Launcher(발사할 발사체, 시작지점, 끝지점, 발사체 속도, 곡사방향으로 줄 힘)
    ProjectileModule:Launcher(bullet, stPos, endPos, speed, force)
    bullet:LookAt(targetPos)
    PID = playerID
end

 

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

    wait(3)
    Game:DeleteFX(fx)
    
end
Object.HitCollider.Collision.OnBeginOverlapEvent:Connect(CollisionEvent)
