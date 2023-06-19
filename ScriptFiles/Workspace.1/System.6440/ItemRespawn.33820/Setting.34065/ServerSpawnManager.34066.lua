--! ------------------------------  ------------------------------
local Root = Script.Parent.Parent
local Config = Root.Setting
local RespawnList = Root.SpawnPoint:GetChildList()

local SpawnItem = Config.SpawnItemRoot:GetChildList()

--! ------------------------------ 스폰 변수 ------------------------------
local Limit = 99999



--! ------------------------------ 스폰너 초기화/세팅 ------------------------------
--# 목적 : 스포너 설정 및 코인 시스템 초기화
local function InitSpawner()
    for i, s in pairs(RespawnList) do
-- 충돌 설정
         s.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)
    
-- 스포너로 바인딩
        local spawner = Game:AddObjectSpawner(s, Enum.ObjectSelectType.Random, Config.SpawnTimeSec, 1);

-- 스폰 방식 설정
        for j = 1 , #SpawnItem do
            local si =  SpawnItem[j]
            spawner:AddSpawnObject(si, si.SpawnRate, Limit);
            spawner:SetObjectSpawnType_Scale(si.Scale);
        end
    end
    
end
InitSpawner()



