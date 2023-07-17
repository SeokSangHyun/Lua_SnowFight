-- Effect_SingleHit Server--
local Item = Script.Parent.Parent
local Effect = Script.Parent
local Damage = Effect.Damage
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
