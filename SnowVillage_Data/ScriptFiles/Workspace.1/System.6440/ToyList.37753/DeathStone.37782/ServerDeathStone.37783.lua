
g_DeathStone = {}
local StoneIndex = 1
local StonrParent = Script.Parent.StoneParent


--! ------------------------------ <DeathStone> ------------------------------
--# -----요약 : 모든 죽음 오브젝트 (눈싸람) 삭제
function ResetDeathStone()
    for i = 1 , #g_DeathStone do
        Game:DeleteObject(g_DeathStone[i])
    end
    
    g_DeathStone = {}
end


--# -----요약 : 게임 시작시 게임 오브젝트 생성
function AddDeathStone()
    local obj = Game:CreateSyncObject(Toybox.DeathStone, Vector.new(0,0,0))
    obj.Enable = false
    obj.Parent = StonrParent
    table.insert(g_DeathStone, obj)
end


--# -----요약 : 게임 중 캐릭터 사망시
function CreateDeathStone(player)
    player.DeathStoneIndex = StoneIndex

    local pos = player:GetCharacter().Location
    g_DeathStone[StoneIndex].Location = pos
    g_DeathStone[StoneIndex].Enable = true

    player.DeathStoneCount = 5
    player.DeathStoneIndex = StoneIndex

    Game:SendEventToClient(player:GetPlayerID(), "CreateDeathStone", player.DeathStoneIndex)
    StoneIndex = StoneIndex + 1
    if #g_DeathStone >= StoneIndex then
        StoneIndex = 1
    end
    
    --토네이도 처리
    Init_Tonado()
end


--# -----요약 : 사망한 캐릭터 부활 시
function RemoveDeathStone(player)
    Game:SendEventToClient(player:GetPlayerID(), "FrozingBroken_sToc")
    Game:SendEventToClient(player:GetPlayerID(), "RemoveDeathStone", player.DeathStoneIndex)
    g_DeathStone[player.DeathStoneIndex].Location = Vector.new(0,0,0)
    g_DeathStone[player.DeathStoneIndex].Enable = false
    

    
    DepOwner(player:GetPlayerID())
    player.DeathStoneCount = 0
    player.DeathStoneIndex = 0
end


--# -----요약 : 사망한 캐릭터 부활 동작 함수
function ActDeathStone(player)
    local index = player.DeathStoneIndex
    local cnt = player.DeathStoneCount
    
    g_DeathStone[index]:FrozenUpdate()
    
    player.DeathStoneCount = cnt - 1
    if cnt <= 0 then
        RemoveDeathStone(player)
    end
end


