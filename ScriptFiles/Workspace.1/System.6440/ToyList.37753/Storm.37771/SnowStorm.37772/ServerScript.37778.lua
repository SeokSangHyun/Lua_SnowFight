
local Item = Script.Parent
local list_IntTonado = {}    -- 토네이도 안에 있는 캐릭터


local function TonadoEvent()

    for i = 1 , #list_IntTonado do
        local character = list_IntTonado[i]
        character.HP = character.HP - 5
    end

    Game:AddTimeEvent("TonadoEvent", 1.5, TonadoEvent)
end
Game:AddTimeEvent("TonadoEvent", 1.5, TonadoEvent)





local function BeginCollisionEvent(self, target)
    if target == nil or not target:IsCharacter() then;    return;    end;
    
    target:SetMaxSpeed(100)
    table.insert(list_IntTonado, target)
end
Item.HitCollider.Collision.OnBeginOverlapEvent:Connect(BeginCollisionEvent)




local function EndCollisionEvent(self, target)
    if target == nil or not target:IsCharacter() then;    return;    end;

    target:SetMaxSpeed(400)
    for i = 1 , #list_IntTonado do
        if list_IntTonado[i].Name == target.Name then
            table.remove(list_IntTonado, i)
            break
        end
    end
    
end
Item.HitCollider.Collision.OnEndOverlapEvent:Connect(EndCollisionEvent)





