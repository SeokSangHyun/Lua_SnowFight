
--! ------------------------------ 변수 선언 ------------------------------
--# 썰매 준비 변수
local CaveColliders = Workspace.World.Lobby.Trigger.Slide:GetChildList()
local InGameSpawnList = Workspace.World.Lobby.Trigger.SpawnPoint:GetChildList()
local ArraySpawn = { }

--#
local spawn_maxcnt = math.floor( ((#GameRegistChair/#InGameSpawnList)+0.5) )
local IsConrifmRegist = false


--# 
function ReadySettingSleigh()
    ArraySpawn = { }
    IsConrifmRegist = false
end



--! ------------------------------ 썰매준비 등록 ------------------------------
--# 
function CharacterMoveToLocation(player, targetPos)
    local playerID = player:GetPlayerID()
    local character = player:GetCharacter()
    character.Location = targetPos
    
    
    --
    local readysit = nil
    for i = 1 , #g_ConnectGate do
        if g_ConnectGate[i] == playerID then
            readysit = GameRegistChair[i]
            break
        end
    end
    
    readysit.WaitPos:AttachCharacter(character, Enum.AttachPoint.Top)
end
Game:ConnectEventFunction("CharacterMoveToLocation", CharacterMoveToLocation)


--Game:SendEventToServer("CharacterMoveToLocation")
function CharacterOutToLocation(player)
    local playerID = player:GetPlayerID()
    local character = player:GetCharacter()
    local outPos = Vector.new(0,0,0)

    local readysit = nil
    for i = 1 , #g_ConnectGate do
        if g_ConnectGate[i] == playerID then
            g_ConnectGate[i] = 0
            readysit = GameRegistChair[i]
            break
        end
    end
    
    --outPos = readysit.WaitPos.Location + Vector.new(-150, 0, 200)
    readysit.WaitPos:DetachAllCharacter(Vector.new(-300, 0, 50))
end
Game:ConnectEventFunction("CharacterOutToLocation", CharacterOutToLocation)



function ReadySleighAction(player)
    local playerID = player:GetPlayerID()
    local character = player:GetCharacter()
    local outPos = Vector.new(0,0,0)

    local readysit = nil
    for i = 1 , #g_ConnectGate do
        if g_ConnectGate[i] == playerID then
            g_ConnectGate[i] = 0
            readysit = GameRegistChair[i]
            break
        end
    end
    
    readysit.WaitPos:DetachAllCharacter(Vector.new(0, 0, 0))
    character:SetMaxSpeed(1000)
    
end
Game:ConnectEventFunction("ReadySleighAction", ReadySleighAction)




--! ------------------------------ 스폰 포인트 처리 ------------------------------
-- local InGameSpawnGroup = Game:AddSpawnPointGroup("InGameSpawnList") --이름으로 스폰 그룹을 등록해요.
-- for i = 1, #InGameSpawnList do
--    local spawner = Game:AddSpawnPointAtGroup("InGameSpawnList", InGameSpawnList[i]) --스폰 그룹에서 사용할 스폰포인트를 등록해요.
--    spawner:SetSpawnType(Enum.PointSpawnType.Area, 0) --스폰포인트의 작동방식을 설정해요.
-- end
-- Game:SetUsingSpawnPointGroup(InGameSpawnGroup) --게임에 적용할 스폰 그룹을 설정해요.
-- Game:SetSpawnType(Enum.SpawnType.UseSpawnGroup) --게임의 스폰타입을 설정해요.


local function RegistSpawnList(playerID)
    local respawn_index = math.random(1, #InGameSpawnList)

    if #ArraySpawn[respawn_index] > spawn_maxcnt then
        print(respawn_index)
        RegistSpawnList(playerID)
    else
        table.insert(ArraySpawn[respawn_index], playerID)
        IsConrifmRegist = true

        wait(1)
        local character = Game:GetPlayer(playerID):GetCharacter()
        character.Location = InGameSpawnList[respawn_index].Location

        wait(1)
        character:AddForce( Vector.new(0, 0, 50*5000) )
    end
end


local function CollisionCaveEvent(self, target)
    if target == nil or not target:IsCharacter() then;    return;    end;
    if IsConrifmRegist then;    return; end;

    local playerID = target:GetPlayerID()
    IsConrifmRegist = false

    RegistSpawnList(playerID)

end


--# 목적 : 충돌 함수 세팅
for i = 1 , #CaveColliders do
    local cave = CaveColliders[i].Cave.Trigger
    cave.Collision.OnCollisionEvent:Connect(CollisionCaveEvent)
end

for i = 1 , #InGameSpawnList do
    table.insert(ArraySpawn, {})
end



