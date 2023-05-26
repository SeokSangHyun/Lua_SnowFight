
--! ------------------------------ 변수 선언 ------------------------------
g_ConnectGate = nil

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
Game:ConnectEventFunction("CharacterStateChange_sToc", CharacterStateChange)



--[[
function CharacterMoveToLocation(targetPos)
    local character = LocalPlayer:GetRemotePlayer():GetCharacter()
    character.Location = targetPos
end
]]--
Runcheck = false
function ReadySleighMoveLoop()
    local targetPos = Vector.new(0,0,0)
    if g_ConnectGate.Index <= 6 then;    targetPos = CaveColliders[1].Cave.Trigger.Location;
    else;    targetPos = CaveColliders[2].Cave.Trigger.Location;    end;

    Runcheck = true
    while Runcheck do
        local myPos = LocalPlayer:GetRemotePlayer():GetCharacter().Location
        local dir = targetPos - myPos
        dir:Normalize()
        
        LocalPlayer:MoveDir(dir, 1)
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






--!---------------------------- Setter/Getter ------------------------------
function SetConnectGate()   ;   end;
function GetConnectGate()   ;   end;
function RegistConnectGate(index)
    g_ConnectGate = GameRegistChair[index]
    
    Toggle_StardardPopup(true)
    Input:SetJoystickControlVisibility(0, false)
    LocalPlayer:SetEnableMovementControl(false)
end;
Game:ConnectEventFunction("RegistConnectGate_sToc", RegistConnectGate)




--!---------------------------- UI ------------------------------
--# -----목적:등록 가능 상태
function ResetChairUI(index)
    local ui = GameRegistChair[index].SurfaceUI
    ui.NonReady.Visible = false
    ui.Ready.Visible = true
    ui.None.Visible = false
end
Game:ConnectEventFunction("ResetChairUI_sToc", ResetChairUI)

--# -----목적:대기 상태
function WaitChairUI(index)
    local ui = GameRegistChair[index].SurfaceUI
    ui.NonReady.Visible = false
    ui.Ready.Visible = false
    ui.None.Visible = true
end
Game:ConnectEventFunction("WaitChairUI_sToc", WaitChairUI)

--# -----목적:체어 상태 변경 없음
function RejectChairUI(index)
    local ui = GameRegistChair[index].SurfaceUI
    ui.NonReady.Visible = true
    ui.Ready.Visible = false
    ui.None.Visible = false
end
Game:ConnectEventFunction("RejectChairUI_sToc", RejectChairUI)





--!---------------------------- 상황 별 처리 ------------------------------
--# -----목적 : 로비 들어왔을 때 의자 상태 초기화
function Init_ReadyChairState()
    g_ConnectGate = nil
    
    local cntChair = #GameRegistChair
    for i = 1 , cntChair do
        ResetChairUI(i)
    end
end


--# -----목적 : 게임 상태로 갔을 때 처리
function Init_InGameChairState()
    g_ConnectGate = nil
    
    local cntChair = #GameRegistChair
    for i = 1 , cntChair do
        RejectChairUI(i)
    end
    
    LocalPlayer:SetEnableMovementControl(true)
end




