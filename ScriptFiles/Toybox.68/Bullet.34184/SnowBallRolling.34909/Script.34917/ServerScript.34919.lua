
local Item = Script.Parent.Parent
local model = Item.Model
Item.Model.HitCollider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)




function Item:RunPlay(rotX, rotY, rotZ)
    local moveSpeed = 10
    local offset = -360

    model.Track:AddLocalRot("Rot", Vector.new(rotX*offset, rotY*offset, rotZ*offset), moveSpeed, false)
    model.Track:PlayTransformTrack("Rot", Enum.TransformPlayType.Repeat, InfinityPlay)
end

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
 




local function Update(updateTime)
    --print("1")
end
Item.OnUpdateEvent:Connect(Update)



--! ------------------------------ 충돌처리 ------------------------------
local function CollisionEvent(self, target)
    if target == nil or not target:IsCharacter() then;    return;    end;

    -- if PID == 0 then;
    --     PID = target:GetPlayerID()
    --     return;
    -- end
    -- if PID ~= target:GetPlayerID() then
    --     if target:IsMyCharacter() then
    --         g_Player:HitMyPlayer(target, Object.ItemNum)
    --     end
    -- end
    
    -- local fx = Game:CreateFX(FX, self.Location)
    -- fx:Play()
    
    
    -- Game:DeleteObject(self)
    print(target)
    --self.Visible=false
end
Item.Model.HitCollider.Collision.OnBeginOverlapEvent:Connect(CollisionEvent)



