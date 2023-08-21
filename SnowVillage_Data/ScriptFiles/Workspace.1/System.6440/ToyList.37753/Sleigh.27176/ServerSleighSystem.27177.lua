
--! ------------------------------ 변수 선언 ------------------------------
--# 썰매 준비 변수
local CaveColliders = Workspace.World.Lobby.Trigger.Slide:GetChildList()
local InGameSpawnList = Workspace.World.Lobby.Trigger.SpawnPoint:GetChildList()
local ArraySpawn = { }

-- 대기 열
g_ConnectGate = {}
for i = 1 , #GameRegistChair do
    table.insert(g_ConnectGate, 0)
end

--#
local spawn_maxcnt = math.floor( ((#GameRegistChair/#InGameSpawnList)+0.5) )
local IsConrifmRegist = false






--! ------------------------------  ------------------------------
--# 
function ReadySettingSleigh()
    ArraySpawn = { }
    IsConrifmRegist = false
end




--! ------------------------------ 썰매준비 등록 ------------------------------


--# -----목적:의자의 상태를 확인하는 함수
function CheckChairState(player, index)
    local playerID = player:GetPlayerID()
    
    --print(playerID .. type(playerID))
    if g_ConnectGate[index] == 0 then
        --입장 가능
        g_ConnectGate[index] = playerID
        Game:SendEventToClient(playerID, "RegistConnectGate_sToc", index)
        Game:BroadcastEvent("WaitChairUI_sToc", index)
    elseif g_ConnectGate[index] == -1 then
        --dlqwkd dkdP akrrl
    else
        --입장 불가능
        --print("")
    end
end 
Game:ConnectEventFunction("CheckChairState_cTos", CheckChairState)







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
    
    readysit.WaitPos.SitPos:AttachCharacter(character, Enum.AttachPoint.Top)
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
    readysit.WaitPos.SitPos:DetachAllCharacter(Vector.new(-300, 0, 50))
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
    
    readysit.WaitPos.SitPos:DetachAllCharacter(Vector.new(0, 0, 0))
    character:SetMaxSpeed(DEF_SLEIGH_SPEED)
    
    AddReadyPlayerList(player)
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
    local player = Game:GetPlayer(playerID)
    local respawn_index = math.random(1, #InGameSpawnList)

    if #ArraySpawn[respawn_index] > spawn_maxcnt then
        print(respawn_index)
        RegistSpawnList(playerID)
    else
        table.insert(ArraySpawn[respawn_index], playerID)
        PlayerData:SetPlayerState(player, "WaitReady")

        local character = Game:GetPlayer(playerID):GetCharacter()
        character.Location = InGameSpawnList[respawn_index].Location
        
        
        PlayerControl:SetMoveControl(player, false)
        StateAction(playerID)
    end
end


local function CollisionCaveEvent(self, target)
    if target == nil or not target:IsCharacter() then;    return;    end;
    local playerID = target:GetPlayerID()

    if not CheckPlayerState(playerID, "WaitReady") then;    return;   end;

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




--!---------------------------- UI ------------------------------
--# -----목적:등록 가능 상태
function ResetChair(player, index)
    g_ConnectGate[index] = 0
    Game:BroadcastEvent("ResetChairUI_sToc", index)
end
Game:ConnectEventFunction("ResetChair_cTos", ResetChair)

--# -----목적:대기 상태
function WaitChair(player, index)
    Game:BroadcastEvent("WaitChairUI_sToc", index)
end
Game:ConnectEventFunction("WaitChair_cTos", WaitChair)

--# -----목적:체어 상태 변경 없음
function RejectChair(player, index)
    Game:BroadcastEvent("RejectChairUI_sToc", index)
end
Game:ConnectEventFunction("RejectChair_cTos", RejectChair)





--!---------------------------- 상황 별 처리 ------------------------------
--# -----목적 : 로비 들어왔을 때 의자 상태 초기화
function Init_ReadyChairState()
    for i = 1 , #g_ConnectGate do
        g_ConnectGate[i] = 0
    end
    Workspace.World.Lobby.Trigger.ReadyLine.Enable = true
    Workspace.World.Lobby.Trigger.ReadyLine.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Block)
end


--# -----목적 : 게임 상태로 갔을 때 처리
function Init_InGameChairState()
    for i = 1 , #g_ConnectGate do
        if g_ConnectGate[i] ~= nil and g_ConnectGate[i] ~= -1 and g_ConnectGate[i] ~= 0 then
            local player = Game:GetPlayer(g_ConnectGate[i])
            PlayerData:SetPlayerState(player, "None")
            PlayerControl:CharacterStateChange( player, "Stand" )
            CharacterOutToLocation(player)
        end
        g_ConnectGate[i] = -1
    end
    Workspace.World.Lobby.Trigger.ReadyLine.Enable = false
    Workspace.World.Lobby.Trigger.ReadyLine.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)
end






