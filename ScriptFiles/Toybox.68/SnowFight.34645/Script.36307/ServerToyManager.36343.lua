
local toy = Script.Parent.Parent


local EquipPlayerID = 0
local IsFire = false





--!---------------------------- Getter/Setter ------------------------------
--[[
local function Script:SetEquipPlayerID(id)
    EquipPlayerID = id
end
]]--






--[[
----------------------------------충돌 객체가 캐릭터일 때 처리---------------------------------
function Item:CharacterHit(targetCharacter, hitPosition)
   if targetCharacter == nil or targetCharacter:IsDie() then
       return
   end

   local hitPlayerID = targetCharacter:GetPlayerID()
   local hitPlayer = targetCharacter:GetPlayer(hitPlayerID)
   
   if EquipPlayerID == nil or hitPlayerID == EquipPlayerID then
       return
   end
   
   local attackCharacter = Game:GetPlayerCharacter(EquipPlayerID)
   local attackPlayer = Game:GetPlayer(EquipPlayerID)
   
   --- Team Check ---
   if attackPlayer:GetTeamName() ~= "" and attackPlayer:GetTeamName() == hitPlayer:GetTeamName() then
       return
   end
   
   ---- knockback check ----
   if KnockBackPower > 0 and KnockBackCheck == false then
       KnockBack(attackCharacter, targetCharacter)
   end
   
   ---- Damage Check ---
   if attackCharacter:IsValidValue("ATK") and attackCharacter.ATK ~= 0 then
       targetCharacter.HP = targetCharacter.HP - Damage - object.ATK
   else
       targetCharacter.HP = targetCharacter.HP - Damage            
   end
   
   if Effect.IsAddKDPoint and targetCharacter.HP <= 0 then       
       local point = pcall(Global_PointKD_Add, attackCharacter, targetCharacter)
       
       if not point then
           print("No [Point_Add] functions in the system. please uncheck Effect.IsAddKdPoint")
       end
   end
end


------------------------------충돌 객체가 NPC일 때 처리-----------------------------------
function Item:NPCHit(targetName, hitPosition, targetKey)

end


------------------------------충돌 객체가 오브젝트일 때 처리-----------------------------------
function Item:StaticMeshHit(targetName, hitPosition, targetKey)

end
]]--







--! ------------------------------ 변수 선언 ------------------------------

--[[
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
]]--
 
 
 
 
 
--[[
 --! ------------------------------ Update 기능 ------------------------------
 local function Update(updateTime)
     if EquipPlayerID ~= nil and IsFire then
         local player = Game:GetPlayer(EquipPlayerID)
         Item:FireBullet(player, 1, FireLocation, FireDir)
         IsFire = false
     
         Item:SendEventToClient(EquipPlayerID, "SetBulletUI", Body.MaxBullet, Body.InitBullet)
     
         
     end
 end
 Body.OnUpdateEvent:Connect(Update)
]]--
 
 
 
 
 
 
 
 
 