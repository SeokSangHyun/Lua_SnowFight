-- Effect_AreaHit Server--

local Item = Script.Parent.Parent 
local Effect = Script.Parent 
local Damage = Effect.Damage
local EffectRadius = Effect.EffectRadius
local EquipPlayerID = nil
local KnockBackCheck = false
local KnockBackPower = Effect.KnockBackPower

---------------------------아이템 장착시 연결 함수--------------------------------
local function EquipItem(player)
   EquipPlayerID = player:GetPlayerID()
   KnockBackCheck = false
end
Item.EquipEvent:Connect(EquipItem)

-----------------------------------아이템 장착해제 시 처리함수------------------------------------
local function UnEquipItem(player)
   EquipPlayerID = nil
end
Item.UnEquipEvent:Connect(UnEquipItem)


-----------------------------------넉백 처리함수------------------------------------
local function KnockBack(character, target)
    KnockBackCheck = true
       
    local selfLocation = character.Location
    local targetLocation = 0
    
    wait(0.03)
           
    if target:IsCharacter() then
        targetLocation = target.Location       
        target:AddForce(Vector.new((targetLocation.X - selfLocation.X) * KnockBackPower, (targetLocation.Y - selfLocation.Y) * KnockBackPower, KnockBackPower * 0.5))
           
    elseif target:IsNPC() then

    elseif target:IsStaticMesh() then
          
    end
       
    wait(0.2)
    KnockBackCheck = false
end


-----------------------------------충돌 지점에서 범위내의 데미지 처리----------------------------
local function RadiusDamage(hitPosition)
   local areaObject = Game:GetObjectList(hitPosition, EffectRadius)
   local check = false
   for i = 1, #areaObject do
   
       ----------------- 캐릭터 피격 시 처리 -----------------
       if areaObject[i] ~= nil and areaObject[i]:IsCharacter() then
           local hitPlayerID = areaObject[i]:GetPlayerID()
           
           if hitPlayerID ~= EquipPlayerID then       
               local hitPlayer = Game:GetPlayer(hitPlayerID)     
               local targetCharacter = hitPlayer:GetCharacter()
               local attackCharacter = Game:GetPlayer(EquipPlayerID):GetCharacter()
               local attackPlayer = Game:GetPlayer(EquipPlayerID)
               
               --- Team Check ---
               if attackPlayer:GetTeamName() ~= "" and attackPlayer:GetTeamName() == hitPlayer:GetTeamName() then
                   return
               end               
           
               ---- Damage check ----
               if not targetCharacter:IsDie()  then
                   if attackCharacter:IsValidValue("ATK") and attackCharacter.ATK ~= 0 then
                       areaObject[i].HP = areaObject[i].HP - Damage - object.ATK
                   else
                       areaObject[i].HP = areaObject[i].HP - Damage
                   end
                   
                   if Effect.IsAddKDPoint and areaObject[i].HP <= 0 then
                       local point = pcall(Global_PointKD_Add, attackCharacter, targetCharacter)
                              
                       if not point then
                           print("No [Point_Add] functions in the system. please uncheck Effect.IsAddKdPoint")
                       end
                   end
               end
               
                ---- knockback check ----
                if KnockBackPower > 0 and KnockBackCheck == false then
                    KnockBack(attackCharacter, targetCharacter)
                end           
           end
           check = true
           
       ----------------- NPC 피격 시 처리 -----------------
       elseif areaObject[i] ~= nil and areaObject[i]:IsNPC() then
           --check = true
           
       ----------------- 스태틱메쉬 피격 시 처리 ----------------- 
       elseif areaObject[i] ~= nil and areaObject[i]:IsStaticMeshHit() then
           --check = true
           
       end 
   end
   
   if check then
       Game:SendEventToClient(EquipPlayerID, "HitAim")
   end
   
end

----------------------------------충돌 객체가 캐릭터일 때 처리---------------------------------
function Item:CharacterHit(targetCharacter, hitPosition)   
   RadiusDamage(hitPosition)
end


------------------------------충돌 객체가 NPC일 때 처리-----------------------------------
function Item:NPCHit(targetName, hitPosition, targetKey)
    RadiusDamage(hitPosition)
end

------------------------------충돌 객체가 오브젝트일 때 처리-----------------------------------
function Item:StaticMeshHit(targetName, hitPosition, targetKey)
   RadiusDamage(hitPosition)
end




