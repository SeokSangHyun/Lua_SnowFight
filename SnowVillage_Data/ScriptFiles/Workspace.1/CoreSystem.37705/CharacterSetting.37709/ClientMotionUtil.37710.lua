
CharacterUtil = Script.Parent



local nowInput = "Default"



local inputRoot = Script.InputRoot
local animRoot = Script.Parent
--local colRoot = Workspace.System.Temp


local nowObject = nil
local AnimFrame = 0


--! ------------------------------ 조작 키 변경 ------------------------------
function ChangeControl(disActive, Active)
    Input:DeactiveGroup(disActive)
    Input:ActiveGroup(Active)
    --g_InputGroup[Active]()
end



--! ------------------------------ 애니메이션 변경 함수 ------------------------------
-- Default , Normal , Action
function CharacterUtil:MontionChange(strChangeInput)
        local remoteCharacter = LocalPlayer:GetRemotePlayer():GetCharacter()

        --# ===== 조작 설정
        ChangeControl(nowInput .. "Input", strChangeInput .. "Input")
        CameraUpdater:SetActiveGroup(strChangeInput .. "Input")
        
        --# ===== 애니메이션 설정
        local AnimMachine = Game:GetAnimStateMachineSetting(strChangeInput .. "CharacterAnim")
        local AnimSetting = animRoot:GetChild(strChangeInput .. "CharacterSetting").AnimationSetting
        Game:ChangeCharacterAnimStateMachine(remoteCharacter, AnimMachine, AnimSetting) 
        nowObject = AnimSetting

        nowInput = strChangeInput
end
CharacterUtil:ConnectEventFunction("MontionChange", function(strChangeInput) CharacterUtil:MontionChange(strChangeInput) end)



local function MontionChangeCol(self, target)
        if target == nil or not target:IsCharacter() or not target:IsMyCharacter() then;    return;    end;
        
        local text = self.Parent.SurfaceUI.Text:GetText()
        local remoteCharacter = LocalPlayer:GetRemotePlayer():GetCharacter()

        --# ===== 조작 설정
        ChangeControl(nowInput .. "Input", text .. "Input")
        CameraUpdater:SetActiveGroup(text .. "Input")
        
        --# ===== 애니메이션 설정
        local AnimMachine = Game:GetAnimStateMachineSetting(text .. "CharacterAnim")
        local AnimSetting = animRoot:GetChild(text .. "CharacterSetting").AnimationSetting
        Game:ChangeCharacterAnimStateMachine(remoteCharacter, AnimMachine, AnimSetting) 
        nowObject = AnimSetting

        nowInput = text
end

--[[
colRoot.normal.BoxCollider.Collision.OnBeginOverlapEvent:Connect(MontionChange)
colRoot.action.BoxCollider.Collision.OnBeginOverlapEvent:Connect(MontionChange)
]]--




function CheckActionState(AnimName)

    if AnimName == nowObject.Throw then
        AnimFrame = AnimFrame + 1
        --print(AnimFrame)
        if AnimFrame == 12 then
            RequestFire()
        end

    end
    --던지기 모션 체크

    return true
end


function ChangeAnimation(str_prevAnim, str_nowAnim)
    if str_prevAnim ~= str_nowAnim or GetActionKey() then
        SetActionKey(false)
        AnimFrame = 0
        return true
    end

    return false
end










