------------------------------------------------------------------------------------------------------------
--캐릭터의 체력이 바뀔때 체력바 UI를 갱신하는 스크립트에요.
------------------------------------------------------------------------------------------------------------

local HPUI = HUD.HP_UI 
local MaxHP = nil --HUD에 있는 HP_UI 오브젝트를 HPUI 변수에 할당해요.



----------------------------------------------------------------------------------------------------------
--캐릭터의 체력이 변경됐을때 호출되는 함수에요.
local function UpdateHP(ownerObject, value)
   if not ownerObject:IsCharacter() or not ownerObject:IsMyCharacter() then --캐릭터가 아니거나 내 캐릭터가 아니면
       return --아래의 로직을 처리하지 않도록 중단해요.
   end

   if HPUI == nil or MaxHP == nil then --HPUI가 없거나 MaxHP가 없으면
       return --아래의 로직을 처리하지 않도록 중단해요.
   end
   
   HPUI.HPBar:SetPercent(value/MaxHP) --캐릭터의 남은 체력을 계산해서 체력바 게이지를 갱신해요.
end



----------------------------------------------------------------------------------------------------------
--캐릭터의 최대체력이 변경됐을때 호출되는 함수에요.
local function UpdateMaxHP(ownerObject, value)
   if not ownerObject:IsCharacter() or not ownerObject:IsMyCharacter() then --캐릭터가 아니거나 내 캐릭터가 아니면
       return --아래의 로직을 처리하지 않도록 중단해요.
   end
   
   MaxHP = value --최대 체력을 변경해요.    
end



----------------------------------------------------------------------------------------------------------
--캐릭터 스폰시 체력바를 갱신하고 이벤트 함수를 연결하는 함수에요.
local function SpawnCharacter(character) --OnSpawnCharacter로 연결된 함수는 character 인자가 고정적으로 들어가요.
   if not character:IsMyCharacter() then
       return --아래의 로직을 처리하지 않도록 중단해요.
   end

   HPUI.HPBar:SetPercent(1) --캐릭터의 체력바 게이지를 100%으로 갱신해요.
   --HPUI.HPBar:SetFillColor(Color.new(0, 255, 0, 255)) --캐릭터의 체력바 게이지 색상을 설정해요.
   
   character:ConnectChangeEventFunction("HP", UpdateHP) --캐릭터의 HP 변수가 변경 될 때 호출되는 함수를 연결해요.
   character:ConnectChangeEventFunction("MaxHP", UpdateMaxHP) --캐릭터의 MaxHP 변수가 변경 될 때 호출되는 함수를 연결해요.
end
Game.OnSpawnCharacter:Connect(SpawnCharacter) --Game에 캐릭터가 생성되면 호출되는 함수를 연결해요.

