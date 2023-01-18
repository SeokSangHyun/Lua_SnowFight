
--! ------------------------------ 변수 선언 ------------------------------
--# 썰매 준비 변수
local CaveColliders = Workspace.World.Lobby.Trigger.Slide:GetChildList()
local InGameSpawnList = Workspace.World.Lobby.Trigger.SpawnPoint:GetChildList()
local ArraySpawn = { }
local CharacterSetting = Toybox.CharacterSetting




--! ------------------------------ 변수 선언 ------------------------------
function CharacterStateChange( anim )
    local character = LocalPlayer:GetRemotePlayer():GetCharacter()
    character:ChangeAnimState(anim, 0.0001)
end




--[[
function CharacterMoveToLocation(targetPos)
    local character = LocalPlayer:GetRemotePlayer():GetCharacter()
    character.Location = targetPos
end
]]--
Runcheck = true
function ReadySleighMoveLoop(player)
    Runcheck = true
    while Runcheck do
                LocalPlayer:MoveForward(1)
                wait(1/30)
            end
    
end



--! ------------------------------ 스폰 포인트 처리 ------------------------------
local function CollisionCaveEvent(self, target)
    if target == nil or not target:IsCharacter() then;    return;    end;

    local playerID = target:GetPlayerID()
    Runcheck = false
end


--# 목적 : 충돌 함수 세팅
for i = 1 , #CaveColliders do
    local cave = CaveColliders[i].Cave.Trigger
    cave.Collision.OnCollisionEvent:Connect(CollisionCaveEvent)
end



