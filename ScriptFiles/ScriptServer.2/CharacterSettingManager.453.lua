local IsAutoRespawn = Script.IsAutoRespawn
local IsOrientRotation = Script.IsOrientRotation
local RespawnTime = Script.RespawnTime

------------------------------------------------------------------------------------------------------------
--캐릭터가 죽었을때 보이지 않게 하고 리스폰시키는 함수에요.
local function DeathCharacter(character) --OnDeathCharacter로 연결된 함수는 character 인자가 고정적으로 들어가요.
    if character:IsCharacter() == false then --캐릭터가 아니면
        return --아래의 로직을 처리하지 않도록 중단해요.
    end
   
    character.Visible = false --캐릭터를 안보이게 처리해요. 
    
    if Script.RespawnTime >= 0 then  --Script의 RespawnTime 변수 값이 0 이상이면
        if IsAutoRespawn then
            wait(Script.RespawnTime) --변수 값만큼 기다린 뒤
            character:GetPlayer():RespawnCharacter() --캐릭터를 리스폰 처리해요.
        end
    end
end
Game.OnDeathCharacter:Connect(DeathCharacter) --Game에 캐릭터가 죽으면 호출되는 함수를 연결해요.

------------------------------------------------------------------------------------------------------------
--캐릭터의 체력이 0 이하가 되면 사망되게 처리하는 함수에요.
local function SetHP(character) --OnSpawnCharacter로 연결된 함수는 character 인자가 고정적으로 들어가요.
    if character == nil then --캐릭터가 없으면
        return --아래의 로직을 처리하지 않도록 중단해요.
    end
   
    character:SetOrientRotationToMovement(IsOrientRotation)
    
    --캐릭터의 HP 변수가 변경 될 때 호출되는 함수를 연결해요.
    character:ConnectChangeEventFunction("HP", function(valueName, newValue)
        if character:IsDie() then --캐릭터가 죽은 상태.
            return --아래의 로직을 처리하지 않도록 중단해요.
        end
        
        if  character.HP > character.MaxHP then --캐릭터 체력이 MaxHP를 초과하면
            character.HP = character.MaxHP --캐릭터 체력을 MaxHP로 설정해요
        end
        
        if character.HP <= 0 then --캐릭터 체력이 0 이하이면
            character:GetPlayer():KillCharacter() --캐릭터를 사망 처리해요.
        end
    end)
end
Game.OnSpawnCharacter:Connect(SetHP) --Game에 캐릭터가 생성되면 호출되는 함수를 연결해요.
