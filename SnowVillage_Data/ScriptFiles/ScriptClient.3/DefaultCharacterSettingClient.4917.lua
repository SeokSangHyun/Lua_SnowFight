------------------------------------------------------------------------------------------------------------
--캐릭터가 죽었을때 HUD를 지우고 DeathParticle을 생성하는 스크립트에요.
------------------------------------------------------------------------------------------------------------

local DeathEffect = Toybox.DeathParticle:GetChildList() --Toybox에 있는 DeathParticle의 자식 오브젝트(GetChildList)를 모두 DeathEffect 변수에 할당해요.



------------------------------------------------------------------------------------------------------------
--캐릭터가 죽었을때 HUD를 지우고, DeathParticle을 생성하는 함수에요.
local function PlayerDeath(character) --OnDeathCharacter로 연결된 함수는 character 인자가 고정적으로 들어가요.
    if character:IsCharacter() == false then --캐릭터가 아니면
        return --아래의 로직을 처리하지 않도록 중단해요.
    end
   
    character:RemovePlayerAllHUD() --캐릭터에 추가된 HUD를 모두 삭제해요.
   
    for i = 1, #DeathEffect do --DeathEffect 변수에 할당된 오브젝트의 수만큼 반복문을 실행해요.
        if DeathEffect[i]:IsFX() then --인덱스(i)에 해당하는 오브젝트가 이펙트이면
            character:CreateFX(DeathEffect[i], Enum.Bone.Body) --캐릭터의 Body 부위에 이펙트를 생성해요.
        end 
    end
end
Game.OnDeathCharacter:Connect(PlayerDeath) --Game에 캐릭터가 죽으면 호출되는 함수를 연결해요.
