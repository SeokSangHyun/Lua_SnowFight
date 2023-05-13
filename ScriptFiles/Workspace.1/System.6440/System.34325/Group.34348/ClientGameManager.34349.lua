local Root = Script.Parent.Parent
local nowInput = "Default"


--! ------------------------------  ------------------------------
function ChangeControl(disActive, Active)
    Input:DeactiveGroup(disActive)
    Input:ActiveGroup(Active)
    --g_InputGroup[Active]()
end



local function CollisionEvent(self, target)
    if target == nil or not target:IsCharacter() then;    return;    end;
    
    local text = self.Parent.SurfaceUI.Text:GetText()
    ChangeControl(nowInput .. "Input", text .. "Input")
    CameraUpdater:SetActiveGroup(text .. "Input")
    
    local remoteCharacter = LocalPlayer:GetRemotePlayer():GetCharacter()
    local AnimMachine = Game:GetAnimStateMachineSetting(text .. "CharacterAnim")
    local AnimSetting = Root.CharacterSetting:GetChild(text .. "CharacterSetting").AnimationSetting
    Game:ChangeCharacterAnimStateMachine(remoteCharacter, AnimMachine, AnimSetting) 
    
    nowInput = text
end

Workspace.System.Collider.normal.BoxCollider.Collision.OnBeginOverlapEvent:Connect(CollisionEvent)
Workspace.System.Collider.action.BoxCollider.Collision.OnBeginOverlapEvent:Connect(CollisionEvent)


--Game:ChangeCharacterAnimStateMachine(remoteCharacter, Game:GetAnimStateMachineSetting("ArcherCharacterAnim"), CharacterSetting.AnimationSetting) 
--character:ChangeAnimState("BowShotEnd")




local IsActionKey = false

function SetActionKey(act)    IsActionKey = act;    end;
function GetActionKey()    return IsActionKey;    end;



function BulletFire_1()
    local player = LocalPlayer:GetRemotePlayer()

    local targetItem = player:GetEquipItem("EquipSlot_1") --장착 중인 킥보드 받아옴


    local obj = Game:CreateObject(Workspace.Cube, targetItem.Location)
    local cor = coroutine.create(function()
        local forward = targetItem.Transform:GetForward()
        while true do
            if obj == nil then;
                return;
            end;
        
            obj.Location = obj.Location + forward
            wait(0.05)
        end
        print("del")
    end)
    
    coroutine.resume(cor)
end
Game:ConnectEventFunction("BulletFire_1", BulletFire_1)


