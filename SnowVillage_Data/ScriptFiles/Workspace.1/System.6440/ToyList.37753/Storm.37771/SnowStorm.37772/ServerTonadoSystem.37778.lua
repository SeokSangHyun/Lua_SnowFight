
local Item = Script.Parent
local list_IntTonado = {}    -- 토네이도 안에 있는 캐릭터
local OwnerPlayerID = nil


function Item:GetOwnerPlayer();    return OwnerPlayerID;    end;
function Item:SetOwnerPlayer(playerID)
    OwnerPlayerID = playerID
end



--!---------------------------- <Tonado 데미지> ------------------------------
--# -----요약 : 토네이도에 안에 있는 데미지 시스템
function Item:TonadoEvent()
    if OwnerPlayerID ~= nil then
        local player = Game:GetPlayer(OwnerPlayerID)
        for i = 1 , #list_IntTonado do
            local character = list_IntTonado[i]
            GameManager:HitCharacter(player, character:GetPlayerID(), Item.BulletDamage)
            --character.HP = character.HP - Item.BulletDamage
        end
    end

    Game:AddTimeEvent("TonadoEvent", 1.5, function() Item:TonadoEvent() end)
end
Game:AddTimeEvent("TonadoEvent", 1.5, function() Item:TonadoEvent() end)





--!---------------------------- <Tonado 충돌> ------------------------------
--# -----요약 : 토네이도에 들어왔을 때
local function BeginCollisionEvent(self, target)
    if target == nil or not target:IsCharacter() then;    return;    end;
    
    local playerID = target:GetPlayerID()
    if OwnerPlayerID == playerID then;    return;    end;
    
    target:SetMaxSpeed(250)
    table.insert(list_IntTonado, target)
end
Item.HitCollider.Collision.OnBeginOverlapEvent:Connect(BeginCollisionEvent)



--# -----요약 : 토네이도에서 나갔을 때
local function EndCollisionEvent(self, target)
    if target == nil or not target:IsCharacter() then;    return;    end;
    
    local playerID = target:GetPlayerID()
    if OwnerPlayerID == playerID then;    return;    end;

    target:SetMaxSpeed(400)
    for i = 1 , #list_IntTonado do
        if list_IntTonado[i].Name == target.Name then
            table.remove(list_IntTonado, i)
            break
        end
    end
    
end
Item.HitCollider.Collision.OnEndOverlapEvent:Connect(EndCollisionEvent)





