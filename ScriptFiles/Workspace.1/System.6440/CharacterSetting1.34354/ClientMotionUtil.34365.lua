
local inputRoot = Script.InputRoot
local animRoot = Script.Parent
local colRoot = Workspace.System.Temp
local nowInput = "Default"


--! ------------------------------ 조작 키 변경 ------------------------------
function ChangeControl(disActive, Active)
    Input:DeactiveGroup(disActive)
    Input:ActiveGroup(Active)
    --g_InputGroup[Active]()
end



--! ------------------------------ 애니메이션 변경 함수 ------------------------------
local function MontionChange(self, target)
        if target == nil or not target:IsCharacter() then;    return;    end;
        
        local text = self.Parent.SurfaceUI.Text:GetText()
        ChangeControl(nowInput .. "Input", text .. "Input")
        CameraUpdater:SetActiveGroup(text .. "Input")
        
        local remoteCharacter = LocalPlayer:GetRemotePlayer():GetCharacter()
        local AnimMachine = Game:GetAnimStateMachineSetting(text .. "CharacterAnim")
        local AnimSetting = animRoot:GetChild(text .. "CharacterSetting").AnimationSetting
        Game:ChangeCharacterAnimStateMachine(remoteCharacter, AnimMachine, AnimSetting) 
        
        nowInput = text

end

colRoot.normal.BoxCollider.Collision.OnBeginOverlapEvent:Connect(MontionChange)
colRoot.action.BoxCollider.Collision.OnBeginOverlapEvent:Connect(MontionChange)







