-- Barrel_Rifle Client --

local Item = Script.Parent.Parent
local Itemname = Item.Name

local Barrel = Item.Barrel
local Base = Item.Base

local AimUI = Barrel.AimUI
local HitAimUI = Barrel.HitAimUI

AimUI.Visible = false
HitAimUI.Visible = false


----------- FX Setting -----------
local FireFX = Base.SFX.Fire:GetChildList()
local CartridgeFX = Base.SFX.Cartridge:GetChildList()
local HitFX = Base.SFX.Hit:GetChildList()

local Bullet_Origin = Base.Bullet
local Projectile = Game:CreateObject(Base.Bullet, Vector.new(0, 0, 0))

local Muzzle = Base.SFX.Fire

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

local ProjectileModule = require(ScriptModule.DefaultModules.Projectile)

---------------------------아이템 장착시 연결 함수--------------------------------
local function EquipItem(Player)
    local player = LocalPlayer:GetRemotePlayer()
    if player ~= Player then
        return
    end
    
    NormalScale = AimUI.Aim.UIScale
    
    Equip = true
    if not IsStraight then
        AimUI.Visible = true
    end
end
Item.EquipEvent:Connect(EquipItem)

-------------------------아이템 해제시 연결 함수--------------------------------
local function UnEquipItem(Player)
   local player = LocalPlayer:GetRemotePlayer()
    if player ~= Player then
        return
    end
    
    Equip = false
    AimUI.Visible = false
end
Item.UnEquipEvent:Connect(UnEquipItem)

----------------------------------플레이어 Hit시 피해줄때 연출 이벤트---------------------
Item:ConnectEventFunction("HitAim", function()
   if Equip == false then
       return
   end

   if not IsStraight then
       HitAimUI.Visible = true
       wait(0.2)
       HitAimUI.Visible = false
   end
end)

----------------------------------발사 종료 시 에임 회복-------------------------------------
function Item:EndFire()
   IsFire = false
   while not IsFire do
       if Equip == false then
           return
       end
   
       AimCount = AimCount - AimRecover
       AimUI.Aim.UIScale = NormalScale + AimCount/MaxAim
       
       if AimCount <= 0 then
           AimCount = 0
           return
       end
       
       wait(0.1)
   end
end

------------------------총알 충돌 시 FX 출력----------------------------------
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


local function SetSperad()
   ------------------------------연사에 따른 Aim 벌어짐 계산----------------------------
   AddAim = DefaultAim + AimCount
   Spread = Vector.new(math.random(-AddAim , AddAim), math.random(-AddAim, AddAim), math.random(-AddAim, AddAim))   
end
SetSperad()

----------------------------------------총알 생성 및 발사 함수------------------------------------
local function FireBullet(playerLocation, speed)
   if Equip == false then
       return
   end
   
   IsFire = true

   local player = LocalPlayer:GetRemotePlayer()
      
   local bulletObject = nil  
   bulletObject = ProjectileModule:Rifle(Projectile, Muzzle.Location + Muzzle.Transform:GetForward() * 5,
                                         playerLocation + Spread + Muzzle.Transform:GetForward() * AddAim, speed)

   bulletObject:LookAt(playerLocation)
   bulletObject.PlayerID = player:GetPlayerID()

    if nil == bulletObject then
        return
    end

   local bulletTrail = bulletObject.Trail:GetChildList()

   if bulletTrail ~= nil then
       for i = 1, #bulletTrail do
       
           if bulletTrail[i]:IsFX() or bulletTrail[i]:IsSound() then
               bulletTrail[i]:Play()
           end
       end
   end
   
   bulletObject.Collision.OnCollisionEvent:Connect(BulletCollision)
   
   ------------------------------Aim이 퍼지는 부분을 UI로 연출--------------------------
   if MaxAim ~= 0 then
       AimUI.Aim.UIScale = NormalScale + AimCount/MaxAim
   end
   
   AimCount = AimCount + AimAdd
   if AimCount > MaxAim then
       AimCount = MaxAim       
   end

   if FireFX ~= nil then
       for i = 1, #FireFX do
           if FireFX[i]:IsFX() or FireFX[i]:IsSound() then
               FireFX[i]:Play()
           end
       end
   end

    if player:IsMyPlayer() then
        Camera:PlayCameraShake(ShakeTime, ShakeScale)    
    end
  
   if CartridgeFX ~= nil then
       wait(0.1)
       for i = 1, #CartridgeFX do
           if CartridgeFX[i]:IsFX() or CartridgeFX[i]:IsSound() then
               CartridgeFX[i]:Play()
           end
       end
   end

   SetSperad()
  
end
Item:ConnectEventFunction("FireBullet", FireBullet)

--------------------------------FX 동기화를 위한 함수----------------------------------------
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

--------------------------------FX 동기화를 위한 함수----------------------------------------
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

   if FireFX ~= nil then
       for i = 1, #FireFX do
           if FireFX[i]:IsFX() or FireFX[i]:IsSound() then
               FireFX[i]:Play()
           end
       end
   end

   if CartridgeFX ~= nil then
       wait(0.1)
       for i = 1, #CartridgeFX do
           if CartridgeFX[i]:IsFX() or CartridgeFX[i]:IsSound() then
               CartridgeFX[i]:Play()
           end
       end
   end
end
Item:ConnectEventFunction("FireFX", FireBulletFX)

