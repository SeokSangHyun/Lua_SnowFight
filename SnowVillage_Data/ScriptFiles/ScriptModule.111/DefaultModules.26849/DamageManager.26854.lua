------------------------------------------------------------------------------------------------------------
-- 대상 캐릭터에게 데미지를 줄 때 사용할 수 있는 모듈 스크립트에요.
------------------------------------------------------------------------------------------------------------



local DamageManager = {}



-- 특정 캐릭터에게 데미지를 입혀주는 함수입니다.
-- 캐릭터의 HP가 0 이하가되면 자동으로 Kill하여 줍니다.
-- ApplyDamage(데미지를 입힐 캐릭터, 데미지)
-- true : alive
function DamageManager:ApplyDamage(character, damage)
    local HP = character.HP
    local IsDamage = true
    HP = HP - damage
    
    if HP >= character.MaxHP then
        HP = character.MaxHP
    end
    
    if HP <= 0 then
        --character:GetPlayer():KillCharacter()
        --character:GetPlayer():RespawnCharacter()
        local player = character:GetPlayer()
        FrozingCharacter(player)
        HP = character.MaxHP
        
        IsDamage = false
    end
    
   character.HP = HP
   return IsDamage
end

return DamageManager
