
--! ------------------------------ Barrel_Rifle Client ------------------------------
local Item = Script.Parent.Parent
local Itemname = Item.Name

local Barrel = Item.Barrel
local Base = Item.Base


----------- Spec Setting -----------
local BulletDistance = Barrel.BulletDistance
local BulletSpeed = Barrel.BulletSpeed
local ShakeTime = Barrel.ShakeTime
local ShakeScale = Barrel.ShakeScale
local DefaultAim = Barrel.DefaultAim
local MaxAim = Barrel.MaxAim
local AimAdd = Barrel.AimAdd
local AimRecover = Barrel.AimRecover
local IsStraight = Barrel.IsStraight

local AimCount = 0

local Equip = false
local IsFire = false
local NormalScale = nil

local AddAim = 0
local Spread = 0

--local ProjectileModule = require(ScriptModule.DefaultModules.Projectile)







--! ------------------------------ 연출용 ------------------------------
--# ===== 에임 연출용
Item:ConnectEventFunction("HitAim", function()

end)


--# ===== 발사 종료 시 에임 회복
function Item:EndFire()
    
end


--# ===== 총알 충돌 시 FX 출력
local function BulletCollision(self, object)
   if nil == self or self == object or IsCollision then
        return
    end                
   if HitFX ~= nil then
       for i = 1, #HitFX do
           if HitFX[i]:IsFX() then
               Game:CreateFX(HitFX[i], self.Location)
           elseif HitFX[i]:IsSound() then
               Game:PlaySound(HitFX[i], self.Location)
           end
       end
   end
   
   if nil ~= self then
      Game:DeleteObject(self)
   end
end


--# ===== 연사에 따른 Aim 벌어짐 계산
local function SetSperad()
   AddAim = DefaultAim + AimCount
   Spread = Vector.new(math.random(-AddAim , AddAim), math.random(-AddAim, AddAim), math.random(-AddAim, AddAim))   
end
--SetSperad()





--! ------------------------------ 총알 생성 및 발사 함수 ------------------------------
-- local function FireBullet(playerLocation, speed)
--    if Equip == false then
--        return
--    end
   
--    IsFire = true

--    local player = LocalPlayer:GetRemotePlayer()
      
--    local bulletObject = nil  
--    bulletObject = ProjectileModule:Rifle(Projectile, Muzzle.Location + Muzzle.Transform:GetForward() * 5,
--                                          playerLocation + Spread + Muzzle.Transform:GetForward() * AddAim, speed)

--    bulletObject:LookAt(playerLocation)
--    bulletObject.PlayerID = player:GetPlayerID()

--     if nil == bulletObject then
--         return
--     end

--    local bulletTrail = bulletObject.Trail:GetChildList()

--    if bulletTrail ~= nil then
--        for i = 1, #bulletTrail do
       
--            if bulletTrail[i]:IsFX() or bulletTrail[i]:IsSound() then
--                bulletTrail[i]:Play()
--            end
--        end
--    end
   
--    bulletObject.Collision.OnCollisionEvent:Connect(BulletCollision)
   
--    ------------------------------Aim이 퍼지는 부분을 UI로 연출--------------------------
--    if MaxAim ~= 0 then
--        --AimUI.Aim.UIScale = NormalScale + AimCount/MaxAim
--    end
   
--    AimCount = AimCount + AimAdd
--    if AimCount > MaxAim then
--        AimCount = MaxAim       
--    end


--     if player:IsMyPlayer() then
--         Camera:PlayCameraShake(ShakeTime, ShakeScale)    
--     end


--    SetSperad()
  
-- end
-- Item:ConnectEventFunction("FireBullet", FireBullet)





--! ------------------------------ FX  함수 ------------------------------
--# ===== FX 동기화를 위한 함수
local function FXBulletCollision(self, object)
   if nil == self or self == object then
        return
    end

   if HitFX ~= nil then
       for i = 1, #HitFX do
           if HitFX[i]:IsFX() then
               Game:CreateFX(HitFX[i], self.Location)
           elseif HitFX[i]:IsSound() then
               Game:PlaySound(HitFX[i], self.Location)
           end
       end
   end
    
    Game:DeleteObject(self)
end


--# ===== FX 동기화를 위한 함수
local function FireBulletFX(playerLocation, speed)
  
   bulletObject = ProjectileModule:Rifle(Projectile, Muzzle.Location + Muzzle.Transform:GetForward() * 5,
                                         playerLocation + Spread + Muzzle.Transform:GetForward() * AddAim, speed)
   bulletObject:LookAt(playerLocation)
   local bulletTrail = bulletObject.Trail:GetChildList()

   if bulletTrail ~= nil then
       for i = 1, #bulletTrail do
           if bulletTrail[i]:IsFX() or bulletTrail[i]:IsSound() then
               bulletTrail[i]:Play()
           end
       end
   end
   
   bulletObject.Collision.OnCollisionEvent:Connect(FXBulletCollision)


end
Item:ConnectEventFunction("FireFX", FireBulletFX)





