------------------------------------------------------------------------------------------------------------
--캐릭터가 죽었을때 리스폰 관련 처리를 설정하는 스크립트에요.
------------------------------------------------------------------------------------------------------------

local Object = Script.Parent --Script의 부모 오브젝트(BaseSetting)를 Object 변수에 할당해요.



------------------------------------------------------------------------------------------------------------
--클라이언트와 동기화되는 값을 추가해요.
Object:AddReplicateValue("MaxHP", Script.MaxHP, Enum.ReplicateType.Changed, 0) --캐릭터의 MaxHP 변수가 클라이언트와 동기화되도록 추가해요.
Object:AddReplicateValue("HP", Script.MaxHP, Enum.ReplicateType.Changed, 0) --캐릭터의 HP 변수가 클라이언트와 동기화되도록 추가해요.
