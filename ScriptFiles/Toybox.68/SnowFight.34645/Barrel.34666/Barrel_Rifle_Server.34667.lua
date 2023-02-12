
--! ------------------------------ Barrel_Rifle Server ------------------------------
local Item = Script.Parent.Parent 
local Barrel = Item.Barrel
local Base = Item.Base

local BulletDistance = Barrel.BulletDistance
local BulletSpeed = Barrel.BulletSpeed
local IsStraight = Barrel.IsStraight

local EquipPlayerID = nil
local NormalActionCoolTime = nil

local Utility = require(ScriptModule.DefaultModules.Utility)





--------------위치 값 조정할 때 어느정도 거리를 무시할지 설정---------------
local IgnoreDistance = 100



--! ------------------------------ 아이템 장착시 연결 함수 ------------------------------
--# ===== 아이템 장착
local function EquipItem(player)
    --NormalActionCoolTime = Item:GetActionCoolTime("Fire")
    EquipPlayerID = player:GetPlayerID()
end
Item.EquipEvent:Connect(EquipItem)


--# ===== 아이템 장착
local function UnEquipItem(player)
   EquipPlayerID = nil
end
Item.UnEquipEvent:Connect(UnEquipItem)





--! ------------------------------ 타겟 히트 시 데미지 입히는 함수 ------------------------------
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
--Item:ConnectEventFunction("CharacterHit", CharacterHit)

local function NPCHit(player, targetName, hitPosition, targetKey)
   if player:GetPlayerID() ~= EquipPlayerID then
       return  
   end
   Item:SendEventToClient(EquipPlayerID, "HitAim")
   Item:NPCHit(targetName, hitPosition, targetKey)
end
--Item:ConnectEventFunction("NPCHit", NPCHit)


local function StaticMeshHit(player, targetName, hitPosition, targetKey)
   if player:GetPlayerID() ~= EquipPlayerID then
       return  
   end
   
   Item:StaticMeshHit(targetName, hitPosition, targetKey)
end
--Item:ConnectEventFunction("StaticMeshHit", StaticMeshHit)





--! ------------------------------ 총알 생성 및 발사 함수 ------------------------------
function Item:FireBullet(player , playerLocation , playerDir)
    local playerID = player:GetPlayerID()    
    local playerCharacter = player:GetCharacter()

    local location = nil
    local speed = nil

    local hitList = player:LineTraceList(playerLocation + playerDir * IgnoreDistance, playerDir, BulletDistance)
    if #hitList >= 1 then
        local hitResult = hitList[1]
        
        if hitResult.HitObject ~= nil then
            local dis = Utility:VecDistance(playerLocation + playerDir * BulletDistance, hitResult.HitLocation)

            hitList = player:LineTraceList(playerLocation + playerDir * IgnoreDistance, playerDir, BulletDistance)
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
        
    else
        location = playerLocation + playerDir * BulletDistance
        speed = BulletSpeed
    end

     Item:SendEventToClient(playerID, "FireBullet", location, speed)
     --------------발사 시 다른 플레이어와의 FX 동기화----------------
     local players = Game:GetAllPlayer()
     for i = 1, #players do
         if players[i]:GetPlayerID() ~= EquipPlayerID then
             Item:SendEventToClient(players[i]:GetPlayerID(), "FireFX", location, speed)
         end     
     end
end





