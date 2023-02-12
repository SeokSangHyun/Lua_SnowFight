------------------------------------------------------------------------------------------------------------
--게임의 기본 설정을 처리하는 스크립트에요.
------------------------------------------------------------------------------------------------------------

local IsSpawn = Script.IsSpawn
local InventorySize_Col = Script.InventorySize_Col
local InventorySize_Row = Script.InventorySize_Row
local QuickSlotCount = Script.QuickSlotCount

Game:SetSpawnType(Enum.SpawnType.UseSpawnPoint) --게임의 스폰 타입을 지정해요.
Game:InitInventorySize(InventorySize_Col, InventorySize_Row) --인벤토리의 사이즈를 설정해요. 
Game:InitQuickSlotCount(QuickSlotCount) --퀵 슬롯의 개수를 설정해요.
Game:SetUsingCharacterSetting(Toybox.CharacterSetting) --게임에서 사용할 캐릭터를 설정해요.

local DefaultSpawnPos = Vector.new(0, 0, 200) --설정된 스폰포인트가 없을때 사용할 스폰 위치에요.
Game:SetDefaultSpawnPos(DefaultSpawnPos) --설정된 스폰포인트가 없을때 지정한 위치에서 스폰되도록 설정해요.



------------------------------------------------------------------------------------------------------------
--플레이어가 입장하면 캐릭터를 스폰 처리하는 함수에요.
local function EnterPlayer(player) --OnEnterPlayer로 연결된 함수는 player 인자가 고정적으로 들어가요.
    if player == nil then --플레이어가 없으면
        return --아래의 로직을 처리하지 않도록 중단해요.
    end
    
    if IsSpawn then
        player:RespawnCharacter() --캐릭터를 리스폰 처리해요.
    end
end
Game.OnEnterPlayer:Connect(EnterPlayer) --Game에 플레이어가 입장하면 호출되는 함수를 연결해요.




local function SpawnCharacter(character) --OnSpawnCharacter로 연결된 함수는 character 인자가 고정적으로 들어가요.
    local player = character:GetPlayer()
    local playerID = player:GetPlayerID()
    
    wait(1)
    InitPlayer(player)
end
Game.OnSpawnCharacter:Connect(SpawnCharacter) --Game에 캐릭터가 생성되면 호출되는 함수를 연결해요.

