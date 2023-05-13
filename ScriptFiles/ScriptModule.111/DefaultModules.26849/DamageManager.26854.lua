------------------------------------------------------------------------------------------------------------
-- 대상 캐릭터에게 데미지를 줄 때 사용할 수 있는 모듈 스크립트에요.
------------------------------------------------------------------------------------------------------------



local DamageManager = {}



-- 특정 캐릭터에게 데미지를 입혀주는 함수입니다.
-- 캐릭터의 HP가 0 이하가되면 자동으로 Kill하여 줍니다.
-- ApplyDamage(데미지를 입힐 캐릭터, 데미지)
function DamageManager:ApplyDamage(character, damage)
   character.HP = character.HP - damage
   
   if character.HP <= 0 then
       character:GetPlayer():KillCharacter()
       character:GetPlayer():RespawnCharacter()
   end
   
   if character.HP >= character.MaxHP then
       character.HP = character.MaxHP
   end
end

return DamageManager
